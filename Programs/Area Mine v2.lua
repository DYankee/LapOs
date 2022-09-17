PasteId = "AKaJGAks"
V = "0.3"
local W,H = term.getSize()
MOption = 1

--list of fuels and their value
Fuel = {
    "minecraft:coal_block" == 800,
    "minecraft:coal" == 80,
    "actuallyadditions:block_misc" == 800,
    "quark:charcoal_block" == 800,
}



--text functions
function print_centered(y,s)
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

function Header()
    print_centered(1,"Area miner v" .. V)
end

--turtle functions
function GetFuelIndex()
    for slotNum = 1, 16, 1 do
        local item = turtle.getItemDetail(slotNum)
        if(item ~=nil) then
            for fuelIndex =1, #fuel, 1 do
                if(item.name == fuel[fuelIndex]) then
                    local fuelValue = fuelIndex[item.name]
                return slotNum, fuelValue
                end
            end
        end
    end
end

function Refuel(max)
    while (turtle.getFuelLevel() < max) do
    local index = getFuelIndex()
        if(index ~= nil) then
        turtle.select(index)
        turtle.refuel(1)
        end
    end
end



function Get_MOption(menu,max)
    if MOption > max then
        MOption = max
    end
    while true do
        local event, key = os.pullEvent()
        if event == "key" then
            if key == 265 or key == 87 then
                if MOption > 1 then
                    MOption = MOption - 1
                    menu()
                end
            elseif key == 264 or key == 83 then
                if MOption < max then
                    MOption = MOption + 1
                    menu()
                end
            elseif key == 257 then
                break
            end
        end
    end
    return(MOption)
end

function Set_dig_area()
    local X,Y,Z = 0,0,0
    local function draw_menu()
        term.clear()
        Header()
        print_centered(2,("Set dig area"))
        Print_left(3,"Width = "..X)
        Print_left(4,"Depth = "..Z)
        Print_left(5,"Hight = "..Y)
    end
    draw_menu()

    --Get sizes
    Print_left(6,"Please enter Width:")
    term.setCursorPos(1,7)
    X = read("*n")
    term.clear()
    draw_menu()
    Print_left(6,"Please enter Depth:")
    term.setCursorPos(1,7)
    Z = read("*n")
    term.clear()
    draw_menu()
    Print_left(6,"Please enter Hight:")
    term.setCursorPos(1,7)
    Y = read("*n")
    term.clear()
    draw_menu()

    Curent_dig_area = {
    x = X,
    z = Z,
    y = Y
    }
    Main_menu()
end

function Dig()
    local x = tonumber(Curent_dig_area.x)
    local z = tonumber(Curent_dig_area.z)
    local y = tonumber(Curent_dig_area.y)
    local fuelNeeded = x * z * (math.floor(y/3) + 1)
    local tRows = math.floor(y/3)
    turtle.refuel(fuelNeeded)

    local function Mine_row()
        if y >= 3 then
            for i = 1, z - 1, 1 do
                turtle.digUp()
                turtle.dig()
                turtle.digDown()
                turtle.forward()
                print(z)
            end
        elseif y == 2 then
            for i = 1, z - 1, 1 do
                turtle.digUp()
                turtle.dig()
                turtle.forward()
                print(z)
            end
        elseif y == 1 then
            for i = 1, z - 1, 1 do
                turtle.dig()
                turtle.forward()
                print(z)
            end
        end
    end

    local function Next_row_l()
        turtle.turnLeft()
        if y >= 3 then
            turtle.digUp()
            turtle.dig()
            turtle.digDown()
        elseif y == 2 then
            turtle.digUp()
            turtle.dig()
        elseif y == 1 then
            turtle.dig()
        end
        turtle.forward()
        turtle.turnLeft()
    end

    local function Next_row_r()
        turtle.turnRight()
        if y >= 3 then
            turtle.digUp()
            turtle.dig()
            turtle.digDown()
        elseif y == 2 then
            turtle.digUp()
            turtle.dig()
        elseif y == 1 then
            turtle.dig()
        end
        turtle.forward()
        turtle.turnRight()
    end

--get in start pos
    turtle.dig()
    turtle.forward()
--dig loop
    while y >= 1 do
        while x > 1 do
            Mine_row()
            Next_row_l()
            Mine_row()
            x = x - 2
            if x >= 2 then
                Next_row_r()
            elseif x == 1 then
                Next_row_r()
                Mine_row()
                turtle.digUp()
                turtle.digDown()
                turtle.turnLeft()
                turtle.turnLeft()
                for i = 1, z, 1 do
                    turtle.forward()
                end
                x = x - 1
            elseif x == 0 then
                turtle.digUp()
                turtle.digDown()
                turtle.forward()
            end
        end
        if y >= 3 then
            y = y - 3
        elseif y == 2 then
            y = 2 -2
        elseif y == 1 then
            y = y - 1
        end
    end
end









-- ui and logic for main menu
function Main_menu()
    -- ui for the main menu
    local function draw_menu()
        term.clear()
        Header()
        print_centered(5,((MOption == 1 and "[ Start ]") or "Start"))
        print_centered(6,((MOption == 2 and "[ Change dig size ]") or "Change dig size"))
        print_centered(7,((MOption == 3 and "[ Exit ]") or "Exit"))
    end
    term.clear()
    draw_menu()
    Get_MOption(draw_menu,3)

--logic for Main_menu
    if MOption == 1 then
        print(Curent_dig_area.x)
        print(Curent_dig_area.z)
        print(Curent_dig_area.y)
        sleep(3)
        term.clear()
        Dig()
    elseif MOption == 2 then
        Set_dig_area()
    elseif MOption ==3 then
        shell.run("/os/programMenu")
    end
end

Main_menu()