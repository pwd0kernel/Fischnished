-- FischnishedUI - Custom UI Library Implementation
-- Replaces Rayfield with our own superior UI system
-- Part of Fischnished Cheat by Buffer_0verflow

local FischnishedUI = {}

-- Get services safely (might be called before services module is loaded)
local function getServices()
    if _G.Fischnished and _G.Fischnished.core and _G.Fischnished.core.services then
        return _G.Fischnished.core.services
    end
    
    -- Fallback services if core module not loaded yet
    return {
        safePcall = function(func) 
            local success, result = pcall(func)
            if not success then
                warn("SafePcall error: " .. tostring(result))
            end
            return success, result
        end,
        cleanup = function() end,
        State = {
            enabledFlags = {},
            playerESPHighlights = {},
            speedValue = 100,
            flySpeedValue = 50
        },
        Players = game:GetService("Players"),
        LocalPlayer = game:GetService("Players").LocalPlayer,
        RunService = game:GetService("RunService"),
        GuiService = game:GetService("GuiService"),
        getHumanoid = function()
            local char = game:GetService("Players").LocalPlayer.Character
            return char and char:FindFirstChild("Humanoid")
        end
    }
end

local Services = getServices()

-- Load our custom UI library - use global reference with multiple fallbacks
local UI = _G.FischnishedUI or 
           (_G.Fischnished and _G.Fischnished.ui and _G.Fischnished.ui.fischnished_complete)

if not UI then
    error("FischnishedUI library not found! Make sure fischnished_complete.lua is loaded first.")
end

function FischnishedUI.initialize()
    print("🎨 Initializing FischnishedUI - Custom UI System")
    
    -- Setup key system
    local keySystemAuthenticated = UI.setupKeySystem({
        enabled = true,
        title = "Fischnished Premium",
        subtitle = "Enter your license key",
        note = "Purchase a key from our Discord server: discord.gg/Tesm6dDcDC",
        keys = {
            "FSH-7K9M-X3QR-BVNP-2L8D-YE4C",
            "FSH-9P6W-M2ZX-QRTN-5K8J-VL3F",
            "FSH-4N7B-R8QM-XZPW-3L9K-YE6D",
            "FSH-2X5Q-MVNR-ZWPK-8J4L-BF7C",
            "FSH-6K9P-BXZM-QRWL-5N8J-VE3D",
            "FSH-3M7Q-XZNR-BVPW-9K2L-YF4C",
            "FSH-8P5N-MZXQ-BRLW-6K9J-VE7D",
            "FSH-4X7Q-NVZM-PRWK-2L8J-BF5C",
            "FSH-9M6K-XZQR-BVNW-5P8L-YE3D",
            "FSH-7Q2N-MXZR-BVPK-8J5L-WF4C",
            "FSH-5K8P-NZXQ-MRVW-3L9J-BE6D",
            "FSH-2N7M-XZQR-BVPK-6J8L-YF5C",
            "FSH-8X4Q-MZNR-BVWP-9K2L-VE7D",
            "FSH-6P9N-XZQM-BRLW-5K8J-YF3C",
            "FSH-3M8K-NZXR-BVPW-7Q2L-VE4D"
        },
        saveKey = true,
        fileName = "FischnishedKey"
    })
    
    if not keySystemAuthenticated then
        warn("Key system authentication failed!")
        return
    end
    
    -- Create main window
    local Window = UI.createWindow({
        Name = "Fischnished - Fisch Cheat (1.0.0)",
        LoadingTitle = "Loading Fischnished...",
        LoadingSubtitle = "by Buffer_0verflow"
    })

    -- Store references for compatibility
    _G.Fischnished.UI = _G.Fischnished.UI or {}
    _G.Fischnished.UI.FischnishedUI = UI
    _G.Fischnished.UI.Window = Window
    _G.Fischnished.UI.Tabs = {}

    -- Create all tabs
    FischnishedUI.createTabs()
    
    -- Setup event connections
    FischnishedUI.setupConnections()
    
    UI.createNotification("Success", "FischnishedUI loaded successfully! 🎮", "success", 3)
    print("✅ FischnishedUI initialized successfully")
end

function FischnishedUI.createTabs()
    local Window = _G.Fischnished.UI.Window
    
    -- Create tabs with modern icons
    _G.Fischnished.UI.Tabs.Hacks = UI.createTab("Hacks", "⚡")
    _G.Fischnished.UI.Tabs.Movement = UI.createTab("Movement", "🚀")
    _G.Fischnished.UI.Tabs.Teleports = UI.createTab("Teleports", "🌐")
    _G.Fischnished.UI.Tabs.Treasure = UI.createTab("Treasure", "💎")
    _G.Fischnished.UI.Tabs.Crates = UI.createTab("Crates", "📦")
    _G.Fischnished.UI.Tabs.Codes = UI.createTab("Creator Codes", "🏷️")
    _G.Fischnished.UI.Tabs.Visuals = UI.createTab("Visuals", "👁️")
    _G.Fischnished.UI.Tabs.Misc = UI.createTab("Misc", "⚙️")
    
    -- Initialize feature UIs
    if _G.Fischnished.features then
        if _G.Fischnished.features.autofarm then
            _G.Fischnished.features.autofarm.createUI()
        end
        if _G.Fischnished.features.movement then
            _G.Fischnished.features.movement.createUI()
        end
        if _G.Fischnished.features.esp then
            _G.Fischnished.features.esp.createUI()
        end
        if _G.Fischnished.features.teleports then
            _G.Fischnished.features.teleports.createUI()
        end
        if _G.Fischnished.features.crates then
            _G.Fischnished.features.crates.createUI()
        end
        if _G.Fischnished.features.codes then
            _G.Fischnished.features.codes.createUI()
        end
        if _G.Fischnished.features.oxygen then
            _G.Fischnished.features.oxygen.createUI()
        end
    end
    
    -- Create misc tab content
    FischnishedUI.createMiscTab()
