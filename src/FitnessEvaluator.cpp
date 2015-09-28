#include <FitnessEvaluator.h>
#include <FastRng.h>

#include <exmars/exhaust.h>
#include <exmars/pspace.h>
#include <exmars/sim.h>
#include <exmars/insn_help.h>

#include <algorithm>
#include <vector>
#include <sstream>
#include <thread>
#include <omp.h>

warrior_t allocWarrior(u32_t maxLength)
{
    warrior_t w;
    w.code = (insn_t*)malloc(sizeof(insn_t)*maxLength);
    w.len = 0;
    w.start = 0;
    w.have_pin = 0;
    w.pin = 0;
    w.name = 0;
    int no = 0;
    return w;
}

// creates 1vs1 mars
mars_t* createMars(unsigned roundsPerWarrior,
    unsigned cycles,
    unsigned coresize,
    unsigned minSep,
    unsigned maxWarriorLength,
    unsigned processes)
{
    mars_t* mars = 0;
    mars = (mars_t*)malloc(sizeof(mars_t));
    memset(mars, 0, sizeof(mars_t));
    mars->rounds = roundsPerWarrior;
    mars->cycles = cycles;
    mars->coresize = coresize;
    mars->processes = processes;
    mars->maxWarriorLength = maxWarriorLength;
    //mars->seed = rng((s32_t)time(0)*0x1d872b41);
    mars->minsep = minSep;
    mars->nWarriors = 2;
    /* pmars */
    mars->errorcode = SUCCESS;
    mars->errorlevel = WARNING;
    mars->saveOper = 0;
    mars->errmsg[0] = '\0';                /* reserve for future */
    
    mars->isMultiWarriorOutput = 0;

    // alloc space for two warriors
    mars->warriors = (warrior_t*)malloc(sizeof(warrior_t)*mars->nWarriors);

    // alloc everything else
    mars->positions = (field_t*)malloc(sizeof(field_t)*mars->nWarriors);
    mars->startPositions = (field_t*)malloc(sizeof(field_t)*mars->nWarriors);
    mars->deaths = (u32_t*)malloc(sizeof(unsigned int)*mars->nWarriors);
    mars->results = (u32_t*)malloc(sizeof(u32_t)*mars->nWarriors*(mars->nWarriors + 1));

    mars->pspaceSize = mars->coresize / 16;
    if (mars->pspaceSize <= 0) mars->pspaceSize = 1;

    mars->coreMem = (insn_t*)malloc(sizeof(insn_t) * mars->coresize);
    mars->queueMem = (insn_t**)malloc(sizeof(insn_t*)*(mars->nWarriors * mars->processes + 1));
    mars->warTab = (w_t*)malloc(sizeof(w_t)*mars->nWarriors);
    mars->pspaces = (pspace_t**)malloc(sizeof(pspace_t*)*mars->nWarriors);
    if ((mars->pspacesOrigin = (pspace_t**)malloc(sizeof(pspace_t*)*mars->nWarriors))) {
        u32_t i;
        memset(mars->pspacesOrigin, 0, sizeof(pspace_t*)*mars->nWarriors);
        for (i = 0; i<mars->nWarriors; ++i) {
            pspace_t* p = pspace_alloc(mars->pspaceSize);
            mars->pspacesOrigin[i] = p;
            if (!p) {
                return 0;
            }
        }
        sim_clear_pspaces(mars);
    }

    return mars;
}

void createWarrior(warrior_t* w, unsigned maxWarriorLength) {
    w->code = (insn_t*)malloc(sizeof(insn_t)*maxWarriorLength);
    if (!w->code) {
        throw std::runtime_error("could not allocate warrior code");
    }
}

// single "test case"
struct SingleTestCase {
    warrior_t* warrior;
    unsigned startPos;
    unsigned round;
};


int assemble_warrior(mars_t* mars, const char* fName, warrior_struct* w);
void pmars2exhaust_warrior(u32_t coresize, warrior_struct* wSrc, warrior_t* wTgt);
void clear_results(mars_t* mars);
void save_pspaces(mars_t* mars);
void amalgamate_pspaces(mars_t* mars);
void load_warriors(mars_t* mars);
void set_starting_order(unsigned int round, mars_t* mars);
void accumulate_results(mars_t* mars);

int mods(int a, int b) {
    int m = a % b;
    if (m < 0) {
        m += b;
    }
    return m;
}

void convertWarrior(const WarriorAry& warrior, warrior_t& w, int coresize) {
    w.start = static_cast<u32_t>(warrior.startOffset);
    w.len = static_cast<u32_t>(warrior.ins.size());
    w.have_pin = 0;
    insn_t* in = w.code;
    for (size_t i = 0; i < warrior.ins.size(); ++i) {
        auto& line = warrior.ins[i];
        in->in = OP(line[0], line[1], line[2], line[4]);
        in->a = mods(line[3], coresize);
        in->b = mods(line[5], coresize);
        ++in;
    }
}

enum FightResult {
    TIE,
    WIN,
    LOSE
};

struct FitnessEvaluator::Data {
    warrior_t mEvaluationWarrior;
    std::vector<warrior_t> mWarriors;
    std::vector<mars_t*> mMars;

