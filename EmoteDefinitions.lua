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
---@field alts table synonyms

---@alias DomainData EmoteDefinition

----------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

---@type table<number, EmoteDefinition>
EmoteDefinitions.list = {
    { name="agree",        cat=EmoteCat.Happy,   },
    { name="amaze",        cat=EmoteCat.Happy,   },
    { name="angry",        cat=EmoteCat.Angry,   viz=true, alts={"mad"}, },
    { name="apologize",    cat=EmoteCat.Sad,     audio=true, alts={"sorry"}, },
    { name="applaud",      cat=EmoteCat.Happy,   viz=true, audio=true, alts={"bravo", "applause"}, },
    { name="arm",          cat=EmoteCat.Happy,   alts={"stretch"},  }, -- custom alt
    { name="attacktarget", cat=EmoteCat.Combat , viz=true, audio=true, fix="attackmytarget", },
    { name="awe",          cat=EmoteCat.Happy,   },
    { name="backpack",     cat=EmoteCat.Neutral, alts={"pack"}, },
    { name="badfeeling",   cat=EmoteCat.Sad,     alts={"bad"}, },
    { name="bark",         cat=EmoteCat.Neutral, },
    { name="bashful",      cat=EmoteCat.Happy,   viz=true, },
    { name="beckon",       cat=EmoteCat.Happy,   },
    { name="beg",          cat=EmoteCat.Sad,     viz=true, audio=true, },
    { name="bite",         cat=EmoteCat.Angry,   },
    { name="blame",        cat=EmoteCat.Angry,   viz=true, },
    { name="blank",        cat=EmoteCat.Neutral, },
    { name="bleed",        cat=EmoteCat.Sad,     alts={"blood"}, },
    { name="blink",        cat=EmoteCat.Neutral, },
    { name="blush",        cat=EmoteCat.Happy,   viz=true, },
    { name="boggle",       cat=EmoteCat.Happy,   viz=true, },
    { name="bonk",         cat=EmoteCat.Angry,   alts={"doh"}, },
    { name="boop",         cat=EmoteCat.Happy,   viz=true, },
    { name="bored",        cat=EmoteCat.Sad,     audio=true, },
    { name="bounce",       cat=EmoteCat.Happy,   },
    { name="bow",          cat=EmoteCat.Happy,   viz=true, },
    { name="brandish",     cat=EmoteCat.Angry,   },
    { name="brb",          cat=EmoteCat.Neutral, },
    { name="breath",       cat=EmoteCat.Neutral, },
    { name="burp",         cat=EmoteCat.Neutral, alts={"belch"}, },
    { name="bye",          cat=EmoteCat.Happy,   viz=true, audio=true, alts={"goodbye", "farewell"}, },
    { name="cackle",       cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="calm",         cat=EmoteCat.Neutral, },
    { name="challenge",    cat=EmoteCat.Angry,   },
    { name="charge",       cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="charm",        cat=EmoteCat.Happy,   },
    { name="cheer",        cat=EmoteCat.Happy,   viz=true, audio=true, alts={"woot"}, },
    { name="chicken",      cat=EmoteCat.Angry,   viz=true, audio=true, alts={"flap", "strut"}, },
    { name="chuckle",      cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="chug",         cat=EmoteCat.Happy,   },
    { name="clap",         cat=EmoteCat.Happy,   viz=true, },
    { name="cold",         cat=EmoteCat.Sad,     },
    { name="comfort",      cat=EmoteCat.Happy,   },
    { name="commend",      cat=EmoteCat.Happy,   viz=true, },
    { name="confused",     cat=EmoteCat.Sad,     viz=true, },
    { name="congratulate", cat=EmoteCat.Happy,   viz=true, audio=true, alts={"congrats", "grats"}, },
    { name="cough",        cat=EmoteCat.Sad,     },
    { name="coverears",    cat=EmoteCat.Angry,   },
    { name="cower",        cat=EmoteCat.Sad,     viz=true, alts={"fear"}, },
    { name="crack",        cat=EmoteCat.Angry,   alts={"knuckles"}, },
    { name="cringe",       cat=EmoteCat.Sad,     },
    { name="crossarms",    cat=EmoteCat.Angry,   },
    { name="cry",          cat=EmoteCat.Sad,     viz=true, audio=true, alts={"sob", "weep"}, },
    { name="cuddle",       cat=EmoteCat.Happy,   alts={"spoon"}, },
    { name="curious",      cat=EmoteCat.Neutral, viz=true, },
    { name="curtsey",      cat=EmoteCat.Happy,   viz=true, },
    { name="dance",        cat=EmoteCat.Happy,   viz=true, },
    { name="ding",         cat=EmoteCat.Happy,   },
    { name="disagree",     cat=EmoteCat.Angry,   viz=true, },
    { name="threaten",     cat=EmoteCat.Angry,   audio=true,  alts={"doom", "threat", "wrath"}, },
    { name="doubt",        cat=EmoteCat.Angry,   viz=true, },
    { name="drink",        cat=EmoteCat.Happy,   viz=true, audio=true, alts={"shindig"}, },
    { name="drool",        cat=EmoteCat.Sad,     },
    { name="duck",         cat=EmoteCat.Sad,     },
    { name="eat",          cat=EmoteCat.Sad,     viz=true, audio=true, alts={"chew", "feast"}, },
    { name="embarrass",    cat=EmoteCat.Sad,     },
    { name="encourage",    cat=EmoteCat.Happy,   },
    { name="enemy",        cat=EmoteCat.Angry,   },
    { name="eye",          cat=EmoteCat.Neutral, },
    { name="eyebrow",      cat=EmoteCat.Neutral, alts={"brow"}, },
    { name="facepalm",     cat=EmoteCat.Sad,     alts={"palm"}, },
    { name="fail",         cat=EmoteCat.Sad,     viz=true, },
    { name="faint",        cat=EmoteCat.Sad,     },
    { name="fart",         cat=EmoteCat.Neutral, },
    { name="fidget",       cat=EmoteCat.Sad,     alts={"impatient"}, },
    { name="flee",         cat=EmoteCat.Combat,  viz=true, audio=true, alts={"retreat"}, },
    { name="flex",         cat=EmoteCat.Happy,   viz=true, alts={"strong"}, },
    { name="flirt",        cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="flop",         cat=EmoteCat.Sad,     },
    { name="followme",     cat=EmoteCat.Combat,  viz=true, audio=true, fix="FOLLOW", },
    { name="forthealliance", cat=EmoteCat.Happy, viz=true, audio=true, },
    { name="forthehorde",  cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="frown",        cat=EmoteCat.Angry,   alts={"disappointed"}, },
    { name="gasp",         cat=EmoteCat.Happy,   viz=true, },
    { name="gaze",         cat=EmoteCat.Neutral, },
    { name="giggle",       cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="glare",        cat=EmoteCat.Angry,   },
    { name="gloat",        cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="glower",       cat=EmoteCat.Angry,   },
    { name="go",           cat=EmoteCat.Neutral, },
    { name="going",        cat=EmoteCat.Neutral, },
    { name="golfclap",     cat=EmoteCat.Angry,   viz=true, },
    { name="greet",        cat=EmoteCat.Happy,   viz=true, alts={"greetings"}, },
    { name="grin",         cat=EmoteCat.Happy,   alts={"wicked", "wickedly"}, },
    { name="groan",        cat=EmoteCat.Sad,     },
    { name="grovel",       cat=EmoteCat.Sad,     viz=true, alts={"peon"}, },
    { name="growl",        cat=EmoteCat.Angry,   viz=true, },
    { name="guffaw",       cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="hail",         cat=EmoteCat.Happy,   viz=true, },
    { name="happy",        cat=EmoteCat.Happy,   alts={"glad", "yay"}, },
    { name="headache",     cat=EmoteCat.Sad,     },
    { name="healme",       cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="hello",        cat=EmoteCat.Happy,   viz=true, audio=true, alts={"hi"}, },
    { name="helpme",       cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="hiccup",       cat=EmoteCat.Neutral, },
    { name="highfive",     cat=EmoteCat.Happy,   },
    { name="hiss",         cat=EmoteCat.Angry,   },
    { name="holdhand",     cat=EmoteCat.Happy,   },
    { name="hug",          cat=EmoteCat.Happy,   },
    { name="hungry",       cat=EmoteCat.Sad,     alts={"food", "pizza"}, },
    { name="hurry",        cat=EmoteCat.Angry,   },
    { name="huzzah",       cat=EmoteCat.Happy,   viz=true, },
    { name="idea",         cat=EmoteCat.Happy,   },
    { name="impressed",    cat=EmoteCat.Happy,   viz=true, },
    { name="incoming",     cat=EmoteCat.Combat,  viz=true, audio=true, alts={"inc"}, },
    { name="insult",       cat=EmoteCat.Angry,   viz=true, },
    { name="introduce",    cat=EmoteCat.Happy,   },
    { name="jealous",      cat=EmoteCat.Angry,   },
    { name="jk",           cat=EmoteCat.Happy,   },
    { name="joke",         cat=EmoteCat.Happy,   viz=true, audio=true, alts={"silly"},  },
    { name="kiss",         cat=EmoteCat.Happy,   viz=true, audio=true, alts={"blow"}, },
    { name="kneel",        cat=EmoteCat.Neutral, viz=true, },
    { name="laugh",        cat=EmoteCat.Happy,   viz=true, audio=true, alts={"lol"}, },
    { name="laydown",      cat=EmoteCat.Neutral, viz=true,  alts={"liedown", "lay", "lie"}, },
    { name="lick",         cat=EmoteCat.Neutral, },
    { name="listen",       cat=EmoteCat.Neutral, },
    { name="look",         cat=EmoteCat.Neutral, },
    { name="lost",         cat=EmoteCat.Sad,     viz=true, },
    { name="love",         cat=EmoteCat.Happy,   },
    { name="magnificent",  cat=EmoteCat.Happy,   viz=true, },
    { name="map",          cat=EmoteCat.Neutral, },
    { name="massage",      cat=EmoteCat.Happy,   },
    { name="meow",         cat=EmoteCat.Neutral, },
    { name="mercy",        cat=EmoteCat.Sad,    viz=true, },
    { name="moan",         cat=EmoteCat.Happy,   },
    { name="mock",         cat=EmoteCat.Angry,   },
    { name="moo",          cat=EmoteCat.Neutral, },
    { name="moon",         cat=EmoteCat.Angry,   },
    { name="mountspecial", cat=EmoteCat.Neutral, viz=true, },
    { name="mourn",        cat=EmoteCat.Sad,     viz=true, audio=true, },
    { name="mutter",       cat=EmoteCat.Neutral, },
    { name="nervous",      cat=EmoteCat.Sad,     },
    { name="no",           cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="nod",          cat=EmoteCat.Happy,   viz=true, audio=true, alts={"yes"}, },
    { name="nosepick",     cat=EmoteCat.Neutral, alts={"pick"}, },
    { name="object",       cat=EmoteCat.Angry,   viz=true, alts={"objection", "holdit"}, },
    { name="offer",        cat=EmoteCat.Happy,   },
    { name="oom",          cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="oops",         cat=EmoteCat.Sad,     viz=true, audio=true, },
    { name="openfire",     cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="panic",        cat=EmoteCat.Sad,     },
    { name="pat",          cat=EmoteCat.Happy,   },
    { name="peer",         cat=EmoteCat.Neutral, },
    { name="pet",          cat=EmoteCat.Happy,   },
    { name="pinch",        cat=EmoteCat.Angry,   },
    { name="pity",         cat=EmoteCat.Sad,     },
    { name="plead",        cat=EmoteCat.Sad,     viz=true, },
    { name="point",        cat=EmoteCat.Combat,  viz=true, },
    { name="poke",         cat=EmoteCat.Neutral, },
    { name="ponder",       cat=EmoteCat.Happy,   viz=true, },
    { name="pounce",       cat=EmoteCat.Happy,   },
    { name="pout",         cat=EmoteCat.Sad,     },
    { name="praise",       cat=EmoteCat.Happy,   alts={"lavish"}, },
    { name="pray",         cat=EmoteCat.Neutral, viz=true, },
    { name="promise",      cat=EmoteCat.Happy,   },
    { name="proud",        cat=EmoteCat.Happy,   },
    { name="pulse",        cat=EmoteCat.Neutral, },
    { name="punch",        cat=EmoteCat.Angry,   },
    { name="purr",         cat=EmoteCat.Happy,   },
    { name="puzzle",       cat=EmoteCat.Sad,     viz=true, --[[alts={"puzzled"},]] },
    { name="quack",        cat=EmoteCat.Neutral, viz=true, },
    { name="raise",        cat=EmoteCat.Neutral, alts={"volunteer"}, },
    { name="rasp",         cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="read",         cat=EmoteCat.Neutral, viz=true, },
    { name="ready",        cat=EmoteCat.Combat,  alts={"rdy"}, },
    { name="regret",       cat=EmoteCat.Sad,     },
    { name="revenge",      cat=EmoteCat.Angry,   },
    { name="roar",         cat=EmoteCat.Angry,   viz=true, audio=true, alts={"rawr"}, },
    { name="rofl",         cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="rolleyes",     cat=EmoteCat.Sad,     alts={"eyeroll"}, },
    { name="rude",         cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="ruffle",       cat=EmoteCat.Sad,     },
    { name="sad",          cat=EmoteCat.Sad,     },
    { name="salute",       cat=EmoteCat.Happy,   viz=true, },
    { name="scared",       cat=EmoteCat.Sad,     viz=true, },
    { name="scoff",        cat=EmoteCat.Angry,   },
    { name="scold",        cat=EmoteCat.Angry,   },
    { name="scowl",        cat=EmoteCat.Angry,   },
    { name="scratch",      cat=EmoteCat.Neutral, alts={"cat", "catty"}, },
    { name="search",       cat=EmoteCat.Neutral, },
    { name="serious",       cat=EmoteCat.Neutral, },
    { name="sexy",         cat=EmoteCat.Happy,   },
    { name="shake",        cat=EmoteCat.Angry,   alts={"rear"}, },
    { name="shakefist",    cat=EmoteCat.Angry,   alts={"fist"}, },
    { name="shifty",       cat=EmoteCat.Neutral, },
    { name="shimmy",       cat=EmoteCat.Neutral, },
    { name="shiver",       cat=EmoteCat.Sad,     },
    { name="shoo",         cat=EmoteCat.Angry,   alts={"pest"}, },
    { name="shout",        cat=EmoteCat.Happy, viz=true, alts={"holler"}, },
    { name="shrug",        cat=EmoteCat.Neutral, viz=true, },
    { name="shudder",      cat=EmoteCat.Sad,     },
    { name="shy",          cat=EmoteCat.Happy,   viz=true, },
    { name="sigh",         cat=EmoteCat.Sad,     audio=true, },
    { name="signal",       cat=EmoteCat.Neutral, },
    { name="silence",      cat=EmoteCat.Neutral, alts={"shush"}, },
    { name="sing",         cat=EmoteCat.Happy,   viz=true, },
    { name="sit",          cat=EmoteCat.Neutral, viz=true, },
    { name="slap",         cat=EmoteCat.Angry,   },
    { name="sleep",        cat=EmoteCat.Sad,     viz=true, },
    { name="smack",        cat=EmoteCat.Angry,   },
    { name="smile",        cat=EmoteCat.Happy,   },
    { name="smirk",        cat=EmoteCat.Happy,   },
    { name="snap",         cat=EmoteCat.Neutral, },
    { name="snarl",        cat=EmoteCat.Angry,   },
    { name="sneak",        cat=EmoteCat.Neutral, },
    { name="sneeze",       cat=EmoteCat.Neutral, },
    { name="snicker",      cat=EmoteCat.Happy,   },
    { name="sniff",        cat=EmoteCat.Neutral, viz=true, },
    { name="snort",        cat=EmoteCat.Angry,   },
    { name="snub",         cat=EmoteCat.Angry,   },
    { name="soothe",       cat=EmoteCat.Happy,   },
    { name="spit",         cat=EmoteCat.Neutral, },
    { name="squeal",       cat=EmoteCat.Happy,   },
    { name="stand",        cat=EmoteCat.Neutral, viz=true, },
    { name="stare",        cat=EmoteCat.Neutral, },
    { name="stink",        cat=EmoteCat.Neutral, alts={"smell"}, },
    { name="stopattack",   cat=EmoteCat.Combat,  },
    { name="surprised",    cat=EmoteCat.Neutral, },
    { name="surrender",    cat=EmoteCat.Sad,     viz=true, },
    { name="suspicious",   cat=EmoteCat.Neutral, },
    { name="sweat",        cat=EmoteCat.Neutral, },
    { name="talk",         cat=EmoteCat.Happy,   viz=true, },
    { name="talkex",       cat=EmoteCat.Happy, viz=true, alts={"excited"}, },
    { name="talkq",        cat=EmoteCat.Neutral, viz=true, alts={"question"}, },
    { name="tap",          cat=EmoteCat.Neutral, },
    { name="taunt",        cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="tease",        cat=EmoteCat.Happy,   },
    { name="thank",        cat=EmoteCat.Happy,   viz=true, audio=true, alts={"thanks", "ty"}, },
    { name="think",        cat=EmoteCat.Neutral, },
    { name="thirsty",      cat=EmoteCat.Sad,     },
    { name="tickle",       cat=EmoteCat.Happy,   },
    { name="tired",        cat=EmoteCat.Sad,     },
    { name="train",        cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="truce",        cat=EmoteCat.Happy  , },
    { name="twiddle",      cat=EmoteCat.Sad,     },
    { name="veto",         cat=EmoteCat.Angry,   },
    { name="victory",      cat=EmoteCat.Happy,   viz=true, },
    { name="violin",       cat=EmoteCat.Angry,   viz=true, audio=true, },
    { name="wait",         cat=EmoteCat.Combat,  viz=true, audio=true, },
    { name="warn",         cat=EmoteCat.Neutral, },
    { name="wave",         cat=EmoteCat.Happy,   viz=true, },
    { name="welcome",      cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="whine",        cat=EmoteCat.Sad,     },
    { name="whistle",      cat=EmoteCat.Happy,   audio=true, },
    { name="whoa",         cat=EmoteCat.Happy,   viz=true, audio=true, },
    { name="wince",        cat=EmoteCat.Sad,     },
    { name="wink",         cat=EmoteCat.Happy,   },
    { name="work",         cat=EmoteCat.Happy,   },
    { name="yawn",         cat=EmoteCat.Sad,     audio=true, },
    { name="yw",           cat=EmoteCat.Happy,   viz=true, audio=true, alts={"yourewelcome"}, }, -- I made up this alt coz "yw" ? really?
}

