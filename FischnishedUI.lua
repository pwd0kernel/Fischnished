-- Fischnished Custom UI Library
-- Modern, sleek interface with animations and custom styling
-- Built from scratch for maximum customization and performance

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local FischnishedUI = {}
FischnishedUI.__index = FischnishedUI

-- UI Constants and Styling - Redesigned for Modern, Clean, Minimal Aesthetic
local COLORS = {
    -- Main Colors
    Primary = Color3.fromRGB(103, 58, 183),      -- Deep Purple
    Secondary = Color3.fromRGB(156, 39, 176),    -- Vibrant Purple
    Accent = Color3.fromRGB(255, 193, 7),        -- Amber Accent
    
    -- Background Colors
    Background = Color3.fromRGB(18, 18, 18),     -- Deep Dark Background
    Surface = Color3.fromRGB(30, 30, 30),        -- Subtle Surface
    SurfaceVariant = Color3.fromRGB(40, 40, 40), -- Hover Surface
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),        -- Crisp White Text
    TextSecondary = Color3.fromRGB(189, 189, 189), -- Soft Gray Text
    TextMuted = Color3.fromRGB(158, 158, 158),   -- Muted Text
    
    -- State Colors
    Success = Color3.fromRGB(76, 175, 80),       -- Green Success
    Warning = Color3.fromRGB(255, 193, 7),       -- Yellow Warning
    Error = Color3.fromRGB(244, 67, 54),         -- Red Error
    
    -- Border Colors
    Border = Color3.fromRGB(66, 66, 66),         -- Subtle Gray Border
    BorderFocus = Color3.fromRGB(103, 58, 183),  -- Purple Focus
}

local FONTS = {
    Regular = Enum.Font.SourceSans,
    Bold = Enum.Font.SourceSansBold,
    Medium = Enum.Font.SourceSansSemibold,
    Light = Enum.Font.SourceSansLight,
    Mono = Enum.Font.Code,
}

local ANIMATIONS = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Utility Functions - Streamlined for Clean Design
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    return corner
end

local function CreateStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or COLORS.Border
    stroke.Transparency = 0.6
    return stroke
end

local function CreateGradient(colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new(COLORS.Primary, COLORS.Secondary)
    gradient.Rotation = rotation or 45
    return gradient
end

local function CreateShadow(radius, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, radius * 2, 1, radius * 2)
    shadow.Position = UDim2.new(0, -radius, 0, -radius)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.85
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    CreateCorner(radius or 4).Parent = shadow
    return shadow
end

local function CreatePadding(left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 8)
    padding.PaddingRight = UDim.new(0, right or 8)
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or 8)
    return padding
end

local function CreateIconLabel(text, size, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, size or 20, 0, size or 20)
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or COLORS.TextMuted
    label.TextSize = size or 20
    label.Font = FONTS.Regular
    label.TextScaled = true
    return label
end

-- Main Tab Class
local Tab = {}
Tab.__index = Tab

function Tab:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. name
    Section.Size = UDim2.new(1, 0, 0, 24)
    Section.BackgroundTransparency = 1
    Section.Parent = self.Content
    
    local SectionText = Instance.new("TextLabel")
    SectionText.Size = UDim2.new(1, 0, 1, 0)
    SectionText.BackgroundTransparency = 1
    SectionText.Text = name
    SectionText.TextColor3 = COLORS.TextSecondary
    SectionText.TextSize = 14
    SectionText.Font = FONTS.Bold
    SectionText.TextXAlignment = Enum.TextXAlignment.Left
    SectionText.Parent = Section
    
    local SectionLine = Instance.new("Frame")
    SectionLine.Size = UDim2.new(1, 0, 0, 1)
    SectionLine.Position = UDim2.new(0, 0, 1, 0)
    SectionLine.BackgroundColor3 = COLORS.Border
    SectionLine.BackgroundTransparency = 0.8
    SectionLine.Parent = Section
    
    return Section
end

function Tab:CreateButton(config)
    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. (config.Name or "Button")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = COLORS.Surface
    Button.Text = config.Name or "Button"
    Button.TextColor3 = COLORS.Text
    Button.TextSize = 14
    Button.Font = FONTS.Regular
    Button.Parent = self.Content
    
    CreateCorner(4).Parent = Button
    CreatePadding(12, 12, 0, 0).Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    if config.Callback then
        Button.MouseButton1Click:Connect(config.Callback)
    end
    
    return Button
end