    unsigned mNumThreads;
    std::vector<SingleTestCase> mTestCases;

    Data(unsigned roundsPerWarrior,
        unsigned cycles,
        unsigned coresize,
        unsigned minSep,
        unsigned maxWarriorLength,
        unsigned processes,
        const std::vector<std::string>& warriorFiles,
        unsigned seed) 
    {
        mNumThreads = std::thread::hardware_concurrency();
        
        // create a mars for each thread
        for (unsigned i = 0; i < mNumThreads; ++i) {
            mMars.push_back(createMars(roundsPerWarrior, cycles, coresize, minSep, maxWarriorLength, processes));
        }

        // load all the warriors
        mWarriors.resize(warriorFiles.size());
        for (size_t i = 0; i < warriorFiles.size(); ++i) {
            warrior_struct w;
            memset(&w, 0, sizeof(warrior_struct));
            if (assemble_warrior(mMars[0], warriorFiles[i].c_str(), &w)) {
                std::stringstream ss;
                ss << "could not load file '" << warriorFiles[i] << "'";
                throw std::runtime_error(ss.str());
            }
            createWarrior(&mWarriors[i], maxWarriorLength);
            pmars2exhaust_warrior(coresize, &w, &mWarriors[i]);
        }

        createWarrior(&mEvaluationWarrior, maxWarriorLength);

        // create randomized positions
        // warrior 0 is always at 0.
        FastRng rng;
        if (seed == -1) {
            rng.seed();
        } else {
            rng.seed(seed);
        }

        std::vector<unsigned> positions;
        for (unsigned p = minSep; p != coresize - 2 * minSep + 1; ++p) {
            positions.push_back(p);
        }

        // initialize all tests
        auto numPoses = std::min(static_cast<unsigned>(positions.size()), roundsPerWarrior);

        for (unsigned warriorIdx = 0; warriorIdx < mWarriors.size(); ++warriorIdx) {
            // reshuffle for each warrior
            std::random_shuffle(positions.begin(), positions.end(), rng);

            // only choose numPoses rounds
            for (unsigned round = 0; round < numPoses; ++round) {
                SingleTestCase stc;
                stc.round = round;
                stc.warrior = &mWarriors[warriorIdx];
                stc.startPos = positions[round];
                mTestCases.push_back(stc);
            }
        }

        // TODO shuffle / reorder mTestCases from time to time to be faster
    }


    size_t calcFitness(const WarriorAry& warrior, size_t stopWhenAbove) {
        // convert warrior into warrior_t struct, then let it fight
        convertWarrior(warrior, mEvaluationWarrior, mMars[0]->coresize);

        // now we've converted everything. Let's fight!
        // TODO make this parallel
        for (size_t i = 0; i < mMars.size(); ++i) {
            //check_sanity();
            save_pspaces(mMars[i]);
            // no pin so far (whatever this is)
            //amalgamate_pspaces(mMars[i]);
        }

        // TODO make this parallel
        int wins = 0;
        int ties = 0;

        size_t fitness = 0;
        for (size_t i = 0; i < mTestCases.size(); ++i) {
            int thread = 0;
            //int thread = omp_get_thread_num();
            auto& mars = mMars[thread];
            auto& tc = mTestCases[i];

            // prepare core
            mars->positions[0] = 0;
            mars->warriors[0] = mEvaluationWarrior;

            mars->positions[1] = tc.startPos;
            mars->warriors[1] = *tc.warrior;

            clear_results(mars);
            sim_clear_core(mars);
            load_warriors(mars);
            set_starting_order(tc.round, mars);

            // simulate! This is the time consuming call.
            u32_t cycles_left;
            int nalive = sim_mw(mars, mars->startPositions, mars->deaths, cycles_left);
            accumulate_results(mars);

            FightResult fr = LOSE;
            if (mars->results[1] == 1) {
                fr = WIN;
            } else if (mars->results[2] == 1) {
                fr = TIE;
            }

            if (WIN == fr) {
                ++wins;
            } else if (TIE == fr) {
                ++ties;
            }
        }

        std::cout << wins << " " << ties << std::endl
            << (mTestCases.size() - (wins + ties)) << " " << ties << std::endl;

        return 0;

    }

    ~Data() {
        for (unsigned i = 0; i < mMars.size(); ++i) {
            sim_free_bufs(mMars[i]);
        }
    }
};

FitnessEvaluator::FitnessEvaluator(
    unsigned roundsPerWarrior,
    unsigned cycles,
    unsigned coresize,
    unsigned minSep,
    unsigned maxWarriorLength,
    unsigned processes,
    const std::vector<std::string>& warriorFiles,
    unsigned seed) 
: mData(new Data(roundsPerWarrior,
    cycles,
    coresize,
    minSep,
    maxWarriorLength,
    processes,
    warriorFiles,
    seed))
{
}

FitnessEvaluator::~FitnessEvaluator() {
}


size_t FitnessEvaluator::calcFitness(const WarriorAry& warrior, size_t stopWhenAbove) {
    return mData->calcFitness(warrior, stopWhenAbove);
}