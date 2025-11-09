-- hi again
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

getgenv().StationAuto = getgenv().StationAuto or {
	work = {},
	upgrade = { SU1 = {}, SU10 = {}, SU100 = {} },
	running = true,
	debug = false
}

getgenv().StationAuto.Unload = function()
	getgenv().StationAuto.running = false
	for i = 1, 9 do
		getgenv().StationAuto.work[i] = false
		getgenv().StationAuto.upgrade.SU1[i] = false
		getgenv().StationAuto.upgrade.SU10[i] = false
		getgenv().StationAuto.upgrade.SU100[i] = false
	end
	task.wait(0.05)
end

local Window = Rayfield:CreateWindow({
   Name = "StupidityHubV1's Billionaire Simulator 2 script",
   Icon = 0,
   LoadingTitle = "Made in only 2 hours",
   LoadingSubtitle = "by @system96 on discord",
   ShowText = "StupidHubV1",
   Theme = "Default",
   ConfigurationSaving = { Enabled = false },
})

local hqFolder = workspace:WaitForChild("HQs")
local hq = hqFolder:WaitForChild("HQ1")
local clickRemote = hq:WaitForChild("Clicked")

local WorkTab = Window:CreateTab("Auto Work")
for i = 1, 9 do
	getgenv().StationAuto.work[i] = getgenv().StationAuto.work[i] or false

	WorkTab:CreateToggle({
		Name = "Auto Work on " .. i,
		CurrentValue = getgenv().StationAuto.work[i],
		Flag = "AutoWork" .. i,
		Callback = function(state)
			getgenv().StationAuto.work[i] = state
			if state then
				task.spawn(function()
					while getgenv().StationAuto.running and getgenv().StationAuto.work[i] do
						pcall(function()
							clickRemote:FireServer("SW", i)
						end)
						task.wait(0.1)
					end
				end)
			end
		end,
	})
end

local UpgradeTab = Window:CreateTab("Auto Upgrades")
for i = 1, 9 do
	for _, t in ipairs({ "SU1", "SU10", "SU100" }) do
		getgenv().StationAuto.upgrade[t][i] = getgenv().StationAuto.upgrade[t][i] or false

		UpgradeTab:CreateToggle({
			Name = string.format("%s on %d", t, i),
			CurrentValue = getgenv().StationAuto.upgrade[t][i],
			Flag = "AutoUpgrade_" .. t .. "_" .. i,
			Callback = function(state)
				getgenv().StationAuto.upgrade[t][i] = state
				if state then
					task.spawn(function()
						while getgenv().StationAuto.running and getgenv().StationAuto.upgrade[t][i] do
							pcall(function()
								clickRemote:FireServer(t, i)
							end)
							task.wait(0.2)
						end
					end)
				end
			end,
		})
	end
end

local ControlTab = Window:CreateTab("Control")
ControlTab:CreateButton({
	Name = "Stop All",
	Callback = function()
		getgenv().StationAuto.Unload()
	end,
})

ControlTab:CreateToggle({
	Name = "Debug Logs",
	CurrentValue = getgenv().StationAuto.debug,
	Flag = "StationAutoDebug",
	Callback = function(v)
		getgenv().StationAuto.debug = v
		if v then
			print("[StationAuto] debug enabled")
		end
	end,
})
