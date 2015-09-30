// by Martin Ankerl 2015

#include <memory>
#include <vector>
#include <exmars/exhaust.h>

// list of instruction. Initialize with e.g.
// { { EX_MOV, EX_mI, EX_DIRECT, 0, EX_DIRECT, 1 } }
struct WarriorAry {
    std::vector<std::vector<int>> ins;
    size_t startOffset;
    double fitness;
    double score;

    size_t iteration;
};


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
    double calcFitness(const WarriorAry& warrior, double stopWhenAbove, double& score);

    std::string printStats() const;
    void createTestCases();

private:
    struct Data;
    std::unique_ptr<Data> mData;
};