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

-- UI Constants and Styling - Inspired by Modern Designs like Fluent and Linoria
local COLORS = {
    Primary = Color3.fromRGB(25, 118, 210),      -- Blue Primary
    Secondary = Color3.fromRGB(66, 165, 245),    -- Light Blue
    Accent = Color3.fromRGB(255, 152, 0),        -- Orange Accent

    Background = Color3.fromRGB(33, 33, 33),     -- Dark Background
    Surface = Color3.fromRGB(48, 48, 48),        -- Surface Cards
    SurfaceHover = Color3.fromRGB(66, 66, 66),   -- Hover State

    TextPrimary = Color3.fromRGB(255, 255, 255), -- Main Text
    TextSecondary = Color3.fromRGB(189, 189, 189), -- Sub Text
    TextDisabled = Color3.fromRGB(158, 158, 158), -- Muted

    Success = Color3.fromRGB(102, 187, 106),     -- Green
    Warning = Color3.fromRGB(255, 167, 38),      -- Orange
    Error = Color3.fromRGB(239, 83, 80),         -- Red

    Border = Color3.fromRGB(97, 97, 97),         -- Borders
    BorderFocus = Color3.fromRGB(25, 118, 210),  -- Focus
}

local FONTS = {
    Regular = Enum.Font.SourceSans,
    Bold = Enum.Font.SourceSansBold,
    SemiBold = Enum.Font.SourceSansSemibold,
    Light = Enum.Font.SourceSansLight,
    Mono = Enum.Font.Code,
}

local ANIMATIONS = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Utility Functions - Clean and Minimal
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 5)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or COLORS.Border
    stroke.Transparency = transparency or 0.7
    return stroke
end

local function CreatePadding(left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    return padding
end

-- Main Tab Class
local Tab = {}
Tab.__index = Tab

function Tab:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. name
    Section.Size = UDim2.new(1, 0, 0, 28)
    Section.BackgroundTransparency = 1
    Section.Parent = self.Content

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = name
    SectionTitle.TextColor3 = COLORS.TextSecondary
    SectionTitle.TextSize = 15
    SectionTitle.Font = FONTS.SemiBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section

    local SectionDivider = Instance.new("Frame")
    SectionDivider.Size = UDim2.new(1, 0, 0, 1)
    SectionDivider.Position = UDim2.new(0, 0, 1, -1)
    SectionDivider.BackgroundColor3 = COLORS.Border
    SectionDivider.BackgroundTransparency = 0.8
    SectionDivider.BorderSizePixel = 0
    SectionDivider.Parent = Section

    return Section
end

function Tab:CreateButton(config)
    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. (config.Name or "Button")
    Button.Size = UDim2.new(1, 0, 0, 34)
    Button.BackgroundColor3 = COLORS.Surface
    Button.Text = config.Name or "Button"
    Button.TextColor3 = COLORS.TextPrimary
    Button.TextSize = 14
    Button.Font = FONTS.Regular
    Button.Parent = self.Content

    CreateCorner(5).Parent = Button
    CreatePadding(12, 12, 0, 0).Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)

    Button.MouseButton1Click:Connect(config.Callback or function() end)

    return Button
end

