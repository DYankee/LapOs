local args = {...}

function Gitget()

    local urlparts = {
        repoOwner = "DYankee",
        repoName = "LapOs",
        branch = "main",
    }
    local url = "https://raw.githubusercontent.com/" .. urlparts.repoOwner .. "/" .. urlparts.repoName .. "/" .. urlparts.branch .. "/" .. args[1]
    local response = http.get(url)
    if response then
      local fileContents = response.readAll()
      response.close()
      local file = fs.open(args[2], "w")
      file.write(fileContents)
      file.close()
      print("File downloaded successfully!")
    else
      print("Error: Failed to connect to GitHub API")
    end
  end

Gitget()