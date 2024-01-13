local ADDON_NAME, Ufo = ...

if "frFR" == GetLocale() then
    local ADDON_NAME, Ufo = ...
    Ufo.Wormhole(Ufo.L10N) -- Lua voodoo magic that replaces the current Global namespace with the Ufo.L10N object
    -- Now, FOO = "bar" is equivilent to Ufo.L10N.FOO = "bar" - Even though they all look like globals, they are not.

    CLICK_TO_TOGGLE_FAVORITE = "Cliquez pour basculer entre favoris."
    RIGHT_CLICK_TO_OPEN_CONFIG = "Cliquez avec le bouton droit sur cette icône pour ouvrir l'écran de configuration."
    RIGHT_CLICK_BUTTON_TO_OPEN_CONFIG = "Cliquez avec le bouton droit sur le bouton Emotes ou sur l'icône d'en-tête pour ouvrir cet écran de configuration."

    CONSEIL_LISTE = {
    "Echap fermera le menu.",
    "La suppression remontera d'un niveau de menu lorsque le texte recherché est vide.",
    "Maj-Suppr effacera tout le texte recherché.",
    "Les touches fléchées haut et bas modifient la sélection.",
    "La touche Entrée activera la sélection.",
    "Maintenir Shift, etc. en même temps fermera le menu.",
}
    -- Category names
    Favorites = "Favoris"
    Happy = "Heureux"
    Angry = "En colère"
    Sad = "Triste"
    Neutral = "Neutre"
    Combat = "Combat"
    Everything = "Tout"

    -- Missing emotes
    MISSING_EMOTES = {
        puzzled = "perplexe",
        joke = "blague",
        serious = "sérieux",
        stretch = "étirer",
        pack = "pack",
        yourewelcome = "de rien",
    }

end
