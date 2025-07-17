# Fischnished Cheat - Loadstring Examples

## Basic Usage
```lua
-- Simple loadstring execution
loadstring(game:HttpGet("https://raw.githubusercontent.com/pwd0kernel/Fischnished/main/init.lua"))()
```

## With Error Handling
```lua
-- Safe execution with error handling
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/pwd0kernel/Fischnished/main/init.lua"))()
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/pwd0kernel/fischnished-cheat/main/init.lua"))()
```

## One-Liner for Executors
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/pwd0kernel/fischnished-cheat/main/init.lua"))()
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
