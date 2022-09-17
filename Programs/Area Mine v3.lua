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
            for fuelIndex = 1, #fuel, 1 do
                if(item.name == fuel[fuelIndex]) then
                    local fuelValue = fuelIndex[item.name]
                return slotNum, fuelValue
                end
            end
        end
    end
end

function Refuel(min)
    while (turtle.getFuelLevel() < min) do
    local index, fuelValue = getFuelIndex()
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
    local x,y,z = 0,0,0
    local function draw_menu()
        term.clear()
        Header()
        print_centered(2,("Set dig area"))
        Print_left(3,"Width = "..x)
        Print_left(4,"Depth = "..z)
        Print_left(5,"Hight = "..y)
    end
    draw_menu()

    --Get sizes
    Print_left(6,"Please enter Width:")
    term.setCursorPos(1,7)
    x = read("*n")
    term.clear()
    draw_menu()

    Print_left(6,"Please enter Depth:")
    term.setCursorPos(1,7)
    z = read("*n")
    term.clear()
    draw_menu()

    Print_left(6,"Please enter Hight:")
    term.setCursorPos(1,7)
    y = read("*n")
    term.clear()
    draw_menu()

    --Get Directions
    Print_left(6,"Please enter lateral direction:")
    term.setCursorPos(1,7)
    local latDir = read()
    term.clear()
    draw_menu()

    Print_left(6,"Please enter lateral direction:")
    term.setCursorPos(1,7)
    local vertDir = read()
    term.clear()
    draw_menu()

    Curent_dig_area = {
    x = x,
    z = z,
    y = y,
    lat = latDir,
    vert = vertDir
    }
    Main_menu()
end

function Dig()
    local x = tonumber(Curent_dig_area.x)
    local z = tonumber(Curent_dig_area.z)
    local y = tonumber(Curent_dig_area.y)
    if Curent_dig_area.lat == "right" then
        LatDirection = true
    else
        LatDirection = false
    end

    local fuelNeeded = x * z * (math.ceil(y/3))
    Refuel(fuelNeeded)

    local function Mine_row()
        if y >=3 then
            for i = 1, z - 1, 1 do
                turtle.digUp()
                turtle.dig()
                turtle.digDown()
                turtle.forward()
                print(i .. "-" .. z)
            end
        elseif y == 2 then
            for i = 1, z - 1, 1 do
                turtle.digUp()
                turtle.dig()
                turtle.forward()
                print(i .. "-" .. z)
            end
        elseif y == 1 then
            for i = 1, z - 1, 1 do
                turtle.dig()
                turtle.forward()
                print(i .. "-" .. z)
            end
        end
    end

    local function Next_row(direction,curentRow)
        if direction == false then
            if (curentRow% 2 == 1) then
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
            else
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
        elseif direction == true then
            if (curentRow% 2 == 1) then
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
            else
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
        end
    end

--get in start pos
    turtle.up()
    turtle.dig()
    turtle.forward()
--dig loop
    while y >= 1 do
        for i = 1, x, 1 do
            Mine_row()
            if i < x then
                Next_row(LatDirection,i)
            else 
                turtle.digUp()
                turtle.digDown()
            end
        end
        if y >= 3 then
            y = y - 3
        elseif y == 2 then
            y = 2 - 2
        elseif y == 1 then
            y = y - 1
        end
        if y > 0 then
            turtle.turnRight()
            turtle.turnRight()
            if x%2 == 0 then
                LatDirection = not LatDirection
            end
            if y >=3 then
                turtle.up()
                turtle.digUp()
                turtle.up()
                turtle.digUp()
                turtle.up()
            else
                turtle.up()
                turtle.digUp()
                turtle.up()
            end
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