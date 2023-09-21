-- Navigator
-- recieves input, traverses the emotes tree, and executes the emote.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class NavEvent
NavEvent = {
    GoNode  = { name="GoNode",  arg1="string", arg2="?" },
    OnEmote = { name="OnEmote", arg1="instigator name", arg2="EmoteDefinition" },
    Exit    = { name="Exit",    arg1="string", arg2="?" },
    Reset   = { name="Reset",   arg1="string", arg2="?" },
}

---@class Navigator
---@field menu EmoteTree a hierarchical, nested set of tables representing a menu of emotes
---@field node table currently selected node
---@field stack table<number,number|string> -- array of nodeIds representing the path of nodes traversed
---@field subscribers table<string,table<function,boolean|string> : <event,list<callback,name>> collection of fuctions to be invoked in case of events
Navigator = {
    subscribers = {},
}

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

---@param treeMenu EmoteTree
function Navigator:new(treeMenu)
    local self = { }
    setmetatable(self, { __index = Navigator })
    self:replaceMenu(treeMenu)
    return self
end

---@param treeMenu EmoteTree
function Navigator:replaceMenu(treeMenu)
    self.menu = treeMenu
    self.node = treeMenu
    self.stack = nil
end

function Navigator:goTop(msg)
    self.node = self.menu
    self.stack = nil
    self:notifySubs(NavEvent.Reset, msg or "Reset came from goTop")
    self:notifySubs(NavEvent.GoNode, msg or "GoNode came from goTop", self.node)

end

---@param key string a keystroke
function Navigator:input(key)

end

---@param nodeId number|string
function Navigator:pickNode(nodeId)

end

---@param event NavEvent
---@return function
---@param name string
function Navigator:subscribe(event, callback, name)
    if not self.subscribers[event] then
        self.subscribers[event] = {}
    end
    -- by virtue of the hash table, each callback can only be registered once and thus is called only once per event
    self.subscribers[event][callback] = name or true
end

---@param event NavEvent
---@param msg string
---@return boolean any subscribers handled the event
function Navigator:notifySubs(event, msg, ...)
    local subs = self.subscribers[event]
    if not subs then
        zebug.trace:print("WARNING: nobody's listening for", event)
        return false
    end

    local handled = false
    for callback, who in pairs(subs) do
        zebug.trace:print("broadcasting event",event.name, "to subscriber",who, "invoking",callback, "with msg",msg)
        local wasHandled = callback(msg, ...)
        if wasHandled then handled = true end
    end

    return true

end
