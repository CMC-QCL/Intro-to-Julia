using Literate: notebook

for file in readdir("literate", join=true)
  notebook(file, execute=false)
end
