-- Fischnished Custom UI Library v2.0
-- Ultra-modern minimalistic design with clean aesthetics
-- Built for professional cheat interfaces with maximum polish

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local FischnishedUI = {}
FischnishedUI.__index = FischnishedUI

-- GitHub-Inspired Minimal Color Palette
local COLORS = {
    -- Primary Colors (GitHub Blue)
    Primary = Color3.fromRGB(33, 136, 255),       -- GitHub Blue
    PrimaryDark = Color3.fromRGB(9, 105, 218),    -- Darker Primary
    PrimaryLight = Color3.fromRGB(84, 174, 255),  -- Lighter Primary
    
    -- Background System (GitHub Dark Theme)
    Background = Color3.fromRGB(13, 17, 23),      -- GitHub Dark BG
    Surface = Color3.fromRGB(22, 27, 34),         -- GitHub Card BG
    SurfaceHover = Color3.fromRGB(30, 39, 46),    -- Hover State
    SurfaceActive = Color3.fromRGB(33, 38, 45),   -- Active State
    SurfaceBorder = Color3.fromRGB(48, 54, 61),   -- GitHub Border
    
    -- Text Hierarchy (GitHub Text Colors)
    TextPrimary = Color3.fromRGB(230, 237, 243),  -- High Emphasis
    TextSecondary = Color3.fromRGB(139, 148, 158), -- Medium Emphasis  
    TextTertiary = Color3.fromRGB(110, 118, 129), -- Low Emphasis
    TextDisabled = Color3.fromRGB(87, 96, 106),   -- Disabled
    
    -- State Colors (GitHub Status Colors)
    Success = Color3.fromRGB(46, 160, 67),        -- GitHub Green
    Warning = Color3.fromRGB(218, 154, 47),       -- GitHub Orange
    Error = Color3.fromRGB(248, 81, 73),          -- GitHub Red
    Info = Color3.fromRGB(79, 172, 254),          -- GitHub Blue
    
    -- Border System
    Border = Color3.fromRGB(48, 54, 61),          -- GitHub Border
    BorderHover = Color3.fromRGB(56, 68, 77),     -- Hover Border
    BorderFocus = Color3.fromRGB(33, 136, 255),   -- Focus Border
    
    -- Special
    Accent = Color3.fromRGB(163, 113, 247),       -- GitHub Purple
    Glass = Color3.fromRGB(255, 255, 255),        -- For glass effects
}

-- Typography System
local FONTS = {
    Regular = Enum.Font.Gotham,
    Medium = Enum.Font.GothamMedium, 
    SemiBold = Enum.Font.GothamSemibold,
    Bold = Enum.Font.GothamBold,
    Mono = Enum.Font.RobotoMono,
}

-- Motion System
local MOTION = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0, 1.2),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0, 1.1),
}

-- GitHub-Inspired Spacing System (More Minimal)
local SPACING = {
    XS = 2,   -- 2px - Micro spacing
    SM = 4,   -- 4px - Small spacing
    MD = 8,   -- 8px - Medium spacing
    LG = 12,  -- 12px - Large spacing
    XL = 16,  -- 16px - Extra large
    XXL = 20, -- 20px - Component padding
}

-- GitHub-Inspired Border Radius System
local RADIUS = {
    SM = 3,   -- Small radius (GitHub buttons)
    MD = 6,   -- Medium radius (GitHub cards)
    LG = 8,   -- Large radius
    XL = 10,  -- Extra large radius
    XXL = 12, -- Component radius
    FULL = 999, -- Fully rounded
}

-- Modern Component Utilities
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or RADIUS.MD)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or COLORS.Border
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateGradient(colors, rotation, transparency)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    if transparency then
        gradient.Transparency = transparency
    end
    return gradient
end

