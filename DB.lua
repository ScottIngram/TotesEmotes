-- DB
-- access to Bliz's persisted data facility

-------------------------------------------------------------------------------
-- Module Loading
--
-- Bliz's SavedVariables don't like my Wormhole magic, so, I've isolated them here
-- there is no call to Wormhole() so we're in the global namespace, NOT in the Totes !
-------------------------------------------------------------------------------

---@class position
---@field point string
---@field relativeToFrameName string
---@field relativePoint string
---@field xOffset number
---@field yOffset number

---@class DB
---@field opts table
---@field theButtonPos table position coordinates for the button
---@field theMenuPos table position coordinates for the menu
---@field theMenuSize table size and shape of the menu
local DB = {}

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.DB = DB

---@class Options -- IntelliJ-EmmyLua annotation
---@field isButtonShown boolean remembers if the user has hidden the button or not
---@field quickKeyBacktick boolean start menu at ~
---@field quickKeyDash boolean the menu will include - on the end
---@field quickKeyEqual boolean the menu will include = on the end
---@field faves table<string,boolean> which emotes are favorites { emoteName = t/f }
Options = { }

-------------------------------------------------------------------------------
-- Config Opts
-------------------------------------------------------------------------------

function DB:initializeOptsMemory()
    ---@type Config
    local Config = Totes.Config

    if not TOTES_OPTS then
        TOTES_OPTS = DB:getOptionDefaults()
    end

    DB.opts = TOTES_OPTS
end

---@return Options
function DB:getOptionDefaults()
    --@type Options
    local defaults = {
        isButtonShown   = true,
        quickKeyBacktick  = false,
        quickKeyDash = true,
        quickKeyEqual = false,
        faves = {}
    }
    return defaults
end

-------------------------------------------------------------------------------
-- Button & Menu Positions & Size
-------------------------------------------------------------------------------

function DB:initializePositionMemory()
    if not TOTES_COORDS then
        TOTES_COORDS = {
            theButtonPos = {},
            theMenuPos = {},
            theMenuSize = {},
        }
    end

    DB.theButtonPos = TOTES_COORDS.theButtonPos
    DB.theMenuPos = TOTES_COORDS.theMenuPos
    DB.theMenuSize = TOTES_COORDS.theMenuSize
end


