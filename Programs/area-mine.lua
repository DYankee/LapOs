PasteId = "MqegTrzh"

V = settings.get("Version")
local W,H = term.getSize()
MOption = 1

function Print_centered(y,s)
    s = tostring(s)
    local x = math.floor((W - string.len(s)) /2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Print_left(y,s)
    s = tostring(s)
    local x = 1
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Print_right(y,s)
    s = tostring(s)
    local x = math.floor(W - string.len(s))
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Get_MOption(max)
    while true do
        local event, key = os.pullEvent()
        if event == "key" then
            if key == 265 or key == 87 then
                if MOption > 1 then
                    MOption = MOption - 1
                    Draw_main_menu(MOption)
                end
            elseif key == 264 or key == 83 then
                if MOption < max then
                    MOption = MOption + 1
                    Draw_main_menu(MOption)
                end
            elseif key == 257 then
                break
            end
        end
    end
    return(MOption)
end

function Draw_main_menu(MOption)
    term.clear()
    Print_centered(1,"Area miner V" .. V)
    Print_right(1, MOption)
    Print_centered(5,((MOption == 1 and "[ Set dig area ]") or "Set dig area"))
    Print_centered(6,((MOption == 2 and "[ Start ]") or "Start"))
    Print_centered(7,((MOption == 3 and "[ Exit ]") or "Exit"))
end

function Set_dig_area()

    term.clear()
    local x = 0
    local z = 0
    local y = 0
    x = tonumber(x)
    z = tonumber(z)
    y = tonumber(y)
    local function draw_dig_area(x,z,y)
        local x2 = tostring(x)
        local z2 = tostring(z)
        local y2 = tostring(y)
        Print_left(2, "Width = " .. x2)
        Print_left(3, "Depth = " .. z2)
        Print_left(4, "Hight = " .. y2)
    end
    Print_centered(1,"Area miner V" .. V)
    draw_dig_area(x,z,y)

    if x == 0 then
        Print_centered(6, "Enter Width")
        term.setCursorPos(7,7)
        x = read()
        term.setCursorPos(7,7)
        term.clearLine()
        while x == 0 do
            Print_centered(5, "Please enter a number greater than 0")
            Print_centered(6, "Enter Width")
            term.setCursorPos(7,7)
            x = read()
            term.setCursorPos(7,7)
            term.clearLine()
        end
        draw_dig_area(x,z,y)
    end
    if z == 0 then
        Print_centered(6, "Enter Width")
        term.setCursorPos(7,7)
        z = read()
        term.setCursorPos(7,7)
        term.clearLine()
        while z == 0 do
            Print_centered(5, "Please enter a number greater than 0")
            Print_centered(6, "Enter Width")
            term.setCursorPos(7,7)
            z = read()
            term.setCursorPos(7,7)
            term.clearLine()
        end
        draw_dig_area(x,z,y)
    end
    if y == 0 then
        Print_centered(6, "Enter Width")
        term.setCursorPos(7,7)
        y = read()
        term.setCursorPos(7,7)
        term.clearLine()
        while y == 0 do
            Print_centered(5, "Please enter a number greater than 0")
            Print_centered(6, "Enter Width")
            term.setCursorPos(7,7)
            y = read()
            term.setCursorPos(7,7)
            term.clearLine()
        end
        draw_dig_area(x,z,y)
    end
    x = tonumber(x)
    z = tonumber(z)
    y = tonumber(y)
    return x, z, y
end

function Run()
    Draw_main_menu()
    local MOption = Get_MOption(3)
    if MOption == 1 then
        Gx,Gz,Gy = Set_dig_area()
    elseif MOption == 2 then
        print("width = " .. Gx)
        print("Depth = " .. Gz)
        print("Hight = " .. Gy)
    elseif MOption == 3 then
        shell.run("/os/programMenu")
    end
end

Run()