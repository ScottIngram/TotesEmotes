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
TOGGLE_TOTES = "toggle emotes button"
OPEN_CONFIG = "open config"
REPOSITION_TOTES = "reset button position"

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

CLICK_TO_TOGGLE_FAVORITE = "Click to toggle favorite."

RIGHT_CLICK_TO_OPEN_CONFIG = "Right-click this icon to open the config screen."
RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG = "Right-click the Emotes button or the Header Icon to open this config screen."

TIP_LIST = {
    "Escape or left arrow will go up a menu level.",
    "Up and down arrow scroll the list.",
    "Enter activates the first emote.",
    "Shift-Enter ditto AND also closes the menu.",
}
