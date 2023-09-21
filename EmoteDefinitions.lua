-- EmoteDefinitions.lua
-- list of all emotes.  Thanks EmoteLDB !

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the Totes object
L10N = Totes.L10N

---@class EmoteDefinitions
EmoteDefinitions = {}

---@class EmoteCat
EmoteCat = {
    Happy   = 1,
    Angry   = 2,
    Sad     = 3,
    Neutral = 4,
    Combat  = 5,
}

---@enum EmoteCatDef
EmoteCatDef = {
    [EmoteCat.Happy  ] = { icon=237554 },
    [EmoteCat.Angry  ] = { icon=237553 },
    [EmoteCat.Sad    ] = { icon=237555 },
    [EmoteCat.Neutral] = { icon=237552 },
    [EmoteCat.Combat ] = { icon=132147 }, -- 132147:swords, 458724:target,
}

---@type table<number,string>
EmoteCatName = {}
for name, i in pairs(EmoteCat) do
    EmoteCatName[i] = name
end

---@class EmoteDefinition
---@field name string a copy of the emote's key/name - this is populated dynamically while sorting the defs
---@field cat EmoteCat category
---@field audio boolean includes audible vocalization
---@field viz boolean includes visual animation
---@field fix string some emotes break the Bliz API because of course they do.  This field is a synonym that works instead.

---@class EmoteTree
---@field catGroup table<EmoteCat,table<number,EmoteDefinition>> -- ex. 1<Happy> -> { 1 -> {name="applaud", viz=true, audio=true}, agree -> {} }, Sad -> ... }

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

