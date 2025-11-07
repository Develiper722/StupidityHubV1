-- Universal Script Hub Loader

-- Table to store scripts for each game
local gameScripts = {
    -- Roblox game PlaceId = script URL or function
    [8892608969] = "https://raw.githubusercontent.com/Develiper722/StupidityHubV1/main/hubscripts/Protect_a_Friend.lua"  
    [78299840360328] = "https://raw.githubusercontent.com/Develiper722/StupidityHubV1/main/hubscripts/Protect_a_Friend.lua"
}

-- Get current game PlaceId
local currentPlaceId = game.PlaceId

-- Check if we have a script for this game
if gameScripts[currentPlaceId] then
    local scriptURL = gameScripts[currentPlaceId]

    -- Load and execute the remote script
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptURL))()
    end)

    if not success then
        warn("Failed to load script: " .. err)
    end
else
    print("No script found for this game.")
end
