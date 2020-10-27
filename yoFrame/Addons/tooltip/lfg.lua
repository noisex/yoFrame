local addonName, ns = ...
local L, yo, N = unpack( ns)

-------------------------------------------------------------------------------------------------------
--                                   from PremadeGroupsFilter
-------------------------------------------------------------------------------------------------------

function OnLFGListSearchEntryOnEnter(self)
	local resultID = self.resultID
	local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
	local _, _, _, _, _, _, _, _, displayType = C_LFGList.GetActivityInfo(searchResultInfo.activityID)

	-- do not show members where Blizzard already does that
	if displayType == LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then return end
	if searchResultInfo.isDelisted or not GameTooltip:IsShown() then return end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(CLASS_ROLES)

	local roles = {}
	local classInfo = {}
	for i = 1, searchResultInfo.numMembers do
		local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i)
		classInfo[class] = {
			name = classLocalized,
			color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
		}
		if not roles[role] then roles[role] = {} end
		if not roles[role][class] then roles[role][class] = 0 end
		roles[role][class] = roles[role][class] + 1
	end

	for role, classes in pairs(roles) do
		GameTooltip:AddLine(_G[role]..": ")
		for class, count in pairs(classes) do
			local text = "   "
			if count > 1 then text = text .. count .. " " else text = text .. "   " end
			text = text .. "|c" .. classInfo[class].color.colorStr ..  classInfo[class].name .. "|r "
			GameTooltip:AddLine(text)
		end
	end
	GameTooltip:Show()
end

local buttonHooksInitialized = false
function OnLFGListFrameSetActivePanel(self, panel)
	if not buttonHooksInitialized and panel == self.SearchPanel then
		buttonHooksInitialized = true
		local buttons = self.SearchPanel.ScrollFrame.buttons
		for i = 1, #buttons do
			buttons[i]:HookScript("OnEnter", OnLFGListSearchEntryOnEnter)
		end
	end
end

hooksecurefunc("LFGListSearchEntry_OnEnter", OnLFGListSearchEntryOnEnter)
hooksecurefunc("LFGListFrame_SetActivePanel", OnLFGListFrameSetActivePanel)


-------------------------------------------------------------------------------------------------------
--                                   LFG Filter
-------------------------------------------------------------------------------------------------------

local function makeDropDown( self, title)

	local userMenu = CreateFrame("Frame", nil, self.setting, "UIDropDownMenuTemplate");
	userMenu.Text:SetText( title)
	userMenu:SetWidth(150)

	userMenu.initialize = function()

		local info = UIDropDownMenu_CreateInfo();
		info.padding 	= 8;
		info.title 		= title
		info.checked 	= nil;

		info.func   = function( this)
			UIDropDownMenu_SetSelectedValue( userMenu, this.value)
			self.setting.filter[info.title] = this.value
			LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
		end

		info.text = info.title .. " = пох"
		info.value = -1
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = info.title .. " = нет"
		info.value = 0
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = info.title .. " = 1"
		info.value = 1
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = info.title .. " = 2"
		info.value = 2
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		info.text = info.title .. " = 3"
		info.value = 3
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		self.setting.filter[info.title] = -1
	end

	UIDropDownMenu_Initialize( userMenu, userMenu.initialize)
	UIDropDownMenu_SetSelectedValue( userMenu, -1)

	local userplus = CreateFrame("CheckButton", nil, self.setting, "InterfaceOptionsCheckButtonTemplate")
	userplus:SetPoint("LEFT", userMenu, "RIGHT", 5, 0)
	userplus.Text:SetText( ">=")
	userplus:SetScript("OnClick", function( this)
		self.setting.filter[title.."Plus"] = this:GetChecked()
		LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
	end)

	return userMenu, userplus
end

function LFGListUtil_SortSearchResults(results)
	local setting = LFGListFrame.setting.filter

	 for idx = #results, 1, -1 do
		local resultID = results[idx]
		local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
		local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)
		--tprint( searchResultInfo)
		--tprint( memberCounts)
		--print( memberCounts.TANK, setting.Tank,  memberCounts.HEALER, setting.Heal, memberCounts.DAMAGER, setting.Damager)

		if ( setting.Tank and (( memberCounts.TANK == setting.Tank) or ( setting.TankPlus and memberCounts.TANK >= setting.Tank))  or setting.Tank == -1 )
			and ( setting.Heal and ((memberCounts.HEALER == setting.Heal ) or ( setting.HealPlus and memberCounts.HEALER >= setting.Heal)) or setting.Heal == -1 )
			and (setting.Damager and ((memberCounts.DAMAGER == setting.Damager ) or ( setting.DamagerPlus and memberCounts.DAMAGER >= setting.Damager)) or setting.Damager == -1)	then
		else
			table.remove( results, idx)
		end
	end
	table.sort(results, LFGListUtil_SortSearchResultsCB);
