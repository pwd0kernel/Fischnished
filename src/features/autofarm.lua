-- Auto Farm Feature Module
-- Handles automated fishing functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local AutoFarm = {}
local Services = _G.Fischnished.core.services

function AutoFarm.createUI()
    local HacksTab = _G.Fischnished.UI.Tabs.Hacks
    
    HacksTab:CreateToggle({
        Name = "Auto Farm",
        CurrentValue = false,
        Flag = "AutoFarmToggle",
        Callback = function(Value)
            AutoFarm.toggle(Value)
        end,
    })

    HacksTab:CreateSlider({
        Name = "Shake Multiplier",
        Range = {1, 50},
        Increment = 1,
        Suffix = "x",
        CurrentValue = 10,
        Flag = "ShakeMultiplierSlider",
        Callback = function(Value)
            Services.State.shakeMultiplier = Value
        end,
    })

    HacksTab:CreateToggle({
        Name = "Stealth Mode",
        CurrentValue = false,
        Flag = "StealthModeToggle",
        Callback = function(Value)
            AutoFarm.toggleStealth(Value)
        end,
    })

    HacksTab:CreateSlider({
        Name = "Human Delay (ms)",
        Range = {50, 500},
        Increment = 10,
        Suffix = "ms",
        CurrentValue = 150,
        Flag = "HumanDelaySlider",
        Callback = function(Value)
            Services.State.enabledFlags["HumanDelayMS"] = Value
        end,
    })

    HacksTab:CreateToggle({
        Name = "Random Failures",
        CurrentValue = false,
        Flag = "RandomFailuresToggle",
        Callback = function(Value)
            Services.State.enabledFlags["RandomFailures"] = Value
            if Value then
                print("🎲 Random failures enabled - will occasionally miss to appear human")
            else
                print("🎲 Random failures disabled")
            end
        end,
    })

    HacksTab:CreateToggle({
        Name = "Auto Sell",
        CurrentValue = false,
        Flag = "AutoSellToggle",
        Callback = function(Value)
            AutoFarm.toggleAutoSell(Value)
        end,
    })

    HacksTab:CreateButton({
        Name = "Sell Now",
        Callback = function()
            AutoFarm.sellNow()
        end,
    })
end

function AutoFarm.toggle(enabled)
    Services.State.enabledFlags["AutoFarm"] = enabled
    
    if enabled then
        Services.State.autoFarmLoop = task.spawn(function()
            AutoFarm.farmLoop()
        end)
        print("🎣 Auto Farm started")
    else
        Services.cleanupConnection("autoFarmLoop")
        print("🎣 Auto Farm stopped")
    end
end

function AutoFarm.farmLoop()
    while Services.State.enabledFlags["AutoFarm"] do
        -- Get human delay setting or use default
        local humanDelayBase = Services.State.enabledFlags["HumanDelayMS"] or 150
        local humanDelay = (humanDelayBase + math.random(-20, 20)) / 1000
        task.wait(humanDelay)

        local character = Services.getCharacter()
        if character then
            local tool = Services.getTool()
            if tool then
                -- Check for random failures if enabled (reduced failure rate)
                local shouldFail = Services.State.enabledFlags["RandomFailures"] and (math.random(1, 100) <= 3) -- 3% failure rate

                if not shouldFail then
                    AutoFarm.performCast(tool)
                    AutoFarm.handleShakeUI()
                    AutoFarm.handleReel(tool)
                else
                    -- Minimal intentional failures
                    print("🎲 Brief pause for realism")
                    task.wait(math.random(500, 1000) / 1000)
                end
            end
        end
        
        -- Moderate delay between fishing cycles
        local cycleDelay = math.random(200, 600) / 1000
        if Services.State.enabledFlags["StealthMode"] then
            cycleDelay = cycleDelay * 1.2 -- Only 20% longer in stealth
        end
        task.wait(cycleDelay)
    end
end

function AutoFarm.performCast(tool)
    Services.safePcall(function()
        local castPower = 100 -- Keep high success rate
        local castDirection = 1 -- Keep consistent for better success
        
        -- Add slight delay for realism
        local castDelay = math.random(50, 150) / 1000
        task.wait(castDelay)
        
        -- In stealth mode, add slight variation but keep effective
        if Services.State.enabledFlags["StealthMode"] then
            castPower = math.random(95, 100) -- Still very effective
            castDirection = math.random(1, 2) -- Limited variation
        end
        
        tool.events.cast:FireServer(castPower, castDirection)
    end)
end

function AutoFarm.handleShakeUI()
    Services.safePcall(function()
        local shakeui = Services.PlayerGui:FindFirstChild("shakeui")
        if shakeui and shakeui:FindFirstChild("safezone") and shakeui.safezone:FindFirstChild("button") then
            -- Minimal delay before shaking
            local preShakeDelay = math.random(50, 150) / 1000
            task.wait(preShakeDelay)
            
            -- Effective shake multiplier
            local effectiveShakeMultiplier = Services.State.shakeMultiplier
            if Services.State.enabledFlags["StealthMode"] then
                effectiveShakeMultiplier = math.max(Services.State.shakeMultiplier, 5) -- Ensure minimum effectiveness
                effectiveShakeMultiplier = math.min(effectiveShakeMultiplier, 20) -- Cap for realism
            end
            
            for i = 1, effectiveShakeMultiplier do
                local shakeDelay = math.random(20, 80) / 1000 -- Faster shaking
                task.wait(shakeDelay)
                
                -- High success rate shaking (only miss 1% of the time)
                local shakeMissChance = Services.State.enabledFlags["RandomFailures"] and 1 or 0
                if math.random(1, 100) > shakeMissChance then
                    shakeui.safezone.button.shake:FireServer()
                end
            end
        end
    end)
