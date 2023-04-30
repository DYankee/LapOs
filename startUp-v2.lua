Version = 0.5


term.clear()
term.setCursorPos(1,1)
print("loading LapOs " .. Version)
term.setCursorPos(1,2)
sleep(1)
textutils.slowPrint("########")
sleep(1)

settings.set("Version", Version)
settings.save(".OsSettings")
settings.load(".OsSettings")


--update os
fs.delete("startUp")
shell.run("pastebin", "get", "mEC0veuM", "startUp")
fs.delete("/os/menu")
shell.run("pastebin", "get", "vBSUkhP1","/os/menu")