---@type table<number, EmoteDefinition>
EmoteDefinitions.defaults = {
    agree     = { cat=EmoteCat.Happy, },
    amaze     = { cat=EmoteCat.Happy, },
    angry     = { cat=EmoteCat.Angry, viz=true, },
    apologize = { cat=EmoteCat.Sad, },
    applaud   = { cat=EmoteCat.Happy, viz=true, audio=true, },
    arm       = { cat=EmoteCat.Happy, },
    attacktarget = { cat=EmoteCat.Combat, viz=true, audio=true, fix="ATTACKMYTARGET", },
    bark      = { cat=EmoteCat.Neutral, },
    bashful   = { cat=EmoteCat.Happy, viz=true, },
    beckon    = { cat=EmoteCat.Happy, },
    beg       = { cat=EmoteCat.Sad, viz=true, },
    belch     = { cat=EmoteCat.Neutral, fix="BURP", },
    bite      = { cat=EmoteCat.Angry, },
    bleed     = { cat=EmoteCat.Sad, },
    blink     = { cat=EmoteCat.Neutral, },
    blush     = { cat=EmoteCat.Happy, viz=true, },
    boggle    = { cat=EmoteCat.Happy, viz=true, },
    bonk      = { cat=EmoteCat.Angry, },
    boop      = { cat=EmoteCat.Happy, viz=true, },
    bored     = { cat=EmoteCat.Sad, audio=true, },
    bounce    = { cat=EmoteCat.Happy, },
    bow       = { cat=EmoteCat.Happy, viz=true, },
    brandish  = { cat=EmoteCat.Angry, },
    brb       = { cat=EmoteCat.Neutral, },
    cackle    = { cat=EmoteCat.Happy, viz=true, audio=true, },
    calm      = { cat=EmoteCat.Neutral, },
    charge    = { cat=EmoteCat.Combat, viz=true, audio=true, },
    cheer     = { cat=EmoteCat.Happy, viz=true, audio=true, },
    chicken   = { cat=EmoteCat.Angry, viz=true, audio=true, },
    chuckle   = { cat=EmoteCat.Happy, viz=true, audio=true, },
    clap      = { cat=EmoteCat.Happy, viz=true, audio=true, },
    cold      = { cat=EmoteCat.Sad, },
    comfort   = { cat=EmoteCat.Happy, },
    commend   = { cat=EmoteCat.Happy, viz=true, audio=true, },
    confused  = { cat=EmoteCat.Sad, viz=true, },
    congrats  = { cat=EmoteCat.Happy, viz=true, audio=true, fix="CONGRATULATE", },
    cough     = { cat=EmoteCat.Sad, },
    cower     = { cat=EmoteCat.Sad, },
    crack     = { cat=EmoteCat.Angry, },
    cringe    = { cat=EmoteCat.Sad, },
    cry       = { cat=EmoteCat.Angry, viz=true, audio=true, },
    cuddle    = { cat=EmoteCat.Happy, },
    curious   = { cat=EmoteCat.Neutral, viz=true, },
    curtsey   = { cat=EmoteCat.Happy, viz=true, },
    dance     = { cat=EmoteCat.Happy, viz=true, },
    ding      = { cat=EmoteCat.Happy, },
    doom      = { cat=EmoteCat.Angry, audio=true, fix="THREATEN", },
    drink     = { cat=EmoteCat.Happy, viz=true, },
    drool     = { cat=EmoteCat.Sad, },
    duck      = { cat=EmoteCat.Sad, },
    eat       = { cat=EmoteCat.Sad, viz=true, },
    excited   = { cat=EmoteCat.Happy, viz=true, fix="TALKEX", },
    eye       = { cat=EmoteCat.Neutral, },
    facepalm  = { cat=EmoteCat.Sad, },
    fart      = { cat=EmoteCat.Neutral, }, -- no longer targets players
    fidget    = { cat=EmoteCat.Sad, },
    flee      = { cat=EmoteCat.Combat, viz=true, audio=true, },
    flex      = { cat=EmoteCat.Happy, viz=true, },
    flirt     = { cat=EmoteCat.Happy, viz=true, audio=true, },
    flop      = { cat=EmoteCat.Sad, },
    followme  = { cat=EmoteCat.Combat, viz=true, audio=true, fix="FOLLOW", },
    frown     = { cat=EmoteCat.Angry, },
    gasp      = { cat=EmoteCat.Happy, viz=true, },
    gaze      = { cat=EmoteCat.Neutral, },
    giggle    = { cat=EmoteCat.Happy, viz=true, audio=true, },
    glare     = { cat=EmoteCat.Angry, },
    gloat     = { cat=EmoteCat.Angry, viz=true, audio=true, },
    golfclap  = { cat=EmoteCat.Angry, viz=true, audio=true, },
    goodbye   = { cat=EmoteCat.Happy, viz=true, audio=true, fix="BYE", },
    greet     = { cat=EmoteCat.Happy, viz=true, },
    grin      = { cat=EmoteCat.Happy, },
    groan     = { cat=EmoteCat.Sad, },
    grovel    = { cat=EmoteCat.Sad, viz=true, },
    growl     = { cat=EmoteCat.Angry, viz=true, },
    guffaw    = { cat=EmoteCat.Happy, viz=true, audio=true, },
    hail      = { cat=EmoteCat.Happy, viz=true, },
    happy     = { cat=EmoteCat.Happy, },
    healme    = { cat=EmoteCat.Combat, viz=true, audio=true, },
    hello     = { cat=EmoteCat.Happy, viz=true, audio=true, },
    helpme    = { cat=EmoteCat.Combat, viz=true, audio=true, },
    highfive  = { cat=EmoteCat.Happy, },
    holdhand  = { cat=EmoteCat.Happy, },
    hug       = { cat=EmoteCat.Happy, },
    hungry    = { cat=EmoteCat.Sad, },
    huzzah    = { cat=EmoteCat.Happy, viz=true, },
    impressed = { cat=EmoteCat.Happy, viz=true, audio=true, },
    incoming  = { cat=EmoteCat.Combat, viz=true, audio=true, },
    insult    = { cat=EmoteCat.Angry, viz=true, },
    introduce = { cat=EmoteCat.Happy, },
    jk        = { cat=EmoteCat.Happy, },
    kiss      = { cat=EmoteCat.Happy, viz=true, audio=true, },
    kneel     = { cat=EmoteCat.Neutral, viz=true, },
    laugh     = { cat=EmoteCat.Happy, viz=true, audio=true, },
    lavish    = { cat=EmoteCat.Happy, fix="PRAISE", },
    lay       = { cat=EmoteCat.Neutral, viz=true, fix="LAYDOWN", },
    lick      = { cat=EmoteCat.Neutral, },
    listen    = { cat=EmoteCat.Neutral, },
    lost      = { cat=EmoteCat.Sad, viz=true, },
    love      = { cat=EmoteCat.Happy, },
    magnificent = { cat=EmoteCat.Happy, viz=true, },
    massage   = { cat=EmoteCat.Happy, },
    meow      = { cat=EmoteCat.Neutral, },
    mock      = { cat=EmoteCat.Angry, },
    moo       = { cat=EmoteCat.Neutral, },
    moon      = { cat=EmoteCat.Angry, },
    mourn     = { cat=EmoteCat.Sad, viz=true, audio=true, },
    no        = { cat=EmoteCat.Angry, viz=true, audio=true, },
    nod       = { cat=EmoteCat.Happy, viz=true, audio=true, },
    nosepick  = { cat=EmoteCat.Neutral, },
    oom       = { cat=EmoteCat.Combat, viz=true, audio=true, },
    openfire  = { cat=EmoteCat.Combat, viz=true, audio=true, },
    panic     = { cat=EmoteCat.Sad, },
    pat       = { cat=EmoteCat.Happy, },
    peer      = { cat=EmoteCat.Neutral, },
    pity      = { cat=EmoteCat.Sad, },
    plead     = { cat=EmoteCat.Sad, viz=true, },
    point     = { cat=EmoteCat.Combat, viz=true, },
    poke      = { cat=EmoteCat.Neutral, },
    ponder    = { cat=EmoteCat.Happy, viz=true, },
    pounce    = { cat=EmoteCat.Happy, },
    pray      = { cat=EmoteCat.Neutral, viz=true, },
    purr      = { cat=EmoteCat.Happy, },
    puzzled   = { cat=EmoteCat.Sad, viz=true, fix="PUZZLE", },
    quack     = { cat=EmoteCat.Neutral, viz=true, },
    question  = { cat=EmoteCat.Sad, viz=true, fix="xxx", fix="TALKQ", },
    raise     = { cat=EmoteCat.Neutral, },
    rasp      = { cat=EmoteCat.Angry, viz=true, audio=true, },
    ready     = { cat=EmoteCat.Combat, },
    regret    = { cat=EmoteCat.Sad, },
    roar      = { cat=EmoteCat.Angry, viz=true, audio=true, },
    rofl      = { cat=EmoteCat.Happy, viz=true, audio=true, },
    rolleyes  = { cat=EmoteCat.Sad, viz=true, },
    rude      = { cat=EmoteCat.Angry, viz=true, },
    salute    = { cat=EmoteCat.Happy, viz=true, },
    scared    = { cat=EmoteCat.Sad, },
    scratch   = { cat=EmoteCat.Neutral, },
    sexy      = { cat=EmoteCat.Happy, },
    shimmy    = { cat=EmoteCat.Neutral, },
    shiver    = { cat=EmoteCat.Sad, },
    shoo      = { cat=EmoteCat.Angry, },
    shrug     = { cat=EmoteCat.Neutral, viz=true, },
    shy       = { cat=EmoteCat.Happy, viz=true, },
    sigh      = { cat=EmoteCat.Sad, audio=true, },
    silly     = { cat=EmoteCat.Happy, viz=true, audio=true, fix="JOKE", },
    slap      = { cat=EmoteCat.Angry, },
    sleep     = { cat=EmoteCat.Sad, viz=true, },
    smile     = { cat=EmoteCat.Happy, },
    smirk     = { cat=EmoteCat.Happy, },
    snarl     = { cat=EmoteCat.Angry, },
    snicker   = { cat=EmoteCat.Happy, },
    sniff     = { cat=EmoteCat.Neutral, },
    snub      = { cat=EmoteCat.Angry, },
    soothe    = { cat=EmoteCat.Happy, },
    spit      = { cat=EmoteCat.Neutral, }, -- no longer targets players
    stare     = { cat=EmoteCat.Neutral, },
    surprised = { cat=EmoteCat.Neutral, },
    surrender = { cat=EmoteCat.Sad, viz=true, },
    talk      = { cat=EmoteCat.Happy, viz=true, },
    tap       = { cat=EmoteCat.Neutral, },
    taunt     = { cat=EmoteCat.Angry, },
    tease     = { cat=EmoteCat.Happy, },
    thank     = { cat=EmoteCat.Happy, },
    think     = { cat=EmoteCat.Neutral, },
    thirsty   = { cat=EmoteCat.Sad, },
    tickle    = { cat=EmoteCat.Happy, },
    tired     = { cat=EmoteCat.Sad, },
    train     = { cat=EmoteCat.Happy, viz=true, audio=true, },
    veto      = { cat=EmoteCat.Angry, },
    victory   = { cat=EmoteCat.Happy, viz=true, },
    violin    = { cat=EmoteCat.Angry, viz=true, audio=true, },
    wait      = { cat=EmoteCat.Combat, viz=true, audio=true, },
    wave      = { cat=EmoteCat.Happy, },
    welcome   = { cat=EmoteCat.Happy, viz=true, audio=true, },
    whine     = { cat=EmoteCat.Sad, },
    whistle   = { cat=EmoteCat.Sad, audio=true, },
    whoa      = { cat=EmoteCat.Happy, viz=true, audio=true, },
    wince     = { cat=EmoteCat.Sad, },
    wink      = { cat=EmoteCat.Happy, },
    work      = { cat=EmoteCat.Happy, },
    yawn      = { cat=EmoteCat.Sad, audio=true, },
    yw        = { cat=EmoteCat.Happy, viz=true, audio=true, },
}

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
-- each of which further sort the emotes alphabetically but preferring emotes with Audio and/or Viz
---@param emotes table<string,EmoteDefinition>
---@param catOrder EmoteCat
---@return EmoteTree
function EmoteDefinitions:makeCategorizedTree(emotes, catOrder)
    local tree = {} -- emoteNamesSortedIntoCategoryAndThenByNamePlusAV

    if not emotes then
        emotes = self.defaults
    end
    if not catOrder then
        catOrder = EmoteCat
    end

    for unsortedName, emoteDef in pairs(emotes) do
        local cat = emoteDef.cat
        emoteDef.name = unsortedName

        -- initialize a bucket for the category to hold the names of its emotes
        if not tree[cat] then
            tree[cat] = { unsortedName }
        else
            local listOfEmoteNames = tree[cat]
            -- insert the unsortedName into the correct spot in the listOfEmoteNames array.
            -- be optimistic and hope the original list is already sorted.
            -- in which case, each new item will follow the previous one
            -- so, search from the end of the sorted array backwards to reduce the number of loops.
            local didIt = false
            for i=#listOfEmoteNames, 1, -1 do
                local emoteNameB = listOfEmoteNames[i]
                local emoteDefB = emotes[emoteNameB]
                local x = compare(emoteDef, emoteDefB)
                if (x == Comparison.aAfterB) or (x == Comparison.aSameAsB) then
                    table.insert(listOfEmoteNames, i+1, unsortedName)
                    didIt = true
                    break
                end
            end
            if not didIt then
                table.insert(listOfEmoteNames, 1, unsortedName)
            end
        end
    end

    return tree
