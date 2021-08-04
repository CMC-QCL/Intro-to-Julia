# # Introduction to Julia: Part II

# # Overview
#
# 1. Collections (? min)
#    - Arrays
#    - Ranges
#    - (Named) Tuples
#    - Dictionaries
# 2. Convenient Syntax Tools (? min)
# 3. Variable Scope (? min)
# 4. Packages: Using other people's code (? min)
#    - Modules
#    - The Standard Library
#    - The General Registry
#    - Environments
# 5. Review with an Example: Multiple Regression (? min)

# # Collections
#
# A *collection* is an object that stores other objects; e.g. an object that stores multiple `Int`s.
# Collections can be nested within each other, so it is possible to have an `Array` of `Array`s or a `Dict` of `NamedTuple` objects.
#
# Before diving into specific kinds of collections, it is good to be aware that collections share a lot of behavior, so much that Julia defines [interfaces](https://docs.julialang.org/en/v1/manual/interfaces/).
# **Importantly, interfaces in Julia are *informal* collections of functions**.
# This means that a single function, such as `iterate`, may be defined for *many* different types in Julia.
# While counterintuitive at first, Julia's interfaces give the language much of its power and composability.
#
# The specific interfaces to keep in mind are:
#
# - *Indexing*, the notion of accessing a particular element in a collection. This makes it so that `x[index]` syntax works for a collection.
# - *Iteration*, the notion of walking through a data structure according to some procedure to access elements programatically. This makes it so that `for item in collection` works for *any* Julia object, user-defined or otherwise.

# ### Array
#
# A Julia [`Array`](https://docs.julialang.org/en/v1/base/arrays/) is an indexed collection with a particular shape determined by its dimensions.
# This means the elements of an `Array` are ordered; it makes sense to speak of "the first element" or "the last element" in an array.
#
# **Note**: Basic arithmetic operations automatically work for arrays with numeric data. Roughly speaking, if an operation works for elements of a certain type, then it will usually automatically work for arrays. LinearAlgebra routines are defined on `Array`.

# #### Array Basics
#
# The shortand for `Array` literals was mentioned last time.
# Elements of an array can be specified by enclosing them with `[` and `]`.

## This creates a 1D Array (Vector) with 3 elements
[1, 2, 3]

#-

## This creates a 3×3 2D Array (Matrix) row by row; note the semicolons
[1 4 7; 2 5 8; 3 6 9]

#- 

## It's also possible to use whitespace in writing out an array
[
    1 0 0
    0 1 0
    0 0 1
]

#-

## typed array literal; the type before the brackets enforces an element type
Float64[1, 2, 3]

# The types `Vector` and `Matrix` are aliases for `Array{T,1}` and `Array{T,2}`, respectively.
# Julia supports general multidimensional arrays through the parameteric type `Array{T,N}`, which is an entire family of types.
#   - It is parametric in the sense that additional *type parameters* determine exactly what kind of object the type represents. Think of this as metadata that is useful to both you and the Julia compiler.
#   - The `T` here refers to the *element type*. It can be a number, string, or even another collection.
#   - The `N` indicates the *number of dimensions*.
#
# To summarize, other ways of constructing an array include

# 1. Request an empty array.
[] # default type Any; top-tevel type
#-
Float64[] # Any can incur performance penalty so you can be specific
#-

# 2. Specify the array elements directly
String["first", "second", "third"]

# 3. Using a function
ones(3) # Vector of 1s; defaults to Float64 
#-
zeros(Int, 4, 2) # Vector of 0s; you can specify the element type
#-
rand('a':'z', 10) # rand will work similarly, but you can specify a collection of elements to sample

# 4.  using the constructor/initializer; note that you can pass multiple arguments or a tuple
Vector{Float64}(undef, 10)
#-
Matrix{Int}(undef, (2, 2))
#-
Array{String}(undef, 2, 2, 3)

# ### Exercise 2.1
#
# Look up `Array`, and the initializers `undef`, `nothing`, and `missing` in the documentation.
#
# How can you construct an array that may contain missing values?
# Try this yourself.
#
# We will discuss undef/missing/null as well as type unions right after.

## experiment here or add your own code cells

# - `undef`: The instance of `<fill in>` used to indicate that an array should be allocated, but not initialized with particular values. 
# - `nothing`: The instance of `<fill in>` used to represent nothingness or void.
# - `missing`: The instance of `<fill in>` used to represent a missing value.

# A *type union* is a type used to indicate uncertainty in values, while restricting the range of possible types.
# For example, if we construct a hetergeneous arrays with numeric types

[1, 1.2] # we get a Vector{Float64}; conversion happens automatically

#-

[1, "1.2"] # but mixing types that are "very different" results in Vector{Any}

# In the latter case, it is preferred to use a union (if you know the types in advance) to make operations with that data as efficient as possible.

Union{Int,String}[1, "1.2"]

# Thus, Julia has the `Missing` type to aid in dealing with missing data coherently.
# Packages like DataFrames.jl, which will be mentioned later, make use of this.

# #### Indexing and Array Properties
#
# Accessing array elements uses square bracket notation `[]`.

x = [1.0, 10.0, 100.0]
#-
y = [1 4 7; 2 5 8; 3 6 9]
#-
function iterate_and_print(arr)
    for i in eachindex(arr)
        value = arr[i]
        println("The element at index $(i) is $(value)")
    end
end
#-
iterate_and_print(x) # Vector
#-
iterate_and_print(y) # Matrix

# **A few observations**:
#
# - Arrays start at index `1`.
# - Notice the order of elements. Data is *column-major*, meaning columns represent contiguous chunks of memory.
# - The `eachindex` function is preferred style for collections that support indexing. It will generate an efficient iteration procedure depending on the type.

