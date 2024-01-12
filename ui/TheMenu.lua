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
---@field visibleRowList table<number,MenuRowButton> the rows currently displayed
---@field selectedRow MenuRowButton
---@field highlightedRow MenuRowButton
---@field scrollBox ScrollBoxListViewMixin from Blizz's ScrollBoxListView.lua

---@alias TheMenu TheMenuBase|KeyListenerMixin|Frame

---@type TheMenuBase
TheMenu = { className = "TheMenu", visibleRowList={}, }
KeyListenerMixin:inject(TheMenu)
_G["TotesTheMenuController"] = TheMenu -- export for use by the XML

---@class TheMenuResizerBtnController
---@field className string "TheMenuResizerBtnController"
TheMenuResizerBtnController = { className = "TheMenuResizerBtnController" }
_G["TotesTheMenuResizerBtnController"] = TheMenuResizerBtnController -- export for use by the XML

---@class MenuRowButton
---@field className string
---@field emote EmoteDefinition
---@field navNode NavNode
---@field nav Navigator
---@field label table UI obj from the XML
---@field audioBtn table UI obj from the XML
---@field vizBtn table UI obj from the XML
---@field faveBtn FavoriteButton UI obj from the XML
---@field visibleIndex number the visible row's number
MenuRowButton = { className = "MenuRowButton" }
_G["TotesTheMenuRowButton"] = MenuRowButton -- export for use by the XML which will create a new instance of MenuRowButton

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
    ---@type TheMenu
    local self = CreateFrame("Frame", ADDON_NAME.."TheMenu", UIParent, "TotesTheMenuTemplate")
    TheMenu = deepcopy(TheMenu, self)

    -- give more recognizable names to Bliz UI elements
    self.icon     = self.PortraitContainer
    self.titleBar = self.TitleContainer
    self.border   = self.NineSlice
    self.closeBtn = _G[self:GetName().."CloseButton"]
    self.scrollBox = self.listDiv.scrollBox

    -- Appearance
    self:setIcon(ICON_TOP_MENU)
    self.titleBar.TitleText:SetText(ADDON_NAME)

    -- Position
    self:restoreSizeFromDb()
    self:restorePositionFromDb()

    -- Behavior
    if DB.opts.isKeyboardEnabled then
        self:startKeyListener(KeyListenerScope.alwaysWhileVisible)
    end
    --self.searchBox:Disable() -- prevents user input effectively making it a display-only UI

    self:makeScrollArea()

    -- tooltip
    self.icon.portrait:SetScript("OnEnter", iconOnEnter)
    self.icon.portrait:SetScript("OnLeave", function() GameTooltip:Hide() end)
    self.icon.portrait:SetScript("OnMouseUp", iconOnClick)

    return self
end

function TheMenu:makeScrollArea()
    local pad = 0
    local elementSpacing = 2
    local view = CreateScrollBoxListLinearView(pad, pad, 15, pad, elementSpacing)
    ---@param rowBtn MenuRowButton
    view:SetElementInitializer("TotesTemplate_TheMenu_RowBtn", function(rowBtn, rowData) rowBtn:formatRow(rowData) end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.scrollBox, self.listDiv.scrollBar, view)
    self.scrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnAcquiredFrame, self.recycleRowBtn, self); -- callback(self, rowBtn, rowData)
end

function iconOnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT", 25, -25)
    GameTooltip:SetText(L10N.getTipsForToolTip())
    GameTooltip:Show()
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
        self.scrollBox:SetDataProvider(self.dataProvider)
    end

    self.dataProvider:Flush()
    self.dataProvider:InsertTable(navNodesList)
    self.scrollBox:OnViewDataChanged()
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

function TheMenu:setHeaderText(label)
    self.header.label:SetText(label)
    if label then
        self.header.backButton:Show()
    else
        self.header.backButton:Hide()
    end
end

function TheMenu:onBackButtonIsPressed()
    theNavigator:goUp()
end

-------------------------------------------------------------------------------
-- KeyListener Event handlers
-------------------------------------------------------------------------------

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyPress(key)
    return self.nav:handleKeyPressEvent(key)
end

---@return boolean true if consumed: stop propagation!
function TheMenu:handleKeyRelease(key)
    return self.nav:handleKeyReleaseEvent(key)
