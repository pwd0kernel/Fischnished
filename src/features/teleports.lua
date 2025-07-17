-- Teleports Feature Module
-- Handles all teleportation functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local Teleports = {}
local Services = _G.Fischnished.core.services

function Teleports.createUI()
    local TeleportsTab = _G.Fischnished.UI.Tabs.Teleports
    local TreasureTab = _G.Fischnished.UI.Tabs.Treasure
    
    Teleports.createDefaultZones(TeleportsTab)
    Teleports.createDynamicZones(TeleportsTab)
    Teleports.createTreasureUI(TreasureTab)
end

function Teleports.createDefaultZones(tab)
    local ZonesData = _G.Fischnished.data.zones
    
    -- Create buttons for default zones
    for _, zone in ipairs(ZonesData.defaultZones) do
        tab:CreateButton({
            Name = "Teleport to " .. zone.Name,
            Callback = function()
                Teleports.teleportToPosition(zone.Pos)
            end,
        })
    end
end

function Teleports.createDynamicZones(tab)
    local ZonesData = _G.Fischnished.data.zones
    
    -- Add separator
    tab:CreateParagraph({Title = "Fishing Zones", Content = "Teleport to fishing areas from workspace.zones.fishing"})

    -- Create buttons for fishing zones
    task.spawn(function()
        local fishingZones = ZonesData.getAllFishingZones()
        for _, zone in ipairs(fishingZones) do
            tab:CreateButton({
                Name = "🎣 " .. zone.Name,
                Callback = function()
                    Teleports.teleportToPosition(zone.Position)
                    print("Teleported to fishing zone: " .. zone.Name)
                end,
            })
        end
    end)

    -- Add separator
    tab:CreateParagraph({Title = "Player Zones", Content = "Teleport to player areas from workspace.zones.player"})

    -- Create buttons for player zones
    task.spawn(function()
        local playerZones = ZonesData.getAllPlayerZones()
        for _, zone in ipairs(playerZones) do
            tab:CreateButton({
                Name = "👤 " .. zone.Name,
                Callback = function()
                    Teleports.teleportToPosition(zone.Position)
                    print("Teleported to player zone: " .. zone.Name)
                end,
            })
        end
    end)

    -- Refresh zones button
    tab:CreateButton({
        Name = "🔄 Refresh All Zones",
        Callback = function()
            Teleports.refreshZones()
        end,
    })
end

function Teleports.createTreasureUI(tab)
    local ZonesData = _G.Fischnished.data.zones
    
    tab:CreateButton({
        Name = "Teleport to Nearest Treasure",
        Callback = function()
            Teleports.teleportToNearestTreasure()
        end,
    })

    tab:CreateButton({
        Name = "List All Treasures",
        Callback = function()
            Teleports.listAllTreasures()
        end,
    })

    tab:CreateButton({
        Name = "Auto Collect Treasures",
        Callback = function()
            Teleports.autoCollectTreasures()
        end,
    })
end

function Teleports.teleportToPosition(position)
    local character = Services.getCharacter()
    local root = Services.getHumanoidRootPart()
    
    if character and root then
        root.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
        print("✈️ Teleported to position: " .. tostring(position))
    else
        warn("❌ Cannot teleport - character or HumanoidRootPart not found")
    end
end

function Teleports.teleportToNearestTreasure()
    local ZonesData = _G.Fischnished.data.zones
    local treasures = ZonesData.getAllTreasures()
    local character = Services.getCharacter()
    local root = Services.getHumanoidRootPart()
    
    if #treasures > 0 and character and root then
        local playerPos = root.Position
        local nearestTreasure = nil
        local nearestDistance = math.huge

        for _, treasure in ipairs(treasures) do
            local distance = (playerPos - treasure.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestTreasure = treasure
            end
        end

        if nearestTreasure then
            root.CFrame = CFrame.new(nearestTreasure.Position + Vector3.new(0, 5, 0))
            print("💰 Teleported to " .. nearestTreasure.Name .. " (Distance: " .. math.floor(nearestDistance) .. " studs)")
        end
    else
        print("❌ No treasures found nearby!")
    end
end

function Teleports.listAllTreasures()
    local ZonesData = _G.Fischnished.data.zones
    local treasures = ZonesData.getAllTreasures()
    local character = Services.getCharacter()
    local root = Services.getHumanoidRootPart()
    
    if #treasures > 0 then
        print("=== TREASURES FOUND ===")
        for i, treasure in ipairs(treasures) do
            local playerPos = character and root and root.Position
            local distance = playerPos and math.floor((playerPos - treasure.Position).Magnitude) or "Unknown"
            print(i .. ". " .. treasure.Name .. " - Distance: " .. distance .. " studs")
        end
        print("======================")
    else
        print("❌ No treasures found!")
    end
end

function Teleports.autoCollectTreasures()
    local ZonesData = _G.Fischnished.data.zones
    local treasures = ZonesData.getAllTreasures()
    local character = Services.getCharacter()
    local root = Services.getHumanoidRootPart()
    
    if #treasures > 0 and character and root then
        print("🤖 Starting auto treasure collection...")
        task.spawn(function()
            for i, treasure in ipairs(treasures) do
                if character and root then
                    print("💰 Collecting treasure " .. i .. "/" .. #treasures .. ": " .. treasure.Name)
                    root.CFrame = CFrame.new(treasure.Position + Vector3.new(0, 5, 0))
                    task.wait(2) -- Wait 2 seconds to collect
                    
                    -- Try to interact with the treasure
                    Services.safePcall(function()
                        if treasure.Object and treasure.Object:FindFirstChild("ClickDetector") then
                            fireclickdetector(treasure.Object.ClickDetector)
                        elseif treasure.Object and treasure.Object:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(treasure.Object.ProximityPrompt)
                        end
                    end)
                    task.wait(1) -- Wait before moving to next treasure
                end
            end
            print("✅ Finished collecting all treasures!")
        end)
    else
        print("❌ No treasures found or character not available!")
    end
end

function Teleports.refreshZones()
    local ZonesData = _G.Fischnished.data.zones
    local fishingZones = ZonesData.getAllFishingZones()
    local playerZones = ZonesData.getAllPlayerZones()
    
    print("=== ZONE REFRESH ===")
    print("Fishing Zones Found: " .. #fishingZones)
    for i, zone in ipairs(fishingZones) do
        print(i .. ". " .. zone.Name .. " - Position: " .. tostring(zone.Position))
    end
    
    print("\nPlayer Zones Found: " .. #playerZones)
    for i, zone in ipairs(playerZones) do
        print(i .. ". " .. zone.Name .. " - Position: " .. tostring(zone.Position))
    end
    print("===================")
    
    print("📝 Note: Restart the GUI to see newly added zones as buttons")
end

return Teleports
