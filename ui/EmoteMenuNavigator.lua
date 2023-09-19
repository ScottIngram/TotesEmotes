-- EmoteMenuNavigator
-- recieves input, traverses the emotes tree, and executes the emote.

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class EmoteMenuNavigator
EmoteMenuNavigator = {}

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

function EmoteMenuNavigator:new(menu)
    local self = { menu = menu }
    return self
end

function EmoteMenuNavigator:input(key)

end
