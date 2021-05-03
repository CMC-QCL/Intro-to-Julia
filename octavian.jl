using BenchmarkTools, Octavian, Random

# get matrix dimension, n, from input
n = parse(Int, ARGS[1])

# don't use Global RNG here; create our own with specific seed
RNG = MersenneTwister(2000)

# create two n by n matrices; the third is for the result of A * B
A = rand(RNG, n, n)
B = rand(RNG, n, n)
C = similar(A)

# run the benchmark; the $ symbol is needed to properly interpolate
# inputs into the @btime macro
@btime matmul!($C, $A, $B)
