-- TotesEmotes.lua
-- addon lifecycle methods, coordination between submodules, etc.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@class TotesEmotes -- IntelliJ-EmmyLua annotation
---@field myTitle string Totes.toc Title
local ADDON_NAME, Totes = ...
Totes.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the Totes object
zebug = Zebug:new(Zebug.OUTPUT.WARN)

-- Purely to satisfy my IDE
DB = Totes.DB
L10N = Totes.L10N

---@alias index number
---@alias key string

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

local isTotesInitialized = false
local hasShitCalmedTheFuckDown = false

-------------------------------------------------------------------------------
-- Event Handlers
-------------------------------------------------------------------------------

local EventHandlers = { }

function EventHandlers:PLAYER_LOGIN()
    zebug.trace:name("EventHandlers:PLAYER_LOGIN"):print("handling")
    local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
    local msg = L10N.LOADED .. " v"..version
    msgUser(msg)
end

function EventHandlers:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    zebug.trace:name("EventHandlers:PLAYER_LOGIN"):print("isInitialLogin",isInitialLogin, "isReloadingUi",isReloadingUi)
    initalizeAddonStuff()
end

-------------------------------------------------------------------------------
-- Bliz's AddonCompartment Global Functions
-------------------------------------------------------------------------------

---@param mouseClick MouseClick
function GLOBAL_TOTES_AddonCompartment_OnClick(addonName, mouseClick)
    zebug.trace:print("addonName",addonName, "mouseClick", mouseClick)

    if mouseClick == MouseClick.LEFT then
        TheButton:toggle()
    elseif mouseClick == MouseClick.MIDDLE then
        TheButton:resetPositionToDefault()
    else
        Config:open() -- Settings.OpenToCategory(Totes.myTitle)
    end
end

---@type string
local addonCompartmentToolTip
function GLOBAL_TOTES_AddonCompartment_OnEnter(addonName, menuButtonFrame)
    zebug.trace:print("addonName",addonName, "menuButtonFrame", menuButtonFrame:GetName())
    GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT");
    if not addonCompartmentToolTip then
        addonCompartmentToolTip = sprintf(
                "%s \r\r %s - %s \r %s - %s \r %s - %s",
                ADDON_NAME,
                zebug.trace:colorize(L10N.LEFT_CLICK),
                zebug.info:colorize(L10N.TOGGLE_TOTES),
                zebug.trace:colorize(L10N.MIDDLE_CLICK),
                zebug.info:colorize(L10N.REPOSITION_TOTES),
                zebug.trace:colorize(L10N.RIGHT_CLICK),
                zebug.info:colorize(L10N.OPEN_CONFIG)
        )
    end
    GameTooltip:SetText(addonCompartmentToolTip);
end

function GLOBAL_TOTES_AddonCompartment_OnLeave(addonName, menuButtonFrame)
    zebug.trace:print("addonName",addonName, "menuButtonFrame", menuButtonFrame:GetName())
    GameTooltip_Hide();
end

-------------------------------------------------------------------------------
-- L10N Utility Functions
-------------------------------------------------------------------------------

function L10N.getTipsForConfigScreen()
    return strjoin("\n    * ", "", L10N.RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG, unpack(L10N.TIP_LIST))
end

function L10N.getTipsForToolTip()
    return strjoin("\n* ", "* ".. L10N.RIGHT_CLICK_TO_OPEN_CONFIG, unpack(L10N.TIP_LIST))
end

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

function foo()
end

-------------------------------------------------------------------------------
-- Sound Functions
-------------------------------------------------------------------------------

