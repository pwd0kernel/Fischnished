-- Creator Codes Feature Module
-- Handles creator code claiming functionality
-- Part of Fischnished Cheat by Buffer_0verflow

local Codes = {}
local Services = _G.Fischnished.core.services

function Codes.createUI()
    local CodesTab = _G.Fischnished.UI.Tabs.Codes
    
    CodesTab:CreateDropdown({
        Name = "Select Creator Code",
        Options = Codes.getAllCreatorCodes(),
        CurrentOption = Services.State.selectedCode,
        Flag = "CodeDropdown",
        Callback = function(Option)
            Services.State.selectedCode = Option
            print("Selected code: " .. Option)
        end,
    })

    CodesTab:CreateButton({
        Name = "Claim Selected Code",
        Callback = function()
            if Services.State.selectedCode and Services.State.selectedCode ~= "" then
                Codes.claimCode(Services.State.selectedCode)
            else
                print("❌ No code selected!")
            end
        end,
    })

    CodesTab:CreateToggle({
        Name = "Auto Claim Codes",
        CurrentValue = false,
        Flag = "AutoClaimToggle",
        Callback = function(Value)
            Codes.toggleAutoClaim(Value)
        end,
    })

    CodesTab:CreateSlider({
        Name = "Claim Delay",
        Range = {0.5, 10},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = 1,
        Flag = "ClaimDelaySlider",
        Callback = function(Value)
            Services.State.claimDelay = Value
        end,
    })

    CodesTab:CreateButton({
        Name = "Claim All Codes Once",
        Callback = function()
            Codes.claimAllCodes()
        end,
    })

    CodesTab:CreateButton({
        Name = "List All Available Codes",
        Callback = function()
            Codes.listAllCodes()
        end,
    })

    CodesTab:CreateButton({
        Name = "Refresh Code List",
        Callback = function()
            Codes.refreshCodeList()
        end,
    })

    CodesTab:CreateButton({
        Name = "Test Single Code",
        Callback = function()
            Codes.testSingleCode()
        end,
    })
end

function Codes.getAllCreatorCodes()
    local codes = {}
    Services.safePcall(function()
        local creatorCodesModule = Services.ReplicatedStorage.shared.modules.CreatorCodes
        if creatorCodesModule then
            local codeList = require(creatorCodesModule)
            if type(codeList) == "table" then
                codes = codeList
            end
        end
    end)
    
    -- Fallback list if module reading fails
    if #codes == 0 then
        codes = {
            "CARBON", "JERX", "KAZER", "UNOTWO", "TEDWA", 
            "MARVINBLOX", "ELEGY", "CHRONAT", "ROBLOXGAMERZ", 
            "FISCHUZZ", "AMARI", "VALOR"
        }
    end
    
    return codes
end

function Codes.claimCode(code)
    Services.safePcall(function()
        local args = {code}
        Services.ReplicatedStorage:WaitForChild("events"):WaitForChild("runcode"):FireServer(unpack(args))
        print("🎁 Claimed code: " .. code)
    end)
end

function Codes.toggleAutoClaim(enabled)
    Services.State.enabledFlags["AutoClaim"] = enabled
    
    if enabled then
        Services.State.autoClaimLoop = task.spawn(function()
            local codes = Codes.getAllCreatorCodes()
            local codeIndex = 1
            
            while Services.State.enabledFlags["AutoClaim"] and codeIndex <= #codes do
                local code = codes[codeIndex]
                Codes.claimCode(code)
                print("🤖 Auto claimed code " .. codeIndex .. "/" .. #codes .. ": " .. code)
                codeIndex = codeIndex + 1
                task.wait(Services.State.claimDelay)
            end
            
            if Services.State.enabledFlags["AutoClaim"] then
                print("✅ Finished claiming all codes! Restarting cycle...")
                -- Restart the cycle
                codeIndex = 1
            end
        end)
        print("🤖 Auto Claim Codes started")
    else
        Services.cleanupConnection("autoClaimLoop")
        print("🤖 Auto Claim Codes stopped")
    end
end

function Codes.claimAllCodes()
    local codes = Codes.getAllCreatorCodes()
    print("🎁 Claiming all creator codes...")
    
    task.spawn(function()
        for i, code in ipairs(codes) do
            Codes.claimCode(code)
            print("🎁 Claimed " .. i .. "/" .. #codes .. ": " .. code)
            task.wait(0.5) -- Small delay between claims
        end
        print("✅ Finished claiming all codes!")
    end)
end

function Codes.listAllCodes()
    local codes = Codes.getAllCreatorCodes()
    print("=== AVAILABLE CREATOR CODES ===")
    for i, code in ipairs(codes) do
        print(i .. ". " .. code)
    end
    print("Total codes: " .. #codes)
    print("================================")
end

function Codes.refreshCodeList()
    local newCodes = Codes.getAllCreatorCodes()
    print("🎁 Creator codes refreshed!")
    print("Found " .. #newCodes .. " codes:")
    for i, code in ipairs(newCodes) do
        print(i .. ". " .. code)
    end
end

function Codes.testSingleCode()
    if Services.State.selectedCode and Services.State.selectedCode ~= "" then
        print("🧪 Testing code: " .. Services.State.selectedCode)
        Codes.claimCode(Services.State.selectedCode)
        print("🧪 Test claim sent for: " .. Services.State.selectedCode)
    else
        print("❌ Please select a code first!")
    end
end

return Codes
