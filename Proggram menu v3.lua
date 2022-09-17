PasteId = "AHEsJqjW"

--initialze
V = settings.get("Version")
W,H = term.getSize()

--text pos func
function Print_left(y,s)
    local w,h = term.getSize()
    local x = 1
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function print_centered(y,s)
    local w,h = term.getSize()
    local x = math.floor((w - string.len(s)) /2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

function Print_right(y,s)
    local w,h = term.getSize()
    local x = math.floor(w - string.len(s))
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

--Get program list
if fs.isDir("/os/programs") == false then
    fs.makeDir"/os/programs"
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
function Get_list_space()
    ListSpace = H - UsedSpace
    if ProgNumber <= ListSpace then
        ListLng = ProgNumber
    elseif ProgNumber > ListSpace then
        ListLng = ListSpace
    end
end

--Draw menu function
function Draw_menu()
    term.clear()
    print_centered(1,"Lapis OS " .. V )
    term.setCursorPos(W-11,1)
    term.write(MOption .. " " .. PageNum)
end

function Draw_prog_menu()
    Get_list_space()
    ProgLeft = ProgNumber - (ListLng * (PageNum - 1))
    print_centered(2, "")
    print_centered(3, "Program list")
    print_centered(4, "")
    if ProgNumber <= ListSpace then
        for i = 1, ProgNumber, 1 do
            print_centered(4 + i, ((MOption == i and "[ " .. Plist[i] .. " ]") or Plist[i]))
        end
        print_centered(H - 1, ((MOption == ProgNumber + 1 and "[ Manage Programs ]") or "Manage Programs"))
        print_centered(H, ((MOption == ProgNumber + 2 and "[ Back ]") or " Back " ))
    elseif ProgNumber > ListSpace then
        if PageNum == 1 then
            for i = 1, ListSpace, 1 do
                print_centered(4 + i, ((MOption == i and "[ " .. Plist[i] .. " ]") or Plist[i]))
            end
            print_centered(H - 4 ,((MOption == ListLng + 1 and "[Next page]") or "Next page"))
            print_centered(H - 1, ((MOption == ListLng + 2 and "[ Manage Programs ]") or "Manage Programs"))
            print_centered(H, ((MOption == ListLng + 3 and "[ Back ]") or " Back " ))
        elseif PageNum > 1 then
            if ProgLeft > ListLng then
                Ci = ListLng * (PageNum - 1)
                for i = Ci + 1, ListLng + Ci, 1 do
                    print_centered(4 + i - Ci, ((MOption == i - Ci and "[ " .. Plist[i] .. " ]") or Plist[i]))
                end
                print_centered(H - 4,((MOption == ListLng + 1 and "[Next page]") or "Next page"))
                print_centered(H - 3,((MOption == ListLng + 2 and "[Prev page]") or "Prev page"))
                print_centered(H - 1,((MOption == ListLng + 3 and "[ Manage Programs ]") or "Manage Programs"))
                print_centered(H, ((MOption == ListLng + 4 and "[ Back ]") or " Back " ))
            elseif ProgLeft <= ListLng then
                Ci = ListLng * (PageNum - 1)
                for i = Ci + 1, ProgLeft + Ci, 1 do
                    print_centered(4 + i - Ci, ((MOption == i - Ci  and "[ " .. Plist[i] .. " ]") or Plist[i]))
                end
                print_centered(H - 4,((MOption == ProgLeft + 1 and "[Prev page]") or "Prev page"))
                print_centered(H - 1,((MOption == ProgLeft + 2 and "[ Manage Programs ]") or "Manage Programs"))
                print_centered(H, ((MOption == ProgLeft + 3 and "[ Back ]") or " Back " ))
            end
        end
    end
end


--Display
PageNum = 1
Draw_menu()
Draw_prog_menu()

--get user imput for menu


--menu logic
function Get_menu_input()
    function Get_menu_input_P1(max)
        while true do
            local event, key = os.pullEvent()
            if event == "key" then
                if key == 265 or key == 87 then
                    if MOption > 1 then
                        MOption = MOption - 1
                        Draw_menu()
                        Draw_prog_menu()
                    end
                elseif key == 264 or key == 83 then
                    if MOption < max then
                        MOption = MOption + 1
                        Draw_menu()
                        Draw_prog_menu()
                    end
                elseif key == 257 then
                    break
                end
            end
        end
    end
    while true do
        if ProgNumber <= ListSpace then
            Get_menu_input_P1(ProgNumber + 2)
            break
        elseif ProgNumber > ListSpace then
            if PageNum == 1 then
                Get_menu_input_P1(ListLng + 3)
                break
            elseif PageNum > 1 then
                if ProgLeft > ListLng then
                    Get_menu_input_P1(ListLng + 4)
                    break
                elseif ProgLeft <= ListLng then
                    Get_menu_input_P1(ProgLeft + 3)
                    break
                end
            end
        end
    end
end

function Menu_logic()
    Ci = ListLng * (PageNum - 1)
    if ProgNumber <= ListSpace then
        if MOption <= ProgNumber then
            os.run({}, "/os/programs/"..Plist[MOption + Ci])
            Run = false
        elseif MOption == ProgNumber + 1 then
            shell.run("/os/managePrograms")
        elseif MOption == ProgNumber + 2 then
            shell.run("/os/menu")
        end
    elseif ProgNumber > ListSpace then
        if PageNum == 1 then
            if MOption <= ListLng then
                os.run({}, "/os/programs/"..Plist[MOption + Ci])
                Run = false
            elseif MOption == ListLng + 1 then
                PageNum = PageNum + 1
                MOption = 1
                Draw_menu()
                Draw_prog_menu()
            elseif MOption == ListLng + 2 then
                shell.run("/os/managePrograms")
            elseif MOption == ListLng + 3 then
                shell.run("/os/menu")
            end
        elseif PageNum > 1 then
            if ProgLeft > ListLng then
                if MOption <= ListLng then
                    os.run({}, "/os/programs/"..Plist[MOption + Ci])
                    Run = false
                elseif MOption == ListLng + 1 then
                    PageNum = PageNum + 1
                    MOption = 1
                    Draw_menu()
                    Draw_prog_menu()
                elseif MOption == ListLng + 2 then
                    PageNum = PageNum - 1
                    MOption = 1
                    Draw_menu()
                    Draw_prog_menu()
                elseif MOption == ListLng + 3 then
                    shell.run("/os/managePrograms")
                elseif MOption == ListLng + 4 then
                    shell.run("/os/menu")
                end
            elseif ProgLeft <= ListLng then
                if MOption <= ProgLeft then
                    os.run({}, "/os/programs/"..Plist[MOption + Ci])
                    Run = false
                elseif MOption == ProgLeft + 1 then
                    PageNum = PageNum - 1
                    MOption = 1
                    Draw_menu()
                    Draw_prog_menu()
                elseif MOption == ProgLeft + 2 then
                    shell.run("/os/managePrograms")
                elseif MOption == ProgLeft + 3 then
                    shell.run("/os/menu")
                end
            end
        end
    end
end

function Run()
    Draw_menu()
    Draw_prog_menu()
    Run = true
    while true do
        Get_menu_input()
        Menu_logic()
    end
end
Run()