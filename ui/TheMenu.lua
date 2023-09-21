-- TheMenu
-- controller for the main menu of emotes

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class TheMenu
---@field className string "TheMenu"
---@field nav Navigator
---@field isDragging boolean
---@field titleBar table
---@field icon table
---@field closeBtn table
---@field inset table
---@field border table
---@type TheMenu|KeyListenerMixin
TheMenu = { className = "TheMenu", }
KeyListenerMixin:inject(TheMenu)
_G["TotesTheMenuController"] = TheMenu -- export for use by the XML

---@class MenuRowController
---@field className string
---@field emote EmoteDefinition
---@field nav Navigator
MenuRowController = { className = "MenuRowController" }
_G["TotesTheMenuRowController"] = MenuRowController -- export for use by the XML which will create a new instance of MenuRowController

-------------------------------------------------------------------------------
-- Data
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Utility Functions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Methods
-------------------------------------------------------------------------------

function TheMenu:new()
    -- BasicFrameTemplate - padded lt grey - thick borders
    -- BasicFrameTemplateWithInset - padded dk grey - thick borders
    -- ButtonFrameTemplate - ditto but with an icon vignette
    -- PortraitFrameTemplate - ditto but brown and no padding
    -- InsetFrameTemplate3 -- lt grey bg - thin grey border
    -- TranslucentFrameTemplate -- dk grey bg  - grey border bolted
    ---@type TheMenu
    local self = CreateFrame("Frame", ADDON_NAME.."TheMenu", theButton, "TotesTheMenuTemplate")
    TheMenu = deepcopy(TheMenu, self)

    -- give more recognizable names to Bliz UI elements
    self.icon     = self.PortraitContainer
    self.titleBar = self.TitleContainer
    self.border   = self.NineSlice
    self.closeBtn = _G[self:GetName().."CloseButton"]

    -- Appearance
    self:SetPoint("BOTTOM", theButton, "TOP", 0, 0)
    self:setIcon(132351)-- 2056011

    -- Behavior
    self:SetScript("OnMouseDown", TheMenu.onMouseDown)
    self:SetScript("OnMouseUp", TheMenu.onMouseUp)
    self:SetMovable(true)
    self:startKeyListener("onlyOnMouseOver")

    -- scroll area
    local pad = 0
    local elementSpacing = 2
    local view = CreateScrollBoxListLinearView(pad, pad, 5, pad, elementSpacing)
    view:SetElementInitializer("TotesTemplate_TheMenu_EmoteRow", function(rowBtn, rowData)
        -- START callback
        self:initializeRowBtn(rowBtn, rowData)
        -- END callback
    end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.listing.scrollBox, self.listing.scrollBar, view)

    return self
end

---@param emotes table<number, EmoteDefinition>
function TheMenu:setEmotes(emotes)
    if not self.dataProvider then
        self.dataProvider = CreateDataProvider(emotes)
    end
    self.listing.scrollBox:SetDataProvider(self.dataProvider)
    self.listing.scrollBox:SetShown(self.listing.scrollBox:HasScrollableExtent())
end

function TheMenu:toggle()
    if self:IsShown() then
        self:Hide()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) --IG_MAINMENU_CLOSE
    else
        self:Show()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) --IG_MAINMENU_OPTION
    end
end

function TheMenu:setIcon(icon)
    self.icon.portrait:SetTexture(icon)
end

function TheMenu:repairStrata()
    -- must do this here instead of new() because Bliz borks these values on PLAYER_LOGIN
    -- NOT USED - moving everything into the XML seems to have solved the problem
    local level = theButton:GetFrameLevel()
    self:SetFrameStrata( theButton:GetFrameStrata() )
    self:SetFrameLevel( level - 3 )
    self.icon:SetFrameLevel( level - 2  )
    self.border:SetFrameLevel( level - 1  ) -- the frame goes over the icon
end

