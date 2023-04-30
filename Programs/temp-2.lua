local w,h = term.getSize()
term.clear()

function PrintRight(y,s)
    local x = w - string.len(s)
    term.setCursorPos(x,y)
    term.write(s)
end

PrintRight(1, h)
PrintRight(2, h - 7)