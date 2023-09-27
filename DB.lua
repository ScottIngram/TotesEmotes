-- DB
-- access to Bliz's persisted data facility

-------------------------------------------------------------------------------
-- Module Loading
--
-- Bliz's SavedVariables don't like my Wormhole magic, so, I've isolated them here
-- there is no call to Wormhole() so we're in the global namespace, NOT in the Totes !
-------------------------------------------------------------------------------

---@class DB
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
-- Profiles
-------------------------------------------------------------------------------

function DB:initializeProfiles()
    if not TOTES_PROFILES then
        TOTES_PROFILES = { }
    end

    DB.profiles = TOTES_PROFILES
end

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

