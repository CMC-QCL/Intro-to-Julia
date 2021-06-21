# # Introduction to Julia: Part I

# # Agenda
#
# 1. What is Julia?
# 2. Literals, Variables, and Functions
# 3. Program Control Flow

# ### Learning Goals
#
# After this workshop you should:
#
# 1. Be familiar with Julia syntax.
# 2. Understand variables, functions, and basic data types in Julia.
# 3. Be able to write short programs in Julia.
# 4. Feel confident enough to explore more on your own.

# # What is Julia?
#
# > **The Julia Project as a whole is about bringing usable, scalable technical computing to a greater audience**: allowing scientists and researchers to use computation more rapidly and effectively; letting businesses do harder and more interesting analyses more easily and cheaply.
# > Part of that project entails creating a free, open-source language that is as easy to use as possible, so that researchers who are not necessarily professional programmers can easily create and share programs that others will be able to use for free and improve upon.
# > However, a large part of the project is also about creating an ecosystem in which such openness and sharing can take place.
#
# -- [Julia Project page](https://julialang.org/project/)

# ### Why should I care?
#
# 1. It is easy to prototype *fast*, *idiomatic* code in Julia *at a high level* thanks to Julia's JIT compiler and powerful type system.
# 2. Julia favors a generic programming style: write functions that assume as little as possible and compose them to write complex programs.
# 3. The Julia community is open and highly collaborative. Many high profile packages represent the joint effort of several brilliant people.
#
# **The Julia language is fast - to run and to write.**

# ### How is it different from `xxxxx`?
#
# Syntax comparison between MATLAB, Julia, and Python: https://cheatsheets.quantecon.org/
# The Julia manual has a dedicated package on this: https://docs.julialang.org/en/v1/manual/noteworthy-differences/
#

# ### I like `X/Y/Z` from `xxxxx` language. I don't think I can ever switch.
#
# Early on in the development of Julia, people put effort into building interoperability between Julia and other languages.
# This means that if you really need a package implemented in another language, it is possible to use it directly from within Julia (and vice-versa).
#
# - Python: Use [PyCall.jl](https://github.com/JuliaPy/PyCall.jl). 
# - R: Use [RCall.jl](https://github.com/JuliaInterop/RCall.jl).
# - MATLAB: Use [MATLAB.jl](https://github.com/JuliaInterop/MATLAB.jl).
# - FORTRAN or C: Use the built-in `ccall` function documented [here](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/).
# - C++: Use [Cxx.jl](https://github.com/JuliaInterop/Cxx.jl).
#
# The [JuliaInterop](https://github.com/JuliaInterop) organization has more packages available for other languages.
#
# **Ultimately, the Julia language is (a very useful) tool. You should use whatever makes you productive, and your work reproducible.**

# # Literals, Variables, and Functions

# ### Literals: Special notation for representing values
#
# Julia has built-in support for representing several kinds of values important for computing.
# You can expect to encounter the following objects in this part of the workshop.

0x01 # 8-bit unsigned integer; input in hexadecimal 0xXX, binary, 0bXXXXXXXX, or octal 0oXXX notation
#-
1 # 64-bit integers by default, or 32-bit if you're using an older computer
#-
1.0 # double precision floating point; scientific notation XeY == X * 10^Y
#-
1f0 # single precision floating point; scientific notation XfY == X * 10^Y
#-
1//2 # rational number using 64-bit integers for numerator and denominator
#-
'1' # characters, only one symbol
#-
"1" # strings, sequence of characters
#-
true # boolean: true or false
#-
1:10 # a UnitRange where A:B specifies values from A to B inclusive (integers)
#-
1:2:10 # a StepRange where A:B:C specifies values from A to B using a step size C (integers)

# There is "special" syntax for many other kinds of objects.
# Here is a sample of other commonly encountered object.
# Collections, such as arrays, will be discussed in the sequel.

