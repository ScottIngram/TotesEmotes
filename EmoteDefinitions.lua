-- EmoteDefinitions.lua
-- list of all emotes.  Thanks EmoteLDB !

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the Totes object

---@type L10N
L10N = Totes.L10N

---@class EmoteDefinitions
EmoteDefinitions = {}

---@class EmoteCat
EmoteCat = {
    Favorites = 1,
    Happy   = 2,
    Angry   = 3,
    Sad     = 4,
    Neutral = 5,
    Combat  = 6,
    Everything = 7,
}

---@enum EmoteCatDef
EmoteIcons = {
    [0]                = ICON_TOP_MENU,
    [EmoteCat.Favorites] = 413589, --3684826:heart-sword, 135767:broken, 1390944:frozen, 413584:star-medal, 413589:now-you-know,
    [EmoteCat.Happy  ] = 237554,
    [EmoteCat.Angry  ] = 237553,
    [EmoteCat.Sad    ] = 237555,
    [EmoteCat.Neutral] = 237552,
    [EmoteCat.Combat ] = 132147, -- 132147:swords, 458724:target,
    [EmoteCat.Everything] = 4630359, -- 1033987:shield+100, 4630359:color-swirl,
}

---@type table<number,string>
EmoteCatName = {}
for name, i in pairs(EmoteCat) do
    EmoteCatName[i] = name
end

---@class EmoteDefinition
---@field name string a copy of the emote's key/name - this is populated dynamically while sorting the defs
---@field cat EmoteCat category
---@field icon number
---@field audio boolean includes audible vocalization
---@field viz boolean includes visual animation
---@field fix string some emotes break the Bliz API because of course they do.  This field is a synonym that works instead.
---@field isEmote boolean does this entry represent a category instead of an actual emote

---@alias DomainData EmoteDefinition

----------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

