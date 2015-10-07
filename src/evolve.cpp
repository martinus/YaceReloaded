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
        //ins[0] = rng(EX_ADD);
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


class Modifier {
public:
    Modifier()
        : mUsedCount(0)
        , mAcceptedCount(0) {
    }
    virtual bool operator()(WarriorAry& w) = 0;

    size_t mUsedCount;
    size_t mAcceptedCount;
};

class InsertRandomInstruction : public Modifier {
private:
    unsigned mMaxWarriorLength;
    unsigned mCoreSize;
    FastRng& mRng;

public:
    InsertRandomInstruction(FastRng& rng, u32_t coresize, u32_t maxWarriorLength)
        : mMaxWarriorLength(maxWarriorLength)
        , mCoreSize(coresize)
        , mRng(rng) {
    }

    virtual bool operator()(WarriorAry& w) {
        // insert random instruction
        if (w.ins.size() >= mMaxWarriorLength) {
            return false;
        }

        int pos = mRng(static_cast<unsigned>(w.ins.size() + 1));
        w.ins.insert(w.ins.begin() + pos, rngIns(mRng, mCoreSize));
        if (pos <= w.startOffset) {
            ++w.startOffset;
        }

        if (mRng(2)) {
            // modify referencing around this command
            int cs = static_cast<int>(mCoreSize);
            for (int i = 0; i < pos; ++i) {
                auto& x = w.ins[i][3];
                if (x < cs / 2 && x >= pos - i) {
                    ++x;
                }
                auto& y = w.ins[i][5];
                if (y < cs / 2 && y >= pos - i) {
                    ++y;
                }
            }
            for (int i = pos + 1; i < w.ins.size(); ++i) {
                auto& x = w.ins[i][3];
                if (x > cs / 2 && cs - x > i - pos) {
                    --x;
                }
                auto& y = w.ins[i][5];
                if (y > cs / 2 && cs - y > i - pos) {
                    --y;
                }
            }
        }

        return true;
    }
};

class RemoveRandomInstruction : public Modifier {
private:
    FastRng& mRng;
    u32_t mCoreSize;

public:
    RemoveRandomInstruction(FastRng& rng, u32_t coresize)
        : mRng(rng)
        , mCoreSize(coresize) {
    }

    virtual bool operator()(WarriorAry& w) {
        // remove random instruction
        if (w.ins.size() <= 3) {
            return false;
        }

        int pos = mRng(static_cast<unsigned>(w.ins.size()));

        w.ins.erase(w.ins.begin() + pos);
        if (pos < w.startOffset || w.startOffset == w.ins.size()) {
            --w.startOffset;
        }

        if (mRng(2)) {
            // modify referencing around this command
            // TODO make sure this is correct!
            int cs = static_cast<int>(mCoreSize);
            for (int i = 0; i < pos; ++i) {
                auto& x = w.ins[i][3];
                if (x < cs / 2 && x >= pos - i) {
                    --x;
                }
                auto& y = w.ins[i][5];
                if (y < cs / 2 && y >= pos - i) {
                    --y;
                }
            }
            for (int i = pos; i < w.ins.size(); ++i) {
                auto& x = w.ins[i][3];
                if (x > cs / 2 && cs - x > i - pos) {
                    ++x;
                }
                auto& y = w.ins[i][5];
                if (y > cs / 2 && cs - y > i - pos) {
                    ++y;
                }
            }
        }

        return true;
    }
};


class SwapRandomInstruction : public Modifier {
private:
    FastRng& mRng;

public:
    SwapRandomInstruction(FastRng& rng)
    : mRng(rng) {
    }

    virtual bool operator()(WarriorAry& w) {
        if (w.ins.size() < 2) {
            return false;
        }

        unsigned pos1 = mRng(static_cast<unsigned>(w.ins.size()));
        unsigned pos2;
        do {
            pos2 = mRng(static_cast<unsigned>(w.ins.size()));
        } while (pos1 == pos2);

        std::swap(w.ins[pos1], w.ins[pos2]);

        return true;
    }
};

