--delcare variables
local termWidth, termHeight = term.getSize()
local mOption = 2
local running = true

function Print_centered(y,s)
    local x = math.floor((termWidth - string.len(s)) /2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
 end

-- mainmenu methods
function Choice_1()
    term.clear()
    shell.run("lua")
end

function Choice_2()
    local temp = "WIP"
    term.clear()
    Print_centered(6, temp)
    sleep(2)
end

function Choice_3()
    
end

function Exit()
    running = false
end

--ProgramMenu methods
function Next_page()
    
end

function Prev_page()
    
end

function Close_menu()
    
end

--Menu definitions
MainMenu = {
    [1] = {text = "Command Line", handler = Choice_1},
    [2] = {text = "Program List", handler = Choice_2},
    [3] = {text = "Settings", handler = Choice_3},
    [4] = {text = "Exit",handler = Exit}
}

ProgramMenu = {
    [1] = {text = "", handler = shell.run()},
    [2] = {text = "next page", handler = Next_page},
    [3] = {text = "prev page", handler = Prev_page},
    [4] = {text = "go back", handler = Close_menu},
}

-- printing methods
function Print_menu(menu)
    for i = 1, #menu do
        if i == mOption then
                print(">> "..menu[i].text)
            else
                print("   "..menu[i].text)
        end
    end
end

-- handler method
function On_key_pressed(key, menu)
    if key == keys.enter then
        On_mOption(menu)
    elseif key == keys.up or key == keys.w then
        if mOption > 1 then
            mOption = mOption - 1
        end
    elseif key == keys.down or key == keys.s then
        if mOption < #menu then
            mOption = mOption + 1
        end
    end
end

function On_mOption(menu)
    menu[mOption].handler()
end

-- main method

function Draw_Main_Menu()
    while running == true do
        term.clear()
        term.setCursorPos(1,1)
        Print_menu(MainMenu)
        local event, key = os.pullEvent("key")
        On_key_pressed(key, MainMenu)
    end
end

function Draw_proggram_menu()
    local isRunning = true
    while isRunning == true do
        
    end
end


Draw_Main_Menu()