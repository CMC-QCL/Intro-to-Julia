# Run on Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/CMC-QCL/Intro-to-Julia/HEAD)

# Workshop Topics

<details>
<summary>Click to expand!</summary>

### Prelude: Navigating Jupyter Notebooks, Reading Julia Source Code, and the Help System

**It is strongly encouraged that you read this before attending the workshop**.

### Part I: Basics

1. What is Julia?
2. Literals, Variables, and Functions
3. Program Control Flow

### Part II: Collections and Using Packages

1. Anatomy of Julia Functions and Types
2. Collections
    - Arrays
    - Ranges
    - (Named) Tuples
    - Dictionaries
3. Convenient Syntax Tools
4. Variable Scope
5. Packages: Using other people's code
    - Modules
    - The Standard Library
    - The General Registry
    - Environments
6. Review with an Example: Multiple Regression

</details>

# Installation

<details>
<summary>Click to expand!</summary>

[Make sure you download Julia 1.6](https://julialang.org/downloads/) (or higher) and install for your operating system.

1. Download files for the workshop.
2. Start the Julia REPL.
3. Run the following script to download and setup extra packages:
```julia
workshop_folder = "path/to/workshop/folder" # CHANGE THIS
cd(workshop_folder)
using Pkg           # alternative: use ] for pkg mode
Pkg.activate(".")
Pkg.resolve()
Pkg.instantiate()
```
</details>

# Starting the Notebook

<details>
<summary>Click to expand!</summary>

If you are currently in the workshop folder:

```julia
using IJulia
notebook(detached=false, dir=".")
```

Otherwise:

```julia
using IJulia
notebook(detached=false, dir="path/to/workshop/folder")
```
</details>