-- FischnishedUI - Complete Custom UI Library
-- A modern, feature-rich UI library built specifically for Fischnished
-- Better than Rayfield with enhanced visuals, performance, and features
-- Part of Fischnished Cheat by Buffer_0verflow

local FischnishedUI = {}

-- Get services locally to avoid dependency issues during loading
local function getServices()
    return {
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        Players = game:GetService("Players"),
        CoreGui = game:GetService("CoreGui"),
        TextService = game:GetService("TextService"),
        Debris = game:GetService("Debris"),
        GuiService = game:GetService("GuiService"),
        LocalPlayer = game:GetService("Players").LocalPlayer
    }
end

local Services = getServices()

-- Constants and Configuration
FischnishedUI.CONFIG = {
    UI_SCALE = 1,
    ANIMATION_SPEED = 0.3,
    THEME = "Dark", -- Dark, Light, Ocean, Sunset
    MOBILE_SUPPORT = true,
    BLUR_BACKGROUND = true,
    AUTO_SAVE_CONFIG = true,
    CONFIG_FILE = "FischnishedUI_Config.json"
}

-- Color Themes
FischnishedUI.THEMES = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(108, 121, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Border = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(74, 144, 226),
        AccentHover = Color3.fromRGB(94, 164, 246),
        Text = Color3.fromRGB(30, 30, 30),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(239, 68, 68),
        Border = Color3.fromRGB(220, 220, 230)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 45),
        Secondary = Color3.fromRGB(25, 35, 55),
        Accent = Color3.fromRGB(34, 197, 94),
        AccentHover = Color3.fromRGB(54, 217, 114),
        Text = Color3.fromRGB(240, 250, 255),
        TextSecondary = Color3.fromRGB(180, 190, 200),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113),
        Border = Color3.fromRGB(55, 65, 85)
    },
    Sunset = {
        Background = Color3.fromRGB(45, 25, 15),
        Secondary = Color3.fromRGB(55, 35, 25),
        Accent = Color3.fromRGB(251, 146, 60),
        AccentHover = Color3.fromRGB(255, 166, 80),
        Text = Color3.fromRGB(255, 245, 235),
        TextSecondary = Color3.fromRGB(215, 195, 175),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113),
        Border = Color3.fromRGB(85, 65, 55)
    }
}

-- State Management
FischnishedUI.State = {
    window = nil,
    tabs = {},
    currentTab = nil,
    isVisible = true,
    isMinimized = false,
    keySystem = {
        enabled = false,
        keys = {},
        authenticated = false
    }
}

-- Utility Functions
function FischnishedUI.getCurrentTheme()
    return FischnishedUI.THEMES[FischnishedUI.CONFIG.THEME] or FischnishedUI.THEMES.Dark
end

function FischnishedUI.createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function FischnishedUI.createStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or FischnishedUI.getCurrentTheme().Border
    stroke.Parent = parent
    return stroke
end

function FischnishedUI.createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(12, 12, 12, 12)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    return shadow
end

