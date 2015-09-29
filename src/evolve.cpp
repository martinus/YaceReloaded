#include <evolve.h>

#include <exmars/exhaust.h>
#include <exmars/insn.h>
#include <FitnessEvaluator.h>

#include <FastRng.h>

#include <string>
#include <iostream>
#include <conio.h>

#include <Windows.h>
#ifdef max
#undef max
#endif


void rngIns(FastRng& rng, std::vector<int>& ins, u32_t coresize, size_t idx) {
    switch (idx) {
    case 0:
        // no LDP and no STP
        ins[0] = rng(EX_LDP);
        break;

    case 1:
        ins[1] = rng(EX_MODIFIER_END);
        break;

    case 2:
        ins[2] = rng(EX_ADDRMODE_END);
        break;

    case 3:
        ins[3] = rng(coresize);
        break;

    case 4:
        ins[4] = rng(EX_ADDRMODE_END);
        break;

    case 5:
        ins[5] = rng(coresize);
        break;

    default:
        throw std::runtime_error("rngIns");
    }
}

std::vector<int> rngIns(FastRng& rng, u32_t coresize) {
    std::vector<int> ins(6);
    for (size_t i = 0; i < ins.size(); ++i) {
        rngIns(rng, ins, coresize, i);
    }
    return ins;
}

void evolve(FastRng& rng, 
    const WarriorAry& wSrc, 
    WarriorAry& wTgt, 
    u32_t coresize, 
    u32_t maxWarriorLength)
{
    bool hasChanged = false;
    while (!hasChanged) {
        switch (rng(11)) {
        case 0:
            // insert random instruction
            if (wSrc.ins.size() < maxWarriorLength) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size() + 1));
                wTgt.ins.insert(wTgt.ins.begin() + pos, rngIns(rng, coresize));
                if (pos <= wTgt.startOffset) {
                    ++wTgt.startOffset;
                }
                hasChanged = true;
            }
            break;

        case 1:
        case 7:
            // remove random instruction
            if (wSrc.ins.size() > 1) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size()));
                wTgt.ins.erase(wTgt.ins.begin() + pos);
                if (pos < wTgt.startOffset || wTgt.startOffset == wTgt.ins.size()) {
                    --wTgt.startOffset;
                }
                hasChanged = true;
            }
            break;

        case 2:
            // swap random instructions
            if (wSrc.ins.size() > 2) {
                unsigned pos1 = rng(static_cast<unsigned>(wSrc.ins.size()));
                unsigned pos2;
                do {
                    pos2 = rng(static_cast<unsigned>(wSrc.ins.size()));
                } while (pos1 == pos2);

                wTgt = wSrc;
                std::swap(wTgt.ins[pos1], wTgt.ins[pos2]);
                hasChanged = true;
            }
            break;

        case 3:
            // change single pos
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                rngIns(rng, wTgt.ins[pos], coresize, rng(6));
                hasChanged = true;
            }
            break;

        case 4:
            // change whole instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                wTgt.ins[pos] = rngIns(rng, coresize);
                hasChanged = true;
            }
            break;

        case 5:
            // change start
            if (wSrc.ins.size() > 1) {
                size_t pos;
                do {
                    pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                } while (pos == wSrc.startOffset);
                wTgt = wSrc;
                wTgt.startOffset = pos;
                hasChanged = true;
            }
            break;

        case 6:
            // duplicate an instruction
            if (wSrc.ins.size() < maxWarriorLength && !wSrc.ins.empty()) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size()));
                auto tmp = wTgt.ins[pos];
                wTgt.ins.insert(wTgt.ins.begin() + pos, tmp);
                if (pos < wTgt.startOffset) {
                    ++wTgt.startOffset;
                }
                hasChanged = true;
            }
            break;

        case 8:
            // swap numbers within instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                std::swap(wTgt.ins[pos][3], wTgt.ins[pos][5]);
                hasChanged = true;
            }
            break;

        case 9:
            // swap address mode within instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                std::swap(wTgt.ins[pos][2], wTgt.ins[pos][4]);
                hasChanged = true;
            }
            break;

        case 10:
            // increase/decrease a number up to 8 
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                int idx = 3;
                if (rng(2)) {
                    idx = 5;
                }

                // -8 to +8, without 0
                int change = rng(16) - 8;
                if (change >= 0) {
                    ++change;
                }
                change += wTgt.ins[pos][idx];

                // handle over and underflow
                if (change < 0) {
                    wTgt.ins[pos][idx] = change + coresize;
                } else if (change >= static_cast<int>(coresize)) {
                    wTgt.ins[pos][idx] = change - coresize;
                } else {
                    wTgt.ins[pos][idx] = change;
                }

                hasChanged = true;
            }
            break;


        default:
            std::cout << "error!" << std::endl;
            throw std::runtime_error("evolve switch");
        }
    }
}