function Tab:CreateToggle(config)
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle_" .. (config.Name or "Toggle")
    Toggle.Size = UDim2.new(1, 0, 0, 34)
    Toggle.BackgroundColor3 = COLORS.Surface
    Toggle.Parent = self.Content

    CreateCorner(5).Parent = Toggle

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name or "Toggle"
    ToggleLabel.TextColor3 = COLORS.TextPrimary
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = FONTS.Regular
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = Toggle

    local ToggleSwitch = Instance.new("Frame")
    ToggleSwitch.Size = UDim2.new(0, 38, 0, 18)
    ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -9)
    ToggleSwitch.BackgroundColor3 = COLORS.Background
    ToggleSwitch.Parent = Toggle

    CreateCorner(9).Parent = ToggleSwitch

    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
    ToggleKnob.Position = UDim2.new(0, 1, 0, 1)
    ToggleKnob.BackgroundColor3 = COLORS.TextDisabled
    ToggleKnob.Parent = ToggleSwitch

    CreateCorner(8).Parent = ToggleKnob

    local toggled = config.CurrentValue or false

    local function updateToggleState()
        if toggled then
            TweenService:Create(ToggleSwitch, ANIMATIONS.Medium, {BackgroundColor3 = COLORS.Primary}):Play()
            TweenService:Create(ToggleKnob, ANIMATIONS.Medium, {Position = UDim2.new(1, -17, 0, 1), BackgroundColor3 = COLORS.TextPrimary}):Play()
        else
            TweenService:Create(ToggleSwitch, ANIMATIONS.Medium, {BackgroundColor3 = COLORS.Background}):Play()
            TweenService:Create(ToggleKnob, ANIMATIONS.Medium, {Position = UDim2.new(0, 1, 0, 1), BackgroundColor3 = COLORS.TextDisabled}):Play()
        end
    end

    updateToggleState()

    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggleState()
        if config.Callback then
            config.Callback(toggled)
        end
    end)

    Toggle.MouseEnter:Connect(function()
        TweenService:Create(Toggle, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover}):Play()
    end)

    Toggle.MouseLeave:Connect(function()
        TweenService:Create(Toggle, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)

    return Toggle
end

function Tab:CreateSlider(config)
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider_" .. (config.Name or "Slider")
    Slider.Size = UDim2.new(1, 0, 0, 50)
    Slider.BackgroundColor3 = COLORS.Surface
    Slider.Parent = self.Content

    CreateCorner(5).Parent = Slider

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -60, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 4)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name or "Slider"
    SliderLabel.TextColor3 = COLORS.TextPrimary
    SliderLabel.TextSize = 14
    SliderLabel.Font = FONTS.Regular
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = Slider

    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -62, 0, 4)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(config.CurrentValue or config.Range[1])
    SliderValue.TextColor3 = COLORS.Secondary
    SliderValue.TextSize = 13
    SliderValue.Font = FONTS.SemiBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = Slider

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -24, 0, 4)
    SliderBar.Position = UDim2.new(0, 12, 1, -18)
    SliderBar.BackgroundColor3 = COLORS.Background
    SliderBar.Parent = Slider

    CreateCorner(2).Parent = SliderBar

    local SliderProgress = Instance.new("Frame")
    SliderProgress.Size = UDim2.new(0, 0, 1, 0)
    SliderProgress.BackgroundColor3 = COLORS.Primary
    SliderProgress.Parent = SliderBar

    CreateCorner(2).Parent = SliderProgress

    local SliderHandle = Instance.new("Frame")
    SliderHandle.Size = UDim2.new(0, 12, 0, 12)
    SliderHandle.Position = UDim2.new(0, -6, 0.5, -6)
    SliderHandle.BackgroundColor3 = COLORS.TextPrimary
    SliderHandle.Parent = SliderProgress

    CreateCorner(6).Parent = SliderHandle

    local dragging = false
    local range = config.Range or {0, 100}
    local current = config.CurrentValue or range[1]
    local increment = config.Increment or 1
    local suffix = config.Suffix or ""

    local function updateValue(value)
        value = math.clamp(value, range[1], range[2])
        if increment then value = math.round(value / increment) * increment end

        local pct = (value - range[1]) / (range[2] - range[1])
        TweenService:Create(SliderProgress, ANIMATIONS.Fast, {Size = UDim2.new(pct, 0, 1, 0)}):Play()
        SliderValue.Text = tostring(value) .. suffix
        current = value
        if config.Callback then config.Callback(value) end
    end

    SliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * pct
            updateValue(value)
        end
    end)

    Slider.MouseEnter:Connect(function()
        TweenService:Create(Slider, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover}):Play()
    end)

    Slider.MouseLeave:Connect(function()
        TweenService:Create(Slider, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)

    updateValue(current)

    return Slider
end

function Tab:CreateDropdown(config)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown_" .. (config.Name or "Dropdown")
    Dropdown.Size = UDim2.new(1, 0, 0, 34)
    Dropdown.BackgroundColor3 = COLORS.Surface
    Dropdown.ClipsDescendants = true
    Dropdown.Parent = self.Content

    CreateCorner(5).Parent = Dropdown

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 34)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = config.CurrentOption or config.Options[1] or "Select option"
    DropdownButton.TextColor3 = COLORS.TextPrimary
    DropdownButton.TextSize = 14
    DropdownButton.Font = FONTS.Regular
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = Dropdown

    CreatePadding(12, 32, 0, 0).Parent = DropdownButton

    local DropdownIcon = Instance.new("TextLabel")
    DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
    DropdownIcon.Position = UDim2.new(1, -32, 0, 0)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Text = "▼"
    DropdownIcon.TextColor3 = COLORS.TextSecondary
    DropdownIcon.TextSize = 12
    DropdownIcon.Parent = DropdownButton

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
    OptionsFrame.BackgroundColor3 = COLORS.Surface
    OptionsFrame.Parent = Dropdown

    CreateCorner(5).Parent = OptionsFrame

    local OptionsList = Instance.new("UIListLayout")
    OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsList.Padding = UDim.new(0, 4)
    OptionsList.Parent = OptionsFrame

    local isOpen = false

    local function toggleOpen()
        isOpen = not isOpen
        local height = isOpen and #config.Options * 34 or 0
        TweenService:Create(Dropdown, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, 34 + height)}):Play()
        TweenService:Create(OptionsFrame, ANIMATIONS.Medium, {Size = UDim2.new(1, 0, 0, height)}):Play()
        TweenService:Create(DropdownIcon, ANIMATIONS.Medium, {Rotation = isOpen and 180 or 0}):Play()
    end

    DropdownButton.MouseButton1Click:Connect(toggleOpen)

    for _, option in ipairs(config.Options or {}) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = COLORS.TextPrimary
        OptionButton.TextSize = 14
        OptionButton.Font = FONTS.Regular
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Parent = OptionsFrame

        CreatePadding(12, 12, 0, 0).Parent = OptionButton

        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover, BackgroundTransparency = 0}):Play()
        end)

        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {BackgroundTransparency = 1}):Play()
        end)

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            toggleOpen()
            if config.Callback then config.Callback(option) end
        end)
    end

    Dropdown.MouseEnter:Connect(function()
        TweenService:Create(Dropdown, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover}):Play()
    end)

    Dropdown.MouseLeave:Connect(function()
        TweenService:Create(Dropdown, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)

    return Dropdown
end

function Tab:CreateTextbox(config)
    local Textbox = Instance.new("Frame")
    Textbox.Name = "Textbox_" .. (config.Name or "Textbox")
    Textbox.Size = UDim2.new(1, 0, 0, 34)
    Textbox.BackgroundColor3 = COLORS.Surface
    Textbox.Parent = self.Content

    CreateCorner(5).Parent = Textbox

    local TextInput = Instance.new("TextBox")
    TextInput.Size = UDim2.new(1, 0, 1, 0)
    TextInput.BackgroundTransparency = 1
    TextInput.Text = config.CurrentValue or ""
    TextInput.PlaceholderText = config.PlaceholderText or "Enter text..."
    TextInput.PlaceholderColor3 = COLORS.TextDisabled
    TextInput.TextColor3 = COLORS.TextPrimary
    TextInput.TextSize = 14
    TextInput.Font = FONTS.Regular
    TextInput.TextXAlignment = Enum.TextXAlignment.Left
    TextInput.Parent = Textbox

    CreatePadding(12, 12, 0, 0).Parent = TextInput

    TextInput.FocusLost:Connect(function(enter)
        if config.Callback and (enter or not config.OnEnter) then config.Callback(TextInput.Text) end
    end)

    Textbox.MouseEnter:Connect(function()
        TweenService:Create(Textbox, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.SurfaceHover}):Play()
    end)

    Textbox.MouseLeave:Connect(function()
        TweenService:Create(Textbox, ANIMATIONS.Fast, {BackgroundColor3 = COLORS.Surface}):Play()
    end)

    return Textbox
