-- Crates Feature Module
-- Handles crate purchasing functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local Crates = {}
local Services = _G.Fischnished.core.services

function Crates.createUI()
    local CratesTab = _G.Fischnished.UI.Tabs.Crates
    
    CratesTab:CreateDropdown({
        Name = "Select Crate",
        Options = Crates.getAllCrates(),
        CurrentOption = Services.State.selectedCrate,
        Flag = "CrateDropdown",
        Callback = function(Option)
            Services.State.selectedCrate = Option
            print("Selected crate: " .. Option)
        end,
    })

    CratesTab:CreateButton({
        Name = "Buy Selected Crate",
        Callback = function()
            if Services.State.selectedCrate then
                Crates.buyCrate(Services.State.selectedCrate)
            else
                print("❌ No crate selected!")
            end
        end,
    })

    CratesTab:CreateToggle({
        Name = "Auto Buy Crates",
        CurrentValue = false,
        Flag = "AutoBuyToggle",
        Callback = function(Value)
            Crates.toggleAutoBuy(Value)
        end,
    })

    CratesTab:CreateSlider({
        Name = "Buy Delay",
        Range = {0.1, 10},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = 1,
        Flag = "BuyDelaySlider",
        Callback = function(Value)
            Services.State.buyDelay = Value
        end,
    })

    CratesTab:CreateButton({
        Name = "Buy All Crate Types (x1 Each)",
        Callback = function()
            Crates.buyAllCrateTypes()
        end,
    })

    CratesTab:CreateButton({
        Name = "Buy 10x Selected Crate",
        Callback = function()
            Crates.buyMultipleCrates(10)
        end,
    })

    CratesTab:CreateButton({
        Name = "Refresh Crate List",
        Callback = function()
            Crates.refreshCrateList()
        end,
    })
end

function Crates.getAllCrates()
    local crates = {}
    Services.safePcall(function()
        local skinCrateGui = Services.LocalPlayer.PlayerGui:FindFirstChild("SkinCrate")
        if skinCrateGui and skinCrateGui:FindFirstChild("Crates") and skinCrateGui.Crates:FindFirstChild("List") then
            for _, crateFrame in ipairs(skinCrateGui.Crates.List:GetChildren()) do
                if crateFrame:IsA("Frame") or crateFrame:IsA("GuiObject") then
                    -- Try to get crate name from the frame
                    local crateName = crateFrame.Name
                    if crateName ~= "UIListLayout" and crateName ~= "UIPadding" then
                        table.insert(crates, crateName)
                    end
                end
            end
        end
    end)
    
    -- Fallback list of common crates if GUI parsing fails
    if #crates == 0 then
        crates = {
            "Moosewood",
            "Roslit", 
            "Snowcap",
            "Mushgrove",
            "Sunstone",
            "Terrapin",
            "Forsaken",
            "Ancient",
            "Desolate",
            "Volcanic"
        }
    end
    
    return crates
end

function Crates.buyCrate(crateName)
    Services.safePcall(function()
        game:GetService("ReplicatedStorage").packages.Net["RF/SkinCrates/Purchase"]:InvokeServer(crateName)
        print("📦 Purchased crate: " .. crateName)
    end)
end

function Crates.toggleAutoBuy(enabled)
    Services.State.enabledFlags["AutoBuy"] = enabled
    
    if enabled then
        Services.State.autoBuyLoop = task.spawn(function()
            while Services.State.enabledFlags["AutoBuy"] do
                if Services.State.selectedCrate then
                    Crates.buyCrate(Services.State.selectedCrate)
                    task.wait(Services.State.buyDelay)
                else
                    task.wait(1)
                end
            end
        end)
        print("🤖 Auto Buy Crates started")
    else
        Services.cleanupConnection("autoBuyLoop")
        print("🤖 Auto Buy Crates stopped")
    end
end

function Crates.buyAllCrateTypes()
    local crates = Crates.getAllCrates()
    print("📦 Buying one of each crate type...")
    
    task.spawn(function()
        for _, crateName in ipairs(crates) do
            Crates.buyCrate(crateName)
            task.wait(0.5) -- Small delay between purchases
        end
        print("✅ Finished buying all crate types!")
    end)
end

function Crates.buyMultipleCrates(amount)
    if Services.State.selectedCrate then
        print("📦 Buying " .. amount .. "x " .. Services.State.selectedCrate .. " crates...")
        
        task.spawn(function()
            for i = 1, amount do
                Crates.buyCrate(Services.State.selectedCrate)
                print("📦 Bought " .. i .. "/" .. amount)
                task.wait(0.3)
            end
            print("✅ Finished buying " .. amount .. " crates!")
        end)
    else
        print("❌ No crate selected!")
    end
end

function Crates.refreshCrateList()
    local newCrates = Crates.getAllCrates()
    print("📦 Available crates:")
    for i, crate in ipairs(newCrates) do
        print(i .. ". " .. crate)
    end
    print("📦 Crate list refreshed! (" .. #newCrates .. " crates found)")
end

return Crates