local function CreateShadow(blur, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Size = UDim2.new(1, blur * 2, 1, blur * 2)
    shadow.Position = UDim2.new(0, -blur, 0, -blur)
    shadow.ZIndex = -1
    return shadow
end

local function CreatePadding(all, left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    if all then
        padding.PaddingLeft = UDim.new(0, all)
        padding.PaddingRight = UDim.new(0, all)
        padding.PaddingTop = UDim.new(0, all)
        padding.PaddingBottom = UDim.new(0, all)
    else
        padding.PaddingLeft = UDim.new(0, left or 0)
        padding.PaddingRight = UDim.new(0, right or 0)
        padding.PaddingTop = UDim.new(0, top or 0)
        padding.PaddingBottom = UDim.new(0, bottom or 0)
    end
    return padding
end

local function CreateListLayout(direction, padding, alignment)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, padding or SPACING.SM)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    return layout
end

local function CreateRipple(parent, color)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    -- Ensure color is a Color3, not UDim2 or other type
    local rippleColor = COLORS.Primary
    if color and typeof(color) == "Color3" then
        rippleColor = color
    end
    ripple.BackgroundColor3 = rippleColor
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = parent.ZIndex + 1
    ripple.Parent = parent
    
    CreateCorner(RADIUS.FULL).Parent = ripple
    
    -- Animate ripple
    TweenService:Create(ripple, MOTION.Fast, {
        Size = UDim2.new(1, 20, 1, 20),
        BackgroundTransparency = 1
    }):Play()
    
    spawn(function()
        wait(0.3)
        ripple:Destroy()
    end)
    
    return ripple
end

-- Tab Component Class
local Tab = {}
Tab.__index = Tab

function Tab:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. name
    Section.Size = UDim2.new(1, 0, 0, 28)
    Section.BackgroundTransparency = 1
    Section.BorderSizePixel = 0
    Section.Parent = self.Content
    
    local SectionText = Instance.new("TextLabel")
    SectionText.Size = UDim2.new(1, 0, 1, 0)
    SectionText.Position = UDim2.new(0, 0, 0, 0)
    SectionText.BackgroundTransparency = 1
    SectionText.Text = name
    SectionText.TextColor3 = COLORS.TextTertiary
    SectionText.TextSize = 10
    SectionText.Font = FONTS.SemiBold
    SectionText.TextXAlignment = Enum.TextXAlignment.Left
    SectionText.TextYAlignment = Enum.TextYAlignment.Bottom
    SectionText.Parent = Section
    
    -- GitHub-style divider line
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 1, -1)
    Divider.BackgroundColor3 = COLORS.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = Section
    
    return Section
end

function Tab:CreateButton(config)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame_" .. (config.Name or "Button")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = self.Content
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Position = UDim2.new(0, 0, 0, 0)
    Button.BackgroundColor3 = COLORS.Surface
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.ClipsDescendants = true
    Button.Parent = ButtonFrame
    
    CreateCorner(RADIUS.SM).Parent = Button
    CreateStroke(1, COLORS.Border).Parent = Button
    CreatePadding(SPACING.LG).Parent = Button
    
    -- Button text
    local ButtonText = Instance.new("TextLabel")
    ButtonText.Size = UDim2.new(1, 0, 1, 0)
    ButtonText.BackgroundTransparency = 1
    ButtonText.Text = config.Name or "Button"
    ButtonText.TextColor3 = COLORS.TextPrimary
    ButtonText.TextSize = 12
    ButtonText.Font = FONTS.Medium
    ButtonText.TextXAlignment = Enum.TextXAlignment.Center
    ButtonText.TextYAlignment = Enum.TextYAlignment.Center
    ButtonText.Parent = Button
    
    -- Hover effects (GitHub-style)
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, MOTION.Fast, {
            BackgroundColor3 = COLORS.SurfaceHover
        }):Play()
        TweenService:Create(Button:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.BorderHover
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, MOTION.Fast, {
            BackgroundColor3 = COLORS.Surface
        }):Play()
        TweenService:Create(Button:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Border
        }):Play()
    end)
    
    Button.MouseButton1Down:Connect(function()
        CreateRipple(Button, COLORS.Primary)
        TweenService:Create(Button, MOTION.Fast, {
            BackgroundColor3 = COLORS.SurfaceActive
        }):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, MOTION.Fast, {
            BackgroundColor3 = COLORS.SurfaceHover
        }):Play()
    end)
    
    if config.Callback then
        Button.MouseButton1Click:Connect(config.Callback)
    end
    
    return ButtonFrame
