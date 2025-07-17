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

-- UI Constants and Styling - Modern Cheat Design
local COLORS = {
    -- Main Colors
    Primary = Color3.fromRGB(88, 101, 242),       -- Discord Blurple
    Secondary = Color3.fromRGB(114, 137, 218),    -- Light Blurple
    Accent = Color3.fromRGB(255, 73, 97),         -- Red Accent
    
    -- Background Colors
    Background = Color3.fromRGB(16, 18, 25),      -- Dark Background
    Surface = Color3.fromRGB(23, 26, 35),         -- Card Surface
    SurfaceVariant = Color3.fromRGB(30, 34, 45),  -- Elevated Surface
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),         -- Primary Text
    TextSecondary = Color3.fromRGB(142, 146, 151), -- Secondary Text
    TextMuted = Color3.fromRGB(114, 118, 125),    -- Muted Text
    
    -- State Colors
    Success = Color3.fromRGB(67, 181, 129),       -- Success Green
    Warning = Color3.fromRGB(250, 166, 26),       -- Warning Orange
    Error = Color3.fromRGB(237, 66, 69),          -- Error Red
    
    -- Border Colors
    Border = Color3.fromRGB(47, 51, 64),          -- Subtle Border
    BorderFocus = Color3.fromRGB(88, 101, 242),   -- Focus Border
}

local FONTS = {
    Regular = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold,
    Medium = Enum.Font.GothamMedium,
    Light = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,
}

local ANIMATIONS = {
    Fast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Utility Functions - Enhanced for Modern Design
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
end

local function CreateStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or COLORS.Border
    stroke.Transparency = 0.3
    return stroke
end

local function CreateGradient(colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    gradient.Rotation = rotation or 0
    return gradient
end

local function CreateShadow(radius, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, radius * 2, 1, radius * 2)
    shadow.Position = UDim2.new(0, -radius, 0, -radius)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    CreateCorner(radius or 8).Parent = shadow
    return shadow
end

local function CreatePadding(left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    return padding
end

local function CreateIconLabel(text, size, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, size or 16, 0, size or 16)
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or COLORS.TextSecondary
    label.TextSize = size or 16
    label.Font = FONTS.Regular
    label.TextScaled = true
    return label
end

-- Main Window Class
local Tab = {}
Tab.__index = Tab

function Tab:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. name
    Section.Size = UDim2.new(1, -16, 0, 32)
    Section.BackgroundTransparency = 1
    Section.BorderSizePixel = 0
    Section.Parent = self.Content
    
    local SectionText = Instance.new("TextLabel")
    SectionText.Size = UDim2.new(1, 0, 1, 0)
    SectionText.Position = UDim2.new(0, 0, 0, 0)
    SectionText.BackgroundTransparency = 1
    SectionText.Text = name
    SectionText.TextColor3 = COLORS.Primary
    SectionText.TextSize = 13
    SectionText.Font = FONTS.Bold
    SectionText.TextXAlignment = Enum.TextXAlignment.Left
    SectionText.TextYAlignment = Enum.TextYAlignment.Center
    SectionText.Parent = Section
    
    -- Add subtle line under section
    local SectionLine = Instance.new("Frame")
    SectionLine.Size = UDim2.new(1, 0, 0, 1)
    SectionLine.Position = UDim2.new(0, 0, 1, -1)
    SectionLine.BackgroundColor3 = COLORS.Border
    SectionLine.BackgroundTransparency = 0.7
    SectionLine.BorderSizePixel = 0
    SectionLine.Parent = Section
    
    return Section
end

function Tab:CreateButton(config)
    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. (config.Name or "Button")
    Button.Size = UDim2.new(1, -16, 0, 36)
    Button.BackgroundColor3 = COLORS.Surface
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = self.Content
    
    CreateCorner(6).Parent = Button
    CreateStroke(1, COLORS.Border).Parent = Button
    CreatePadding(12, 12, 0, 0).Parent = Button
    
    -- Button content
    local ButtonText = Instance.new("TextLabel")
    ButtonText.Size = UDim2.new(1, -24, 1, 0)
    ButtonText.Position = UDim2.new(0, 12, 0, 0)
    ButtonText.BackgroundTransparency = 1
    ButtonText.Text = config.Name or "Button"
    ButtonText.TextColor3 = COLORS.Text
    ButtonText.TextSize = 12
    ButtonText.Font = FONTS.Regular
    ButtonText.TextXAlignment = Enum.TextXAlignment.Left
    ButtonText.TextYAlignment = Enum.TextYAlignment.Center
    ButtonText.Parent = Button
    
    -- Hover indicator
    local HoverIndicator = Instance.new("Frame")
    HoverIndicator.Size = UDim2.new(0, 3, 1, -8)
    HoverIndicator.Position = UDim2.new(0, 4, 0, 4)
    HoverIndicator.BackgroundColor3 = COLORS.Primary
    HoverIndicator.BorderSizePixel = 0
    HoverIndicator.BackgroundTransparency = 1
    HoverIndicator.Parent = Button
    
    CreateCorner(2).Parent = HoverIndicator
    
    -- Hover and click effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.SurfaceVariant
        }):Play()
        TweenService:Create(HoverIndicator, ANIMATIONS.Fast, {
            BackgroundTransparency = 0
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Surface
        }):Play()
        TweenService:Create(HoverIndicator, ANIMATIONS.Fast, {
            BackgroundTransparency = 1
        }):Play()
    end)
    
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Background
        }):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.SurfaceVariant
        }):Play()
    end)
    
    if config.Callback then
        Button.MouseButton1Click:Connect(config.Callback)
    end
    
    return Button
