PasteId = "jJ7xa9hX"

V = settings.get("Version")
local W,H = term.getSize()

-- print centered on x axis
function print_centered(y,s)
    local x = math.floor((W - string.len(s)) /2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Print_left(y,s)
    local x = 1
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Print_right(y,s)
    local x = math.floor(W - string.len(s))
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

Plist = fs.list("/os/programs")
ProgNumber = #Plist

--getsizes
UsedSpace = 9
ListSpace = H - UsedSpace
MOption = 1
PageNum = 1
if ProgNumber <= ListSpace then
    ListLng = ProgNumber
elseif ProgNumber > ListSpace then
    ListLng = ListSpace
end

function Draw_menu()
    term.clear()
    print_centered(1,"Lapis OS " .. V )
    term.setCursorPos(W-11,1)
    term.write(MOption .. " " .. PageNum)
end

--GUI
function Draw_front_end()
    print_centered(math.floor(H/2) - 3, "")
    print_centered(math.floor(H/2) - 2, "Manage programs")
    print_centered(math.floor(H/2) - 1, "")
    print_centered(math.floor(H/2) + 0, ((MOption == 1 and "[ Add program    ]") or " Add program    " ))
    print_centered(math.floor(H/2) + 1, ((MOption == 2 and "[ Remove program ]") or " Remove program " ))
    print_centered(math.floor(H/2) + 2, ((MOption == 3 and "[ Update program ]") or " Update program " ))
    print_centered(math.floor(H/2) + 3, "")
    print_centered(math.floor(H/2) + 4, ((MOption == 4 and "[ Back ]") or " Back " ))
end

function Draw_prog_menu()
    ProgLeft = ProgNumber - (ListLng * (PageNum - 1))
    print_centered(2, "")
    print_centered(3, "select program")
    print_centered(4, "")
    if ProgNumber <= ListSpace then
        for i = 1, ProgNumber, 1 do
            print_centered(4 + i, ((MOption == i and "[ " .. Plist[i] .. " ]") or Plist[i]))
        end
        print_centered(H, ((MOption == ProgNumber + 1 and "[ Back ]") or " Back " ))
    elseif ProgNumber > ListSpace then
        if PageNum == 1 then
            for i = 1, ListSpace, 1 do
                print_centered(4 + i, ((MOption == i and "[ " .. Plist[i] .. " ]") or Plist[i]))
            end
            print_centered(H - 4 ,((MOption == ListLng + 1 and "[Next page]") or "Next page"))
            print_centered(H, ((MOption == ListLng + 2 and "[ Back ]") or " Back " ))
        elseif PageNum > 1 then
            if ProgLeft > ListLng then
                Ci = ListLng * (PageNum - 1)
                for i = Ci + 1, ListLng + Ci, 1 do
                    print_centered(4 + i - Ci, ((MOption == i - Ci and "[ " .. Plist[i] .. " ]") or Plist[i]))
                end
                print_centered(H - 4,((MOption == ListLng + 1 and "[Next page]") or "Next page"))
                print_centered(H - 3,((MOption == ListLng + 2 and "[Prev page]") or "Prev page"))
                print_centered(H, ((MOption == ListLng + 3 and "[ Back ]") or " Back " ))
            elseif ProgLeft <= ListLng then
                Ci = ListLng * (PageNum - 1)
                for i = Ci + 1, ProgLeft + Ci, 1 do
                    print_centered(4 + i - Ci, ((MOption == i - Ci  and "[ " .. Plist[i] .. " ]") or Plist[i]))
                end
                print_centered(H - 4,((MOption == ProgLeft + 1 and "[Prev page]") or "Prev page"))
                print_centered(H, ((MOption == ProgLeft + 2 and "[ Back ]") or " Back " ))
            end
        end
    end
end

function Get_menu_input(max, whichMenu)
    while true do
        local event, key = os.pullEvent()
        if event == "key" then
            if key == 265 or key == 87 then
                if MOption > 1 then
                    MOption = MOption - 1
                    Draw_menu()
                    whichMenu()
                end
            elseif key == 264 or key == 83 then
                if MOption < max then
                    MOption = MOption + 1
                    Draw_menu()
                    whichMenu()
                end
            elseif key == 257 then
                break
            end
        end
    end
end

function Add_program()
    term.clear()
    print_centered(math.floor(H/2) - 6, "Add Program")
    Print_left(math.floor(H/2) - 5, "Enter program name")
    term.setCursorPos(1,(math.floor(H/2) - 4))
    local programName = read()
    term.setCursorPos(1,1)
    term.write(programName)
    Print_left(math.floor(H/2) - 3, "Enter pastebin directory")
    term.setCursorPos(1,(math.floor(H/2) - 2))
    local paste = read()
    shell.run("pastebin", "get", paste, "/os/programs/"..programName)
    Print_left(math.floor(H/2) ,"Program Installed")
    sleep(3)
    shell.run("/os/managePrograms")
end

function Delete_program()
    MOption = 1
    local menu = Draw_prog_menu
    Draw_menu()
    menu()
    Ci = ListLng * (PageNum - 1)
    while true do
        if ProgNumber <= ListSpace then
            Get_menu_input(ProgNumber + 1, menu )
            if MOption <= ProgNumber then
                fs.delete("/os/programs/"..Plist[MOption])
                shell.run("/os/managePrograms")
            elseif MOption == ProgNumber + 1 then
                shell.run("/os/managePrograms")
            end
        elseif ProgNumber > ListSpace then
            if PageNum == 1 then
                Get_menu_input(ListLng + 2, menu)
                if MOption <= ListLng then
                    fs.delete("/os/programs/"..Plist[MOption])
                    shell.run("/os/managePrograms")
                elseif MOption == ListLng + 1 then
                    PageNum = PageNum + 1
                    MOption = 1
                    Draw_menu()
                    menu()
                elseif MOption == ListLng + 2 then
                    shell.run("/os/managePrograms")
                end
            elseif PageNum > 1 then
                if ProgLeft > ListLng then
                    Get_menu_input(ListLng + 3, menu)
                    if MOption <= ListLng then
                        fs.delete("/os/programs/"..Plist[MOption + Ci])
                        shell.run("/os/managePrograms")
                    elseif MOption == ListLng + 1 then
                        PageNum = PageNum + 1
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ListLng + 2 then
                        PageNum = PageNum - 1
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ListLng + 3 then
                        shell.run("/os/managePrograms")
                    end
                elseif ProgLeft <= ListLng then
                    Get_menu_input(ProgLeft + 2, menu)
                    if MOption <= ProgLeft then
                        fs.delete("/os/programs/"..Plist[MOption + Ci])
                        shell.run("/os/managePrograms")
                    elseif MOption == ProgLeft + 1 then
                        if PageNum > 1 then
                            PageNum = PageNum - 1
                        end
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ProgLeft + 2 then
                        shell.run("/os/managePrograms")
                    end
                end
            end
        end
    end
end

function Update_program()
    Ci = ListLng * (PageNum - 1)
    function Update()
        local file = fs.open("/os/programs/"..Plist[MOption + Ci], "r")
        local pastId = file.readLine()
        file.close()
        local pName = Plist[MOption]
        fs.delete("/os/programs/"..Plist[MOption])
        shell.run("pastebin", "get", string.sub(pastId,10), "/os/programs/"..pName)
        shell.run("/os/managePrograms")
    end
    MOption = 1
    local menu = Draw_prog_menu
    Draw_menu()
    menu()
    while true do
        if ProgNumber <= ListSpace then
            Get_menu_input(ProgNumber + 1, menu )
            if MOption <= ProgNumber then
                Update()
                shell.run("/os/managePrograms")
            elseif MOption == ProgNumber + 1 then
                shell.run("/os/managePrograms")
            end
        elseif ProgNumber > ListSpace then
            if PageNum == 1 then
                Get_menu_input(ListLng + 2, menu)
                if MOption <= ListLng then
                    Update()
                    shell.run("/os/managePrograms")
                elseif MOption == ListLng + 1 then
                    PageNum = PageNum + 1
                    MOption = 1
                    Draw_menu()
                    menu()
                elseif MOption == ListLng + 2 then
                    shell.run("/os/managePrograms")
                end
            elseif PageNum > 1 then
                if ProgLeft > ListLng then
                    Get_menu_input(ListLng + 3, menu)
                    if MOption <= ListLng then
                        Update()
                        shell.run("/os/managePrograms")
                    elseif MOption == ListLng + 1 then
                        PageNum = PageNum + 1
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ListLng + 2 then
                        PageNum = PageNum - 1
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ListLng + 3 then
                        shell.run("/os/managePrograms")
                    end
                elseif ProgLeft <= ListLng then
                    Get_menu_input(ProgLeft + 2, menu)
                    if MOption <= ProgLeft then
                        Update()
                        shell.run("/os/managePrograms")
                    elseif MOption == ProgLeft + 1 then
                        if PageNum > 1 then
                            PageNum = PageNum - 1
                        end
                        MOption = 1
                        Draw_menu()
                        menu()
                    elseif MOption == ProgLeft + 2 then
                        shell.run("/os/managePrograms")
                    end
                end
            end
        end
    end
end

MOption = 1
Draw_menu()
Draw_front_end()
Get_menu_input(4, Draw_front_end)
if MOption == 1 then
    Add_program()
elseif MOption == 2 then
    Delete_program()
elseif MOption == 3 then
    Update_program()
elseif MOption == 4 then
    shell.run("/os/programMenu")
end