end

function Tab:CreateToggle(config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame_" .. (config.Name or "Toggle")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
    ToggleFrame.BackgroundColor3 = COLORS.Surface
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = self.Content
    
    CreateCorner(RADIUS.SM).Parent = ToggleFrame
    CreateStroke(1, COLORS.Border).Parent = ToggleFrame
    CreatePadding(SPACING.LG).Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name or "Toggle"
    ToggleLabel.TextColor3 = COLORS.TextPrimary
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = FONTS.Medium
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center
    ToggleLabel.Parent = ToggleButton
    
    -- GitHub-style toggle switch
    local SwitchTrack = Instance.new("Frame")
    SwitchTrack.Size = UDim2.new(0, 38, 0, 20)
    SwitchTrack.Position = UDim2.new(1, -38, 0.5, -10)
    SwitchTrack.BackgroundColor3 = COLORS.Border
    SwitchTrack.BorderSizePixel = 0
    SwitchTrack.Parent = ToggleButton
    
    CreateCorner(RADIUS.FULL).Parent = SwitchTrack
    CreateStroke(1, COLORS.BorderHover).Parent = SwitchTrack
    
    local SwitchThumb = Instance.new("Frame")
    SwitchThumb.Size = UDim2.new(0, 16, 0, 16)
    SwitchThumb.Position = UDim2.new(0, 2, 0, 2)
    SwitchThumb.BackgroundColor3 = COLORS.TextPrimary
    SwitchThumb.BorderSizePixel = 0
    SwitchThumb.Parent = SwitchTrack
    
    CreateCorner(RADIUS.FULL).Parent = SwitchThumb
    CreateShadow(2, 0.3).Parent = SwitchThumb
    
    local toggled = config.CurrentValue or false
    
    local function updateToggle()
        if toggled then
            TweenService:Create(SwitchTrack, MOTION.Medium, {
                BackgroundColor3 = COLORS.Primary
            }):Play()
            TweenService:Create(SwitchTrack:FindFirstChild("UIStroke"), MOTION.Medium, {
                Color = COLORS.Primary
            }):Play()
            TweenService:Create(SwitchThumb, MOTION.Medium, {
                Position = UDim2.new(1, -18, 0, 2),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(SwitchTrack, MOTION.Medium, {
                BackgroundColor3 = COLORS.Border
            }):Play()
            TweenService:Create(SwitchTrack:FindFirstChild("UIStroke"), MOTION.Medium, {
                Color = COLORS.BorderHover
            }):Play()
            TweenService:Create(SwitchThumb, MOTION.Medium, {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = COLORS.TextPrimary
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
    
    -- GitHub-style hover effects
    ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, MOTION.Fast, {
            BackgroundColor3 = COLORS.SurfaceHover
        }):Play()
        TweenService:Create(ToggleFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.BorderHover
        }):Play()
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, MOTION.Fast, {
            BackgroundColor3 = COLORS.Surface
        }):Play()
        TweenService:Create(ToggleFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Border
        }):Play()
    end)
    
    return ToggleFrame
end

