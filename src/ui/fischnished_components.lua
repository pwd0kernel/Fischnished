-- FischnishedUI Components - Part 2
-- Extended functionality for FischnishedUI library
-- Contains all UI components like tabs, buttons, toggles, sliders, etc.

local FischnishedUI = require(script.Parent.fischnished)
local Services = _G.Fischnished.core.services

-- Get references from main file
local State = FischnishedUI.State or {}
local getCurrentTheme = FischnishedUI.getCurrentTheme
local createCorner = FischnishedUI.createCorner
local createStroke = FischnishedUI.createStroke
local createShadow = FischnishedUI.createShadow
local tweenProperty = FischnishedUI.tweenProperty
local addHoverEffect = FischnishedUI.addHoverEffect
local createRippleEffect = FischnishedUI.createRippleEffect

-- Tab Management
function FischnishedUI.createTab(name, icon)
    if not State.window then
        warn("Window not created yet!")
        return nil
    end
    
    local theme = getCurrentTheme()
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
    tabButton.Parent = State.window.tabList
    
    createCorner(tabButton, 6)
    
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
    tabContent.Parent = State.window.contentContainer
    
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
        for _, tab in pairs(State.tabs) do
            tab.content.Visible = false
            tab.button.BackgroundColor3 = theme.Secondary
            tab.button.TextColor3 = theme.TextSecondary
        end
        
        -- Show selected tab
        tabContent.Visible = true
        tabButton.BackgroundColor3 = theme.Accent
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        State.currentTab = name
        
        -- Animate selection
        tweenProperty(tabButton, {BackgroundColor3 = theme.Accent}, 0.2)
    end
    
    tabButton.MouseButton1Click:Connect(function()
        createRippleEffect(tabButton, Vector2.new(tabButton.AbsoluteSize.X/2, tabButton.AbsoluteSize.Y/2))
        selectTab()
    end)
    
    addHoverEffect(tabButton, theme.AccentHover, theme.Secondary)
    
    -- Store tab
    State.tabs[name] = {
        button = tabButton,
        content = tabContent,
        layout = contentLayout,
        name = name
    }
    
    -- Select first tab automatically
    if #State.window.tabList:GetChildren() == 2 then -- Layout + first tab
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
        end,
        CreateKeybind = function(config)
            return FischnishedUI.createKeybind(tabContent, config)
        end,
        CreateColorPicker = function(config)
            return FischnishedUI.createColorPicker(tabContent, config)
        end
    }
end

-- Button Component
function FischnishedUI.createButton(parent, config)
    local theme = getCurrentTheme()
    
    local container = Instance.new("Frame")
    container.Name = config.Name or "Button"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = theme.Accent
    button.BorderSizePixel = 0
    button.Text = config.Name or "Button"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = container
    
    createCorner(button, 6)
    addHoverEffect(button, theme.AccentHover)
    
    button.MouseButton1Click:Connect(function()
        createRippleEffect(button, Vector2.new(button.AbsoluteSize.X/2, button.AbsoluteSize.Y/2))
        if config.Callback then
            config.Callback()
        end
    end)
    
    return button
end

-- Toggle Component
function FischnishedUI.createToggle(parent, config)
    local theme = getCurrentTheme()
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
    
    createCorner(button, 6)
    createStroke(button, 1, theme.Border)
    
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
    
    createCorner(toggleFrame, 12)
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = currentValue and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleFrame
    
    createCorner(toggleCircle, 10)
    createShadow(toggleCircle)
    
    local function updateToggle(value)
        currentValue = value
        
        tweenProperty(toggleFrame, {
            BackgroundColor3 = value and theme.Success or theme.Border
        }, 0.2)
        
        tweenProperty(toggleCircle, {
            Position = value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        }, 0.2, Enum.EasingStyle.Quad)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    button.MouseButton1Click:Connect(function()
        updateToggle(not currentValue)
    end)
    
    addHoverEffect(button, theme.Background, theme.Secondary)
    
    -- Initialize
    updateToggle(currentValue)
    
    return {
        SetValue = updateToggle,
        GetValue = function() return currentValue end
    }
end

-- Slider Component
function FischnishedUI.createSlider(parent, config)
    local theme = getCurrentTheme()
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
    
    createCorner(sliderFrame, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    createCorner(sliderFill, 10)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderFrame
    
    createCorner(sliderKnob, 8)
    createShadow(sliderKnob)
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        value = math.round(value / increment) * increment
        currentValue = value
        
        local percentage = (value - min) / (max - min)
        
        tweenProperty(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
        tweenProperty(sliderKnob, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
        
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

-- Dropdown Component
function FischnishedUI.createDropdown(parent, config)
    local theme = getCurrentTheme()
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
    
    createCorner(button, 6)
    createStroke(button, 1, theme.Border)
    
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
    
    createCorner(optionsFrame, 6)
    createStroke(optionsFrame, 1, theme.Border)
    createShadow(optionsFrame)
    
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
        
        createCorner(optionButton, 4)
        addHoverEffect(optionButton, theme.Background)
        
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
    addHoverEffect(button, theme.Background, theme.Secondary)
    
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

-- Paragraph Component
function FischnishedUI.createParagraph(parent, config)
    local theme = getCurrentTheme()
    
    local container = Instance.new("Frame")
    container.Name = config.Title or "Paragraph"
    container.Size = UDim2.new(1, 0, 0, 80)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.Parent = parent
    
    createCorner(container, 6)
    createStroke(container, 1, theme.Border)
    
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
    
    -- Auto-resize based on content
    local textService = Services.TextService
    local textSize = textService:GetTextSize(
        config.Content or "Content",
        14,
        Enum.Font.SourceSans,
        Vector2.new(container.AbsoluteSize.X - 20, math.huge)
    )
    
    container.Size = UDim2.new(1, 0, 0, math.max(80, textSize.Y + 50))
    
    return container
end

-- Textbox Component
function FischnishedUI.createTextbox(parent, config)
    local theme = getCurrentTheme()
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
    
    createCorner(frame, 6)
    createStroke(frame, 1, theme.Border)
    
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
    
    createCorner(textbox, 4)
    createStroke(textbox, 1, theme.Border)
    
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
    if State.window and State.window.gui then
        State.window.gui:Destroy()
        State.window = nil
        State.tabs = {}
        State.currentTab = nil
    end
end

function FischnishedUI.toggleWindow()
    if State.window and State.window.container then
        State.isVisible = not State.isVisible
        State.window.container.Visible = State.isVisible
    end
end

return FischnishedUI
