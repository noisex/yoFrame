local L, yo = unpack( select( 2, ...))

local tick, ptick = 1, 0

local cfg = {
  	scale = 1,
  	point = { "TOPRIGHT", UIPARENT, "TOPRIGHT", 10, 10},
}
	--onenter/show
local function Show()
  	GameTimeFrame:SetAlpha( 0.9)
  	TimeManagerClockButton:SetAlpha( 0.9)
  	MiniMapTracking:SetAlpha(0.9)
  	MiniMapChallengeMode:SetAlpha(0.9)
  	MiniMapInstanceDifficulty:SetAlpha(0.9)
  	GuildInstanceDifficulty:SetAlpha(0.9)
	MinimapZoneTextButton:SetAlpha(0.9)

  	if yo_MiniMapIcon.CloseButton then
  		yo_MiniMapIcon.CloseButton:SetAlpha(0.9)
  	end
end

--onleave/hide
local lasttime = 0
local function Hide()
  	if Minimap:IsMouseOver() then return end
  	if time() == lasttime then return end
  	
  	GameTimeFrame:SetAlpha( C_Calendar.GetNumPendingInvites())
  	TimeManagerClockButton:SetAlpha( 1)
  	MiniMapTracking:SetAlpha(0)
  	MiniMapChallengeMode:SetAlpha(0)
  	MiniMapInstanceDifficulty:SetAlpha(0)
  	GuildInstanceDifficulty:SetAlpha(0)

	if yo.Addons.MiniMapHideText then  	
		MinimapZoneTextButton:SetAlpha(0)
	end

  	if yo_MiniMapIcon.CloseButton then
  		yo_MiniMapIcon.CloseButton:SetAlpha(0)
  	end
 end

local function SetTimer()
  	lasttime = time()
  	C_Timer.After( 2, Hide)
end