function Tab:CreateSlider(config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame_" .. (config.Name or "Slider")
    SliderFrame.Size = UDim2.new(1, 0, 0, 56)
    SliderFrame.BackgroundColor3 = COLORS.Surface
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = self.Content
    
    CreateCorner(RADIUS.SM).Parent = SliderFrame
    CreateStroke(1, COLORS.Border).Parent = SliderFrame
    CreatePadding(SPACING.LG).Parent = SliderFrame
    
    -- Header with label and value
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 16)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -50, 1, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name or "Slider"
    SliderLabel.TextColor3 = COLORS.TextPrimary
    SliderLabel.TextSize = 12
    SliderLabel.Font = FONTS.Medium
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.TextYAlignment = Enum.TextYAlignment.Center
    SliderLabel.Parent = HeaderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 1, 0)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(config.CurrentValue or config.Range[1]) .. (config.Suffix or "")
    ValueLabel.TextColor3 = COLORS.Primary
    ValueLabel.TextSize = 11
    ValueLabel.Font = FONTS.SemiBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.TextYAlignment = Enum.TextYAlignment.Center
    ValueLabel.Parent = HeaderFrame
    
    -- GitHub-style slider track
    local SliderContainer = Instance.new("Frame")
    SliderContainer.Size = UDim2.new(1, 0, 0, 20)
    SliderContainer.Position = UDim2.new(0, 0, 1, -20)
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, 0, 0, 4)
    SliderTrack.Position = UDim2.new(0, 0, 0.5, -2)
    SliderTrack.BackgroundColor3 = COLORS.Border
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderContainer
    
    CreateCorner(RADIUS.SM).Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    CreateCorner(RADIUS.SM).Parent = SliderFill
    
    -- GitHub-style thumb (more minimal)
    local SliderThumb = Instance.new("Frame")
    SliderThumb.Size = UDim2.new(0, 12, 0, 12)
    SliderThumb.Position = UDim2.new(0, -6, 0.5, -6)
    SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderThumb.BorderSizePixel = 0
    SliderThumb.ZIndex = 3
    SliderThumb.Parent = SliderFill
    
    CreateCorner(RADIUS.FULL).Parent = SliderThumb
    CreateStroke(2, COLORS.Primary).Parent = SliderThumb
    CreateShadow(3, 0.2).Parent = SliderThumb
    
    local SliderInput = Instance.new("TextButton")
    SliderInput.Size = UDim2.new(1, 0, 1, 0)
    SliderInput.BackgroundTransparency = 1
    SliderInput.Text = ""
    SliderInput.ZIndex = 4
    SliderInput.Parent = SliderContainer
    
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
        
        TweenService:Create(SliderFill, MOTION.Fast, {
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
            local relativeX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * relativeX
            updateSlider(value)
        end
    end
    
    SliderInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            
            -- GitHub-style active state
            TweenService:Create(SliderThumb, MOTION.Fast, {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, -8, 0.5, -8)
            }):Play()
            TweenService:Create(SliderThumb:FindFirstChild("UIStroke"), MOTION.Fast, {
                Thickness = 3
            }):Play()
            
            local relativeX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            local value = range[1] + (range[2] - range[1]) * relativeX
            updateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(onDrag)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(SliderThumb, MOTION.Fast, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -6, 0.5, -6)
            }):Play()
            TweenService:Create(SliderThumb:FindFirstChild("UIStroke"), MOTION.Fast, {
                Thickness = 2
            }):Play()
        end
    end)
    
    -- GitHub-style hover effects
    SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(SliderFrame, MOTION.Fast, {
            BackgroundColor3 = COLORS.SurfaceHover
        }):Play()
        TweenService:Create(SliderFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.BorderHover
        }):Play()
        if not dragging then
            TweenService:Create(SliderThumb, MOTION.Fast, {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, -7, 0.5, -7)
            }):Play()
        end
    end)
    
    SliderFrame.MouseLeave:Connect(function()
        if not dragging then
            TweenService:Create(SliderFrame, MOTION.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
            TweenService:Create(SliderFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
                Color = COLORS.Border
            }):Play()
            TweenService:Create(SliderThumb, MOTION.Fast, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -6, 0.5, -6)
            }):Play()
        end
    end)
    
    updateSlider(currentValue)
    
    return SliderFrame
end

