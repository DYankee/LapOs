PasteId = "MqegTrzh"
package.path = package.path .. ";/os/modules/FreqFunc"
FreqFunc = require(".os.modules.FreqFunc")
local monitor = peripheral.find("monitor")
local modem = peripheral.find("modem")


term.redirect(monitor)
W,H = term.getSize()

FreqFunc.reset()
term.setCursorPos(1,3)
FreqFunc.print_centered("this is a test")
sleep(3)