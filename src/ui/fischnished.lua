-- FischnishedUI - Custom UI Library
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
    dragData = {
        isDragging = false,
        startPos = Vector2.new(0, 0),
        offset = Vector2.new(0, 0)
    },
    components = {},
    notifications = {},
    keySystem = {
        enabled = false,
        keys = {},
        authenticated = false
    },
    config = {}
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
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = theme.Accent
    header.BorderSizePixel = 0
    header.Parent = container
    
    FischnishedUI.createCorner(header, 15)
    
    local headerMask = Instance.new("Frame")
    headerMask.Size = UDim2.new(1, 0, 0, 40)
    headerMask.Position = UDim2.new(0, 0, 1, -40)
    headerMask.BackgroundColor3 = theme.Accent
    headerMask.BorderSizePixel = 0
    headerMask.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = FischnishedUI.State.keySystem.title
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -20, 0, 30)
    subtitle.Position = UDim2.new(0, 10, 0, 45)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = FischnishedUI.State.keySystem.subtitle
    subtitle.TextColor3 = Color3.new(1, 1, 1)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.SourceSans
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextTransparency = 0.3
    subtitle.Parent = header
    
    -- Key input
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(1, -40, 0, 50)
    inputFrame.Position = UDim2.new(0, 20, 0, 100)
    inputFrame.BackgroundColor3 = theme.Secondary
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = container
    
    FischnishedUI.createCorner(inputFrame, 8)
    FischnishedUI.createStroke(inputFrame, 1, theme.Border)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your license key..."
    keyInput.TextColor3 = theme.Text
    keyInput.PlaceholderColor3 = theme.TextSecondary
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.SourceSans
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputFrame
    
    -- Note
    local note = Instance.new("TextLabel")
    note.Name = "Note"
    note.Size = UDim2.new(1, -40, 0, 60)
    note.Position = UDim2.new(0, 20, 0, 170)
    note.BackgroundTransparency = 1
    note.Text = FischnishedUI.State.keySystem.note
    note.TextColor3 = theme.TextSecondary
    note.TextScaled = true
    note.Font = Enum.Font.SourceSans
    note.TextWrapped = true
    note.Parent = container
    
    -- Buttons
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -40, 0, 40)
    buttonFrame.Position = UDim2.new(0, 20, 0, 240)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = container
    
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0.48, 0, 1, 0)
    submitButton.Position = UDim2.new(0, 0, 0, 0)
    submitButton.BackgroundColor3 = theme.Success
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit Key"
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Parent = buttonFrame
    
    FischnishedUI.createCorner(submitButton, 8)
    FischnishedUI.addHoverEffect(submitButton, theme.Success)
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.48, 0, 1, 0)
    cancelButton.Position = UDim2.new(0.52, 0, 0, 0)
    cancelButton.BackgroundColor3 = theme.Error
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Color3.new(1, 1, 1)
    cancelButton.TextScaled = true
    cancelButton.Font = Enum.Font.SourceSansBold
    cancelButton.Parent = buttonFrame
    
    FischnishedUI.createCorner(cancelButton, 8)
    FischnishedUI.addHoverEffect(cancelButton, theme.Error)
    
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
        FischnishedUI.tweenProperty(container, {Position = UDim2.new(0.5, -235, 0.5, -150)}, 0.1)
        FischnishedUI.tweenProperty(container, {Position = UDim2.new(0.5, -225, 0.5, -150)}, 0.1)
        return false
    end
    
    submitButton.MouseButton1Click:Connect(validateKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        FischnishedUI.State.keySystem.authenticated = false
    end)
    
    -- Wait for authentication
    while gui.Parent and not FischnishedUI.State.keySystem.authenticated do
        task.wait(0.1)
    end
    
    return FischnishedUI.State.keySystem.authenticated
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