function Tab:CreateDropdown(config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame_" .. (config.Name or "Dropdown")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
    DropdownFrame.BackgroundColor3 = COLORS.Surface
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Content
    
    CreateCorner(RADIUS.SM).Parent = DropdownFrame
    CreateStroke(1, COLORS.Border).Parent = DropdownFrame
    CreatePadding(SPACING.LG).Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 32)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    local DropdownText = Instance.new("TextLabel")
    DropdownText.Size = UDim2.new(1, -20, 1, 0)
    DropdownText.BackgroundTransparency = 1
    DropdownText.Text = config.CurrentOption or config.Options[1] or "Select option..."
    DropdownText.TextColor3 = COLORS.TextPrimary
    DropdownText.TextSize = 12
    DropdownText.Font = FONTS.Medium
    DropdownText.TextXAlignment = Enum.TextXAlignment.Left
    DropdownText.TextYAlignment = Enum.TextYAlignment.Center
    DropdownText.Parent = DropdownButton
    
    -- GitHub-style chevron icon
    local DropdownIcon = Instance.new("TextLabel")
    DropdownIcon.Size = UDim2.new(0, 14, 0, 14)
    DropdownIcon.Position = UDim2.new(1, -14, 0.5, -7)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Text = "⌄"
    DropdownIcon.TextColor3 = COLORS.TextTertiary
    DropdownIcon.TextSize = 12
    DropdownIcon.Font = FONTS.Regular
    DropdownIcon.TextXAlignment = Enum.TextXAlignment.Center
    DropdownIcon.TextYAlignment = Enum.TextYAlignment.Center
    DropdownIcon.Parent = DropdownButton
    
    -- GitHub-style dropdown menu
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Position = UDim2.new(0, 0, 0, 34)
    OptionsContainer.BackgroundColor3 = COLORS.Surface
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.ZIndex = 10
    OptionsContainer.Parent = DropdownFrame
    
    CreateCorner(RADIUS.SM).Parent = OptionsContainer
    CreateStroke(1, COLORS.BorderHover).Parent = OptionsContainer
    CreateShadow(4, 0.1).Parent = OptionsContainer
    
    local OptionsLayout = CreateListLayout(Enum.FillDirection.Vertical, 1)
    OptionsLayout.Parent = OptionsContainer
    
    local isOpen = false
    local selectedOption = config.CurrentOption or config.Options[1]
    
    local function createOption(option)
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = COLORS.TextSecondary
        OptionButton.TextSize = 11
        OptionButton.Font = FONTS.Regular
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Parent = OptionsContainer
        
        CreatePadding(SPACING.MD).Parent = OptionButton
        
        -- GitHub-style option hover
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, MOTION.Fast, {
                BackgroundColor3 = COLORS.Primary,
                BackgroundTransparency = 0.9
            }):Play()
            TweenService:Create(OptionButton, MOTION.Fast, {
                TextColor3 = COLORS.TextPrimary
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, MOTION.Fast, {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(OptionButton, MOTION.Fast, {
                TextColor3 = COLORS.TextSecondary
            }):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            DropdownText.Text = option
            isOpen = false
            
            TweenService:Create(DropdownFrame, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, 32)
            }):Play()
            
            TweenService:Create(OptionsContainer, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(DropdownIcon, MOTION.Medium, {
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
            local containerHeight = math.min(optionCount * 29, 140) -- 28px per option + 1px spacing
            
            TweenService:Create(DropdownFrame, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, 32 + containerHeight + 2)
            }):Play()
            
            TweenService:Create(OptionsContainer, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, containerHeight)
            }):Play()
            
            TweenService:Create(DropdownIcon, MOTION.Medium, {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(DropdownFrame, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, 32)
            }):Play()
            
            TweenService:Create(OptionsContainer, MOTION.Medium, {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(DropdownIcon, MOTION.Medium, {
                Rotation = 0
            }):Play()
        end
    end)
    
    -- GitHub-style hover effects
    DropdownFrame.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, MOTION.Fast, {
                BackgroundColor3 = COLORS.SurfaceHover
            }):Play()
            TweenService:Create(DropdownFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
                Color = COLORS.BorderHover
            }):Play()
        end
    end)
    
    DropdownFrame.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(DropdownFrame, MOTION.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
            TweenService:Create(DropdownFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
                Color = COLORS.Border
            }):Play()
        end
    end)
    
    return DropdownFrame