0:0.1:1 # StepRangeLen; like A:B:C above but specifies a range over real numbers
#-
1.2 + 0im # 64-bit complex number; im is the imaginary unit
#-
:abc # symbol; objects used to represent Julia code, or as keys into objects like dictionaries
#-
1.0:0.25:2.0 # a StepRange 
#-
[1, 2, 3] # 1D array (Vector) with 64-bit integer elements; separate with commas
#-
['a' 'b' 'c'; 'c' 'd' 'e'] # 2D array (Matrix) with characters elements; separate rows with semicolons
#-
("first", "second", "third") # tuple; fixed-length container supporting indexing
#-
(a=1, b=2.0, c=0x03) # a tuple with named elements
#-
'a' => 1 # a pair object which associates the first argument with the right
#-
Dict('a' => 1, 'b' => 2) # a dictionary literal defined using the pair syntax

# Every value in Julia has a *type* which tells us (and Julia's machinery) what kind of object one is dealing with.
# We can access type information in a programmatic way using the `typeof` function:

typeof(1)
#-
typeof("1")
#-
typeof(true)

# ### Exercise 1.1
#
# The literal `1.2` has type `Float64`. What is the type of `Float64`?

## try it yourself here 

# In addition to specifying values with special notation one can use *constructors*, which are just functions for creating instances of a specific type.

UInt8(1)
#-
Int16(1)
#-
Rational(1, 2)

# **Note**: The mention of constructors might invoke the notion of *classes* as in object-oriented languages.
# However, Julia's types are used strictly to represent values and therefore do not "own" functions or methods.

# ### Exercise 1.2
# Investigate the following types using the help system and methods lookup.

## Float64
#-
## Rational
#-
## Symbol

# ### Variables: Symbols bound to a value
#
# You can bind a value (i.e. literal) to an identifier using the assignment operator `=`:

myvariable = 1903

# One nice feature in Julia is its [support for Unicode characters](https://docs.julialang.org/en/v1/manual/unicode-input/).
# This is particularly useful if you want code to match mathematical notation in notes or a textbook.
# You can type special characters here (or in a Julia REPL) using tab completions (`\<shortcut> → Tab`).
# For mathematical characters, the notation often matches LaTeX commands.

α = 1 # type \alpha → Tab
x₀ = 0.5 # type x\_0 → Tab

# ### Exercise 1.3
#
# Assign a value to a variable called `x`.
# Try running the commands `typeof(x)`, `?x`.

## your solution goes here

# ### Functions

# #### Built-in functions
#
# First we discuss printing functions which are useful for displaying information.
# Next, we look at *operators*, which are mostly just short names for regular Julia functions.
# There are some exceptional cases and we'll point those out as we go.
# The list here is not exhaustive ([see for example](https://docs.julialang.org/en/v1/manual/functions/#Operators-With-Special-Names)).
# 
# In the case of math, you may want to familiarize yourself with [operator precedence](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Mathematical-Operations-and-Elementary-Functions).

# ##### Printing
#
# There are two functions to know: `print` and `println` which accept multiple arguments, string or otherwise.
# If the passed object is not a string, Julia will derive some representation of the object. 
#
# Note that the character `\n` indicates a newline.

myvariable = "four"
myothervar = pi
#-
print("The value of myvariable is ", myvariable, ".\n")
print("The value of myothervar is ", myothervar, ".\n")
#-
println("The value of myvariable is ", myvariable, ".")
println("The value of myothervar is ", myothervar, ".")

# The documentation (`?print`) discusses how these functions can be used to print to a stream other than "standard output", `stdout`. 

# Triple-quoted strings `"""..."""` interpret whitespace, specifically indentation and newlines.
# The `$` symbol can be used to interpolate a variable's value into a string.
# More generally, `$(ex)` will interpolate the value of an expression `ex`.

print(
"""
The value of myvariable is $myvariable.
  1 + 1 is $(1 + 1).
"""
)

# ##### [Artihmetic operators](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Arithmetic-Operators) are supported in Julia
#
# Arithmetic operators are defined for numeric types.
# You can mix numeric types without worrying about type-casting or conversion.

1 + 1 # addition
#-
20.9 - 20 # subtraction
#-
2.3 * 4 # multiplication
#-
9 / 3 # division on the right; equivalent to 3 \ 9 using left division
#-
3 \ 9 # left division
#-
9 ÷ 3 # Euclidean division (÷ is \div → Tab); infix notation for div(9, 3)
#-
7 % 2 # remainder (after Euclidean division); infix notation for mod(7, 2)
#-
2//3 ^ 2 # exponentiation
#-
3 << 4 # left bit shift (on integers); equivalent to 3 * 2^4
#-
-1 # negative sign; unary operator