end

function Tab:CreateToggle(config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. (config.Name or "Toggle")
    ToggleFrame.Size = UDim2.new(1, -16, 0, 36)
    ToggleFrame.BackgroundColor3 = COLORS.Surface
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = self.Content
    
    CreateCorner(6).Parent = ToggleFrame
    CreateStroke(1, COLORS.Border).Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name or "Toggle"
    ToggleLabel.TextColor3 = COLORS.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = FONTS.Regular
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 36, 0, 18)
    ToggleButton.Position = UDim2.new(1, -48, 0.5, -9)
    ToggleButton.BackgroundColor3 = COLORS.Background
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    CreateCorner(9).Parent = ToggleButton
    CreateStroke(1, COLORS.Border).Parent = ToggleButton
    
    local ToggleSlider = Instance.new("Frame")
    ToggleSlider.Size = UDim2.new(0, 14, 0, 14)
    ToggleSlider.Position = UDim2.new(0, 2, 0, 2)
    ToggleSlider.BackgroundColor3 = COLORS.TextMuted
    ToggleSlider.BorderSizePixel = 0
    ToggleSlider.Parent = ToggleButton
    
    CreateCorner(7).Parent = ToggleSlider
    
    local toggled = config.CurrentValue or false
    
    local function updateToggle()
        if toggled then
            TweenService:Create(ToggleButton, ANIMATIONS.Medium, {
                BackgroundColor3 = COLORS.Primary
            }):Play()
            TweenService:Create(ToggleSlider, ANIMATIONS.Medium, {
                Position = UDim2.new(1, -16, 0, 2),
                BackgroundColor3 = COLORS.Text
            }):Play()
            TweenService:Create(ToggleLabel, ANIMATIONS.Fast, {
                TextColor3 = COLORS.Text
            }):Play()
        else
            TweenService:Create(ToggleButton, ANIMATIONS.Medium, {
                BackgroundColor3 = COLORS.Background
            }):Play()
            TweenService:Create(ToggleSlider, ANIMATIONS.Medium, {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = COLORS.TextMuted
            }):Play()
            TweenService:Create(ToggleLabel, ANIMATIONS.Fast, {
                TextColor3 = COLORS.Text
            }):Play()
        end
    end
    
    updateToggle()
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        if config.Callback then
            config.Callback(toggled)
        end
    end)
    
    -- Add click to frame as well
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            updateToggle()
            if config.Callback then
                config.Callback(toggled)
            end
        end
    end)
    
    -- Hover effect
    ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.SurfaceVariant
        }):Play()
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Surface
        }):Play()
    end)
    
    return ToggleFrame
end

