#include <evolve.h>

#include <exmars/exhaust.h>
#include <exmars/insn.h>
#include <FitnessEvaluator.h>

#include <FastRng.h>

#include <string>
#include <iostream>
#include <iomanip>
#include <algorithm>
#include <conio.h>

#include <Windows.h>
#ifdef max
#undef max
#endif
#ifdef min
#undef min
#endif

u32_t rngCorepos(FastRng& rng, u32_t coresize) {
    /*
    float r = rng.rand01();
    int change = static_cast<int>(r*r*r * (coresize / 2));
    if (rng(2)) {
    ins[3] = change;
    } else {
    ins[3] = -change;
    }
    }
    */
    u32_t c;
    if (rng(2)) {
        c = rng(32);
        if (rng(2)) {
            c = coresize - c;
        }
    } else {
        c = rng(coresize);
    }
    return c;
}


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
        ins[3] = rngCorepos(rng, coresize);
        break;

    case 4:
        ins[4] = rng(EX_ADDRMODE_END);
        break;

    case 5:
        ins[5] = rngCorepos(rng, coresize);
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

std::string print(const WarriorAry& w, u32_t coresize);


void printStatus(size_t iter, const WarriorAry& w, u32_t coresize, double acceptanceRate, double beta) {
    std::cout
        << std::endl
        << ";redcode-94nop" << std::endl
        << ";name YaceReloaded " << w.iteration << ": " << w.fitness << std::endl
        << ";author Martin Ankerl" << std::endl
        << ";strategy Markov Chain Monte Carlo sampling" << std::endl
        << ";strategy with Metropolis-Hastings Algorithm" << std::endl
        << ";strategy " << std::fixed << std::setprecision(2) << w.score << " testset score" << std::endl
        << ";strategy " << std::defaultfloat << std::setprecision(10) << acceptanceRate << " acceptance rate" << std::endl
        << ";strategy " << iter << " current iteration" << std::endl
        << ";strategy " << beta << " beta" << std::endl
        << ";url https://github.com/martinus/YaceReloaded" << std::endl
        << ";assert 1" << std::endl
        << print(w, coresize);
}


