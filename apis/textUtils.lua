function get_term_size()
    local w,h = term.getSize()
    return w,h
end

function print_centered(y, s)
   local w,h = get_term_size()
   term.setCursorPos(y, math.floor((w-s)/s))
   print(s)
end