end

local function createLFGFrame( self)

	if not self.setting then
		local setting = CreateFrame("Frame", nil, self)
		setting:SetPoint("TOPLEFT", self, "TOPRIGHT", 10, 0)
		setting:SetSize( 200, 170)
		CreateStyle( setting, 2)
		setting.shadow:SetBackdropColor(0.075, 0.078, 0.086, 1)
		setting:Hide()
		setting.filter = {}
		self.setting = setting

		self.setting.tankMenu, self.setting.tankPlus = makeDropDown( self,"Tank")
		self.setting.tankMenu:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, -10)

		self.setting.healMenu, self.setting.healPlus = makeDropDown( self, "Heal")
		self.setting.healMenu:SetPoint("TOP", self.setting.tankMenu, "BOTTOM", 0, -10)

		self.setting.ddMenu, self.setting.ddPlus = makeDropDown( self, "Damager")
		self.setting.ddMenu:SetPoint("TOP", self.setting.healMenu, "BOTTOM", 0, -10)

		self.setting.clear =  CreateFrame("Button", nil, setting, "UIPanelButtonTemplate")
		self.setting.clear:SetWidth( 140)
		self.setting.clear:SetHeight( 25)
		self.setting.clear:SetPoint("BOTTOM", setting, "BOTTOM", 0, 10)
		self.setting.clear:SetText( "all пох")
		self.setting.clear:SetScript("OnClick", function(self, ...)
			UIDropDownMenu_Initialize( setting.ddMenu, setting.ddMenu.initialize)
			UIDropDownMenu_SetSelectedValue( setting.ddMenu, -1)
			UIDropDownMenu_Initialize( setting.tankMenu, setting.tankMenu.initialize)
			UIDropDownMenu_SetSelectedValue( setting.tankMenu, -1)
			UIDropDownMenu_Initialize( setting.healMenu, setting.healMenu.initialize)
			UIDropDownMenu_SetSelectedValue( setting.healMenu, -1)
			setting.tankPlus:SetChecked(false)
			setting.healPlus:SetChecked(false)
			setting.ddPlus:SetChecked(false)
			setting.filter.TankPlus = false
			setting.filter.HealPlus = false
			setting.filter.DamagerPlus = false

			LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
		end)

		self.LFGListUtil_SortSearchResults = LFGListUtil_SortSearchResults

		N.CreateBorder( setting, 14, -3)
	end
end

LFGListFrame:HookScript("OnShow", createLFGFrame)
LFGListFrame.SearchPanel:HookScript("OnShow", function(self, ...) LFGListFrame.setting:Show() end)
LFGListFrame.SearchPanel:HookScript("OnHide", function(self, ...) LFGListFrame.setting:Hide() end)

--lfg:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
--lfg:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED")
--lfg:RegisterEvent("LFG_LIST_SEARCH_FAILED")
--lfg:RegisterEvent("ADDON_LOADED")
----lfg:RegisterEvent("CHAT_MSG_ADDON")
----lfg:RegisterEvent("CHAT_MSG_SYSTEM")
----lfg:RegisterEvent("PLAYER_LOGIN")
--lfg:RegisterEvent("GROUP_ROSTER_UPDATE")

--lfg:SetScript("OnEvent", onEvent)


--function LFGListUtil_FilterSearchResults(results, filteredIDs)
--	print( i, id)
--	for i, id in ipairs(filteredIDs) do
--		print( i, id)
--		for j = #results, 1, -1 do
--			if ( results[j] == id ) then
--				tremove(results, j);
--				break;
--			end
--		end
--	end
--end

--    HybridScrollFrame_CreateButtons(self.ScrollFrame, "LFGListSearchEntryTemplate");



--local function onEvent( self, event, ...)

--	if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
--		print( event, LFGListFrame.SearchPanel.filters or LFGListFrame.CategorySelection.selectedFilters)
--		local numResults, results = C_LFGList.GetSearchResults()
--		self.LFGListUtil_SortSearchResults(results)
--		for k, v in pairs(results) do
--			local id, activityID, name, comment, PH, voiceChat, iLvl, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoInv = C_LFGList.GetSearchResultInfo(results[k])
--			--tprint( id)

--			--print(id, activityID, name, comment, PH, voiceChat, iLvl, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoInv)
--		end
--	elseif event == "LFG_LIST_SEARCH_RESULT_UPDATED" then

--	end
--end


--local function myFunc( self)
--	--print( self.selectedValue)
--end