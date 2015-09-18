#include <chrono>

/// FastRng is a simple random number generator based on
/// George Marsaglia's MWC (multiply with carry) generator.
/// Although it is very simple, it passes Marsaglia's DIEHARD
/// series of random number generator tests. It is exceptionally fast.
///
/// The MWC generator concatenates two 16-bit multiply-
/// with-carry generators, x(n)=36969x(n-1)+carry,
/// y(n)=18000y(n-1)+carry mod 2^16, has period about
/// 2^60 and seems to pass all tests of randomness. A
/// favorite stand-alone generator---faster than KISS,
/// which contains it.
///
/// @see http://www.codeproject.com/Articles/25172/Simple-Random-Number-Generation
/// @see http://www.cse.yorku.ca/~oz/marsaglia-rng.html
/// @see http://mathforum.org/kb/message.jspa?messageID=1524861
class FastRng {
public:
    FastRng()
        : mRange(0)
        , mW(521288629)
        , mZ(362436069)
    {
        seed();
    }

    FastRng(unsigned range)
        : mRange(range)
        , mW(521288629)
        , mZ(362436069)
    {
        seed();
    }


    FastRng(unsigned range, unsigned additionalSeed)
        : mRange(range)
        , mW(521288629 + additionalSeed)
        , mZ(362436069 + additionalSeed)
    {
        seed();
    }

    void seed() {
        mW += static_cast<unsigned>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
        mZ += static_cast<unsigned>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
    }

    void seed(unsigned val) {
        mZ = 362436069;
        mW = val;
    }

    // This is the heart of the generator.
    // It uses George Marsaglia's MWC algorithm to produce an unsigned integer.
    // @see https://groups.google.com/forum/?fromgroups=#!topic/sci.crypt/yoaCpGWKEk0
    //
    // generates next random value
    inline unsigned next() {
        mZ = 36969 * (mZ & 65535) + (mZ >> 16);
        mW = 18000 * (mW & 65535) + (mW >> 16);
        return (mZ << 16) + mW;
    }

    // This has a modulo bias.
    inline unsigned operator()() {
        unsigned v = next();
        if (mRange != 0) {
            v %= mRange;
        }
        return v;
    }

    // tight lower bound on the set of all values returned by operator().
    // The return value of this function shall not change during the lifetime of the object.
    // @see http://www.boost.org/doc/libs/1_55_0/doc/html/boost_random/reference.html
    inline unsigned min() const {
        return 0;
    }

    // if std::numeric_limits<T>::is_integer, tight upper bound on the set of all values returned by operator()
    // the generated values x fulfill min() <= x <= max(),
    inline unsigned max() const {
        return -1;
    }

    /// Random float value between 0 and 1.
    inline float rand01() {
        // 1.0 / (2^32 - 1)
        return next() * 2.3283064370807973754314699618685e-10f;
    }

    /// Random float value between min and max.
    inline float operator()(float min_val, float max_val) {
        return (max_val - min_val) * rand01() + min_val;
    }

    // Generates using the given range. This has a modulo bias.
    inline unsigned operator()(unsigned range) {
        return next() % range;
    }

private:
    const unsigned mRange;
    unsigned mZ;
    unsigned mW;
};