function Tab:CreateToggle(config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. (config.Name or "Toggle")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
    ToggleFrame.BackgroundColor3 = COLORS.Surface
    ToggleFrame.Parent = self.Content
    
    CreateCorner(4).Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name or "Toggle"
    ToggleLabel.TextColor3 = COLORS.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = FONTS.Regular
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Size = UDim2.new(0, 32, 0, 16)
    ToggleButton.Position = UDim2.new(1, -44, 0.5, -8)
    ToggleButton.BackgroundColor3 = COLORS.Background
    ToggleButton.Parent = ToggleFrame
    
    CreateCorner(8).Parent = ToggleButton
    
    local ToggleSlider = Instance.new("Frame")
    ToggleSlider.Size = UDim2.new(0, 12, 0, 12)
    ToggleSlider.Position = UDim2.new(0, 2, 0, 2)
    ToggleSlider.BackgroundColor3 = COLORS.TextMuted
    ToggleSlider.Parent = ToggleButton
    
    CreateCorner(6).Parent = ToggleSlider
    
    local toggled = config.CurrentValue or false
    
    local function updateToggle()
        if toggled then
            TweenService:Create(ToggleButton, ANIMATIONS.Medium, {BackgroundColor3 = COLORS.Primary}):Play()
            TweenService:Create(ToggleSlider, ANIMATIONS.Medium, {Position = UDim2.new(1, -14, 0, 2), BackgroundColor3 = COLORS.Text}):Play()
        else
            TweenService:Create(ToggleButton, ANIMATIONS.Medium, {BackgroundColor3 = COLORS.Background}):Play()
            TweenService:Create(ToggleSlider, ANIMATIONS.Medium, {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = COLORS.TextMuted}):Play()
        end
    end
    
    updateToggle()
    
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            updateToggle()
            if config.Callback then
                config.Callback(toggled)
            end
        end
    end)
    
    ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    return ToggleFrame
end

function Tab:CreateSlider(config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. (config.Name or "Slider")
    SliderFrame.Size = UDim2.new(1, 0, 0, 48)
    SliderFrame.BackgroundColor3 = COLORS.Surface
    SliderFrame.Parent = self.Content
    
    CreateCorner(4).Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -60, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 4)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name or "Slider"
    SliderLabel.TextColor3 = COLORS.Text
    SliderLabel.TextSize = 14
    SliderLabel.Font = FONTS.Regular
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 48, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(config.CurrentValue or config.Range[1])
    ValueLabel.TextColor3 = COLORS.Primary
    ValueLabel.TextSize = 12
    ValueLabel.Font = FONTS.Medium
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -24, 0, 4)
    SliderBack.Position = UDim2.new(0, 12, 1, -16)
    SliderBack.BackgroundColor3 = COLORS.Background
    SliderBack.Parent = SliderFrame
    
    CreateCorner(2).Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.Primary
    SliderFill.Parent = SliderBack
    
    CreateCorner(2).Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Position = UDim2.new(0, -5, 0.5, -5)
    SliderButton.BackgroundColor3 = COLORS.Text
    SliderButton.Text = ""
    SliderButton.Parent = SliderFill
    
    CreateCorner(5).Parent = SliderButton
    
    local dragging = false
    local range = config.Range or {0, 100}
    local increment = config.Increment or 1
    local suffix = config.Suffix or ""
    local currentValue = config.CurrentValue or range[1]
    
    local function updateSlider(value)
        value = math.clamp(value, range[1], range[2])
        if increment then
            value = math.round(value / increment) * increment
        end
        
        local percentage = (value - range[1]) / (range[2] - range[1])
        
        TweenService:Create(SliderFill, ANIMATIONS.Fast, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        
        ValueLabel.Text = tostring(value) .. suffix
        currentValue = value
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    local function onDrag(input)
        if dragging then
            local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * relativeX
            updateSlider(value)
        end
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            TweenService:Create(SliderButton, ANIMATIONS.Fast, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, -6, 0.5, -6)}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(onDrag)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(SliderButton, ANIMATIONS.Fast, {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, -5, 0.5, -5)}):Play()
        end
    end)
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * relativeX
            updateSlider(value)
        end
    end)
    
    SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(SliderFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
    end)
    
    SliderFrame.MouseLeave:Connect(function()
        TweenService:Create(SliderFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    updateSlider(currentValue)
    
    return SliderFrame
end

function Tab:CreateDropdown(config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown_" .. (config.Name or "Dropdown")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
    DropdownFrame.BackgroundColor3 = COLORS.Surface
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Content
    
    CreateCorner(4).Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = config.CurrentOption or config.Options[1] or "Select"
    DropdownButton.TextColor3 = COLORS.Text
    DropdownButton.TextSize = 14
    DropdownButton.Font = FONTS.Regular
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = DropdownFrame
    
    CreatePadding(12, 32, 0, 0).Parent = DropdownButton
    
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Size = UDim2.new(0, 16, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -24, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = COLORS.TextMuted
    DropdownArrow.TextSize = 12
    DropdownArrow.Parent = DropdownButton
    
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 1, 0)
    OptionsContainer.BackgroundColor3 = COLORS.SurfaceVariant
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.Parent = DropdownFrame
    
    CreateCorner(4).Parent = OptionsContainer
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 4)
    OptionsLayout.Parent = OptionsContainer
    
    local isOpen = false
    
    local function createOption(option)
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = COLORS.Text
        OptionButton.TextSize = 14
        OptionButton.Font = FONTS.Regular
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Parent = OptionsContainer
        
        CreatePadding(12, 0, 0, 0).Parent = OptionButton
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Primary, BackgroundTransparency = 0.95}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {BackgroundTransparency = 1}):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            isOpen = false
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 32)}):Play()
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {Rotation = 0}):Play()
            if config.Callback then
                config.Callback(option)
            end
        end)
    end
    
    for _, option in ipairs(config.Options or {}) do
        createOption(option)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local height = math.min(#(config.Options or {}) * 28 + (#config.Options - 1) * 4, 120)
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 32 + height)}):Play()
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, height)}):Play()
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {Rotation = 180}):Play()
        else
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 32)}):Play()
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {Rotation = 0}):Play()
        end
    end)
    
    DropdownFrame.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
        end
    end)
    
    DropdownFrame.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
        end
    end)
    
    return DropdownFrame
