local L, yo = unpack( select( 2, ...))

local function loginEvent(self, ...)
	resolution = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")
	getscreenwidth, getscreenheight = DecodeResolution(resolution)


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
	--Рекомендуем поставить значение чуть выше чем Ваш пинг, например, если пинг 60 — поставьте /console SpellQueueWindow 100
	SetCVar("nameplateOccludedAlphaMult",1)
	SetCVar("nameplateMinScale",1)
    --SetCVar("nameplateMaxScale",1)
	SetCVar("nameplateShowFriendlyNPCs", 0)
	
	SetCVar("nameplateOverlapH",  0.8) 	--default is 0.8
	SetCVar("nameplateOverlapV",  2) 	--default is 1.5
	SetCVar("nameplateTargetRadialPosition", 1)
	SetCVar("nameplateMotion", 1)

	SetCVar("nameplateMaxDistance", 40)	
	SetCVar("nameplateMaxAlpha", 0.7)
	SetCVar("nameplateMinAlpha", 0.2)
	SetCVar("nameplateMaxAlphaDistance", 100)
	SetCVar("nameplateMinAlphaDistance", -30)

	SetCVar("nameplateSelectedAlpha", 1)
	SetCVar("nameplateSelectedScale", 1.15)


	SetCVar( "nameplateOtherTopInset", 0.1)
	SetCVar( "nameplateOtherBottomInset", -1)

	SetCVar( "nameplateLargeTopInset", 0.1)
	SetCVar( "nameplateLargeBottomInset", -1)

	SetCVar( "nameplateSelfTopInset", 0.1)
	SetCVar( "nameplateSelfBottomInset", -1)

	--["nameplateMaxDistance"] = { prettyName = "Nameplate Distance", description = "The max distance to show nameplates.", type = "number" },
	--["nameplateTargetBehindMaxDistance"] = { prettyName = "Nameplate Target Behind Distance", description = "The max distance to show the target nameplate when the target is behind the camera.", type = "number" },

	--["nameplateMinAlphaDistance"] = { prettyName = "Nameplate Min Alpha Distance", description = "The distance from the max distance that nameplates will reach their minimum alpha.", type = "number" },
	--["nameplateMaxAlphaDistance"] = { prettyName = "Nameplate Max Alpha Distance", description = "The distance from the camera that nameplates will reach their maximum alpha.", type = "number" },
	
	--["nameplateOtherBottomInset"] = { prettyName = "Nameplate Other Bottom Inset", description = "The inset from the bottom (in screen percent) that the non-self nameplates are clamped to.", type = "number" },
	--["nameplateOtherTopInset"] = { prettyName = "Nameplate Other Top Inset", description = "The inset from the top (in screen percent) that the non-self nameplates are clamped to.", type = "number" },
	--["nameplateLargeBottomInset"] = { prettyName = "Nameplate Large Bottom Inset", description = "The inset from the bottom (in screen percent) that large nameplates are clamped to.", type = "number" },
	--["nameplateLargeTopInset"] = { prettyName = "Nameplate Large Top Inset", description = "The inset from the top (in screen percent) that large nameplates are clamped to.", type = "number" },
	
	--["nameplateTargetRadialPosition"] = { prettyName = nil, description = "When target is off screen, position its nameplate radially around sides and bottom", type = "number"},

	SetCVar("alwaysShowActionBars", 1)

	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatDamage", 0)
	SetCVar("ShowClassColorInNameplate", 1)
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
	

	local hiddenOptions = {
		["showTargetOfTarget"] = 				{ description = OPTION_TOOLTIP_SHOW_TARGET_OF_TARGET, type = "boolean" },
		["TargetNearestUseNew"] = 				{ description = "Use 7.2 'nearest target' functionality", type = "boolean" },
		--["TargetPriorityAllowAnyOnScreen"] = 	{ description = "If set, and no 100% correct target is available, allow selecting any valid in-range target (2 = also out-of-range)", type = "boolean" },
		["TargetPriorityCombatLock"] = 			{ description = "1=Lock to in-combat targets when starting from an in-combat target. 2=Further restrict to in-combat with player.", type = "boolean" },
		["TargetPriorityCombatLockHighlight"] = { description = "1=Lock to in-combat targets when starting from an in-combat target. 2=Further restrict to in-combat with player. (while doing hold-to-target)", type = "boolean" },
		--["TargetPriorityHoldHighlightDelay"] = 	{ description = "Delay in Milliseconds before priority target highlight starts when holding the button", type = "number" },
		--["TargetPriorityIncludeBehind"] = 		{ description = "If set, include target's behind the player in priority target selection", type = "boolean" },
		["TargetPriorityCombatLockContextualRelaxation"] = { description = "1=Enables relaxation of combat lock based on context (eg. no in-combat target infront)", type = "number" },
	}	