---@class SND
SND = {
    DELETE   = SOUNDKIT.IG_CHAT_SCROLL_UP,
    KEYPRESS = SOUNDKIT.IG_MINIMAP_ZOOM_IN, -- IG_CHAT_SCROLL_DOWN
    ENTER    = SOUNDKIT.IG_CHAT_BOTTOM,
    NAV_INTO = SOUNDKIT.IG_ABILITY_PAGE_TURN, -- IG_QUEST_LOG_OPEN, --  IG_MAINMENU_OPTION
    NAV_OUTOF= SOUNDKIT.IG_ABILITY_PAGE_TURN, -- IG_QUEST_LOG_OPEN, --  IG_MAINMENU_OPTION
    OPEN     = SOUNDKIT.IG_SPELLBOOK_OPEN, -- IG_BACKPACK_OPEN, -- IG_MAINMENU_OPTION_CHECKBOX_OFF
    CLOSE    = SOUNDKIT.IG_SPELLBOOK_CLOSE, -- IG_CHARACTER_INFO_CLOSE, -- IG_MAINMENU_OPTION_CHECKBOX_ON
    SCROLL_UP = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON,
    SCROLL_DOWN = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON,
}
play = PlaySound

function makeSoundDemoButton()
    local funcs = {}
    for k, v in pairs(SOUNDKIT) do
        if string.sub(k,1,3) == "IG_" then
            funcs[#funcs+1] = function(btn, mouseClick)
                print(k)
                local foo = string.len(k) or 1
                btn:SetSize(foo * 10, 30)
                btn:SetText(k)
                PlaySound(v)
            end
        end
    end

    local btn = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
    btn:SetPoint("CENTER")
    btn:SetText("Sound Demo")
    btn:SetSize(200, 30)
    btn:SetFrameStrata(FrameStrata.TOOLTIP)
    btn:RegisterForClicks("AnyUp")

    btn:SetScript("OnClick", function(btn, mouseClick)
        local mathOp = (mouseClick == MouseClick.LEFT) and 1 or (mouseClick == MouseClick.RIGHT) and 1 or 0
        btn.i = (btn.i or 0) + mathOp
        if btn.i > #funcs then
            btn.i = 1
        elseif btn.i < 1 then
            btn.i = #funcs
        end
        local func = funcs[btn.i]
        func(btn, mouseClick)
    end)
end

-------------------------------------------------------------------------------
-- Config for Slash Commands aka "/ufo"
-------------------------------------------------------------------------------

local slashFuncs = {
    [L10N.SLASH_CMD_CONFIG] = {
        desc = L10N.SLASH_DESC_CONFIG,
        fnc = Config.open,
    },
    [L10N.SLASH_CMD_OPEN] = {
        desc = L10N.SLASH_DESC_OPEN,
        fnc = function() TheMenu:toggle()  end,
    },
}

-------------------------------------------------------------------------------
-- Addon Lifecycle
-------------------------------------------------------------------------------

function initalizeAddonStuff()
    if isTotesInitialized then return end

    myTitle = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title")

    -- support keybindings via arcane BS syntax and globals.  facepalm.
    _G.BINDING_HEADER_TotesEmotes = ADDON_NAME -- and this appears to not even be supported anymore
    _G["BINDING_NAME_"..KEYBINDING_ID] = ADDON_NAME .. " - Toggle Menu"

    registerSlashCmd("totes", slashFuncs)
    registerSlashCmd("totesemotes", slashFuncs)

    DB:initializeOptsMemory()
    DB:initializePositionMemory()
    Config:initializeOptionsMenu()

    theButton = TheButton:new()
    theMenu = TheMenu:new()

    local emotesTree = EmoteDefinitions:makeNavigationTree()
    theNavigator = Navigator:new(emotesTree)
    theMenu:setNavSubscriptions(theNavigator)
    theButton:setNavSubscriptions(theNavigator)

    theNavigator:reset("addon initialization")

    -- flags to wait out the chaos happening when the UI first loads / reloads.
    isTotesInitialized = true
    C_Timer.After(1, function() hasShitCalmedTheFuckDown = true end)
end

-------------------------------------------------------------------------------
-- OK, Go for it!
-------------------------------------------------------------------------------

BlizGlobalEventsListener:register(Totes, EventHandlers)
