local tArgs, gUser, gRepo, gPath, gBranch = {...}, nil, nil, "", "master"
local usage = [[
 github <user> <repo> [path] [remote path] [branch]
 Remote path defaults to the root of the repo.
 Path defaults to the download folder.
 Branch defaults to master.
 If you want to leave an option empty use a dot.
 Example: github johnsmith hello-world . foo
 Everything inside the directory foo will be 
 downloaded to downloads/hello-world/.
  ]]
local blackList = [[
@blacklistedfile
]]
 
local title = "Github Repo Downloader"
local fileList = {dirs={},files={}}
local x , y = term.getSize()
 
-- GUI
function printTitle()
    local line = 2
    term.setCursorPos(1,line)
    for i = 2, x, 1 do write("-") end
    term.setCursorPos((x-title:len())/2,line+1)
    print(title)
    for i = 2, x, 1 do write("-") end
end
 
function Write_Center( str )
    term.clear()
    printTitle()
    term.setCursorPos((x-str:len())/2-1,y/2-1)
    for i = -1, str:len(), 1 do write("-") end
    term.setCursorPos((x-str:len())/2-1,y/2)
    print("|"..str.."|")
    term.setCursorPos((x-str:len())/2-1,y/2+1)
    for i = -1, str:len(), 1 do write("-") end
end
 
function Print_Usage()
    local str = "Press space key to continue"
    term.clear()
    printTitle()
    term.setCursorPos(1,y/2-4)
    print(usage)
    term.setCursorPos((x-str:len())/2,y/2+7)
    print(str)
    while true do
        local event, param1 = os.pullEvent("key")
        if param1 == 57 then
            sleep(0)
            break
        end
    end
    term.clear()
    term.setCursorPos(1,1)
end
 
-- Download File
function Download_File( path, url, name )
    Write_Center("Downloading File: "..name)
    DirPath = path:gmatch('([%w%_%.% %-%+%,%;%:%*%#%=%/]+)/'..name..'$')()
    if DirPath ~= nil and not fs.isDir(DirPath) then fs.makeDir(DirPath) end
    local content = http.get(url)
    local file = fs.open(path,"w")
    print(content)
    if content ~= nil then file.write(content.readAll()) end
    file.close()
end
 
-- Get Directory Contents
function Get_Github_Contents( path )
    local pType, pPath, pName, checkPath = {}, {}, {}, {}
    local response = http.get("https://api.github.com/repos/"..gUser.."/"..gRepo.."/contents/"..path.."/?ref="..gBranch)
    if response then
        response = response.readAll()
        if response ~= nil then
            for str in response:gmatch('"type":"(%w+)"') do table.insert(pType, str) end
            for str in response:gmatch('"path":"([^\"]+)"') do table.insert(pPath, str) end
            for str in response:gmatch('"name":"([^\"]+)"') do table.insert(pName, str) end
        end
    else
        Write_Center( "Error: Can't resolve URL" )
        sleep(2)
        term.clear()
        term.setCursorPos(1,1)
        error()
    end
    return pType, pPath, pName
end
 
-- Blacklist Function
function Is_Black_Listed( path )
    if blackList:gmatch("@"..path)() ~= nil then
        return true
    end
end
 
-- Download Manager
function Download_Manager( path )
    local fType, fPath, fName = Get_Github_Contents( path )
    for i,data in pairs(fType) do
        if data == "file" then
            CheckPath = http.get("https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i])
            if CheckPath == nil then
                
                fPath[i] = fPath[i].."/"..fName[i]
            end
            local path = "downloads/"..gRepo.."/"..fPath[i]
            if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
            if not fileList.files[path] and not Is_Black_Listed(fPath[i]) then
                fileList.files[path] = {"https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i],fName[i]}
            end
        end
    end
    for i, data in pairs(fType) do
        if data == "dir" then
            local path = "downloads/"..gRepo.."/"..fPath[i]
            if gPath ~= "" then path = gPath.."/"..gRepo.."/"..fPath[i] end
            if not fileList.dirs[path] then 
                Write_Center("Listing directory: "..fName[i])
                fileList.dirs[path] = {"https://raw.github.com/"..gUser.."/"..gRepo.."/"..gBranch.."/"..fPath[i],fName[i]}
                Download_Manager( fPath[i] )
            end
        end
    end
end
 
-- Main Function
function Main( path )
    Write_Center("Connecting to Github")
    Download_Manager(path)
    for i, data in pairs(fileList.files) do
        Download_File( i, data[1], data[2] )
    end
    Write_Center("Download completed")
    sleep(2,5)
    term.clear()
    term.setCursorPos(1,1)
end
 
-- Parse User Input
function Parse_Input( user, repo , dldir, path, branch )
    if path == nil then path = "" end
    if branch ~= nil then gBranch = branch end
    if repo == nil then Print_Usage()
    else
        gUser = user
        gRepo = repo
        if dldir ~= nil then gPath = dldir end
        Main( path ) 
    end
end
 
if not http then
    Write_Center("You need to enable the HTTP API!")
    sleep(3)
    term.clear()
    term.setCursorPos(1,1)
else
    for i=1, 5, 1 do
        if tArgs[i] == "." then tArgs[i] = nil end
    end 
    Parse_Input( tArgs[1], tArgs[2], tArgs[3], tArgs[4], tArgs[5] )
end