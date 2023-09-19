-- Object

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

local ADDON_NAME, ADDON_SYMBOL_TABLE = ...
ADDON_SYMBOL_TABLE.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the Totes object

---@class Object
Object = {}

function Object:new(class)
    local self = {}

    local getterNames = {}
    local getterLoops = {}
    local getter = function(self, key)
        -- examine the class for a getter function --> MyClass:getMyValue()
        if not getterNames[key] then
            getterNames[key] = makeGetterName(key)
        end
        local getterName = getterNames[key]
        local getterFunc = class[getterName]
        if getterFunc then
            if getterLoops[key] then
                return rawget(self, key)
            else
                getterLoops[key] = true
                local val = getterFunc()
                getterLoops[key] = false
                return val
            end
        end

        return self[key]

        -- error(string.format([[No attribute "%s" and no method "%s()"]], key, getterName))
    end

    local setterNames = {}
    local setterLoops = {}
    local setter = function(self, key, value)
        -- examine the class for a getter function --> MyClass:getMyValue()
        if not setterNames[key] then
            setterNames[key] = makeSetterName(key)
        end
        local setterName = setterNames[key]
        local setterFunc = class[setterName]
        if setterFunc then
            if setterLoops[key] then
                return rawset(self, key)
            else
                setterLoops[key] = true
                setterFunc(value)
                setterLoops[key] = false
            end
        end

        self[key] = value
    end

    setmetatable(self, {
        __index = getter,
        __newindex = setter
    })
end

function makeGetterName(key)
    return makeActorName("get")
end

function makeSetterName(key)
    return makeActorName("set")
end

function makeActorName(action, key)
    -- for "get", "myValue" return "getMyValue"
    return action .. string.upper( strsub(key,1,1)  ) .. strsub(key,2)
end