class RandomChangeSingleInstruction : public Modifier {
private:
    FastRng& mRng;
    u32_t mCoreSize;
    float mChangeProbability;

public:
    RandomChangeSingleInstruction(FastRng& rng, u32_t coresize, float changeProbability)
        : mRng(rng)
        , mCoreSize(coresize)
        , mChangeProbability(changeProbability) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.empty()) {
            return false;
        }

        unsigned pos = mRng(static_cast<unsigned>(w.ins.size()));

        auto& ins = w.ins[pos];
        const size_t forcedChangeIdx = mRng(6);
        for (size_t i = 0; i < ins.size(); ++i) {
            if (i == forcedChangeIdx || mRng.rand01() < mChangeProbability) {
                rngIns(mRng, w.ins[pos], mCoreSize, i);
            }
        }

        return true;
    }
};

class ChangeStartOffset : public Modifier {
private:
    FastRng& mRng;

public:
    ChangeStartOffset(FastRng& rng)
    : mRng(rng) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.size() <= 1) {
            return false;
        }

        unsigned pos;
        do {
            pos = mRng(static_cast<unsigned>(w.ins.size()));
        } while (pos == w.startOffset);

        w.startOffset = pos;
        return true;
    }
};

// TODO add probability of move instead of duplicate?
class DuplicateInstruction : public Modifier {
private:
    FastRng& mRng;
    u32_t mMaxWarriorLength;

public:
    DuplicateInstruction(FastRng& rng, u32_t maxWarriorLength)
        : mRng(rng)
        , mMaxWarriorLength(maxWarriorLength) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.size() >= mMaxWarriorLength || w.ins.empty()) {
            return false;
        }
        unsigned sourcePos = mRng(static_cast<unsigned>(w.ins.size()));
        auto tmp = w.ins[sourcePos];

        unsigned insertPos = mRng(static_cast<unsigned>(w.ins.size() + 1));
        w.ins.insert(w.ins.begin() + insertPos, tmp);
        if (insertPos < w.startOffset) {
            ++w.startOffset;
        }

        return true;
    }
};

class SwapWithinInstruction : public Modifier {
private:
    FastRng& mRng;
    float mProbNumberSwap;
    float mProbBothSwap;

public:
    SwapWithinInstruction(FastRng& rng, float probNumberSwap, float probBothSwap)
        : mRng(rng)
        , mProbNumberSwap(probNumberSwap)
        , mProbBothSwap(probBothSwap) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.empty()) {
            return false;
        }

        const unsigned pos = mRng(static_cast<unsigned>(w.ins.size()));

        if (mRng.rand01() < mProbBothSwap) {
            std::swap(w.ins[pos][2], w.ins[pos][4]);
            std::swap(w.ins[pos][3], w.ins[pos][5]);
        } else {
            if (mRng.rand01() < mProbNumberSwap) {
                std::swap(w.ins[pos][3], w.ins[pos][5]);
            } else {
                std::swap(w.ins[pos][2], w.ins[pos][4]);
            }
        }

        return true;
    }
};

class ChangeBetweenInstructions : public Modifier {
private:
    FastRng& mRng;
    float mProbInterchange;
    float mProbCopy;

public:
    ChangeBetweenInstructions(FastRng& rng, float probInterchange = 0.5f, float probCopy = 0.0f)
        : mRng(rng)
        , mProbInterchange(probInterchange)
        , mProbCopy(probCopy) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.size() < 2) {
            return false;
        }

        const unsigned pos1 = mRng(static_cast<unsigned>(w.ins.size()));
        unsigned pos2;
        do {
            pos2 = mRng(static_cast<unsigned>(w.ins.size()));
        } while (pos1 == pos2);


        //    0       1       2       3     4       5
        //  EX_MOV, EX_mI, EX_DIRECT, 0, EX_DIRECT, 1 } }

        // random swap a and b value/mode
        unsigned idx1 = mRng(4);
        int idx2 = idx1;
        if (idx1 >= 2 && mRng.rand01() < mProbInterchange) {
            idx2 += 2;
        }

        if (mRng.rand01() < mProbCopy) {
            w.ins[pos1][idx1] = w.ins[pos2][idx2];
        } else {
            std::swap(w.ins[pos1][idx1], w.ins[pos2][idx2]);
        }

        return true;
    }
};