function Tab:CreateSlider(config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. (config.Name or "Slider")
    SliderFrame.Size = UDim2.new(1, -16, 0, 58)
    SliderFrame.BackgroundColor3 = COLORS.Surface
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = self.Content
    
    CreateCorner(6).Parent = SliderFrame
    CreateStroke(1, COLORS.Border).Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -16, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 6)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name or "Slider"
    SliderLabel.TextColor3 = COLORS.Text
    SliderLabel.TextSize = 12
    SliderLabel.Font = FONTS.Regular
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -62, 0, 6)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(config.CurrentValue or config.Range[1])
    ValueLabel.TextColor3 = COLORS.Primary
    ValueLabel.TextSize = 11
    ValueLabel.Font = FONTS.Medium
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -24, 0, 4)
    SliderBack.Position = UDim2.new(0, 12, 1, -16)
    SliderBack.BackgroundColor3 = COLORS.Background
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = SliderFrame
    
    CreateCorner(2).Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    CreateCorner(2).Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 12, 0, 12)
    SliderButton.Position = UDim2.new(0, -6, 0.5, -6)
    SliderButton.BackgroundColor3 = COLORS.Text
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderFill
    
    CreateCorner(6).Parent = SliderButton
    local shadow = CreateShadow(2, 0.6)
    shadow.Parent = SliderButton
    
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
        
        TweenService:Create(SliderFill, ANIMATIONS.Fast, {
            Size = UDim2.new(percentage, 0, 1, 0)
        }):Play()
        
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
            TweenService:Create(SliderButton, ANIMATIONS.Fast, {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, -7, 0.5, -7)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(onDrag)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(SliderButton, ANIMATIONS.Fast, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -6, 0.5, -6)
            }):Play()
        end
    end)
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * relativeX
            updateSlider(value)
        end
    end)
    
    -- Hover effects
    SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(SliderFrame, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.SurfaceVariant
        }):Play()
    end)
    
    SliderFrame.MouseLeave:Connect(function()
        if not dragging then
            TweenService:Create(SliderFrame, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
        end
    end)
    
    updateSlider(currentValue)
    
    return SliderFrame
end

function Tab:CreateDropdown(config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown_" .. (config.Name or "Dropdown")
    DropdownFrame.Size = UDim2.new(1, -16, 0, 36)
    DropdownFrame.BackgroundColor3 = COLORS.Surface
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Content
    
    CreateCorner(6).Parent = DropdownFrame
    CreateStroke(1, COLORS.Border).Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, -8, 1, -8)
    DropdownButton.Position = UDim2.new(0, 4, 0, 4)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = config.CurrentOption or config.Options[1] or "Select..."
    DropdownButton.TextColor3 = COLORS.Text
    DropdownButton.TextSize = 12
    DropdownButton.Font = FONTS.Regular
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = DropdownFrame
    
    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingLeft = UDim.new(0, 8)
    DropdownPadding.PaddingRight = UDim.new(0, 24)
    DropdownPadding.Parent = DropdownButton
    
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Size = UDim2.new(0, 16, 1, 0)
    DropdownArrow.Position = UDim2.new(1, -20, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = COLORS.TextMuted
    DropdownArrow.TextSize = 8
    DropdownArrow.Font = FONTS.Regular
    DropdownArrow.Parent = DropdownButton
    
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(1, -8, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 4, 1, 4)
    OptionsContainer.BackgroundColor3 = COLORS.Surface
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.Parent = DropdownFrame
    
    CreateCorner(4).Parent = OptionsContainer
    CreateStroke(1, COLORS.Border).Parent = OptionsContainer
    local shadow = CreateShadow(4, 0.8)
    shadow.Parent = OptionsContainer
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Parent = OptionsContainer
    
    local isOpen = false
    local selectedOption = config.CurrentOption or config.Options[1]
    
    local function createOption(option)
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        OptionButton.BackgroundTransparency = 1
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = COLORS.Text
        OptionButton.TextSize = 11
        OptionButton.Font = FONTS.Regular
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Parent = OptionsContainer
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 8)
        OptionPadding.Parent = OptionButton
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.Primary,
                BackgroundTransparency = 0.9
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, ANIMATIONS.Fast, {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownButton.Text = option
            isOpen = false
            
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -16, 0, 36)
            }):Play()
            
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -8, 0, 0)
            }):Play()
            
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {
                Rotation = 0
            }):Play()
            
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
            local optionCount = #(config.Options or {})
            local containerHeight = math.min(optionCount * 28, 140)
            
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -16, 0, 36 + containerHeight + 8)
            }):Play()
            
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -8, 0, containerHeight)
            }):Play()
            
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(DropdownFrame, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -16, 0, 36)
            }):Play()
            
            TweenService:Create(OptionsContainer, ANIMATIONS.Medium, {
                Size = UDim2.new(1, -8, 0, 0)
            }):Play()
            
            TweenService:Create(DropdownArrow, ANIMATIONS.Medium, {
                Rotation = 0
            }):Play()
        end
    end)
    
    -- Hover effects
    DropdownFrame.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.SurfaceVariant
            }):Play()
        end
    end)
    
    DropdownFrame.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
        end
    end)
    
    return DropdownFrame