end

function FischnishedUI.createMiscTab()
    local MiscTab = _G.Fischnished.UI.Tabs.Misc
    
    MiscTab.CreateParagraph({
        Title = "Credits", 
        Content = "Developed by Buffer_0verflow\n\nRestructured for GitHub distribution.\nModular design for better maintenance.\n\nNow featuring FischnishedUI - our custom UI library!\n\nVersion: 1.0.0"
    })

    MiscTab.CreateButton({
        Name = "📱 Join Discord Server",
        Callback = function()
            FischnishedUI.openDiscord()
        end,
    })

    MiscTab.CreateButton({
        Name = "📋 Copy Discord Link",
        Callback = function()
            FischnishedUI.copyDiscordLink()
        end,
    })

    MiscTab.CreateButton({
        Name = "🎨 Toggle Theme",
        Callback = function()
            FischnishedUI.toggleTheme()
        end,
    })

    MiscTab.CreateButton({
        Name = "Exit GUI",
        Callback = function()
            FischnishedUI.exitGUI()
        end,
    })
end

function FischnishedUI.toggleTheme()
    local themes = {"Dark", "Light", "Ocean", "Sunset"}
    local currentTheme = UI.CONFIG.THEME
    local currentIndex = 1
    
    for i, theme in ipairs(themes) do
        if theme == currentTheme then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #themes) + 1
    local newTheme = themes[nextIndex]
    
    UI.CONFIG.THEME = newTheme
    UI.createNotification("Theme Changed", "Switched to " .. newTheme .. " theme!", "success", 2)
    
    -- Note: In a full implementation, you'd refresh the UI here
    print("🎨 Theme changed to: " .. newTheme)
end

function FischnishedUI.openDiscord()
    Services.safePcall(function()
        local success = false
        
        -- Method 1: Try direct clipboard copy and notification
        if setclipboard then
            setclipboard("https://discord.gg/Tesm6dDcDC")
            print("✅ Discord link copied to clipboard!")
            print("🔗 https://discord.gg/Tesm6dDcDC")
            success = true
        end
        
        -- Method 2: Try to open URL directly
        if Services.GuiService then
            Services.safePcall(function()
                Services.GuiService:OpenBrowserWindow("https://discord.gg/Tesm6dDcDC")
                success = true
            end)
        end
        
        -- Method 3: Fallback notification
        if not success then
            print("📱 Discord Server: https://discord.gg/Tesm6dDcDC")
            print("💬 Copy this link to join our Discord!")
        end
        
        FischnishedUI.createNotification("Discord", "Link copied to clipboard!\nhttps://discord.gg/Tesm6dDcDC")
    end)
end

function FischnishedUI.copyDiscordLink()
    Services.safePcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/Tesm6dDcDC")
            print("✅ Discord link copied to clipboard: https://discord.gg/Tesm6dDcDC")
            FischnishedUI.createNotification("Success", "Discord Link Copied!")
        else
            print("📋 Discord Server: https://discord.gg/Tesm6dDcDC")
            print("⚠️ Clipboard not available - copy manually")
        end
    end)
end

function FischnishedUI.createNotification(title, message, type, duration)
    -- Use our custom notification system
    UI.createNotification(title, message, type, duration)
end

function FischnishedUI.exitGUI()
    print("🚪 Exiting Fischnished...")
    
    -- Cleanup all features
    Services.cleanup()
    
    -- Destroy UI
    UI.destroyWindow()
    
    -- Clear global
    _G.FischnishedLoaded = false
    _G.Fischnished = nil
    
    print("✅ Fischnished exited successfully")
end

function FischnishedUI.setupConnections()
    -- ESP update connections
    Services.Players.PlayerAdded:Connect(function(player)
        if Services.State.enabledFlags["PlayerESP"] and _G.Fischnished.features.esp then
            _G.Fischnished.features.esp.updatePlayerESP()
        end
    end)
    
    Services.Players.PlayerRemoving:Connect(function(player)
        if Services.State.playerESPHighlights[player] then
            Services.State.playerESPHighlights[player]:Destroy()
            Services.State.playerESPHighlights[player] = nil
        end
    end)

    Services.RunService.RenderStepped:Connect(function()
        if _G.Fischnished.features.esp then
            if Services.State.enabledFlags["PlayerESP"] then
                _G.Fischnished.features.esp.updatePlayerESP()
            end
            if Services.State.enabledFlags["NPCESP"] then
                _G.Fischnished.features.esp.updateNPCESP()
            end
            if Services.State.enabledFlags["TreasureESP"] then
                _G.Fischnished.features.esp.updateTreasureESP()
            end
        end
    end)

    -- Handle fly on character respawn
    Services.LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        if Services.State.enabledFlags["FlyHack"] and _G.Fischnished.features.movement then
            _G.Fischnished.features.movement.enableFly()
        end
    end)

    Services.LocalPlayer.CharacterRemoving:Connect(function()
        if _G.Fischnished.features.movement then
            _G.Fischnished.features.movement.disableFly()
        end
    end)

    -- Humanoid speed update on character respawn
    Services.LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Changed:Connect(function()
            if Services.State.enabledFlags["SpeedHack"] then
                character.Humanoid.WalkSpeed = Services.State.speedValue
            end
        end)
    end)
end

return FischnishedUI
