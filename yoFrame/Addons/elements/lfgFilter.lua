local addon, ns = ...

local L, yo, n = unpack( ns)
--local oUF = ns.oUF

local CreateFrame, CreateStyle, wipe, gmatch, pairs, LFGListSearchPanel_DoSearch, LFGListUtil_SortSearchResultsCB, print, tprint, ipairs, tremove
	= CreateFrame, CreateStyle, wipe, gmatch, pairs, LFGListSearchPanel_DoSearch, LFGListUtil_SortSearchResultsCB, print, tprint, ipairs, tremove

local UIDropDownMenu_Initialize, UIDropDownMenu_SetSelectedValue, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, table_sort
	= UIDropDownMenu_Initialize, UIDropDownMenu_SetSelectedValue, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, table.sort

local UIDROPDOWNMENU_MENU_LEVEL = UIDROPDOWNMENU_MENU_LEVEL

--GLOBALS: LFGListUtil_SortSearchResults
-------------------------------------------------------------------------------------------------------
--                                   LFG Filter
-------------------------------------------------------------------------------------------------------
local LFGListFrame = _G.LFGListFrame
local activities = {}
local rolesInfo = {
	{ -1, L.lfgDIS}, { 0, L.lfgNONE}, { 1, " = 1"}, { 2, " = 2"}, { 3, " = 3"}, { 4, " = 4"}, { 5, " = 5"}
}

local function makeDropDown( self, title)

	local userPlus, userMinus
	local userMenu = CreateFrame("Frame", nil, self.setting, "UIDropDownMenuTemplate");
	userMenu.Text:SetText( title)
	userMenu:SetWidth(150)
	--UIDropDownMenu_SetWidth(GTFO_SoundChannelDropdown, 150);
	--UIDropDownMenu_SetButtonWidth(GTFO_SoundChannelDropdown, 124);

	if title == "Activity" then --and not userMenu.initialize

		userMenu.initialize = function()
			local info = UIDropDownMenu_CreateInfo();
			info.title 		= title
			info.checked 	= nil;

			info.func   = function( this)
				UIDropDownMenu_SetSelectedValue( userMenu, this.value)
				self.setting.filter[info.title] = this.value
				LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
			end

			info.text = info.title .. L.lfgDIS
			info.value = -1
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			for activityID, activityName in pairs(activities) do
				info.text 	= activityName
				info.value 	= activityID
				info.checked 	= nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
		end
		self.setting.filter["Activity"] = -1
	else
		userMenu.initialize = function()

			local info = UIDropDownMenu_CreateInfo();
			info.title = title

			info.func   = function( this)
				UIDropDownMenu_SetSelectedValue( userMenu, this.value)
				self.setting.filter[info.title] = this.value
				LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
			end

			for id, value in ipairs( rolesInfo) do
				info.text 	= info.title .. value[2]
				info.value 	= value[1]
				info.checked 	= nil;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			self.setting.filter[info.title] = -1
		end

		userPlus = CreateFrame("CheckButton", nil, self.setting, "InterfaceOptionsCheckButtonTemplate")
		userPlus:SetPoint("LEFT", userMenu, "RIGHT", 5, 0)
		userPlus.Text:SetText( ">=")
		userPlus:SetScript("OnClick", function( this)
			self.setting.filter[title.."Plus"] = this:GetChecked()
			LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
		end)

		userMinus = CreateFrame("CheckButton", nil, self.setting, "InterfaceOptionsCheckButtonTemplate")
		userMinus:SetPoint("RIGHT", userMenu, "LEFT", -5, 0)
		userMinus.Text:SetText( "<=")
		userMinus:SetScript("OnClick", function( this)
			self.setting.filter[title.."Minus"] = this:GetChecked()
			LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
		end)
	end

	UIDropDownMenu_Initialize( userMenu, userMenu.initialize)
	UIDropDownMenu_SetSelectedValue( userMenu, -1)

	return userMenu, userPlus, userMinus
end

--local function getRUS( name)
--	print( string.gmatch( name, "([а-я])"))
--end

