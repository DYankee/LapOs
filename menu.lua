V = settings.get("Version")
local w,h = term.getSize()


-- print centered on x axis
function Print_centered(y,s)
   local x = math.floor((w - string.len(s)) /2)
   term.setCursorPos(x,y)
   term.clearLine()
   term.write(s)
end

--Draw menu function
MOption = 1
function Drawmenu()
    term.clear()
    print_centered(1,"Lapis OS " .. V )
    term.setCursorPos(w-11,1)
    if MOption == 1 then
        term.write("Command Line")
    elseif MOption == 2 then
        term.write("Programs")
    elseif MOption == 3 then
        term.write("Shutdown")
    else
    end
end

--GUI
local function drawFrontend()
    print_centered(math.floor(h/2) - 3, "")
    print_centered(math.floor(h/2) - 2, "Start Menu")
    print_centered(math.floor(h/2) - 1, "")
    print_centered(math.floor(h/2) + 0, ((MOption == 1 and "[ Command Line ]") or " Command Line " ))
    print_centered(math.floor(h/2) + 1, ((MOption == 2 and "[ Programs     ]") or " Programs     " ))
    print_centered(math.floor(h/2) + 2, ((MOption == 3 and "[ Shutdown     ]") or " Shutdown     " ))
end

--Display
Drawmenu()
drawFrontend()


while true do
    local event, key = os.pullEvent()
    if event == "key" then
        if key == 265 or key == 87 then
            if MOption > 1 then
                MOption = MOption - 1
                Drawmenu()
                drawFrontend()
            end
        elseif key == 264 or key == 83 then
            if MOption < 3 then
                MOption = MOption + 1
                Drawmenu()
                drawFrontend()
            end
        elseif key == 257 then
            break
        end
    end
end

if MOption == 1 then
    shell.run("/os/command")
elseif MOption == 2 then
    shell.run("/os/programMenu")
elseif MOption == 3 then
    os.shutdown()
else
end