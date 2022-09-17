chests = {
    "quark:oak_chest",
    "charm:oak_chest",
}
 
fuel = {
    "minecraft:coal_block",
    "actuallyadditions:block_misc",
    "quark:charcoal_block",
    "thermal:charcoal_block",
}
 
crop = "pamhc2crops:radishitem"
 
function checkAge()
    local isBlock, data = turtle.inspect()
    if (data['state']['age'] == 7)
    then
        isgrown = true
    elseif (data['state']['age'] ~= 7)
    then
        isgrown = false
    end
end
 
function getFuelIndex()
    for slotNum = 1, 16, 1 do
        local Item = turtle.getItemDetail(slotNum)
        if(Item ~=nil) then
            for fuelIndex = 1, #fuel, 1 do
                if(Item.name == fuel[fuelIndex]) then
                return slotNum
                end
            end
        end
    end
end
 
function refuel()
    fIndex = getFuelIndex()
    fCount = turtle.getItemCount(fIndex)
    while fCount == nil or fCount < 4 do
        print("Out of Fuel1")
        turtle.suckUp(30)
        fIndex = getFuelIndex()
        fCount = turtle.getItemCount(fIndex)
            if fCount == nil or fCount < 4 then
                sleep(60)
            end
    end
    if(turtle.getFuelLevel() < 400) then
        fIndex = getFuelIndex()
        if(fIndex ~= nil) then
        turtle.select(fIndex)
         turtle.refuel(2)
        end
    elseif fIndex == nil then
        while fIndex == nil do
            print("Out of fuel2")
            refuel()
        end
    end
end
 
function getCropIndex()
    for slotNum = 1, 16, 1 do
        local item = turtle.getItemDetail(slotNum)
        if(item ~=nil) then
            if(item["name"] == crop) then
                return slotNum
            end
        end
    end
end
 
function harvestRow()
    RL = 6
    checkAge()
    while isgrown ~= true do
        sleep(10)
        checkAge()
    end
    if isgrown == true then
        for CB = 1, RL -1, 1 do
            checkAge()
            if isgrown == true then
                turtle.dig()
                turtle.suck()
                turtle.suck()
                cropSlot = getCropIndex()
                turtle.select(cropSlot)
                turtle.place()
                local cropNum = turtle.getItemCount()
                if cropNum > 4 then
                    turtle.dropDown(cropNum - 1)
                end
            end
            turtle.turnLeft()
            turtle.forward()
            turtle.turnRight()
        end
        checkAge()
        if isgrown == true then
            turtle.dig()
            turtle.suck()
            turtle.suck()
            cropSlot = getCropIndex()
            turtle.select(cropSlot)
            turtle.place()
            local seedNum = turtle.getItemCount()
            turtle.dropDown(seedNum - 1)
        end
    end
end
 
function harvest()
    harvestRow()
    turtle.turnLeft()
    turtle.turnLeft()
    harvestRow()
    refuel()
    turtle.turnLeft()
    turtle.turnLeft()
end
while true do
    harvest()
end