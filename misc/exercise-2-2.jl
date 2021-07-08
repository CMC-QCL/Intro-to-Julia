function exercise_2_2()
    x = Array{Char}(undef, 4, 3, 2)
    x[:,1,1] = 'a':'d'
    x[1,:,1] .= 'a'
    x[2,2:end,1] = ['f','g']
    x[3,2:end,1] = ['m','n']
    x[4,2:end,1] = ['o','p']
    x[1,:,2] = 'x':'z'
    x[2,:,2] = ['i','o','o']
    x[3,:,2] = ['o','i','o']
    x[4,:,2] = ['e','o','i']
    return x
end