# *Binary arithmetic operators* have a special property: they can be invoked in infix notation (as above) or prefix notation:

1 + 2 + 3
#-
+(1, 2, 3)

# Binary arithmetic operators `op` also have corresponding *update* versions, which are shorthand for `x = x op y`.
# For example, the addition update operator

x = 1
x += 10
x

# Note: Multiplication is also defined for `String`s and `Char`s.

"abc" * 'c' # this concatenates the two inputs; Strings equipped with * form a semigroup
#-


# ##### Logical, Bitwise, and Comparison Operators

# See for details:
# - [Logical](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Boolean-Operators)
# - [Bitwise](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Bitwise-Operators)
# - [Comparison](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Numeric-Comparisons)
#
# These operators can be chained; e.g. 1 < 2 < 3.
# Numeric types can be mixed with other numeric types but any other mixing will throw an error.

1 < 10 # less than; integers compared based on bits representation
#-
1.2 > 1.2 + 1e-8 # greater than; Float
#-
'a' <= 'b' # less than or equal to (≤ \le + Tab); characters use lexicographic ordering
#-
"aaa" >= "a" # greater than or equal to; strings also use lexicographic ordering
#-
[1, 1] == [1, 1] # equality in terms of value
#-
[1, 1, 1] === [1, 1, 1] # equality in terms of distinguishability
#-
1 != 2 # not equal; similar to !(1 == 2)
#-
!false # logical negation
#-
0.5 < 1 & 1 < 0.5 # bitwise AND
#-
0.5 < 1 | 1 < 0.5 # bitwise OR
#-
0.5 < 1 && 1 < 0.5 # short-circuit AND; similar for |

# The main difference between bitwise and short-circuit logical operators is that the latter has a special evaluation semantic.
# For example, all arguments to bitwise AND are evaluated, whereas as arguments to short-circuit AND are evaluated left-to-right as needed.

true & "this will error"
#-
true && "this will run"
#-
true || "this is never evaluated"
#-

# ##### Other mathematical functions

# Julia implements many common mathematical functions within the base language.
# Starting from rounding, see the [list](https://docs.julialang.org/en/v1/manual/mathematical-operations/#Rounding-functions) here.
#
# The @show *macro* is used here as shorthand for printing an expression and its value.
# We'll discuss macros later in the next part.

@show exp(1)         # exponential
@show sqrt(2)        # valid for non-negative arguments
@show sqrt(-4 + 0im) # use Complex argument for negative values 
@show log(exp(-2))   # default: natural logarithm
@show log(2, 4)      # specify base 2, argument 4
@show log10(1e-3)    # some logarthims have their own dedicated function

# ### User-defined functions

# Programming involves building up many small programs that, ideally, can be composed to write larger more complex programs.
# There are many ways to define a function in Julia.
# For example, consider the function $x \mapsto x + 1$ that takes a number and adds 1 to it:

f(x) = x+1    # must be written as a single line or compound expression; begin ... end

function f(x) # function body is automatically treated as a compound expression
    return x+1
end
#-
f(3)

# By default, a function returns the value of the last statement within the body.
# You can be specific about what the return value should be by using the `return` keyword.
# You can return multiple values by separating them with commas

function g(x)
  return x, x + 1 # this implicitly defines a tuple (x, x+1)
end
#-
g(2.5)

# If you know a function returns multiple arguments, you can easily "destructure" the return value and assign to multiple variables.

both = g(2.5) # bind everything to one variable
#-
x, y = g(2.5) # bind to x and y
#-
_, z = g(2.5) # ignore one with special character _, bind the second to z
#-
@show both
@show x
@show y
@show z

# ### Exercise 1.4
#
# What are the return values for the following functions?

function fun1(x)
    x + 1
    x + 2
    x + 3
end

function fun2(x)
    x + 1
    return x + 2
    x + 3
end

function fun3(x)
    x + 1
    x = x + 2
    return x + 3
    x = x + 4
end

function fun4(x)
    x + 10
    return
    x - 2
end

# ### Exercise 1.5
#
# Write a function that evaluates the quadratic $a x^{2} + b x + c$.
# Call your function `evaluate_quadratic`.
# It should take four (4) inputs, `a`, `b`, `c`, and `x`, in that order.

