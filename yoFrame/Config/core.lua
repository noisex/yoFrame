local L, yo = unpack( select( 2, ...))

LeftInfoPanel  = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
LeftDataPanel  = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightDataPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
RightInfoPanel = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")

local function enterEvent( self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	mySpec = GetSpecialization()
	myRole = UnitGroupRolesAssigned( "player")

	SetCVar("multiBarRightVerticalLayout", 0)  -- уменьшает 4 и 5 бары, если включено

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

	----------------------------------------------------------------------------------------
	--	Tooltip replace
	----------------------------------------------------------------------------------------
	local function GameTooltipDefault(tooltip, parent)
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", yo_MoveToolTip, "BOTTOMRIGHT", 0, 0)
		tooltip.default = 1
	end
	hooksecurefunc("GameTooltip_SetDefaultAnchor", GameTooltipDefault)

	hooksecurefunc( "CloseAllWindows", checkToClose)
	--C_Timer.After( 2, function() buttonsUP(self) end )
end

local function OnEvent( self, event, ...)

	if event == "PLAYER_ROLES_ASSIGNED" then
		myRole = UnitGroupRolesAssigned( "player")
	elseif event == "PLAYER_ENTERING_WORLD" then
		enterEvent( self)
	elseif event == "PLAYER_REGEN_ENABLED" then
		--self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		--buttonsUP( self)
	end

end

local csf = CreateFrame("Frame")
csf:RegisterEvent("PLAYER_ENTERING_WORLD")
csf:RegisterEvent("PLAYER_ROLES_ASSIGNED")
--csf:RegisterEvent("PLAYER_REGEN_ENABLED")

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
SLASH_CLEAR_CHAT3 = "/cl"