local function MiniInit()
	if not yo.Addons.MiniMap then return end
	
	--CreateStyle( DurabilityFrame, 3, 0)
	DurabilityFrame:ClearAllPoints()
	DurabilityFrame:SetPoint("BOTTOM", plFrame, "TOP", 0, 20)
	--DurabilityFrame:SetFrameLevel( 10)
	DurabilityFrame.ClearAllPoints = dummy
	DurabilityFrame.SetPoint = dummy
	

	--MinimapCluster
	MinimapCluster:SetScale(cfg.scale)
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint(unpack(cfg.point))

	--Minimap
	local mediapath = "interface\\addons\\yoFrame\\Media\\"
	--Minimap:SetMaskTexture(mediapath.."mask2")
	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -5)
	Minimap:SetSize( yo.Addons.MiniMapSize, yo.Addons.MiniMapSize) --correct the cluster offset

	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
	--Minimap:SetHitRectInsets(0, 0, 24*cfg.scale, 24*cfg.scale)
	Minimap:SetFrameLevel(4)
	Minimap:SetScale(cfg.scale)
	Minimap:SetArchBlobRingScalar(0);
	Minimap:SetQuestBlobRingScalar(0);

	--hide regions
	MinimapBackdrop:Hide()
	MinimapBorder:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MinimapBorderTop:Hide()
	MiniMapWorldMapButton:Hide()
	--MinimapZoneText:Hide()

	--Zone Text
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetFrameStrata("MEDIUM")
	MinimapZoneTextButton:SetPoint("TOP", Minimap, "TOP", 0, 2)
	--MinimapZoneTextButton:SetAlpha(0.7)
	
	--dungeon info
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOP",Minimap,"TOP",0,-10)
	MiniMapInstanceDifficulty:SetScale(0.9)
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOP",Minimap,"TOP",0,-10)
	GuildInstanceDifficulty:SetScale(0.8)
	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetPoint("TOP",Minimap,"TOP",0,-10)
	MiniMapChallengeMode:SetScale(0.8)

	--QueueStatusMinimapButton (lfi)
	QueueStatusMinimapButton:SetParent(Minimap)
	QueueStatusMinimapButton:SetScale(1)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("BOTTOMLEFT",Minimap, -5, 30)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButton:SetHighlightTexture (nil)
	QueueStatusMinimapButton:SetPushedTexture(nil)

	--garrison (DIEEEEEE!!!)
	--GarrisonLandingPageMinimapButton
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetParent(Minimap)
	GarrisonLandingPageMinimapButton:SetSize( 28,33)
	GarrisonLandingPageMinimapButton.SetSize = dummy
	GarrisonLandingPageMinimapButton.SetWidth = dummy
	GarrisonLandingPageMinimapButton.SetHeight = dummy

	GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", 0, 0)
	--GarrisonLandingPageMinimapButton:SetScale( 0.3)

	--mail
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("BOTTOMRIGHT",Minimap, -0, -3)
	MiniMapMailIcon:SetTexture(mediapath.."mail")
	MiniMapMailBorder:SetTexture("Interface\\Calendar\\EventNotificationGlow")
	MiniMapMailBorder:SetBlendMode("ADD")
	MiniMapMailBorder:ClearAllPoints()
	MiniMapMailBorder:SetPoint("CENTER",MiniMapMailFrame,0.5,1.5)
	MiniMapMailBorder:SetSize(27,27)
	MiniMapMailBorder:SetAlpha(0.5)

	--MiniMapTracking
	MiniMapTracking:SetParent(Minimap)
	MiniMapTracking:SetScale(1)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("TOPLEFT",Minimap,0,0)
	MiniMapTrackingButton:SetHighlightTexture (nil)
	MiniMapTrackingButton:SetPushedTexture(nil)
	MiniMapTrackingBackground:Hide()
	MiniMapTrackingButtonBorder:Hide()

	--MiniMapNorthTag
	MinimapNorthTag:ClearAllPoints()
	MinimapNorthTag:SetPoint("TOP",Minimap,0,-3)
	MinimapNorthTag:SetAlpha(0)

	--Blizzard_TimeManager
	LoadAddOn("Blizzard_TimeManager")
	TimeManagerClockButton:GetRegions():Hide()
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("BOTTOM",0, -10)
	TimeManagerClockTicker:SetFont( font,fontsize +3,"OUTLINE")
	TimeManagerClockTicker:SetTextColor(0.8,0.8,0.6,1)

	--GameTimeFrame
	GameTimeFrame:SetParent(Minimap)
	GameTimeFrame:SetScale(0.6)
	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint("TOPRIGHT",Minimap,-18,-18)
	GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
	GameTimeFrame:GetNormalTexture():SetTexCoord(0,1,0,1)
	GameTimeFrame:SetNormalTexture(mediapath.."calendar")
	GameTimeFrame:SetPushedTexture(nil)
	GameTimeFrame:SetHighlightTexture (nil)
	local fs = GameTimeFrame:GetFontString()
		fs:ClearAllPoints()
		fs:SetPoint("CENTER",0,-5)
		fs:SetFont( font,fontsize + 10)
		fs:SetTextColor(0.2,0.2,0.1,0.9)

	--zoom
	Minimap:EnableMouseWheel()
	local function Zoom(self, direction)
		if(direction > 0) then Minimap_ZoomIn()
		else Minimap_ZoomOut() end
		end
	Minimap:SetScript("OnMouseWheel", Zoom)
	Minimap:SetScript("OnLeave", SetTimer)
	Minimap:SetScript("OnEnter", Show)
	CreateStyle( Minimap, 5)
	Hide( Minimap)
end

local function pvpTimer( self, elapsed)
	ptick = ptick + elapsed
	if ptick < 1 then return end
	ptick = 0

	if not self.pvpText then
		self.pvpIcon = self:CreateTexture(nil, "OVERLAY")
		self.pvpIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)
		self.pvpIcon:SetTexture("texture")
		self.pvpIcon:SetSize(22, 22)
		unitPVP( self, "player")

		self.pvpText = self:CreateFontString(nil, "OVERLAY")
		self.pvpText:SetFont( font, fontsize  +3, "OUTLINE")
		self.pvpText:SetPoint("RIGHT", self.pvpIcon, "LEFT", 0, 1)
		self.pvpText:SetTextColor(1, .4, 0, 1)
	end

	if IsPVPTimerRunning() then
		self.pvpIcon:Show()
		self.pvpText:Show()
		self.pvpText:SetText( timeFormat( GetPVPTimer() /1000))
	else
		self.pvpIcon:Hide()
		self.pvpText:Hide()
		self:SetScript("OnUpdate", nil)
	end	