function TheMenu:activateDrag()
    -- pay attention to how far the button is dragged so we cam choose to handleClick or not -- currently unused
    if mouseClick == MouseClick.LEFT then
        self.mouseX, self.mouseY = GetCursorPosition()
        self.isDragging = true
        self:StartMoving()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

---@param rowBtn MenuRowController
---@param emote EmoteDefinition
function TheMenu:initializeRowBtn(rowBtn, emote)
    if not rowBtn.getMenu then
        rowBtn.getMenu = function() return self end
        rowBtn.nav = function() return self.nav end
    end
    rowBtn:formatRow(emote)
end

-------------------------------------------------------------------------------
-- KetListener Event handlers
-------------------------------------------------------------------------------

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyPress(key)
    zebug.info:print("key",key)
    return true
end

-------------------------------------------------------------------------------
-- Widget Event handlers
-------------------------------------------------------------------------------

---@param mouseClick MouseClick
function TheMenu:onMouseDown(mouseClick)
    if mouseClick == MouseClick.LEFT then
        self.isDragging = true
        self:StartMoving()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

---@param mouseClick MouseClick
function TheMenu:onMouseUp(mouseClick)
    if mouseClick == MouseClick.LEFT then
        self.isDragging = false
        self:StopMovingOrSizing()

    end
    zebug.trace:print("onMouseUp", mouseClick)
end

-------------------------------------------------------------------------------
-- XML Event handlers
-------------------------------------------------------------------------------

function TheMenu:OnLoad(zelf)
    -- this doesn't appear to be called
    zebug.error:line(20,"self",self, "xml zelf", zelf, "TheMenu",TheMenu, "theMenu",theMenu)
end

-------------------------------------------------------------------------------
-- Navigator Event handlers
-------------------------------------------------------------------------------

---@param nav Navigator
function TheMenu:setNavSubscriptions(nav)
    self.nav = nav
    nav:subscribe(NavEvent.GoNode, TheMenu_handleGoNode, self.className)
    nav:subscribe(NavEvent.OnEmote, TheMenu_handleOnEmote, self.className)
end

function TheMenu_handleGoNode(event, msg, node)
    zebug.info:name("handleGoNode"):print("event",event, "msg",msg, "node",node)
    -- TODO: refresh the display
end

function TheMenu_handleOnEmote(msg, node)
    -- Prolly not going to do anything here... I don't want to auto close the menu, do I?  Not really.
    zebug.info:name("handleDoEmote"):print("self",self, "Heard msg",msg, "node",node)
end

-------------------------------------------------------------------------------
-- RowController
-------------------------------------------------------------------------------

---@param emote EmoteDefinition
function MenuRowController:formatRow(emote)
    self.emote = emote
    if emote.name == emote.cat then
        -- this is a category
        self.label:SetText("===== "..  EmoteCatName[emote.cat].." =====")
        --zebug.error:line(20, "cat", EmoteCatName[emote.cat])
    else
        -- this is an emote
        self.label:SetText(emote.name)
        --zebug.warn:print("i",i, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",name)
        if emote.audio then
            self.audioBtn.icon:SetTexture(2056011)
        else
            self.audioBtn.icon:SetTexture(nil)
        end
        if emote.viz then
            self.vizBtn.icon:SetTexture(538536)
        else
            self.vizBtn.icon:SetTexture(nil)
        end
    end
end

-------------------------------------------------------------------------------
-- XML Event handlers
-------------------------------------------------------------------------------

function MenuRowController:OnLoad(...)
    -- this doesn't appear to be called
    zebug.info:print("OnLoad args", ...)
end

---@param mouseClick MouseClick
function MenuRowController:OnClick(mouseClick, isDown)
    zebug.trace:print("emote",self.emote.name, "mouseClick",mouseClick, "isDown",isDown)
    EmoteDefinitions:doEmote(self.emote)
    nav:notifySubs(NavEvent.OnEmote, "MenuRowController:OnClick", self.emote)
end


