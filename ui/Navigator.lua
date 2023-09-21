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
    GoNode  = { name="GoNode",  arg1="instigator name", arg2="EmoteDefinition" },
    OnEmote = { name="OnEmote", arg1="instigator name", arg2="EmoteDefinition" },
    Exit    = { name="Exit",    arg1="string", arg2="?" },
    Reset   = { name="Reset",   arg1="string", arg2="?" },
}

---@class Navigator
---@field tree EmoteTree a hierarchical, nested set of tables representing a menu of emotes
---@field node table currently selected node: an array of nodeDefs or a single nodeDef
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
    ---@type Navigator
    local self = { }
    setmetatable(self, { __index = Navigator })
    self:replaceMenu(treeMenu)
    return self
end

---@param treeMenu EmoteTree
function Navigator:replaceMenu(treeMenu)
    if treeMenu ~= self.tree then
        self.tree = treeMenu
        self.node = self:getTopMenu()
    end
    self.stack = nil
end

function Navigator:reset(msg, newTree)
    self:replaceMenu(newTree or self.tree)
    self:notifySubs(NavEvent.Reset, msg or "Reset event came from Navigator:Reset")
    self:notifySubs(NavEvent.GoNode, msg or "GoNode event came from Navigator:Reset", self.node)
end

-- PROOF OF CONCEPT
---@param emoteCat EmoteCat
function Navigator:throwUpSubMenu(emoteCat)
    local subMenu = self.tree[emoteCat or EmoteCat.Combat]
    local emotes = self:convertNamesIntoNodes(subMenu)
    self:notifySubs(NavEvent.GoNode, "menu for one category", emotes)
end

-- PROOF OF CONCEPT
function Navigator:throwUpTopMenu()
    local top = self:getTopMenu()
    --zebug.warn:dumpy("getTopMenu()", top)
    self:notifySubs(NavEvent.GoNode, "Go Top!", top)
end

-- PROOF OF CONCEPT
function Navigator:throwUpFlatList(emotesTree)
    local emotesList = EmoteDefinitions:flattenTreeIntoList(emotesTree)
    --zebug.warn:dumpy("emotesList",emotesList)
    self:notifySubs(NavEvent.GoNode, "FlAt", emotesList)
end

function Navigator:getTopMenu()
    local list = {}
    ---@param emoteCat EmoteCat
    for emoteCat, arrayOfEmoteDefs in ipairs(self.tree) do
        zebug.error:print("i", emoteCat, "arrayOfEmoteDefs", arrayOfEmoteDefs)
        ---@type EmoteDefinition
        local row = { cat=emoteCat, name=emoteCat, icon = EmoteCatDef[arrayOfEmoteDefs] and EmoteCatDef[arrayOfEmoteDefs].icon }
        list[emoteCat] = row
    end
    return list
end

function Navigator:convertNamesIntoNodes(names)
    local nodes = {}
    ---@param i EmoteCat
    for i, name in ipairs(names) do
        zebug.error:print("i", i, "name", name)
        nodes[i] = EmoteDefinitions.defaults[name]
    end
    return nodes
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
        zebug.trace:print("WARNING: nobody's listening for", event.name)
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
