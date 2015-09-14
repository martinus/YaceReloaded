// by Martin Ankerl 2015

#include <memory>
#include <vector>
#include <exmars/exhaust.h>

// Evaluates a warrior against a testset.
// This uses a deterministic evaluation, with early stop if fitness is worse than a given threshold.
class FitnessEvaluator {
public:
    FitnessEvaluator(
        unsigned roundsPerWarrior,
        unsigned coresize,
        unsigned minsep,
        unsigned processes,
        
        const std::vector<std::string>& warriorFiles,
        unsigned seed);
    ~FitnessEvaluator();

    // calculates fitness for this warrior. This should be as fast as possible.
    size_t calcFitness(warrior_t* warrior, size_t stopWhenAbove);

private:
    struct Data;
    std::unique_ptr<Data> mData;
};