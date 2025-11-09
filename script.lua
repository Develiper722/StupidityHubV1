-- hi
local gameScripts = {
    [78299840360328]  = "https://raw.githubusercontent.com/Develiper722/RetardedHubV1/main/hubwarnings/Protect_a_Friend.lua",
    [134497392943706] = "https://raw.githubusercontent.com/Develiper722/RetardedHubV1/main/hubscripts/Protect_a_Friend.lua",
    [12578778816] = "https://raw.githubusercontent.com/Develiper722/RetardedHubV1/main/hubscripts/Billionaire-Simulator-2.lua"
}

local FALLBACK_HUB = "https://raw.githubusercontent.com/Develiper722/RetardedHubV1/main/hubwarnings/test.lua"

local function looks_like_html(text)
    if not text or type(text) ~= "string" then return false end
    local lower = text:sub(1, 512):lower()
    if lower:find("<!doctype") or lower:find("<html") or lower:find("<meta") then
        return true
    end
    return false
end

local function fetch_script(url)
    if not url or type(url) ~= "string" then return nil, "invalid url" end
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok then return nil, ("HttpGet failed: %s"):format(tostring(response)) end
    if not response or response == "" then return nil, "empty response" end
    if looks_like_html(response) then return nil, "response appears to be HTML" end
    return response, nil
end

local function compile_with_env(code)
    if type(code) ~= "string" then return nil, "code is not string" end
    local loader = loadstring or load
    local ok, chunk_or_err = pcall(loader, code)
    if not ok then return nil, ("compile error: %s"):format(tostring(chunk_or_err)) end
    local chunk = chunk_or_err
    if type(chunk) ~= "function" then return nil, "compiled object is not a function" end

    if setfenv then
        local success, env_err = pcall(setfenv, chunk, getfenv(1))
        if not success then return chunk, ("setfenv failed: %s"):format(tostring(env_err)) end
        return chunk, nil
    else
        local env = (getfenv and getfenv(1)) or {}
        local ok2, reloaded = pcall(function() return load(code, nil, "t", env) end)
        if ok2 and type(reloaded) == "function" then
            return reloaded, nil
        end
        return chunk, "couldn't set env (non-5.1 environment); running chunk as-is"
    end
end

local function run_chunk(chunk)
    if type(chunk) ~= "function" then return false, "chunk is not a function" end
    local ok, err = pcall(chunk)
    if not ok then return false, err end
    return true, nil
end

local function load_entry(entry)
    if not entry then return false, "nil entry" end

    if type(entry) == "function" then
        local ok, err = pcall(entry)
        if not ok then return false, ("function entry error: %s"):format(tostring(err)) end
        return true, nil
    end

    if type(entry) == "string" then
        local code, fetch_err = fetch_script(entry)
        if not code then return false, ("fetch error: %s"):format(fetch_err) end
        local chunk, compile_err = compile_with_env(code)
        if not chunk then return false, ("compile error: %s"):format(tostring(compile_err)) end
        local ok, run_err = run_chunk(chunk)
        if not ok then return false, ("runtime error: %s"):format(tostring(run_err)) end
        return true, nil
    end

    return false, "unsupported entry type"
end

local function load_for_current_game()
    local placeId = game.PlaceId
    local entry = gameScripts[placeId]
    if not entry then
        if FALLBACK_HUB and FALLBACK_HUB ~= "" then
            entry = FALLBACK_HUB
        else
            return false, ("No script mapped for this PlaceId (%s)."):format(tostring(placeId))
        end
    end
    local ok, err = load_entry(entry)
    if not ok then return false, err end
    return true, nil
end

local status, err = load_for_current_game()
if not status then
    warn(err)
end

function hub_load_url(url)
    local ok, err = load_entry(url)
    if not ok then warn(err) end
end

function hub_register(placeId, urlOrFunction)
    if not placeId or not urlOrFunction then return false, "bad args" end
    gameScripts[placeId] = urlOrFunction
    return true
end
