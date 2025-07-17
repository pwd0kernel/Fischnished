-- Movement Feature Module
-- Handles speed, fly, noclip, and anti-void functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local Movement = {}
local Services = _G.Fischnished.core.services

function Movement.createUI()
    local MovementTab = _G.Fischnished.UI.Tabs.Movement
    
    MovementTab:CreateToggle({
        Name = "Speed Hack",
        CurrentValue = false,
        Flag = "SpeedHackToggle",
        Callback = function(Value)
            Movement.toggleSpeed(Value)
        end,
    })

    MovementTab:CreateSlider({
        Name = "Speed Value",
        Range = {16, 500},
        Increment = 10,
        Suffix = "Speed",
        CurrentValue = 100,
        Flag = "SpeedSlider",
        Callback = function(Value)
            Services.State.speedValue = Value
            if Services.State.enabledFlags["SpeedHack"] then
                local humanoid = Services.getHumanoid()
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end,
    })

    MovementTab:CreateToggle({
        Name = "Fly Hack",
        CurrentValue = false,
        Flag = "FlyHackToggle",
        Callback = function(Value)
            Movement.toggleFly(Value)
        end,
    })

    MovementTab:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 300},
        Increment = 10,
        Suffix = "Speed",
        CurrentValue = 50,
        Flag = "FlySlider",
        Callback = function(Value)
            Services.State.flySpeedValue = Value
        end,
    })

    MovementTab:CreateToggle({
        Name = "No Clip",
        CurrentValue = false,
        Flag = "NoClipToggle",
        Callback = function(Value)
            Movement.toggleNoClip(Value)
        end,
    })

    MovementTab:CreateToggle({
        Name = "Anti Void",
        CurrentValue = false,
        Flag = "AntiVoidToggle",
        Callback = function(Value)
            Movement.toggleAntiVoid(Value)
        end,
    })
end

function Movement.toggleSpeed(enabled)
    Services.State.enabledFlags["SpeedHack"] = enabled
    local humanoid = Services.getHumanoid()
    
    if humanoid then
        humanoid.WalkSpeed = enabled and Services.State.speedValue or Services.State.originalWalkSpeed
    end
    
    print(enabled and "🏃 Speed Hack enabled" or "🏃 Speed Hack disabled")
end

function Movement.toggleFly(enabled)
    Services.State.enabledFlags["FlyHack"] = enabled
    
    if enabled then
        Movement.enableFly()
        print("✈️ Fly Hack enabled")
    else
        Movement.disableFly()
        print("✈️ Fly Hack disabled")
    end
end

function Movement.enableFly()
    local character = Services.getCharacter()
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    Services.State.flyBodyVelocity = Instance.new("BodyVelocity")
    Services.State.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Services.State.flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Services.State.flyBodyVelocity.Parent = root

    Services.State.flyGyro = Instance.new("BodyGyro")
    Services.State.flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    Services.State.flyGyro.P = 20000
    Services.State.flyGyro.Parent = root

    Services.State.flyLoopConnection = Services.RunService.Heartbeat:Connect(function()
        Movement.updateFlyMovement()
    end)
end

function Movement.updateFlyMovement()
    local cam = Services.Workspace.CurrentCamera
    if Services.State.flyGyro then
        Services.State.flyGyro.CFrame = cam.CFrame
    end
    
    local velocity = Vector3.new(0, 0, 0)
    
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
        velocity = velocity + (cam.CFrame.LookVector * Services.State.flySpeedValue)
    end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
        velocity = velocity - (cam.CFrame.LookVector * Services.State.flySpeedValue)
    end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
        velocity = velocity - (cam.CFrame.RightVector * Services.State.flySpeedValue)
    end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
        velocity = velocity + (cam.CFrame.RightVector * Services.State.flySpeedValue)
    end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        velocity = velocity + Vector3.new(0, Services.State.flySpeedValue, 0)
    end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        velocity = velocity - Vector3.new(0, Services.State.flySpeedValue, 0)
    end
    
    if Services.State.flyBodyVelocity then
        Services.State.flyBodyVelocity.Velocity = velocity
    end
end

function Movement.disableFly()
    Services.cleanupConnection("flyLoopConnection")
    
    if Services.State.flyBodyVelocity then
        Services.State.flyBodyVelocity:Destroy()
        Services.State.flyBodyVelocity = nil
    end
    if Services.State.flyGyro then
        Services.State.flyGyro:Destroy()
        Services.State.flyGyro = nil
    end
end

function Movement.toggleNoClip(enabled)
    Services.State.enabledFlags["NoClip"] = enabled
    
    if enabled then
        Services.State.noClipConnection = Services.RunService.Stepped:Connect(function()
            local character = Services.getCharacter()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("👻 No Clip enabled")
    else
        Services.cleanupConnection("noClipConnection")
        
        -- Re-enable collision for all parts
        local character = Services.getCharacter()
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("👻 No Clip disabled")
    end
end

function Movement.toggleAntiVoid(enabled)
    Services.State.enabledFlags["AntiVoid"] = enabled
    
    if enabled then
        Services.State.antiVoidConnection = Services.RunService.Heartbeat:Connect(function()
            local character = Services.getCharacter()
            local root = Services.getHumanoidRootPart()
            if character and root then
                if root.Position.Y < 0 then
                    root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
                end
            end
        end)
        print("🛡️ Anti Void enabled")
    else
        Services.cleanupConnection("antiVoidConnection")
        print("🛡️ Anti Void disabled")
    end
end

return Movement
