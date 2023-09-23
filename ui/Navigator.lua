-- Navigator
-- recieves input, traverses the emotes tree, and executes the emote.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@enum NavEvent
NavEvent = {
    Execute = { name="Execute", arg1="instigator name", arg2="NavNode" },
    GoNode  = { name="GoNode",  arg1="instigator name", arg2="NavNode" },
    OnEmote = { name="OnEmote", arg1="instigator name", arg2="EmoteDefinition" },
    Exit    = { name="Exit",    arg1="string", arg2="?" },
    Reset   = { name="Reset",   arg1="string", arg2="?" },
}

---@alias NavNodeId number

---@class NavNode
---@field id NavNodeId if this node is contained within a table, id will be a copy of its key / index
---@field level number how far down the tree
---@field parentId NavNodeId the id of the parent NavNode - nil in the case of top level (ie Category) nodes
---@field domainData DomainData -- somewhere else, type our an annotation like this one ---@alias DomainData EmoteDefinition
---@field kids table<index,NavNode>

---@class Navigator
---@field rootNode NavNode a hierarchical, nested set of tables representing a menu of emotes
---@field stack table<number,number|string> -- array of nodeIds representing the path of nodes traversed
---@field subscribers table<string,table<function,boolean|string> : <event,list<callback,name>> collection of fuctions to be invoked in case of events
Navigator = {
    stack = {},
    subscribers = {},
}

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

---@param rootNode NavNode
function Navigator:new(rootNode)
    ---@type Navigator
    local self = deepcopy(Navigator, {})
    setmetatable(self, { __index = Navigator })
    self:replaceMenu(rootNode)
    return self
end

---@param rootNode NavNode
function Navigator:replaceMenu(rootNode)
    if rootNode ~= self.rootNode then
        self.rootNode = rootNode
        self.openedNode = rootNode
    end
    for i = #self.stack, 1, -1 do
        self.stack[i] = nil
    end
    self:push(rootNode)
end

function Navigator:reset(msg, newTree)
    self:replaceMenu(newTree or self.rootNode)
    self:notifySubs(NavEvent.Reset, msg or "Reset event came from Navigator:Reset")
    self:throwUpTopMenu()
end

function Navigator:getSelectedNode()
    return self.stack[#self.stack]
end

---@param navNode NavNode
function Navigator:push(navNode)
    self.stack[#self.stack + 1] = navNode
end

---@return NavNode
function Navigator:pop()
    local foo
    if #self.stack > 0 then
        foo = self.stack[#self.stack]
        self.stack[#self.stack] = nil
    end
    return foo
end

function Navigator:throwUpTopMenu()
    self:notifySubs(NavEvent.GoNode, "Go Top!", self.rootNode)
end

-- PROOF OF CONCEPT
function Navigator:throwUpFlatList(emotesTree)
    local emotesList = EmoteDefinitions:flattenTreeIntoList(emotesTree)
    --zebug.warn:dumpy("emotesList",emotesList)
    self:notifySubs(NavEvent.GoNode, "FlAt", emotesList)
end

---@param key string a keystroke
function Navigator:input(key)
    local num = tonumber(key) -- TODO: support a-z ?
    zebug.error:print("key",key, "num",num)
    if not num then return false end
    local selectedNode = self:getSelectedNode()
    local pickedKid = selectedNode.kids[num]
    pickedKid.id = num

    --zebug.error:dumpy("node",selectedNode)
    --zebug.error:print("num",num, "pickedKid", pickedKid)
    --zebug.error:dumpy("emoteDef", pickedKid)

    if pickedKid then
        self:pickNode(pickedKid)
        return true
    end
    return false
end

---@param navNode NavNode
function Navigator:pickNode(navNode)
    if navNode.kids then
        self:push(navNode)
        self:notifySubs(NavEvent.GoNode, "open node id "..navNode.id, navNode)
    else
        self:notifySubs(NavEvent.Execute, "childless node "..navNode.id, navNode)
    end
end

function Navigator:goUp()
    local level = self:pop()
    if level then
        self:throwUpTopMenu("addon initialization")
    else
        self:notifySubs(NavEvent.Exit, "goUp")
    end
end

---@param event NavEvent
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
        zebug.trace:print("broadcasting event",event.name, "to subscriber",who, "invoking",callback, "with msg",msg, "arg1",... )
        local wasHandled = callback(msg, ...)
        if wasHandled then handled = true end
    end

    return true

end