end

function AutoFarm.handleReel(tool)
    if Services.PlayerGui:FindFirstChild("reel") then
        Services.safePcall(function()
            -- Quick response to reel
            local reelDelay = math.random(100, 300) / 1000
            task.wait(reelDelay)
            
            -- High success reel completion
            local reelSuccess = 100 -- Perfect reel for reliability
            local perfectCatch = true -- Always perfect for maximum efficiency
            
            -- In stealth mode, add slight variation but keep very effective
            if Services.State.enabledFlags["StealthMode"] then
                reelSuccess = math.random(95, 100)
                perfectCatch = math.random(1, 100) <= 90 -- 90% perfect catch rate
            end
            
            -- Minimal random failures for reel (only 1%)
            if Services.State.enabledFlags["RandomFailures"] and math.random(1, 100) <= 1 then
                reelSuccess = math.random(80, 95)
                perfectCatch = false
                print("🎲 Slight reel variation for realism")
            end
            
            Services.ReplicatedStorage.events["reelfinished"]:FireServer(reelSuccess, perfectCatch)
            
            -- Quick reset for efficiency
            local resetDelay = math.random(100, 300) / 1000
            task.wait(resetDelay)
            tool.events.reset:FireServer()
        end)
    end
end

function AutoFarm.toggleStealth(enabled)
    Services.State.enabledFlags["StealthMode"] = enabled
    
    if enabled then
        print("🥷 Stealth Mode Activated - Balanced for effectiveness")
        AutoFarm.setupStealthMeasures()
    else
        print("🥷 Stealth Mode Deactivated")
        AutoFarm.disableStealthMeasures()
    end
end

function AutoFarm.setupStealthMeasures()
    -- Hook and modify remote security (less aggressive)
    Services.safePcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            -- Light spoofing for fishing-related remotes
            if method == "FireServer" then
                if string.find(tostring(self), "cast") then
                    -- Only slightly modify cast parameters
                    if args[1] and tonumber(args[1]) and args[1] == 100 then
                        args[1] = math.random(98, 100) -- Very slight variation from perfect
                    end
                    if args[2] and tonumber(args[2]) and args[2] == 1 then
                        args[2] = math.random(1, 2) -- Minimal direction variation
                    end
                end

                if string.find(tostring(self), "shake") then
                    -- Minimal delay to shake events
                    if math.random(1, 100) <= 20 then -- Only 20% of the time
                        task.wait(math.random(1, 10) / 1000) -- Tiny delays
                    end
                end

                if string.find(tostring(self), "reelfinished") then
                    -- Light modification to reel completion
                    if args[1] and tonumber(args[1]) and args[1] == 100 then
                        args[1] = math.random(95, 100) -- Keep very high success
                    end
                end
            end

            return oldNamecall(self, unpack(args))
        end

        setreadonly(mt, true)
    end)

    -- Light network lag simulation
    Services.State.enabledFlags["NetworkLagSim"] = Services.RunService.Heartbeat:Connect(function()
        if math.random(1, 100) <= 1 then -- Only 1% chance
            task.wait(math.random(1, 5) / 1000) -- Tiny delays
        end
    end)

    -- Light behavior simulation
    Services.State.enabledFlags["BehaviorSim"] = task.spawn(function()
        while Services.State.enabledFlags["StealthMode"] do
            -- Rare idle periods
            if math.random(1, 100) <= 2 then -- Only 2% chance
                local idleTime = math.random(200, 800) / 1000
                print("🤖 Brief idle period: " .. idleTime .. "s")
                task.wait(idleTime)
            end
            task.wait(5) -- Check less frequently
        end
    end)
end

function AutoFarm.disableStealthMeasures()
    if Services.State.enabledFlags["NetworkLagSim"] then
        Services.State.enabledFlags["NetworkLagSim"]:Disconnect()
        Services.State.enabledFlags["NetworkLagSim"] = nil
    end
    if Services.State.enabledFlags["BehaviorSim"] then
        coroutine.close(Services.State.enabledFlags["BehaviorSim"])
        Services.State.enabledFlags["BehaviorSim"] = nil
    end
end

function AutoFarm.toggleAutoSell(enabled)
    Services.State.enabledFlags["AutoSell"] = enabled
    
    if enabled then
        Services.State.autoSellLoop = task.spawn(function()
            while Services.State.enabledFlags["AutoSell"] do
                task.wait(5) -- Delay to avoid detection
                AutoFarm.sellNow()
            end
        end)
        print("💰 Auto Sell started")
    else
        Services.cleanupConnection("autoSellLoop")
        print("💰 Auto Sell stopped")
    end
end

function AutoFarm.sellNow()
    Services.safePcall(function()
        local args = {
            {
                voice = 12,
                npc = Services.Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"),
                idle = Services.Workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle")
            }
        }
        Services.ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll"):InvokeServer(unpack(args))
        print("💰 Sold all items")
    end)
end

return AutoFarm