function FischnishedUI.tweenProperty(object, properties, duration, style, direction)
    local tween = Services.TweenService:Create(
        object,
        TweenInfo.new(
            duration or FischnishedUI.CONFIG.ANIMATION_SPEED,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

function FischnishedUI.createRippleEffect(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, position.X, 0, position.Y)
    ripple.BackgroundColor3 = FischnishedUI.getCurrentTheme().Accent
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = parent.ZIndex + 1
    ripple.Parent = parent
    
    FischnishedUI.createCorner(ripple, 100)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    FischnishedUI.tweenProperty(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, position.X - maxSize/2, 0, position.Y - maxSize/2),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.delay(0.6, function()
        ripple:Destroy()
    end)
end

function FischnishedUI.addHoverEffect(element, hoverColor, normalColor)
    local originalColor = normalColor or element.BackgroundColor3
    local hover = hoverColor or FischnishedUI.getCurrentTheme().AccentHover
    
    element.MouseEnter:Connect(function()
        FischnishedUI.tweenProperty(element, {BackgroundColor3 = hover}, 0.2)
    end)
    
    element.MouseLeave:Connect(function()
        FischnishedUI.tweenProperty(element, {BackgroundColor3 = originalColor}, 0.2)
    end)
end

-- Notification System
function FischnishedUI.createNotification(title, message, type, duration)
    local theme = FischnishedUI.getCurrentTheme()
    local notifColor = theme.Accent
    
    if type == "success" then
        notifColor = theme.Success
    elseif type == "warning" then
        notifColor = theme.Warning
    elseif type == "error" then
        notifColor = theme.Error
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "FischnishedNotification"
    gui.Parent = Services.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 350, 0, 100)
    container.Position = UDim2.new(1, -370, 0, 20)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.ZIndex = 1000
    container.Parent = gui
    
    FischnishedUI.createCorner(container, 12)
    FischnishedUI.createShadow(container)
    FischnishedUI.createStroke(container, 2, notifColor)
    
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Size = UDim2.new(0, 60, 1, 0)
    iconFrame.Position = UDim2.new(0, 0, 0, 0)
    iconFrame.BackgroundColor3 = notifColor
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = container
    
    FischnishedUI.createCorner(iconFrame, 12)
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = type == "success" and "✅" or type == "warning" and "⚠️" or type == "error" and "❌" or "🎮"
    icon.TextColor3 = Color3.new(1, 1, 1)
    icon.TextScaled = true
    icon.Font = Enum.Font.SourceSansBold
    icon.Parent = iconFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -70, 0, 35)
    titleLabel.Position = UDim2.new(0, 65, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -70, 0, 55)
    messageLabel.Position = UDim2.new(0, 65, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = theme.TextSecondary
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = container
    
    -- Progress bar
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = notifColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = container
    
    FischnishedUI.createCorner(progressBar, 2)
    
    -- Animate in
    container.Position = UDim2.new(1, 0, 0, 20)
    FischnishedUI.tweenProperty(container, {Position = UDim2.new(1, -370, 0, 20)}, 0.5, Enum.EasingStyle.Back)
    
    -- Progress animation
    local progressTween = FischnishedUI.tweenProperty(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration or 3)
    
    -- Auto destroy
    task.delay(duration or 3, function()
        FischnishedUI.tweenProperty(container, {Position = UDim2.new(1, 0, 0, 20)}, 0.3)
        task.delay(0.3, function()
            gui:Destroy()
        end)
    end)
    
    -- Click to dismiss
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            progressTween:Cancel()
            FischnishedUI.tweenProperty(container, {Position = UDim2.new(1, 0, 0, 20)}, 0.3)
            task.delay(0.3, function()
                gui:Destroy()
            end)
        end
    end)
end

-- Key System
function FischnishedUI.setupKeySystem(config)
    FischnishedUI.State.keySystem = {
        enabled = config.enabled or false,
        title = config.title or "Fischnished Premium",
        subtitle = config.subtitle or "Enter your license key",
        note = config.note or "Get your key from our Discord server",
        keys = config.keys or {},
        saveKey = config.saveKey or true,
        fileName = config.fileName or "FischnishedKey",
        authenticated = false
    }
    
    if FischnishedUI.State.keySystem.enabled then
        return FischnishedUI.showKeyPrompt()
    end
    
    return true
end

