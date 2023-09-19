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
---@field foo boolean placate Bliz security rules of "don't SetAnchor() during combat"
---@field bar boolean close the flyout after the user clicks one of its buttons
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
    return {
        foo = true,
        bar = true,
    }
end

