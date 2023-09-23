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
---@field titleBar table UI obj from the XML
---@field header table UI obj from the XML
---@field icon table UI obj from the XML
---@field closeBtn table UI obj from the XML
---@field inset table UI obj from the XML
---@field border table UI obj from the XML
---@field rowList table<number,MenuRowController> the rows currently displayed (well, the first 10 anyway)
---@type TheMenu|KeyListenerMixin
TheMenu = { className = "TheMenu", rowList={}, }
KeyListenerMixin:inject(TheMenu)
_G["TotesTheMenuController"] = TheMenu -- export for use by the XML

---@class MenuRowController
---@field className string
---@field emote EmoteDefinition
---@field navNode NavNode
---@field nav Navigator
---@field label table UI obj from the XML
MenuRowController = { className = "MenuRowController" }
_G["TotesTheMenuRowController"] = MenuRowController -- export for use by the XML which will create a new instance of MenuRowController

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

ICON_TOP_MENU = 132351
ICON_AUDIO = 2056011
ICON_VIZ   = 538536

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
    self:setIcon(ICON_TOP_MENU)
    self.titleBar.TitleText:SetText(ADDON_NAME)

    -- Behavior
    self:SetScript("OnMouseDown", TheMenu.onMouseDown)
    self:SetScript("OnMouseUp", TheMenu.onMouseUp)
    self.canMove = false -- TODO - make a config option
    if self.canMove then
        self:SetMovable(true)
    end

    self:startKeyListener()

    -- scroll area
    local pad = 0
    local elementSpacing = 2
    local view = CreateScrollBoxListLinearView(pad, pad, 15, pad, elementSpacing)
    view:SetElementInitializer("TotesTemplate_TheMenu_EmoteRow", function(rowBtn, rowData)
        -- START callback
        self:initializeRowBtn(rowBtn, rowData)
        -- END callback
    end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.listing.scrollBox, self.listing.scrollBar, view)
    --self.listing.scrollBox:SetShown(self.listing.scrollBox:HasScrollableExtent())

    return self
end

---@param navNodesList table<index,NavNode>
function TheMenu:setListing(navNodesList)
    if true --[[enable for now]] and self.dataProvider then
        -- Ok, this DOES work now.  -- none of this seems to trigger a refresh... yay complete lack of documentation
        self.dataProvider:Init(navNodesList)
        --self.dataProvider:Flush()
        self.dataProvider:TriggerEvent(DataProviderMixin.Event.OnSizeChanged, false);
        --self.listing.scrollBox:SetDataProvider(self.dataProvider)
        self.listing.scrollBox:OnViewDataChanged()
    else
        self.dataProvider = CreateDataProvider(navNodesList)
        self.listing.scrollBox:SetDataProvider(self.dataProvider)
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
        if self.canMove then
            self:StartMoving()
        end
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

---@param rowBtn MenuRowController
---@param navNode NavNode
function TheMenu:initializeRowBtn(rowBtn, navNode)
    zebug.info:print(rowBtn:GetOrderIndex())
    if not rowBtn.getMenu then
        rowBtn.getMenu = function() return self end
        rowBtn.nav = self.nav
    end
    rowBtn:formatRow(navNode)
end

---@param row MenuRowController
function TheMenu:selectedRow(row)
    if self.currentlySelected then
        self.currentlySelected.SelectedOverlay:Hide()
    end
    if row then
        row.SelectedOverlay:Show()
    end
    self.currentlySelected = row
end

function TheMenu:clearRowList()
    for i=#self.rowList, 1, -1 do
        self.rowList[i] = nil
    end
end

-------------------------------------------------------------------------------
-- KetListener Event handlers
-------------------------------------------------------------------------------

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyPress(key)
    if key == "ESCAPE" then
        zebug.trace:print("handling Escape")
        self:selectedRow(nil)
        self.nav:goUp()
        return KeyListenerResult.consumed
    else
        local n = tonumber(key) or 999
        if n <= 9 then
            zebug.trace:print("reporting key",key)
            if n == 0 then n = 10 end
            return self.nav:input(n)
        end
    end
    return KeyListenerResult.passedOn
end

-------------------------------------------------------------------------------
-- Widget Event handlers
-------------------------------------------------------------------------------

