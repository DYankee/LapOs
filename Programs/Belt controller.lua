PasteId = "pdf8hCiJ"

function Redstone_clock(side, interval)
    redstone.setOutput(side, true)
    sleep(interval)
    redstone.setOutput(side, false)
    sleep(0.1)
end

while true do
    Redstone_clock("back",2)
end