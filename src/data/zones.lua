-- Zones Data Module
-- Contains all teleport zone data
-- Part of Fischnished Cheat by Buffer_0verflow

local ZonesData = {}

ZonesData.defaultZones = {
    {Name = "Moosewood Dock", Pos = Vector3.new(360, 133, 264)},
    {Name = "Mushgrove Swamp", Pos = Vector3.new(2420, 135, -750)},
    {Name = "Roslit Bay Dock", Pos = Vector3.new(-1462, 132, 717)},
    {Name = "Snowcap Island Dock", Pos = Vector3.new(2612, 135, 2397)},
    {Name = "Sunstone Island Dock", Pos = Vector3.new(-933, 131, -1111)},
    {Name = "Terrapin Island Dock", Pos = Vector3.new(-196, 133, 1945)},
    {Name = "Desolate Deep Buoy", Pos = Vector3.new(-787, 133, -3104)},
    {Name = "Forsaken Shores Dock", Pos = Vector3.new(-2485, 133, 1562)},
    {Name = "Ancient Isle", Pos = Vector3.new(6000, 200, 300)},
    {Name = "Grand Reef", Pos = Vector3.new(-3575, 151, 524)},
    {Name = "Statue of Sovereignty", Pos = Vector3.new(38, 133, -1013)},
    {Name = "Enchant Altar", Pos = Vector3.new(1313, -805, -99)},
    {Name = "Northern Summit Entrance", Pos = Vector3.new(-1746, 129, 3879)},
    {Name = "Oil Rig", Pos = Vector3.new(-1770, 132, -483)},
    {Name = "Volcanic Vents", Pos = Vector3.new(-3435, -2273, 3766)}
}

-- Function to get all fishing zones from workspace.zones.fishing
function ZonesData.getAllFishingZones()
    local Services = _G.Fischnished.core.services
    local fishingZones = {}
    
    pcall(function()
        local zones = Services.Workspace:FindFirstChild("zones")
        if zones then
            local fishing = zones:FindFirstChild("fishing")
            if fishing then
                for _, zone in ipairs(fishing:GetChildren()) do
                    if zone:IsA("BasePart") or (zone:IsA("Model") and zone:FindFirstChild("HumanoidRootPart")) then
                        local position = zone:IsA("BasePart") and zone.Position or zone.HumanoidRootPart.Position
                        table.insert(fishingZones, {
                            Name = zone.Name,
                            Position = position,
                            Object = zone
                        })
                    end
                end
            end
        end
    end)
    return fishingZones
end

-- Function to get all player zones from workspace.zones.player
function ZonesData.getAllPlayerZones()
    local Services = _G.Fischnished.core.services
    local playerZones = {}
    
    pcall(function()
        local zones = Services.Workspace:FindFirstChild("zones")
        if zones then
            local player = zones:FindFirstChild("player")
            if player then
                for _, zone in ipairs(player:GetChildren()) do
                    if zone:IsA("BasePart") or (zone:IsA("Model") and zone:FindFirstChild("HumanoidRootPart")) then
                        local position = zone:IsA("BasePart") and zone.Position or zone.HumanoidRootPart.Position
                        table.insert(playerZones, {
                            Name = zone.Name,
                            Position = position,
                            Object = zone
                        })
                    end
                end
            end
        end
    end)
    return playerZones
end

function ZonesData.getAllTreasures()
    local Services = _G.Fischnished.core.services
    local treasures = {}
    local world = Services.Workspace:FindFirstChild("world")
    
    if world then
        -- Search in world descendants
        for _, obj in ipairs(world:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and ZonesData.isTreasure(obj) then
                table.insert(treasures, {
                    Name = obj.Name,
                    Position = obj.HumanoidRootPart.Position,
                    Object = obj
                })
            end
        end
        
        -- Also check items folder
        local items = world:FindFirstChild("items")
        if items then
            for _, item in ipairs(items:GetChildren()) do
                if item:IsA("Model") and item:FindFirstChild("HumanoidRootPart") and ZonesData.isTreasure(item) then
                    table.insert(treasures, {
                        Name = item.Name,
                        Position = item.HumanoidRootPart.Position,
                        Object = item
                    })
                end
            end
        end
    end
    return treasures
end

function ZonesData.isTreasure(obj)
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

return ZonesData
