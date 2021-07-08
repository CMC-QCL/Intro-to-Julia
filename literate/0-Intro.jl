# # Overview
#
# 1. Using Jupyter notebooks
# 2. Reading Julia source code
# 3. Getting the most out of interactive environments
#      - Finding what you need
#      - Tab completions
#      - Global scope
# 4. Using the Julia REPL (Optional)
#      - REPL modes

#
# This first notebook is intended to help orient you to the environment used for the workshop.
# First, we introduce Jupyter notebooks (what you are viewing) and go over how to navigate them.
# Next, we present a brief primer on reading Julia source code, which touches on special syntax for comments, the role of whitespace, and how expressions are structured. 
# The subsequent section provides a few tips to help you use Julia in interactive computing environments.
# The remaining sections are marked optional because they are not required for following along in this workshop.
#
# **Note**: This prelude to the workshop contains Julia code.
# However, you are not expected to know anything about Julia code at this point, and there are no programming exercises.
# Code blocks are intended to be self-contained, so you may see some modules being loaded several times.
#

# # Using Jupyter Notebooks
#
# 

# ## Notebook cells
#
# A notebook is made up of different cells to help organize its content: text notes, code, images, and program output.

# A **code cell** contains a series of instructions in a programming language (Julia in this case). 
#
# - You can evaluate a code cell by clicking the run button (`▷`), or entering `Ctrl + Enter`.
# - Once a cell is evaluated, you will see output appear below it.
#       - If the cell contained print statements, you will see it displayed.
#       - If the cell contains an expression at the end, its value will be displayed.
#
# Jupyter notebooks have support for rich display so that some objects, such as plots or tables, are automatically rendered.
#
# Practice evaluating code cells yourself down below.

## Make a few variables.
x = 1
y = 3.2
z = 8//10

## Print a few things.
println("The value of x is $(x). It is of type $(typeof(x)).")
println("The value of y is $(y). It is of type $(typeof(y)).")
println("The value of z is $(z). It is of type $(typeof(z)).")
println("Their sum is...")
x + y + z
#-
using Plots, LaTeXStrings

f(x) = exp(-x^2 / 2) # define a function that evaluates a Guassian (bell curve)
xs = range(-2.0, 2.0, step=0.1) # represent [-2, 2] over the real line
ys = f.(xs) # evaluate Gaussian over [-2, 2]

plot(xs, ys, xlabel="x", ylabel=latexstring("f(x) = e^{-\\frac{ x^{2} }{ 2 }}"))

#
# A **Markdown cell** contains text that can be formatted with [Markdown](https://jupyter-notebook.readthedocs.io/en/latest/examples/Notebook/Working%20With%20Markdown%20Cells.html).
# They may contain text, images, or LaTeX equations.
#
# Try double-clicking the following Markdown cells to see their source


# You can insert new cells with the (`+`) button in the notebook.
# By default it will be a code cell.
# You can change to a Markdown cell by selecting a cell and using the dropdown menu in the toolbar.

#
# After selecting a cell (highlighted in blue or green):
# * You can insert a new cell (code cell by default) by typing `Esc` followed by `A` (insert above) or `Esc` followed by `B` (insert below).
# * Convert it to a code cell using `Esc` then `Y`.
# * Convert it to a Markdown cell using `Esc` then `M`.

# **Exercise**: Convert the following cell into a code cell and run it.

# sqrt(2)

# # Reading Julia source code
#
# In this section we review a little bit about reading Julia syntax.

# **Comments** are denoted with `#`. Anything inside a comment is decorative and therefore not evaluated.

## This is a comment so nothing happens if you run the cell

# **Multiline comments** are initiated with `#=` and closed with `=#`.

function complicated_code()
#= This is a multiline comment,
useful for complicated code =#
end

# Outside of separating different symbols on a single line, **whitespace** is not interpreted.

short_name       = 1
longer_name      = 2 # every line here is valid syntax
much_longer_name = 3
#-
for i in 1:3
    println(i) # indentation nice for making nested expression readable...
end
#-
for i in 1:3 # but the whitespace is not stricly necessary.
println(i)
end

# Instead, you'll notice that **compound expressions** are closed by the `end` keyword.

function an_example(x) # this a compound expression that defines a function
    x = 1 + 1          # with several statements inside its body
    y = 2*x
    z = sqrt(y)/3
    return z