## write your code here

# Test your code by running the following code block.

@show evaluate_quadratic(0, 0, 2.0, 100.0)   # == 2
@show evaluate_quadratic(1.0, 0, 0, 10.0)    # == 100
@show evaluate_quadratic(0, 1.0, 0, 10.0)    # == 10
@show evaluate_quadratic(2, 1, -10, 2)       # == 0 

# ### Exercise 1.6
# Fill in the formula in the following function, which computes both roots of a quadratic,
# $$
# a x^{2} + b x + c = 0 \iff x = \frac{-b \pm \sqrt{b^{2} - 4 a c}}{2a}
# $$
# Your function should take three (3) inputs, `a`, `b`, and `c`, which you may assume are numbers of the same type.
# You can also assume $|a| > 0$.
# Return the roots as a tuple; e.g. `return root1, root2` or `return (root1, root2)`.

function quadratic_formula(a, b, c)
    ## check for real roots
    d = b^2 - 4a * c
    if d < 0
        error("Roots are not real. Use quadratic(Complex(a), Complex(b), Complex(c)) for imaginary roots.")
    end

    ## your code goes here

    return r1, r2
end

# A few test cases:

@show quadratic_formula(1.0, -2.0, 1.0) # == (1.0, 1.0); x^2 - 2x + 1
@show quadratic_formula(1.0, 0, -1.0)   # == (-1.0, 1.0); x^2 - 1

# # BREAK! (10 minutes)

# #### A note for scientists
#
# Try the following code using your `quadratic_formula`:

a = 1.0; b = 100.0; c = 1.0 # represents x^2 + 100*x + 1
r1, r2 = quadratic_formula(a, b, c)
@show evaluate_quadratic(a, b, c, r1)
@show evaluate_quadratic(a, b, c, r2)

# Depending on how you chose to implement your function, one of the results above is not $0$ but close to it.
# In this case, $b^{2}$ is much larger compared to $4ac$ which means $b^{2} - 4ac$ is subject to *roundoff error*.
# This happens because numbers on the real line *cannot* be represented exactly on a computer.
# It is an issue for irrational numbers like $\sqrt{2}$ and even rational numbers like $1/10 = 0.1$:

bitstring(0.1) # this is not exact in base 2!

# Julia uses the [IEEE 754-2008 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) to handle floating-point arithmetic.
# The Julia manual has plenty of [references](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/#Background-and-References) for the interested reader. 

# Some useful values and functions to know about:

# - `Inf`/`Inf32`/`Inf16`: Literals for representing infinity.
# - `0.0` and `-0.0`: Signed zeros. note that `0.0 == -0.0`.
# - `NaN`: Not a Number; used to handle numerical issues like division by `0` or loss of precison due to underflow/overflow.
# - `exponent`: Return the exponent in the floating point representation of a number.
# - `significand`: Return the digits in the floating point representation of a number.
# - `signbit`: Check the sign bit of a number (false for positive, true for negative).
# - `bitstring`: Return the binary representation of a number literal.
# - `eps`: Machine epsilon; the gap between `1.0` and the next largest representable value of the same numeric type.
# - `nextfloat`/`prevfloat`: The next/previous representable floating-point number relative to an input.

# **Takeaway**: Try to look through documentation to see if a function you want has already been implemented, *especially* for any numerics.

# # Program Control Flow
# 
# *Conditional statements* and *repeated evaluation* are common patterns that emerge in algorithms.
# Julia handles these concepts in a familiar, straightforward way.

# ### Conditional Statements
#
# `if-else` blocks allow you to execute a block of code conditional on some requirement.
#

function flip_coin()
  if rand() < 0.5 # rand() generates a random Float64 between 0 and 1
    println("Heads")
  else
    println("Tails")
  end
end
#-
flip_coin() 

# `if-elseif-else` can be used to chain more than 2 branches.

function roll_die()
  u = rand() # random number between 0 and 1

  if u < 1//6 # divide interval [0,1] into 6 equally sized sub-intervals; assign a side
    1
  elseif 1//6 ≤ u < 2//6
    2
  elseif 2//6 ≤ u < 3//6
    3
  elseif 3//6 ≤ u < 4//6
    4
  elseif 4//6 ≤ u < 5//6
    5
  else # 5//6 ≤ u < 6//6
    6
  end
