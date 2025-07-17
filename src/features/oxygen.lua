-- Oxygen Feature Module
-- Handles unlimited oxygen functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local Oxygen = {}
local Services = _G.Fischnished.core.services

function Oxygen.createUI()
    local HacksTab = _G.Fischnished.UI.Tabs.Hacks
    
    HacksTab:CreateToggle({
        Name = "Unlimited Oxygen",
        CurrentValue = false,
        Flag = "UnlimitedOxygenToggle",
        Callback = function(Value)
            Oxygen.toggle(Value)
        end,
    })
end

function Oxygen.toggle(enabled)
    Services.State.enabledFlags["UnlimitedOxygen"] = enabled
    
    if enabled then
        Oxygen.enable()
        print("=== UNLIMITED OXYGEN ACTIVATED ===")
    else
        Oxygen.disable()
        print("=== UNLIMITED OXYGEN DEACTIVATED ===")
    end
end

function Oxygen.enable()
    -- Oxygen Bypass Implementation
    Services.Workspace:SetAttribute("IgnoreOxygen", true)
    print("✓ Workspace IgnoreOxygen set to true")

    -- Block drown events
    Services.safePcall(function()
        local drownEvent = Services.ReplicatedStorage:WaitForChild("events", 5):WaitForChild("drown", 5)
        local oldFireServer = drownEvent.FireServer
        drownEvent.FireServer = function(...)
            print("Blocked drown event!")
            return
        end
        print("✓ Drown event blocked")
    end)

    -- Continuous oxygen maintenance
    Services.State.enabledFlags["OxygenHeartbeat"] = Services.RunService.Heartbeat:Connect(function()
        if Services.State.enabledFlags["UnlimitedOxygen"] then
            Oxygen.maintainOxygen()
        end
    end)

    -- Apply immediately
    Oxygen.forceFullOxygen()

    -- Name spoofing
    Oxygen.setupNameSpoofing()

    -- UI hiding loop
    Services.State.enabledFlags["OxygenUILoop"] = task.spawn(function()
        while Services.State.enabledFlags["UnlimitedOxygen"] do
            Oxygen.hideOxygenUI()
            task.wait(0.1)
        end
    end)
end

function Oxygen.disable()
    Services.Workspace:SetAttribute("IgnoreOxygen", false)
    
    if Services.State.enabledFlags["OxygenHeartbeat"] then
        Services.State.enabledFlags["OxygenHeartbeat"]:Disconnect()
        Services.State.enabledFlags["OxygenHeartbeat"] = nil
    end
    
    if Services.State.enabledFlags["OxygenUILoop"] then
        coroutine.close(Services.State.enabledFlags["OxygenUILoop"])
        Services.State.enabledFlags["OxygenUILoop"] = nil
    end
end

function Oxygen.maintainOxygen()
    local character = Services.getCharacter()
    if character then
        character:SetAttribute("Refill", true)
        character:SetAttribute("OxygenUnits", 100)
        
        Services.safePcall(function()
            if character:FindFirstChild("zone") then
                character.zone.Value = nil
            end
        end)
        
        Services.safePcall(function()
            for _, gui in pairs(character:GetDescendants()) do
                if gui:IsA("BillboardGui") and gui.Name == "ui" then
                    gui.Enabled = false
                end
            end
            
            local PlayerGui = Services.LocalPlayer.PlayerGui
            if PlayerGui:FindFirstChild("LowOxygen") then
                PlayerGui.LowOxygen.Enabled = false
            end
            if PlayerGui:FindFirstChild("sounds") and PlayerGui.sounds:FindFirstChild("heartbeatSound") then
                PlayerGui.sounds.heartbeatSound:Stop()
            end
        end)
    end
end

function Oxygen.forceFullOxygen()
    local character = Services.getCharacter()
    if character then
        character:SetAttribute("Refill", true)
        character:SetAttribute("OxygenUnits", 100)
        
        Services.safePcall(function()
            if character:FindFirstChild("zone") then
                character.zone.Value = nil
            end
        end)
        
        for _, descendant in pairs(character:GetDescendants()) do
            if descendant:IsA("LocalScript") then
                if descendant.Name:lower():find("oxygen") or 
                   (descendant.Parent and descendant.Parent.Name:lower():find("oxygen")) then
                    Services.safePcall(function()
                        local env = getfenv(descendant)
                        for varName, value in pairs(env) do
                            if type(value) == "number" and value < 100 and value > 0 then
                                env[varName] = 100
                            end
                        end
                    end)
                    descendant.Enabled = false
                    print("✓ Disabled oxygen script:", descendant.Name)
                end
            end
        end
    end
end

function Oxygen.setupNameSpoofing()
    Services.safePcall(function()
        local mt = getrawmetatable(game)
        local oldNameIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = function(self, key)
            if self == Services.LocalPlayer and key == "Name" then
                return "uzerk1234"
            end
            return oldNameIndex(self, key)
        end
        setreadonly(mt, true)
        print("✓ Player name spoofed")
    end)
end

function Oxygen.hideOxygenUI()
    local character = Services.getCharacter()
    if character and character:FindFirstChild("Head") then
        for _, child in pairs(character.Head:GetChildren()) do
            if child:IsA("BillboardGui") and child.Name == "ui" then
                child.Enabled = false
                for _, element in pairs(child:GetDescendants()) do
                    if element:IsA("GuiObject") then
                        element.Visible = false
                        element.BackgroundTransparency = 1
                        if element:IsA("ImageLabel") then
                            element.ImageTransparency = 1
                        end
                    end
                end
            end
        end
    end
end

return Oxygen
