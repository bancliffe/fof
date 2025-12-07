function print_c(str, x, y, c)
    str_width = print(str, 0, -20, c)
    print(str, x-(str_width/2), y, c)
end

function lerp(a,b,t)
    return a+(b-a)*t
end