end

function TheMenu:enableKeyboard(on)
    if on then
        TheMenu:startKeyListener()
    else
        TheMenu:stopKeyListener()
    end

    ---@param row MenuRowButton
    self.scrollBox:ForEachFrame(function(row)
        row:updateHotKey()
    end)
end

-------------------------------------------------------------------------------
-- Widget Event handlers for dragging and resizing
-------------------------------------------------------------------------------

function isTitleBar()
    return TheMenu.titleBar.TitleText:IsMouseOver(15, -10, -25, 15) -- extra room for Top, Bottom, Left, Right
end

---@param mouseClick MouseClick
function TheMenu:onMouseDown(mouseClick)
    if not isTitleBar() then return end
    if mouseClick == MouseClick.LEFT then
        self.isDragging = true
        self:StartMoving()
    end
    zebug.trace:print("onMouseDown", mouseClick)
end

---@param mouseClick MouseClick
function TheMenu:onMouseUp(mouseClick)
    -- as written, this fires regardless of isDragging == true -- TODO: anticipate this becoming a problem
    if mouseClick == MouseClick.LEFT then
        self.isDragging = false
        self:StopMovingOrSizing()
        self:savePositionToDb()
    end
    zebug.trace:print("onMouseUp", mouseClick)
end

function TheMenu:restorePositionFromDb()
    local p = DB.theMenuPos
    if p and p.point and p.relativeToFrameName and p.relativePoint and p.xOffset and p.yOffset then
        self:moveTo(p.point, p.relativeToFrameName, p.relativePoint, p.xOffset, p.yOffset)
    else
        self:resetPositionToDefault()
    end
end

function TheMenu:resetPositionToDefault()
    self:moveTo("CENTER", nil, "CENTER", 0, 0)
    self:Show()
end

function TheMenu:moveTo(point, relativeToFrameName, relativePoint, xOffset, yOffset)
    if InCombatLockdown() then C_Timer.After(1, function() self:moveTo(point, relativeToFrameName, relativePoint, xOffset, yOffset)  end) return end
    self:ClearAllPoints()
    local relativeToFrame = _G[relativeToFrameName] or UIParent
    self:SetPoint(point, relativeToFrame, relativePoint, xOffset, yOffset)
    self:savePositionToDb()
end

function TheMenu:savePositionToDb()
    local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint()
    zebug.trace:print("point", point, "relativeTo", relativePoint, "relativePoint", relativeTo, "xOffset", xOffset, "yOffset", yOffset)
    DB.theMenuPos.point = point or "TOPLEFT"
    DB.theMenuPos.relativeToFrameName = relativeTo and relativeTo.GetName and relativeTo:GetName() or "UIParent"
    DB.theMenuPos.relativePoint = relativePoint or "TOPLEFT"
    DB.theMenuPos.xOffset = xOffset
    DB.theMenuPos.yOffset = yOffset
end

function TheMenu:restoreSizeFromDb()
    local g = DB.theMenuSize
    zebug.trace:dumpy("theMenuSize",g)
    if g and g.width and g.height then
        self:SetSize(g.width, g.height)
        --self:SetHeight(g.height)
        zebug.trace:print("width", g.width, "height", g.height)
    end
end

function TheMenu:saveSizeToDb()
    local width, height = self:GetSize()
    zebug.trace:print("name",self:GetName(), "width", width, "height", height)

    DB.theMenuSize.width = width
    DB.theMenuSize.height = height
end

-------------------------------------------------------------------------------
-- Search box
-------------------------------------------------------------------------------

local previousSearchString

function GLOBAL_TOTES_TheMenu_onSearchTextChanged(searchBox)
    SearchBoxTemplate_OnTextChanged(searchBox)

    local newText = searchBox:GetText()
    local strippedText = newText
    strippedText = string.gsub(strippedText, "^%s+", "") -- less important now that I've added alphabeticOnly to the xml
    strippedText = string.gsub(strippedText, "%s+$", "")
    local hasNoBlankSpaceOnEnds = newText == strippedText
    zebug.info:print("name", searchBox:GetName(), "search text", "["..newText.."]", "previousSearchString", "["..(previousSearchString or "").."]")
    if previousSearchString ~= strippedText then
        TheMenu.nav:runSearchFor(strippedText)
        previousSearchString = strippedText
    end

    thisIsMe = false