end

local function CalendarPend( self, event, ...)
	--local pend = C_Calendar.GetNumPendingInvites()

	if event == "MINIMAP_PING" then
		local unit = ...
		if unit 
			--and not UnitIsUnit("player", unit) 
			then
		
			if not self.pingText then
				self.pingText = self:CreateFontString(nil, "OVERLAY")
				self.pingText:SetFont( font, fontsize, "OUTLINE")
				self.pingText:SetPoint("CENTER", Minimap, "TOP", 0, -40)
				self.pingText:Hide()			
			end

			local uclass = ( select( 2, UnitClass( unit)) or 1)
			local sColor = "|c" .. RAID_CLASS_COLORS[ uclass].colorStr .. UnitName( unit) .. "|r"
			--local sColor = "|c" .. RAID_CLASS_COLORS[ uclass].colorStr .. strsplit( "-", UnitName( unit)) .. "|r"

			self.pingText:SetText( sColor)
			self.pingText:Show()
  			C_Timer.After( 2, HidePing)
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		MiniInit()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if IsPVPTimerRunning() then			
			self:SetScript("OnUpdate", pvpTimer)
		end	

	elseif event == "CALENDAR_EVENT_ALARM" then
		local title, hour, minute = ...;
		local info = ChatTypeInfo["SYSTEM"];
		DEFAULT_CHAT_FRAME:AddMessage(format(CALENDAR_EVENT_ALARM_MESSAGE, title), info.r, info.g, info.b, info.id);
		UIFrameFlash(GameTimeCalendarEventAlarmTexture, 1.0, 1.0, 6);
	
	elseif event == "PLAYER_FLAGS_CHANGED" then
		if IsPVPTimerRunning() then
			self:SetScript("OnUpdate", pvpTimer)
		end	
	else
		print("|cffff0000Debug event: |r", event, ... )
	end	
end

local calevent = CreateFrame("Frame", nil, Minimap)
--calevent:RegisterEvent("CALENDAR_NEW_EVENT")

--calevent:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
--calevent:RegisterEvent("CALENDAR_OPEN_EVENT")
--calevent:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")

calevent:RegisterEvent("CALENDAR_EVENT_ALARM")
calevent:RegisterEvent("PLAYER_ENTERING_WORLD")
calevent:RegisterEvent("MINIMAP_PING")
calevent:RegisterEvent("PLAYER_FLAGS_CHANGED")
calevent:SetScript("OnEvent", CalendarPend)

function HidePing(...)
	calevent.pingText:Hide()
end

----------------------------------------------------------------------------------------
--	Creating Coordinate 
----------------------------------------------------------------------------------------
local function coordUpdate( self, elapsed)
	tick  = tick + elapsed
	if tick >= 1 then
		if not yo.Addons.MiniMapCoord then
			self:SetScript("OnUpdate", nil)
			self.MiniMapText:SetText("")
			return
		else
			local r, b, g = strsplit( ",", yo.Addons.MMCoordColor)
			
			local fontsize = yo.Addons.MMCoordSize
			self.MiniMapText:SetTextColor( r, b, g)
			self.MiniMapText:SetFont( font, fontsize)
		end
		
		tick = 0
		
		local mapID = C_Map.GetBestMapForUnit("player")

		if mapID and C_Map.GetPlayerMapPosition( mapID, "player") then
			local x, y = C_Map.GetPlayerMapPosition( mapID, "player"):GetXY() 

			x = math.floor(100 * x) or 0
			y = math.floor(100 * y) or 0
			if x ~= 0 and y ~= 0 then
				self.MiniMapText:SetText( x .. ": " .. y)
			else
				self.MiniMapText:SetText( " ")
			end
		end
	end
