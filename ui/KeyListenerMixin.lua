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

---@class KeyEvent
KeyEvent = {
    DOWN = "OnKeyDown",
    UP   = "OnKeyUp",
}

function KeyListenerMixin:inject(other)
    for name, func in pairs(KeyListenerMixin) do
        other[name] = func
    end
end

---@param onlyWhenMouseOver? KeyListenerScope
---@param self KeyListenerMixin
function KeyListenerMixin:startKeyListener(onlyWhenMouseOver)
    self.onlyWhenMouseOver = onlyWhenMouseOver
    self:EnableKeyboard(true)
    self:SetPropagateKeyboardInput(true)
    self:SetScript(KeyEvent.DOWN, makeKeyHandlerFrom(self.handleKeyPress))
    self:SetScript(KeyEvent.UP,   makeKeyHandlerFrom(self.handleKeyRelease))
end

function KeyListenerMixin:stopKeyListener()
    self:EnableKeyboard(false)
    self:SetPropagateKeyboardInput(false)
end

function makeKeyHandlerFrom(handler)
    local func = function(self, key)
        local doConsumeKeyPress = (not self.onlyWhenMouseOver) or self:IsMouseOver()
        if doConsumeKeyPress then
            local handled = handler(self, key)
            local propagate = not handled
            if isInCombatLockdown("key press heard") then return true end
            self:SetPropagateKeyboardInput(propagate)
        else
            if isInCombatLockdown("key press heard") then return true end -- avoid taint failure
            self:SetPropagateKeyboardInput(true)
        end
        return true
    end
    return func
end

---@return boolean true if handled: stop propagation!
function KeyListenerMixin:handleKeyPress(key)
    -- dummy stub.  implement
    zebug.warn:name("handleKeyPress"):print("default stub heard key",key)
    return false
end

---@return boolean true if handled: stop propagation!
function KeyListenerMixin:handleKeyRelease(key)
    -- dummy stub.  implement
    zebug.warn:name("handleKeyRelease"):print("default stub heard key",key)
    return false
end
