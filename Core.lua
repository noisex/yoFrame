local L, yo = unpack( select( 2, ...))

local function loginEvent(self, ...)
	resolution = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")
	getscreenwidth, getscreenheight = GetPhysicalScreenSize() --DecodeResolution(resolution)


	if yo.Media.AutoScale == "manual" then
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", yo.Media.ScaleRate)
		UIParent:SetScale( yo.Media.ScaleRate)

	elseif yo.Media.AutoScale == "auto" then

		if getscreenwidth < 1024 and GetCVar("gxMonitor") == "0" then
			SetCVar("useUiScale", 0)
			StaticPopup_Show("DISABLE_UI")
		elseif getscreenwidth == 1366 and getscreenheight == 768 then
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.82)
			UIParent:SetScale( 0.82)
		elseif getscreenwidth < 1900 then
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.75)
			UIParent:SetScale( 0.75)
		elseif getscreenwidth >= 1900 and getscreenheight == 1080 then
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.7)
			UIParent:SetScale( 0.7)
		else
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.64)
			UIParent:SetScale( 0.64)

			-- Hack for 4K and WQHD Resolution
			local customScale = min(2, max(0.32, 768 / string.match(resolution, "%d+x(%d+)")))
			if customScale < 0.64 then
				UIParent:SetScale(customScale)
			elseif customScale < 0.64 then
				UIParent:SetScale( 0.64)
			end
		end
	else
		SetCVar("useUiScale", 0)
		--SetCVar("uiScale", 0.64)
		--UIParent:SetScale( 0.64)
	end

	if yo.General.scriptErrors == true then
		SetCVar("scriptErrors", 1)
	else
		SetCVar("scriptErrors", 0)
	end

	SetCVar("alwaysShowActionBars", 1)

	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatDamage", 0)
	SetCVar("buffDurations",1)

	SetCVar("screenshotQuality", 10)
	SetCVar("showTutorials", 0)
	SetCVar("cameraSmoothStyle", 1)

	SetCVar("cameraDistanceMaxZoomFactor", 2.6)

	SetCVar("TargetNearestUseNew", 1)
	SetCVar("TargetPriorityCombatLock", 0)
	SetCVar("TargetPriorityCombatLockContextualRelaxation", 0)
	SetCVar("countdownForCooldowns", 0)
	SetCVar("showTargetOfTarget", 1)

	SetCVar("nameplateShowSelf", 0)
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemyMinus", 1)
	SetCVar("nameplateShowEnemyMinions", 1)

	SetCVar("autoLootDefault", 1)
	SetCVar("doNotFlashLowHealthWarning", 1)
end

local function InterfaceOptions_UpdateMultiActionBars()
	SHOW_MULTI_ACTIONBAR_1 = 1
----	SHOW_MULTI_ACTIONBAR_2 = 1
	SHOW_MULTI_ACTIONBAR_3 = 1
----	SHOW_MULTI_ACTIONBAR_4 = 1
	ALWAYS_SHOW_MULTIBARS  = 1

	if ( SHOW_MULTI_ACTIONBAR_1 == "0" ) then
		SHOW_MULTI_ACTIONBAR_1 = nil;
	end

	if ( SHOW_MULTI_ACTIONBAR_2 == "0" ) then
		SHOW_MULTI_ACTIONBAR_2 = nil;
	end

	if ( SHOW_MULTI_ACTIONBAR_3 == "0" ) then
		SHOW_MULTI_ACTIONBAR_3 = nil;
	end

	if ( SHOW_MULTI_ACTIONBAR_4 == "0" ) then
		SHOW_MULTI_ACTIONBAR_4 = nil;
	end

	if ( ALWAYS_SHOW_MULTIBARS == "0" ) then
		ALWAYS_SHOW_MULTIBARS = nil;
	end

	if ( LOCK_ACTIONBAR == "0" ) then
		LOCK_ACTIONBAR = nil;
	end

	SetActionBarToggles(not not SHOW_MULTI_ACTIONBAR_1, not not SHOW_MULTI_ACTIONBAR_2, not not SHOW_MULTI_ACTIONBAR_3, not not SHOW_MULTI_ACTIONBAR_4, not not ALWAYS_SHOW_MULTIBARS);
	MultiActionBar_Update();
	UIParent_ManageFramePositions();
	StatusTrackingBarManager:UpdateBarTicks();
