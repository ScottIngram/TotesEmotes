-- EventRegistry
-- lets your code issue custom events and have other parts of your code react
-- TODO: support async?

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

local ADDON_NAME, ADDON_SYMBOL_TABLE = ...
ADDON_SYMBOL_TABLE.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the ADDON_SYMBOL_TABLE

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-- create a global variable so my addons can talk to each other
if not _G["ScottFreeEventSubscribers"] then
    _G["ScottFreeEventSubscribers"] = {}
end

local subscribers = _G["ScottFreeEventSubscribers"]

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

function EventRegistry:register(event, callback, name)
    if not subscribers[event] then
        subscribers[event] = {}
    end
    -- by virtue of the hash table, each callback can onlty be registered once and thus is called only once per event
    subscribers[event][callback] = name or true
end

function EventRegistry:broadcast(event, msg, ...)
    local subs = subscribers[event]
    if not subs then
        zebug.trace:print("WARNING: nobody's listening for", event)
        return
    end

    for who, callback in pairs(subs) do
        zebug.trace:print("broadcasting event", event, "to subscriber", who)
    end
end