end
#-
roll_die()

# Note that a value is returned even though we didn't specify a value outside the conditional block.
# **Code blocks in Julia will always evaluate to *something*.**

# The ternary operator (3-argument) `?` can be used to write `if-else` statements compactly.
# Try running the following code a few times to see how it works.

truth_value = rand() < 0.5 # random true / false
truth_value ? println("branch taken if true") : println("branch taken if false")
@show truth_value

# ### Exercise 1.7
#
# Complete the following function which implements the factorial function (on non-negative integers) in a recursive fashion.
#
# $$
# n! = n \times (n-1) \times (n-2) \ldots 3 \times 2 \times 1.
# $$
#
# **Hints**: What is the base case? What is the expected behavior for negative arguments?
#

function factorial_recursive(n)
  ## handle base case

  ## otherwise, continue to recurse
  n * factorial_recursive(n-1)
end

# Here are some test cases

@show factorial_recursive(0)  # == 1
@show factorial_recursive(4)  # == 24
@show factorial_recursive(-1) # up to you what you do here

# ### Repeated evaluation
#
# `for` loops in Julia allow you to repeat a set of instructions based on a condition.
# In Julia, `for` loops are defined over an *iterable* object so the condition is typically to repeat evaluation until the iterable object is exhausted.
#
# The `UnitRange` and `StepRange` objects are particularly well suited for this task.
# Both objects depend on *integer* arguments (but as you saw earlier, there is an analogous version for ranges over the real line).

# A `UnitRange` object defines a collection of integers between a start and end point, inclusively.
# Elements in the collection are assumed to be separated by a *unit* step size.
# 
# For example:

1:10 # start:stop; this is 1, 2, 3, ... , 10; end points are included
#-
UnitRange(1, 10) # alternative using a constructor directly
#-
10:0 # empty range because start > stop

# A `StepRange` object takes 3 integer arguments: a start point, a step size, and an end point.

0:2:10 # start:step:stop; this is 0, 2, 4, ... , 10.
#-
StepRange(0, 2, 10) # alternative syntax
#-
10:-2:0 # you can use a negative step size to iterate in descending order

# Unlike `UnitRange`, a `StepRange` object may not include the end point.
# Specifically, if `stop` is not divisible by `start + step*n` for some integer `n`, then 
# the end point is changed to the closest value of the form `start + step*n`.

1:2:10 # 1, 3, 5, 7, 9; the end point is changed
#-
2:3:10 # what about here?

# Lastly, you can put expressions inside the special : operator syntax.

2*1 : 1+1 : 2^2 # 2, 4; whitespace is allowed and parentheses are not required

# Now we can define our first `for` loop:

for i = 1:10 # for i equal to 1, 2, ..., 10.
  println("The value of i is $(i)")
end
#-
for i in 1:10 # prefered style in Julia is to use `in` or `∈` (\in → Tab)
  println("The value of i is $(i)")
end

# You can also iterate over the elements of an Array.

mylist = ['J', 'u', 'l', 'i', 'a']

for (i, item) in enumerate(mylist)
  println("The item at index $(i) is $(item)")
end

# **Note**: In all these examples, the variables defined within each `for` loop belong to a *local scope* defined by the loop.
# This means `i` and `item` are not available outside the loops.

i # should throw an error unless you defined `i` somewhere
#-
item # should also throw an error

# We will discuss variable scope in more detail later.

# ### Exercise 1.8
#
# Write a function, called `mysum` which evaluates $1^{2} + 2^{2} + \ldots + n^{2}$.
# It should accept a single argument `n`, assumed to be an integer.
# 
# Check your answer using the identity $\frac{1}{6} \times n \times (n+1) \times (2n + 1)$.

## write your solution here
#-
## test your solution here

# ### Exercise 1.9
#
# Implement the factorial function using a `for` loop.
# Recall the definition
#
# $$
# n! = n \times (n-1) \times (n-2) \ldots 3 \times 2 \times 1.
# $$
#
# **Hint**: If $A_{n}$ is equal to $n!$, then $A_{n+1} = (n+1) \times A_{n}$. 
# How can you handle the base case?

function factorial_loop(n)
  ## your code goes here
end

# Compare your implementation against your solution to Exercise 1.7 and the Julia's own `factorial`.

