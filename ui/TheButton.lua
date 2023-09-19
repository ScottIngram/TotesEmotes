-- TheButton
-- user defined options and saved vars

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class TheButton
---@field isDragging boolean
---@type TheButton|KeyListenerMixin
TheButton = { }
KeyListenerMixin:inject(TheButton)

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

local HEIGHT = 30

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

function TheButton:new()
    local self = CreateFrame("Button", ADDON_NAME.."TheButton", UIParent, "UIPanelButtonTemplate")
    TheButton = deepcopy(TheButton, self)
    self:SetPoint("CENTER")
    self:mySetText("Emotes")
--[[
    btn:SetScript("OnClick", function(self, mouseClick, isDown)
        print("Pressed", mouseClick, isDown and "down" or "up")
    end)
]]
    self:SetScript("OnMouseDown", TheButton.onMouseDown)
    self:SetScript("OnMouseUp", TheButton.onMouseUp)
    self:RegisterForClicks("AnyDown", "AnyUp")
    self:SetMovable(true)

    self:startKeyListener("onlyOnMouseOver")

    return self
end

function TheButton:toggle()
    if self:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

function TheButton:mySetText(text)
    local foo = string.len(text) or 1
    self:SetSize(foo * 10, HEIGHT)
    self:SetText(text)
end

---@param mouseClick MouseClick
function TheButton:onMouseDown(mouseClick)
    self:SetFrameStrata(FrameStrata.MEDIUM)
    self:SetFrameLevel(9) -- one below inventory bags

    if mouseClick == MouseClick.LEFT then
        self.isDragging = true
        self:StartMoving()
        theMenu:toggle()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

function TheButton:activateDrag()
    if mouseClick == MouseClick.LEFT then
        self.mouseX, self.mouseY = GetCursorPosition()
        self.isDragging = true
        self:StartMoving()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end


---@param mouseClick MouseClick
function TheButton:onMouseUp(mouseClick)
    if mouseClick == MouseClick.LEFT then
        self.isDragging = false
        self:StopMovingOrSizing()
    end
    zebug.trace:print("onMouseUp", mouseClick)
end

function foo()
    self.mouseX, self.mouseY = GetCursorPosition()

end

---@return boolean true if consumed: stop propagation!
function TheButton:handleKeyPress(key)
    zebug.info:print("key",key)
    return true
end
