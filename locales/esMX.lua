local ADDON_NAME, Ufo = ...

if "esMX" == GetLocale() or "es" == string.sub(GetLocale(),1,2) then
    local ADDON_NAME, Ufo = ...
    Ufo.Wormhole(Ufo.L10N) -- Lua voodoo magic that replaces the current Global namespace with the Ufo.L10N object
    -- Now, FOO = "bar" is equivilent to Ufo.L10N.FOO = "bar" - Even though they all look like globals, they are not.

    -- Localized text
    CONFIRM_DELETE = "¿Estás seguro de que quieres eliminar el conjunto flotante %s?"
    DETECTED = "detectado"
    LOADED = "cargado"

    CLICK_TO_TOGGLE_FAVORITE = "Haga clic para alternar entre favoritos."
    RIGHT_CLICK_TO_OPEN_CONFIG = "Haga clic derecho en este icono para abrir la pantalla de configuración."
    RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG = "Haga clic derecho en el botón Gestos o en el ícono de encabezado para abrir esta pantalla de configuración."
    TIP_LIST = {
        "Escape cerrará el menú.",
        "Eliminar subirá un nivel de menú cuando el texto de búsqueda esté vacío.",
        "Shift-Delete borrará todo el texto de búsqueda.",
        "Las teclas de flecha arriba y abajo cambian la selección.",
        "La tecla Enter activará la selección.",
        "Mantener presionada la tecla Mayús, etc. al mismo tiempo cerrará el menú.",
    }

    -- Category names
    Favorites = "Favoritos"
    Happy = "Feliz"
    Angry = "Enojado"
    Sad = "Triste"
    Neutral = "Neutro"
    Combat = "Combate"
    Everything = "Todo"

    -- Missing emotes
    MISSING_EMOTES = {
        puzzled = "desconcertado",
        joke = "broma",
        serious = "serio",
        stretch = "estirar",
        pack = "paquete",
        yourewelcome = "de nada",
    }

end
