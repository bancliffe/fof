logger={
    init=function()
        printh(get_local_time()..":\tlog started","log.txt", true)
    end,
    log=function(msg)
        printh(get_local_time()..":\t"..msg, "log.txt", false)
    end
}

function get_local_time()
    local year = stat(90)
    local month = stat(91)
    local day = stat(92)    
    local hour = stat(93)
    local minute = stat(94)
    local second = stat(95)
    return year.."-"..month.."-"..day.." "..hour..":"..minute..":"..second
end