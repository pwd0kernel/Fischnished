# Fischnished Cheat - Loadstring Examples

## Basic Usage
```lua
-- Simple loadstring execution
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
```

## With Error Handling
```lua
-- Safe execution with error handling
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
end)

if not success then
    warn("Failed to load Fischnished: " .. tostring(result))
else
    print("Fischnished loaded successfully!")
end
```

## With Custom Configuration
```lua
-- Load with custom settings
_G.FischnishedConfig = {
    AutoStartFarm = true,
    DefaultSpeed = 150,
    StealthMode = true,
    SkipKeySystem = false  -- Set to true to bypass key system (if you modify the script)
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
```

## One-Liner for Executors
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
```

## Alternative Hosting Examples

### Using Pastebin
```lua
loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_PASTE_ID"))()
```

### Using GitHub Gist
```lua
loadstring(game:HttpGet("https://gist.githubusercontent.com/yourusername/gist_id/raw/init.lua"))()
```

### Using Your Own Server
```lua
loadstring(game:HttpGet("https://yourdomain.com/fischnished/init.lua"))()
```

## Advanced Usage

### Load Specific Version
```lua
-- Load a specific version/branch
local version = "v1.0.0"  -- or "main", "dev", etc.
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/" .. version .. "/init.lua"))()
```

### Load with Backup URLs
```lua
-- Try multiple sources
local urls = {
    "https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua",
    "https://pastebin.com/raw/BACKUP_ID",
    "https://yourdomain.com/backup/fischnished.lua"
}

local loaded = false
for _, url in ipairs(urls) do
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        print("Loaded from: " .. url)
        loaded = true
        break
    else
        warn("Failed to load from " .. url .. ": " .. tostring(result))
    end
end

if not loaded then
    error("Failed to load Fischnished from all sources!")
end
```

## Mobile Executor Example
```lua
-- For mobile executors (simplified)
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua", true))()
```

## Discord Rich Presence Integration
```lua
-- Load with Discord webhook (if you want to track usage)
_G.FischnishedDiscord = {
    webhook = "YOUR_DISCORD_WEBHOOK_URL",
    username = game.Players.LocalPlayer.Name
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
```

## Auto-Update Example
```lua
-- Check for updates before loading
local function loadFischnished()
    local HttpService = game:GetService("HttpService")
    
    -- Get latest version info
    local versionUrl = "https://api.github.com/repos/yourusername/fischnished-cheat/releases/latest"
    local success, versionData = pcall(function()
        return HttpService:GetAsync(versionUrl)
    end)
    
    if success then
        local data = HttpService:JSONDecode(versionData)
        print("Latest version: " .. data.tag_name)
        print("Loading Fischnished...")
    end
    
    -- Load the cheat
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
end

loadFischnished()
```

## Script Hub Integration
```lua
-- Example for adding to script hubs
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ScriptHub/Library/main/init.lua"))()

Library:CreateButton({
    Name = "🎣 Fischnished Cheat",
    Description = "Ultimate Fisch cheat with auto farm, ESP, and more!",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/fischnished-cheat/main/init.lua"))()
    end
})
```

## Notes

1. **Replace `yourusername`** with your actual GitHub username
2. **Update URLs** to match your repository structure
3. **Test thoroughly** before distributing
4. **Consider rate limits** when using GitHub raw URLs
5. **Use HTTPS** for secure connections
6. **Add error handling** for production use

## Distribution Tips

1. **Use URL shorteners** for easier sharing:
   ```lua
   loadstring(game:HttpGet("https://bit.ly/fischnished"))()
   ```

2. **Create QR codes** for mobile users

3. **Host on multiple platforms** for redundancy

4. **Version your releases** for better tracking

5. **Document changes** in your README