---@param mouseClick MouseClick
function TheMenu:onMouseDown(mouseClick)
    if mouseClick == MouseClick.LEFT then
        self.isDragging = true
        if self.canMove then
            self:StartMoving()
        end
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

function TheMenu:OnLoad(arg1)
    -- self is the XML's instance of TheMenu mixin
    zebug.trace:name("OnLoad"):print("self",self, "arg1", arg1, "TheMenu",TheMenu, "theMenu",theMenu)
end

-------------------------------------------------------------------------------
-- Navigator Event handlers
-------------------------------------------------------------------------------

---@param nav Navigator
function TheMenu:setNavSubscriptions(nav)
    self.nav = nav
    nav:subscribe(NavEvent.Exit, function(...) self:toggle() end, self.className)
    ---@param navNode NavNode
    nav:subscribe(NavEvent.GoNode, function(msg, navNode) self:handleGoNode(msg, navNode) end, self.className)
    ---@param navNode NavNode
    nav:subscribe(NavEvent.Execute, function(msg, navNode) self:handleExecuteNode(msg, navNode) end, self.className)
end

---@param navNode NavNode
function TheMenu:handleGoNode(msg, navNode)
    local key = navNode.id
    local emoteDef = navNode.domainData
    local isEmote = emoteDef and emoteDef.isEmote
    zebug.info:name("handleGoNode"):print("msg",msg, "node level", navNode.level, "key",key, "#kids", navNode.kids and #navNode.kids, "isEmote",isEmote)
    local icon = emoteDef and emoteDef.icon or ICON_TOP_MENU
    self.header.fontString:SetText(EmoteCatName[key])
    self:setIcon(icon)
    self:clearRowList()
    self:setListing(navNode.kids)
end

---@param navNode NavNode
function TheMenu:handleExecuteNode(msg, navNode)
    local rowFrame = self:getRowForNavNode(navNode)
    rowFrame:Click()
end

---@param navNode NavNode
---@return MenuRowController
function TheMenu:getRowForNavNode(navNode)
    local n = navNode.id
    zebug.error:dumpKeys(self.rowList)
    local result = self.rowList[n]
    zebug.error:print("n",n, "result",result)
    return result
end

-------------------------------------------------------------------------------
-- RowController
-------------------------------------------------------------------------------

---@param navNode NavNode
function MenuRowController:formatRow(navNode)
    zebug.error:dumpKeys(navNode)
    zebug.error:dumpKeys(navNode.domainData)
    self.navNode = navNode
    self.emote = navNode.domainData
    local emote = self.emote
    if navNode.level == 1 then -- TODO: this feels like a kludge
        -- this is a category
        self.label:SetText(emote.name)
        self.audioBtn.icon:SetTexture(nil) -- 450908:arrow_right
        self.vizBtn.icon:SetTexture(emote.icon)
        zebug.error:line(20, "CAT", emote.name, "icon",emote.icon)
    else
        -- this is an emote
        self.label:SetText(emote.name)
        self.audioBtn.icon:SetTexture(emote.audio and ICON_AUDIO)
        self.vizBtn.icon:SetTexture(emote.viz and ICON_VIZ)
        zebug.warn:print("i",i, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",emote.name, "icon",emote.icon)
    end

    -- put a number next to the first 10 rows
    local n = self:GetOrderIndex()
    if n <= 10 then
        self:getMenu().rowList[n] = self
        zebug.trace:print("adding self to rowList",self.emote.name, "at index n",n)
        n = n==10 and 0 or n
        self.audioBtn.text:SetText(n)
    else
        self.audioBtn.text:SetText(nil)
    end
end

-------------------------------------------------------------------------------
-- XML Event handlers
-------------------------------------------------------------------------------

function MenuRowController:OnLoad(...)
    -- this doesn't appear to be called
    zebug.error:name("OnLoad"):print("OnLoad args", ...)
end

---@param mouseClick MouseClick
function MenuRowController:OnClick(mouseClick, isDown)
    local emote = self.emote
    zebug.trace:name("OnClick"):print("emote",emote.name, "mouseClick",mouseClick, "isDown",isDown)
    if self.navNode.level == 1 then --TODO: this feels like a kludge
        self.nav:pickNode(self.navNode)
    else
        EmoteDefinitions:doEmote(emote)
        self:getMenu():selectedRow(self)
        self.nav:notifySubs(NavEvent.OnEmote, "MenuRowController:OnClick", emote)
    end
end


