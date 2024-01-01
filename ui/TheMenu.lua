-- TheMenu
-- controller for the main menu of emotes

-------------------------------------------------------------------------------
-- Module Loading
-------------------------------------------------------------------------------

---@type TotesEmotes
local ADDON_NAME, Totes = ...
Totes.Wormhole()

---@class TheMenuBase
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

---@alias TheMenu TheMenuBase|KeyListenerMixin|Frame

---@type TheMenuBase
TheMenu = { className = "TheMenu", rowList={}, }
KeyListenerMixin:inject(TheMenu)
_G["TotesTheMenuController"] = TheMenu -- export for use by the XML

---@class MenuRowController
---@field className string
---@field emote EmoteDefinition
---@field navNode NavNode
---@field nav Navigator
---@field label table UI obj from the XML
---@field audioBtn table UI obj from the XML
---@field vizBtn table UI obj from the XML
---@field faveBtn FavoriteButton UI obj from the XML
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
    self:SetClampedToScreen(true)
    self:setIcon(ICON_TOP_MENU)
    self.titleBar.TitleText:SetText(ADDON_NAME)

    -- Behavior
    self:SetScript("OnMouseDown", TheMenu.onMouseDown)
    self:SetScript("OnMouseUp", TheMenu.onMouseUp)
    self.canMove = false -- TODO - make a config option
    if self.canMove then
        self:SetMovable(true)
    end

    self:startKeyListener(KeyListenerScope.alwaysWhileVisible)

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
    self.listing.scrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnAcquiredFrame, self.recycleRowBtn, self); -- callback(self, rowBtn, rowData)
    self.listView = view
    --self.listing.scrollBar:SetShown(self.listing.scrollBox:HasScrollableExtent())

    -- tooltip
    self.icon.portrait:SetScript("OnEnter", iconOnEnter)
    self.icon.portrait:SetScript("OnLeave", function() GameTooltip:Hide() end)
    self.icon.portrait:SetScript("OnMouseUp", iconOnClick)

    return self
end

function iconOnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT", 25, -25)
    GameTooltip:SetText(L10N.getTipsForToolTip())
    GameTooltip:Show()
end

function iconOnExit(self)
    GameTooltip:Hide()
end

---@param mouseClick MouseClick
function iconOnClick(self, mouseClick, isDown)
    if mouseClick == MouseClick.LEFT then
        --theMenu:toggle()
    elseif mouseClick == MouseClick.RIGHT then
        Settings.OpenToCategory(Totes.myTitle)
    end
end

function TheMenu:setListing(navNodesList)
    if not self.dataProvider then
        self.dataProvider = CreateDataProvider(navNodesList)
        self.listing.scrollBox:SetDataProvider(self.dataProvider)
    end

    self.dataProvider:Flush()
    self.dataProvider:InsertTable(navNodesList)
    self.listing.scrollBox:OnViewDataChanged()
end

function TheMenu:toggle()
    if self:IsShown() then
        play(SND.CLOSE)
        self:Hide()
    else
        play(SND.OPEN)
        self:Show()
    end
end

function GLOBAL_TOTES_Toggle_Menu()
    TheMenu:toggle()
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

function TheMenu:scrollDown()
    self.listing.scrollBar:ScrollStepInDirection(1)
    play(SND.SCROLL_DOWN)
end

function TheMenu:scrollUp()
    self.listing.scrollBar:ScrollStepInDirection(-1)
    play(SND.SCROLL_UP)
end

-------------------------------------------------------------------------------
-- KeyListener Event handlers
-------------------------------------------------------------------------------

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyPress(key)
    return self.nav:handleKeyPress(key)
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
    nav:subscribe(NavEvent.Exit, function() self:handleNavExit() end, self.className)
    ---@param navNode NavNode
    nav:subscribe(NavEvent.OpenNode, function(msg, navNode) self:handleNavOpenNode(msg, navNode) end, self.className)
    ---@param navNode NavNode
    nav:subscribe(NavEvent.Execute, function(msg, navNode) self:handleNavExecuteNode(msg, navNode) end, self.className)
    nav:subscribe(NavEvent.DownKey, function() self:scrollDown() end, self.className)
    nav:subscribe(NavEvent.UpKey, function() self:scrollUp() end, self.className)
