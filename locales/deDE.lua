local ADDON_NAME, Ufo = ...

if "deDE" == GetLocale() then
    local ADDON_NAME, Ufo = ...
    Ufo.Wormhole(Ufo.L10N) -- Lua voodoo magic that replaces the current Global namespace with the Ufo.L10N object
    -- Now, FOO = "bar" is equivilent to Ufo.L10N.FOO = "bar" - Even though they all look like globals, they are not.

    -- Localized text
    CONFIRM_DELETE = "Sind Sie sicher, dass Sie das Flyout-Set %s löschen möchten?"
    DETECTED = "Erkannt"
    LOADED = "Voll"
    LEFT_CLICK = "Left-click"
    RIGHT_CLICK = "Right-click"
    MIDDLE_CLICK = "Middle-click"

    SLASH_CMD_HELP = "helfen"
    SLASH_CMD_CONFIG = "konfigurieren"
    SLASH_DESC_CONFIG = "Öffnen Sie das Optionskonfigurationsfenster."
    SLASH_CMD_OPEN = "Öffnen"
    SLASH_DESC_OPEN = "Öffnen Sie das Menü der Emotes."
    SLASH_CMD_TOGGLE = "Schalten"
    SLASH_DESC_TOGGLE = "Schalten Sie die Emote-Menüschaltfläche um."
    SLASH_UNKNOWN_COMMAND = "unbekannter Befehl"

    TOGGLE_TOTES = "Emotes-Menü umschalten"
    OPEN_CONFIG = "öffne die Konfiguration"
    REPOSITION_TOTES = "Position der Reset-Taste"
    CLICK_TO_TOGGLE_FAVORITE = "Klicken Sie, um den Favoriten umzuschalten."
    RIGHT_CLICK_TO_OPEN_CONFIG = "Klicken Sie mit der rechten Maustaste auf dieses Symbol, um den Konfigurationsbildschirm zu öffnen."
    RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG = "Klicken Sie mit der rechten Maustaste auf die Schaltfläche „Emotes“ oder das Kopfzeilensymbol, um diesen Konfigurationsbildschirm zu öffnen."

    TIP_LIST = {
        "Escape schließt das Menü.",
        "Durch Löschen wird eine Menüebene nach oben verschoben, wenn der Suchtext leer ist.",
        "Umschalt-Entf löscht den gesamten Suchtext.",
        "Mit den Auf- und Ab-Pfeiltasten können Sie die Auswahl ändern.",
        "Die Eingabetaste aktiviert die Auswahl.",
        "Wenn Sie gleichzeitig die Umschalttaste usw. gedrückt halten, wird das Menü geschlossen.",
    }

    -- Category names
    Favorites = "Favoritinnen"
    Happy = "Glücklich"
    Angry = "Wütend"
    Sad = "Traurig"
    Neutral = "Neutral"
    Combat = "Kampf"
    Everything = "Alles"

    -- Missing emotes
    MISSING_EMOTES = {
        puzzled = "verwirrt",
        joke = "Witz",
        serious = "ernst",
        stretch = "strecken",
        pack = "packen",
        yourewelcome = "geschehen",
    }

end
