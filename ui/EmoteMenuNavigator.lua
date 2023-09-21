-- EmoteMenuNavigator
-- recieves input, traverses the emotes tree, and executes the emote.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class MenuEvent
EmoteMenuEvent = {
    GoNode   = "GoNode",
    Execute  = "Execute",
    Exit     = "Exit",
    Reset    = "Reset",
}


---@class EmoteMenuNavigator
---@field menu EmoteTree a hierarchical, nested set of tables representing a menu of emotes
---@field node table currently selected node
---@field stack table<number,number|string> -- array of nodeIds representing the path of nodes traversed
---@field subscribers table<string,table<function,boolean|string> : <event,list<callback,name>> collection of fuctions to be invoked in case of events
EmoteMenuNavigator = {
    subscribers = {},
}

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

---@param treeMenu EmoteTree
function EmoteMenuNavigator:new(treeMenu)
    local self = { }
    setmetatable(self, { __index = EmoteMenuNavigator })
    self:replaceMenu(treeMenu)
    return self
end

---@param treeMenu EmoteTree
function EmoteMenuNavigator:replaceMenu(treeMenu)
    self.menu = treeMenu
    self.node = treeMenu
    self.stack = nil
end

function EmoteMenuNavigator:goTop(msg)
    self.node = self.menu
    self.stack = nil
    self:notifySubs(EmoteMenuEvent.Reset, msg or "Reset came from goTop")
    self:notifySubs(EmoteMenuEvent.GoNode, msg or "GoNode came from goTop", self.node)

end

---@param key string a keystroke
function EmoteMenuNavigator:input(key)

end

---@param nodeId number|string
function EmoteMenuNavigator:pickNode(nodeId)

end

---@param event MenuEvent
---@return function
---@param name string
function EmoteMenuNavigator:subscribe(event, callback, name)
    if not self.subscribers[event] then
        self.subscribers[event] = {}
    end
    -- by virtue of the hash table, each callback can only be registered once and thus is called only once per event
    self.subscribers[event][callback] = name or true
end

---@param event MenuEvent
---@param msg string
---@return boolean any subscribers handled the event
function EmoteMenuNavigator:notifySubs(event, msg, ...)
    local subs = self.subscribers[event]
    if not subs then
        zebug.trace:print("WARNING: nobody's listening for", event)
        return false
    end

    local handled = false
    for callback, who in pairs(subs) do
        zebug.trace:print("broadcasting event",event, "to subscriber",who, "invoking",callback)
        local wasHandled = callback(msg, ...)
        if wasHandled then handled = true end
    end

    return true

end
