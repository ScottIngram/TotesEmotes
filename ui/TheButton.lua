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
    self:RegisterForClicks("AnyDown", "AnyUp")
    self:SetMovable(true)

    self:restoreVisibility()
    self:startKeyListener(KeyListenerScope.onlyDuringMouseOver)

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

function TheButton:resetPosition()
    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "CENTER")
    self:Show()
    DB.opts.isButtonShown = true
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
    return KeyListenerResult.passedOn
end

-------------------------------------------------------------------------------
-- Navigator Event handlers
-------------------------------------------------------------------------------

---@param navigator Navigator
function TheButton:setNavSubscriptions(navigator)
    self.nav = navigator
    navigator:subscribe(NavEvent.OpenNode, TheButton_handleOpenNode, self.className)
    nav:subscribe(NavEvent.OnEmote, TheButton_handleEmote, self.className)
end

function TheButton_handleOpenNode(msg, node)
    --zebug.info:name("handleOpenNode"):print("msg",msg, "node",node)
    -- TODO: refresh the display
end

function TheButton_handleEmote(msg, node)
    --zebug.info:name("emote"):print("msg",msg, "node",node)
    -- TODO: refresh the display
end


