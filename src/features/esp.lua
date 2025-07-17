-- ESP Feature Module
-- Handles player, NPC, and treasure ESP functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local ESP = {}
local Services = _G.Fischnished.core.services

function ESP.createUI()
    local VisualsTab = _G.Fischnished.UI.Tabs.Visuals
    
    VisualsTab:CreateToggle({
        Name = "Player ESP",
        CurrentValue = false,
        Flag = "PlayerESPToggle",
        Callback = function(Value)
            Services.State.enabledFlags["PlayerESP"] = Value
            ESP.updatePlayerESP()
        end,
    })

    VisualsTab:CreateToggle({
        Name = "NPC ESP",
        CurrentValue = false,
        Flag = "NPCESPToggle",
        Callback = function(Value)
            Services.State.enabledFlags["NPCESP"] = Value
            ESP.updateNPCESP()
        end,
    })

    VisualsTab:CreateToggle({
        Name = "Treasure ESP",
        CurrentValue = false,
        Flag = "TreasureESPToggle",
        Callback = function(Value)
            Services.State.enabledFlags["TreasureESP"] = Value
            ESP.updateTreasureESP()
        end,
    })
end

function ESP.updatePlayerESP()
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= Services.LocalPlayer and player.Character then
            local highlight = Services.State.playerESPHighlights[player]
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.FillTransparency = 0.5
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character
                Services.State.playerESPHighlights[player] = highlight
            end
            highlight.Enabled = Services.State.enabledFlags["PlayerESP"] or false
        end
    end
end

function ESP.updateNPCESP()
    local world = Services.Workspace:FindFirstChild("world")
    if world then
        local npcs = world:FindFirstChild("npcs")
        if npcs then
            for _, npc in ipairs(npcs:GetChildren()) do
                if npc:IsA("Model") then
                    local highlight = Services.State.npcESPHighlights[npc]
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.FillTransparency = 0.5
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.Parent = npc
                        Services.State.npcESPHighlights[npc] = highlight
                    end
                    highlight.Enabled = Services.State.enabledFlags["NPCESP"] or false
                end
            end
        end
    end
end

function ESP.updateTreasureESP()
    local world = Services.Workspace:FindFirstChild("world")
    if world then
        -- Look for treasure chests in the world
        for _, obj in ipairs(world:GetDescendants()) do
            if obj:IsA("Model") and ESP.isTreasure(obj) then
                ESP.handleTreasureESP(obj)
            end
        end
        
        -- Also check for items that might be treasures in the items folder
        local items = world:FindFirstChild("items")
        if items then
            for _, item in ipairs(items:GetChildren()) do
                if item:IsA("Model") and ESP.isTreasure(item) then
                    ESP.handleTreasureESP(item)
                end
            end
        end
    end
end

function ESP.isTreasure(obj)
    local name = string.lower(obj.Name)
    return (
        string.find(name, "chest") or
        string.find(name, "treasure") or
        string.find(name, "crate") or
        string.find(name, "barrel") or
        string.find(name, "loot") or
        string.find(name, "supply") or
        obj.Name == "TreasureChest" or
        obj.Name == "treasure_chest" or
        obj.Name == "Chest" or
        obj.Name == "SupplyCrate" or
        obj.Name == "LootBarrel"
    )
end

function ESP.handleTreasureESP(obj)
    local highlight = Services.State.treasureESPHighlights[obj]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.3
        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Gold color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Yellow outline
        highlight.Parent = obj
        Services.State.treasureESPHighlights[obj] = highlight
        
        -- Add distance label
        ESP.createTreasureLabel(obj, highlight)
    end
    
    highlight.Enabled = Services.State.enabledFlags["TreasureESP"] or false
    if highlight.BillboardGui then
        highlight.BillboardGui.Enabled = Services.State.enabledFlags["TreasureESP"] or false
        ESP.updateTreasureDistance(obj, highlight)
    end
end

function ESP.createTreasureLabel(obj, highlight)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 100, 0, 25)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = obj
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = obj.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboardGui
    
    highlight.BillboardGui = billboardGui
end

function ESP.updateTreasureDistance(obj, highlight)
    local character = Services.getCharacter()
    local root = Services.getHumanoidRootPart()
    
    if character and root and obj:FindFirstChild("HumanoidRootPart") then
        local distance = math.floor((root.Position - obj.HumanoidRootPart.Position).Magnitude)
        highlight.BillboardGui.TextLabel.Text = obj.Name .. "\n[" .. distance .. " studs]"
    end
end

return ESP