function FischnishedUI.showKeyPrompt()
    local theme = FischnishedUI.getCurrentTheme()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "FischnishedKeySystem"
    gui.Parent = Services.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Background blur
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = gui
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 450, 0, 300)
    container.Position = UDim2.new(0.5, -225, 0.5, -150)
    container.BackgroundColor3 = theme.Background
    container.BorderSizePixel = 0
    container.ZIndex = 100
    container.Parent = gui
    
    FischnishedUI.createCorner(container, 15)
    FischnishedUI.createShadow(container)
    FischnishedUI.createStroke(container, 2, theme.Accent)
    
    -- Create key input and buttons (simplified for space)
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -40, 0, 50)
    keyInput.Position = UDim2.new(0, 20, 0.5, -25)
    keyInput.BackgroundColor3 = theme.Secondary
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your license key..."
    keyInput.TextColor3 = theme.Text
    keyInput.PlaceholderColor3 = theme.TextSecondary
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.SourceSans
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = container
    
    FischnishedUI.createCorner(keyInput, 8)
    
    -- Submit button
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0.48, 0, 0, 40)
    submitButton.Position = UDim2.new(0, 20, 0.8, 0)
    submitButton.BackgroundColor3 = theme.Success
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit Key"
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = container
    
    FischnishedUI.createCorner(submitButton, 8)
    
    -- Animation
    container.Size = UDim2.new(0, 0, 0, 0)
    FischnishedUI.tweenProperty(container, {Size = UDim2.new(0, 450, 0, 300)}, 0.5, Enum.EasingStyle.Back)
    
    -- Event handlers
    local function validateKey()
        local enteredKey = keyInput.Text:upper()
        for _, validKey in ipairs(FischnishedUI.State.keySystem.keys) do
            if enteredKey == validKey:upper() then
                FischnishedUI.State.keySystem.authenticated = true
                FischnishedUI.createNotification("Success", "Key authenticated successfully!", "success", 2)
                gui:Destroy()
                return true
            end
        end
        
        FischnishedUI.createNotification("Error", "Invalid license key!", "error", 3)
        keyInput.Text = ""
        return false
    end
    
    submitButton.MouseButton1Click:Connect(validateKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    -- Wait for authentication
    while gui.Parent and not FischnishedUI.State.keySystem.authenticated do
        task.wait(0.1)
    end
    
    return FischnishedUI.State.keySystem.authenticated
end

-- Main window creation
function FischnishedUI.createWindow(config)
    if FischnishedUI.State.keySystem.enabled and not FischnishedUI.State.keySystem.authenticated then
        return nil
    end
    
    local theme = FischnishedUI.getCurrentTheme()
    
    -- Main ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "FischnishedUI"
    gui.Parent = Services.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 600, 0, 400)
    container.Position = UDim2.new(0.5, -300, 0.5, -200)
    container.BackgroundColor3 = theme.Background
    container.BorderSizePixel = 0
    container.Active = true
    container.Parent = gui
    
    FischnishedUI.createCorner(container, 12)
    FischnishedUI.createShadow(container)
    FischnishedUI.createStroke(container, 1, theme.Border)
    
    -- Header/Title bar
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = theme.Secondary
    header.BorderSizePixel = 0
    header.Parent = container
    
    FischnishedUI.createCorner(header, 12)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name or "Fischnished UI"
    title.TextColor3 = theme.Text
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = theme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = header
    
    FischnishedUI.createCorner(closeButton, 15)
    FischnishedUI.addHoverEffect(closeButton)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = theme.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = container
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 4
    tabList.ScrollBarImageColor3 = theme.Accent
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabList
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -150, 1, -50)
    contentContainer.Position = UDim2.new(0, 150, 0, 50)
    contentContainer.BackgroundColor3 = theme.Background
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = container
    
    -- Setup basic dragging
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = container.Position
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            local delta = input.Position - dragStart
            container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        FischnishedUI.destroyWindow()
    end)
    
    -- Store references
    FischnishedUI.State.window = {
        gui = gui,
        container = container,
        tabList = tabList,
        tabListLayout = tabListLayout,
        contentContainer = contentContainer,
        config = config
    }
    
    -- Auto-resize tab list
    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Initialize with animation
    container.Size = UDim2.new(0, 0, 0, 0)
    FischnishedUI.tweenProperty(container, {Size = UDim2.new(0, 600, 0, 400)}, 0.5, Enum.EasingStyle.Back)
    
    return FischnishedUI.State.window
end