end

local coordFrame = CreateFrame( "Frame", nil, UIParent)
coordFrame.MiniMapText = coordFrame:CreateFontString(nil, "OVERLAY")
coordFrame.MiniMapText:SetFont( font, fontsize)
coordFrame.MiniMapText:SetJustifyH("LEFT")
coordFrame.MiniMapText:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 15)
coordFrame.MiniMapText:SetText("0, 0")
coordFrame.MiniMapText:SetTextColor( 0.7, 0.7, 0.7)
coordFrame:SetScript("OnUpdate",coordUpdate)


local int = 0
local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
coords:SetFrameLevel(90)
coords.PlayerText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.PlayerText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 0, 20)
coords.PlayerText:SetJustifyH("LEFT")
coords.PlayerText:SetText(UnitName("player")..": 0,0")

coords.MouseText = coords:CreateFontString(nil, "OVERLAY", "GameFontNormal")
coords.MouseText:SetJustifyH("LEFT")
coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
coords.MouseText:SetText(L["MAP_CURSOR"]..": 0,0")

WorldMapFrame:HookScript("OnUpdate", function(self, elapsed)
	int = int + 1
	if int >= 3 then
		local UnitMap = C_Map.GetBestMapForUnit("player")
		local x, y = 0, 0

		if UnitMap then
			local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, "player")
			if GetPlayerMapPosition then
				x, y = GetPlayerMapPosition:GetXY()
			end
		end

		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			coords.PlayerText:SetText(UnitName("player")..": "..x..","..y)
		else
			coords.PlayerText:SetText(UnitName("player")..": ".."|cffff0000"..L["MAP_BOUNDS"].."|r")
			--coords.PlayerText:SetText("")
		end

		local scale = WorldMapFrame.ScrollContainer:GetEffectiveScale()
		local width = WorldMapFrame.ScrollContainer:GetWidth()
		local height = WorldMapFrame.ScrollContainer:GetHeight()
		local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			coords.MouseText:SetText( L["MAP_CURSOR"]..adjustedX..","..adjustedY)
		else
			--coords.MouseText:SetText( L_MAP_CURSOR.."|cffff0000"..L["MAP_BOUNDS"].."|r")
			coords.MouseText:SetText( "")
		end
		int = 0
	end
end)

--Create the new minimap tracking dropdown frame and initialize it
-- local ElvUIMiniMapTrackingDropDown = CreateFrame("Frame", "ElvUIMiniMapTrackingDropDown", UIParent, "UIDropDownMenuTemplate")
-- ElvUIMiniMapTrackingDropDown:SetID(1)
-- ElvUIMiniMapTrackingDropDown:SetClampedToScreen(true)
-- ElvUIMiniMapTrackingDropDown:Hide()
-- UIDropDownMenu_Initialize(ElvUIMiniMapTrackingDropDown, MiniMapTrackingDropDown_Initialize, "MENU");
-- ElvUIMiniMapTrackingDropDown.noResize = true

-- function M:Minimap_OnMouseUp(btn)
	-- local position = self:GetPoint()
	-- if btn == "MiddleButton" or (btn == "RightButton" and IsShiftKeyDown()) then
		-- if position:match("LEFT") then
			-- E:DropDown(menuList, menuFrame)
		-- else
			-- E:DropDown(menuList, menuFrame, -160, 0)
		-- end
	-- elseif btn == "RightButton" then
		-- ToggleDropDownMenu(1, nil, ElvUIMiniMapTrackingDropDown, "cursor");
	-- else
		-- Minimap_OnClick(self)
	-- end
-- end
	
	--menuFrame:SetTemplate("Transparent", true)
	
	
	
-- local f = CreateFrame('Button', nil, UIParent)
-- f:SetSize(11,8)
-- f:SetPoint('BOTTOMLEFT', Minimap, 'BOTTOMLEFT', 0, 0)
-- f:RegisterForClicks('Anyup')
-- f:RegisterEvent('ADDON_LOADED')