end

function Tab:CreateTextbox(config)
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = "TextboxFrame_" .. (config.Name or "Textbox")
    TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
    TextboxFrame.BackgroundColor3 = COLORS.Surface
    TextboxFrame.BorderSizePixel = 0
    TextboxFrame.Parent = self.Content
    
    CreateCorner(RADIUS.LG).Parent = TextboxFrame
    CreateStroke(1, COLORS.Border).Parent = TextboxFrame
    CreatePadding(SPACING.LG).Parent = TextboxFrame
    
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Size = UDim2.new(1, 0, 0, 16)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = config.Name or "Textbox"
    TextboxLabel.TextColor3 = COLORS.TextPrimary
    TextboxLabel.TextSize = 12
    TextboxLabel.Font = FONTS.Medium
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextboxLabel.Parent = TextboxFrame
    
    local TextboxInput = Instance.new("TextBox")
    TextboxInput.Size = UDim2.new(1, 0, 0, 32)
    TextboxInput.Position = UDim2.new(0, 0, 1, -32)
    TextboxInput.BackgroundColor3 = COLORS.Background
    TextboxInput.BorderSizePixel = 0
    TextboxInput.Text = config.CurrentValue or ""
    TextboxInput.PlaceholderText = config.PlaceholderText or "Enter text..."
    TextboxInput.TextColor3 = COLORS.TextPrimary
    TextboxInput.PlaceholderColor3 = COLORS.TextTertiary
    TextboxInput.TextSize = 13
    TextboxInput.Font = FONTS.Regular
    TextboxInput.TextXAlignment = Enum.TextXAlignment.Left
    TextboxInput.ClearTextOnFocus = false
    TextboxInput.Parent = TextboxFrame
    
    CreateCorner(RADIUS.MD).Parent = TextboxInput
    CreateStroke(1, COLORS.Border).Parent = TextboxInput
    CreatePadding(SPACING.MD).Parent = TextboxInput
    
    local focused = false
    
    TextboxInput.Focused:Connect(function()
        focused = true
        TweenService:Create(TextboxInput:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Primary,
            Thickness = 2
        }):Play()
        TweenService:Create(TextboxInput, MOTION.Fast, {
            BackgroundColor3 = COLORS.Surface
        }):Play()
    end)
    
    TextboxInput.FocusLost:Connect(function(enterPressed)
        focused = false
        TweenService:Create(TextboxInput:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Border,
            Thickness = 1
        }):Play()
        TweenService:Create(TextboxInput, MOTION.Fast, {
            BackgroundColor3 = COLORS.Background
        }):Play()
        
        if config.Callback and (enterPressed or not config.OnEnter) then
            config.Callback(TextboxInput.Text)
        end
    end)
    
    -- Hover effects
    TextboxFrame.MouseEnter:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, MOTION.Fast, {
                BackgroundColor3 = COLORS.SurfaceHover
            }):Play()
            TweenService:Create(TextboxFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
                Color = COLORS.BorderHover
            }):Play()
        end
    end)
    
    TextboxFrame.MouseLeave:Connect(function()
        if not focused then
            TweenService:Create(TextboxFrame, MOTION.Fast, {
                BackgroundColor3 = COLORS.Surface
            }):Play()
            TweenService:Create(TextboxFrame:FindFirstChild("UIStroke"), MOTION.Fast, {
                Color = COLORS.Border
            }):Play()
        end
    end)
    
    return TextboxFrame
end

