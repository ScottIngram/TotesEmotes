-- BlizGlobalEventsListener.lua
-- register callbacks for global (non-frame) events

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

local ADDON_NAME, ADDON_SYMBOL_TABLE = ...
ADDON_SYMBOL_TABLE.Wormhole()
local zebug = Zebug:new(Zebug.OUTPUT.WARN)

---@class BlizGlobalEventsListener
BlizGlobalEventsListener = {}

-------------------------------------------------------------------------------
-- Event Handler Registration
-------------------------------------------------------------------------------

---@param zelf table will act as the "self" object in all eventHandlers
---@param eventHandlers table<string, function> key -> "EVENT_NAME" , value -> handlerCallback
---@param addonLoadedHandlers table<string, function> key -> "OtherAddonName" , value -> funcToCallWhenOtherAddonLoads
-- Note: addons that load before yours will not be handled.  Use IsAddOnLoaded(addonName) instead
function BlizGlobalEventsListener:register(zelf, eventHandlers, addonLoadedHandlers)
    local dispatcher = function(listenerFrame, eventName, ...)
        eventHandlers[eventName](zelf, ...)
    end

    local eventListenerFrame = CreateFrame("Frame", ADDON_NAME.."BlizGlobalEventsListener")
    eventListenerFrame:SetScript("OnEvent", dispatcher)

    -- handle the ADDON_LOADED event separately
    if isTableNotEmpty(addonLoadedHandlers) then
        local existingHandler = eventHandlers.ADDON_LOADED

        -- create a separate hadler just for ADDON_LOADED
        eventHandlers.ADDON_LOADED = function(zelf, loadedAddonName)
            -- START CALLBACK
            if existingHandler then
                zebug.trace:print("triggering the existing ADDON_LOADED handler", existingHandler)
                existingHandler(zelf)
            end

            -- find a handler for the addon that just triggered the ADDON_LOADED event
            for addonName, handler in pairs(addonLoadedHandlers) do
                zebug.trace:name("dispatcher"):print("loaded",loadedAddonName, "comparing to",addonName, "handler",handler)
                if addonName == loadedAddonName then
                    zebug.trace:print("invoking", addonName)
                    handler(zelf, addonName)
                end
            end
            -- END CALLBACK
        end
    end

    for eventName, _ in pairs(eventHandlers) do
        zebug.trace:print("registering ",eventName)
        eventListenerFrame:RegisterEvent(eventName)
    end
end
