--// Universal Script Hub Loader with Debug Info
print("=== Universal Script Hub Loader | by @system96 ===")

-- Table to store scripts for each game
local gameScripts = {
    -- Roblox game PlaceId = script URL or function
    [134497392943706] = "https://raw.githubusercontent.com/Develiper722/StupidityHubV1/main/hubscripts/Protect_a_Friend.lua",
    [78299840360328]  = "https://raw.githubusercontent.com/Develiper722/StupidityHubV1/main/hubscripts/Protect_a_Friend.lua"
}

-- Get current game PlaceId
local currentPlaceId = game.PlaceId
print("Current PlaceId:", currentPlaceId)

-- Debug environment check
print("Checking environment...")
print("loadstring:", loadstring)
print("game.HttpGet:", game.HttpGet)
print("game.HttpGetAsync:", game.HttpGetAsync)

-- Function to safely load and run a remote script
local function safeLoadScript(url)
    print("Fetching script from:", url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("❌ Failed to fetch script:", result)
        return
    end

    if not result or #result == 0 then
        warn("❌ Script returned empty response.")
        return
    end

    print("✅ Script loaded, length:", #result)

    -- Attempt to run it
    local ok, runErr = pcall(function()
        local f = loadstring(result)
        if not f then
            error("loadstring() returned nil – unsupported environment?")
        end
        f()
    end)

    if not ok then
        warn("❌ Error running loaded script:", runErr)
    else
        print("✅ Script executed successfully!")
    end
end

-- Main logic: check if game supported
if gameScripts[currentPlaceId] then
    local scriptURL = gameScripts[currentPlaceId]
    safeLoadScript(scriptURL)
else
    warn("No script found for this game (" .. tostring(currentPlaceId) .. ").")
end