function Tab:CreateParagraph(config)
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = "ParagraphFrame_" .. (config.Title or "Paragraph")
    ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
    ParagraphFrame.BackgroundColor3 = COLORS.Surface
    ParagraphFrame.BorderSizePixel = 0
    ParagraphFrame.Parent = self.Content
    
    CreateCorner(RADIUS.LG).Parent = ParagraphFrame
    CreateStroke(1, COLORS.Border).Parent = ParagraphFrame
    CreatePadding(SPACING.LG).Parent = ParagraphFrame
    
    local ParagraphLayout = CreateListLayout(Enum.FillDirection.Vertical, SPACING.SM)
    ParagraphLayout.Parent = ParagraphFrame
    
    if config.Title then
        local ParagraphTitle = Instance.new("TextLabel")
        ParagraphTitle.Size = UDim2.new(1, 0, 0, 20)
        ParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y
        ParagraphTitle.BackgroundTransparency = 1
        ParagraphTitle.Text = config.Title
        ParagraphTitle.TextColor3 = COLORS.TextPrimary
        ParagraphTitle.TextSize = 14
        ParagraphTitle.Font = FONTS.SemiBold
        ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
        ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
        ParagraphTitle.TextWrapped = true
        ParagraphTitle.LayoutOrder = 1
        ParagraphTitle.Parent = ParagraphFrame
    end
    
    local ParagraphText = Instance.new("TextLabel")
    ParagraphText.Size = UDim2.new(1, 0, 0, 0)
    ParagraphText.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphText.BackgroundTransparency = 1
    ParagraphText.Text = config.Text or config.Content or "Paragraph text"
    ParagraphText.TextColor3 = COLORS.TextSecondary
    ParagraphText.TextSize = 12
    ParagraphText.Font = FONTS.Regular
    ParagraphText.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphText.TextYAlignment = Enum.TextYAlignment.Top
    ParagraphText.TextWrapped = true
    ParagraphText.LineHeight = 1.4
    ParagraphText.LayoutOrder = 2
    ParagraphText.Parent = ParagraphFrame
    
    return ParagraphFrame
end