# You can index arrays using *linear* indices or *coordinates*.
# The colon operator (`:`) is used to select slices.
# Separate indices along different dimensions with a comma (`,`).
y = [1 4 7; 2 5 8; 3 6 9]
#-
y[6] # == 6; linear index
#-
y[3,1] # == 6; coordinates
#-
y[2,:] # == [2,5,8]; subset a ROW
#-
y[:,3] # == [7,8,9]; subset a COLUMN
#-
y[ [1,5,9] ] == [1,5,9] # if you pass an array this will subset elements
#-
y[ [] ] == Int[] # empty indices produce an empty subset
#-
y[ [1,2], [1,2] ] == [1 4; 2 5] # if you pass multiple indices, this will subset rows and columns
#-
x = ['a', 'b', 'c']
#-
x[begin:end] # begin and end can be used to reference first and last indices
#-
y[2:end, begin:2] # works with higher dimensional arrays, too
#-
y[begin:end] # this will discard shape information
#-
x[ [false, true, false] ] == ['b'] # Booleans can be used to subset too
#-
x[ x .== 'b' ] # select subset based on a condition; .== is element-wise equality 

# ### Exercise 2.2
#
# Practice indexing by trying to construct the following sequences of letters with indexing.
# In each case, your solution should be a vector.
#
# **Hint**: You can use `;` to concatenate individual indices and ranges e.g. `[1:3; 4] == [1,2,3,4]`.

include("misc/exercise-2-2.jl")
x = exercise_2_2() # this function creates an array for the exercise

# **aaa**
##

#-

# **iii**
##

#-

# **mnop**
##

#-

# **abcd**
##

# **xyz**
##

#-

# **abcdefg**
##

# ### Exercise 2.3
#
# Look up the following functions:
# 
# - `ndims`
# - `length`
# - `eltype`
# - `size`
# - `axes`
# - `eachindex`
# - `isempty`
#
# Practice calling these functions on the array below.
# Be sure to test different dimensions.

x = rand(10, 2, 3);
#-
## test functions here or add your own cells

# ### Exercise 2.4
#
# This exercise demonstrates how the order of iteration over matrices impacts performance.
#
# In Julia, `@time` is a special function (a macro) that is useful for measuring how long an expression takes to run.
# Below is an example of how to invoke it.

@time 1 + 1 # practically instant

# The first time you invoke `@time` on an expression, Julia has to compile the function so `@time` will usually reflect the compilation cost.
# Running a second time will often be faster.
# Furthermore, there is some overhead associated with running `@time` in a global scope like a REPL or notebook (more on scope later), so it's best to wrap it inside a function.
#
# 1. Practice using `@time` by adding it next to the left of `for` in each of the following functions.
# 2. Afterwards, try calling both functions with matrices of different sizes. Which function is faster? Use `ones`, `zeros`, or `rand` to quickly generate arrays.

function iterate_j_then_i(matrix)
    m, n = size(matrix)
    max_val = -Inf
    for j in 1:n, i in 1:m # move down along a column; column-major ordering
        max_val = max(max_val, matrix[i,j])
    end
    return max_val
end
#-
function iterate_i_then_j(matrix)
    m, n = size(matrix)
    max_val = -Inf
    for i in 1:m, j in 1:n # move down along a row; row-major ordering
        max_val = max(max_val, matrix[i,j])
    end
    return max_val
end
#-
## call one function here
#-
## call the other function here

# #### Mutability
#
# Arrays are *mutable* objects, meaning it is possible to change contents.
# This is done by combining indexing with assignment syntax.

x = [0, 0, 0]
x[1] = 1
x[2] = 2
x[3] = 3
x

# This generalizes to multidimensional arrays and coordinate indexing.
# Later, we will see how to change several locations in an array at once.

# ### Exercise 2.5
#
# Write a function that fills a vector with the numbers $1, 2, \ldots, n$, where $n$ is the length of the given array.
#
# - The input to your function should be an array which stores each item.
# - Your function should return the modified array.
# - Call your function `consecutive_integers!`.

## your solution goes here

# A few test cases:

x = zeros(4)
consecutive_integers!(x) == Float64[1, 2, 3, 4]
#-
x = zeros(Int, 5)
consecutive_integers!(x) == Int64[1, 2, 3, 4, 5]

# At this point you may have some questions about the function name.
#
# First, because Julia arrays are *mutable* it is possible to change their contents.
# When you pass an argument to a function, say `x`, its value is bound to a new variable
# which appears inside; for example, in the function
#
# ```julia
# function example(internal_name)
#   # code in here...
# end
#
# example(x)
# ```
#
# The value of `x` is bound to `internal_name`.
# However, this *does not create a copy* so **if a mutable object is modified inside the function it is also modified in the outer scope**.
# In brief, Julia's functions are **pass by value**.
#
# Finally, the exclamation mark.
# It is a Julia convention to annotate functions that mutate their arguments with `!` at the end.
# This let's other users know some arguments may be modified.
# A few other conventions:
#
#   - the mutated arguments often appear on the left,
#   - if multiple arguments are mutated the documentation should outline this,
#   - the object that is mutated should be returned (with exceptions), and
#   - a function that allocates memory should be split into one that sets up data and then mutates the allocated objects.

# ### Exercise 2.6
#
# This is an exercise in practicing the Julia conventions above.
# Write a function called `consecutive_integers` that creates an array containing integers between `1` and `n`.
#
#   - `n` is the input argument.
#   - Your implementation should reuse your function from Exercise 2.4.
#   - **Bonus**: Allow the caller to specify a numeric type for the output array.

## write your solution here

# A few test cases:

consecutive_integers(0) == Int[]
#-
consecutive_integers(1) == Int[1]
#-
consecutive_integers(5) == Int[1, 2, 3, 4, 5]

