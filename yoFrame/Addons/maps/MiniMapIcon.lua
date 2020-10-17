local L, yo = unpack( select( 2, ...))

local ignoreButtons = {
	["MiniMapTracking"]= true,
	["MiniMapWorldMapButton"]= true,
	["QueueStatusMinimapButton"]= true,
	["MinimapZoomIn"]= true,
	["MinimapZoomOut"]= true,
	["MiniMapMailFrame"]= true,
	["MiniMapBattlefieldFrame"]= true,
	["GameTimeFrame"]= true,
	["FeedbackUIButton"]= true,
	["TimeManagerClockButton"] = true,
	["GarrisonLandingPageMinimapButton"] = true,
	["MinimapBackdrop"] = true,
};

local bShift = 0
local bSize = 30
local frameHeight = 154
local lasttime = 0
local count = 1
local prevButton
local buttonList = {}

local function ButtonEnter(self)
	local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
	self:SetBackdropBorderColor(color.r, color.g, color.b)
	self:SetAlpha( 0.9)
end

local function ButtonLeave(self)
	self:SetBackdropBorderColor(.15,.15,.15, 0)
end

local function toggleFrame( )
	if yo_MiniMapIcon:IsShown() then
		yo_MiniMapIcon:Hide()
		yo_MiniMapIcon.Text:SetText("<\n<")
	else
		yo_MiniMapIcon:Show()
		yo_MiniMapIcon.Text:SetText(">\n>")
	end
end

local function Hide()
  	if yo_MiniMapIcon:IsMouseOver() then return end
  	if time() == lasttime then return end

	yo_MiniMapIcon:Hide()
	yo_MiniMapIcon.Text:SetText("<\n<")
	--toggleFrame()
end

local function SetTimer()
  	lasttime = time()
  	C_Timer.After( 2.5, Hide)
end

local function ScanButtons( frame)
	for i, iFrame in ipairs( {frame:GetChildren()}) do
		local nameFrame = iFrame:GetName()

		if nameFrame and not ignoreButtons[nameFrame] then
			tinsert(buttonList, iFrame)
		end
	end
	numButtons = #buttonList
end

local function MoveButtons( parent, numRow)
	for count, iFrame in ipairs( buttonList) do
		iFrame:SetParent(parent)
		iFrame:SetScript('OnDragStart', nil);
		iFrame:SetScript('OnDragStop', nil);
		iFrame:SetFrameStrata( parent:GetFrameStrata());
		iFrame:SetFrameLevel( parent:GetFrameLevel() + 1);
		iFrame:ClearAllPoints();

		if count == 1 then
			iFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", bShift, -2)
		elseif math.fmod( count - 1, numRow) == 0 then
			iFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", bShift, -( bSize * ( math.ceil( count / numRow) - 1) + bShift))
		else
			iFrame:SetPoint("LEFT", prevButton, "RIGHT", 0, 0)
		end
		prevButton = iFrame
	end
end

local function CreateMiniMapFrame(self)
	if #buttonList > 0 then
		local numCol = math.floor( frameHeight / bSize + 0.5)
		local numRow = math.ceil( #buttonList / numCol)

		SimpleBackground( self, bSize * numRow, frameHeight, "RIGHT", Minimap, "LEFT", -8, 0)
		CreateStyle( self, 3, 0, 0.85)
		self:SetFrameLevel(10)
		self:SetFrameStrata("HIGH")
		self:SetScript("OnLeave", SetTimer)
		self:SetBackdropColor( 0, 0, 0, 0)
		self:Hide()

		self:SetMovable(true)
		self:RegisterForDrag("LeftButton", "RightButton")
		self:SetScript("OnDragStart", function(self) self:StartMoving() end)
		self:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

		local CloseButton = CreateFrame("Button", nil, UIParent, "SecureHandlerClickTemplate")
		CloseButton:SetSize( 12, 25)
		CloseButton:SetPoint( "RIGHT", Minimap, "LEFT", 17, 0)
		CloseButton:RegisterForClicks("AnyUp")
		CloseButton:SetScript("OnEnter", ButtonEnter)
		CloseButton:SetScript("OnLeave", ButtonLeave)
		CloseButton:SetScript("OnMouseUp", function( self) toggleFrame( self) end)
		frame1px(CloseButton)
		CreateStyle(CloseButton, 2)
		self.CloseButton = CloseButton

		local Text = CloseButton:CreateFontString(nil,"OVERLAY",CloseButton)
		Text:SetFont( yo.font, 10, "OUTLINE")
		Text:SetText("<\n<")
		Text:SetPoint("CENTER")
		self.Text = Text

		MoveButtons( self, numRow)
	end
end

local logan = CreateFrame("Frame", "yo_MiniMapIcon", UIParent, BackdropTemplateMixin and "BackdropTemplate")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo["Addons"].MMColectIcons then return end

	ScanButtons( Minimap)
	ScanButtons( MinimapBackdrop)
	CreateMiniMapFrame( self)
end)