end

function TheMenu:updateSearchString(msg)
    local searchBox = self.searchBox
    local newText = msg or ""
    local oldText = searchBox:GetText() or ""
    if oldText == newText then
        zebug.trace:print("no change = aborting!")
        return
    end

    searchBox:SetText(newText)
    SearchBoxTemplate_OnTextChanged(searchBox)

    zebug.trace:print("name TM",self:GetName(), "msg", newText, "search text",searchBox:GetText())
end

-------------------------------------------------------------------------------
-- Resizer Button
-------------------------------------------------------------------------------

function TheMenuResizerBtnController:onMouseDown()
    -- tell the UI that the lower right corner should follow the mouse pointer
    self:GetParent():StartSizing("BOTTOMRIGHT")
end

function TheMenuResizerBtnController:onMouseUp()
    local p = self:GetParent()
    zebug.info:name("init"):print("index of last row",p.scrollBox:GetDataIndexEnd())
    p:StopMovingOrSizing("BOTTOMRIGHT")
    p:saveSizeToDb()
    p:savePositionToDb() -- because Bliz's GetPoint() API is spastic and arbitarily changes its coordinate system if the size changes among other things
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
    nav:subscribe(NavEvent.DownKey, function() self:selectNextRow() end, self.className)
    nav:subscribe(NavEvent.UpKey, function() self:selectPreviousRow() end, self.className)
    nav:subscribe(NavEvent.SearchStringChange, function(msg) self:updateSearchString(msg) end, self.className)
end

function TheMenu:handleNavExit()
    self:selectRow(nil)
    self:toggle()
end