std::string print(const WarriorAry& w, u32_t coresize);

void printStatus(size_t iter, const WarriorAry& wBest, mars_t* mars, double acceptanceRate, double beta) {
    std::cout.precision(15);
    std::cout
        << std::endl
        << ";redcode-94" << std::endl
        << ";name YaceReloaded " << wBest.iteration << ": " << wBest.fitness << std::endl
        << ";author Martin Ankerl" << std::endl
        << ";strategy Markov Chain Monte Carlo sampling" << std::endl
        << ";stratgey with Metropolis-Hastings Algorithms" << std::endl
        << ";strategy " << acceptanceRate << " acceptance rate" << std::endl
        << ";strategy " << iter << " current iteration" << std::endl
        << ";strategy " << beta << " beta" << std::endl;

    std::cout << print(wBest, mars->coresize);
}


int evolve(int argc, char** argv) {
    // TODO use protobuf configuration instead of argc and argv
    mars_t* mars = init(argc, argv);
    std::vector<std::string> warriorFiles;
    auto* w = mars->warriorNames;
    while (w) {
        warriorFiles.push_back(w->warriorName);
        w = w->next;
    }

    FitnessEvaluator fe(
        mars->rounds,
        mars->cycles,
        mars->coresize,
        mars->minsep,
        mars->maxWarriorLength,
        mars->processes,
        warriorFiles,
        123);

    // create an imp
    WarriorAry wCurrent;
    //wCurrent.ins.push_back({ EX_IMP, EX_mI, EX_DIRECT, 0, EX_DIRECT, 1 });
     
    wCurrent.startOffset = 0;
    wCurrent.fitness = fe.calcFitness(wCurrent);

    FastRng rng;
    //rng.seed(3211);

    WarriorAry wTrial;

    double beta = 100;
    WarriorAry wBest;
    wBest.fitness = std::numeric_limits<double>::max();

    size_t iter = 0;
    double acceptanceRate = 0.5;

    // see http://msdn.microsoft.com/en-us/library/windows/desktop/ms686277%28v=vs.85%29.aspx
    //SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_BEGIN);

    bool isAutoPrintBestActive = false;
    while (true) {
        evolve(rng, wCurrent, wTrial, mars->coresize, mars->maxWarriorLength);

        // see https://github.com/StanfordPL/stoke-release/blob/232ca096de53be8f1f528b22f3b610566f386cae/src/search/search.cc#L142
        const auto maxFitness = wCurrent.fitness - std::log(rng.rand01()) / beta;
        wTrial.fitness = fe.calcFitness(wTrial, maxFitness);
        ++iter;
        double gotAccepted = 0;
        if (wTrial.fitness <= maxFitness) {
            gotAccepted = 1;
            wCurrent = wTrial;

            if (wCurrent.fitness < wBest.fitness) {
                wBest = wCurrent;
                wBest.iteration = iter;
                if (isAutoPrintBestActive) {
                    printStatus(iter, wBest, mars, acceptanceRate, beta);
                }
            }
        }

        acceptanceRate = acceptanceRate * 0.99 + gotAccepted * 0.01;

        if (_kbhit()) {
            switch (_getch()) {
            case 'r':
                wCurrent = wBest;
                std::cout << "resetted current to best" << std::endl;
                break;

            case 'p':
                printStatus(iter, wBest, mars, acceptanceRate, beta);
                break;

            case 'B':
                beta *= 2;
                std::cout << "doubling beta to " << beta << std::endl;
                break;

            case 'b':
                beta /= 2;
                std::cout << "halfing beta to " << beta << std::endl;
                break;

            case 'a':
                isAutoPrintBestActive = !isAutoPrintBestActive;
                std::cout << "automatically print new best is " << (isAutoPrintBestActive ? "ON" : "OFF") << std::endl;
                break;

            default:
                std::cout << "usage:" << std::endl
                    << " h: this help" << std::endl
                    << " a: toggle automatic printing of new best warrior" << std::endl
                    << " p: print best warrior" << std::endl
                    << " r: reset current warrior to best warrior" << std::endl
                    << " B: double beta" << std::endl
                    << " b: half beta" << std::endl
                    << std::endl;
                break;
            }
        }
    }

    //SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_END);

    //const auto stop = std::chrono::system_clock::now();
    //auto t = std::chrono::duration<double>(stop - start).count();
    return 0;
}