@show factorial_recursive(21)
@show factorial_loop(21)
@show factorial(21)

# `while` loops allow one to repeat a sequence of instructions without knowing how many times they should be repeated.

counter = 0

while counter < 5
    println("The current value is $(counter)")
    counter = counter + 1 # or counter += 1
end
#-
counter = 0
still_true = true # use a Bool as a flag to indicate current state

while still_true
    println("The current value is $(counter)")
    counter = counter + 1    # make sure to update the counter
    still_true = counter < 5 # make sure to update the variable we use to check
end

# Care must be taken to make sure a `while` loop eventually terminates.
# If you accidentally make an infinite `while` loop, just use the "Interrupt the kernel" button (□), `Esc` → `C`, or `Ctrl + C`.

# ### Nested loops
#
# Both `for` and `while` loops can be nested inside each other.

count_A = 0
count_B = 0

while count_A < 10
  while count_B ≤ count_A
    println(count_A, " ", count_B)
    count_B += 1
  end
  count_A += 2
end

# Note that it is possible to reference variables defined within the nested scopes.
# Try running the following code.

for j in 1:4
  for i in 1:j # reference the variable j, which is visible here
    print(i, ' ')
  end
  println()
end

# `for` loops are special in that you can indicate nested loops using commas (`,`):

for j in 1:3, i in 1:3 # loops nested from left to right, left being top-level
  println("(i, j) = ($i, $j)")
end

# ### Loop control
#
# Lastly, it is worth mentioning two useful keyword, `continue` and `break`.
# - `continue` is used to skip over an iteration, typically based on some condition.
# - `break` is used to terminate a loop early altogether.
#
# Here are a few examples to illustrate potential use cases:

for i in 1:10
  if i % 2 == 0 # if i is even; can also use `iseven`
    continue
  end
  println(i) # only odd numbers
end
#-
s = 0
while true
  println(s)
  s = s + 1
  if s > 10
    break
  end
end

# ### Exercise 1.10
#
# Credit: [Algorithms from THE BOOK](https://locus.siam.org/doi/book/10.1137/1.9781611976175?mobileUi=0&) by Kenneth Lange
#
# The ancients could compute square roots long before the age of computers or the rigorous formulation of the real numbers.
# The so-called Babylonian method estimates square roots via the iterative method
#
# $$
# x_{k+1} = \frac{1}{2}\left[x_{k} + \frac{a}{x_{k}}\right].
# $$
#
# Using a `while` loop, implement a function that computes the square root of an a non-negative number `a` based on an initial guess `x0`.
# Your function should run until it achieves a given relative tolerance, $\epsilon$ = `tol`; in symbols this is
# $$
# |x_{k+1} - x_{k}| < \epsilon~(x_{k} + 1).
# $$
#
# Hint: The function `abs` computes the absolute value of a number.

function babylonian(a, x0, tol)
  x_cur = x0            # current estimate
  x_old = x0            # previous estimate
  iter = 0              # number of iterations
  
  ## your code goes here

  ## report iterations taken
  println("Converged after $(iter) iterations.")
  
  return x_cur # return the solution
end
#-
a = 2.0
x0 = 1.0
observed = babylonian(a, x0, 1e-6)
expected = sqrt(a)
abs(observed - expected)

# ### Exercise 1.11
#
# Write a function that counts the number of times a character `char` occurs in a given string `str`.
# It should treat the upper and lower case characters as being the same; e.g. 'c' and 'C' count as the same letter.
#
# **Hint**: Julia allows aribtrary objects to implement some notion of *iteration* and *indexing*.
# A `String` object is both iterable (so that `for c in str` makes sense) and indexable (so that `str[1]`).

function countin(char, str)
  ## your code goes here
end
#-
function capitalize_every_other(str)
  output = "" # start with an empty string

  for (i, c) in enumerate(str) # iterate over each character in str
    if i % 2 == 0              # capitalize if even index
        output *= uppercase(c)
    else                       # otherwise make lowercase
        output *= lowercase(c)
    end
  end
  return output
end
#-
test_string1 = "The quick brown fox jumps over the lazy dog."
test_string2 = capitalize_every_other(test_string1)
@show countin('a', test_string1) # should equal 1
@show countin('o', test_string2) # should equal 4
