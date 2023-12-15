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
    UpKey   = { name="Up Key", arg1="string", arg2="?" },
    DownKey = { name="Down Key", arg1="string", arg2="?" },
    SearchStringChange = { name="SearchStringChange", arg1="instigator name", arg2="the new search string" },
}

---@alias NavNodeId number
---@alias SearchIndex table<string,list<number,NavNode>

---@class NavNode
---@field id NavNodeId if this node is contained within a table, id will be a copy of its key / index
---@field name string human readable id
---@field level number how far down the tree
---@field parentId NavNodeId the id of the parent NavNode - nil in the case of top level (ie Category) nodes
---@field domainData DomainData -- somewhere else, type our an annotation like this one ---@alias DomainData EmoteDefinition
---@field kids table<index,NavNode> -- should be handled as a NavEvent.OpenNode
---@field isExe boolean should be handled as a NavEvent.Execute (perhaps in addition to NavEvent.OpenNode?)
---@field searchIndex SearchIndex all of the kids names chopped up and indexed
---@field searchIndexProxy EmoteCat a kid node whose searchIndex should be used instead
---@field isSearchResult boolean

-- Example. searchIndex
local exampleSearchIndex = {
    ["a"] = { -- any kid with an "a" anywhere
        "nodeObjFor:agree", "nodeObjFor:amaze", "nodeObjFor:angry", -- etc.
        "nodeObjFor:bArk",  "nodeObjFor:bAshful", -- etc.
        "nodeObjFor:brAndish", -- etc.
        "nodeObjFor:whoA", -- etc. etc etc
    },
    ["ag"] = { -- any kid with an "ag" anywhere
        "nodeObjFor:AGree", "nodeObjFor:mAGnificent", "nodeObjFor:massAGe",
    },
    ["agr"] = { "nodeObjFor:agree", },
    ["agre"] = { "nodeObjFor:agree", },
    ["agree"] = { "nodeObjFor:agree", },
    ["am & ama & amaz & amaze"] = { "nodeObjFor:amaze", },  -- etc etc etc
    ["an"] = {   -- any kid with an "an" anywhere
        "nodeObjFor:angry", "nodeObjFor:brandish", "nodeObjFor:dance", -- etc
    },
}

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

---@param newTree? NavNode
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

