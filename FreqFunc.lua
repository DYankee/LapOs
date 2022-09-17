PasteId = "vN3NrXdp"

local function reset()
    term.clear()
    term.setCursorPos(1,1)
end

local function print_left(text)
    local x, y = term.getCursorPos()
    local w, h = term.getSize()
    term.setCursorPos(1,y)
    term.write(text)
end

local function print_centered(text)
    local x, y = term.getCursorPos()
    local w, h = term.getSize()
    term.setCursorPos(math.floor((w - #text) / 2) + 1, y)
    term.write(text)
end

local function print_right(text)
    local x, y = term.getCursorPos()
    local w, h = term.getSize()
    term.setCursorPos(x - #text)
    term.write(text)
end

return{
    print_left = print_left,
    print_centered = print_centered,
    print_right = print_right,
    reset = reset,
}