end

function Tab:CreateTextbox(config)
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = "Textbox_" .. (config.Name or "Textbox")
    TextboxFrame.Size = UDim2.new(1, -16, 0, 54)
    TextboxFrame.BackgroundColor3 = COLORS.Surface
    TextboxFrame.BorderSizePixel = 0
    TextboxFrame.Parent = self.Content
    
    CreateCorner(6).Parent = TextboxFrame
    CreateStroke(1, COLORS.Border).Parent = TextboxFrame
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(1, -16, 0, 18)
    TextboxLabel.Position = UDim2.new(0, 12, 0, 4)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = config.Name or "Textbox"
    TextboxLabel.TextColor3 = COLORS.Text
    TextboxLabel.TextSize = 11
    TextboxLabel.Font = FONTS.Regular
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    local Textbox = Instance.new("TextBox")
    Textbox.Size = UDim2.new(1, -20, 0, 26)
    Textbox.Position = UDim2.new(0, 10, 1, -30)
    Textbox.BackgroundColor3 = COLORS.Background
    Textbox.BorderSizePixel = 0
    Textbox.Text = config.CurrentValue or ""
    Textbox.PlaceholderText = config.PlaceholderText or "Enter text..."
    Textbox.TextColor3 = COLORS.Text
    Textbox.PlaceholderColor3 = COLORS.TextMuted
    Textbox.TextSize = 11
    Textbox.Font = FONTS.Regular
    Textbox.TextXAlignment = Enum.TextXAlignment.Left
    Textbox.ClearTextOnFocus = false
    Textbox.Parent = TextboxFrame
    
    CreateCorner(4).Parent = Textbox
    CreateStroke(1, COLORS.Border).Parent = Textbox
    
    local TextboxPadding = Instance.new("UIPadding")
    TextboxPadding.PaddingLeft = UDim.new(0, 8)
    TextboxPadding.PaddingRight = UDim.new(0, 8)
    TextboxPadding.Parent = Textbox
    
    local focused = false
    
    Textbox.Focused:Connect(function()
        focused = true
        TweenService:Create(Textbox, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.SurfaceVariant
        }):Play()
        TweenService:Create(Textbox:FindFirstChild("UIStroke"), ANIMATIONS.Fast, {
            Color = COLORS.Primary
        }):Play()
    end)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        focused = false
        TweenService:Create(Textbox, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Background
        }):Play()
        TweenService:Create(Textbox:FindFirstChild("UIStroke"), ANIMATIONS.Fast, {
            Color = COLORS.Border
        }):Play()
        
        if config.Callback and (enterPressed or not config.OnEnter) then
            config.Callback(Textbox.Text)
        end
    end)
    
    -- Hover effect
    TextboxFrame.MouseEnter:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.SurfaceVariant
            }):Play()
        end
    end)
    
    TextboxFrame.MouseLeave:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
        end
    end)
    
    return TextboxFrame
end

function Tab:CreateParagraph(config)
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = "Paragraph_" .. (config.Title or "Paragraph")
    ParagraphFrame.BackgroundColor3 = COLORS.Background
    ParagraphFrame.BorderSizePixel = 0
    ParagraphFrame.Parent = self.Content
    
    CreateCorner(8).Parent = ParagraphFrame
    
    local ParagraphTitle = Instance.new("TextLabel")
    ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
    ParagraphTitle.Position = UDim2.new(0, 15, 0, 10)
    ParagraphTitle.BackgroundTransparency = 1
    ParagraphTitle.Text = config.Title or "Title"
    ParagraphTitle.TextColor3 = COLORS.Primary
    ParagraphTitle.TextSize = 16
    ParagraphTitle.Font = FONTS.Bold
    ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
    ParagraphTitle.Parent = ParagraphFrame
    
    local ParagraphContent = Instance.new("TextLabel")
    ParagraphContent.Size = UDim2.new(1, -20, 1, -45)
    ParagraphContent.Position = UDim2.new(0, 15, 0, 35)
    ParagraphContent.BackgroundTransparency = 1
    ParagraphContent.Text = config.Content or "Content"
    ParagraphContent.TextColor3 = COLORS.TextSecondary
    ParagraphContent.TextSize = 13
    ParagraphContent.Font = FONTS.Regular
    ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
    ParagraphContent.TextWrapped = true
    ParagraphContent.Parent = ParagraphFrame
    
    -- Auto-size the frame based on content
    local textHeight = game:GetService("TextService"):GetTextSize(
        ParagraphContent.Text,
        ParagraphContent.TextSize,
        ParagraphContent.Font,
        Vector2.new(ParagraphContent.AbsoluteSize.X, math.huge)
    ).Y
    
    ParagraphFrame.Size = UDim2.new(1, -20, 0, textHeight + 55)
    
    return ParagraphFrame
