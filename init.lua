-- Fischnished Ultimate Cheat GUI for Fisch on Roblox
-- Main loader file - this is what gets called by loadstring
-- Version: 1.0.0
-- Author: Buffer_0verflow

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local CONFIG = {
    VERSION = "0.0.1",
    DISCORD = "Tesm6dDcDC",
    GITHUB_BASE = "https://raw.githubusercontent.com/pwd0kernel/Fischnished/main/",
    
    -- File paths (relative to GitHub base)
    FILES = {
        "src/ui/rayfield.lua",
        "src/core/services.lua",
        "src/features/autofarm.lua",
        "src/features/movement.lua",
        "src/features/esp.lua",
        "src/features/teleports.lua",
        "src/features/crates.lua",
        "src/features/codes.lua",
        "src/features/oxygen.lua",
        "src/utils/helpers.lua",
        "src/data/zones.lua"
    }
}

-- Module loader
local function loadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        return result
    else
        warn("Failed to load module from: " .. url)
        warn("Error: " .. tostring(result))
        return nil
    end
end

-- Main loader function
local function initializeFischnished()
    print("=== Fischnished Cheat Loading ===")
    print("Version: " .. CONFIG.VERSION)
    print("Discord: discord.gg/" .. CONFIG.DISCORD)
    
    -- Check if already loaded
    if _G.FischnishedLoaded then
        warn("Fischnished is already loaded!")
        return
    end
    
    -- Create global namespace
    _G.Fischnished = {
        Config = CONFIG,
        Modules = {},
        Data = {},
        Utils = {},
        Features = {},
        UI = {}
    }
    
    -- Load all modules
    local loadedModules = 0
    local totalModules = #CONFIG.FILES
    
    for i, filePath in ipairs(CONFIG.FILES) do
        local url = CONFIG.GITHUB_BASE .. filePath
        print("Loading (" .. i .. "/" .. totalModules .. "): " .. filePath)
        
        local module = loadModule(url)
        if module then
            -- Store module based on file path structure
            local parts = string.split(filePath, "/")
            local category = parts[2] -- src/[category]/file.lua
            local filename = parts[3]:gsub("%.lua$", "")
            
            if not _G.Fischnished[category] then
                _G.Fischnished[category] = {}
            end
            
            _G.Fischnished[category][filename] = module
            loadedModules = loadedModules + 1
        else
            warn("Failed to load: " .. filePath)
        end
    end
    
    print("Loaded " .. loadedModules .. "/" .. totalModules .. " modules")
    
    -- Initialize the cheat if all critical modules loaded
    if loadedModules >= (totalModules * 0.8) then -- Allow 20% failure rate
        _G.FischnishedLoaded = true
        
        -- Initialize UI
        if _G.Fischnished.ui and _G.Fischnished.ui.rayfield then
            _G.Fischnished.ui.rayfield.initialize()
        end
        
        print("=== Fischnished Loaded Successfully ===")
    else
        error("Failed to load critical modules. Aborting initialization.")
    end
end

-- Auto-execute
initializeFischnished()

return _G.Fischnished