# ### Exercise 2.7
#
# Implement a function called `set_union` that returns the *union* of two vectors `x` and `y`.
#
# A few hints:
#
# - You may assume that `x` and `y` have elements of the same type (no need to handle heterogeneity).
# - The inputs may have different lengths.
# - The result should not contain duplicates.
# - The result need not be sorted, but you may find it useful to sort the inputs. Use `sort` to avoid mutating the original inputs `x` and `y`.

## write your code here

# A few test cases:

x = [1,2,3]; y = [1, 2, 3]
expected = sort!( union(x, y) ) # union is the Julia implementation
observed = sort!( set_union(x, y) ) # we sort the result to it easy to compare implementations
@show expected == observed
#-
x = ['a']; y = ['b', 'c']
expected = sort!( union(x, y) )
observed = sort!( set_union(x, y) )
@show expected == observed
#-
x = Float64[]; y = rand(3)
expected = sort!( union(x, y) )
observed = sort!( set_union(x, y) )
@show expected == observed

# #### Array concatenation

# - `cat`: concatenate along specified dimensions
# - `hcat`: horizontal `cat`
# - `vcat`: vertical `cat`

# Consider the block matrix
# $$
# \begin{bmatrix}
# A_{11} & A_{12} \\
# A_{21} & A_{22}
# \end{bmatrix}
# $$

A11 = rand(3, 3)
A12 = zeros(3, 2)
A21 = zeros(5, 3)
A22 = rand(5, 2)

A = [A11 A12; A21 A22] # spaces separate colums, semicolons separate rows
#-
B = [ A11 A12          # newlines separate rows, too
      A21 A22 ]
#-
C = vcat( hcat(A11, A12), hcat(A21, A22) ) # build directly with functions
#-
D = hcat( vcat(A11, A21), vcat(A12, A22) )
#-
E = cat(A11, A22, dims=(1,2)) # concatenate along both dimensions

# This works for other types of collections, too.

A = [1:3; 4:6]
#-
B = [1:3 4:6]

# #### Slices and Views

# Selecting specific dimensions of an array creates temporary arrays by default.
X = rand(3, 8)
X[:, 3] # this is a NEW array

# Having code that generates lots of temporaries can slow down code inside a "hot" loop.
# The `view` function and associated `@view` macro helps avoid temporaries

view(X, :, 1) # select column 1
#-
view(X, 1, :) # select column 2
#-
@view X[:, 1] # use with the usual syntax

# #### Basic Linear Algebra
#
# Numerical arrays support basic algebraic operations by default.
# These include: `+`, `-`, `*`, `\`, `/`, and `'`.
# Julia will error if two arrays do not have compatible dimensions.

x = [1, 2, 3]
#-
y = 2 * ones(3)
#-
x + y

# Note that `x * y` is not defined. For element-wise operations (more on *broadcasting* later), add a `.` before the operator:

x .* y

# For the "dot product" you can write `x' * y`.

x' * y

# Accessing the documentation for linear algebra operations requires loading the LinearAlgebra package (more packages later)

using LinearAlgebra
#-
?LinearAlgebra

# ### Ranges

# Range objects are used to lazily represent a collection of ordered values, such as intervals.
# All range objects support indexing and some notion of length.
# In Part I we covered `UnitRange` (e.g. `1:10`) and `StepRange` (e.g. `1:1:10`), which work mainly on integer types.
# Only `UnitRange` generalizes to real numbers but require using an explicit constructor rather than the shorthand with colons.
# Below are a few examples.

UnitRange(1.0, 10.0) # 1, 2, ..., 10 as Float64
#-
StepRange(1, 2, 10) # 1, 3, ..., 9 as Int64
#-
StepRange(1.0, 2, 10.0) # will error

# Instead, the `StepRangeLen` type handles ranges on floating point types **accurately**.

x = 1.0:0.5:10.0
#-
typeof(x)

# Alternatively, you can use the `range` function which requires
#
# 1. a left endpoint,
# 2. an optional *positional argument* for the right endpoint, and
# 3. a *keyword argument* `step` or `length`.

range(1, length=100) # 1:100
#-
range(1, 100, length=100)
#-
range(1.0, length=100) # 1.0:1.0:100.0
#-
range(1.0, step=2, length=3)

# Lastly, it is possible to instantiate all the values in a range using `collect`.

collect(1:10)
#-
collect(range(0.0, 10.0, step=0.1))

# One rarely needs to know exactly the type of range object used.
#
# **Advice**: Use the colon shorthand if you're referring to indices into a collection, and `range` for discretizing intervals.

# ### (Named) Tuples

# `Tuple`s are similar to `Array`s in that they are lists of objects, but they do not have a shape.
# They are created by separating values with commas `,`.
# Sometimes it is useful to add parantheses to make it clear that an object is a `Tuple`.

x = 1, 2, 3
#-
x = (1, 2, 3)

# Tuples support both *indexing*, and *iteration*.

for val in x
    @show val
end
#-
for (i, val) in enumerate(x)
    @show i, val, x[i]
end

# A `Tuple` cannot change value because it is an immutable type.

x[2] = 100

# In addition, a `Tuple` has a length which is a fixed property of the object.
length(x)

# So why would you use `Tuple`?

# 1. You want to *pass* or *return* multiple values in a function.
# 2. You want to represent a collection of heterogeneous elements.
# 3. You want the collection to be immutable (e.g. for use in functional programming style).

# ### Exercise 2.8
#
# The `Tuple` type is quite important in Julia because it allows one to "destructure" multiple return values.
# Below are three functions that return multiple values using a mix of `Array` and `Tuple`.

f1() = [1, 2, [3, 4]]
#-
f2() = (1, 2, [3, 4])
#-
f3() = (1, 2, (3, 4))

# **Call `typeof` on each function (e.g. `typeof(f1())`). What do you notice?**
##

# **Try assigning the return value to a single variable (e.g. `x = f1()`).**
##

# **Now assign the return value to three variables (e.g. `x, y, z = f1()`).**
##

