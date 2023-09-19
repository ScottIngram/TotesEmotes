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
    self.inset    = _G[self:GetName().."Inset"]
    self.closeBtn = _G[self:GetName().."CloseButton"]

    -- Appearance
    --self:Hide()
    --self:SetPoint("BOTTOM", theButton, "TOP", 0, 0)
    --self:SetSize(200, 400)
    self:setIcon(2056011)

    -- Behavior
    self:SetScript("OnMouseDown", TheMenu.onMouseDown)
    self:SetScript("OnMouseUp", TheMenu.onMouseUp)
    self:SetMovable(true)
    self:startKeyListener("onlyOnMouseOver")

    -- scroll area
    local theMenuListing = CreateFrame("Frame", nil --[[ADDON_NAME.."TheMenuListing"]], TheMenu.inset, "TotesTheMenuListingTemplate")

    local topPadding, bottomPadding, leftPadding, rightPadding = 5, 10, 0, 0;
    local elementSpacing = 4;
    local view = CreateScrollBoxListLinearView(topPadding, bottomPadding, leftPadding, rightPadding, elementSpacing);
    view:SetElementInitializer("TotesMenuRowTemplate", function(button, rowData)
        -- START callback
        button.Label:SetText(rowData)
        -- END callback
    end)

    ScrollUtil.InitScrollBoxListWithScrollBar(theMenuListing.ScrollBox, theMenuListing.ScrollBar, view);

    local dataProvider = CreateDataProvider({1,2,3,4,5,6,7,8,9,"Row Ten!",1,2,3,4,5,6,7,8,9,"Row Twenty!!"});
    theMenuListing.ScrollBox:SetDataProvider(dataProvider);
    theMenuListing.ScrollBar:SetShown(theMenuListing.ScrollBox:HasScrollableExtent());

    theMenuListing:SetAllPoints() --TheMenu.inset
    theMenuListing:Show()
    theMenuListing.ScrollBox:Show()
    theMenuListing.ScrollBar:Show()


    return self
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