---@type table<number, EmoteDefinition>
EmoteDefinitions.list = {
    { name="agree",       cat=EmoteCat.Happy, },
    { name="amaze",       cat=EmoteCat.Happy, },
    { name="angry",       cat=EmoteCat.Angry, viz=true, },
    { name="apologize",   cat=EmoteCat.Sad, },
    { name="applaud",     cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="arm",         cat=EmoteCat.Happy, },
    { name="attacktarget",cat=EmoteCat.Combat, viz=true, audio=true, fix="ATTACKMYTARGET", },
    { name="bark",        cat=EmoteCat.Neutral, },
    { name="bashful",     cat=EmoteCat.Happy, viz=true, },
    { name="beckon",      cat=EmoteCat.Happy, },
    { name="beg",         cat=EmoteCat.Sad, viz=true, },
    { name="belch",       cat=EmoteCat.Neutral, fix="BURP", },
    { name="bite",        cat=EmoteCat.Angry, },
    { name="bleed",       cat=EmoteCat.Sad, },
    { name="blink",       cat=EmoteCat.Neutral, },
    { name="blush",       cat=EmoteCat.Happy, viz=true, },
    { name="boggle",      cat=EmoteCat.Happy, viz=true, },
    { name="bonk",        cat=EmoteCat.Angry, },
    { name="boop",        cat=EmoteCat.Happy, viz=true, },
    { name="bored",       cat=EmoteCat.Sad, audio=true, },
    { name="bounce",      cat=EmoteCat.Happy, },
    { name="bow",         cat=EmoteCat.Happy, viz=true, },
    { name="brandish",    cat=EmoteCat.Angry, },
    { name="brb",         cat=EmoteCat.Neutral, },
    { name="cackle",      cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="calm",        cat=EmoteCat.Neutral, },
    { name="charge",      cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="cheer",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="chicken",     cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="chuckle",     cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="clap",        cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="cold",        cat=EmoteCat.Sad, },
    { name="comfort",     cat=EmoteCat.Happy, },
    { name="commend",     cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="confused",    cat=EmoteCat.Sad, viz=true, },
    { name="congrats",    cat=EmoteCat.Happy, viz=true, audio=true, fix="CONGRATULATE", },
    { name="cough",       cat=EmoteCat.Sad, },
    { name="cower",       cat=EmoteCat.Sad, },
    { name="crack",       cat=EmoteCat.Angry, },
    { name="cringe",      cat=EmoteCat.Sad, },
    { name="cry",         cat=EmoteCat.Sad, viz=true, audio=true, },
    { name="cuddle",      cat=EmoteCat.Happy, },
    { name="curious",     cat=EmoteCat.Neutral, viz=true, },
    { name="curtsey",     cat=EmoteCat.Happy, viz=true, },
    { name="dance",       cat=EmoteCat.Happy, viz=true, },
    { name="ding",        cat=EmoteCat.Happy, },
    { name="doh",         cat=EmoteCat.Angry, },
    { name="doom",        cat=EmoteCat.Angry, audio=true, fix="THREATEN", },
    { name="drink",       cat=EmoteCat.Happy, viz=true, },
    { name="drool",       cat=EmoteCat.Sad, },
    { name="duck",        cat=EmoteCat.Sad, },
    { name="eat",         cat=EmoteCat.Sad, viz=true, },
    { name="excited",     cat=EmoteCat.Happy, viz=true, fix="TALKEX", },
    { name="eye",         cat=EmoteCat.Neutral, },
    { name="eyeroll",     cat=EmoteCat.Sad, fix="ROLLEYES"},
    { name="facepalm",    cat=EmoteCat.Sad, },
    { name="fart",        cat=EmoteCat.Neutral, }, -- no longer targets players
    { name="fidget",      cat=EmoteCat.Sad, },
    { name="flee",        cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="flex",        cat=EmoteCat.Happy, viz=true, },
    { name="flirt",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="flop",        cat=EmoteCat.Sad, },
    { name="followme",    cat=EmoteCat.Combat, viz=true, audio=true, fix="FOLLOW", },
    { name="frown",       cat=EmoteCat.Angry, },
    { name="gasp",        cat=EmoteCat.Happy, viz=true, },
    { name="gaze",        cat=EmoteCat.Neutral, },
    { name="giggle",      cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="glare",       cat=EmoteCat.Angry, },
    { name="gloat",       cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="golfclap",    cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="goodbye",     cat=EmoteCat.Happy, viz=true, audio=true, fix="BYE", },
    { name="greet",       cat=EmoteCat.Happy, viz=true, },
    { name="grin",        cat=EmoteCat.Happy, },
    { name="groan",       cat=EmoteCat.Sad, },
    { name="grovel",      cat=EmoteCat.Sad, viz=true, },
    { name="growl",       cat=EmoteCat.Angry, viz=true, },
    { name="guffaw",      cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="hail",        cat=EmoteCat.Happy, viz=true, },
    { name="happy",       cat=EmoteCat.Happy, },
    { name="healme",      cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="hello",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="helpme",      cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="hi",          cat=EmoteCat.Happy, viz=true, audio=true,  fix="HELLO",},
    { name="highfive",    cat=EmoteCat.Happy, },
    { name="holdhand",    cat=EmoteCat.Happy, },
    { name="hug",         cat=EmoteCat.Happy, },
    { name="hungry",      cat=EmoteCat.Sad, },
    { name="hurry",       cat=EmoteCat.Angry, },
    { name="huzzah",      cat=EmoteCat.Happy, viz=true, },
    { name="impressed",   cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="incoming",    cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="insult",      cat=EmoteCat.Angry, viz=true, },
    { name="introduce",   cat=EmoteCat.Happy, },
    { name="jk",          cat=EmoteCat.Happy, },
    { name="kiss",        cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="kneel",       cat=EmoteCat.Neutral, viz=true, },
    { name="laugh",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="lavish",      cat=EmoteCat.Happy, fix="PRAISE", },
    { name="lay",         cat=EmoteCat.Neutral, viz=true, fix="LAYDOWN", },
    { name="lick",        cat=EmoteCat.Neutral, },
    { name="listen",      cat=EmoteCat.Neutral, },
    { name="lost",        cat=EmoteCat.Sad, viz=true, },
    { name="love",        cat=EmoteCat.Happy, },
    { name="magnificent", cat=EmoteCat.Happy, viz=true, },
    { name="massage",     cat=EmoteCat.Happy, },
    { name="meow",        cat=EmoteCat.Neutral, },
    { name="mock",        cat=EmoteCat.Angry, },
    { name="moo",         cat=EmoteCat.Neutral, },
    { name="moon",        cat=EmoteCat.Angry, },
    { name="mourn",       cat=EmoteCat.Sad, viz=true, audio=true, },
    { name="no",          cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="nod",         cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="nosepick",    cat=EmoteCat.Neutral, },
    { name="oom",         cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="openfire",    cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="panic",       cat=EmoteCat.Sad, },
    { name="pat",         cat=EmoteCat.Happy, },
    { name="peer",        cat=EmoteCat.Neutral, },
    { name="pity",        cat=EmoteCat.Sad, },
    { name="plead",       cat=EmoteCat.Sad, viz=true, },
    { name="point",       cat=EmoteCat.Combat, viz=true, },
    { name="poke",        cat=EmoteCat.Neutral, },
    { name="ponder",      cat=EmoteCat.Happy, viz=true, },
    { name="pounce",      cat=EmoteCat.Happy, },
    { name="pray",        cat=EmoteCat.Neutral, viz=true, },
    { name="purr",        cat=EmoteCat.Happy, },
    { name="puzzled",     cat=EmoteCat.Sad, viz=true, fix="PUZZLE", },
    { name="quack",       cat=EmoteCat.Neutral, viz=true, },
    { name="question",    cat=EmoteCat.Sad, viz=true, fix="xxx", fix="TALKQ", },
    { name="raise",       cat=EmoteCat.Neutral, },
    { name="rasp",        cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="ready",       cat=EmoteCat.Combat, },
    { name="regret",      cat=EmoteCat.Sad, },
    { name="roar",        cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="rofl",        cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="rolleyes",    cat=EmoteCat.Sad, },
    { name="rude",        cat=EmoteCat.Angry, viz=true, },
    { name="salute",      cat=EmoteCat.Happy, viz=true, },
    { name="scared",      cat=EmoteCat.Sad, },
    { name="scratch",     cat=EmoteCat.Neutral, },
    { name="sexy",        cat=EmoteCat.Happy, },
    { name="shimmy",      cat=EmoteCat.Neutral, },
    { name="shiver",      cat=EmoteCat.Sad, },
    { name="shoo",        cat=EmoteCat.Angry, },
    { name="shrug",       cat=EmoteCat.Neutral, viz=true, },
    { name="shy",         cat=EmoteCat.Happy, viz=true, },
    { name="sigh",        cat=EmoteCat.Sad, audio=true, },
    { name="silly",       cat=EmoteCat.Happy, viz=true, audio=true, fix="JOKE", },
    { name="slap",        cat=EmoteCat.Angry, },
    { name="sleep",       cat=EmoteCat.Sad, viz=true, },
    { name="smile",       cat=EmoteCat.Happy, },
    { name="smirk",       cat=EmoteCat.Happy, },
    { name="snarl",       cat=EmoteCat.Angry, },
    { name="snicker",     cat=EmoteCat.Happy, },
    { name="sniff",       cat=EmoteCat.Neutral, },
    { name="snub",        cat=EmoteCat.Angry, },
    { name="soothe",      cat=EmoteCat.Happy, },
    { name="spit",        cat=EmoteCat.Neutral, }, -- no longer targets players
    { name="stare",       cat=EmoteCat.Neutral, },
    { name="surprised",   cat=EmoteCat.Neutral, },
    { name="surrender",   cat=EmoteCat.Sad, viz=true, },
    { name="talk",        cat=EmoteCat.Happy, viz=true, },
    { name="tap",         cat=EmoteCat.Neutral, },
    { name="taunt",       cat=EmoteCat.Angry, },
    { name="tease",       cat=EmoteCat.Happy, },
    { name="thank",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="think",       cat=EmoteCat.Neutral, },
    { name="thirsty",     cat=EmoteCat.Sad, },
    { name="tickle",      cat=EmoteCat.Happy, },
    { name="tired",       cat=EmoteCat.Sad, },
    { name="train",       cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="veto",        cat=EmoteCat.Angry, },
    { name="victory",     cat=EmoteCat.Happy, viz=true, },
    { name="violin",      cat=EmoteCat.Angry, viz=true, audio=true, },
    { name="wait",        cat=EmoteCat.Combat, viz=true, audio=true, },
    { name="wave",        cat=EmoteCat.Happy, },
    { name="welcome",     cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="whine",       cat=EmoteCat.Sad, },
    { name="whistle",     cat=EmoteCat.Sad, audio=true, },
    { name="whoa",        cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="wince",       cat=EmoteCat.Sad, },
    { name="wink",        cat=EmoteCat.Happy, },
    { name="work",        cat=EmoteCat.Happy, },
    { name="yawn",        cat=EmoteCat.Sad, audio=true, },
    { name="yw",          cat=EmoteCat.Happy, viz=true, audio=true, },
}