# **Take a guess at how you can capture the values `3` and `4` in separate variables.**
##

# A related type is the `NamedTuple` which is a `Tuple` with named fields.
nt = (a = 1, b = [1,2,3], c = 'c')
#-
nt.a
#-
nt.b
#-
nt.c

# ### Exercise 2.9
#
# Both `Tuple` and `NamedTuple` are useful in passing around multiple arguments to functions that accept variable length arguments.
# The "splat" operator `...` can be used to expand the contents of a tuple object into the arguments of a function.

x = (1,2,3,4,5)
sum(x) == +(x...) # splat x into +; expands to 1 + 2 + 3 + 4 + 5

# **Write a function `f(x,y)` that computes `x + y`**.

## your code goes here

# **Now try calling `f(x...)` where `x` is a `Tuple` with two numbers.**

## try splatting here

# Later we will revisit splatting with `NamedTuple` in plotting.

# ### Dictionaries

# A [`Dict`](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) in Julia is an object that maps a specific *key* to a unique *value* (key-value pairs).
# Virtually anything can be used as a key or value, but you should favor using immutable objects as keys to avoid headaches!

# One way to define a `Dict` is by specifying key-value `Pairs`, `<key> => <value>`. Julia will infer the key and value types automatically.

"apple" => pi # creates a Pair object

# The `Pair` type essentially provides a specialized syntax for defining `Dict` literals

d = Dict("Alice" => 25, "Bob" => 22)
#-
d["Alice"] # support for indexing
#-
d = Dict(i => string("x", i) for i in 1:3) # support for comprehensions
#-
for (key, val) in d # support for iteration
    @show key, val, d[key]
end

# ### Exercise 2.10
#
# Write a function that counts the number instances of each character in a `String`, storing the result in a dictionary.
# Remember that `String` objects are iterable.
# 
# **Hint**: Calling `d['a']` should return the number of instances of the letter `a` in the given string. 

## write your code here
#-
test1 = "heterogeneous"
#-
test2 = "Alcatraz"

# # BREAK! (10 minutes)

# # Convenient Syntax Tools

# ### Higher-Order Functions, Transformations, and Broadcasting
#
# The Julia language allows `Function`s to be passed as arguments into other `Function`s, allowing for implementation of higher-order functions (HoFs).
# A common HoF is `map`, which transforms the elements in an iterable collection according to a rule.

result = map(sqrt, 1:10) # computes sqrt(1), sqrt(2), ..., sqrt(9)
#-
x = [-100, -10, -1]
y = [100, 10, 1]
map(+, x, y) # works for multiple inputs

# There is also a non-allocating version, called `map!`, which allows one to specify where the result should be stored.

input = collect(1:9)
result = Vector{Float64}(undef, 10)
#-
map!(sqrt, result, input)

# Sometimes you want to `map` a collection but the transformation you need requires multiple arguments. How can you handle this in Julia?

# **With anonymous functions**
#
# The syntax `x -> f(x)` defines an unnamed (hence anonymous) function. The key here is the `->` operator. These are useful for "fixing" arguments in a multi-argument function call

x = [-1, 32, 4, 8, -12, 0]
map(arg -> arg > 0, x)

# **With specialized types**
#
# Some functions like `>`, `isequal`, and `occursin` can be called with a single argument, which generates a `Fix2` object.
# This object behaves exactly like a function, except it "fixes" one argument in a function call.

is_greater_than_zero = >(0)
#-
is_greater_than_zero(10)

# ### Exercise 2.11
#
# Try using the concepts above to search for the specified elements.
# Hint: functions to look up: `findall`, `contains`, `occursin`, `filter`.

# **Positive elements of the following array:**
test_arr = randn(10) # generates 10 random elements that are normally distributed about 0 with variance 1
#-
## your solution

# **File names ending with the `.out` extension:**
include("misc/exercise-2-2.jl")
files = exercise_2_12()

# In many dynamic languages it is common to write complex mathematical expressions in "vectorized" form. Often, this is because loops in the language are inherently slow, or the vectorized code hooks into specialized routines that run faster than a naive implementation.
#
# Julia provides *broadcasting* for performing element-wise operations (although loops are a fast language feature).
#
# To start, common mathematical and logical operators can be broadcast by adding a `.` before the operator:

x = rand(3)
#-
1 .+ x
#-
1 .> x

# Other functions, both built-in and user-defined, can be broadcast by adding a `.` between the function name and the open parenthesis `(`:

x = 1:100
#-
exp.(x)

# Thus, complex expressions can be vectorized using `.` as needed:

x = 10 * rand(3)
y = 5 * rand(3)
z = 1 .+ exp.( -(x .- y) .^ 2 ./ 2 )
#-
for i in eachindex(z)
    @show z[i] == 1 + exp( -(x[i] - y[i])^2 / 2 )
end

# Because adding `.` everywhere can be tedious, there is the `@.` macro to have Julia do the heavy lifting:

w = @. 1 + exp( -(x - y)^2 / 2 )

# It's possible to control which arguments are broadcasted as documented in the manual.

# Lastly, you should note that `.=` can be used to broadcast assignment.
# If an array already exists, you can even put `@.` on the left of a variable to assign the selected dimension. 
X = zeros(5, 3)
#-
X[:, 1] = rand(5)
#-
X[:, 2] .= 2
#-
@. X[:, 3] = 1 + exp(rand())
#-
X

# ### Comprehensions and Generators

# Sometimes we have a simple rule to enumerate the members of the collection, and it is convenient to specify that collection compactly in set builder-like notation.
# Julia has two language constructs that implement this sort of notation, *generators* and *comprehensions*.

# A *generator* in Julia is a construct that lazily generates a sequence of values, meaning you don't create and store the values.
# Rather, you wait until you iterate over the object to acces specific values.
# Here is an example:

