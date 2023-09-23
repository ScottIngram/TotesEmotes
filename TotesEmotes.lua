-- TotesEmotes.lua
-- addon lifecycle methods, coordination between submodules, etc.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@class TotesEmotes -- IntelliJ-EmmyLua annotation
---@field myTitle string Totes.toc Title
local ADDON_NAME, Totes = ...
Totes.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the Totes object
zebug = Zebug:new(Zebug.OUTPUT.TRACE)

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
-- Handlers Loaded Addons
-------------------------------------------------------------------------------

local AddonLoadedHandlers = {}

function AddonLoadedHandlers:TotesEmotes()
    -- Because: The position of named, movable, user-positioned frames created
    -- before PLAYER_LOGIN is automatically restored by the client from the layout cache when the player logs in.
    zebug.trace:print("Heard event: ADDON_LOADED --> TotesEmotes")
    theButton = TheButton:new()
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
        print("coming soon - open menu!")
    else
        Settings.OpenToCategory(Totes.myTitle)
    end
end

local addonCompartmentToolTip
function GLOBAL_TOTES_AddonCompartment_OnEnter(addonName, menuButtonFrame)
    zebug.trace:print("addonName",addonName, "menuButtonFrame", menuButtonFrame:GetName())
    GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT");
    if not addonCompartmentToolTip then
        addonCompartmentToolTip = sprintf(
                "%s \r\r %s - %s \r %s - %s",
                ADDON_NAME,
                zebug.trace:colorize(L10N.LEFT_CLICK),
                zebug.info:colorize(L10N.TOGGLE_TOTES),
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
-- Utility Functions
-------------------------------------------------------------------------------

function foo()
end

-------------------------------------------------------------------------------
-- Config for Slash Commands aka "/ufo"
-------------------------------------------------------------------------------

local slashFuncs = {
    [L10N.SLASH_CMD_CONFIG] = {
        desc = L10N.SLASH_DESC_CONFIG,
        fnc = function() Settings.OpenToCategory(Totes.myTitle)  end,
    },
    [L10N.SLASH_CMD_TOGGLE] = {
        desc = L10N.SLASH_DESC_TOGGLE,
        fnc = function() print("doing done did SLASH_CMD_OPEN")  end,
    },
}

-------------------------------------------------------------------------------
-- Addon Lifecycle
-------------------------------------------------------------------------------

function initalizeAddonStuff()
    if isTotesInitialized then return end

    myTitle = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title")

    registerSlashCmd("totes", slashFuncs)
    DB:initializeProfiles()
    DB:initializeOptsMemory()
    Config:initializeOptionsMenu()

    theMenu = TheMenu:new()

    emotesTree = EmoteDefinitions:makeNavigationTree()
    nav = Navigator:new(emotesTree)
    theMenu:setNavSubscriptions(nav)
    theButton:setNavSubscriptions(nav)

    nav:reset("addon initialization")

    -- flags to wait out the chaos happening when the UI first loads / reloads.
    isTotesInitialized = true
    C_Timer.After(1, function() hasShitCalmedTheFuckDown = true end)
end

-------------------------------------------------------------------------------
-- OK, Go for it!
-------------------------------------------------------------------------------

BlizGlobalEventsListener:register(Totes, EventHandlers, AddonLoadedHandlers)