--local completedEncounters = C_LFGList.GetSearchResultEncounterInfo(resultID);
--if ( completedEncounters and #completedEncounters > 0 ) then
--	tooltip:AddLine(" ");
--	tooltip:AddLine(LFG_LIST_BOSSES_DEFEATED);
--	for i=1, #completedEncounters do
--		tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
--	end
--end


function LFGListUtil_SortSearchResults(results)

	if LFGListFrame.setting then
		local set = LFGListFrame.setting.filter

	 	for idx = #results, 1, -1 do
			local resultID 			= results[idx]
			local searchResultInfo 	= C_LFGList.GetSearchResultInfo(resultID)
			local members 	   		= C_LFGList.GetSearchResultMemberCounts(resultID)
			local activityID 	   	= searchResultInfo.activityID
			local fullName 		 	= C_LFGList.GetActivityInfo( activityID);
			activities[activityID] 	= fullName
			--tprint( searchResultInfo) --tprint( members) --print( members.TANK, set.Tank,  members.HEALER, set.Heal, members.DAMAGER, set.Damager)

			if 		( set.Tank 		== -1 or members.TANK 	 == set.Tank  	 or ( set.TankPlus 	  and members.TANK 	  >= set.Tank)    or ( set.TankMinus 	and members.TANK 	<= set.Tank))
				and ( set.Heal  	== -1 or members.HEALER  == set.Heal     or ( set.HealPlus 	  and members.HEALER  >= set.Heal) 	  or ( set.HealMinus 	and members.HEALER 	<= set.Heal))
				and ( set.Damager 	== -1 or members.DAMAGER == set.Damager  or ( set.DamagerPlus and members.DAMAGER >= set.Damager) or ( set.DamagerMinus	and members.DAMAGER <= set.Damager))
				and ( set.Activity 	== -1 or activityID 	 == set.Activity) 										-- or (set.ActivityPlus and leaderName and string.match( leaderName, "[а-я]"))
				then
			else
				tremove( results, idx)
			end
		end

		LFGListFrame.setting.acMenu.initialize()
	end
	table_sort(results, LFGListUtil_SortSearchResultsCB);
end

local function clearOnClick( setting)

	setting.filter["Activity"] = -1
	UIDropDownMenu_Initialize( setting.ddMenu, setting.ddMenu.initialize)
	UIDropDownMenu_SetSelectedValue( setting.ddMenu, -1)
	UIDropDownMenu_Initialize( setting.tankMenu, setting.tankMenu.initialize)
	UIDropDownMenu_SetSelectedValue( setting.tankMenu, -1)
	UIDropDownMenu_Initialize( setting.healMenu, setting.healMenu.initialize)
	UIDropDownMenu_SetSelectedValue( setting.healMenu, -1)
	UIDropDownMenu_Initialize( setting.acMenu, setting.acMenu.initialize)
	UIDropDownMenu_SetSelectedValue( setting.acMenu, -1)
	setting.tankPlus:SetChecked(false)
	setting.healPlus:SetChecked(false)
	setting.ddPlus:SetChecked(false)

	setting.tankMinus:SetChecked(false)
	setting.healMinus:SetChecked(false)
	setting.ddMinus:SetChecked(false)

	setting.filter.TankMinus 	= false
	setting.filter.HealMinus 	= false
	setting.filter.DamagerMinus	= false

	setting.filter.TankPlus 	= false
	setting.filter.HealPlus 	= false
	setting.filter.DamagerPlus 	= false
	--setting.filter.ActivityPlus = false
end

local function createLFGFrame( self)
	if not self.setting then

		local setting = CreateFrame("Frame", nil, self)
		setting:SetPoint("TOPLEFT", self, "TOPRIGHT", 10, 0)
		setting:SetSize( 250, 200)
		CreateStyle( setting, 2)
		setting.shadow:SetBackdropColor(0.075, 0.078, 0.086, 1)
		setting:Hide()
		setting.filter = {}
		self.setting = setting

		setting.tankMenu, setting.tankPlus, setting.tankMinus 	= makeDropDown( self, "Tank")
		setting.healMenu, setting.healPlus, setting.healMinus 	= makeDropDown( self, "Heal")
		setting.ddMenu,   setting.ddPlus,   setting.ddMinus 	= makeDropDown( self, "Damager")
		setting.acMenu											= makeDropDown( self, "Activity")

		setting.tankMenu:SetPoint("TOP", setting, 		   "TOP",   -10, -10)
		setting.healMenu:SetPoint("TOP", setting.tankMenu, "BOTTOM", 0, -10)
		setting.ddMenu:SetPoint("TOP", 	 setting.healMenu, "BOTTOM", 0, -10)
		setting.acMenu:SetPoint("TOP",   setting.ddMenu,   "BOTTOM", 0, -10)
		setting.acMenu.Text:SetWidth( 92)

		setting.clear = setting.clear or CreateFrame("Button", nil, setting, "UIPanelButtonTemplate")
		setting.clear:SetWidth( 140)
		setting.clear:SetHeight( 25)
		setting.clear:SetPoint("BOTTOM", setting, "BOTTOM", 0, 10)
		setting.clear:SetText( "all пох")
		setting.clear:SetScript("OnClick", function(self, ...)
			clearOnClick( setting)
			LFGListSearchPanel_DoSearch( LFGListFrame.SearchPanel)
		end)

		self.LFGListUtil_SortSearchResults = LFGListUtil_SortSearchResults

		n.CreateBorder( setting, 14, -3)
	end
end

hooksecurefunc("LFGListSearchEntry_Update", function(self, ...)
	local completedEncounters = C_LFGList.GetSearchResultEncounterInfo( self.resultID);
	if ( completedEncounters and #completedEncounters > 0 ) then
		self.Name:SetTextColor( 0.9, 0.4, 0.15);

		--	tooltip:AddLine(LFG_LIST_BOSSES_DEFEATED);
		--	for i=1, #completedEncounters do
		--		tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		--	end
	end

end)

hooksecurefunc( "LFGListCategorySelection_StartFindGroup", function()
	wipe( activities)
	clearOnClick( LFGListFrame.setting)
end)

LFGListFrame:HookScript("OnShow", createLFGFrame)
LFGListFrame.SearchPanel:HookScript("OnShow", function(self, ...) if LFGListFrame.setting then LFGListFrame.setting:Show() end end)
LFGListFrame.SearchPanel:HookScript("OnHide", function(self, ...) if LFGListFrame.setting then LFGListFrame.setting:Hide() end end)
