--// Rayfield UI by @system96 on Discord

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Breakables & Utilities | by @system96",
	LoadingTitle = "Loading System96 UI",
	LoadingSubtitle = "Breakables, Campfire, Bridge, Potion",
	ConfigurationSaving = { Enabled = false },
})

--// Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local ContribTab = Window:CreateTab("Contributions", 4483362458)
local PotionTab = Window:CreateTab("Potions", 4483362458)
local AutoTab = Window:CreateTab("Automation", 4483362458)

--// Services
local rs = game:GetService("ReplicatedStorage")
local remotes = rs:WaitForChild("Remotes")

--// Variables
local currentBreakables = {}
local autoBreak = false
local autoCampfire = false
local autoBridge = false
local autoPotion = false
local autoShaman = false

--// Utility Functions
local function fetchBreakables()
	local breakables = workspace:WaitForChild("Breakables")
	currentBreakables = {}

	for _, folder in ipairs(breakables:GetChildren()) do
		if folder:IsA("Folder") then
			table.insert(currentBreakables, folder)
		end
	end

	Rayfield:Notify({
		Title = "Refetched Breakables",
		Content = "Found " .. tostring(#currentBreakables) .. " breakables.",
		Duration = 3,
		Image = 4483362458
	})
end

local function fireTool(toolName)
	if #currentBreakables == 0 then
		fetchBreakables()
	end

	local remote = remotes:FindFirstChild("Tool")
	if remote then
		remote:FireServer(currentBreakables, 10, toolName)
	end
end

local function contribute(remoteName, resource, amount)
	local remote = remotes:FindFirstChild(remoteName)
	if remote then
		remote:FireServer(resource, amount)
	end
end

local function callRemote(remoteName, resource)
	local remote = remotes:FindFirstChild(remoteName)
	if remote then
		remote:FireServer(resource)
	end
end

--// === MAIN TAB ===
MainTab:CreateButton({
	Name = "Refetch Breakables",
	Callback = fetchBreakables
})

MainTab:CreateButton({
	Name = "Break Wood (Golden Axe)",
	Callback = function() fireTool("Golden Axe") end
})

MainTab:CreateButton({
	Name = "Break Stone (Golden Pickaxe)",
	Callback = function() fireTool("Golden Pickaxe") end
})

--// === CONTRIBUTIONS TAB ===
ContribTab:CreateButton({
	Name = "Contribute 100 Logs to Campfire",
	Callback = function() contribute("CampfireContribution", "Logs", 100) end
})

ContribTab:CreateButton({
	Name = "Contribute 100 Stone to Campfire",
	Callback = function() contribute("CampfireContribution", "Stone", 100) end
})

ContribTab:CreateButton({
	Name = "Contribute 10 Logs to Bridge",
	Callback = function() contribute("BridgeContribution", "Logs", 10) end
})

ContribTab:CreateButton({
	Name = "Contribute 10 Stone to Bridge",
	Callback = function() contribute("BridgeContribution", "Stone", 10) end
})

--// === POTION TAB ===
PotionTab:CreateButton({
	Name = "Use Potion (Logs)",
	Callback = function() callRemote("UsePotion", "Logs") end
})

PotionTab:CreateButton({
	Name = "Use Potion (Stone)",
	Callback = function() callRemote("UsePotion", "Stone") end
})

PotionTab:CreateButton({
	Name = "Grab (Logs) Potion",
	Callback = function() callRemote("Shaman", "Logs") end
})

PotionTab:CreateButton({
	Name = "Grab (Stone) Potion",
	Callback = function() callRemote("Shaman", "Stone") end
})

--// === AUTOMATION TAB ===
AutoTab:CreateToggle({
	Name = "Auto Break (Golden Axe / Pickaxe)",
	CurrentValue = false,
	Callback = function(v) autoBreak = v end
})

AutoTab:CreateToggle({
	Name = "Auto Campfire Contribute",
	CurrentValue = false,
	Callback = function(v) autoCampfire = v end
})

AutoTab:CreateToggle({
	Name = "Auto Bridge Contribute",
	CurrentValue = false,
	Callback = function(v) autoBridge = v end
})

AutoTab:CreateToggle({
	Name = "Auto Potion Use",
	CurrentValue = false,
	Callback = function(v) autoPotion = v end
})

AutoTab:CreateToggle({
	Name = "Auto Potion Grab",
	CurrentValue = false,
	Callback = function(v) autoShaman = v end
})

--// Auto Loop
task.spawn(function()
	while task.wait(3) do
		if autoBreak then
			fireTool("Golden Axe")
			fireTool("Golden Pickaxe")
		end
		if autoCampfire then
			contribute("CampfireContribution", "Logs", 100)
			contribute("CampfireContribution", "Stone", 100)
		end
		if autoBridge then
			contribute("BridgeContribution", "Logs", 10)
			contribute("BridgeContribution", "Stone", 10)
		end
		if autoPotion then
			callRemote("UsePotion", "Logs")
			callRemote("UsePotion", "Stone")
		end
		if autoShaman then
			callRemote("Shaman", "Logs")
			callRemote("Shaman", "Stone")
		end
	end
end)

--// Init
fetchBreakables()