itr = (i for i in 1:10) # produce the values; cannot index into this object
for val in itr # iterate and consume the sequence
    @show val
end

# The general syntax is `( f(x) for x in iterable )`, which yields a `Base.Generator` object.
# For our purposes, it's enough to understand that a `Generator` specifies a collection without storing any actual data; it's quite useful if the collection would be incredibly large.
# Generators are also useful in writing more human-readable code.
# For example, if we wanted to sum up the first 10 nonzero integers, we could write

sum(i for i in 1:10)

# Whether you should use a generator or an explicit for loop is a matter of taste.

# In contrast to lazy generators, *comprehensions* explicitly store data.
# Specifically, *array comprehensions* are essentially just a generator-like expression enclosed in square brackets; that is,
#
# ```julia
# [ f(x) for x in iterable ]
# ```
#
# Here are some examples:

x = [ i for i in 1:4 ]
#-
y = [ i^2 for i in 1:4 ]
#-
z = [ string("x", i) for i in 1:4 ]

# ### Exercise 2.12
#
# The exponential growth model, $G(t) = G(0) \times e^{rt}$, is used in many disciplines to describe populations in a rapid proliferation phase.
# Here $G(0)$ is the initial population size and $r$ is the population growth rate.
#
# **Implement the mathematical model $G(t)$ in a function.**
# Your implementation should be sufficiently general that you can use HoFs, broadcasting, and/or comprehensions to evaluate $G(t)$ at different time points $t$, different initial sizes $G(0)$, and different growth rates $r$.

## your solution

# *Trajectory over time for a particular $G(0)$ and $r$.*
ts = range(0.0, 2.0, step=0.02)
r = 1.0
G0 = 100.0
G.(ts, r, G0)

# # Variable Scope
#
# Several types of code blocks in Julia introduce new variable scopes -- regions of code where a particular identifier is "visible" or "known".
# The following table ([from the manual](https://docs.julialang.org/en/v1/manual/variables-and-scoping/)) summarizes the rules for different language constructs:
#
# | *Construct*        | *Scope type* | *Allowed within* |
# |--------------------|--------------|------------------|
# | module, baremodule | global       | global           |
# | struct             | local (soft) | global           |
# | for, while, try    | local (soft) | global, local    |
# | macro              | local (hard) | global           |
# | functions, do blocks, let blocks, comprehensions, generators | local (hard) | global, local |
#
# The main idea to understand Julia's scoping rules: lexical scope
#
# **The scope of a variable can be inferred based on *where* it appears in code.**
#
# This means that if a variable appears in nested scopes it is visible within the scopes it is contained.
#

# ### Global Scope and Const-ness
#
# First, anything defined inside a REPL or notebook will live in the global scope of `Main`, a special module for interactive environments.
# We'll cover modules laters, but for now just think of a Julia module as a way to organize related code.

global_x = 123 # define the variable
#-
Main.global_x # be explicit about the namespace of the identifier

# Now let's write a function that references `x`.
# Julia requires you to be explicit about global variables with the `global` keyword in assigning new values.

function global_scope_example()
    println(@isdefined global_x) # it's visible
    y = global_x * 10
    @show y
    global global_x = 10 # if we don't declare global, this will define a local variable
    y = global_x * 10
    @show y
    return nothing
end

global_scope_example()
#-
global_x

# **Using global variables like this will incur a performance penalty**.
# The reason? It's possible that a function or script changes the type of a global, which makes it hard for the Julia compiler to reason about the global variable.
# You should avoid globals wherever possible.
#
# You can also use `const` to declare global variables that will never change.

const const_x = 123
#-
function const_example()
    println(@isdefined const_x) # it's visible
    y = const_x * 10
    @show y
    global const_x = 10 # throws a warning
    y = const_x * 10    # what does this do now?
    @show y
    return nothing
end

# ### Local Scope
#
# Local scopes occur naturally in writing functions or handling control flow.
# There are three main rules to consider when assigning values in local scopes; that is, `x = <value>`
#
# 1. **(Updating):** If `x` is already a local variable, then that local variable is what is assigned.
# 2. **(Hard Scope):** If `x` is not already local, and you assign it inside a "hard" construct like a function, a new local variable is created.
# 3. **(Soft Scope):** If `x` is not already local, and you assign it inside a soft scope (like a loop), then it depends on whether a *global* `x` was defined as well as the environment you're running in (interactive vs script). 
#
# This is best illustrated with examples.

function local_scope_example1() # defines a hard local scope
    fancy_var = 1 # now exists within the function
    println("Outside")
    @show fancy_var

    let other_var = 10 # explicitly defines new local scope (hard)
        println("Inside `let` block")
        @show fancy_var # this is nested inside our function, so fancy_var is still local here
        @show fancy_var + other_var
        fancy_var = 10
        @show fancy_var # the variable already existed, so it was updated
    end

    println("Outside again")
    @show fancy_var # still 10
    println("Is `other_var` defined? ", @isdefined other_var) # no, other_var DNE here
end
#-
local_scope_example1()
#-
@isdefined fancy_var
#-

function local_scope_example2()
    xyz = 1 # same as before
    println("Outside")
    @show xyz

    function inner(xyz) # creates a new local scope (hard); don't be cruel about names
        println("Inside `inner` function")
        @show xyz # this `xyz` is meant to refer to the first argument of the function
        xyz = 10
        @show xyz
        return nothing
    end

    println("Calling inner...")
    inner(2)
    println("Outside again...")
    @show xyz

    println("Calling inner again...")
    inner(xyz)
    println("Outside again...")
    @show xyz
    return nothing
end
#-
local_scope_example2()

# These examples deal mainly in *hard* scoping, i.e. creating a new local scope where outer variables are nested in only if those variables occur in other hard scopes.
#
# *Soft* scope rules mainly deal with how variables are resolved in interactive environments vs scripts.
# For example, `for` loops have soft local scope.
# That makes it so that 