end

function TheMenu:handleNavExit()
    self:selectedRow(nil)
    self:toggle()
end

---@param navNode NavNode
function TheMenu:handleNavOpenNode(msg, navNode)
    local id = navNode.id
    local emoteDef = navNode.domainData
    local isEmote = emoteDef and emoteDef.isEmote
    zebug.info:name("handleOpenNode"):print("msg",msg, "node level", navNode.level, "id", id, "#kids", navNode.kids and #navNode.kids, "isEmote",isEmote)
    local icon = emoteDef and emoteDef.icon or ICON_TOP_MENU
    local label = navNode.name or EmoteCatName[id]
    self.header.fontString:SetText(label)
    self:setIcon(icon)
    self:selectedRow(nil)
    self:clearRowList()

    -- handle special case: Favorites
    zebug.trace:dumpy("faves", DB.opts.faves)
    zebug.info:print("faves isEmpty", isTableEmpty(DB.opts.faves), "key", id, "EmoteCat.Favorites",EmoteCat.Favorites)
    if id == EmoteCat.Favorites then
        self:generateFavoritesNode(navNode)
    end

    self:setListing(navNode.kids)
end

---@param navNode NavNode
function TheMenu:handleNavExecuteNode(msg, navNode)
    local rowFrame = self:getRowForNavNode(navNode)
    rowFrame:Click()
end

function TheMenu:generateFavoritesNode(navNode)
    local names = { }
    for name, _ in pairs(DB.opts.faves) do
        names[#names + 1] = name
    end
    --zebug.error:dumpy("names", names)
    table.sort(names)
    --zebug.error:dumpy("SORTED names", names)
    --@type table<number, NavNode>
    local navNodes = {}
    ---@param name string
    for i, name in ipairs(names) do
        local emoteDef = EmoteDefinitions.map[name]
        local favMenuNode = self.nav.rootNode.kids[EmoteCat.Favorites]
        local navNode = EmoteDefinitions:convertToNavNode(emoteDef, favMenuNode)
        navNodes[i] = navNode
    end
    --zebug.error:dumpy("navNodes", navNodes)
    navNode.kids = navNodes
end


---@param navNode NavNode
---@return MenuRowController
function TheMenu:getRowForNavNode(navNode)
    local n = navNode.id
    zebug.trace:dumpKeys(self.rowList)
    local result = self.rowList[n]
    zebug.trace:print("n",n, "result",result)
    return result
end

-------------------------------------------------------------------------------
-- For the MenuRowController
-------------------------------------------------------------------------------

---@param rowBtn MenuRowController
---@param navNode NavNode
function TheMenu:initializeRowBtn(rowBtn, navNode)
    zebug.trace:print(rowBtn:GetOrderIndex())
    if not rowBtn.isInit then
        rowBtn.isInit = true
        rowBtn.getMenu = function() return self end
        rowBtn.nav = self.nav
        rowBtn.scrollBox = self.listing.scrollBox
        rowBtn:SetParentKey("btn"..rowBtn:GetOrderIndex())
    end
    rowBtn:formatRow(navNode)
end

---@param rowBtn MenuRowController
---@param navNode NavNode
function TheMenu:recycleRowBtn(rowBtn, rowData, c)
    if not rowBtn.isInit then
        return
    end

    self.listing.scrollBox:ForEachFrame(function(row)
        if rowBtn.isInit then
            updateHotKey(row)
        end
    end)
end


-------------------------------------------------------------------------------
-- MenuRowController
-------------------------------------------------------------------------------

---@param navNode NavNode
function MenuRowController:formatRow(navNode)
    --zebug.trace:dumpKeys(navNode)
    --zebug.trace:dumpKeys(navNode.domainData)
    self.navNode = navNode
    self.emote = navNode.domainData
    self.name = navNode.domainData.name
    local emote = self.emote
    if navNode.kids then
        -- this is a category
        self.label:SetText(emote.name)
        self.audioBtn.icon:SetTexture(nil) -- 450908:arrow_right
        self.vizBtn.icon:SetTexture(emote.icon)
        zebug.trace:line(20, "CAT", emote.name, "icon",emote.icon)
    else
        -- this is an emote
        self.label:SetText(emote.name)
        self.audioBtn.icon:SetTexture(emote.audio and ICON_AUDIO)
        self.vizBtn.icon:SetTexture(emote.viz and ICON_VIZ)
        self.faveBtn:updateDisplay()
        zebug.trace:print("emote",emote.name, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",emote.name, "icon",emote.icon)
    end

    updateHotKey(self)
end

function updateHotKey(row)
    local n = row:GetOrderIndex()
    local indexOfFirstVisibleRow = TheMenu.listView:GetDataIndexBegin()

    -- put a number next to the first 10 rows (or more depending on user config opts)
    local howManyQuickKeys = 10
            + ((DB.opts.quickKeyBacktick and 1) or 0)
            + ((DB.opts.quickKeyDash and 1) or 0)
            + ((DB.opts.quickKeyEqual and 1) or 0)

    local indexEnder = indexOfFirstVisibleRow + howManyQuickKeys

    if n < indexEnder then
        local bump = (DB.opts.quickKeyBacktick and 1) or 0
        ---@type string
        local display = n - bump - indexOfFirstVisibleRow + 1
        TheMenu.rowList[display] = row

        if display == 10 then
            display = "0"
        elseif DB.opts.quickKeyBacktick and display==0 then
            display = "`"
        elseif DB.opts.quickKeyDash and display==11 then
            display = "-"
        elseif DB.opts.quickKeyEqual and display==12 then
            display = "="
        end

        zebug.trace:print("adding self to rowList", row.emote.name, "at index n",n, "howManyQuickKeys",howManyQuickKeys, "bump",bump, "display",display, "DB.opts.quickKeyEqual",DB.opts.quickKeyEqual)

        row.audioBtn.text:SetText(display)
    else
        row.audioBtn.text:SetText(nil)
    end
end

function MenuRowController:OnLoad(...)
    -- this doesn't appear to be called
    zebug.trace:name("OnLoad"):print("OnLoad args", ...)
end

---@param mouseClick MouseClick
function MenuRowController:OnClick(mouseClick, isDown)
    local emote = self.emote
    zebug.trace:name("OnClick"):print("emote",emote.name, "mouseClick",mouseClick, "isDown",isDown)
    if self.navNode.kids then
        self.nav:pickNode(self.navNode)
    else
        EmoteDefinitions:doEmote(emote)
        self:getMenu():selectedRow(self)
        self.nav:notifySubs(NavEvent.OnEmote, "MenuRowController:OnClick", emote)
    end
end

-------------------------------------------------------------------------------
-- Favorite button - stolen from AuctionHouseFavoriteButtonBaseMixin
-------------------------------------------------------------------------------

---@class FavoriteButton
FavoriteButton = {}
_G["TotesFavoriteButtonMixin"] = FavoriteButton

function FavoriteButton:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L10N.CLICK_TO_TOGGLE_FAVORITE)
    GameTooltip:Show();
end

function FavoriteButton:OnLeave()
    GameTooltip_Hide();
end

function FavoriteButton:OnClick()
    self:toggleIsFavorite()
    self:updateDisplay()
end

function FavoriteButton:updateDisplay()
    local isFavorite = self:isFavorite()
    local currAtlas = isFavorite and "auctionhouse-icon-favorite" or "auctionhouse-icon-favorite-off"
    self.NormalTexture:SetAtlas(currAtlas)
    self.NormalTexture:SetAlpha(isFavorite and 0.8 or 0.2)

    self.HighlightTexture:SetAtlas(currAtlas)
    --self.HighlightTexture:SetAlpha(0.8)
end

function FavoriteButton:isFavorite()
    local name = self:GetParent().name
    return DB.opts.faves[name]
end

function FavoriteButton:toggleIsFavorite()
    local name = self:GetParent().name
    DB.opts.faves[name] = (not DB.opts.faves[name]) or nil -- don't store false. just erase the true value.
end



