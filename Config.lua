-- Config
-- user defined options and saved vars

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class Config -- IntelliJ-EmmyLua annotation
---@field opts Options
---@field optDefaults Options
Config = { }

-------------------------------------------------------------------------------
-- Configuration Options Menu UI
-------------------------------------------------------------------------------

function Config:new()
    return Object:new(Config)
end

local optionsMenu

local function initializeOptionsMenu()
    if optionsMenu then
        return optionsMenu
    end

    local opts = Config.opts

    optionsMenu = {
        name = Totes.myTitle,
        type = "group",
        args = {

            -------------------------------------------------------------------------------
            -- General Options
            -------------------------------------------------------------------------------

            helpText = {
                order = 100,
                type = 'description',
                fontSize = "small",
                name = "(Shortcut: Right-click the [TOTES] button to open this config menu.)\n\n",
            },
        }
    }

    return optionsMenu
end

-------------------------------------------------------------------------------
-- Mouse Button opt maker
-------------------------------------------------------------------------------

function Config:initializeOptionsMenu()
    initializeOptionsMenu()
    --local db = LibStub("AceDB-3.0"):New(ADDON_NAME, defaults)
    --options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, optionsMenu)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME, Totes.myTitle)
end