-- Main CreateWindow function for FischnishedUI
function FischnishedUI:CreateWindow(config)
    local Window = {
        Name = config.Name or "Fischnished UI",
        Size = config.Size or UDim2.new(0, 650, 0, 500),
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
    
    -- Create main frame (GitHub-inspired)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Window.Size
    MainFrame.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    Window.MainFrame = MainFrame
    
    CreateCorner(RADIUS.MD).Parent = MainFrame
    CreateStroke(1, COLORS.Border).Parent = MainFrame
    CreateShadow(6, 0.2).Parent = MainFrame
    
    -- GitHub-style title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = COLORS.Surface
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    CreateCorner(RADIUS.MD).Parent = TitleBar
    CreateStroke(1, COLORS.Border).Parent = TitleBar
    CreatePadding(SPACING.LG).Parent = TitleBar
    
    -- Title bar corner fix
    local titleCornerFix = Instance.new("Frame")
    titleCornerFix.Size = UDim2.new(1, 0, 0, RADIUS.MD)
    titleCornerFix.Position = UDim2.new(0, 0, 1, -RADIUS.MD)
    titleCornerFix.BackgroundColor3 = COLORS.Surface
    titleCornerFix.BorderSizePixel = 0
    titleCornerFix.Parent = TitleBar
    
    -- GitHub-style title text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -80, 1, 0)
    TitleText.Position = UDim2.new(0, 0, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Window.Name
    TitleText.TextColor3 = COLORS.TextPrimary
    TitleText.TextSize = 14
    TitleText.Font = FONTS.SemiBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.TextYAlignment = Enum.TextYAlignment.Center
    TitleText.Parent = TitleBar
    
    -- GitHub-style close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -28, 0.5, -14)
    CloseButton.BackgroundColor3 = COLORS.Surface
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = COLORS.TextSecondary
    CloseButton.TextSize = 14
    CloseButton.Font = FONTS.SemiBold
    CloseButton.Parent = TitleBar
    
    CreateCorner(RADIUS.SM).Parent = CloseButton
    CreateStroke(1, COLORS.Border).Parent = CloseButton
    
    -- GitHub-style close button hover effects
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, MOTION.Fast, {
            BackgroundColor3 = COLORS.Error,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(CloseButton:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Error
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, MOTION.Fast, {
            BackgroundColor3 = COLORS.Surface,
            TextColor3 = COLORS.TextSecondary
        }):Play()
        TweenService:Create(CloseButton:FindFirstChild("UIStroke"), MOTION.Fast, {
            Color = COLORS.Border
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateRipple(CloseButton, Color3.fromRGB(255, 255, 255))
        TweenService:Create(MainFrame, MOTION.Spring, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    -- Content area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -48)
    ContentFrame.Position = UDim2.new(0, 0, 0, 48)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- GitHub-style tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 180, 1, 0)
    TabContainer.Position = UDim2.new(0, 0, 0, 0)
    TabContainer.BackgroundColor3 = COLORS.Surface
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = ContentFrame
    
    CreateStroke(1, COLORS.Border).Parent = TabContainer
    CreatePadding(SPACING.MD).Parent = TabContainer
    
    local TabList = CreateListLayout(Enum.FillDirection.Vertical, SPACING.XS)
    TabList.Parent = TabContainer
    
    -- Tab content area
    local TabContentFrame = Instance.new("Frame")
    TabContentFrame.Name = "TabContentFrame"
    TabContentFrame.Size = UDim2.new(1, -180, 1, 0)
    TabContentFrame.Position = UDim2.new(0, 180, 0, 0)
    TabContentFrame.BackgroundTransparency = 1
    TabContentFrame.BorderSizePixel = 0
    TabContentFrame.Parent = ContentFrame
    
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
    
    -- Store references
    Window.TabContainer = TabContainer
    Window.TabContentFrame = TabContentFrame
    Window.TabList = TabList
    
    -- Tab creation function
    function Window:CreateTab(config)
        local TabInstance = {
            Name = config.Name or "Tab",
            Active = false,
            Button = nil,
            Content = nil,
            Window = self
        }
        
        -- Create GitHub-style tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. TabInstance.Name
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = COLORS.Surface
        TabButton.BorderSizePixel = 0
        TabButton.Text = TabInstance.Name
        TabButton.TextColor3 = COLORS.TextSecondary
        TabButton.TextSize = 11
        TabButton.Font = FONTS.Medium
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer
        
        CreateCorner(RADIUS.SM).Parent = TabButton
        CreatePadding(SPACING.MD).Parent = TabButton
        TabInstance.Button = TabButton
        
        -- Create tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. TabInstance.Name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = COLORS.Primary
        TabContent.ScrollBarImageTransparency = 0.6
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = TabContentFrame
        
        CreatePadding(SPACING.LG).Parent = TabContent
        TabInstance.Content = TabContent
        
        local ContentLayout = CreateListLayout(Enum.FillDirection.Vertical, SPACING.MD)
        ContentLayout.Parent = TabContent
        
        -- Auto-resize canvas
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + SPACING.LG * 2)
        end)
        
        -- Tab selection logic
        TabButton.MouseButton1Click:Connect(function()
            CreateRipple(TabButton, COLORS.Primary)
            self:SelectTab(TabInstance)
        end)
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, MOTION.Fast, {
                    BackgroundColor3 = COLORS.SurfaceHover
                }):Play()
                TweenService:Create(TabButton, MOTION.Fast, {
                    TextColor3 = COLORS.TextPrimary
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabInstance.Active then
                TweenService:Create(TabButton, MOTION.Fast, {
                    BackgroundColor3 = COLORS.Surface
                }):Play()
                TweenService:Create(TabButton, MOTION.Fast, {
                    TextColor3 = COLORS.TextSecondary
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
            TweenService:Create(existingTab.Button, MOTION.Fast, {
                BackgroundColor3 = COLORS.Surface,
                TextColor3 = COLORS.TextSecondary
            }):Play()
        end
        
        -- Select new tab
        tab.Active = true
        tab.Content.Visible = true
        self.CurrentTab = tab
        
        TweenService:Create(tab.Button, MOTION.Fast, {
            BackgroundColor3 = COLORS.Primary,
            TextColor3 = COLORS.TextPrimary
        }):Play()
    end
    
    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, MOTION.Bounce, {
        Size = Window.Size,
        Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    }):Play()
    
    return Window
end

return FischnishedUI
