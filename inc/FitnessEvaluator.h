// by Martin Ankerl 2015

#include <memory>
#include <vector>
#include <exmars/exhaust.h>

// list of instruction. Initialize with e.g.
// { { op::MOV, modifier::mI, addr_mode::DIRECT, 0, addr_mode::DIRECT, 1 } }
typedef std::vector<std::vector<int>> WarriorAry;


// Evaluates a warrior against a testset.
// This uses a deterministic evaluation, with early stop if fitness is worse than a given threshold.
class FitnessEvaluator {
public:
    FitnessEvaluator(
        unsigned roundsPerWarrior,
        unsigned cycles,
        unsigned coresize,
        unsigned minSep,
        unsigned maxWarriorLength,
        unsigned processes,
        
        const std::vector<std::string>& warriorFiles,
        unsigned seed);
    ~FitnessEvaluator();

    // calculates fitness for this warrior. This should be as fast as possible.
    size_t calcFitness(const WarriorAry& warrior, size_t stopWhenAbove = -1);

private:
    struct Data;
    std::unique_ptr<Data> mData;
};