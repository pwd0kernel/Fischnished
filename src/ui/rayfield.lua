-- Rayfield UI Module
-- Handles all UI creation and management
-- Part of Fischnished Cheat by Buffer_0verflow

local RayfieldUI = {}
local Services = _G.Fischnished.core.services

function RayfieldUI.initialize()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
        Name = "Fischnished - Fisch Cheat (1.0.0)",
        LoadingTitle = "Loading Fischnished...",
        LoadingSubtitle = "by Buffer_0verflow",
        ConfigurationSaving = {
            Enabled = false,
            FolderName = nil,
            FileName = "FischnishedConfig"
        },
        Discord = {
            Enabled = true,
            Invite = "Tesm6dDcDC",
            RememberJoins = true
        },
        KeySystem = true,
        KeySettings = {
            Title = "Fischnished Premium",
            Subtitle = "Enter your license key",
            Note = "Purchase a key from our Discord server: discord.gg/Tesm6dDcDC",
            FileName = "FischnishedKey",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {
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
            }
        }
    })

    -- Store references
    _G.Fischnished.UI.Rayfield = Rayfield
    _G.Fischnished.UI.Window = Window
    _G.Fischnished.UI.Tabs = {}

    -- Create all tabs
    RayfieldUI.createTabs()
    
    -- Setup event connections
    RayfieldUI.setupConnections()
    
    print("✅ Rayfield UI initialized successfully")
end

function RayfieldUI.createTabs()
    local Window = _G.Fischnished.UI.Window
    
    -- Create tabs
    _G.Fischnished.UI.Tabs.Hacks = Window:CreateTab("Hacks", nil)
    _G.Fischnished.UI.Tabs.Movement = Window:CreateTab("Movement", nil)
    _G.Fischnished.UI.Tabs.Teleports = Window:CreateTab("Teleports", nil)
    _G.Fischnished.UI.Tabs.Treasure = Window:CreateTab("Treasure", nil)
    _G.Fischnished.UI.Tabs.Crates = Window:CreateTab("Crates", nil)
    _G.Fischnished.UI.Tabs.Codes = Window:CreateTab("Creator Codes", nil)
    _G.Fischnished.UI.Tabs.Visuals = Window:CreateTab("Visuals", nil)
    _G.Fischnished.UI.Tabs.Misc = Window:CreateTab("Misc", nil)
    
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
    RayfieldUI.createMiscTab()
end

function RayfieldUI.createMiscTab()
    local MiscTab = _G.Fischnished.UI.Tabs.Misc
    
    MiscTab:CreateParagraph({
        Title = "Credits", 
        Content = "Developed by Buffer_0verflow\n\nRestructured for GitHub distribution.\nModular design for better maintenance.\n\nVersion: 1.0.0"
    })

    MiscTab:CreateButton({
        Name = "📱 Join Discord Server",
        Callback = function()
            RayfieldUI.openDiscord()
        end,
    })

    MiscTab:CreateButton({
        Name = "📋 Copy Discord Link",
        Callback = function()
            RayfieldUI.copyDiscordLink()
        end,
    })

    MiscTab:CreateButton({
        Name = "Exit GUI",
        Callback = function()
            RayfieldUI.exitGUI()
        end,
    })
end

function RayfieldUI.openDiscord()
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
        
        RayfieldUI.createNotification("Discord", "Link copied to clipboard!\nhttps://discord.gg/Tesm6dDcDC")
    end)
end

function RayfieldUI.copyDiscordLink()
    Services.safePcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/Tesm6dDcDC")
            print("✅ Discord link copied to clipboard: https://discord.gg/Tesm6dDcDC")
            RayfieldUI.createNotification("Success", "Discord Link Copied!")
        else
            print("📋 Discord Server: https://discord.gg/Tesm6dDcDC")
            print("⚠️ Clipboard not available - copy manually")
        end
    end)
end

function RayfieldUI.createNotification(title, message)
    Services.safePcall(function()
        if Services.LocalPlayer and Services.LocalPlayer.PlayerGui then
            local gui = Instance.new("ScreenGui")
            gui.Parent = Services.LocalPlayer.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 100)
            frame.Position = UDim2.new(0.5, -150, 0.1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = frame
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "🎮 " .. title
            titleLabel.TextColor3 = Color3.new(1, 1, 1)
            titleLabel.TextScaled = true
            titleLabel.Font = Enum.Font.SourceSansBold
            titleLabel.Parent = frame
            
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, 0, 0.6, 0)
            descLabel.Position = UDim2.new(0, 0, 0.4, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = message
            descLabel.TextColor3 = Color3.new(1, 1, 1)
            descLabel.TextScaled = true
            descLabel.Font = Enum.Font.SourceSans
            descLabel.Parent = frame
            
            -- Auto-destroy notification after 3 seconds
            Services.Debris:AddItem(gui, 3)
            
            -- Animate notification
            frame:TweenPosition(
                UDim2.new(0.5, -150, 0.05, 0),
                "Out",
                "Quad",
                0.5,
                true
            )
            
            task.wait(2.5)
            frame:TweenPosition(
                UDim2.new(0.5, -150, -0.2, 0),
                "In",
                "Quad",
                0.5,
                true
            )
        end
    end)
end

function RayfieldUI.exitGUI()
    print("🚪 Exiting Fischnished...")
    
    -- Cleanup all features
    Services.cleanup()
    
    -- Destroy UI
    if _G.Fischnished.UI.Rayfield then
        _G.Fischnished.UI.Rayfield:Destroy()
    end
    
    -- Clear global
    _G.FischnishedLoaded = false
    _G.Fischnished = nil
    
    print("✅ Fischnished exited successfully")
end

function RayfieldUI.setupConnections()
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

return RayfieldUI