---@param navNode NavNode
function Navigator:replaceCurrentNode(navNode)
    self.stack[#self.stack] = navNode
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
    self:goNode(msg, node)
end

function Navigator:goSearchResults(matches)
    local originalNode = self:getCurrentNode()
    local newNavNode = self:convertSearchResultsIntoNode(matches, originalNode)
    if originalNode.isSearchResult then
        self:replaceCurrentNode(newNavNode)
    else
        self:push(newNavNode)
    end
    self:goCurrentNode("search results")
end

function Navigator:goNode(msg, node)
    -- tell each kid what its index is... useful when filters are dynamically changing the contents
    for i, kidNode in ipairs(node.kids) do
        kidNode.id = i
    end
    self:notifySubs(NavEvent.OpenNode, (msg or "goCurrentNode") .. " level="..((node and node.level)or"nil"), node)
end

---@return NavNode
---@param originalNode NavNode
function Navigator:convertSearchResultsIntoNode(matches, originalNode)
    ---@type NavNode
    local result = {
        id = originalNode.id,
        name = self.searchString,
        level = originalNode.level + 1,
        kids = matches or {},
        parentId = EmoteCat.Everything,
        domainData = originalNode.domainData,
        searchIndex = originalNode.searchIndex,
        searchIndexProxy = originalNode.searchIndexProxy,
        isSearchResult = true,
    }
    return result
end


---@return boolean true if consumed: stop propagation!
function Navigator:handleKeyPress(key)
    -- assume Bliz consistently provides key in all upper case... ROFLMAO!!!
    -- Is Bliz EVER consistent about ANYTHING?!?!   OMG, good one!!!  Tears!  Tears streaming from my eyes!
    key = string.upper(key)

    -- the escape key closes the window
    --if key == "ESCAPE" then
    --    self:exit()
    --    return KeyListenerResult.consumed
    --end

    -- the LEFT and UP keys exit the current level and goes up one
    if
    key == "ESCAPE" or
    key == "LEFT" or
    ((key == "DELETE" or key == "BACKSPACE") and not self.searchString) then
        self:goUp()
        return KeyListenerResult.consumed
    end

    if key == "DOWN" then
        self:notifySubs(NavEvent.DownKey, "Down Key")
        return KeyListenerResult.consumed
    elseif key == "UP" then
        self:notifySubs(NavEvent.UpKey, "Up Key")
        return KeyListenerResult.consumed
    end

    local keyAsNumber = tonumber(key)
    if keyAsNumber then
        zebug.trace:print("found number",key, "is", keyAsNumber)
        if keyAsNumber == 0 then keyAsNumber = 10 end
    end

    if not keyAsNumber then
        -- is the key equivalent to a number ?
        keyAsNumber = convertKeyToIndex(key, DB.opts.quickKeyBacktick, "`", 0)
                or convertKeyToIndex(key, DB.opts.quickKeyDash, "-", 11)
                or convertKeyToIndex(key, DB.opts.quickKeyEqual, "=", 12)
        zebug.trace:print("convertKeyToIndex key",key, "as number?", keyAsNumber)
    end

    if keyAsNumber then
        zebug.trace:print("handling number key", keyAsNumber)
        keyAsNumber = keyAsNumber + ((DB.opts.quickKeyBacktick and 1) or 0)
        return self:inputNumber(keyAsNumber)
    end

    zebug.trace:print("IT'S...", key)

    local word
    if string.match(key, '^[a-zA-Z]$') then
        word = self:pushLetter(key)
    elseif key == "DELETE" or key == "BACKSPACE" then
        word = self:popLetter()
    elseif key == "ENTER" then
        -- treat enter the same as pressing the "1" key
        local result = self:inputNumber(1)
        if result == KeyListenerResult.consumed then
            -- pressing shift-enter will exit the window
            if IsModifierKeyDown() then
                self:exit()
            end
        end
        return result
    else
        -- exit when any unrecognized key is pressed
        return KeyListenerResult.passedOn
    end

    zebug.trace:print("word", word)
    if exists(word) then
        local matches = self:search(word)
        if not matches then
            -- self:popLetter() -- remove the last letter
        end
        self:goSearchResults(matches)
        return KeyListenerResult.consumed
    else
        local x = self:getCurrentNode()
        if x.isSearchResult then
            self:pop()
            self:goCurrentNode("search text cleared")
        end
    end

    return KeyListenerResult.passedOn
end

---@param c string a single letter
---@return string the word formed by all input letters
function Navigator:pushLetter(c)
    c = string.lower(c)
    if self.searchString then
        self.searchString = self.searchString .. c
    else
        self.searchString = c
    end
    self:broadcastSearchStringChange("added "..c)
    return self.searchString
end

---@return string the word formed by all input letters minus the last one
function Navigator:popLetter()
    if self.searchString then
        self.searchString = string.sub(self.searchString, 1, -2)
        if string.len(self.searchString) == 0 then
            self.searchString = nil
        end
    end
    self:broadcastSearchStringChange("popped")
    return self.searchString
end

function Navigator:nukeSearchString()
    self.searchString = nil
    self:broadcastSearchStringChange("nuked")
end

function Navigator:broadcastSearchStringChange(msg)
    self:notifySubs(NavEvent.SearchStringChange, msg or "googly do!", self.searchString)
end

---@return number
---@param VAL number
function convertKeyToIndex(key, opt, KEY, VAL)
    if opt then
        if key == KEY then
            return VAL
        end
    end
end

---@param num number
---@return boolean true if consumed: stop propagation!
function Navigator:inputNumber(num)
    zebug.info:print("num",num)
    if not num then return false end
    local selectedNode = self:getCurrentNode()
    local pickedKid = selectedNode.kids[num]
    if pickedKid then
        pickedKid.id = num -- is this still needed?
        self:pickNode(pickedKid)
        return KeyListenerResult.consumed
    end
    return KeyListenerResult.passedOn
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

---@param word string
---@return table<number,NavNode> the NavNodes corresponding to all emotes that match the search word
function Navigator:search(word)
    local navNode = self:getCurrentNode()

    if navNode.searchIndexProxy then
        navNode = self.rootNode.kids[navNode.searchIndexProxy]
    end

    local searchIndex = navNode.searchIndex
    if not searchIndex then
        navNode.searchIndex = self:createSearchIndex(navNode)
    end

    local matches = navNode.searchIndex[word]
    zebug.trace:dumpy("matches",matches)

    return matches
end

---@param navNode NavNode
---@return SearchIndex -- <string,list<number,NavNode>
function Navigator:createSearchIndex(navNode)
    local searchIndex = {}

    -- iterate over every kid, chop up its name, and index the pieces
    ---@param kidNode NavNode
    for kidN, kidNode in ipairs(navNode.kids) do
        local alreadyIndexedFor = {}
        local name = kidNode.domainData.name
        zebug.trace:line(10, "kidN",kidN, "name",name)
        local len = string.len(name)
        for i = 1, len do
            -- take "clap" and chop it into c,cl,cla,clap... then l,la,lap... then a,ap... then p.
            for j = i, len do
                local subStr = string.sub(name, i, j)
                zebug.trace:print("subStr",subStr)
                local subStrings = searchIndex[subStr]
                if not subStrings then
                    subStrings = {}
                    searchIndex[subStr] = subStrings
                end
                if not alreadyIndexedFor[subStr] then
                    subStrings[#subStrings + 1] = kidNode -- { "c" = { "clap's NavNode"  }  }
                    alreadyIndexedFor[subStr] = true -- prevent the case of "eye" getting indexed under "e" twice
                end
            end
        end
    end

    zebug.trace:dumpy("searchIndex",searchIndex)

    return searchIndex
end

function Navigator:exit()
    self:nukeSearchString()
    self:replaceMenu(self.rootNode)
    self:goCurrentNode("Exit")
    self:notifySubs(NavEvent.Exit, "explicit exit")
end

function Navigator:goUp()
    self:nukeSearchString()

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
