Version = 0.4
PastBinAddress = "mEC0veuM"

settings.set("Version", Version)
settings.save(".OsSettings")
settings.load(".OsSettings")
term.clear()
term.setCursorPos(1,1)
print("loading Lapis OS " .. Version)
term.setCursorPos(1,2)
sleep(1)
textutils.slowPrint("########")
sleep(1)
Version = "Version"

if fs.isDir("/os") == false then
    fs.makeDir"/os"
end

if fs.isDir("/os/programs") == false then
    fs.makeDir"/os/programs"
end


--update os
fs.delete("startUp")
shell.run("pastebin", "get", "mEC0veuM", "startUp")

fs.delete("/os/menu")
shell.run("pastebin", "get", "vBSUkhP1","/os/menu")

fs.delete("/os/programMenu")
shell.run("pastebin", "get", "AHEsJqjW","/os/programMenu")

fs.delete("/os/managePrograms")
shell.run("pastebin", "get", "jJ7xa9hX","/os/managePrograms")

fs.delete("/os/modules/FreqFunc")
shell.run("pastebin", "get", "vN3NrXdp", "/os/modules/FreqFunc")

shell.run("/os/menu")