class ChangeNumber : public Modifier {
private:
    FastRng& mRng;
    u32_t mCoreSize;
    float mOneChangeProbability;

public:
    ChangeNumber(FastRng& rng, u32_t coresize, float oneChangeProbability = 0.8f)
        : mRng(rng)
        , mCoreSize(coresize)
        , mOneChangeProbability(oneChangeProbability) {
    }

    bool operator()(WarriorAry& w) {
        if (w.ins.empty()) {
            return false;
        }

        const unsigned pos = mRng(static_cast<unsigned>(w.ins.size()));
        int idx = 3;
        if (mRng(2)) {
            idx = 5;
        }

        int change = 1;
        while (mRng.rand01() < mOneChangeProbability && change < static_cast<int>(mCoreSize)) {
            ++change;
        }
        if (mRng(2)) {
            change = -change;
        }
        change += w.ins[pos][idx];

        // handle over and underflow
        if (change < 0) {
            w.ins[pos][idx] = change + mCoreSize;
        } else if (change >= static_cast<int>(mCoreSize)) {
            w.ins[pos][idx] = change - mCoreSize;
        } else {
            w.ins[pos][idx] = change;
        }


        return true;
    }
};


void evolve(FastRng& rng, 
            std::vector<std::shared_ptr<Modifier>>& modifiers,
            const WarriorAry& wSrcOriginal, 
            WarriorAry& wTgt,
            std::vector<size_t>& usedModifiers)
{
    // change at least once, and probably multiple times.
    size_t codeChangesLeft = 1;
    while (rng.rand01() < 0.7) {
        ++codeChangesLeft;
    }

    // TODO use multi-armed bandit?
    // probably won't work because it will prefers changes that don't do anything. Changes
    // that would increase global search be "destroying" the individual would get less and less
    // attention.
    wTgt = wSrcOriginal;

    usedModifiers.clear();
    while (codeChangesLeft != 0) {
        unsigned pos = rng(static_cast<unsigned>(modifiers.size()));
        if ((*modifiers[pos])(wTgt)) {
            --codeChangesLeft;
            usedModifiers.push_back(pos);
            ++modifiers[pos]->mUsedCount;
        }
    }
}