--@type table<string,EmoteDefinition>
EmoteDefinitions.map = {}

for i, emote in ipairs(EmoteDefinitions.list) do
    EmoteDefinitions.map[emote.name] = emote

    -- expand the alts into their own rows
    if emote.alts then
        for j, altName in ipairs(emote.alts) do
            local copy = deepcopy(emote)
            if not copy.fix then
                copy.fix = emote.name -- the original emote
            end
            copy.name = altName
            EmoteDefinitions.map[altName] = copy
        end
    end
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
        local navNodes = { self:convertToNavNode(emoteDef, parentNavNode) }

        for i, navNode in ipairs(navNodes) do
            zebug.trace:print("emote", navNode.name, "level", navNodes[1].level, "cat", parentName, "cat size",#siblings)
            --zebug.warn:dumpy("emote navNode", navNode)
            insertNewRow(siblings, navNode)
            insertNewRow(flatList, navNode)
        end
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
    -- expand the alts into their own rows
    if emoteDef.alts then
        local results = { result }
        for j, altName in ipairs(emoteDef.alts) do
            local emoteCopy = deepcopy(emoteDef)
            if not emoteCopy.fix then
                emoteCopy.fix = emoteDef.name -- the original emote
            end
            emoteCopy.name = altName
            local nodeCopy = deepcopy(result)
            nodeCopy.name = altName
            nodeCopy.domainData = emoteCopy
            results[#results+1] = nodeCopy
        end
        return unpack(results)
    else
        return result
    end
end

---@param emote EmoteDefinition
function EmoteDefinitions:doEmote(emote)
    local id = emote.fix or emote.name
    zebug.info:print("name", emote.name, "fix", emote.fix)
    DoEmote(id);
end