s = 0 # technically global
for i in 1:10
    s += i
end

# "just works" in the REPL/notebook; i.e. we meant to reference the `s` just outside.
# In a script you'll get a warning about potential ambiguity or an error.
#
# Why do soft scope rules exist?
# The reason is that one might accidentally reuse the identifier `s` in a very long script,
# in which case there is no clear way to know what you meant to do unless you go back and make the code explicit

# **Takeaways:**
#
# - If you need to use global variables, be explicit.
# - Use `const` if you don't need the global variable to change.
# - Visibility of a variable depends only on where it occurs in code, not on program execution.

# # Packages: Using other people's code

# ### Modules

# Proper Julia packages live inside [*modules*](https://docs.julialang.org/en/v1/manual/modules/). They are defined using module code blocks.
#
# From the documentation:
#
# > 1. **Modules are separate namespaces, each introducing a new global scope**. This is useful, because it allows the same name to be used for different functions or global variables without conflict, as long as they are in separate modules.
# > 2. Modules have facilities for detailed namespace management: each defines a set of names it exports, and can import names from other modules with `using` and `import` (we explain these below).
# > 3. Modules can be precompiled for faster loading, and contain code for runtime initialization.
#
# That being said, modules are also used in managing code to make it both reproducible and easy to share.
#
# Today, we'll only look at the syntax for modules and the rules for importing/exporting code so we understand how to use other people's code.

module MyExample # defined in Main scope!
    println("This module is loading")
    helloworld() = println("Hello world! This is my contribution.") # define a function
    println("We're done")

    export helloworld # export the function by default so others can use it
end

# We see the code executed. Let's try calling the function we made:

helloworld()

# This fails?
# The reason is that defining it in our interactive environment is equivalent to an `import`, which prevents exported functions from being brought into scope.
# We have to be explicit about where the function comes from in this case.

MyExample.helloworld()

# This can be a bit tedious, so fortunately Julia lets us bind a module to a variable to make it easier to write:

ME = MyExample
ME.helloworld()

# Alternatively, the `using` keyword brings all exported functions into scope:

using Main.MyExample # remember, it was defined in Main so we have to qualify the name
helloworld()

# Yet another option: You can explicitly choose which functions to bring into scope when you ivoke `using`:

using Statistics: mean # only bring mean into scope, unqualified
mean(rand(100))
#-
median # lives in Statistics
#-
using Statistics
median

# #### A word on documentation
#
# Package writers will often annotate exported functions with documentation strings, or doctstrings for short.

"This is a docstring."
function docstring_test()
    println("Hello")
end
#-
?docstring_test

# [Docstrings](https://docs.julialang.org/en/v1/manual/documentation/) can use Markdown, LaTeX, and have their own style and formatting rules.

# **Another useful tip:** The function `varinfo` (provided by the Standard Library package InteractiveUtils) can be used to check what variables are defined in a particular module.

# ### The Standard Library

# Julia ships with its own standard library.
# The functions immediately available mostly live in the Base module.
# Other useful packages include: 
#
# - [LinearAlgebra](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/), for everything linear algebra.
# - [DelimitedFiles](https://docs.julialang.org/en/v1/stdlib/DelimitedFiles/), for working with formatted files (e.g. tab or comma separated).
# - [Statistics](https://docs.julialang.org/en/v1/stdlib/Statistics/), many standard statistics functions.
# - [Random](https://docs.julialang.org/en/v1/stdlib/Random/), random number generation.
# - [Printf](https://docs.julialang.org/en/v1/stdlib/Printf/), for printing formatted strings (C-style).
# - [Pkg](https://docs.julialang.org/en/v1/stdlib/Pkg/), the Julia pacakge manager.

# ### The General Registry

# Julia users and developers are free to contribute to the Julia package ecosystem by registering them.
# The **General** registry belongs to the whole community, but it is also possible to create your own private registry that contains your own packages (hosting is a separate issue).
#
# Regardless, you can manage community-contributed packages using the Pkg module.
#
# Some examples include:
#
# * [BenchmarkTools](https://github.com/JuliaCI/BenchmarkTools.jl), which provides macros like `@benchmark` and `@btime` that are useful for checking time and memory allocations in functions. 
# * [CSV](https://csv.juliadata.org/stable/), which handles reading/writing comma-separated files and other delimited file types.
# * [DifferentialEquations](https://sciml.ai/), for everything about differential equations.
# * [Distributions](https://github.com/JuliaStats/Distributions.jl), for representing and sampling from probability distributions.
# * [DataFrames](https://dataframes.juliadata.org/stable/), which provides the `DataFrame` type to represent tabular data (similar to R).
# * [Plots](http://docs.juliaplots.org/latest/), provides a high-level interface for plotting with multiple backends (including `matplotlib` as wrapped by PyPlot).
#
# and many, many more.

# ### Exercise 2.13
#
# The [Plots](http://docs.juliaplots.org/latest/) package is an interface to different plotting backends in Julia.
#
# - It provides high-level interfaces like `plot`, `scatter`, `histogram`, and so on.
# - The implementation details are handled by other packages; for example GR, PyPlot, Plotly.
# - The default backend is GR.
# - Switching backends can be done interactively; for example, calling `gr()` switches to GR.
#
# Here we'll practice using a few plotting commands.

# **Load the Plots package.**
##

# **Run the following code cell.** Note that *keyword arguments* are used to specify plot options.
xs = range(0.0, 1.0, step=0.1)
ys = exp.(xs)
plot(xs, ys, xlabel="x", ylabel="exp(x)")

# Try making the same plot using the `scatter` command.
##

# Plot both the lines and a marker at each point by specifying the option `marker=:o`.
##

# If you pass a single `Array` argument to `plot`, indices are used as the x-axis. **Plot just `ys` with a single command**.
##

