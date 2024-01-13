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

SLASH_CMD_HELP = "help"
SLASH_CMD_CONFIG = "config"
SLASH_DESC_CONFIG = "open the options configuration panel."
SLASH_CMD_OPEN = "open"
SLASH_DESC_OPEN = "open the menu of emotes."
SLASH_CMD_TOGGLE = "toggle"
SLASH_DESC_TOGGLE = "toggle the Emote menu button."
SLASH_UNKNOWN_COMMAND = "unknown command"

TOGGLE_TOTES = "toggle emotes menu"
OPEN_CONFIG = "open config"
REPOSITION_TOTES = "reset button position"
CLICK_TO_TOGGLE_FAVORITE = "Click to toggle favorite."
RIGHT_CLICK_TO_OPEN_CONFIG = "Right-click this icon to open the config screen."
RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG = "Right-click the Emotes button or the Header Icon to open this config screen."

TIP_LIST = {
    "Escape will close the menu.",
    "Delete will go up a menu level when the search text is empty.",
    "Shift-Delete will erase the entire search text.",
    "Up and down arrow keys change the selection.",
    "The Enter key will activate the selection.",
    "Holding shift, etc. at the same time will close the menu.",
}

-- Category names
Favorites = "Favorites"
Happy = "Happy"
Angry = "Angry"
Sad = "Sad"
Neutral = "Neutral"
Combat = "Combat"
Everything = "Everything"

-- Missing emotes
MISSING_EMOTES = {
    puzzled = "puzzled",
    joke = "joke",
    serious = "serious",
    stretch = "stretch",
    pack = "pack",
    yourewelcome = "yourewelcome",
}