end

function Tab:CreateTextbox(config)
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = "Textbox_" .. (config.Name or "Textbox")
    TextboxFrame.Size = UDim2.new(1, 0, 0, 48)
    TextboxFrame.BackgroundColor3 = COLORS.Surface
    TextboxFrame.Parent = self.Content
    
    CreateCorner(4).Parent = TextboxFrame
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
    TextboxLabel.Position = UDim2.new(0, 12, 0, 4)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = config.Name or "Textbox"
    TextboxLabel.TextColor3 = COLORS.Text
    TextboxLabel.TextSize = 14
    TextboxLabel.Font = FONTS.Regular
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    local Textbox = Instance.new("TextBox")
    Textbox.Size = UDim2.new(1, -24, 0, 20)
    Textbox.Position = UDim2.new(0, 12, 1, -24)
    Textbox.BackgroundColor3 = COLORS.Background
    Textbox.Text = config.CurrentValue or ""
    Textbox.PlaceholderText = config.PlaceholderText or "Input..."
    Textbox.TextColor3 = COLORS.Text
    Textbox.PlaceholderColor3 = COLORS.TextMuted
    Textbox.TextSize = 14
    Textbox.Font = FONTS.Regular
    Textbox.ClearTextOnFocus = false
    Textbox.Parent = TextboxFrame
    
    CreateCorner(4).Parent = Textbox
    CreatePadding(8, 8, 0, 0).Parent = Textbox
    
    local focused = false
    
    Textbox.Focused:Connect(function()
        focused = true
        TweenService:Create(Textbox, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        focused = false
        TweenService:Create(Textbox, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Background}):Play()
        if config.Callback and (enterPressed or not config.OnEnter) then
            config.Callback(Textbox.Text)
        end
    end)
    
    TextboxFrame.MouseEnter:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceVariant}):Play()
        end
    end)
    
    TextboxFrame.MouseLeave:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
        end
    end)
    
    return TextboxFrame
end

function Tab:CreateParagraph(config)
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = "Paragraph_" .. (config.Title or "Paragraph")
    ParagraphFrame.BackgroundTransparency = 1
    ParagraphFrame.Parent = self.Content
    
    local ParagraphTitle = Instance.new("TextLabel")
    ParagraphTitle.Size = UDim2.new(1, 0, 0, 20)
    ParagraphTitle.BackgroundTransparency = 1
    ParagraphTitle.Text = config.Title or "Title"
    ParagraphTitle.TextColor3 = COLORS.Text
    ParagraphTitle.TextSize = 16
    ParagraphTitle.Font = FONTS.Bold
    ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphTitle.TextWrapped = true
    ParagraphTitle.Parent = ParagraphFrame
    
    local ParagraphContent = Instance.new("TextLabel")
    ParagraphContent.Size = UDim2.new(1, 0, 0, 0)
    ParagraphContent.Position = UDim2.new(0, 0, 0, 20)
    ParagraphContent.BackgroundTransparency = 1
    ParagraphContent.Text = config.Content or "Content"
    ParagraphContent.TextColor3 = COLORS.TextSecondary
    ParagraphContent.TextSize = 14
    ParagraphContent.Font = FONTS.Regular
    ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphContent.TextWrapped = true
    ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
    ParagraphContent.Parent = ParagraphFrame
    
    ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(function()
        ParagraphContent.Size = UDim2.new(1, 0, 0, ParagraphContent.TextBounds.Y)
        ParagraphFrame.Size = UDim2.new(1, 0, 0, 20 + ParagraphContent.TextBounds.Y + 8)
    end)
    
    return ParagraphFrame
