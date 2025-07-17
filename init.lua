-- Fischnished Ultimate Cheat GUI for Fisch on Roblox
-- Main loader file - this is what gets called by loadstring
-- Version: 1.0.0
-- Author: Buffer_0verflow

-- For local testing, we'll load directly from the file system
-- When uploading to GitHub, change USE_LOCAL_FILES to false
local USE_LOCAL_FILES = false -- Set to false for GitHub distribution

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local CONFIG = {
    VERSION = "1.0.0",
    DISCORD = "Tesm6dDcDC",
    GITHUB_BASE = "https://raw.githubusercontent.com/pwd0kernel/Fischnished/main/",
    
    -- File loading order (dependencies first)
    FILES = {
        {path = "src/core/services.lua", category = "core", name = "services"},
        {path = "src/utils/helpers.lua", category = "utils", name = "helpers"},
        {path = "src/data/zones.lua", category = "data", name = "zones"},
        {path = "src/features/autofarm.lua", category = "features", name = "autofarm"},
        {path = "src/features/movement.lua", category = "features", name = "movement"},
        {path = "src/features/esp.lua", category = "features", name = "esp"},
        {path = "src/features/teleports.lua", category = "features", name = "teleports"},
        {path = "src/features/crates.lua", category = "features", name = "crates"},
        {path = "src/features/codes.lua", category = "features", name = "codes"},
        {path = "src/features/oxygen.lua", category = "features", name = "oxygen"},
        {path = "src/ui/rayfield.lua", category = "ui", name = "rayfield"}
    }
}

-- Module loader
local function loadModule(filePath, category, name)
    local module = nil
    
    if USE_LOCAL_FILES then
        -- Load from local file system (for testing)
        local success, result = pcall(function()
            return loadfile(filePath)()
        end)
        
        if success then
            module = result
            print("✓ Loaded local: " .. filePath)
        else
            print("✗ Failed to load local: " .. filePath)
            print("Error: " .. tostring(result))
        end
    else
        -- Load from GitHub (for distribution)
        local url = CONFIG.GITHUB_BASE .. filePath
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        
        if success then
            module = result
            print("✓ Loaded remote: " .. url)
        else
            print("✗ Failed to load remote: " .. url)
            print("Error: " .. tostring(result))
        end
    end
    
    return module
end

-- Safe string split function (in case string.split doesn't exist)
local function split(str, delimiter)
    local result = {}
    local pattern = "(.-)" .. delimiter
    local lastEnd = 1
    local s, e, cap = str:find(pattern, 1)
    
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(result, cap)
        end
        lastEnd = e + 1
        s, e, cap = str:find(pattern, lastEnd)
    end
    
    if lastEnd <= #str then
        cap = str:sub(lastEnd)
        table.insert(result, cap)
    end
    
    return result
end

-- Main loader function
local function initializeFischnished()
    print("=== Fischnished Cheat Loading ===")
    print("Version: " .. CONFIG.VERSION)
    print("Discord: discord.gg/" .. CONFIG.DISCORD)
    print("Mode: " .. (USE_LOCAL_FILES and "Local Testing" or "GitHub Distribution"))
    
    -- Check if already loaded
    if _G.FischnishedLoaded then
        warn("Fischnished is already loaded!")
        return _G.Fischnished
    end
    
    -- Create global namespace
    _G.Fischnished = {
        Config = CONFIG,
        core = {},
        ui = {},
        features = {},
        utils = {},
        data = {}
    }
    
    -- Load all modules in order
    local loadedModules = 0
    local totalModules = #CONFIG.FILES
    
    for i, fileInfo in ipairs(CONFIG.FILES) do
        print("Loading (" .. i .. "/" .. totalModules .. "): " .. fileInfo.path)
        
        local module = loadModule(fileInfo.path, fileInfo.category, fileInfo.name)
        if module then
            -- Store module in the correct category
            if not _G.Fischnished[fileInfo.category] then
                _G.Fischnished[fileInfo.category] = {}
            end
            
            _G.Fischnished[fileInfo.category][fileInfo.name] = module
            loadedModules = loadedModules + 1
        else
            warn("Failed to load: " .. fileInfo.path)
        end
    end
    
    print("Loaded " .. loadedModules .. "/" .. totalModules .. " modules")
    
    -- Initialize the cheat if critical modules loaded
    if loadedModules >= math.max(1, math.floor(totalModules * 0.7)) then -- At least 70% or minimum 1 module
        _G.FischnishedLoaded = true
        
        -- Initialize UI if available
        if _G.Fischnished.ui and _G.Fischnished.ui.rayfield and _G.Fischnished.ui.rayfield.initialize then
            local success, err = pcall(function()
                _G.Fischnished.ui.rayfield.initialize()
            end)
            
            if not success then
                warn("Failed to initialize UI: " .. tostring(err))
                -- Fallback: create a simple notification
                print("UI initialization failed, but core modules loaded successfully.")
            end
        else
            warn("UI module not available - modules may not have loaded correctly")
        end
        
        print("=== Fischnished Loaded Successfully ===")
        return _G.Fischnished
    else
        error("Failed to load critical modules (" .. loadedModules .. "/" .. totalModules .. "). Aborting initialization.")
    end
end

-- Auto-execute
initializeFischnished()

return _G.Fischnished
