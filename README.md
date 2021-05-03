# Installation

[Make sure you download Julia 1.6](https://julialang.org/downloads/) (or higher) and install for your system.

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

# Starting the Notebook

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
