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

    local isKeyboardDisabled = function()
        return not opts.isKeyboardEnabled
    end

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
            -- Enable Keyboard
            -------------------------------------------------------------------------------

            keyboardHeader = {
                order = 500,
                name = "Keyboard Controls",
                type = 'header',
            },
            keyboardHelp = {
                order = 510,
                type = 'description',
                name = "TotesEmotes can be controlled with both the mouse and keyboard.  However, you can disable the keyboard if you don't want the menu to intercept keystrokes.",
            },
            keyboardEnabled = {
                order = 520,
                name = "Enable Keyboard",
                desc = "Don't intercept any keystrokes.  Control emotes using only the mouse.",
                type = "toggle",
                set = function(optionsMenu, val)
                    opts.isKeyboardEnabled = val
                    if val then
                        TheMenu:enableKeyboard(true)
                    else
                        TheMenu:enableKeyboard(false)
                    end
                end,
                get = function()
                    return opts.isKeyboardEnabled
                end,
            },

            -------------------------------------------------------------------------------
            -- shortcut numbering
            -------------------------------------------------------------------------------

            quickHeader = {
                order = 1000,
                name = "Shortcut Quick Keys",
                type = 'header',
                hidden = isKeyboardDisabled,
            },
            quickHelp = {
                order = 1010,
                type = 'description',
                name = "The first several emotes in the menu can be triggered via a key-press.  By default, these are: 1, 2, 3, ... 9, and 0",
                hidden = isKeyboardDisabled,
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
                hidden = isKeyboardDisabled,
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
                hidden = isKeyboardDisabled,
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
                hidden = isKeyboardDisabled,
            },

            -------------------------------------------------------------------------------
            -- Autocomplete
            -------------------------------------------------------------------------------

            everythingHeader = {
                order = 2000,
                name = "Autocomplete",
                type = 'header',
                hidden = isKeyboardDisabled,
            },
            everythingHelp = {
                order = 2010,
                type = 'description',
                name = "While the menu is open, typing in a word will trigger a search for matching emotes.",
                hidden = isKeyboardDisabled,
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
    LibStub("AceConfigDialog-3.0.TOTES"):AddToBlizOptions(ADDON_NAME, Totes.myTitle)
end

function Config:open()
    --print("TOTES Totes.configUiId",Totes.configUiId)
    Settings.OpenToCategory(Totes.configUiId, Totes.myTitle)
end