void evolve(FastRng& rng, 
    const WarriorAry& wSrcOriginal, 
    WarriorAry& wTgt, 
    u32_t coresize, 
    u32_t maxWarriorLength)
{
    // change at least once, and probably multiple times.
    auto wSrc = wSrcOriginal;

    size_t codeChangesLeft = 1;
    while (rng.rand01() < 0.8) {
        ++codeChangesLeft;
    }

    while (codeChangesLeft != 0) {
        switch (rng(14)) {
        case 0:
            // insert random instruction
            if (wSrc.ins.size() < maxWarriorLength) {
                wTgt = wSrc;

                int pos = rng(static_cast<unsigned>(wTgt.ins.size() + 1));

                wTgt.ins.insert(wTgt.ins.begin() + pos, rngIns(rng, coresize));
                if (pos <= wTgt.startOffset) {
                    ++wTgt.startOffset;
                }

                if (rng(2)) {
                    // modify referencing around this command
                    int cs = static_cast<int>(coresize);
                    for (int i = 0; i < pos; ++i) {
                        auto& x = wTgt.ins[i][3];
                        if (x < cs / 2 && x >= pos - i) {
                            ++x;
                        }
                        auto& y = wTgt.ins[i][5];
                        if (y < cs / 2 && y >= pos - i) {
                            ++y;
                        }
                    }
                    for (int i = pos+1; i < wTgt.ins.size(); ++i) {
                        auto& x = wTgt.ins[i][3];
                        if (x > cs / 2 && cs - x > i - pos) {
                            --x;
                        }
                        auto& y = wTgt.ins[i][5];
                        if (y > cs / 2 && cs - y > i - pos) {
                            --y;
                        }
                    }
                }

                --codeChangesLeft;
            }
            break;

        case 1:
        case 7:
        case 13:
            // remove random instruction
            if (wSrc.ins.size() > 1) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size()));
                wTgt.ins.erase(wTgt.ins.begin() + pos);
                if (pos < wTgt.startOffset || wTgt.startOffset == wTgt.ins.size()) {
                    --wTgt.startOffset;
                }
                --codeChangesLeft;
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
                --codeChangesLeft;
            }
            break;

        case 3:
            // change single pos
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                rngIns(rng, wTgt.ins[pos], coresize, rng(6));
                --codeChangesLeft;
            }
            break;

        case 4:
            // change whole instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                wTgt.ins[pos] = rngIns(rng, coresize);
                --codeChangesLeft;
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
                --codeChangesLeft;
            }
            break;

        case 6:
            // duplicate an instruction
            /*
            if (wSrc.ins.size() < maxWarriorLength && !wSrc.ins.empty()) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size()));
                auto tmp = wTgt.ins[pos];
                wTgt.ins.insert(wTgt.ins.begin() + pos, tmp);
                if (pos < wTgt.startOffset) {
                    ++wTgt.startOffset;
                }
                --codeChangesLeft;
            }
            */
            break;

        case 8:
            // swap numbers within instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                std::swap(wTgt.ins[pos][3], wTgt.ins[pos][5]);
                --codeChangesLeft;
            }
            break;

        case 9:
            // swap address mode within instruction
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                std::swap(wTgt.ins[pos][2], wTgt.ins[pos][4]);
                --codeChangesLeft;
            }
            break;

        case 10:
            // increase/decrease a number by a bit 
            if (!wSrc.ins.empty()) {
                wTgt = wSrc;
                unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
                int idx = 3;
                if (rng(2)) {
                    idx = 5;
                }

                int change = 1;
                while (rng.rand01() < 0.8f && change < static_cast<int>(coresize)) {
                    ++change;
                }
                if (rng(2)) {
                    change = -change;
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

                --codeChangesLeft;
            }
            break;

        case 11:
            // duplicate to random position
            /*
            if (wSrc.ins.size() < maxWarriorLength && !wSrc.ins.empty()) {
                wTgt = wSrc;
                int pos = rng(static_cast<unsigned>(wTgt.ins.size()));
                auto tmp = wTgt.ins[pos];

                int insertPos = rng(static_cast<unsigned>(wTgt.ins.size() + 1));
                wTgt.ins.insert(wTgt.ins.begin() + insertPos, tmp);
                if (pos <= wTgt.startOffset) {
                    ++wTgt.startOffset;
                }
                --codeChangesLeft;
            }
            */
            break;

        case 12:
            // swap random within index
            if (wSrc.ins.size() > 2) {
                unsigned pos1 = rng(static_cast<unsigned>(wSrc.ins.size()));
                unsigned pos2;
                do {
                    pos2 = rng(static_cast<unsigned>(wSrc.ins.size()));
                } while (pos1 == pos2);

                wTgt = wSrc;

                //    0       1       2       3     4       5
                //  EX_MOV, EX_mI, EX_DIRECT, 0, EX_DIRECT, 1 } }

                // random swap a and b value/mode
                int idx1 = rng(4);
                int idx2 = idx1;
                if (idx1 >= 2 && rng(2)) {
                    idx2 += 2;
                }
                std::swap(wTgt.ins[pos1][idx1], wTgt.ins[pos2][idx2]);
                --codeChangesLeft;
            }
            break;

            /*
        case 13:
            // copy single value to random other instruction.
            // unfortunately copying the full instruction seems to destroy diversity.
            // Just copy one entry instead.
            if (wSrc.ins.size() > 1) {
                wTgt = wSrc;
                int pos1 = rng(static_cast<unsigned>(wTgt.ins.size()));
                int pos2;
                do {
                    pos2 = rng(static_cast<unsigned>(wTgt.ins.size()));
                } while (pos1 == pos2);
                auto idx = rng(6);
                wTgt.ins[pos1][idx] = wTgt.ins[pos2][idx];
                --codeChangesLeft;
            }
            break;
            */

        default:
            std::cout << "error!" << std::endl;
            throw std::runtime_error("evolve switch");
        }

        // update wSrc for next round
        wSrc = wTgt;
    }
}