end

-- Main CreateWindow function for FischnishedUI
function FischnishedUI:CreateWindow(config)
    local Window = {
        Name = config.Name or "Fischnished UI",
        Size = config.Size or UDim2.new(0, 600, 0, 450),
        Tabs = {},
        CurrentTab = nil,
        Config = config,
        Dragging = false,
        DragStart = nil,
        StartPos = nil
    }
    
    -- Create main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FischnishedUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    Window.Gui = ScreenGui
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Window.Size
    MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    Window.MainFrame = MainFrame
    
    CreateCorner(12).Parent = MainFrame
    CreateStroke(1, COLORS.Border).Parent = MainFrame
    local shadow = CreateShadow(6, 0.4)
    shadow.Parent = MainFrame
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 44)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = COLORS.Surface
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    CreateCorner(12).Parent = TitleBar
    CreateStroke(1, COLORS.Border).Parent = TitleBar
    
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Size = UDim2.new(1, 0, 0, 16)
    titleCornerFix.Position = UDim2.new(0, 0, 1, -16)
    titleCornerFix.BackgroundColor3 = COLORS.Surface
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.Parent = TitleBar
    
    -- Title text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -120, 1, 0)
    TitleText.Position = UDim2.new(0, 16, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Window.Name
    TitleText.TextColor3 = COLORS.Text
    TitleText.TextSize = 14
    TitleText.Font = FONTS.Medium
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -34, 0, 10)
    CloseButton.BackgroundColor3 = COLORS.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.Text
    CloseButton.TextSize = 14
    CloseButton.Font = FONTS.Medium
    CloseButton.Parent = TitleBar
    
    CreateCorner(12).Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, ANIMATIONS.Fast, {
            BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Error
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, ANIMATIONS.Medium, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Position = UDim2.new(1, -64, 0, 10)
    MinimizeButton.BackgroundColor3 = COLORS.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = COLORS.Text
    MinimizeButton.TextSize = 14
    MinimizeButton.Font = FONTS.Medium
    MinimizeButton.Parent = TitleBar
    
    CreateCorner(12).Parent = MinimizeButton
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, ANIMATIONS.Fast, {
            BackgroundColor3 = Color3.fromRGB(255, 200, 60)
        }):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Warning
        }):Play()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 300, 0, 44) or Window.Size
        TweenService:Create(MainFrame, ANIMATIONS.Medium, {Size = targetSize}):Play()
    end)
    
    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -54)
    TabContainer.Position = UDim2.new(0, 8, 0, 50)
    TabContainer.BackgroundColor3 = COLORS.Background
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    Window.TabContainer = TabContainer
    
    CreateCorner(12).Parent = TabContainer
    
    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -54)
    ContentArea.Position = UDim2.new(0, 154, 0, 50)
    ContentArea.BackgroundColor3 = COLORS.Surface
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    Window.ContentArea = ContentArea
    
    CreateCorner(8).Parent = ContentArea
    CreateStroke(1, COLORS.Border).Parent = ContentArea
    
    -- Add scrolling to content
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Size = UDim2.new(1, -16, 1, -16)
    ContentScroll.Position = UDim2.new(0, 8, 0, 8)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 6
    ContentScroll.ScrollBarImageColor3 = COLORS.Primary
    ContentScroll.ScrollBarImageTransparency = 0.5
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.Parent = ContentArea
    Window.ContentScroll = ContentScroll
    
    -- Tab scrolling
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, -10, 1, -10)
    TabScroll.Position = UDim2.new(0, 5, 0, 5)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 6
    TabScroll.ScrollBarImageColor3 = COLORS.Primary
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = TabContainer
    Window.TabScroll = TabScroll
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Dragging functionality
    local function onDragStart(input)
        Window.Dragging = true
        Window.DragStart = input.Position
        Window.StartPos = MainFrame.Position
    end
    
    local function onDragEnd()
        Window.Dragging = false
    end
    
    local function onDrag(input)
        if Window.Dragging then
            local delta = input.Position - Window.DragStart
            MainFrame.Position = UDim2.new(
                Window.StartPos.X.Scale,
                Window.StartPos.X.Offset + delta.X,
                Window.StartPos.Y.Scale,
                Window.StartPos.Y.Offset + delta.Y
            )
        end
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDragStart(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(onDrag)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            onDragEnd()
        end
    end)
    
    -- Window methods
    function Window:CreateTab(name, icon)
        local TabInstance = {
            Name = name,
            Icon = icon,
            Active = false,
            Elements = {},
            Window = self
        }
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. name
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.BackgroundColor3 = COLORS.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = (icon and icon .. " " or "") .. name
        TabButton.TextColor3 = COLORS.TextSecondary
        TabButton.TextSize = 14
        TabButton.Font = FONTS.Regular
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = self.TabScroll
        TabInstance.Button = TabButton
        
        CreateCorner(8).Parent = TabButton
        
        -- Tab content container
        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent_" .. name
        TabContent.Size = UDim2.new(1, 0, 0, 1)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = self.ContentScroll
        TabInstance.Content = TabContent
        
        -- Layout for tab content
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Parent = TabContent
        
        -- Auto-resize tab content based on children
        local function updateContentSize()
            local totalHeight = TabContentLayout.AbsoluteContentSize.Y
            TabContent.Size = UDim2.new(1, 0, 0, math.max(totalHeight + 16, 1))
            
            -- Update the overall scroll canvas
            local maxHeight = 0
            for _, child in pairs(self.ContentScroll:GetChildren()) do
                if child:IsA("Frame") and child.Visible then
                    maxHeight = math.max(maxHeight, child.Size.Y.Offset)
                end
            end
            self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, maxHeight + 32)
        end
        
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentSize)
        
        -- Store the update function for later use
        TabInstance.UpdateSize = updateContentSize
        
        -- Padding for tab button
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 15)
        TabPadding.Parent = TabButton
        
        -- Tab selection logic
        TabButton.MouseButton1Click:Connect(function()
            self:SelectTab(TabInstance)
        end)
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, ANIMATIONS.Fast, {
                    BackgroundColor3 = COLORS.Surface
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, ANIMATIONS.Fast, {
                    BackgroundColor3 = COLORS.Background
                }):Play()
            end
        end)
        
        -- Add Tab methods to the tab instance
        for methodName, method in pairs(Tab) do
            if type(method) == "function" then
                TabInstance[methodName] = method
            end
        end
        
        -- Select first tab by default
        if #self.Tabs == 0 then
            spawn(function()
                wait(0.1) -- Wait a frame for the tab to be fully created
                self:SelectTab(TabInstance)
            end)
        end
        
        table.insert(self.Tabs, TabInstance)
        return TabInstance
    end
    
    function Window:SelectTab(tab)
        -- Deselect all tabs first
        for _, existingTab in pairs(self.Tabs) do
            existingTab.Active = false
            existingTab.Content.Visible = false
            TweenService:Create(existingTab.Button, ANIMATIONS.Fast, {
                BackgroundColor3 = COLORS.Background,
                TextColor3 = COLORS.TextSecondary
            }):Play()
        end
        
        -- Select new tab
        tab.Active = true
        tab.Content.Visible = true
        self.CurrentTab = tab
        
        -- Update scroll canvas size for the active tab
        if tab.UpdateSize then
            tab.UpdateSize()
        end
        
        TweenService:Create(tab.Button, ANIMATIONS.Fast, {
            BackgroundColor3 = COLORS.Primary,
            TextColor3 = COLORS.Text
        }):Play()
    end
    
    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, ANIMATIONS.Bounce, {
        Size = Window.Size,
        Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    }):Play()
    
    return Window
end

return FischnishedUI
