-- holy fucking shit, FINALLY I MADE IT WORK

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

getgenv().StationAuto = getgenv().StationAuto or {
	work = {},
	upgrade = { SU1 = {}, SU10 = {}, SU100 = {} },
	running = true,
	debug = false
}

-- quick unload so i don't have to rejoin this fucking game every 5 minutes
-- i forgot i done this so i rejoined every time i changed anything fuck me
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
	Name = "auto do stuff",
	ConfigurationSaving = { Enabled = false },
})

-- WaitForChild chain: if this blows up, it's probs my code's fault this time, 
local hqFolder = workspace:WaitForChild("HQs")
local hq = hqFolder:WaitForChild("HQ1")
local clickRemote = hq:WaitForChild("Clicked")

-- ===== AUTO WORK TAB =====
-- goddamn 9 toggles, why did i agree to do this
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
					-- if this loop spams like an idiot, blame the tiny wait and my impatience
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

-- ===== AUTO UPGRADE TAB =====
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
						-- okay this is the one that used to murder servers. handle with caution, you reckless ape.
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

-- ===== CONTROL TAB =====
-- yay it all workie now!
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

-- if you toggle everything at once you are a monster
-- this ran at 3am while listening to shitty lo-fi and regretting my life choices
-- if warnings pop up, close your eyes, chant "it works" and keep going
-- fucking FINALLY I MADE IT WORK