-- f:SetNormalTexture('Interface\\AddOns\\QulightUI\\Root\\Media\\picomenu\\picomenuNormal')
-- f:GetNormalTexture():SetSize(11,8)

-- f:SetHighlightTexture('Interface\\AddOns\\QulightUI\\Root\\Media\\picomenu\\picomenuHighlight')
-- f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())

-- f:SetScript('OnMouseDown', function(self)
    -- self:GetNormalTexture():ClearAllPoints()
    -- self:GetNormalTexture():SetPoint('CENTER', 1, -1)
-- end)

-- f:SetScript('OnMouseUp', function(self, button)
    -- self:GetNormalTexture():ClearAllPoints()
    -- self:GetNormalTexture():SetPoint('CENTER')

    -- if (button == 'LeftButton') then
        -- if (self:IsMouseOver()) then
            -- if (DropDownList1:IsShown()) then
                -- DropDownList1:Hide()
            -- else
                -- securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
                ----DropDownList1:ClearAllPoints()
                ----DropDownList1:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT')
            -- end
        -- end
    -- else
        -- if (self:IsMouseOver()) then
            -- ToggleFrame(GameMenuFrame)
        -- end
    -- end

    -- GameTooltip:Hide()
-- end)

-- f:SetScript('OnEnter', function(self) 
    -- GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 25, -5)
    -- GameTooltip:AddLine(MAINMENU_BUTTON)
    -- GameTooltip:Show()
-- end)

-- f:SetScript('OnLeave', function() 
    -- GameTooltip:Hide()
-- end)
-- end


--Create the minimap micro menu
--local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent)
--local menuList = {
--	{text = CHARACTER_BUTTON,
--		func = function() ToggleCharacter("PaperDollFrame") end},
--	{text = SPELLBOOK_ABILITIES_BUTTON,
--		func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
--	{text = TALENTS_BUTTON,
--	func = function()
--		if not PlayerTalentFrame then
--			TalentFrame_LoadUI()
--		end

--		if not PlayerTalentFrame:IsShown() then
--			ShowUIPanel(PlayerTalentFrame)
--		else
--			HideUIPanel(PlayerTalentFrame)
--		end
--	end},
--	{text = COLLECTIONS,
--	func = function()
--		ToggleCollectionsJournal()
--	end},
--	{text = TIMEMANAGER_TITLE,
--		func = function() ToggleFrame(TimeManagerFrame) end},
--	{text = ACHIEVEMENT_BUTTON,
--		func = ToggleAchievementFrame},
--	{text = SOCIAL_BUTTON,
--		func = ToggleFriendsFrame},
--	{text = "Calendar",
--		func = function() GameTimeFrame:Click() end},
--	{text = GARRISON_LANDING_PAGE_TITLE,
--		func = function() GarrisonLandingPageMinimapButton_OnClick() end},
--	{text = ACHIEVEMENTS_GUILD_TAB,
--		func = ToggleGuildFrame},
--	{text = LFG_TITLE,
--		func = ToggleLFDParentFrame},
--	{text = ENCOUNTER_JOURNAL,
--		func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
--	{text = MAINMENU_BUTTON,
--	func = function()
--		if ( not GameMenuFrame:IsShown() ) then
--			if ( VideoOptionsFrame:IsShown() ) then
--				VideoOptionsFrameCancel:Click();
--			elseif ( AudioOptionsFrame:IsShown() ) then
--				AudioOptionsFrameCancel:Click();
--			elseif ( InterfaceOptionsFrame:IsShown() ) then
--				InterfaceOptionsFrameCancel:Click();
--			end
--			CloseMenus();
--			CloseAllWindows()
--			PlaySound(850) --IG_MAINMENU_OPEN
--			ShowUIPanel(GameMenuFrame);
--		else
--			PlaySound(854) --IG_MAINMENU_QUIT
--			HideUIPanel(GameMenuFrame);
--			MainMenuMicroButton_SetNormal();
--		end
--	end}
--}