end

function Tab:CreateParagraph(config)
    local Paragraph = Instance.new("Frame")
    Paragraph.Name = "Paragraph_" .. (config.Title or "Paragraph")
    Paragraph.BackgroundTransparency = 1
    Paragraph.Parent = self.Content

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Title"
    Title.TextColor3 = COLORS.TextPrimary
    Title.TextSize = 16
    Title.Font = FONTS.SemiBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextWrapped = true
    Title.Parent = Paragraph

    local Content = Instance.new("TextLabel")
    Content.Position = UDim2.new(0, 0, 0, 20)
    Content.BackgroundTransparency = 1
    Content.Text = config.Content or "Content"
    Content.TextColor3 = COLORS.TextSecondary
    Content.TextSize = 14
    Content.Font = FONTS.Regular
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextWrapped = true
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.Parent = Paragraph

    Content:GetPropertyChangedSignal("TextBounds"):Connect(function()
        Content.Size = UDim2.new(1, 0, 0, Content.TextBounds.Y)
        Paragraph.Size = UDim2.new(1, 0, 0, 20 + Content.TextBounds.Y + 8)
    end)

    return Paragraph
end

-- Main CreateWindow Function
function FischnishedUI:CreateWindow(config)
    local Window = {
        Name = config.Name or "Fischnished UI",
        Size = config.Size or UDim2.new(0, 580, 0, 420),
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

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = COLORS.Surface
    TitleBar.Parent = MainFrame

    CreateCorner(8).Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Window.Name
    TitleLabel.TextColor3 = COLORS.TextPrimary
    TitleLabel.TextSize = 16
    TitleLabel.Font = FONTS.SemiBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -16)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.TextSecondary
    CloseButton.TextSize = 20
    CloseButton.Parent = TitleBar

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = COLORS.Surface
    Sidebar.Parent = MainFrame
    Window.Sidebar = Sidebar

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = SidebarScroll

    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y)
    end)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -160, 1, -40)
    ContentFrame.Position = UDim2.new(0, 160, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    Window.ContentFrame = ContentFrame

    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Size = UDim2.new(1, 0, 1, 0)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = COLORS.Border
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.Parent = ContentFrame
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
            Content = Instance.new("Frame")
        }

        TabInstance.Content.Name = "TabContent_" .. name
        TabInstance.Content.Size = UDim2.new(1, 0, 1, 0)
        TabInstance.Content.BackgroundTransparency = 1
        TabInstance.Content.Visible = false
        TabInstance.Content.Parent = Window.ContentScroll

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabInstance.Content

        local function updateSize()
            Window.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 16)
        end

        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
        TabInstance.UpdateSize = updateSize

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = (icon or "") .. " " .. name
        TabButton.TextColor3 = COLORS.TextSecondary
        TabButton.TextSize = 15
        TabButton.Font = FONTS.Regular
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = SidebarScroll

        CreatePadding(16, 0, 0, 0).Parent = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Active = false
                t.Content.Visible = false
                TweenService:Create(t.Button, ANIMATIONS.Fast, {TextColor3 = COLORS.TextSecondary}):Play()
            end
            TabInstance.Active = true
            TabInstance.Content.Visible = true
            Window.CurrentTab = TabInstance
            TabInstance.UpdateSize()
            TweenService:Create(TabButton, ANIMATIONS.Fast, {TextColor3 = COLORS.Primary}):Play()
        end)

        if #Window.Tabs == 0 then
            TabButton.MouseButton1Click:Fire()
        end

        table.insert(Window.Tabs, TabInstance)
        TabInstance.Button = TabButton

        setmetatable(TabInstance, Tab)

        return TabInstance
    end

    return Window
end

return FischnishedUI
