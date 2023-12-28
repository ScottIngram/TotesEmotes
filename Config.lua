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

local function optKeyBind(config, value)
    if value ~= nil then
        local valueB = GetBindingKey(KEYBINDING_ID);
        if valueB then
            SetBinding(valueB);
        end
        if value ~= "" then
            SetBinding(value, KEYBINDING_ID);
        end
        SaveBindings(GetCurrentBindingSet());
    end
    return GetBindingKey(KEYBINDING_ID);
end


---@type table
local optionsMenu

---@return table
local function initializeOptionsMenu()
    if optionsMenu then
        return optionsMenu
    end

    local opts = DB.opts

    optionsMenu = {
        name = Totes.myTitle,
        type = "group",
        args = {

            -------------------------------------------------------------------------------
            -- General Options
            -------------------------------------------------------------------------------

            introText = {
                order = 100,
                type = 'description',
                fontSize = "small",
                name = [=[All /emotes are a few clicks away!

Tips:
]=].. L10N.getTipsForConfigScreen(),
            },

            -------------------------------------------------------------------------------
            -- shortcut numbering
            -------------------------------------------------------------------------------

            quickHeader = {
                order = 1000,
                name = "Shortcut Quick Keys",
                type = 'header',
            },
            quickHelp = {
                order = 1010,
                type = 'description',
                name = "The first several emotes in the menu can be triggered via a key-press.  By default, these are: 1, 2, 3, ... 9, and 0",
            },
            quickKeyBacktick = {
                order = 1100,
                name = "Start with `",
                desc = "The quick keys will start with the ` before the 1",
                --width = "full",
                type = "toggle",
                set = function(optionsMenu, val)
                    opts.quickKeyBacktick = val
                    -- TODO reinit
                end,
                get = function()
                    return opts.quickKeyBacktick
                end,
            },
            quickKeyDash = {
                order = 1200,
                name = "Include -",
                desc = 'The quick keys will include "-" after 0',
                --width = "full",
                type = "toggle",
                set = function(optionsMenu, val)
                    opts.quickKeyDash = val
                    -- TODO reinit
                end,
                get = function()
                    return opts.quickKeyDash
                end,
            },
            quickKeyEqual = {
                order = 1300,
                name = "Include =",
                desc = 'The quick keys will include "=" on the end',
                --width = "full",
                type = "toggle",
                set = function(optionsMenu, val)
                    opts.quickKeyEqual = val
                    -- TODO reinit
                end,
                get = function()
                    return opts.quickKeyEqual
                end,
            },

            -------------------------------------------------------------------------------
            -- Autocomplete
            -------------------------------------------------------------------------------

            everythingHeader = {
                order = 2000,
                name = "Autocomplete",
                type = 'header',
            },
            everythingHelp = {
                order = 2010,
                type = 'description',
                name = "While the menu is open, typing in a word will trigger a search for matching emotes.",
            },

            -------------------------------------------------------------------------------
            -- Key Bindings
            -------------------------------------------------------------------------------

            keybindingHeader = {
                order = 3000,
                name = "Key Bindings",
                type = 'header',
            },
            keybindingBinder = {
                order = 3010,
                type = "keybinding",
                width = "double",
                name = "Toggle Menu",
                desc = "Open and close the menu of emotes.",
                get = optKeyBind,
                set = optKeyBind,
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
