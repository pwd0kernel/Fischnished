-- Utilities Helper Module
-- Contains shared utility functions
-- Part of Fischnished Cheat by Buffer_0verflow

local Helpers = {}

-- Math utilities
function Helpers.randomFloat(min, max)
    return min + (math.random() * (max - min))
end

function Helpers.randomInt(min, max)
    return math.random(min, max)
end

function Helpers.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- String utilities
function Helpers.split(str, delimiter)
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

function Helpers.trim(str)
    return str:match("^%s*(.-)%s*$")
end

function Helpers.contains(str, substring)
    return string.find(string.lower(str), string.lower(substring)) ~= nil
end

-- Table utilities
function Helpers.tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function Helpers.tableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function Helpers.mergeTables(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        result[k] = v
    end
    for k, v in pairs(t2) do
        result[k] = v
    end
    return result
end

-- Position utilities
function Helpers.getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Helpers.getRandomPosition(center, radius)
    local angle = math.random() * 2 * math.pi
    local distance = math.random() * radius
    local x = center.X + math.cos(angle) * distance
    local z = center.Z + math.sin(angle) * distance
    return Vector3.new(x, center.Y, z)
end

-- Timing utilities
function Helpers.humanDelay(baseMs, variationMs)
    variationMs = variationMs or 20
    local delay = (baseMs + math.random(-variationMs, variationMs)) / 1000
    return math.max(0.01, delay) -- Minimum 10ms delay
end

function Helpers.randomDelay(minMs, maxMs)
    return math.random(minMs, maxMs) / 1000
end

-- Safe execution utilities
function Helpers.safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Safe call failed: " .. tostring(result))
        return false, result
    end
    return true, result
end

function Helpers.retryCall(func, maxRetries, delay, ...)
    maxRetries = maxRetries or 3
    delay = delay or 1
    
    for i = 1, maxRetries do
        local success, result = Helpers.safeCall(func, ...)
        if success then
            return true, result
        end
        
        if i < maxRetries then
            wait(delay)
        end
    end
    
    return false, "Max retries exceeded"
end

-- Validation utilities
function Helpers.validateNumber(value, min, max, default)
    if type(value) ~= "number" then
        return default
    end
    return Helpers.clamp(value, min or -math.huge, max or math.huge)
end

function Helpers.validateString(value, default)
    if type(value) ~= "string" then
        return default or ""
    end
    return value
end

function Helpers.validateBoolean(value, default)
    if type(value) ~= "boolean" then
        return default or false
    end
    return value
end

-- Instance utilities
function Helpers.findChild(parent, name, className)
    if not parent then return nil end
    
    for _, child in pairs(parent:GetChildren()) do
        if child.Name == name and (not className or child:IsA(className)) then
            return child
        end
    end
    return nil
end

function Helpers.findDescendant(parent, name, className)
    if not parent then return nil end
    
    for _, descendant in pairs(parent:GetDescendants()) do
        if descendant.Name == name and (not className or descendant:IsA(className)) then
            return descendant
        end
    end
    return nil
end

function Helpers.waitForChild(parent, name, timeout)
    timeout = timeout or 5
    local startTime = tick()
    
    while tick() - startTime < timeout do
        local child = parent:FindFirstChild(name)
        if child then
            return child
        end
        wait(0.1)
    end
    
    return nil
end

-- Logging utilities
function Helpers.log(level, message, ...)
    local timestamp = os.date("%H:%M:%S")
    local prefix = "[" .. timestamp .. "] [" .. level .. "] "
    
    if #{...} > 0 then
        message = string.format(message, ...)
    end
    
    if level == "ERROR" then
        warn(prefix .. message)
    else
        print(prefix .. message)
    end
end

function Helpers.logInfo(message, ...)
    Helpers.log("INFO", message, ...)
end

function Helpers.logWarn(message, ...)
    Helpers.log("WARN", message, ...)
end

function Helpers.logError(message, ...)
    Helpers.log("ERROR", message, ...)
end

function Helpers.logDebug(message, ...)
    if _G.Fischnished and _G.Fischnished.Config and _G.Fischnished.Config.DEBUG then
        Helpers.log("DEBUG", message, ...)
    end
end

-- Color utilities
function Helpers.hexToRgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber("0x" .. hex:sub(1, 2)) / 255
    local g = tonumber("0x" .. hex:sub(3, 4)) / 255
    local b = tonumber("0x" .. hex:sub(5, 6)) / 255
    return Color3.new(r, g, b)
end

function Helpers.randomColor()
    return Color3.new(math.random(), math.random(), math.random())
end

return Helpers
