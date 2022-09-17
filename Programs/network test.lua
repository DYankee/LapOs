local modem = peripheral.find("modem")
modem.open(100)

while true do
    local event, side ,channel, replyChannel, message, distance = os.pullEvent("modem_message")
    print(message .. " sent from: " .. replyChannel)
end