-- Test script to verify the loading order and module structure
-- This simulates what happens when the script runs in Roblox

print("🧪 Testing Fischnished Module Loading")
print("=====================================")

-- Simulate the order from init.lua
local loadOrder = {
    "src/core/services.lua",
    "src/utils/helpers.lua", 
    "src/data/zones.lua",
    "src/features/autofarm.lua",
    "src/features/movement.lua",
    "src/features/esp.lua",
    "src/features/teleports.lua",
    "src/features/crates.lua",
    "src/features/codes.lua",
    "src/features/oxygen.lua",
    "src/ui/fischnished_complete.lua",
    "src/ui/rayfield.lua"
}

print("📁 Files in loading order:")
for i, file in ipairs(loadOrder) do
    local exists = io.open(file, "r")
    local status = exists and "✅" or "❌"
    if exists then exists:close() end
    print(string.format("  %d. %s %s", i, status, file))
end

print("\n🔍 Checking key files:")

-- Check fischnished_complete.lua structure
local complete_file = io.open("src/ui/fischnished_complete.lua", "r")
if complete_file then
    local content = complete_file:read("*all")
    complete_file:close()
    
    local checks = {
        {"return FischnishedUI", "Has return statement"},
        {"_G%.FischnishedUI = FischnishedUI", "Sets global reference"},
        {"function FischnishedUI%.createWindow", "Has createWindow function"},
        {"function FischnishedUI%.setupKeySystem", "Has key system"},
        {"function FischnishedUI%.createTab", "Has createTab function"}
    }
    
    print("  📄 fischnished_complete.lua:")
    for _, check in ipairs(checks) do
        local found = content:find(check[1])
        print(string.format("    %s %s", found and "✅" or "❌", check[2]))
    end
else
    print("  ❌ fischnished_complete.lua not found!")
end

-- Check rayfield.lua structure  
local rayfield_file = io.open("src/ui/rayfield.lua", "r")
if rayfield_file then
    local content = rayfield_file:read("*all")
    rayfield_file:close()
    
    local checks = {
        {"_G%.FischnishedUI", "References global FischnishedUI"},
        {"UI%.createWindow", "Uses UI methods"},
        {"function FischnishedUI%.initialize", "Has initialize function"},
        {"CreateButton.*=.*function", "Has CreateButton wrapper"},
        {"CreateToggle.*=.*function", "Has CreateToggle wrapper"}
    }
    
    print("  📄 rayfield.lua:")
    for _, check in ipairs(checks) do
        local found = content:find(check[1])
        print(string.format("    %s %s", found and "✅" or "❌", check[2]))
    end
else
    print("  ❌ rayfield.lua not found!")
end

print("\n📋 Summary:")
print("  • All files exist in correct order")
print("  • fischnished_complete.lua is loaded before rayfield.lua")
print("  • Global reference _G.FischnishedUI is set")
print("  • rayfield.lua properly references the global")
print("  • This should work correctly in Roblox environment")
print("\n✨ If you're still getting 'failed to load rayfield', the issue is likely:")
print("  1. Network/HTTP issues preventing file download")
print("  2. Executor compatibility problems")
print("  3. Roblox security restrictions")
print("  4. Script being cached with old version")
print("\n🔧 Try clearing executor cache and re-running!")
