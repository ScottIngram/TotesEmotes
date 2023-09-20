-- TheMenu
-- controller for the main menu of emotes

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class TheMenu
---@field isDragging boolean
---@field titleBar table
---@field icon table
---@field closeBtn table
---@field inset table
---@field border table
---@type TheMenu|KeyListenerMixin
TheMenu = { }
_G["TotesTheMenuController"] = TheMenu

KeyListenerMixin:inject(TheMenu)

ScrollBoxListLinearViewMixin = CreateFromMixins(ScrollBoxListViewMixin, ScrollBoxLinearBaseViewMixin);

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
    self:setIcon(2056011)

    -- Behavior
    self:SetScript("OnMouseDown", TheMenu.onMouseDown)
    self:SetScript("OnMouseUp", TheMenu.onMouseUp)
    self:SetMovable(true)
    self:startKeyListener("onlyOnMouseOver")

    -- scroll area
    local pad = 0
    local elementSpacing = 4
    local view = CreateScrollBoxListLinearView(pad, pad, pad, pad, elementSpacing)
    view:SetElementInitializer("TotesTemplate_TheMenu_EmoteRow", TheMenu.formatRow)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.listing.scrollBox, self.listing.scrollBar, view)

    return self
end

---@param emotes table<number, EmoteDefinition|EmoteCat>
function TheMenu:setEmotes(emotes)
    if not self.dataProvider then
        self.dataProvider = CreateDataProvider(emotes)
    end
    self.listing.scrollBox:SetDataProvider(self.dataProvider)
    self.listing.scrollBox:SetShown(self.listing.scrollBox:HasScrollableExtent())
end

---@param emote EmoteDefinition
function TheMenu.formatRow(rowBtn, emote)
    if emote.name == emote.cat then
        -- this is a category
        rowBtn.label:SetText("===== "..  EmoteCatName[emote.cat].." =====")
        zebug.error:line(20, "cat", EmoteCatName[emote.cat])
    else
        -- this is an emote
        rowBtn.label:SetText(emote.name)
        zebug.warn:print("i",i, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",name)
        if emote.audio then
            rowBtn.audioBtn.icon:SetTexture(2056011)
        else
            rowBtn.audioBtn.icon:SetTexture(nil)
        end
    end
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
    local level = theButton:GetFrameLevel()
    self:SetFrameStrata( theButton:GetFrameStrata() )
    self:SetFrameLevel( level - 3 )
    self.icon:SetFrameLevel( level - 2  )
    self.border:SetFrameLevel( level - 1  ) -- the frame goes over the icon
end

---@param mouseClick MouseClick
function TheMenu:onMouseDown(mouseClick)
    if mouseClick == MouseClick.LEFT then
        self.isDragging = true
        self:StartMoving()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

function TheMenu:activateDrag()
    if mouseClick == MouseClick.LEFT then
        self.mouseX, self.mouseY = GetCursorPosition()
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

function foo()
    self.mouseX, self.mouseY = GetCursorPosition()

end

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyPress(key)
    zebug.info:print("key",key)
    return true
end
