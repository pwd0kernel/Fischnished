-- Core Services Module
-- Provides centralized access to Roblox services and shared state
-- Part of Fischnished Cheat by Buffer_0verflow

local Services = {}

-- Roblox Services
Services.Players = game:GetService("Players")
Services.LocalPlayer = Services.Players.LocalPlayer
Services.PlayerGui = Services.LocalPlayer:WaitForChild("PlayerGui")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.RunService = game:GetService("RunService")
Services.UserInputService = game:GetService("UserInputService")
Services.Workspace = game:GetService("Workspace")
Services.TweenService = game:GetService("TweenService")
Services.HttpService = game:GetService("HttpService")
Services.GuiService = game:GetService("GuiService")
Services.Debris = game:GetService("Debris")

-- Shared State
Services.State = {
    enabledFlags = {},
    originalWalkSpeed = 16,
    
    -- Movement
    flyBodyVelocity = nil,
    flyGyro = nil,
    flyLoopConnection = nil,
    flySpeedValue = 50,
    speedValue = 100,
    
    -- ESP
    playerESPHighlights = {},
    npcESPHighlights = {},
    treasureESPHighlights = {},
    
    -- Auto Farm
    autoFarmLoop = nil,
    shakeMultiplier = 10,
    
    -- Other features
    noClipConnection = nil,
    autoSellLoop = nil,
    antiVoidConnection = nil,
    autoBuyLoop = nil,
    autoClaimLoop = nil,
    
    -- Settings
    selectedCrate = "Moosewood",
    buyDelay = 1,
    claimDelay = 1,
    selectedCode = ""
}

-- Utility functions
function Services.getCharacter()
    return Services.LocalPlayer.Character
end

function Services.getHumanoid()
    local character = Services.getCharacter()
    return character and character:FindFirstChild("Humanoid")
end

function Services.getHumanoidRootPart()
    local character = Services.getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

function Services.getTool()
    local character = Services.getCharacter()
    return character and character:FindFirstChildWhichIsA("Tool")
end

-- Event cleanup utility
function Services.cleanupConnection(connectionName)
    local connection = Services.State[connectionName]
    if connection then
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "thread" then
            coroutine.close(connection)
        end
        Services.State[connectionName] = nil
    end
end

-- Cleanup all connections and state
function Services.cleanup()
    -- Cleanup all connections
    local connections = {
        "flyLoopConnection", "noClipConnection", "antiVoidConnection",
        "autoFarmLoop", "autoSellLoop", "autoBuyLoop", "autoClaimLoop"
    }
    
    for _, connectionName in ipairs(connections) do
        Services.cleanupConnection(connectionName)
    end
    
    -- Clean up ESP highlights
    for _, hl in pairs(Services.State.playerESPHighlights) do 
        if hl then hl:Destroy() end
    end
    for _, hl in pairs(Services.State.npcESPHighlights) do 
        if hl then hl:Destroy() end
    end
    for _, hl in pairs(Services.State.treasureESPHighlights) do 
        if hl then hl:Destroy() end
    end
    
    -- Reset state
    Services.State.playerESPHighlights = {}
    Services.State.npcESPHighlights = {}
    Services.State.treasureESPHighlights = {}
    Services.State.enabledFlags = {}
    
    -- Reset humanoid speed
    local humanoid = Services.getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = Services.State.originalWalkSpeed
    end
end

-- Safe pcall wrapper
function Services.safePcall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Safe pcall failed: " .. tostring(result))
    end
    return success, result
end

return Services