end

local function enterEvent( self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	myRole = UnitGroupRolesAssigned( "player")

	local function GameTooltipDefault(tooltip, parent)
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", yo_MoveToolTip, "BOTTOMRIGHT", 0, 0)
		tooltip.default = 1
	end
	hooksecurefunc("GameTooltip_SetDefaultAnchor", GameTooltipDefault)

	if yo.Addons.unitFrames then
	
		plFrame = CreateFrame("Button", "yo_Player", UIParent, "SecureUnitButtonTemplate") 
		plFrame:SetPoint( "CENTER", yo_MovePlayer, "CENTER", 0 , 0)
		plFrame:SetSize( yo_MovePlayer:GetSize())
		plFrame.unit = "player"
		CreateUFrame( plFrame, plFrame.unit)

		tarFrame = CreateFrame("Button", "yo_Target", UIParent, "SecureUnitButtonTemplate") 
		tarFrame:SetPoint( "CENTER", yo_MoveTarget, "CENTER", 0 , 0)
		tarFrame:SetSize( yo_MoveTarget:GetSize())
		tarFrame.unit = "target"
		CreateUFrame( tarFrame, tarFrame.unit)

		totFrame = CreateFrame("Button", "yo_TarTar", UIParent, "SecureUnitButtonTemplate") 
		totFrame:SetPoint( "TOPLEFT", yo_MoveTarget, "TOPRIGHT", 8 , 0)
		totFrame:SetSize( 100, 25)
		totFrame.unit = "targettarget"
		CreateUFrame( totFrame, totFrame.unit)

		fcFrame = CreateFrame("Button", "yo_Focus", UIParent, "SecureUnitButtonTemplate") 
		fcFrame:SetPoint( "CENTER", yo_MoveFocus, "CENTER", 0 , 0)
		fcFrame:SetSize( yo_MoveFocus:GetSize())
		fcFrame.unit = "focus"
		CreateUFrame( fcFrame, fcFrame.unit)

		petFrame = CreateFrame("Button", "yo_Pet", UIParent, "SecureUnitButtonTemplate") 
		petFrame:SetPoint( "TOPRIGHT", yo_MovePlayer, "TOPLEFT", -8 , 0)
		petFrame:SetSize( 100, 25)
		petFrame.unit = "pet"
		CreateUFrame( petFrame, petFrame.unit)

		for i = 1, MAX_BOSS_FRAMES do
			local bFrame = "boss"..i.."Frame"
			bFrame = CreateFrame("Button", "yo_Boss" .. i, UIParent, "SecureUnitButtonTemplate") 
			bFrame.unit = "boss"..i
			bFrame:SetPoint( "CENTER", yo_MoveBoss, "CENTER", 0 , -( i -1) * 62)
			bFrame:SetSize( yo_MoveBoss:GetSize())
			CreateUFrame(  bFrame, bFrame.unit)
		end
	end

	CreatePanel( RightDataPanel, 440, 175, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 3, 0.5, 0)
	CreateStyle( RightDataPanel, 3, 0, 0, 0.7)

	CreatePanel( LeftDataPanel, 440, 175, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 3, 0.5, 0)
	CreateStyle( LeftDataPanel, 3, 0, 0, 0.7)

	SimpleBackground( RightInfoPanel, 440, 15, "BOTTOM", RightDataPanel, "BOTTOM", 0, 0)
	CreateStyle( RightInfoPanel, 3, 0)

	SimpleBackground( LeftInfoPanel, 440, 15, "BOTTOM", LeftDataPanel, "BOTTOM", 0, 0)
	CreateStyle( LeftInfoPanel, 3, 0)
	
	if not yo.Addons.BlackPanels then 
		RightDataPanel:Hide()
		LeftDataPanel:Hide()
	end
	if not yo.Addons.InfoPanels then 
		RightInfoPanel:Hide()
		LeftInfoPanel:Hide()
		--LeftInfoPanel:UnregisterAllEvents()
		--LeftInfoPanel = nil
	end
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

LeftInfoPanel = CreateFrame("Frame", nil, UIParent)
LeftDataPanel = CreateFrame("Frame", nil, UIParent)
RightDataPanel = CreateFrame("Frame", nil, UIParent)
RightInfoPanel = CreateFrame("Frame", nil, UIParent)

SlashCmdList["YOMOVE"] = ySlashCmd;
SLASH_YOMOVE1 = "/yo";
SLASH_YOMOVE2 = "/нщ";

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
