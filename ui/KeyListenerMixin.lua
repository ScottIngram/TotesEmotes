-- KeyListenerMixin.lua

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class KeyListenerMixin
KeyListenerMixin = {}

---@class KeyListenerResult
KeyListenerResult = {
    consumed = true,
    passedOn = false
}

---@class KeyListenerScope
KeyListenerScope = {
    onlyDuringMouseOver = true,
    alwaysWhileVisible = false,
}

function KeyListenerMixin:inject(other)
    for name, func in pairs(KeyListenerMixin) do
        other[name] = func
    end
end

---@param onlyWhenMouseOver? KeyListenerScope
---@param self KeyListenerMixin
function KeyListenerMixin:startKeyListener(onlyWhenMouseOver)
    self:EnableKeyboard(true)
    self:SetScript("OnKeyDown",(function(self, key)
        local doConsumeKeyPress = (not onlyWhenMouseOver) or self:IsMouseOver()
        if doConsumeKeyPress then
            local handled = self:handleKeyPress(key)
            local propagate = not handled
            self:SetPropagateKeyboardInput(propagate)
        else
            --zebug.trace:print("Ignoring ", key, "self:GetPropagateKeyboardInput", self:GetPropagateKeyboardInput())
            self:SetPropagateKeyboardInput(true)
        end
        return true
    end))
    self:SetPropagateKeyboardInput(true)
end

---@return boolean true if handled: stop propagation!
function KeyListenerMixin:handleKeyPress(key)
    -- dummy stub.  implement
    return false
end