# You can plot single-argument functions directly. **Try calling the `plot` command with the function `exp` instead of `y`.**
##

# To plot multiple functions, put them in an `Array`. **Plot both `cos` and `sin` with a single plot command.**
##

# You can build plots incrementally by using the `!` versions of functions. **Plot `cos` and `sin` with two plot commands**.
##

# Plots will interpret *columns* of a matrix as different series.
xs = range(0.0, 1.0, length=101)
ys = randn(length(xs), 3) # 101 time points by 3 series
plot(xs, ys)

# ### Environments

# The list of explicitly installed packages is stored in a file called `Project.toml`.
# The *main* environment is usually called `@v1.x` where `x` is the minor Julia version and lives in `~/.julia/environments/v1.x`.
# This is important because it helps you reproduce the environment used in developing a project!
# 
# There is another file, `Manifest.toml`, which contains specific details about package versions and other dependencies.
#
# Both `Project.toml` and `Manifest.toml` are important for managing your own Julia installation, developing your own packages, and making your programs reproducible when sharing code.

# ##### High-level summary
#
# **If you want to add a package to your computing environment for daily use:**
#
# - No need to worry about `Project.toml` or `Manifest.toml`; just `]add` whatever you want!
# - If you run into bugs and want to get help online/report a bug, you may be asked to supply both files.
#
# **If you want to write code for a (research) project:**
#
# - You should track the computing environment used in a `Project.toml` **and** `Manifest.toml` to make your results reproducible.
# - Ideally, anyone that wants to recreate your studies can just `]activate <environment>`, `]resolve` dependecies, and then `]instantiate` the specific dependencies required.
#
# **If you want to develop your own code:**
#
# - You'll want to write and test within your package's own environment.
# - Track dependencies in `Project.toml` and be mindful of what versions you're using when developing code.
# - Ideally keep `Project.toml` under version control.
# - `Manifest.toml` not required; end-user will have different dependencies.


# # Review with an Example: Multiple Regression
#
# The following series of exercises will help you practice the concepts from this session.
# We will walk through an algorithm to fit a linear model in the context of multiple regression:
#
# $$
# y_{i} \sim x_{i1} \beta_{1} + x_{i2} \beta_{2} + \ldots x_{ip} \beta_{p} + \beta_{p+1},
# $$
#
# where
#
# - $y_{i}$ is the $i$th sample of a dependent variable (what we want our model to be able to predict)
# - $x_{ij}$ is the $i$th sample of predictor $j$,
# - $\beta_{j}$ is the effect size of predictor $j$ (roughly how much a predictor influences the dependent variable), and
# - $\beta_{p+1}$ is an intercept term that captures the ``mean effect'' in the data.
#
# **For the purposes of this extended example, we will simply think of multiple regression as a technique to make predictions from data. No theory is required.**

# ### Exercise 2.14
#
# Complete the following function by
#
# 1. Concatenate `X` with a column of `1s` on the right. Use the function `ones` to creat a vector of the correct length. That is, `X` should become something like `[X 1]`.
# 2. Update components 3, 5, and 8 of the vector `β` with the values in `β_causal`. This requires that you index the correct locations in both vectors. Feel free to use broadcasting; i.e. `.=`.
# 3. Compute `y = X * β`.
# 4. Return three variables `y`, `X`, and `β`.
# 
# Note that this function simulates the design matrix `X` where columns correspond to different predictors, as well as the "true" model `β`.
# This is used to create the dependent variable `y`.
#
# **Note:** The "causal" predictors will be in components 3, 5, and 8.

function simulate_data(nsamples, npredictors)
    if npredictors < 8
        error("Please set `npredictors` ≥ 8.")
    end

    ## design matrix; last columns as `1`s to represent intercept term β₀
    X = 0.5 * randn(nsamples, npredictors)
    ## 1. code goes here

    ## coefficients; the last component represents β₀
    β = 1e-2 * randn(npredictors+1)

    ## coefficients 3, 5, and 8 are causal
    β_causal = [8,-10,12] .* randn(3)
    β # 2. code goes here
    
    ## simulate dependent variable
    y # 3. code goes here

    ## 4. code goes here
end

y, X, β = simulate_data(1000, 10)
#-
X[:,end] # should be 1s
#-
β[3], β[5], β[8] # should be "large" in magnitude

# ### Exercise 2.15
#
# Now we're going to use the Plots package to visualize our simulated data.
#
# 1. Load the Plots package.

## your solution

# 2. Use the `scatter` function to plot a particular predictor `X[:,j]` on the x-axis and `y` on the y-axis. This function takes two arguments, `scatter(xaxis_values, yaxis_values)`. **You should only see a "strong" trend for `j = 3, 5, 8`.**

## your solution

# 3. Using your previous code, add labels to both axes using the `xlabel` and `ylabel` keywords to `scatter`. The x-axis should read "independent variable" and the y-axis should be "dependent variable".

## your solution

# ### Exercise 2.16
#
# Now we'll use the DataFrames and Statistics packages to do some descriptive statistics.
# Here we will simply run the existing code cells.
#
# 1. Load DataFrames and create a DataFrame of `[y X]`.

df = DataFrame([y X], :auto) # creates DataFrame with automatic column names

# 2. Let's rename the columns. DataFrames uses `Symbol` objects for the names.

colnames = [ Symbol("predictor", i) for i in 1:size(X, 2)-1 ] # create column names for predictors
colnames = [:y; colnames; :intercept] # add names for `y` and `intercept`
rename!(df, colnames) # do the renaming

# 3. Call the `describe` function on the `DataFrame` `df`. This will give us a nice summary.

describe(df)

# 4. (Bonus) Verify the summary statistics from above using the Statistics package. Load Statistics and then call functions like `mean` and `median` on specific columns.
# You can access a particular column with the dot syntax `df.column` where `column` is a name in the `DataFrame`.