-- Tab creation
function FischnishedUI.createTab(name, icon)
    if not FischnishedUI.State.window then
        warn("Window not created yet!")
        return nil
    end
    
    local theme = FischnishedUI.getCurrentTheme()
    local tabButton = Instance.new("TextButton")
    local tabContent = Instance.new("ScrollingFrame")
    
    -- Tab Button
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.BackgroundColor3 = theme.Secondary
    tabButton.BorderSizePixel = 0
    tabButton.Text = (icon and icon .. " " or "") .. name
    tabButton.TextColor3 = theme.TextSecondary
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.SourceSans
    tabButton.Parent = FischnishedUI.State.window.tabList
    
    FischnishedUI.createCorner(tabButton, 6)
    
    -- Tab Content
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, -10, 1, -10)
    tabContent.Position = UDim2.new(0, 5, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = theme.Accent
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = FischnishedUI.State.window.contentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = tabContent
    
    -- Auto-resize content
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab switching
    local function selectTab()
        -- Hide all tabs
        for _, tab in pairs(FischnishedUI.State.tabs) do
            tab.content.Visible = false
            tab.button.BackgroundColor3 = theme.Secondary
            tab.button.TextColor3 = theme.TextSecondary
        end
        
        -- Show selected tab
        tabContent.Visible = true
        tabButton.BackgroundColor3 = theme.Accent
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        FischnishedUI.State.currentTab = name
        
        -- Animate selection
        FischnishedUI.tweenProperty(tabButton, {BackgroundColor3 = theme.Accent}, 0.2)
    end
    
    tabButton.MouseButton1Click:Connect(function()
        FischnishedUI.createRippleEffect(tabButton, Vector2.new(tabButton.AbsoluteSize.X/2, tabButton.AbsoluteSize.Y/2))
        selectTab()
    end)
    
    FischnishedUI.addHoverEffect(tabButton, theme.AccentHover, theme.Secondary)
    
    -- Store tab
    FischnishedUI.State.tabs[name] = {
        button = tabButton,
        content = tabContent,
        layout = contentLayout,
        name = name
    }
    
    -- Select first tab automatically
    if #FischnishedUI.State.window.tabList:GetChildren() == 2 then -- Layout + first tab
        selectTab()
    end
    
    return {
        CreateButton = function(config)
            return FischnishedUI.createButton(tabContent, config)
        end,
        CreateToggle = function(config)
            return FischnishedUI.createToggle(tabContent, config)
        end,
        CreateSlider = function(config)
            return FischnishedUI.createSlider(tabContent, config)
        end,
        CreateDropdown = function(config)
            return FischnishedUI.createDropdown(tabContent, config)
        end,
        CreateTextbox = function(config)
            return FischnishedUI.createTextbox(tabContent, config)
        end,
        CreateParagraph = function(config)
            return FischnishedUI.createParagraph(tabContent, config)
        end
    }
end

-- Component creation functions (simplified versions)
function FischnishedUI.createButton(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = theme.Accent
    button.BorderSizePixel = 0
    button.Text = config.Name or "Button"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    
    FischnishedUI.createCorner(button, 6)
    FischnishedUI.addHoverEffect(button, theme.AccentHover)
    
    button.MouseButton1Click:Connect(function()
        FischnishedUI.createRippleEffect(button, Vector2.new(button.AbsoluteSize.X/2, button.AbsoluteSize.Y/2))
        if config.Callback then
            config.Callback()
        end
    end)
    
    return button
end

function FischnishedUI.createToggle(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    local currentValue = config.CurrentValue or false
    
    local container = Instance.new("Frame")
    container.Name = config.Name or "Toggle"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Name = "ToggleButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = theme.Secondary
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = container
    
    FischnishedUI.createCorner(button, 6)
    FischnishedUI.createStroke(button, 1, theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleFrame.BackgroundColor3 = currentValue and theme.Success or theme.Border
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = button
    
    FischnishedUI.createCorner(toggleFrame, 12)
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = currentValue and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleFrame
    
    FischnishedUI.createCorner(toggleCircle, 10)
    FischnishedUI.createShadow(toggleCircle)
    
    local function updateToggle(value)
        currentValue = value
        
        FischnishedUI.tweenProperty(toggleFrame, {
            BackgroundColor3 = value and theme.Success or theme.Border
        }, 0.2)
        
        FischnishedUI.tweenProperty(toggleCircle, {
            Position = value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        }, 0.2, Enum.EasingStyle.Quad)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        updateToggle(not currentValue)
    end)
    
    FischnishedUI.addHoverEffect(button, theme.Background, theme.Secondary)
    
    -- Initialize
    updateToggle(currentValue)
    
    return {
        SetValue = updateToggle,
        GetValue = function() return currentValue end
    }
end

function FischnishedUI.createSlider(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    local min = config.Range[1] or 0
    local max = config.Range[2] or 100
    local increment = config.Increment or 1
    local currentValue = config.CurrentValue or min
    local suffix = config.Suffix or ""
    
    local container = Instance.new("Frame")
    container.Name = config.Name or "Slider"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Slider"
    label.TextColor3 = theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentValue) .. suffix
    valueLabel.TextColor3 = theme.Accent
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.SourceSansBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = theme.Border
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    FischnishedUI.createCorner(sliderFrame, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    FischnishedUI.createCorner(sliderFill, 10)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderFrame
    
    FischnishedUI.createCorner(sliderKnob, 8)
    FischnishedUI.createShadow(sliderKnob)
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        value = math.round(value / increment) * increment
        currentValue = value
        
        local percentage = (value - min) / (max - min)
        
        FischnishedUI.tweenProperty(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
        FischnishedUI.tweenProperty(sliderKnob, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
        
        valueLabel.Text = tostring(value) .. suffix
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    local dragging = false
    
    local function handleInput(input)
        local relativeX = input.Position.X - sliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
        local newValue = min + (max - min) * percentage
        updateSlider(newValue)
    end
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            handleInput(input)
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            handleInput(input)
        end
    end)
    
    -- Initialize
    updateSlider(currentValue)
    
    return {
        SetValue = updateSlider,
        GetValue = function() return currentValue end
    }
end

function FischnishedUI.createDropdown(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    local options = config.Options or {}
    local currentOption = config.CurrentOption or (options[1] or "None")
    local isOpen = false
    
    local container = Instance.new("Frame")
    container.Name = config.Name or "Dropdown"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Name = "DropdownButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = theme.Secondary
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = container
    
    FischnishedUI.createCorner(button, 6)
    FischnishedUI.createStroke(button, 1, theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Dropdown"
    label.TextColor3 = theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.Size = UDim2.new(0.4, 0, 1, 0)
    selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = currentOption
    selectedLabel.TextColor3 = theme.Accent
    selectedLabel.TextScaled = true
    selectedLabel.Font = Enum.Font.SourceSansBold
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    selectedLabel.Parent = button
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = theme.TextSecondary
    arrow.TextScaled = true
    arrow.Font = Enum.Font.SourceSans
    arrow.Parent = button
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150))
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = theme.Secondary
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 100
    optionsFrame.Parent = container
    
    FischnishedUI.createCorner(optionsFrame, 6)
    FischnishedUI.createStroke(optionsFrame, 1, theme.Border)
    FischnishedUI.createShadow(optionsFrame)
    
    local optionsList = Instance.new("ScrollingFrame")
    optionsList.Name = "OptionsList"
    optionsList.Size = UDim2.new(1, -10, 1, -10)
    optionsList.Position = UDim2.new(0, 5, 0, 5)
    optionsList.BackgroundTransparency = 1
    optionsList.BorderSizePixel = 0
    optionsList.ScrollBarThickness = 4
    optionsList.ScrollBarImageColor3 = theme.Accent
    optionsList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    optionsList.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsList
    
    local function createOptionButton(option)
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Size = UDim2.new(1, 0, 0, 28)
        optionButton.BackgroundColor3 = theme.Secondary
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = theme.Text
        optionButton.TextScaled = true
        optionButton.Font = Enum.Font.SourceSans
        optionButton.Parent = optionsList
        
        FischnishedUI.createCorner(optionButton, 4)
        FischnishedUI.addHoverEffect(optionButton, theme.Background)
        
        optionButton.MouseButton1Click:Connect(function()
            currentOption = option
            selectedLabel.Text = option
            isOpen = false
            optionsFrame.Visible = false
            arrow.Text = "▼"
            
            if config.Callback then
                config.Callback(option)
            end
        end)
        
        return optionButton
    end
    
    -- Create option buttons
    for _, option in ipairs(options) do
        createOptionButton(option)
    end
    
    local function toggleDropdown()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        arrow.Text = isOpen and "▲" or "▼"
        
        if isOpen then
            container.Size = UDim2.new(1, 0, 0, 35 + optionsFrame.AbsoluteSize.Y + 5)
        else
            container.Size = UDim2.new(1, 0, 0, 35)
        end
    end
    
    button.MouseButton1Click:Connect(toggleDropdown)
    FischnishedUI.addHoverEffect(button, theme.Background, theme.Secondary)
    
    return {
        SetOptions = function(newOptions)
            options = newOptions
            optionsList:ClearAllChildren()
            optionsLayout.Parent = optionsList
            
            for _, option in ipairs(options) do
                createOptionButton(option)
            end
            
            optionsFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150))
            optionsList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
        end,
        SetSelected = function(option)
            currentOption = option
            selectedLabel.Text = option
        end,
        GetSelected = function() return currentOption end
    }
end

function FischnishedUI.createParagraph(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    
    local container = Instance.new("Frame")
    container.Name = config.Title or "Paragraph"
    container.Size = UDim2.new(1, 0, 0, 80)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.Parent = parent
    
    FischnishedUI.createCorner(container, 6)
    FischnishedUI.createStroke(container, 1, theme.Border)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Title"
    title.TextColor3 = theme.Text
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    local content = Instance.new("TextLabel")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.BackgroundTransparency = 1
    content.Text = config.Content or "Content"
    content.TextColor3 = theme.TextSecondary
    content.TextScaled = true
    content.Font = Enum.Font.SourceSans
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.Parent = container
    
    return container
end

function FischnishedUI.createTextbox(parent, config)
    local theme = FischnishedUI.getCurrentTheme()
    local currentText = config.CurrentText or ""
    
    local container = Instance.new("Frame")
    container.Name = config.Name or "Textbox"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local frame = Instance.new("Frame")
    frame.Name = "TextboxFrame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = theme.Secondary
    frame.BorderSizePixel = 0
    frame.Parent = container
    
    FischnishedUI.createCorner(frame, 6)
    FischnishedUI.createStroke(frame, 1, theme.Border)
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Textbox"
    label.TextColor3 = theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "Textbox"
    textbox.Size = UDim2.new(0.65, 0, 0.8, 0)
    textbox.Position = UDim2.new(0.33, 0, 0.1, 0)
    textbox.BackgroundColor3 = theme.Background
    textbox.BorderSizePixel = 0
    textbox.Text = currentText
    textbox.PlaceholderText = config.PlaceholderText or "Enter text..."
    textbox.TextColor3 = theme.Text
    textbox.PlaceholderColor3 = theme.TextSecondary
    textbox.TextScaled = true
    textbox.Font = Enum.Font.SourceSans
    textbox.ClearTextOnFocus = config.ClearTextOnFocus or false
    textbox.Parent = frame
    
    FischnishedUI.createCorner(textbox, 4)
    FischnishedUI.createStroke(textbox, 1, theme.Border)
    
    textbox.FocusLost:Connect(function(enterPressed)
        if config.Callback then
            config.Callback(textbox.Text, enterPressed)
        end
    end)
    
    return {
        SetText = function(text)
            textbox.Text = text
        end,
        GetText = function()
            return textbox.Text
        end
    }
end

-- Window Management
function FischnishedUI.destroyWindow()
    if FischnishedUI.State.window and FischnishedUI.State.window.gui then
        FischnishedUI.State.window.gui:Destroy()
        FischnishedUI.State.window = nil
        FischnishedUI.State.tabs = {}
        FischnishedUI.State.currentTab = nil
    end
end

function FischnishedUI.toggleWindow()
    if FischnishedUI.State.window and FischnishedUI.State.window.container then
        FischnishedUI.State.isVisible = not FischnishedUI.State.isVisible
        FischnishedUI.State.window.container.Visible = FischnishedUI.State.isVisible
    end
end

return FischnishedUI