end

local function enterEvent( self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	mySpec = GetSpecialization()
	myRole = UnitGroupRolesAssigned( "player")

	local function GameTooltipDefault(tooltip, parent)
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", yo_MoveToolTip, "BOTTOMRIGHT", 0, 0)
		tooltip.default = 1
	end
	hooksecurefunc("GameTooltip_SetDefaultAnchor", GameTooltipDefault)

	CreatePanel( RightDataPanel, 440, 175, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 3, 0.5, 0)
	CreateStyle( RightDataPanel, 3, 0, 0, 0.7)

	CreatePanel( LeftDataPanel, 440, 175, "BOTTOMLEFT", yo_MoveLeftPanel, "BOTTOMLEFT", 0, 0, 0.5, 0)
	CreateStyle( LeftDataPanel, 3, 0, 0, 0.7)

	SimpleBackground( RightInfoPanel, 440, 15, "BOTTOM", RightDataPanel, "BOTTOM", 0, 0)
	CreateStyle( RightInfoPanel, 3, 0)

	SimpleBackground( LeftInfoPanel, 440, 15, "BOTTOM", LeftDataPanel, "BOTTOM", 0, 0)
	CreateStyle( LeftInfoPanel, 3, 0)

	if not yo.Addons.BlackPanels then RightDataPanel:Hide() LeftDataPanel:Hide() end
	if not yo.Addons.InfoPanels  then RightInfoPanel:Hide() LeftInfoPanel:Hide() end

	InterfaceOptions_UpdateMultiActionBars ()
end

local function OnEvent( self, event, ...)

	if event == "PLAYER_LOGIN" then
		loginEvent( self)
	elseif event == "PLAYER_ROLES_ASSIGNED" then
		myRole = UnitGroupRolesAssigned( "player")
	elseif event == "PLAYER_ENTERING_WORLD" then
		enterEvent( self)
	end

end

LeftInfoPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
LeftDataPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightDataPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightInfoPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")

local csf = CreateFrame("Frame")
csf:RegisterEvent("PLAYER_LOGIN")
csf:RegisterEvent("PLAYER_ENTERING_WORLD")
csf:RegisterEvent("PLAYER_ROLES_ASSIGNED")

csf:SetScript("OnEvent", OnEvent)

-----------------------------------------------------------------------------------------

--print(" ")
--print("|cFF00A2FF/yo |r - Command for change all UI positions.")
--print("|cFF00A2FF/yo reset |r - Set default UFrames positions.")
--print("|cFF00A2FF/rl |r - Command to reload UI ( ReloadUI).")
--print("|cFF00A2FF/kb |r - Command to ActionBar KeyBinding.")
--print("|cFF00A2FF/cfg |r - Ingame UI config.")

SlashCmdList["YOMOVE"] = ySlashCmd;
SLASH_YOMOVE1 = "/yo";
SLASH_YOMOVE2 = "/нщ";
SLASH_YOMOVE3 = "/move";
SLASH_YOMOVE4 = "/ьщму";

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = "/кд"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"
SLASH_RCSLASH2 = "/кс"

----------------------------------------------------------------------------------------
--	Clear chat
----------------------------------------------------------------------------------------
SlashCmdList.CLEAR_CHAT = function()
	for i = 1, NUM_CHAT_WINDOWS do
		_G[format("ChatFrame%d", i)]:Clear()
	end
end
SLASH_CLEAR_CHAT1 = "/clear"
SLASH_CLEAR_CHAT2 = "/сдуфк"
