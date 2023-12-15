local ADDON_NAME, ADDON_SYMBOL_TABLE = ...

ADDON_SYMBOL_TABLE.Wormhole() -- Lua voodoo magic that replaces the current Global namespace with the ADDON_SYMBOL_TABLE

---@class MouseClick
MouseClick = {
    ANY    = "any",
    LEFT   = "LeftButton",
    RIGHT  = "RightButton",
    MIDDLE = "MiddleButton",
    FOUR   = "Button4",
    FIVE   = "Button5",
}

---@class FrameStrata
FrameStrata = {
    WORLD          = "WORLD",
    BACKGROUND     = "BACKGROUND",
    LOW            = "LOW",
    MEDIUM         = "MEDIUM",
    HIGH           = "HIGH",
    DIALOG         = "DIALOG",
    FULLSCREEN     = "FULLSCREEN",
    FULLSCREEN_DIALOG =  "FULLSCREEN_DIALOG",
    TOOLTIP         = "TOOLTIP",
}

KEYBINDING_ID = "TotesEmotes_Toggle_Menu"

QUOTE = "\""
EOL = "\n"
MAX_GLOBAL_MACRO_ID = 120
DEFAULT_ICON = "INV_Misc_QuestionMark"
DEFAULT_ICON_FULL = "INTERFACE\\ICONS\\INV_Misc_QuestionMark"
DEFAULT_ICON_FULL_CAPS = "INTERFACE\\ICONS\\INV_MISC_QUESTIONMARK"

ESCAPE = "ESCAPE"
