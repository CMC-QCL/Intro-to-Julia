using BenchmarkTools, LinearAlgebra, Random

# get number of threads, t, and matrix dimension, n, from inputs
t = parse(Int, ARGS[1])
n = parse(Int, ARGS[2])

# don't use Global RNG here; create our own with specific seed
RNG = MersenneTwister(2000)

# limit BLAS to a specific number of threads
BLAS.set_num_threads(t)

# create two n by n matrices; the third is for the result of A * B
A = rand(RNG, n, n)
B = rand(RNG, n, n)
C = similar(A)

# run the benchmark; the $ symbol is needed to properly interpolate
# inputs into the @btime macro
@btime mul!($C, $A, $B)