--@type table<string,EmoteDefinition>
EmoteDefinitions.map = {}

for i, emote in ipairs(EmoteDefinitions.list) do
    EmoteDefinitions.map[emote.name] = EmoteDefinitions.list[i]
end

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

---@class Comparison
Comparison = {
    aBeforeB = 1,
    aSameAsB = 0,
    aAfterB = -1,
}

---@param a EmoteDefinition
---@param b EmoteDefinition
---@return Comparison
local function compare(a, b)
    if (a.audio and a.viz) and (not (b.audio and b.viz)) then
        return Comparison.aBeforeB
    elseif (not (a.audio and a.viz)) and (b.audio and b.viz) then
        return Comparison.aAfterB
    elseif a.audio and (not b.audio) then
        return Comparison.aBeforeB
    elseif (not a.audio) and b.audio then
        return Comparison.aAfterB
    elseif a.viz and (not b.viz) then
        return Comparison.aBeforeB
    elseif (not a.viz) and b.viz then
        return Comparison.aAfterB
    elseif a.name < b.name then
        return Comparison.aBeforeB
    elseif a.name > b.name then
        return Comparison.aAfterB
    else
        return Comparison.aSameAsB
    end
end

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

-- take the incoming raw list of emotes and
-- sort them into categories,
-- each of which further sort the emotes alphabetically but preferring emotes with audio and/or viz as per compare(a,b)
---@param emotes? table<number,EmoteDefinition>
---@param catOrder? EmoteCat
---@return NavNode one node whose kids array contains all emotes in a 3-level hierarchy: top; catregories; emotes;
function EmoteDefinitions:makeNavigationTree(emotes, catOrder)
    --@type NavNode
    local topNode = { level=0, kids={}, name="", searchIndexProxy=EmoteCat.Everything } -- the return value
    local flatList = {}

    -- in absence of args, set defaults
    if not emotes then
        emotes = EmoteDefinitions.list
    end
    if not catOrder then
        catOrder = EmoteCat
    end

    -- Favorites placeholder
    ---@type NavNode
    topNode.kids[EmoteCat.Favorites] = {
        id = EmoteCat.Favorites,
        level = 1,
        parentId = nil,
        kids = { },
        domainData = {
            cat = EmoteCat.Favorites,
            name = "Favorites",
            icon = EmoteIcons[EmoteCat.Favorites],
        }
    }

    ---@type table<index, NavNode>
    local lookupTable = {}

    -- go through the flat list of emotes eg. { { name="bashful", cat=EmoteCat.Happy, viz=true }, { name="bored", cat=EmoteCat.Sad, audio=true, } ... }
    -- and rearrange them into a hierarchy of { EmoteCat.Neutral = { { name="bashful", cat=EmoteCat.Happy, viz=true}, { cat=...}, ... }, EmoteCat.Sad = {{ name="bored",   ... }, ... } ... }
    for i, emoteDef in ipairs(emotes) do

        -- PARENT / CATEGORY
        -- create / fetch the parent bucket which contains all of the emotes grouped into this category (ie, "siblings")
        local parentId = emoteDef.cat
        local parentName = EmoteCatName[parentId]
        local parentNavNode = lookupTable[parentId]
        if not parentNavNode then
            zebug.info:line(40,"New Category", parentName)
            ---@type NavNode
            parentNavNode = {
                id = parentId,
                level = 1,
                parentId = nil,
                kids = { },
                domainData = {
                    cat = emoteDef.cat,
                    name = parentName,
                    icon = EmoteIcons[emoteDef.cat]  -- TODO: support custom cats
                },
            }
            topNode.kids[parentId] = parentNavNode -- stow it in the results
            lookupTable[parentId] = parentNavNode -- make it easy to find again in later loops
            zebug.trace:dumpy("parent navNode", parentNavNode)
        end
        local siblings = parentNavNode.kids

        -- EMOTE
        -- create a NavNode for the emote
        emoteDef.isEmote = true
        local navNode = self:convertToNavNode(emoteDef, parentNavNode)
        zebug.trace:print("emote", emoteDef.name, "level", navNode.level, "cat", parentName, "cat size",#siblings)
        --zebug.warn:dumpy("emote navNode", navNode)

        insertNewRow(siblings, navNode)
        insertNewRow(flatList, navNode)
    end

    topNode.kids[EmoteCat.Everything] = {
        id = EmoteCat.Everything,
        level = 1,
        parentId = nil,
        kids = flatList,
        domainData = {
            cat = EmoteCat.Everything,
            name = "Everything",
            icon = EmoteIcons[EmoteCat.Everything],
        }
    }

    return topNode
end

---@param siblings table<number,NavNode>
---@param navNode NavNode
function insertNewRow(siblings, navNode)
    -- insert the unsortedName into the correct spot in the siblings array.
    -- be optimistic and hope the original list is already sorted.
    -- in which case, each new item will follow the previous one
    -- so, search from the end of the sorted array backwards to reduce the number of loops.
    local didIt = false
    local emoteDef_A = navNode.domainData
    for i=#siblings, 1, -1 do
        local emoteDef_B = siblings[i].domainData
        local x = compare(emoteDef_A, emoteDef_B)
        if (x == Comparison.aAfterB) or (x == Comparison.aSameAsB) then
            table.insert(siblings, i+1, navNode)
            didIt = true
            break
        end
    end

    if not didIt then
        table.insert(siblings, 1, navNode)
    end
end

---@param navNode NavNode
function EmoteDefinitions:print(navNode, level)
    level = level or 0
    zebug.warn:line(level, "level",level, "id", navNode.domainData.id,  "name", navNode.domainData.name, (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",name)

    for i, kidNavNode in ipairs(navNode.kids) do
        self:print(kidNavNode, level+1)
    end
end

-- take the incoming tree list of emotes and
-- squish it into a flat array while preserving categories & order.
-- pseudo-flag: a row where name==cat is a category and not an emote
---@param navNode NavNode
---@return table<number, EmoteDefinition>
function EmoteDefinitions:flattenTreeIntoList(navNode, list)
    list = list or {}

    list[#list+1] = navNode

    for i, kidNavNode in ipairs(navNode.kids) do
        self:flattenTreeIntoList(kidNavNode, list)
    end

    return list
end

---@param emoteDef EmoteDefinition
---@param parentNavNode NavNode
---@return NavNode
function EmoteDefinitions:convertToNavNode(emoteDef, parentNavNode)
    ---@type EmoteDefinition
    local domainData = deepcopy(emoteDef,{})
    --zebug.info:print("parentNavNode.level",parentNavNode.level)
    ---@type NavNode
    local result = {
        id = "UNINITIALIZED", -- this will be replaced with an index
        name = emoteDef.name,
        parentId = parentNavNode and parentNavNode.id,
        level = (parentNavNode and parentNavNode.level and parentNavNode.level+1) or 1, -- start index at 1 - coz Lua is fun!
        isExe = true,
        domainData = domainData,
    }
    return result
end

---@param emote EmoteDefinition
function EmoteDefinitions:doEmote(emote)
    local id = emote.fix or emote.name
    zebug.info:print("name", emote.name, "fix", emote.fix)
    DoEmote(id);
end
