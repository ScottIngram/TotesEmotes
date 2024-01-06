-- TheButton
-- user defined options and saved vars

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class TheButtonBase
---@field className string "TheMenu"
---@field nav Navigator
---@field isDragging boolean

---@alias TheButton TheButtonBase|KeyListenerMixin|Frame

---@type TheButton
TheButton = { className = "TheButton", }
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
    ---@type TheButton
    local self = CreateFrame("Button", ADDON_NAME.."TheButton", UIParent, "UIPanelButtonTemplate")
    ---@type TheButton
    TheButton = deepcopy(TheButton, self)
    self:SetPoint("CENTER")
    self:mySetText("Emotes")
    self:SetScript("OnMouseDown", TheButton.onMouseDown)
    self:SetScript("OnMouseUp", TheButton.onMouseUp)
    self:SetScript("OnDragStart", TheButton.onDragStart)
    self:SetScript("OnDragStop", TheButton.onDragStop)
    self:RegisterForClicks("AnyDown", "AnyUp")
    self:RegisterForDrag("LeftButton")
    self:SetMovable(true)
    self:SetClampedToScreen(true)

    self:restorePositionFromDb()
    self:restoreVisibility()
    if DB.opts.isKeyboardEnabled then
        self:startKeyListener(KeyListenerScope.onlyDuringMouseOver)
    end

    return self
end

-- TODO - store visibility in SAVED_VARS
function TheButton:toggle()
    if self:IsShown() then
        self:Hide()
        DB.opts.isButtonShown = false
    else
        self:Show()
        DB.opts.isButtonShown = true
    end
end

function TheButton:restoreVisibility()
    -- TODO: fix bug that the menu is also hidden while the button is

    if DB.opts.isButtonShown == nil then
        DB.opts.isButtonShown = true
    end
    if DB.opts.isButtonShown then
        self:Show()
    else
        self:Hide()
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
        theMenu:toggle()
    elseif mouseClick == MouseClick.RIGHT then
        Settings.OpenToCategory(Totes.myTitle)
    end
end

---@param mouseClick MouseClick
function TheButton:onMouseUp(mouseClick)
    zebug.trace:print("onMouseUp", mouseClick)
end

function TheButton:onDragStart()
    if InCombatLockdown() then return end
    self.isDragging = true
    self:StartMoving()
end

function TheButton:onDragStop()
    self.isDragging = false
    self:StopMovingOrSizing()
    self:savePosition()
end

function TheButton:restorePositionFromDb()
    local p = DB.theButtonPos
    self:moveTo(p.point, p.relativeToFrameName, p.relativePoint, p.xOffset, p.yOffset)
end

function TheButton:resetPositionToDefault()
    self:moveTo("CENTER", nil, "CENTER", 0, 0)
    self:Show()
    DB.opts.isButtonShown = true
end

function TheButton:moveTo(point, relativeToFrameName, relativePoint, xOffset, yOffset)
    if InCombatLockdown() then C_Timer.After(1, function() self:moveTo(point, relativeToFrameName, relativePoint, xOffset, yOffset)  end) return end
    self:ClearAllPoints()
    local relativeToFrame = _G[relativeToFrameName] or UIParent
    self:SetPoint(point or "CENTER", relativeToFrame, relativePoint or "CENTER", xOffset or 0, yOffset or 0)
    self:savePosition()
end

function TheButton:savePosition() -- save button position after move
    local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint()
    DB.theButtonPos.point = point or "CENTER"
    DB.theButtonPos.relativeToFrameName = relativeTo and relativeTo.GetName and relativeTo:GetName() or "UIParent"
    DB.theButtonPos.relativePoint = relativePoint or "CENTER"
    DB.theButtonPos.xOffset = xOffset
    DB.theButtonPos.yOffset = yOffset
end

---@return boolean true if consumed: stop propagation!
function TheButton:handleKeyPress(key)
    zebug.info:print("key",key)
    return KeyListenerResult.passedOn
end

-------------------------------------------------------------------------------
-- Navigator Event handlers
-------------------------------------------------------------------------------

---@param navigator Navigator
function TheButton:setNavSubscriptions(navigator)
    self.nav = navigator
    navigator:subscribe(NavEvent.OpenNode, TheButton_handleOpenNode, self.className)
    navigator:subscribe(NavEvent.OnEmote, TheButton_handleEmote, self.className)
end

function TheButton_handleOpenNode(msg, node)
    --zebug.info:name("handleOpenNode"):print("msg",msg, "node",node)
    -- TODO: refresh the display
end

function TheButton_handleEmote(msg, node)
    --zebug.info:name("emote"):print("msg",msg, "node",node)
    -- TODO: refresh the display
end