end

---@param emotesTree EmoteTree
function EmoteDefinitions:print(emotesTree)
    for catIndex, emotes in ipairs(emotesTree) do
        zebug.error:line(20, "cat", EmoteCatName[catIndex])
        for i, name in ipairs(emotes) do
            ---@type EmoteDefinition
            local emote = EmoteDefinitions.defaults[name]
            zebug.warn:print("i",i, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",name)
        end
    end
end


-- take the incoming tree list of emotes and
-- squish it into a flat array while preserving categories & order.
-- pseudo-flag: a row where name==cat is a category and not an emote
---@param emotesTree EmoteTree
---@return table<number, EmoteDefinition>
function EmoteDefinitions:flattenTreeIntoList(emotesTree)
    local list = {}

    ---@param emoteCat EmoteCat
    ---@param emotes table<number,string>
    for emoteCat, emotes in ipairs(emotesTree) do
        --zebug.error:line(20, "cat", EmoteCatName[emoteCat])
        list[#list+1] = { name=emoteCat, cat=emoteCat }
        for i, name in ipairs(emotes) do
            ---@type EmoteDefinition
            local emote = EmoteDefinitions.defaults[name]
            --zebug.warn:print("i",i, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",name)
            list[#list+1] = emote
        end
    end

    return list
end

---@param emote EmoteDefinition
function EmoteDefinitions:isCat(emote)
    return emote.name == emote.cat
end


---@param emote EmoteDefinition
function EmoteDefinitions:doEmote(emote)
    local id = emote.fix or emote.name
    zebug.error:print("name", emote.name, "fix", emote.fix)
    DoEmote(id);
end