end
#-
if true               # this is a compound expression for a conditional block
    println("hello")
else
    println("goodbye")
end

# Compound expression all have a return value.
# For example, the `begin` ... `end` block can be used to evaluate a complicated expression
# while using white space to highlight certain elements.

result = begin # this will be equal to `z` inside the block below, 2/3
    x = 1 + 1
    y = 2*x
    z = sqrt(y)/3
end

# We will discuss the semantics of what values are returned for certain compound expression in more detail within the workshop itself.

# # Getting the most out of interactive environments
#
# In this section we go over a few tips for reading Julia code and helping yourself learn within an interactive computing environment.
# The content here applies to both notebook and REPL environments.

# ## Finding what you need
#
# Julia has a help system that can be accessed using `?`.

?

# You can use the syntax `?<identifier>` to ask about anything in the Julia language.
# Try the examples below

?Int64 # ask about types
#-
?rand # ask about functions
#-
?println
#-
x = "abc" # define a variable...
#-
?x # and ask about it
#-
using LinearAlgebra # load a module...
#-
?LinearAlgebra # and ask about it
#-

# You can ask about reserved words/symbols in Julia, too.

?using
#-
?for
#-
?if
#-
?:
#-
?pi

# The help system is great if you already know what you're looking for before you use it.
# If the event that the help system fails to generate a hit, you'll notice a few suggestions at the top of the output (search: ...).
#
# That's useful, but what if you don't know the correct vocabulary or the help hints don't help?
# The `apropos` command can be used to scrape through the documentation.
# For example, let's search for information about `sorting`.

?sorting
#-
apropos("sorting")

# In this case, we see that `apropos` generates a list of functions with documentation that contain our search query.
# We can then use this to look up documentation.

?sort

# Other times you may want to invoke a function, but you're not sure it's defined for the data types you want to use, or you're fuzzy on what the function call should look like.
# In this case, you can use the `methods` function to look up specific invocations for your function.

methods(sort)

# The methods table for a function is succint, so you will often have to use it in conjunction with the help system to make sense of it.

# Lastly, sometimes you may find yourself working with a new data type and you're not sure what functions are defined on it.
# In this case, you can use `methodswith`

using LinearAlgebra
methodswith(QR) # look up functions defined on the QR type

# The `methodswith` lookup will mostly be useful when used on data types that have very specific uses (compared to Base Julia types like Int that appear everywhere).

# ## Tab completions
#
# Julia supports using [Unicode characters](https://docs.julialang.org/en/v1/manual/unicode-input/) inside source code.
# This can be useful if you want your code to match a derivation or reference document, especially for mathematical or simulation code.

using LinearAlgebra
X = randn(10, 3) # naive simulation for least squares problem...
y = randn(10)
λ = 2.0          # type \lambda → Tab to get λ symbol

β = inv(X'X + λ*I) * X' *y # ridge regression solution

# ## Global scope
#
# By default, variables and functions defined with a REPL or notebook will live inside a global scope.
# Specifically, they will live inside the global scope of the `Main` module.
# At any time you can ask what variables, functions, and modules are available in `Main` using `varinfo`.

varinfo()

# # Using the Julia REPL (Read-Eval-Print Loop)

# ## REPL Modes

# ### Julia (Default)
# ![img/repl-mode-julia.png](img/repl-mode-julia.png)
# - Prompt reads as `julia>`.
# - This is where you can run Julia commands.
# - Variables and functions defined here will be in global scope.

# ### Help (`?`)
# ![img/repl-mode-help.png](img/repl-mode-help.png)
# - Prompt reads as `help?>`.
# - Running `?` by itself will show the default help message (shown above).
# - You can ask about anything: the help system will work for functions, macros, and variables.
# - If your query does not generate a hit, you will be shown a few suggestions (see `search:` text in the image).

# ### Package (`]`)
# ![img/repl-mode-pkg.png](img/repl-mode-pkg.png)
# - Prompt reads as `(environment) pkg>`. The active environment above is `(@v1.6)`, the default for Julia 1.6.
# - This is an interactive version of the package manager, `Pkg.jl`.
# - Run `] help` to see a list of available commands.

# ### Shell (`;`)
# ![img/repl-mode-shell.png](img/repl-mode-shell.png)