end

-- Main CreateWindow Function
function FischnishedUI:CreateWindow(config)
    local Window = {
        Name = config.Name or "Fischnished UI",
        Size = config.Size or UDim2.new(0, 550, 0, 400),
        Tabs = {},
        CurrentTab = nil,
        Config = config,
        Dragging = false,
        DragStart = nil,
        StartPos = nil
    }
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FischnishedUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    Window.Gui = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Window.Size
    MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.Parent = ScreenGui
    Window.MainFrame = MainFrame
    
    CreateCorner(8).Parent = MainFrame
    local shadow = CreateShadow(8, 0.7)
    shadow.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = COLORS.Surface
    TitleBar.Parent = MainFrame
    
    CreateCorner(8).Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -80, 1, 0)
    TitleText.Position = UDim2.new(0, 12, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Window.Name
    TitleText.TextColor3 = COLORS.Text
    TitleText.TextSize = 16
    TitleText.Font = FONTS.Medium
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -36, 0.5, -14)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.TextMuted
    CloseButton.TextSize = 20
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, ANIMATIONS.Fast, {TextColor3 = COLORS.Error}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, ANIMATIONS.Fast, {TextColor3 = COLORS.TextMuted}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, ANIMATIONS.Spring, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = COLORS.Surface
    TabContainer.Parent = MainFrame
    Window.TabContainer = TabContainer
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabScroll
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 16, 0, 0)
    end)
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, 0, 1, -80)
    ContentArea.Position = UDim2.new(0, 0, 0, 80)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    Window.ContentArea = ContentArea
    
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Size = UDim2.new(1, 0, 1, 0)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = COLORS.Border
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.Parent = ContentArea
    Window.ContentScroll = ContentScroll
    
    -- Dragging
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Window.Dragging = true
            Window.DragStart = input.Position
            Window.StartPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Window.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - Window.DragStart
            MainFrame.Position = UDim2.new(Window.StartPos.X.Scale, Window.StartPos.X.Offset + delta.X, Window.StartPos.Y.Scale, Window.StartPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Window.Dragging = false
        end
    end)
    
    function Window:CreateTab(name, icon)
        local TabInstance = {
            Name = name,
            Icon = icon,
            Active = false,
            Window = self
        }
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. name
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = (icon and icon .. " " or "") .. name
        TabButton.TextColor3 = COLORS.TextMuted
        TabButton.TextSize = 14
        TabButton.Font = FONTS.Medium
        TabButton.Parent = TabScroll
        TabInstance.Button = TabButton
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent_" .. name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentScroll
        TabInstance.Content = TabContent
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 4)
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Parent = TabContent
        
        local function updateContentSize()
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 16)
        end
        
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentSize)
        TabInstance.UpdateSize = updateContentSize
        
        TabButton.MouseButton1Click:Connect(function()
            self:SelectTab(TabInstance)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, ANIMATIONS.Fast, {TextColor3 = COLORS.TextSecondary}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, ANIMATIONS.Fast, {TextColor3 = COLORS.TextMuted}):Play()
            end
        end)
        
        for methodName, method in pairs(Tab) do
            if type(method) == "function" then
                TabInstance[methodName] = method
            end
        end
        
        if #self.Tabs == 0 then
            self:SelectTab(TabInstance)
        end
        
        table.insert(self.Tabs, TabInstance)
        return TabInstance
    end
    
    function Window:SelectTab(tab)
        for _, existingTab in pairs(self.Tabs) do
            existingTab.Active = false
            existingTab.Content.Visible = false
            TweenService:Create(existingTab.Button, ANIMATIONS.Fast, {TextColor3 = COLORS.TextMuted}):Play()
        end
        
        tab.Active = true
        tab.Content.Visible = true
        self.CurrentTab = tab
        tab.UpdateSize()
        TweenService:Create(tab.Button, ANIMATIONS.Fast, {TextColor3 = COLORS.Primary}):Play()
    end
    
    -- Entrance Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, ANIMATIONS.Spring, {Size = Window.Size}):Play()
    
    return Window
end

return FischnishedUI