---@param navNode NavNode
function TheMenu:handleNavOpenNode(msg, navNode)
    local id = navNode.id
    local emoteDef = navNode.domainData
    local isEmote = emoteDef and emoteDef.isEmote
    zebug.info:name("handleOpenNode"):print("msg",msg, "node level", navNode.level, "id", id, "#kids", navNode.kids and #navNode.kids, "isEmote",isEmote)
    local icon = emoteDef and emoteDef.icon or ICON_TOP_MENU
    local label = --[[navNode.name or]] EmoteCatName[id] -- no longer display the search string in place of the cat name
    self:setHeaderText(label)
    self:setIcon(icon)
    local oldNavNode = self.selectedRow and self.selectedRow.navNode
    self:selectRow(nil)
    self:clearRowList()

    -- handle special case: Favorites
    zebug.trace:dumpy("faves", DB.opts.faves)
    zebug.info:print("faves isEmpty", isTableEmpty(DB.opts.faves), "key", id, "EmoteCat.Favorites",EmoteCat.Favorites)
    if id == EmoteCat.Favorites then
        self:generateFavoritesNode(navNode)
    end

    self:setListing(navNode.kids)

    self:selectRowByNavNode(oldNavNode)
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
---@return MenuRowButton
function TheMenu:getRowForNavNode(navNode)
    local n = navNode.id
    zebug.trace:dumpKeys(self.visibleRowList)
    local result = self.visibleRowList[n]
    zebug.trace:print("n",n, "result",result)
    return result
end

-------------------------------------------------------------------------------
-- Scroll Box and Rows
-------------------------------------------------------------------------------

function TheMenu:getVisibleRowCount()
    return self.scrollBox:GetDataIndexEnd() - self.scrollBox:GetDataIndexBegin() + 1
end

function TheMenu:getPhysicalRowCount()
    return self.scrollBox:GetDataProviderSize()
end

function TheMenu:getVisibleRows()
    if not self.visibleRowList or (#self.visibleRowList == 0) then
        self.visibleRowList = {}
        self.scrollBox:ForEachFrame(function(row)
            self.visibleRowList[#self.visibleRowList +1] = row
        end)
    end
    return self.visibleRowList
end

function TheMenu:clearRowList()
    for i=#self.visibleRowList, 1, -1 do
        self.visibleRowList[i] = nil
    end
end

function TheMenu:printRows()
    self.scrollBox:ForEachFrame(function(row)
        zebug.warn:print("row",row.name, "index", row.visibleIndex)
    end)
end

-------------------------------------------------------------------------------
-- Row highlighting and selection
-------------------------------------------------------------------------------

function TheMenu:getSelectedRowIndex()
    return self.selectedRow and self.selectedRow.visibleIndex
end

function TheMenu:selectNextRow()
    self:selectAdjacentRow(1)
end

function TheMenu:selectPreviousRow()
    self:selectAdjacentRow(-1)
end

function TheMenu:selectAdjacentRow(increment)
    if self.selectedRow then
        self:selectRowByVisibleIndex(self.selectedRow.visibleIndex + increment)
    else
        self:selectRowByVisibleIndex(1)
    end
end

function TheMenu:selectRowByVisibleIndex(visibleIndex)
    local visibleRowCount = self:getVisibleRowCount()
    zebug.info:print("selecting by visibleIndex", visibleIndex)
    if visibleIndex >= 1 and visibleIndex <= visibleRowCount then
        local row = self.visibleRowList[visibleIndex]
        self:selectRow(row)
    else
        local currentPhysicalIndex = self.selectedRow:GetOrderIndex()
        if visibleIndex < 1 then
            if currentPhysicalIndex == 1 then
                -- don't scroll before the start of the list
                zebug.info:print("already at START of list - aborting UP scroll")
                return
            end

            self:scrollUp()
            zebug.info:print("scrolled UP.  selected row's new index",self.selectedRow.visibleIndex)
            self:selectPreviousRow()
        elseif visibleIndex > visibleRowCount then
            if currentPhysicalIndex == self:getPhysicalRowCount() then
                -- don't scroll past the end of the list
                zebug.info:print("already at END of list - aborting DOWN scroll")
                return
            end
            self:scrollDown()
            zebug.info:print("scrolled DOWN.  selected row's new index",self.selectedRow.visibleIndex)
            self:selectNextRow()
        else
        end
    end
end

---@param row MenuRowButton
function TheMenu:selectRow(row)
    if self.selectedRow then
        self.selectedRow.SelectedOverlay:Hide()
    end
    if row then
        row.SelectedOverlay:Show()
        play(SND.SCROLL_UP)
        zebug.trace:print("selecting row",row.name, "index", row.visibleIndex)
    else
        zebug.trace:print("clearing row selection")
    end
    self.selectedRow = row
end

---@param row NavNode
function TheMenu:selectRowByNavNode(navNode)
    if not navNode then return end

    local foundRow
    zebug.trace:print("looking for NavNode", navNode.domainData.name)

    ---@param row MenuRowButton
    self.scrollBox:ForEachFrame(function(row)
        if row.navNode == navNode then
            foundRow = row
        end
    end)

    if foundRow then
        zebug.trace:print("selecting row",foundRow.name, "index", foundRow.visibleIndex)
        self:selectRow(foundRow)
    else
        zebug.trace:print("no row found for NavNode", navNode.domainData.name)
    end
end

-------------------------------------------------------------------------------
-- programmatic scrolling
-- TODO: implement ScrollPageInDirection up & down
-------------------------------------------------------------------------------

function TheMenu:scrollDown()
    self.listDiv.scrollBar:ScrollPageInDirection(ScrollControllerMixin.Directions.Increase)
    play(SND.SCROLL_DOWN)
end

function TheMenu:scrollUp()
    self.listDiv.scrollBar:ScrollPageInDirection(ScrollControllerMixin.Directions.Decrease)
    play(SND.SCROLL_UP)
end

-------------------------------------------------------------------------------
-- For the MenuRowButton
-------------------------------------------------------------------------------

---@param rowBtn MenuRowButton
---@param navNode NavNode
function TheMenu:recycleRowBtn(rowBtn, navNode)
    if rowBtn == self.selectedRow then
        --self:selectRow(nil)
    end

    ---@param row MenuRowButton
    self.scrollBox:ForEachFrame(function(row)
        row:updateHotKey()
    end)
end

-------------------------------------------------------------------------------
-- MenuRowButton
-------------------------------------------------------------------------------

function MenuRowButton:onLoad()
    zebug.info:name("init"):print("initializing... grandparent", self:getScrollBox():GetName(), "GetDataIndexEnd",self:getScrollBox():GetDataIndexEnd())
    self.isInit = true
end

function MenuRowButton:getMenu()
    return TheMenu
end

function MenuRowButton:getNavigator()
    return self:getMenu().nav
end

function MenuRowButton:getScrollBox()
    return self:GetParent():GetParent()
end

function MenuRowButton:getFrameIndex()
    --zebug.error:print("row count", TheMenu.scrollBox:GetFrameCount() )
    local n = self:GetOrderIndex()
    local indexOfFirstVisibleRow = self:getScrollBox():GetDataIndexBegin() -- Also GetDataIndexEnd()
    return n - indexOfFirstVisibleRow + 1
end

---@param navNode NavNode
function MenuRowButton:formatRow(navNode)
    --zebug.trace:dumpKeys(navNode)
    --zebug.trace:dumpKeys(navNode.domainData)
    self.navNode = navNode
    self.emote = navNode.domainData
    self.name = navNode.domainData.name
    local emote = self.emote
    if navNode.kids then
        -- this is a category
        local localized = L10N[emote.name] or emote.name
        self.label:SetText(localized)
        self.audioBtn.icon:SetTexture(nil) -- 450908:arrow_right
        self.vizBtn.icon:SetTexture(emote.icon)
        zebug.trace:line(20, "CAT", emote.name, "icon",emote.icon)
    else
        -- this is an emote
        local localized = localizeEmote(emote.name)
        self.label:SetText(localized)
        self.audioBtn.icon:SetTexture(emote.audio and ICON_AUDIO)
        self.vizBtn.icon:SetTexture(emote.viz and ICON_VIZ)
        self.faveBtn:updateDisplay()
        zebug.trace:print("emote",emote.name, "cat", EmoteCatName[emote.cat], (emote.audio and "A") or "*", (emote.viz and "V") or "*", "emote",emote.name, "icon",emote.icon)
    end

    self:updateHotKey()
end

function MenuRowButton:updateHotKey()
    if not self.navNode then return end

    local physicalIndex = self:GetOrderIndex()
    local physicalIndexOfFirstVisibleRow = self:getScrollBox():GetDataIndexBegin()

    -- put a number next to the first 10 rows (or more depending on user config opts)
    local howManyQuickKeys = 10
            + ((DB.opts.quickKeyBacktick and 1) or 0)
            + ((DB.opts.quickKeyDash and 1) or 0)
            + ((DB.opts.quickKeyEqual and 1) or 0)

    local backtickBump = (DB.opts.quickKeyBacktick and 1) or 0
    local visibleIndex = physicalIndex - physicalIndexOfFirstVisibleRow - backtickBump  + 1
    TheMenu.visibleRowList[visibleIndex] = self
    self.visibleIndex = visibleIndex

    -- TODO: refactor so that visibleRowList is populated elsewhere and we don't have to invoke updateHotKey()

    if visibleIndex <= howManyQuickKeys and DB.opts.isKeyboardEnabled then
        ---@type string

        if visibleIndex == 10 then
            visibleIndex = "0"
        elseif DB.opts.quickKeyBacktick and visibleIndex == 0 then
            visibleIndex = "`"
        elseif DB.opts.quickKeyDash and visibleIndex == 11 then
            visibleIndex = "-"
        elseif DB.opts.quickKeyEqual and visibleIndex == 12 then
            visibleIndex = "="
        end

        zebug.trace:print("adding self to rowList", self.emote.name, "at index n", physicalIndex, "howManyQuickKeys",howManyQuickKeys, "bump", backtickBump, "display", visibleIndex, "DB.opts.quickKeyEqual",DB.opts.quickKeyEqual)

        self.audioBtn.text:SetText(visibleIndex)
    else
        self.audioBtn.text:SetText(nil)
    end
end

---@param mouseClick MouseClick
function MenuRowButton:onClick(mouseClick, isDown)
    local emote = self.emote
    zebug.trace:name("onClick"):print("emote",emote.name, "mouseClick",mouseClick, "isDown",isDown)
    if self.navNode.kids then
        self:getNavigator():pickNode(self.navNode)
    else
        EmoteDefinitions:doEmote(emote)
        self:getMenu():selectRow(self)
        self:getNavigator():notifySubs(NavEvent.OnEmote, "MenuRowButton:OnClick", emote)
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