## your solution

# ### Exercise 2.17
#
# Complete the function below which creates an object to represent our problem.
#
# First, load the LinearAlgebra package and search the help system for how to compute the singular value decomposition (SVD) $\boldsymbol{X} = \boldsymbol{U} \boldsymbol{S} \boldsymbol{V}^{\top}$.
# Then complete the following:
#
# 1. Create three variables `U`, `s`, and `V` which store the SVD of a matrix `X`.
# 2. Allocate a vector `β` that has the same length as the number of columns as `X`.
# 3. Put the variables `y`, `X`, `U`, `s`, `V`, and `β` into a `NamedTuple` with the same field names. Call it `problem`.

## First, load the LinearAlgebra package
#-
## Now fill in the blanks
function make_regression_problem(y, X)
    ## 1. compute SVD of X

    ## 2. allocate vector for coefficients

    ## 3. use a NamedTuple to store data and represent the problem

    return problem
end

# Now we have a way to represent the problem at hand.
# One way to solve the regression problem is to minimize the least squares criterion
#
# $$
# \sum_{i=1}^{n} \left[y_{i} - \sum_{j=1}^{p} x_{ij} \beta_{j} - \beta_{p+1}\right]^{2},
# $$
#
# that is, the distance between the observed values $y$ and the model's predictions $X \beta$.
# However, in some cases a unique solution does not exist.
# Adding a regularization term to the equation above, $\lambda \sum_{j} \beta_{j}$ restores uniqueness but introduces an additioanl parameter.
# The next function implements the solution for a particular choice $\lambda$.
#
# $$
# \beta = \sum_{j} \frac{s_{j}}{s_{j}^{2} + \lambda} \boldsymbol{u}_{j}^{\top} \boldsymbol{y} \boldsymbol{v}_{j}.
# $$
#
# Here the notation $\boldsymbol{u}^{\top} \boldsymbol{v} = u_{1} v_{1} + u_{2} v_{2} + \ldots + u_{n} v_{n}$ represents the "dot product" or "inner product" between two vectors of equal length.
# In Julia you can compute these quantities using `u' * v`, where `'` is the adjoint (transpose for real numbers).
# Another way is to use `dot(u, v)` directly.

# ### Exercise 2.18
#
# Let's implement a function that computes the matrix-vector product $\boldsymbol{X} \boldsymbol{β}$ from the `problem` object we created.
#
# First, implement a non-allocating `predict!` which uses the fields in `problem` to store `X*β` in `dest`.
# Don't use `*` directly; use `mul!` from the LinearAlgebra package.

function predict!(dest, problem)
    ## compute X * β and store in dest without creating a temporary array.

    return dest
end

# Now implement an allocating version `predict` with a single argument `problem`.
# Allocate the output for `X*β` and pass to `predict!`.
function predict(problem)
    ## allocate the output array and call predict!
end

# ### Exercise 2.19
#
#
# Complete the function below by filling in the missing pieces:
#
# Outside the `for` loop:
#
# 1. Add an optional *positional* argument `λ::Real` that defaults to `1.0`.
# 2. Create local variables for `y`, `U`, `s`, `V` and `β` by extracting them from the `NamedTuple` problem.
#
# In the `for` loop:
#
# 1. Select column `j` in the matrix `U`. Make sure to use `@view` to avoid creating a new vector.
# 2. Select column `j` in the matrix `V`. Make sure to use `@view`.
# 3. Compute the coefficient `c = s[j] / (s[j]^2 + λ) * dot(u, y)`.
# 4. Update $\beta = \beta + c \boldsymbol{v}_{j}$. Avoid creating a temporary array by using broadcasting. 

function solve_regression!(problem) # 1. add positional argument
    ## 2. extract variables from problem

    ## initialize β
    for j in eachindex(s)
        u = # 1. select column j in U
        v = # 2. select column j in V
        c = # 3. compute the coefficient that scales v
        β = # 4. Update β
    end

    return β
end

# ### Exercise 2.20
#
# Let's use a test function to check that our implementation works.
# We'll use the mean-squared error,
#
# $$\mathrm{MSE}(u, v) = \frac{1}{n} \sum_{i}^{n} (u_{i} - v_{i})^{2}$$
# 
# to check a few things.
#
# Implement this function below. Feel free to use broadcasting or loops.

function mse(u, v)
    ## you solution
end

# ### Exercise 2.21
#
# Now let's actually check.

y, X, β = simulate_data(1000, 10) # create an instance of the problem; β is the ground truth
problem = make_regression_problem(y, X) # create the problem object
solve_regression!(problem) # try solving with different values of λ; default is λ=1.0
#-
mse(y, predict(problem)) # how good is our prediction?
#-
mse(β, problem.β) # how well do we estimate the "true" values?
#-
causal_idx = [3,5,8]
mse(β[causal_idx], problem.β[causal_idx]) # how about just the "causal" ones?

# ### Exercise 2.22 (Bonus)
#
# Lastly, the following code will generate a plot that shows how the esimated $\beta$ changes as $\lambda$ changes.

λs = [10.0 ^ k for k in -2:5]     # this will be our x-axis
βs = zeros(length(λs), length(β)) # columns correspond to different series in the plot
for (j, λ) in enumerate(λs)
    βs[j, :] .= solve_regression!(problem, λ) # place the solution along rows
end

plot(λs, βs,
    xlabel="lambda",
    ylabel="beta",
    label=["1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "intercept"], # has to be a row vector
    legend=:outerright, # placement of legend
    xscale=:log10,      # log transform the x-axis only
)

# 1. Using the code above as a guide, figure out how to plot the MSE between `y` and the prediction `X*β` as a funtion of $\lambda$.
# 2. Do the same for `β` and the estimate `problem.β`.
# 3. Can you turn your code into a function that handles these two cases? The original case?
