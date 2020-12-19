local addon, ns = ...

local L, yo, n = unpack( ns)
--local oUF = ns.oUF

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

	if LFGListFrame.setting then
		local setting = LFGListFrame.setting.filter

	 	for idx = #results, 1, -1 do
			local resultID = results[idx]
			local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
			local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)
			--tprint( searchResultInfo)
			--tprint( memberCounts)
			--print( memberCounts.TANK, setting.Tank,  memberCounts.HEALER, setting.Heal, memberCounts.DAMAGER, setting.Damager)

			if 		( setting.Tank 		and (( memberCounts.TANK 	== setting.Tank) 		or ( setting.TankPlus 	 and memberCounts.TANK 		>= setting.Tank))  		or setting.Tank 	== -1)
				and ( setting.Heal 		and (( memberCounts.HEALER 	== setting.Heal) 		or ( setting.HealPlus 	 and memberCounts.HEALER 	>= setting.Heal)) 		or setting.Heal  	== -1)
				and ( setting.Damager 	and (( memberCounts.DAMAGER == setting.Damager) 	or ( setting.DamagerPlus and memberCounts.DAMAGER 	>= setting.Damager)) 	or setting.Damager 	== -1)	then
			else
				table.remove( results, idx)
			end
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

		self.setting.tankMenu, self.setting.tankPlus = makeDropDown( self, "Tank")
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

		n.CreateBorder( setting, 14, -3)
	end
end

LFGListFrame:HookScript("OnShow", createLFGFrame)
LFGListFrame.SearchPanel:HookScript("OnShow", function(self, ...) if LFGListFrame.setting then LFGListFrame.setting:Show() end end)
LFGListFrame.SearchPanel:HookScript("OnHide", function(self, ...) if LFGListFrame.setting then LFGListFrame.setting:Hide() end end)
