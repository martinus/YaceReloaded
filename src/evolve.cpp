#include <evolve.h>

#include <exmars/exhaust.h>
#include <exmars/insn.h>
#include <FitnessEvaluator.h>

#include <FastRng.h>

#include <string>
#include <iostream>

void rngIns(FastRng& rng, std::vector<int>& ins, u32_t coresize, size_t idx) {
    switch (idx) {
    case 0:
        ins[0] = rng(EX_OP_END);
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
        switch (rng(5)) {
        case 0:
            // insert random instruction
            if (wSrc.ins.size() < maxWarriorLength) {
                wTgt = wSrc;
                wTgt.ins.push_back(rngIns(rng, coresize));
                hasChanged = true;
            }
            break;

        case 1:
            // remove random instruction
            if (wSrc.ins.size() > 1) {
                wTgt = wSrc;
                wTgt.ins.erase(wTgt.ins.begin() + rng(static_cast<unsigned>(wTgt.ins.size())));
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
        {
            // change single pos
            wTgt = wSrc;
            unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
            rngIns(rng, wTgt.ins[pos], coresize, rng(6));
            hasChanged = true;
        }
            break;

        case 4:
            // change whole instruction
        {
            wTgt = wSrc;
            unsigned pos = rng(static_cast<unsigned>(wSrc.ins.size()));
            wTgt.ins[pos] = rngIns(rng, coresize);
            hasChanged = true;
        }
            break;

        default:
            throw std::runtime_error("evolve switch");
        }
    }
}

std::string print(const WarriorAry& w, u32_t coresize);


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
    rng.seed(3211);

    WarriorAry wTrial;

    double beta = 1e7;
    WarriorAry wBest;
    wBest.fitness = std::numeric_limits<double>::max();

    size_t iter = 0;
    while (true) {
        evolve(rng, wCurrent, wTrial, mars->coresize, mars->maxWarriorLength);

        // see https://github.com/StanfordPL/stoke-release/blob/232ca096de53be8f1f528b22f3b610566f386cae/src/search/search.cc#L142
        const auto maxFitness = wCurrent.fitness - std::log(rng.rand01()) / beta;
        wTrial.fitness = fe.calcFitness(wTrial, maxFitness);
        ++iter;
        if (wTrial.fitness <= maxFitness) {
            wCurrent = wTrial;
            std::cout << ".";
            //std::cout << iter << ": " << wCurrent.fitness << " accepted" << std::endl;

            if (wCurrent.fitness < wBest.fitness) {
                wBest = wCurrent;
                std::cout
                    << std::endl 
                    << "; YaceReloaded " 
                    << iter 
                    << ": " 
                    << wBest.fitness 
                    << " new global best!" 
                    << std::endl;
                std::cout << print(wBest, mars->coresize);
            }
        }
    }
    //const auto stop = std::chrono::system_clock::now();
    //auto t = std::chrono::duration<double>(stop - start).count();
    return 0;
}