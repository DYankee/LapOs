Modem.open(1)
local listen = true



while listen == true do
    local event, side, channel, replyChannel, message, distance
repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
until channel == 1
print(tostring(message))
end