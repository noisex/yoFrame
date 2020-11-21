local L, yo, N = unpack( select( 2, ...))

LeftInfoPanel  = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
LeftDataPanel  = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightDataPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightInfoPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")

N.infoTexts.LeftInfoPanel  = LeftInfoPanel
N.infoTexts.LeftDataPanel  = LeftDataPanel
N.infoTexts.RightDataPanel = RightDataPanel
N.infoTexts.RightInfoPanel = RightInfoPanel

CreatePanel( RightDataPanel, 440, 175, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 3, 0.5, 0)
CreateStyle( RightDataPanel, 3, 0, 0, 0.7)

CreatePanel( LeftDataPanel, 440, 175, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 3, 0.5, 0)
CreateStyle( LeftDataPanel, 3, 0, 0, 0.7)

SimpleBackground( RightInfoPanel, 440, 15, "BOTTOM", RightDataPanel, "BOTTOM", 0, 0)
CreateStyle( RightInfoPanel, 3, 0)

SimpleBackground( LeftInfoPanel, 440, 15, "BOTTOM", LeftDataPanel, "BOTTOM", 0, 0)
CreateStyle( LeftInfoPanel, 3, 0)

if not yo.Addons.BlackPanels then RightDataPanel:Hide() LeftDataPanel:Hide() end
if not yo.Addons.InfoPanels  then RightInfoPanel:Hide() LeftInfoPanel:Hide() end

AlertFrame:ClearAllPoints()
AlertFrame:SetPoint("TOPLEFT", UIParent, "CENTER", 0, -150)
AlertFrame.ClearAllPoints = dummy
AlertFrame.SetPoint = dummy

local function enterEvent( self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	mySpec = GetSpecialization()
	myRole = UnitGroupRolesAssigned( "player")

	SetCVar("countdownForCooldowns", 0)
	SetCVar("multiBarRightVerticalLayout", 0)  -- уменьшает 4 и 5 бары, если включено

	hooksecurefunc( "CloseAllWindows", checkToClose)
	--C_Timer.After( 2, function() buttonsUP(self) end )
end

local function OnEvent( self, event, ...)

	if event == "PLAYER_ROLES_ASSIGNED" then
		myRole = UnitGroupRolesAssigned( "player")
	elseif event == "PLAYER_ENTERING_WORLD" then
		enterEvent( self)
	elseif event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN" then
		dprint(event, ...)
	elseif event == "PLAYER_LEVEL_UP" then
		myLevel = UnitLevel("player")
	end

end

local csf = CreateFrame("Frame")
csf:RegisterEvent("PLAYER_ENTERING_WORLD")
csf:RegisterEvent("PLAYER_ROLES_ASSIGNED")
csf:RegisterEvent("PLAYER_LEVEL_UP")
csf:RegisterEvent("ADDON_ACTION_BLOCKED")
csf:RegisterEvent("ADDON_ACTION_FORBIDDEN")

csf:SetScript("OnEvent", OnEvent)

-----------------------------------------------------------------------------------------

--print(" ")
--print("|cFF00A2FF/yo |r - Command for change all UI positions.")
--print("|cFF00A2FF/yo reset |r - Set default UFrames positions.")
--print("|cFF00A2FF/rl |r - Command to reload UI ( ReloadUI).")
--print("|cFF00A2FF/kb |r - Command to ActionBar KeyBinding.")
--print("|cFF00A2FF/cfg |r - Ingame UI config.")

SlashCmdList["YOMOVE"] = ySlashCmd
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
SLASH_CLEAR_CHAT3 = "/cl"

----------------------------------------------------------------------------------------
--	Test Blizzard Alerts
----------------------------------------------------------------------------------------

SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound(SOUNDKIT.LFG_REWARDS)
	if not AchievementFrame then
		AchievementFrame_LoadUI()
	end
	AchievementAlertSystem:AddAlert(112)
	CriteriaAlertSystem:AddAlert(9023, "Doing great!")
	GuildChallengeAlertSystem:AddAlert(3, 2, 5)
	InvasionAlertSystem:AddAlert(678, DUNGEON_FLOOR_THENEXUS1, true, 1, 1)
	WorldQuestCompleteAlertSystem:AddAlert(AlertFrameMixin:BuildQuestData(42114))
	---- GarrisonFollowerAlertSystem:AddAlert(32, "Dagg", 90, 2, true, C_Garrison.GetFollowerInfo(32)) -- error when mouseover
	---- GarrisonShipFollowerAlertSystem:AddAlert(592, "Ship", "Transport", "GarrBuilding_Barracks_1_H", 3, 2, 1) -- error when mouseover
	GarrisonBuildingAlertSystem:AddAlert(GARRISON_CACHE)
	----GarrisonTalentAlertSystem:AddAlert(3, _G.C_Garrison.GetTalent(370))
	----LegendaryItemAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832:0:0:0:0:0:0:0:0:0:0\124h[Brutality Blade]\124h\124r")
	----LootAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832::::::::::\124h[Brutality Blade]\124h\124r", 1, 1, 100, 2, false, false, 0, false, false)
	LootUpgradeAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832::::::::::\124h[Brutality Blade]\124h\124r", 1, 1, 1, nil, nil, false)
	MoneyWonAlertSystem:AddAlert(81500)
	EntitlementDeliveredAlertSystem:AddAlert("", "Interface\\Icons\\Ability_pvp_gladiatormedallion", TRINKET0SLOT, 214)
	RafRewardDeliveredAlertSystem:AddAlert("", "Interface\\Icons\\Ability_pvp_gladiatormedallion", TRINKET0SLOT, 214)
	DigsiteCompleteAlertSystem:AddAlert("Human")
	NewRecipeLearnedAlertSystem:AddAlert(204)
	---- BonusRollFrame_StartBonusRoll(242969, 'test', 20, 515, 15, 14)
end
SLASH_TEST_ACHIEVEMENT1 = "/tach"
SLASH_TEST_ACHIEVEMENT2 = "/ефср"