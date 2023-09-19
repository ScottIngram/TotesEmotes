local ADDON_NAME, TOTES = ...

---@class L10N -- IntelliJ-EmmyLua annotation
---@field DETECTED
---@field LOADED
TOTES.L10N = {}

TOTES.Wormhole(TOTES.L10N) -- Lua voodoo magic that replaces the current Global namespace with the Totes.L10N object

DETECTED = "detected"
LOADED = "loaded"
LEFT_CLICK = "Left-click"
RIGHT_CLICK = "Right-click"
MIDDLE_CLICK = "Middle-click"
TOGGLE_TOTES = "toggle Emote MB"
OPEN_CONFIG = "open config"

SLASH_CMD_HELP = "help"
SLASH_CMD_CONFIG = "config"
SLASH_DESC_CONFIG = "open the options configuration panel."
SLASH_CMD_OPEN = "open"
SLASH_DESC_OPEN = "open the catalog of flyout menus."
SLASH_CMD_TOGGLE = "toggle"
SLASH_DESC_TOGGLE = "toggle the Emote menu button."
SLASH_UNKNOWN_COMMAND = "unknown command"

Happy = "Happy"
Angry = "Angry"
Sad = "Sad"
Neutral = "Neutral"
Combat  = "Combat"
