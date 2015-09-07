# YaceReloaded
Yet Another Corewar Evolver - It's been 12 years, now I'll try my luck again.

I would like to try some new tricks that I have learned in the last few years. Here is what I'd like to implement:

* A Markov Chain Monte Carlo sampler to generate new warriors. This stochastic search seems to be well suited for this kind of problem. This procedure can be easily used to either tune a warrior, or to start completely fresh witout any prior knowledge.
* A new cost minimization function. As far as I know, all evolvers use directly the evaluation results (wins & ties & losses) as the fitness function, and attempt to use KoTH to smooth the fitness function (like I did in Yace). I'd like to try something new here, with a single evolving warrior against a static test set, and even a fixed random sequence of fight position so evaluation is completely deterministic.
* Implement the modifiers in separate LUA scripts so it is easy to hack together your own evolver.
* Easy parallelization and distribution to multiple cores and multiple computers. This will probably be done with ZMQ. the goal is to make it extremely easy to add or remove another PC.
* Configuration as a protocol buffers file. That's also convenient as a data transmission format over the network.
* I use exmars, so that we can parse standard warriors, and have the performance of exhaust-ma.

References:
* Stochastic Superoptimization http://cs.stanford.edu/people/eschkufz/research/asplos291-schkufza.pdf
* Stochastic Optimization of Floating-Point Programs with Tunable Precision http://cs.stanford.edu/people/eschkufz/research/pldi52-schkufza.pdf
* exMARS http://corewar.co.uk/ankerl/exmars.htm
* yace http://corewar.co.uk/ankerl/yace.htm
* An Introduction to MCMC for Machine Learning http://cis-linux1.temple.edu/~latecki/Courses/RobotFall07/PapersFall07/andrieu03introduction.pdf