void printStats(const FitnessEvaluator& fe, std::vector<std::shared_ptr<Modifier>>& modifiers) {
    std::cout << fe.printStats() << std::endl;
    std::cout << "Modifiers:" << std::endl;
    for (size_t i = 0; i < modifiers.size(); ++i) {
        auto& m = modifiers[i];
        std::cout << " " << i << ": " 
            << (m->mAcceptedCount*100.0 / m->mUsedCount) << "% accepted (" 
            << m->mUsedCount << " used, " << m->mAcceptedCount << " accepted)" << std::endl;
    }

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

    unsigned roundsPerWarrior = mars->rounds;

    FitnessEvaluator fe(
        roundsPerWarrior,
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
    /*
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
    */

    WarriorAry wTrial;

    double beta = 25;
    WarriorAry wBest;
    wBest.fitness = std::numeric_limits<double>::max();

    size_t iter = 0;
    double acceptanceRate = 0.5;

    // see http://msdn.microsoft.com/en-us/library/windows/desktop/ms686277%28v=vs.85%29.aspx
    //SetThreadPriority(GetCurrentThread(), THREAD_MODE_BACKGROUND_BEGIN);

    bool isAutoPrintBestActive = true;


    std::vector<std::shared_ptr<Modifier>> modifiers;
    modifiers.push_back(std::make_shared<InsertRandomInstruction>(rng, mars->coresize, mars->maxWarriorLength));
    modifiers.push_back(std::make_shared<RemoveRandomInstruction>(rng, mars->coresize));
    modifiers.push_back(std::make_shared<RemoveRandomInstruction>(rng, mars->coresize));
    modifiers.push_back(std::make_shared<SwapRandomInstruction>(rng));
    modifiers.push_back(std::make_shared<RandomChangeSingleInstruction>(rng, mars->coresize, 0.0f));
    modifiers.push_back(std::make_shared<RandomChangeSingleInstruction>(rng, mars->coresize, 1.0f));
    modifiers.push_back(std::make_shared<ChangeStartOffset>(rng));
    modifiers.push_back(std::make_shared<DuplicateInstruction>(rng, mars->maxWarriorLength));
    modifiers.push_back(std::make_shared<SwapWithinInstruction>(rng, 0.5f, 0.5f));
    modifiers.push_back(std::make_shared<ChangeNumber>(rng, mars->coresize, 0.8f));
    modifiers.push_back(std::make_shared<ChangeBetweenInstructions>(rng, 0.5f, 0.5f));


    //while (iter < 10000) {
    // set priority to very low
    SetPriorityClass(GetCurrentProcess(), IDLE_PRIORITY_CLASS);

    unsigned kothSize = 10;

    std::vector<size_t> usedModifiers;
    while (true) {
        evolve(rng, modifiers, wCurrent, wTrial, usedModifiers);

        // see https://github.com/StanfordPL/stoke-release/blob/232ca096de53be8f1f528b22f3b610566f386cae/src/search/search.cc#L142
        const auto maxFitness = wCurrent.fitness - std::log(rng.rand01()) / beta;
        wTrial.fitness = fe.calcFitness(wTrial, maxFitness, wTrial.score);
        ++iter;
        double gotAccepted = 0;
        if (wTrial.fitness <= maxFitness) {
            gotAccepted = 1;
            wCurrent = wTrial;

            for (size_t i = 0; i < usedModifiers.size(); ++i) {
                ++modifiers[usedModifiers[i]]->mAcceptedCount;
            }


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
            fe.addWarriorToKoth(wBest, kothSize);
            size_t numTestCases = fe.createTestCases(roundsPerWarrior);

            // re-evaluate current and best
            wCurrent.fitness = fe.calcFitness(wCurrent, std::numeric_limits<double>::max(), wCurrent.score);
            auto oldScore = wBest.score;
            wBest.fitness = fe.calcFitness(wBest, std::numeric_limits<double>::max(), wBest.score);
            std::cout << "Score changed from " << oldScore << " to " << wBest.score << ". " << numTestCases << " test cases." << std::endl;

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

            case 'P':
                std::cout << "PAUSING! press any key to continue processing." << std::endl;
                _getch();
                std::cout << "continuing..." << std::endl;
                break;

            case 'c':
                printStatus(iter, wCurrent, mars->coresize, acceptanceRate, beta);
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

            case 'R':
                std::cout << "Currently using " << roundsPerWarrior << " rounds. Enter new rounds per warrior (0 to cancel): ";
                unsigned newRoundsPerWarrior;
                std::cin >> newRoundsPerWarrior;
                if (newRoundsPerWarrior) {
                    roundsPerWarrior = newRoundsPerWarrior;
                    fe.createTestCases(roundsPerWarrior);
                    std::cout << "recreated testset" << std::endl;
                }
                std::cout << "using " << roundsPerWarrior << " rounds" << std::endl;
                break;

            case '<':
                if (--roundsPerWarrior == 0) {
                    roundsPerWarrior = 1;
                }
                fe.createTestCases(roundsPerWarrior);
                std::cout << "using " << roundsPerWarrior << " rounds" << std::endl;
                break;

            case 's':
                printStats(fe, modifiers);
                break;

            case 'k':
                std::cout << "Currently using " << kothSize << " KoTH size. Enter new size: ";
                std::cin >> kothSize;
                std::cout << "using " << kothSize << " from now on." << std::endl;
                break;

            default:
                std::cout << "usage:" << std::endl
                    << " h: this help" << std::endl
                    << " a: toggle automatic printing of new best warrior" << std::endl
                    << " p: print best warrior" << std::endl
                    << " P: Pause evaluation" << std::endl
                    << " c: print current warrior" << std::endl
                    << " r: reset current warrior to best warrior" << std::endl
                    << " R: change Rounds per warrior" << std::endl
                    << " B: double beta" << std::endl
                    << " b: half beta" << std::endl
                    << " s: print stats" << std::endl
                    << " k: change KoTH size" << std::endl
                    << std::endl;
                break;
            }
        }
    }
    printStatus(iter, wBest, mars->coresize, acceptanceRate, beta);
    printStats(fe, modifiers);

    //const auto stop = std::chrono::system_clock::now();
    //auto t = std::chrono::duration<double>(stop - start).count();
    return 0;
}