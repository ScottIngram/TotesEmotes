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
    OpenNode= { name="OpenNode",  arg1="instigator name", arg2="NavNode" },
    OnEmote = { name="OnEmote", arg1="instigator name", arg2="EmoteDefinition" },
    Exit    = { name="Exit",    arg1="string", arg2="?" },
    Reset   = { name="Reset",   arg1="string", arg2="?" },
}

---@alias NavNodeId number

---@class NavNode
---@field id NavNodeId if this node is contained within a table, id will be a copy of its key / index
---@field name string human readable id
---@field level number how far down the tree
---@field parentId NavNodeId the id of the parent NavNode - nil in the case of top level (ie Category) nodes
---@field domainData DomainData -- somewhere else, type our an annotation like this one ---@alias DomainData EmoteDefinition
---@field kids table<index,NavNode> -- should be handled as a NavEvent.OpenNode
---@field isExe boolean should be handled as a NavEvent.Execute (perhaps in addition to NavEvent.OpenNode?)


---@class Navigator
---@field rootNode NavNode a hierarchical, nested set of tables representing a menu of emotes
---@field stack table<number,NavNode> -- array of traversed NavNodes
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
    self:goCurrentNode("Reset")
end

---@return NavNode
function Navigator:getCurrentNode()
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

function Navigator:goCurrentNode(msg)
    local node = self:getCurrentNode()
    self:broadcastNode(msg, node)
end

function Navigator:broadcastNode(msg, node)
    -- tell each kid what its index is... useful when filters are dynamically changing the contents
    for i, kidNode in ipairs(node.kids) do
        kidNode.id = i
    end
    self:notifySubs(NavEvent.OpenNode, (msg or "goCurrentNode") .. " level="..((node and node.level)or"nil"), node)
end

---@param num number
function Navigator:input(num)
    zebug.info:print("num",num)
    if not num then return false end
    local selectedNode = self:getCurrentNode()
    local pickedKid = selectedNode.kids[num]
    pickedKid.id = num -- required because I didn't assign it earlier

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
        self:goCurrentNode("pick node id "..navNode.id)
    else
        self:notifySubs(NavEvent.Execute, "childless node "..navNode.id, navNode)
    end
end

function Navigator:goUp()
    --self:printStack()

    -- don't go higher than the root.  signal "Exit" instead
    local currentNode = self:getCurrentNode()
    if currentNode.level == 0 then
        self:notifySubs(NavEvent.Exit, "goUp already at top")
        return
    end

    self:pop()
    self:goCurrentNode("Go Up!")
end

function Navigator:printStack()
    zebug.error:line(20,"NAV STACK")
    for i, navNode in ipairs(self.stack) do
        local dom = navNode.domainData
        local name = dom and dom.name or "noname"
        zebug.error:print("i",i, "id",navNode.id, "level", navNode.level, "name",name)
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