void printStats(const FitnessEvaluator& fe) {
    std::cout << fe.printStats() << std::endl;
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

    FastRng rng;
    //rng.seed(3211);

    // create a random start warrior
    WarriorAry wCurrent;
    wCurrent.fitness = std::numeric_limits<double>::max();
    for (size_t i = 0; i < 100; ++i) {
        WarriorAry wTry;
        int initialLength = rng(mars->maxWarriorLength) + 1;
        for (size_t i = 0; i < initialLength; ++i) {
            wTry.ins.push_back(rngIns(rng, mars->coresize));
        }
        wTry.startOffset = rng(initialLength);
        double score;
        wTry.fitness = fe.calcFitness(wTry, std::numeric_limits<double>::max(), score);
        wTry.score = score;

        if (wTry.fitness < wCurrent.fitness) {
            wCurrent = wTry;
        }
    }

    WarriorAry wTrial;

    double beta = 25;
    WarriorAry wBest;
    wBest.fitness = std::numeric_limits<double>::max();

    size_t iter = 0;
    double acceptanceRate = 0.5;

    // see http://msdn.microsoft.com/en-us/library/windows/desktop/ms686277%28v=vs.85%29.aspx
    //SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_BEGIN);

    bool isAutoPrintBestActive = true;

    //while (iter < 10000) {
    // set priority to very low
    SetPriorityClass(GetCurrentProcess(), PROCESS_MODE_BACKGROUND_BEGIN);
    while (true) {
        evolve(rng, wCurrent, wTrial, mars->coresize, mars->maxWarriorLength);

        // see https://github.com/StanfordPL/stoke-release/blob/232ca096de53be8f1f528b22f3b610566f386cae/src/search/search.cc#L142
        const auto maxFitness = wCurrent.fitness - std::log(rng.rand01()) / beta;
        wTrial.fitness = fe.calcFitness(wTrial, maxFitness, wTrial.score);
        ++iter;
        double gotAccepted = 0;
        if (wTrial.fitness <= maxFitness) {
            gotAccepted = 1;
            wCurrent = wTrial;

            if (wCurrent.fitness < wBest.fitness) {
                wBest = wCurrent;
                wBest.iteration = iter;
                if (isAutoPrintBestActive) {
                    printStatus(iter, wBest, mars->coresize, acceptanceRate, beta);
                }
            }
        }

        if (iter % 100 == 0) {
            // recreate test cases from time to time, to prevent overfitting
            fe.createTestCases();
            // re-evaluate current and best
            wCurrent.fitness = fe.calcFitness(wCurrent, std::numeric_limits<double>::max(), wCurrent.score);
            auto oldScore = wBest.score;
            wBest.fitness = fe.calcFitness(wBest, std::numeric_limits<double>::max(), wBest.score);
            std::cout << "Score changed from " << oldScore << " to " << wBest.score << std::endl;
        }

        acceptanceRate = acceptanceRate * 0.99 + gotAccepted * 0.01;

        if (_kbhit()) {
            switch (_getch()) {
            case 'r':
                wCurrent = wBest;
                std::cout << "resetted current to best" << std::endl;
                break;

            case 'p':
                printStatus(iter, wBest, mars->coresize, acceptanceRate, beta);
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

            case 's':
                printStats(fe);
                break;

            default:
                std::cout << "usage:" << std::endl
                    << " h: this help" << std::endl
                    << " a: toggle automatic printing of new best warrior" << std::endl
                    << " p: print best warrior" << std::endl
                    << " r: reset current warrior to best warrior" << std::endl
                    << " B: double beta" << std::endl
                    << " b: half beta" << std::endl
                    << " s: print stats" << std::endl
                    << std::endl;
                break;
            }
        }
    }
    printStatus(iter, wBest, mars->coresize, acceptanceRate, beta);
    printStats(fe);

    // set priority back.
    SetPriorityClass(GetCurrentProcess(), PROCESS_MODE_BACKGROUND_END);

    //SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_END);

    //const auto stop = std::chrono::system_clock::now();
    //auto t = std::chrono::duration<double>(stop - start).count();
    return 0;
}