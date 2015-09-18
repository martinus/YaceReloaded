#include <FitnessEvaluator.h>
#include <FastRng.h>

#include <exmars/exhaust.h>
#include <exmars/pspace.h>
#include <exmars/sim.h>

#include <algorithm>
#include <vector>
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

    // alloc everything except warriors
    mars->warriors = 0;
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

// single "test case"
struct SingleTestCase {
    warrior_t* warrior;
    unsigned startPos;
    unsigned round;
};


struct FitnessEvaluator::Data {
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
        // TODO 
        
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
    return 0;
}