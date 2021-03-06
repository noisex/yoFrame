local L, yo, n = unpack( select( 2, ...))

if not yo.Bags.enable then return end

local _G = _G
local type, ipairs, pairs, unpack, select, assert, pcall = type, ipairs, pairs, unpack, select, assert, pcall
local tinsert = table.insert
--local _G.BankFrame = _G.BankFrame
local floor, ceil, abs, mod = math.floor, math.ceil, math.abs, math.fmod
local format, len, sub = string.format, string.len, string.sub
local BankFrameItemButton_Update = BankFrameItemButton_Update
local BankFrameItemButton_UpdateLocked = BankFrameItemButton_UpdateLocked
local C_NewItems_IsNewItem = C_NewItems.IsNewItem
local Search = n.LIBS.Search
local defcol = 0.17
LE_ITEM_QUALITY_POOR = 0

local CreateFrame, CreateStyle, UIParent, CreateStyleSmall, GameTooltip, GetContainerNumSlots, GetItemInfo, GetContainerItemLink, GetContainerItemInfo, GetItemQualityColor, SetItemButtonTexture, SetItemButtonCount
	= CreateFrame, CreateStyle, UIParent, CreateStyleSmall, GameTooltip, GetContainerNumSlots, GetItemInfo, GetContainerItemLink, GetContainerItemInfo, GetItemQualityColor, SetItemButtonTexture, SetItemButtonCount

local tostring, PlaySound, GetBankSlotCost, GetNumBankSlots, IsShiftKeyDown, print, IsControlKeyDown, UnitClass, GetLocale, wipe, next, yoDelay, InCombatLockdown, SetItemButtonDesaturated, SetBankBagSlotFlag, SetBagSlotFlag
	= tostring, PlaySound, GetBankSlotCost, GetNumBankSlots, IsShiftKeyDown, print, IsControlKeyDown, UnitClass, GetLocale, wipe, next, yoDelay, InCombatLockdown, SetItemButtonDesaturated, SetBankBagSlotFlag, SetBagSlotFlag

local SetUpAnimGroup, UIDropDownMenu_CreateInfo, IsInventoryItemProfessionBag, ContainerIDToInventoryID, UIDropDownMenu_AddButton, GetBagSlotFlag, GetBankBagSlotFlag, GetBagSlotFlag, GetBankAutosortDisabled, GetBackpackAutosortDisabled
	= SetUpAnimGroup, UIDropDownMenu_CreateInfo, IsInventoryItemProfessionBag, ContainerIDToInventoryID, UIDropDownMenu_AddButton, GetBagSlotFlag, GetBankBagSlotFlag, GetBagSlotFlag, GetBankAutosortDisabled, GetBackpackAutosortDisabled

local SetBankAutosortDisabled, SetBackpackAutosortDisabled, EquipItemByName, ConfirmBindOnUse, C_NewItems_RemoveNewItem, C_NewItems_IsNewItem, GetInventoryItemsForSlot, GetContainerItemQuestInfo, GetContainerItemCooldown
	= SetBankAutosortDisabled, SetBackpackAutosortDisabled, EquipItemByName, ConfirmBindOnUse, C_NewItems.RemoveNewItem, C_NewItems.IsNewItem, GetInventoryItemsForSlot, GetContainerItemQuestInfo, GetContainerItemCooldown

local CooldownFrame_Set, SetItemButtonTextureVertexColor, SetItemButtonQuality, frame1px, ToggleDropDownMenu, PutItemInBag, PutItemInBackpack, CloseBankBagFrames, CloseBankFrame, SortBags
	= CooldownFrame_Set, SetItemButtonTextureVertexColor, SetItemButtonQuality, frame1px, ToggleDropDownMenu, PutItemInBag, PutItemInBackpack, CloseBankBagFrames, CloseBankFrame, SortBags

local GetCVarBitfield, IsReagentBankUnlocked, DepositReagentBank, GetContainerNumFreeSlots, ReagentButtonInventorySlot, BankFrameItemButton_OnEnter, HelpTip, Kill, BankFrameTab2, UIDropDownMenu_Initialize, Setlers
	= GetCVarBitfield, IsReagentBankUnlocked, DepositReagentBank, GetContainerNumFreeSlots, ReagentButtonInventorySlot, BankFrameItemButton_OnEnter, HelpTip, Kill, BankFrameTab2, UIDropDownMenu_Initialize, Setlers

local SortBankBags, SortReagentBankBags, PurchaseSlot, SetInsertItemsLeftToRight, SetSortBagsRightToLeft, StaticPopupDialogs, HideUIPanel, MoneyFrame_Update, StaticPopup_Show, hooksecurefunc, ToggleFrame
	= SortBankBags, SortReagentBankBags, PurchaseSlot, SetInsertItemsLeftToRight, SetSortBagsRightToLeft, StaticPopupDialogs, HideUIPanel, MoneyFrame_Update, StaticPopup_Show, hooksecurefunc, ToggleFrame

local BANK = BANK
local SEARCH_STRING
local SEARCH = SEARCH
local BAGSLOTTEXT = BAGSLOTTEXT
local KEY_BUTTON2 = KEY_BUTTON2
local REAGENT_BANK = REAGENT_BANK
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local BAG_CLEANUP_BANK = BAG_CLEANUP_BANK
local BAG_CLEANUP_BAGS = BAG_CLEANUP_BAGS
local AUTO_ACTIVATE_ON = AUTO_ACTIVATE_ON
local REAGENT_BANK_HELP = REAGENT_BANK_HELP
local BAG_FILTER_IGNORE = BAG_FILTER_IGNORE
local BANK_BAG_PURCHASE = BANK_BAG_PURCHASE
local BAG_FILTER_CLEANUP = BAG_FILTER_CLEANUP
local REAGENTBANK_DEPOSIT = REAGENTBANK_DEPOSIT
local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES
local BAG_SETTINGS_TOOLTIP = BAG_SETTINGS_TOOLTIP
local CONFIRM_BUY_BANK_SLOT = CONFIRM_BUY_BANK_SLOT
local REAGENTBANK_CONTAINER = REAGENTBANK_CONTAINER
local STATICPOPUP_NUMDIALOGS = STATICPOPUP_NUMDIALOGS
local NUM_LE_BAG_FILTER_FLAGS = NUM_LE_BAG_FILTER_FLAGS
local LE_BAG_FILTER_FLAG_JUNK = LE_BAG_FILTER_FLAG_JUNK
local BAG_CLEANUP_REAGENT_BANK = BAG_CLEANUP_REAGENT_BANK
local LE_BAG_FILTER_FLAG_EQUIPMENT = LE_BAG_FILTER_FLAG_EQUIPMENT
local LE_BAG_FILTER_FLAG_IGNORE_CLEANUP = LE_BAG_FILTER_FLAG_IGNORE_CLEANUP
local LE_FRAME_TUTORIAL_REAGENT_BANK_UNLOCK = LE_FRAME_TUTORIAL_REAGENT_BANK_UNLOCK

-- GLOBALS: LE_ITEM_QUALITY_POOR, ReagentBankFrameItem1, ToggleBackpack, ToggleBag, ToggleAllBags, OpenAllBags, OpenBackpack, CloseBackpack, CloseAllBags

n.bags = CreateFrame("Frame", "yo_Bags", UIParent)
local addon = n.bags
--addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

local ElvUIAssignBagDropdown = CreateFrame("Frame", "ElvUIAssignBagDropdown", UIParent, "UIDropDownMenuTemplate")
ElvUIAssignBagDropdown:SetID(1)
ElvUIAssignBagDropdown:SetClampedToScreen(true)
ElvUIAssignBagDropdown:Hide()

local ProfessionColors = {
	[0x0008]   = {224/255, 187/255, 74/255},  -- Leatherworking
	[0x0010]   = {74/255, 77/255, 224/255},   -- Inscription
	[0x0020]   = {18/255, 181/255, 32/255},   -- Herbs
	[0x0040]   = {194/255, 4/255, 204/255},   -- Enchanting
	[0x0080]   = {232/255, 118/255, 46/255},  -- Engineering
	[0x0200]   = {8/255, 180/255, 207/255},   -- Gems
	[0x0400]   = {138/255, 103/255, 9/255},   -- Mining
	[0x8000]   = {107/255, 150/255, 255/255}, -- Fishing
	[0x010000] = {222/255, 13/255,  65/255},  -- Cooking
}

local AssignmentColors = {
	[0] = {252/255, 59/255, 54/255}, -- fallback
	[2] = {0/255, 127/255, 121/255}, -- equipment
	[3] = {145/255, 242/255, 123/255}, -- consumables
	[4] = {255/255, 81/255, 168/255}, -- tradegoods
}

BAG_FILTER_ICONS = {
	[_G.LE_BAG_FILTER_FLAG_EQUIPMENT] = 'Interface/ICONS/INV_Chest_Plate10',
	[_G.LE_BAG_FILTER_FLAG_CONSUMABLES] = 'Interface/ICONS/INV_Potion_93',
	[_G.LE_BAG_FILTER_FLAG_TRADE_GOODS] = 'Interface/ICONS/INV_Fabric_Silk_02',
}

local QuestColors = {
	questStarter = {r = 1, g = 1, b = 0},
	questItem 	 = {r = 1, g = 0.30, b = 0.30},
}

local UpdateItemUpgradeIcon;
local ITEM_UPGRADE_CHECK_TIME = 0.5;

local enrus = {
	["q"] = "й",
	["w"] = "ц",
	["e"] = "у",
	["r"] = "к",
	["t"] = "е",
	["y"] = "н",
	["u"] = "г",
	["i"] = "ш",
	["o"] = "щ",
	["p"] = "з",

	["a"] = "ф",
	["s"] = "ы",
	["d"] = "в",
	["f"] = "а",
	["g"] = "п",
	["h"] = "р",
	["j"] = "о",
	["k"] = "л",
	["l"] = "д",
	[";"] = "ж",

	["z"] = "я",
	["x"] = "ч",
	["c"] = "с",
	["v"] = "м",
	["b"] = "и",
	["n"] = "т",
	["m"] = "ь",
	[","] = "б",
	["."] = "ю",
	["/"] = ".",
}

-----------------------------------------------------------------------------------------------
----													SEARCH
-----------------------------------------------------------------------------------------------

function addon:SearchReset()
	SEARCH_STRING = ""
end

function addon:IsSearching()
	if SEARCH_STRING ~= "" and SEARCH_STRING ~= SEARCH then
		return true
	end
	return false
end

local function ConvertER( str)
	if not str then return "" end
	local res, t = "", {}
	str:gsub(".",function(c)
		if enrus[c] then c = enrus[c] end
		tinsert( t, c )
	end)

	for k, v in pairs( t) do
        res = res..tostring( v)
    end
	--tprint( t)
	return res
end

function addon:UpdateSearch()
	if self.Instructions then self.Instructions:SetShown(self:GetText() == "") end
	local MIN_REPEAT_CHARACTERS = 3;
	local searchString
	if GetLocale() == "ruRU" then
		searchString = ConvertER( self:GetText())
	else
		searchString = self:GetText()
	end

	local prevSearchString = SEARCH_STRING;
	if (len(searchString) > MIN_REPEAT_CHARACTERS) then
		local repeatChar = true;
		for i=1, MIN_REPEAT_CHARACTERS, 1 do
			if ( sub(searchString,(0-i), (0-i)) ~= sub(searchString,(-1-i),(-1-i)) ) then
				repeatChar = false;
				break;
			end
		end
		if ( repeatChar ) then
			addon.ResetAndClear(self);
			return;
		end
	end

	--Keep active search term when switching between bank and reagent bank
	if searchString == SEARCH and prevSearchString ~= "" then
		searchString = prevSearchString
	elseif searchString == SEARCH then
		searchString = ''
	end

	SEARCH_STRING = searchString

	addon:SetSearch(SEARCH_STRING);
end

--function addon:OpenEditbox()
--	addon.BagFrame.detail:Hide();
--	addon.BagFrame.editBox:Show();
--	addon.BagFrame.editBox:SetText( SEARCH);
--	addon.BagFrame.editBox:HighlightText();
--end

function addon:ResetAndClear()
	local editbox = self:GetParent().editBox or self
	if editbox then editbox:SetText(SEARCH) end

	self:ClearFocus();
	addon:SearchReset();
end

function addon:SetSearch( query)
	if not query then return end
	--print( query)
	local empty = len( query:gsub(' ', '')) == 0
	local method = Search.Matches
	local allowPartialMatch
	if Search.Filters.tipPhrases.keywords[query] then
		if query == "rel" or query == "reli" or query == "relic" then
			allowPartialMatch = true
		end
		method = Search.TooltipPhrase
		query = Search.Filters.tipPhrases.keywords[query]
	end

	for _, bagFrame in pairs( addon.BagFrames) do
		for _, bagID in ipairs( bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local _, _, _, _, _, _, link = GetContainerItemInfo(bagID, slotID);
				local button = bagFrame.Bags[bagID][slotID];
				local success, result = pcall(method, Search, link, query, allowPartialMatch)
				if ( empty or (success and result) ) then
					SetItemButtonDesaturated(button);
					button:SetAlpha(1);
				else
					SetItemButtonDesaturated(button, 1);
					button:SetAlpha(0.3);
				end
			end
		end
	end

	if(ReagentBankFrameItem1) then
		for slotID=1, 98 do
			local _, _, _, _, _, _, link = GetContainerItemInfo(REAGENTBANK_CONTAINER, slotID);
			local button = _G["ReagentBankFrameItem"..slotID]
			local success, result = pcall(method, Search, link, query)
			if ( empty or (success and result) ) then
				SetItemButtonDesaturated(button);
				button:SetAlpha(1);
			else
				SetItemButtonDesaturated(button, 1);
				button:SetAlpha(0.4);
			end
		end
	end
end

-----------------------------------------------------------------------------------------------
----													DESIGN
-----------------------------------------------------------------------------------------------

function addon:AssignBagFlagMenu()
	local holder = ElvUIAssignBagDropdown.holder
	ElvUIAssignBagDropdown.holder = nil

	if not (holder and holder.id) then return end

	local info = UIDropDownMenu_CreateInfo()
	if holder.id > 0 and not IsInventoryItemProfessionBag('player', ContainerIDToInventoryID(holder.id)) then -- The actual bank has ID -1, backpack has ID 0, we want to make sure we're looking at a regular or bank bag
		info.text = _G.BAG_FILTER_ASSIGN_TO
		info.isTitle = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)

		info.isTitle = nil
		info.notCheckable = nil
		info.tooltipWhileDisabled = 1
		info.tooltipOnButton = 1

		for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
			if i ~= LE_BAG_FILTER_FLAG_JUNK then
				info.text = _G.BAG_FILTER_LABELS[i]
				info.func = function(_, _, _, value)
					value = not value

					if holder.id > NUM_BAG_SLOTS then
						SetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, i, value)
					else
						SetBagSlotFlag(holder.id, i, value)
					end

					if value then
						holder.tempflag = i
						holder.FilterIcon:SetTexture(BAG_FILTER_ICONS[i])
						holder.FilterIcon:Show()
					else
						holder.FilterIcon:Hide()
						holder.tempflag = -1
					end
				end

				if holder.tempflag then
					info.checked = holder.tempflag == i
				else
					if holder.id > NUM_BAG_SLOTS then
						info.checked = GetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, i)
					else
						info.checked = GetBagSlotFlag(holder.id, i)
					end
				end

				info.disabled = nil
				info.tooltipTitle = nil
				UIDropDownMenu_AddButton(info)
			end
		end
	end

	info.text = BAG_FILTER_CLEANUP
	info.isTitle = 1
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	info.isTitle = nil
	info.notCheckable = nil
	info.isNotRadio = true
	info.disabled = nil

	info.text = BAG_FILTER_IGNORE
	info.func = function(_, _, _, value)
		if holder.id == -1 then
			SetBankAutosortDisabled(not value)
		elseif holder.id == 0 then
			SetBackpackAutosortDisabled(not value)
		elseif holder.id > NUM_BAG_SLOTS then
			SetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not value)
		else
			SetBagSlotFlag(holder.id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not value)
		end
	end
	if holder.id == -1 then
		info.checked = GetBankAutosortDisabled()
	elseif holder.id == 0 then
		info.checked = GetBackpackAutosortDisabled()
	elseif holder.id > NUM_BAG_SLOTS then
		info.checked = GetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP)
	else
		info.checked = GetBagSlotFlag(holder.id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP)
	end

	UIDropDownMenu_AddButton(info)
end

function addon:Tooltip_Show()
	GameTooltip:SetOwner(self);
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)

	if self.ttText2 then
		if self.ttText2desc then
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
		else
			GameTooltip:AddLine(self.ttText2)
		end
	end

	GameTooltip:Show()
	if self.shadow then self.shadow:SetBackdropBorderColor(n.myColor.r, n.myColor.g, n.myColor.b, 1) end
end

function addon:Tooltip_Hide()
	GameTooltip:Hide()
	if self.shadow then self.shadow:SetBackdropBorderColor( defcol, defcol, defcol) end
end

function addon:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID);
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
						f.Bags[bagID][slotID].shadow:SetAlpha( 1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.2)
						f.Bags[bagID][slotID].shadow:SetAlpha(0.2)
					end
				end
			end
		end
	end
end

function addon:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID);
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
					f.Bags[bagID][slotID].shadow:SetAlpha( 1)
				end
			end
		end
	end
end

local function Flash(object, duration, loop)
	if not object.anim then
		SetUpAnimGroup(object, loop and "FlashLoop" or 'Flash', 0.7, .0, duration * 1.7)
	end

	if not object.anim.playing then
		object.anim.fadein:SetDuration(duration * 1.7)
		object.anim.fadeout:SetDuration(duration * 0.15)
		object.anim:Play()
		object.anim.playing = true
	end
end

local function StopFlash(object)
	if object.anim and object.anim.playing then
		object.anim:Stop()
		object.anim.playing = nil;
	end
end

function addon:NewItemGlowSlotSwitch(slot, show)
	if slot and slot.newItemGlow then
		if show then
			slot.newItemGlow:SetVertexColor( 1, 1, 0.5, 0)
			slot.newItemGlow:Show()
			if yo.Bags.newIconAnimation then
				Flash(slot.newItemGlow, 0.6, yo.Bags.newAnimationLoop)
			end
		else
			slot.newItemGlow:Hide()
			if yo.Bags.newIconAnimation then
				StopFlash(slot.newItemGlow)
			end
		end
	end
end

local function hideNewItemGlow(slot)
	addon:NewItemGlowSlotSwitch(slot)
end

function addon:CheckSlotNewItem(slot, bagID, slotID)
	addon:NewItemGlowSlotSwitch(slot, C_NewItems_IsNewItem(bagID, slotID))
end

function addon:GetBagAssignedInfo(holder)

	if not (holder and holder.id and holder.id > 0) then return end

	local inventoryID = ContainerIDToInventoryID(holder.id)
	if IsInventoryItemProfessionBag("player", inventoryID) then return end

	if holder.tempflag then
		holder.tempflag = nil --clear tempflag from AssignBagFlagMenu
	end

	local active, color
	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
		if i ~= LE_BAG_FILTER_FLAG_JUNK then --ignore this one
			if holder.id > NUM_BAG_SLOTS then
				active = GetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, i)
			else
				active = GetBagSlotFlag(holder.id, i)
			end

			if active then
				color = AssignmentColors[i]
				active = (color and i) or 0
				holder.FilterIcon:SetTexture( BAG_FILTER_ICONS[i])
				holder.FilterIcon:Show()
				break
			else
				holder.FilterIcon:Hide()
			end
		end
	end

	if not active then
		holder.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09)
	else
		holder.shadow:SetBackdropBorderColor(unpack(color or AssignmentColors[0]))
		return active
	end
end

local function StyleButton(button, noHover, noPushed, noChecked)
	if button.SetHighlightTexture and not button.hover and not noHover then
		local hover = button:CreateTexture("frame", nil, button)
			hover:SetTexture( n.texture)
			hover:SetVertexColor( 0, 1, 0, 1)
			hover:SetPoint("TOPLEFT", 0, -0)
			hover:SetPoint("BOTTOMRIGHT", -0, 0)
			hover:SetAlpha( 0.4)
		button.hover = hover
		button:SetHighlightTexture( hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture("frame", nil, button)
			pushed:SetTexture( n.texture)
			pushed:SetVertexColor( 0, 1, 0, 1)
			pushed:SetPoint("TOPLEFT", 0, -0)
			pushed:SetPoint("BOTTOMRIGHT", -0, 0)
			pushed:SetAlpha( 0.5)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture("frame", nil, button)
			checked:SetTexture( n.texture)
			checked:SetVertexColor( 1, 1, 0, 1)
			checked:SetPoint("TOPLEFT", 0, -0)
			checked:SetPoint("BOTTOMRIGHT", -0, 0)
			checked:SetAlpha( 0.2)
		button.checked = checked
		button:SetCheckedTexture( checked)
	end

	--local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
	--if cooldown then
	--	cooldown:ClearAllPoints()
	--	--SetInside( cooldown)
	--	cooldown:SetDrawEdge(false)
	--	cooldown:SetSwipeColor(0, 0, 0, 1)
	--end
end

-----------------------------------------------------------------------------------------------
----													UPDATES
-----------------------------------------------------------------------------------------------

local function IsItemEligibleForItemLevelDisplay(classID, subClassID, equipLoc, rarity)
	if (equipLoc and _G[equipLoc] and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_TABARD") and (rarity and rarity > 1) then
		return true
	end
	return false
end

local doEquip
local function equipItem( slot, bagID, slotID, clink, iLvl, locLink, locLvl, itemEquipLoc)
	-- body
	--dprint("doEquip = ", doEquip)
	if doEquip then return	end

	local itemRarity = select( 3, GetItemInfo( clink))
	local hexColor = "|c" .. select( 4, GetItemQualityColor(itemRarity))
	local loclhexColor, locitemRarity

	if locLink then
		locitemRarity = select( 3, GetItemInfo( locLink))
		loclhexColor = "|c" .. select( 4, GetItemQualityColor(locitemRarity))
	else
		loclhexColor = "|c" .. select( 4, GetItemQualityColor(0))
		locLvl = "0"
		locLink = loclhexColor .. "Empty slot"
	end

	local text = hexColor .. " [" ..  iLvl .. "] > " .. loclhexColor .. "[".. locLvl  .. "] " .. clink .. "|r" .. L["instead"].. locLink

	--dprint( "EQuipItem ", bagID, slotID, clink, iLvl, locLink, locLvl, itemEquipLoc)

	--print(clink, locLink, itemEquipLoc, iLvl, locLvl, bagID, slotID, text)
	if yo.Addons.equipNewItem and yo.Addons.equipNewItemLevel > iLvl and ( locitemRarity ~= 7 or itemRarity ~= 0) then
		doEquip = true
		if InCombatLockdown() then
			print( L["putOn"] .. text)

			slot.clink 	= clink
			slot.text 	= text

			slot:RegisterEvent("PLAYER_REGEN_ENABLED")
			slot:SetScript("OnEvent", function(self, ...)
				self:UnregisterAllEvents()
				print( L["weared"] .. self.text)
				EquipItemByName( self.clink)
				ConfirmBindOnUse()
				self.clink = nil
			end)
		else
			print( L["weared"] .. text)
			EquipItemByName( clink)
			ConfirmBindOnUse() -- elseif ( event == "USE_BIND_CONFIRM" ) then StaticPopup_Show("USE_BIND");
		end
		C_NewItems_RemoveNewItem(bagID, slotID)
		--print( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink)
	else
		print( L["canChange"] .. text)
		C_NewItems_RemoveNewItem(bagID, slotID)
	end
end

local itemTable = {}

---------http://wowprogramming.com/docs/api/IsEquippedItemType.html
local function checkSloLocUpdate( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink, itemSubClassID)  --- C_NewItems_IsNewItem(bagID, slotID))
	local ret, canWear, weapon2H = false, false
	local slotIndexes = n.slotEquipType[itemEquipLoc]

	if slotIndexes and iLvl then

		for i, locSlotID in ipairs( slotIndexes ) do
			local itemLocation = _G.ItemLocation:CreateFromEquipmentSlot( locSlotID)
			local item = _G.Item:CreateFromItemLocation( itemLocation)
			local locLvl = item:GetCurrentItemLevel()

			if locSlotID == 16 and n.slot2HWeapon[item:GetInventoryTypeName()] then weapon2H = true end
			--tprint( item)
			--print( locSlotID, clink, item:GetItemLink(), item:GetInventoryTypeName(), weapon2H)

			if itemSubClassID == n.classEquipMap[n.myClass] or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
				canWear = true
			else
				wipe( itemTable)
				GetInventoryItemsForSlot( locSlotID, itemTable); --ItemLocation:CreateFromBagAndSlot( bagID, slotID)
				for location, itemID in next, itemTable do
					--print( locSlotID, itemID, clink)
					if clink == itemID then
						canWear = true
						--print( locSlotID, itemID, clink) --, "YSDKJSH DKSJH")
					end
				end
			end
			--dprint( "11111 ", bagID, slotID, itemEquipLoc, locEquipLocation, itemSubType, clink, canWear, locLvl, iLvl, C_NewItems.IsNewItem(bagID, slotID))
			if item:IsItemEmpty() and locSlotID < 16 and C_NewItems_IsNewItem(bagID, slotID) == true then

				if locSlotID >= 11 and locSlotID <= 15 then 				-- ring and trinkets slots
					equipItem( slot, bagID, slotID, clink, iLvl)
				elseif locSlotID >= 1 and locSlotID <= 10 and canWear then 	-- armor slots
					equipItem( slot, bagID, slotID, clink, iLvl)
				else 														-- reserv for weapon slots, look down
				end

			elseif canWear and locLvl and iLvl > locLvl then
				local locLink = item:GetItemLink()
				--dprint("прошли 1й чек")
				--local locItemSutType = select( 7, GetItemInfo( locLink))
				local locEquipLocation = select( 9, GetItemInfo( locLink))
				ret = true 																	-- чекать что в майнхэнде двуручка и не чекать 2й слот на канвеар
				if locSlotID <= 16 and itemEquipLoc == locEquipLocation then
					--dprint("прошли 2й чек")
					if ( C_NewItems_IsNewItem(bagID, slotID) == true) then
						--dprint("прошли 3й чек")
						equipItem( slot, bagID, slotID, clink, iLvl, locLink, locLvl, itemEquipLoc)
					end
				elseif locSlotID >= 16 then

				end

			elseif item:IsItemEmpty() and canWear then
				if locSlotID == 17 and weapon2H then  -- если 17й пустой, а в 16-м - двуручув
				else
					ret = true
				end

			end
		end
	end
	--if ret then print( bagID, slotID, itemEquipLoc, itemSubType, locItemSutType, iLvl, clink) end
	slot.UpgradeIcon:SetShown( ret);
end

-----------------------------------------------------------------------------------------------------------------
--																	UPDATE SLOT
-----------------------------------------------------------------------------------------------------------------
local function UpdateSlot( self, bagID, slotID)
	--print ("UPDATE_SLOT: ", bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then return; end

	local itemLink
	local slot, _ 		= self.Bags[bagID][slotID], nil;
	local bagType 		= self.Bags[bagID].type;
	local clink 		= GetContainerItemLink(bagID, slotID);
	local assignedID 	= bagID --(self.isBank and bagID) or bagID - 1
	local assignedBag 	= self.Bags[assignedID] and self.Bags[assignedID].assigned
	local texture, count, locked, readable, noValue

	slot.name, slot.rarity = nil, nil;
	texture, count, locked, slot.rarity, readable, _, itemLink, _, noValue = GetContainerItemInfo(bagID, slotID);

	slot:Show();
	slot.itemLevel:SetText("")
	if slot.questIcon   then slot.questIcon:Hide(); end
	if slot.UpgradeIcon then slot.UpgradeIcon:Hide() end
	slot.SetIcon:SetShown( Search:InSet( clink))
	--if Search:InSet( clink) then  	slot.SetIcon:Show() else 							slot.SetIcon:Hide()	end

	if (slot.JunkIcon) then
		if (slot.rarity) and (slot.rarity == LE_ITEM_QUALITY_POOR and not noValue)  then
			slot.JunkIcon:Show();
		else
			slot.JunkIcon:Hide()
		end
	end

	if ProfessionColors[bagType] then
		local r, g, b = unpack( ProfessionColors[bagType])
		slot.shadow:SetBackdropBorderColor(r, g, b, 0.9)
	elseif (clink) then
		local iLvl, itemEquipLoc, itemClassID, itemSubClassID, itemSubType
		slot.name, _, _, _, _, _, itemSubType, _, itemEquipLoc, _, _, itemClassID, itemSubClassID = GetItemInfo(clink);

		local item = _G.Item:CreateFromBagAndSlot(bagID, slotID)
 		if ( item ) then
    		iLvl = item:GetCurrentItemLevel()
		end

		local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bagID, slotID);
		local r, g, b

		if slot.rarity then
			r, g, b = GetItemQualityColor(slot.rarity);
		end

		--Item Level
		if iLvl and IsItemEligibleForItemLevelDisplay(itemClassID, itemSubClassID, itemEquipLoc, slot.rarity) then
			if (iLvl >= 1) then
				slot.itemLevel:SetText(iLvl)
				slot.itemLevel:SetTextColor(r, g, b)
			end
		end

		if slot.UpgradeIcon then
			--dprint( "CheckUpdateIcon: ", bagID, slotID, slot)
			--checkSloLocUpdate( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink, itemSubClassID)  --- C_NewItems_IsNewItem(bagID, slotID))
			yoDelay( 0.5, checkSloLocUpdate, bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink, itemSubClassID)
		end

		-- color slot according to item quality
		if questId and not isActiveQuest then
			slot.shadow:SetBackdropBorderColor( QuestColors.questStarter.r, QuestColors.questStarter.g, QuestColors.questStarter.b);
			if(slot.questIcon) then slot.questIcon:Show(); end

		elseif questId or isQuestItem then
			slot.shadow:SetBackdropBorderColor( QuestColors.questItem.r, QuestColors.questItem.g, QuestColors.questItem.b);
			if(slot.questIcon) then slot.questIcon:Show(); end

		elseif slot.rarity and slot.rarity > 1 then
			slot.shadow:SetBackdropBorderColor(r, g, b, 0.9);

		elseif AssignmentColors[assignedBag] then
			local rr, gg, bb = unpack( AssignmentColors[assignedBag])
			slot.shadow:SetBackdropBorderColor(rr, gg, bb, 0.9)

		else
			slot.shadow:SetBackdropBorderColor( defcol, defcol, defcol, 0.9)
		end

	elseif AssignmentColors[assignedBag] then
		local rr, gg, bb = unpack( AssignmentColors[assignedBag])
		slot.shadow:SetBackdropBorderColor(rr, gg, bb, 0.25)    -- Prof Bags
	else
		slot.shadow:SetBackdropBorderColor( defcol, defcol, defcol, .9)
		--slot.shadow:SetBackdropBorderColor( .09, .09, .09, .9)		-- DEFAULT border !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		--slot.shadow:SetBackdropBorderColor( .12, .12, .12, .9)		-- DEFAULT border !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	end

	--addon:NewItemGlowSlotSwitch(slot, C_NewItems_IsNewItem(bagID, slotID))
	yoDelay( 0.2, addon.CheckSlotNewItem, addon, slot, bagID, slotID)

	if (texture) then
		local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
		CooldownFrame_Set(slot.cooldown, start, duration, enable)
		if ( duration > 0 and enable == 0 ) then
			SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4);
		else
			SetItemButtonTextureVertexColor(slot, 1, 1, 1);
		end
		slot.hasItem = 1;
	else
		slot.cooldown:Hide()
		slot.hasItem = nil;
	end

	slot.readable = readable;

	SetItemButtonTexture(slot, texture);
	SetItemButtonCount(slot, count);
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5);
	SetItemButtonQuality(slot, slot.rarity, itemLink)

	if GameTooltip:GetOwner() == slot and not slot.hasItem then GameTooltip:Hide() end
end

function addon:UpdateBagSlots( self, bagID)
	--dprint( "UpdateBagSlot: ", bagID, GetContainerNumSlots(bagID), self.UpdateSlot)

	if(bagID == REAGENTBANK_CONTAINER) then
		for i=1, 98 do
			addon:UpdateReagentSlot(i);
		end
	else
		for slotID = 1, GetContainerNumSlots(bagID) do
			UpdateSlot( self, bagID, slotID);
		end
	end
end

function addon:UpdateCooldowns(frame)
	if not (frame and frame.BagIDs) then return end

	for _, bagID in ipairs(frame.BagIDs) do
		for slotID = 1, GetContainerNumSlots(bagID) do
			if GetContainerItemInfo(bagID, slotID) then
				local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
				CooldownFrame_Set(frame.Bags[bagID][slotID].cooldown, start, duration, enable)
			end
		end
	end
end

local function UpdateAllSlots( self, ...)
	--print( "UpdateAllSlots: ", self:GetName(), self.BagIDs)

	for _, bagID in ipairs( self.BagIDs) do
		if self.Bags[bagID] then
			addon:UpdateBagSlots( self, bagID);
		end
	end

	--Refresh search in case we moved items around
	if addon:IsSearching() then
		addon:SetSearch(SEARCH_STRING);
	end
end


-----------------------------------------------------------------------------------------------
----													SHOW HIDES
-----------------------------------------------------------------------------------------------

function addon:RegisterEvents( )
	local f = addon.bagFrame

	f:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
	f:RegisterEvent("ITEM_LOCK_CHANGED");
	f:RegisterEvent("ITEM_UNLOCKED");
	f:RegisterEvent("BAG_UPDATE_COOLDOWN")
	f:RegisterEvent("BAG_UPDATE");
	f:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
	f:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
	f:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	f:RegisterEvent("QUEST_ACCEPTED");
	f:RegisterEvent("QUEST_REMOVED");
	f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	f:RegisterEvent("USE_BIND_CONFIRM")
end

function addon:UnRegisterEvents( )
	local f = addon.bagFrame
	f:UnregisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
	--f:UnregisterEvent("ITEM_LOCK_CHANGED");
	--f:UnregisterEvent("ITEM_UNLOCKED");
	--f:UnregisterEvent("BAG_UPDATE_COOLDOWN")
	--f:UnregisterEvent("BAG_UPDATE");
	--f:UnregisterEvent("BAG_SLOT_FLAGS_UPDATED");
	--f:UnregisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
	f:UnregisterEvent("PLAYERBANKSLOTS_CHANGED");
	f:UnregisterEvent("QUEST_ACCEPTED");
	f:UnregisterEvent("QUEST_REMOVED");
	--f:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED");
	--f:UnregisterEvent("USE_BIND_CONFIRM")
end

function addon:Open()
	--print( "BAGS Frame Open")
	addon:RegisterEvents()

	PlaySound ( 862, "Master")
	addon.bagFrame:Show()
	UpdateAllSlots( addon.bagFrame)
end

function addon:Close()
	addon:UnRegisterEvents()

	if addon.bagFrame:IsShown() then PlaySound ( 863, "Master") end
	addon.bagFrame:Hide()
end

function addon:Toggle()
	--print( "addon_Toggle")
	if addon.bagFrame:IsShown() then 	addon:Close()
	else								addon:Open()	end
end

function addon:OnHide()
	--print( "Event addonBANK_ONhide")
	addon:Close()
	addon.bankFrame:Hide()
	_G.BankFrame:Hide()
	CloseBankFrame()
end

function addon:OnShow()
	--print( "Event addonBANK_ONShow")
	--OpenBankFrame()
	--ReagentBankHelpBox:Show();
	if(not GetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_REAGENT_BANK_UNLOCK)) then
		local numSlots,full = GetNumBankSlots();
		if ( full and not IsReagentBankUnlocked()) then
			local helpTipInfo = {
				text = REAGENT_BANK_HELP,
				buttonStyle = HelpTip.ButtonStyle.Close,
				cvarBitfield = "closedInfoFrames",
				bitfieldFlag = LE_FRAME_TUTORIAL_REAGENT_BANK_UNLOCK,
				targetPoint = HelpTip.Point.RightEdgeCenter,
				offsetX = -2,
			};
			HelpTip:Show( addon, helpTipInfo, BankFrameTab2);
		end
	end

	if addon.bankFrame and addon.bankFrame:IsShown() then
		--print("Opem bank")
		--addon.bankFrame:Show()
		UpdateAllSlots( addon.bankFrame)
	end

	if yo.Bags.autoReagent then
		PlaySound(841)
		DepositReagentBank()
	end
end

function addon:OnHide()

	if addon.bankFrame and addon.bankFrame:IsShown() then
		--print( "Event addonBAG_ONhide")
		addon.bankFrame:Hide()
		--ContainerFrame14:Hide()
		CloseAllBags();
		CloseBankBagFrames();
		CloseBankFrame();
	end
end

-------------------------------------------------------------------------------------------------------------
--											UPDATE REAGENT SLOT
-------------------------------------------------------------------------------------------------------------
function addon:UpdateReagentSlot(slotID)
	assert(slotID)
	local bagID = REAGENTBANK_CONTAINER
	local texture, count = GetContainerItemInfo(bagID, slotID);
	local clink = GetContainerItemLink(bagID, slotID);
	local slot = _G["ReagentBankFrameItem"..slotID]
	if not slot then return; end

	slot:Show();
	slot.name, slot.rarity = nil, nil;

	if not slot.shadow then CreateStyle( slot, 1, nil, 0.5) end

	if (clink) then
		slot.name, slot.t, slot.rarity = GetItemInfo(clink);

		local r, g, b

		if slot.rarity then r, g, b = GetItemQualityColor(slot.rarity); end

		if slot.rarity and slot.rarity > 1 then
			slot.shadow:SetBackdropBorderColor(r, g, b);

		else
			slot.shadow:SetBackdropBorderColor( defcol, defcol, defcol, 0.9)
		end
	else
		slot.shadow:SetBackdropBorderColor( defcol, defcol, defcol, 0.9)
	end

	SetItemButtonTexture(slot, texture);
	SetItemButtonCount(slot, count);
end

------------------------------------------------------------------------------------------
--- 									LAYOUT
------------------------------------------------------------------------------------------
local function GetMaxSlots( self)
	local numSlots = 0
	for i, bagID in ipairs( self.BagIDs) do
		numSlots = numSlots + GetContainerNumSlots(bagID);
	end
	return numSlots
end

function addon:GetContainerFrame(arg)
	if type(arg) == 'boolean' and arg == true then
		return self.bankFrame;
	elseif type(arg) == 'number' then
		if self.bankFrame then
			for _, bagID in ipairs(self.bankFrame.BagIDs) do
				if bagID == arg then
					return self.bankFrame;
				end
			end
		end
	end

	return self.bagFrame;
end

function addon:CreateFilterIcon(parent)
	--Create the texture showing the assignment type
	parent.FilterIcon = parent:CreateTexture(nil, 'OVERLAY')
	parent.FilterIcon:Hide()
	parent.FilterIcon:SetTexture( "Interface\\ICONS\\INV_Potion_93")
	parent.FilterIcon:SetPoint('TOPLEFT', parent, 'TOPLEFT', -2, 2)
	parent.FilterIcon:SetTexCoord(unpack(n.tCoord))
	parent.FilterIcon:SetSize(14, 14)
	--parent.FilterIcon:SetAtlas( "bags-icon-consumables")
end

--local function yoReagentSplitStack(split)
--	SplitContainerItem(REAGENTBANK_CONTAINER, self:GetID(), split)
--end

function addon:CreateLayout( isBank)
	local f = self:GetContainerFrame(isBank);
	if not f then return; end

	local buttonSize 			= yo.Bags.buttonSize
	local buttonSpacing 		= yo.Bags.buttonSpacing
	local containerWidth 		= yo.Bags.containerWidth
	local numMaxRow 			= yo.Bags.numMaxRow

	local numContainerColumns, numContainerRows, holderWidth = 0, 0, 0
	local maxSlots = GetMaxSlots( f)

	repeat
		numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing));
		holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing;
		local rows = ceil( maxSlots / numContainerColumns)

		if rows > numMaxRow then
			containerWidth = containerWidth + buttonSize + buttonSpacing
		end
	until rows <= numMaxRow

	f.holderFrame:SetWidth(holderWidth);

	if(isBank) then f.reagentFrame:SetWidth(holderWidth) end

	f.totalSlots = 0
	local lastButton;
	local lastRowButton;
	local lastContainerButton;
	local numContainerSlots = GetNumBankSlots();

	for i, bagID in ipairs(f.BagIDs) do
		local assignedBag
----------------------------------------------------------------------------
--				CONTAINER SLOTS
----------------------------------------------------------------------------
		--print( i, bagID, isBank, numContainerSlots, f:GetName(), GetContainerNumSlots(bagID))
		local bagName = isBank and format('ElvUIBankBag%d', bagID-4) or bagID == 0 and 'ElvUIMainBagBackpack' or format('ElvUIMainBag%dSlot', bagID-1)
		local inherit = isBank and 'BackdropTemplate, BankItemButtonBagTemplate' or bagID == 0 and 'BackdropTemplate, ItemAnimTemplate' or 'BackdropTemplate, BagSlotButtonTemplate'

		--f.ContainerHolder:SetSize(((buttonSize + buttonSpacing) * numContainerSlots) + buttonSpacing, buttonSize + (buttonSpacing * 2))
		f.ContainerHolder:SetSize(((buttonSize) * i) + 10, buttonSize + (buttonSpacing * 2))

		f.ContainerHolder[i] = f.ContainerHolder[i] or CreateFrame("ItemButton", bagName, f.ContainerHolder, inherit) --"BagSlotButtonTemplate") --"ContainerFrameItemButtonTemplate")-- "BagSlotButtonTemplate")   --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		f.ContainerHolder[i].id = bagID
		f.ContainerHolder[i]:HookScript('OnEnter', function(ch) addon.SetSlotAlphaForBag(ch, f) end)
		f.ContainerHolder[i]:HookScript('OnLeave', function(ch) addon.ResetSlotAlphaForBags(ch, f) end)

		if not f.ContainerHolder[i].shadow then
			CreateStyle( f.ContainerHolder[i], 2, nil, 0.5, 0)
			StyleButton( f.ContainerHolder[i])
		end
		f.ContainerHolder[i]:SetNormalTexture("")
		f.ContainerHolder[i]:SetPushedTexture("")

		addon:CreateFilterIcon(f.ContainerHolder[i])

		if isBank then
			f.ContainerHolder[i]:SetID(bagID - 4)
			f.ContainerHolder[i].icon:SetTexture('Interface/Buttons/Button-Backpack-Up')
			f.ContainerHolder[i]:SetScript('OnClick', function(holder, button)
				if button == 'RightButton' and holder.id then
					ElvUIAssignBagDropdown.holder = holder
					ToggleDropDownMenu(1, nil, ElvUIAssignBagDropdown, 'cursor')
				else
					local inventoryID = holder:GetInventorySlot()
					PutItemInBag(inventoryID);--Put bag on empty slot, or drop item in this bag
				end
			end)
		else
			if bagID == 0 then --Backpack needs different setup
				f.ContainerHolder[i]:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
				f.ContainerHolder[i]:SetScript('OnClick', function(holder, button)
					if button == 'RightButton' and holder.id then
						ElvUIAssignBagDropdown.holder = holder
						ToggleDropDownMenu(1, nil, ElvUIAssignBagDropdown, 'cursor')
					else
						PutItemInBackpack()
					end
				end)
				f.ContainerHolder[i]:SetScript('OnReceiveDrag', PutItemInBackpack)
				f.ContainerHolder[i].icon:SetTexture('Interface/Buttons/Button-Backpack-Up')
			else
				f.ContainerHolder[i]:SetScript('OnClick', function(holder, button)
					if button == 'RightButton' and holder.id then
						ElvUIAssignBagDropdown.holder = holder
						ToggleDropDownMenu(1, nil, ElvUIAssignBagDropdown, 'cursor')
					else
						local id = holder:GetID()
						PutItemInBag(id)
					end
				end)
			end
		end

		f.ContainerHolder[i].IconBorder:SetAlpha(0)
		f.ContainerHolder[i].icon:ClearAllPoints()
		f.ContainerHolder[i].icon:SetPoint("CENTER", f.ContainerHolder[i])
		f.ContainerHolder[i].icon:SetSize(buttonSize -3, buttonSize -3)
		f.ContainerHolder[i].icon:SetTexCoord( unpack( f.texCoord))
		f.ContainerHolder[i]:SetSize( buttonSize, buttonSize)

		if i == 1 then
			f.ContainerHolder[i]:SetPoint('BOTTOMLEFT', f.ContainerHolder, 'BOTTOMLEFT',  2, 2)
		else
			f.ContainerHolder[i]:SetPoint('LEFT', f.ContainerHolder[i - 1], 'RIGHT', 0, 0)
		end

		f.Bags[bagID] = f.Bags[bagID] or CreateFrame('Frame', f:GetName()..'Bag'..bagID, f.holderFrame)
		f.Bags[bagID]:SetID(bagID)

		assignedBag = addon:GetBagAssignedInfo(f.ContainerHolder[i])

----------------------------------------------------------------------------
--				BAG/BANK SLOTS
----------------------------------------------------------------------------
		local numSlots = GetContainerNumSlots(bagID);
		if numSlots > 0 then
			if not f.Bags[bagID] then
				f.Bags[bagID] = CreateFrame('Frame', f:GetName()..'Bag'..bagID, f.holderFrame);
				f.Bags[bagID]:SetID(bagID);
				f.Bags[bagID].UpdateBagSlots = addon.UpdateBagSlots;
				f.Bags[bagID].UpdateSlot = UpdateSlot;
			end

			f.Bags[bagID].numSlots = numSlots;
			f.Bags[bagID].assigned = assignedBag;
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID));

			--Hide unused slots
			for i = 1, 20 do
				if f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide();
				end
			end

			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1;
				local slot = f.Bags[bagID][slotID]
				if not slot then
					slot = CreateFrame('ItemButton', f.Bags[bagID]:GetName()..'Slot'..slotID, f.Bags[bagID], bagID == -1 and 'BackdropTemplate, BankItemButtonGenericTemplate' or 'BackdropTemplate, ContainerFrameItemButtonTemplate')

					if not slot.shadow then
						CreateStyle( slot, 1, nil, 0.5)
						StyleButton( slot)
						--slot.IconBorder:SetAlpha(0)
					end

					slot:SetNormalTexture(nil);

					--addon:CreateFilterIcon( slot)
					--slot:SetCheckedTexture(nil);	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

					if(_G[slot:GetName()..'NewItemTexture']) then
						_G[slot:GetName()..'NewItemTexture']:Hide()
					end

					slot.Count:ClearAllPoints();
					slot.Count:SetPoint('BOTTOMRIGHT', 0, 2);
					slot.Count:SetFont( n.font, n.fontsize -0, "OUTLINE")

					if not(slot.questIcon) then
						slot.questIcon = _G[slot:GetName()..'IconQuestTexture'] or _G[slot:GetName()].IconQuestTexture
						slot.questIcon:SetTexture( yo.Media.path .. "icons\\bagQuestIcon");
						slot.questIcon:SetTexCoord(0,1,0,1);
						slot.questIcon:Show();
					end

					if slot.UpgradeIcon then
						slot.UpgradeIcon:ClearAllPoints()
						slot.UpgradeIcon:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 8, -7)
						slot.UpgradeIcon.ClearAllPoints 	= n.dummy
						slot.UpgradeIcon.SetPoint 			= n.dummy
						slot.UpgradeIcon:SetTexture( yo.Media.path .. "icons\\bagUpgradeIcon");
						slot.UpgradeIcon:SetTexCoord(0,1,0,1);
						slot.UpgradeIcon:Hide();
					end

					--.JunkIcon only exists for items created through ContainerFrameItemButtonTemplate
					if not slot.JunkIcon then
						local JunkIcon = slot:CreateTexture(nil, "OVERLAY")
						JunkIcon:SetAtlas("bags-junkcoin")
						JunkIcon:SetPoint("TOPLEFT", 1, 0)
						JunkIcon:Hide()
						slot.JunkIcon = JunkIcon
					end

					if not slot.SetIcon then
						local SetIcon = slot:CreateTexture(nil, "OVERLAY")
						--SetIcon:SetAtlas("bags-junkcoin")
						SetIcon:SetPoint("BOTTOMLEFT", 1, 1)
						SetIcon:SetSize( 7, 7)
						SetIcon:SetTexture( n.texture)
						SetIcon:SetVertexColor(0, 1, 0, 1)
						SetIcon:Hide()
						slot.SetIcon = SetIcon
					end

					slot.IconBorder:kill()
					--slot.IconBorder:Kill()
					--slot.IconOverlay:SetInside()
					--slot.IconOverlay2:SetInside()

					slot.icon:SetTexCoord( unpack( n.tCoord))  		--( unpack( n.tCoord))
					slot.icon:ClearAllPoints()
					slot.icon:SetPoint("CENTER", slot)
					slot.icon:SetSize(slot:GetWidth() -8, slot:GetHeight() -8)
					slot.icon.ClearAllPoints = n.dummy
					--slot.icon.SetTexCoord = n.dummy

					slot.cooldown = _G[slot:GetName()..'Cooldown'];
					slot.cooldown.ColorOverride = 'bags'
					slot.bagID = bagID
					slot.slotID = slotID

					slot.itemLevel = slot.itemLevel or slot:CreateFontString(nil, 'OVERLAY')
					slot.itemLevel:SetPoint("TOP", 0, -2)
					slot.itemLevel:SetFont( n.font, n.fontsize - 1, "OUTLINE")

					if(slot.BattlepayItemTexture) then
						slot.BattlepayItemTexture:Hide()
					end

					if not slot.newItemGlow then
						local newItemGlow = slot:CreateTexture(nil, "OVERLAY")
						newItemGlow:SetTexture("Interface\\GLUES\\Models\\UI_LightforgedDraenei\\draenei_glow_blue.blp")
						newItemGlow:SetAllPoints( slot)
						newItemGlow:Hide()
						slot.newItemGlow = newItemGlow
						slot:HookScript("OnEnter", hideNewItemGlow)
					end

					f.Bags[bagID][slotID] = slot
				end

				slot.slotID = slotID
				slot.bagID = bagID
				slot:SetID(slotID);
				slot:SetSize( buttonSize, buttonSize)

				if slot.JunkIcon then
					slot.JunkIcon:SetSize( buttonSize/2, buttonSize/2)
				end
				--print( "TO UPDARE: ", f, bagID, slotID)
				f:UpdateSlot( bagID, slotID);

				if slot:GetPoint() then
					slot:ClearAllPoints();
				end

				if lastButton then
					if (f.totalSlots - 1)  %numContainerColumns == 0 then
						slot:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing);
						lastRowButton = slot;
						numContainerRows = numContainerRows + 1;
					else
						slot:SetPoint('LEFT', lastButton, 'RIGHT', buttonSpacing, 0);
					end
				else
					slot:SetPoint('TOPLEFT', f.holderFrame, 'TOPLEFT');
					lastRowButton = slot;
					numContainerRows = numContainerRows + 1;
				end

				lastButton = slot;
			end
		else
			--Hide unused slots
			for i = 1, 20 do
				if f.Bags[bagID] and f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide();
				end
			end

			if f.Bags[bagID] then
				f.Bags[bagID].numSlots = numSlots;
			end

			if self.isBank then
				if self.ContainerHolder[i] then
					--print( "erroe 2")
					BankFrameItemButton_Update(self.ContainerHolder[i])
					BankFrameItemButton_UpdateLocked(self.ContainerHolder[i])
				end
			end
		end
	end

----------------------------------------------------------------------------
--				REAGENT SLOTS
----------------------------------------------------------------------------
	if(isBank and f.reagentFrame:IsShown()) then
		if(not IsReagentBankUnlocked()) then
			--f.reagentFrame.cover:Show();
			--B:RegisterEvent("REAGENTBANK_PURCHASED")
		else
			--f.reagentFrame.cover:Hide();
		end


		local totalSlots = 0
		local lastRowButton
		numContainerRows = 1
		for i = 1, 98 do
			totalSlots = totalSlots + 1;
			local slot = f.reagentFrame.slots[i]
			if not slot then
				slot = CreateFrame("ItemButton", "ReagentBankFrameItem"..i, f.reagentFrame, "BackdropTemplate, BankItemButtonGenericTemplate");
				slot:SetID(i)
				slot.isReagent = true

				StyleButton( slot)
				if not slot.shadow then
					CreateStyle( slot, 1, nil, 0.5)
				end

				--slot.IconBorder:Kill()
				--slot.IconOverlay:SetInside()
				--slot.IconOverlay2:SetInside()

				slot:SetNormalTexture(nil);
				slot.Count:ClearAllPoints();
				slot.Count:SetPoint('BOTTOMRIGHT', 0, 2);
				slot.Count:SetFont( n.font, n.fontsize -0, "OUTLINE") --, .db.bags.countFontOutline)

				slot.icon:ClearAllPoints()
				slot.icon:SetAllPoints( slot)
				slot.icon:SetTexCoord( unpack( f.texCoord))
				slot.IconBorder:SetAlpha(0)

				slot:RegisterForDrag('LeftButton')
				slot:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
				slot.GetInventorySlot = ReagentButtonInventorySlot
				slot.UpdateTooltip = BankFrameItemButton_OnEnter
				--f.reagentFrame.slots[i].SplitStack = yoReagentSplitStack
				f.reagentFrame.slots[i] = slot
			end

			slot:ClearAllPoints()
			slot:SetSize( buttonSize, buttonSize)
			if(f.reagentFrame.slots[i-1]) then
				if(totalSlots - 1)  %numContainerColumns == 0 then
					slot:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing);
					lastRowButton = slot;
					numContainerRows = numContainerRows + 1;
				else
					slot:SetPoint('LEFT', f.reagentFrame.slots[i-1], 'RIGHT', buttonSpacing, 0);
				end
			else
				slot:SetPoint('TOPLEFT', f.reagentFrame, 'TOPLEFT');
				lastRowButton = slot
			end

			self:UpdateReagentSlot(i)
		end
	end
	f:SetSize( containerWidth, ((( buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + f.topOffset + f.bottomOffset); -- 8 is the cussion of the f.holderFrame
end
------------------------------------------------------------------------------------------
--- 									CREATE BAG FRAME
------------------------------------------------------------------------------------------
function addon:CreateBagFrame( Bag, isBank)
	--local n = "StuffingFrame"..Bag
	local f = CreateFrame('Button', Bag, UIParent);
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(1)
	f:SetSize( 440, 400)
	f.UpdateSlot = UpdateSlot;
	f.UpdateAllSlots = UpdateAllSlots
	f.isBank = isBank
	f.topOffset = 25
	f.bottomOffset = 10
	f.texCoord = n.tCoord --{.08, .92, .08, .92} --{ unpack( n.tCoord)}

	if isBank then
		f:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
		f:RegisterEvent("ITEM_LOCK_CHANGED");
		f:RegisterEvent("ITEM_UNLOCKED");
		--f:RegisterEvent("BAG_UPDATE_COOLDOWN")
		f:RegisterEvent("BAG_UPDATE");
		f:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
		f:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
		f:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
		f:RegisterEvent("QUEST_ACCEPTED");
		f:RegisterEvent("QUEST_REMOVED");
		f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
		f:RegisterEvent("USE_BIND_CONFIRM")
	else
		--f:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED");
		f:RegisterEvent("ITEM_LOCK_CHANGED");
		f:RegisterEvent("ITEM_UNLOCKED");
		--f:RegisterEvent("BAG_UPDATE_COOLDOWN")
		f:RegisterEvent("BAG_UPDATE");
		f:RegisterEvent("BAG_SLOT_FLAGS_UPDATED");
		--f:RegisterEvent("BANK_BAG_SLOT_FLAGS_UPDATED");
		--f:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
		--f:RegisterEvent("QUEST_ACCEPTED");
		--f:RegisterEvent("QUEST_REMOVED");
		f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
		--f:RegisterEvent("USE_BIND_CONFIRM")
	end
	f:SetScript("OnEvent", addon.OnEvent)

	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4};
	f.Bags = {};

	if isBank then
		f:SetPoint( "BOTTOMLEFT", n.infoTexts.LeftDataPanel, "TOPLEFT", 2, 46)
	else
		f:SetPoint( "BOTTOMRIGHT", n.infoTexts.RightDataPanel, "TOPRIGHT", -2, 46)
	end

	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnClick", function(self) if IsControlKeyDown() then print( "boom") end end)
	f:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	f.ContainerHolder = CreateFrame('Button', Bag..'ContainerHolder', f)
	f.ContainerHolder:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 5)
	CreateStyle( f.ContainerHolder, 2, nil, 0.5)
	f.ContainerHolder:Hide()

	f.holderFrame = CreateFrame('Frame', nil, f);
	f.holderFrame:SetPoint('TOP', f, 'TOP', 0, -f.topOffset);
	f.holderFrame:SetSize( 100, 10)

	f.holderFrame.closeButton = CreateFrame('Button', nil, f, 'UIPanelCloseButton');
	f.holderFrame.closeButton:SetPoint('BOTTOMRIGHT', f.holderFrame, 'TOPRIGHT', 10, -2)
	--f.holderFrame.closeButton:SetDesaturated( true)

	if isBank then
----------------------------------------------------------------------------
--				BAG BUTTONS
----------------------------------------------------------------------------
		--Bags Button
		f.bagsButton = CreateFrame("Button", Bag..'BagsButton', f);
		f.bagsButton:SetSize( 16, 16)
		CreateStyleSmall( f.bagsButton, 1)
		f.bagsButton:SetPoint("RIGHT", f.holderFrame.closeButton, "LEFT", -2, 0)
		f.bagsButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton.ttText2 = format("|cffFFFFFF%s|r", BAG_SETTINGS_TOOLTIP)
		f.bagsButton:RegisterForClicks('anyUp')
		f.bagsButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsButton:SetScript('OnClick', function()
			ToggleFrame(f.ContainerHolder)
			PlaySound(852) --IG_MAINMENU_OPTION
			--f.ContainerHolder:SetShown( f.ContainerHolder:IsShown())
		end)

		--Banks Sort Button
		f.bagsSortButton = CreateFrame("Button", Bag..'bagsSortButton', f);
		f.bagsSortButton:SetSize( 17, 17)
		CreateStyleSmall( f.bagsSortButton, 1)
		f.bagsSortButton:SetPoint("RIGHT", f.bagsButton, "LEFT", -3, 0)
		f.bagsSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsSortButton:RegisterForClicks('anyUp')
		f.bagsSortButton.ttText = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. BAG_CLEANUP_BANK
		--f.bagsSortButton.ttText2 = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. REAGENTBANK_DEPOSIT
		f.bagsSortButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsSortButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsSortButton:SetScript('OnClick', function( self, button)
			if button == 'RightButton' then
				PlaySound(852) --IG_MAINMENU_OPTION
				if f.reagentFrame:IsShown() then
					SortReagentBankBags()
				else
					SortBankBags()
				end
			end
		end)

		--Bags to Reageng Button
		f.bagsToReagent = CreateFrame("Button", Bag..'bagsToReagent', f);
		f.bagsToReagent:SetSize( 17, 17)
		CreateStyleSmall( f.bagsToReagent, 1)
		f.bagsToReagent:SetPoint("RIGHT", f.bagsSortButton, "LEFT", -4, 0)
		f.bagsToReagent:SetNormalTexture("Interface\\ICONS\\INV_Misc_Flower_02")
		f.bagsToReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:SetPushedTexture("Interface\\ICONS\\INV_Misc_Flower_02")
		f.bagsToReagent:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:RegisterForClicks('anyUp')
		f.bagsToReagent.ttText = REAGENTBANK_DEPOSIT
		f.bagsToReagent:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsToReagent:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsToReagent:SetScript('OnClick', function( self, button)
				PlaySound(841)
				DepositReagentBank()
		end)

		f.purchaseBagButton = CreateFrame('Button', nil, f)
		f.purchaseBagButton:SetSize( 17, 17)
		CreateStyleSmall( f.purchaseBagButton, 1)
		f.purchaseBagButton:SetPoint("RIGHT", f.bagsToReagent, "LEFT", -5, 0)
		f.purchaseBagButton:SetNormalTexture("Interface\\ICONS\\INV_Misc_Coin_01")
		f.purchaseBagButton:GetNormalTexture():SetTexCoord(unpack( f.texCoord))
		f.purchaseBagButton:SetPushedTexture("Interface\\ICONS\\INV_Misc_Coin_01")
		f.purchaseBagButton:GetPushedTexture():SetTexCoord(unpack( f.texCoord))
		f.purchaseBagButton.ttText = BANK_BAG_PURCHASE
		f.purchaseBagButton:SetScript("OnEnter", self.Tooltip_Show)
		f.purchaseBagButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.purchaseBagButton:SetScript("OnClick", function()
			local _, full = GetNumBankSlots()

			PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)

			if f.reagentFrame:IsShown() then
				StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
			elseif(full) then
--				StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
			else
				if not StaticPopupDialogs['MY_CONFIRM_BUY_BANK_SLOT'] then
					StaticPopupDialogs['MY_CONFIRM_BUY_BANK_SLOT'] = {
						text = CONFIRM_BUY_BANK_SLOT,
						button1 = YES,
						button2 = NO,
						OnAccept = PurchaseSlot,
						OnShow = function(self)
							MoneyFrame_Update(self.moneyFrame, GetBankSlotCost(GetNumBankSlots()))
						end,
						hasMoneyFrame = 1,
						hideOnEscape = 1, timeout = 0,
						preferredIndex = STATICPOPUP_NUMDIALOGS
					}
				end

				StaticPopup_Show('MY_CONFIRM_BUY_BANK_SLOT')
			end
		end)

		f:SetScript('OnHide', function()
			CloseBankFrame()
		end)

		f.reagentFrame = CreateFrame("Frame", "ReagentBankFrame", f);
		f.reagentFrame:SetPoint('TOPLEFT', f, 'TOPLEFT', 10, -35);
		f.reagentFrame:SetSize( 100, 10)
		f.reagentFrame.slots = {}
		f.reagentFrame:SetID( REAGENTBANK_CONTAINER)
		f.reagentFrame:Hide()

		-- Bank / Reagent Toggle Button
		f.bankToggle = CreateFrame( "Button", "ReagentBankFrame"..Bag, f)
		f.bankToggle:SetPoint("TOP", f, "TOP", 10, 0)
		f.bankToggle:SetSize(140, 18)
		frame1px( f.bankToggle)
		CreateStyle( f.bankToggle, 2)
		f.bankToggle:SetBackdropColor(0.3, 0.3, 0.3, 0.6)

		f.bankToggle:RegisterForClicks("AnyUp")
		f.bankToggle:SetScript("OnLeave", function( self)  f.bankToggle:SetBackdropBorderColor(.15,.15,.15, 0) end)
		f.bankToggle:SetScript("OnEnter", function( self)
			local color = n.myColor --RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
			f.bankToggle:SetBackdropBorderColor(color.r, color.g, color.b)
		end)

		f.bankToggle.text = f.bankToggle:CreateFontString( nil, "OVERLAY")
		f.bankToggle.text:SetFont( n.font, 10, "OUTLINE")
		f.bankToggle.text:SetPoint("CENTER")
		f.bankToggle.text:SetText( BANK)

		f.bankToggle:SetScript("OnMouseUp", function()
			PlaySound(841) --IG_CHARACTER_INFO_TAB
			if f.holderFrame:IsShown() then
				_G.BankFrame.selectedTab = 2
				f.holderFrame:Hide()
				f.reagentFrame:Show()
				f.bagsSortButton.ttText = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. BAG_CLEANUP_REAGENT_BANK
				f.bankToggle.text:SetText( REAGENT_BANK)
				--addon:CreateLayout( true)
			else
				_G.BankFrame.selectedTab = 1
				f.reagentFrame:Hide()
				f.holderFrame:Show()
				f.bagsSortButton.ttText = "|cffFFFFFF"..KEY_BUTTON2 ..": |r"..BAG_CLEANUP_BANK
				f.bankToggle.text:SetText( BANK)
			end
			addon.CreateLayout( self, true)
			--self:Layout(true)
			f:Show()
		end)


	else
---------------------------------------------------------------------------------
--				BANK BUTTONS
---------------------------------------------------------------------------------
		--Gold Text
		-- f.goldText = f:CreateFontString(nil, 'OVERLAY')
		-- f.goldText:SetFont( font, fontsize)
		-- f.goldText:SetPoint('BOTTOM', f.holderFrame, 'TOP', 0, 4)
		-- f.goldText:SetJustifyH("RIGHT")
		-- f.goldText:SetText("BAGS FRAME")

		--Bags Button
		f.bagsButton = CreateFrame("Button", Bag..'BankButton', f);
		f.bagsButton:SetSize( 17, 17)
		CreateStyleSmall( f.bagsButton, 1)
		f.bagsButton:SetPoint("RIGHT", f.holderFrame.closeButton, "LEFT", 0, 0)
		f.bagsButton:RegisterForClicks('anyUp')
		f.bagsButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton.ttText2 = format("|cffFFFFFF%s|r", BAG_SETTINGS_TOOLTIP)
		f.bagsButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsButton:SetScript('OnClick', function()
			PlaySound(852) --IG_MAINMENU_OPTION
			--ToggleFrame(f.ContainerHolder)
			f.ContainerHolder:SetShown( not f.ContainerHolder:IsShown())
		end)

		--Bags Sort Button
		f.bagsSortButton = CreateFrame("Button", Bag..'BankSortButton', f);
		f.bagsSortButton:SetSize( 17, 17)
		CreateStyleSmall( f.bagsSortButton, 1)
		f.bagsSortButton:SetPoint("RIGHT", f.bagsButton, "LEFT", -4, 0)
		f.bagsSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsSortButton:RegisterForClicks('anyUp')
		f.bagsSortButton.ttText = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. BAG_CLEANUP_BAGS
		--f.bagsSortButton.ttText2 = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. REAGENTBANK_DEPOSIT
		f.bagsSortButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsSortButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsSortButton:SetScript('OnClick', function( self, button)
			if button == 'RightButton' then
				PlaySound(841)
				SortBags()
			end
		end)

		--Bags to Reageng Button
		f.bagsToReagent = CreateFrame("Button", Bag..'BankToReagent', f);
		f.bagsToReagent:SetSize( 17, 17)
		CreateStyleSmall( f.bagsToReagent, 1)
		f.bagsToReagent:SetPoint("RIGHT", f.bagsSortButton, "LEFT", -4, 0)
		f.bagsToReagent:SetNormalTexture("Interface\\ICONS\\INV_Misc_Flower_02")
		f.bagsToReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:SetPushedTexture("Interface\\ICONS\\INV_Misc_Flower_02")
		f.bagsToReagent:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:RegisterForClicks('anyUp')
		f.bagsToReagent.ttText = REAGENTBANK_DEPOSIT
		f.bagsToReagent:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsToReagent:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsToReagent:SetScript('OnClick', function( self, button)
				PlaySound(841)
				DepositReagentBank()
		end)

		--Auto to Reageng Button
		f.bagsAutoReagent = CreateFrame("Button", Bag..'BankAutoReagent', f);
		f.bagsAutoReagent:SetSize( 17, 17)
		CreateStyleSmall( f.bagsAutoReagent, 1)
		f.bagsAutoReagent:SetPoint("RIGHT", f.bagsToReagent, "LEFT", -4, 0)
		f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check.blp")
		f.bagsAutoReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsAutoReagent:RegisterForClicks('anyUp')
		f.bagsAutoReagent.ttText = AUTO_ACTIVATE_ON
		f.bagsAutoReagent.ttText2 = "|cffffffff" .. REAGENTBANK_DEPOSIT
		f.bagsAutoReagent:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsAutoReagent:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsAutoReagent:SetScript('OnClick', function( self, button)
				Setlers( "Bags#autoReagent", not yo.Bags.autoReagent)
				if yo.Bags.autoReagent then
					f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check.blp")
				else
					f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled.blp")
				end
		end)
		f.bagsAutoReagent:SetScript('OnShow', function( self, button)
				if yo.Bags.autoReagent then
					f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check.blp")
				else
					f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled.blp")
				end
		end)

		--Search
		f.editBox = CreateFrame('EditBox', Bag..'EditBox', f);
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2);
		CreateStyle( f.editBox, 3)
		f.editBox:SetHeight( 15);
		f.editBox:SetWidth( 150);
		f.editBox:SetPoint('BOTTOMLEFT', f.holderFrame, 'TOPLEFT', 0, 7);
		f.editBox:SetAutoFocus(false);
		f.editBox:SetScript("OnEscapePressed", addon.ResetAndClear);
		f.editBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end);
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText);
		f.editBox:SetScript("OnTextChanged", addon.UpdateSearch);
		f.editBox:SetScript('OnChar', addon.UpdateSearch);
		f.editBox:SetText(SEARCH);
		f.editBox:SetFont( n.font, n.fontsize)

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, 'OVERLAY')
		f.editBox.searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
		f.editBox.searchIcon:SetPoint("RIGHT", f.editBox, "RIGHT", 0, -1)
		f.editBox.searchIcon:SetSize(15, 15)
	end

	CreateStyle( f, 5, nil, 0.9)
	tinsert( addon.BagFrames, f)
	return f
end
--------------------------------------------------------------------------------------------------
-----							INIT BAGS
---------------------------------------------------------------------------------------------------
function addon:InitBags()

	addon.BagFrames = {};

	local f = self:CreateBagFrame("yoFrame_BagsFrame")
	f:SetScript("OnShow", addon.OnShow)
	f:SetScript("OnHide", addon.OnHide)

	f:Hide()
	self.bagFrame = f
	self:CreateLayout( false)
end

function addon:InitBank()
	if not self.bankFrame then
		local f = self:CreateBagFrame("yoFrame_BanksFrame", true)
		f:SetScript("OnHide", addon.OnHide)
		f:SetScript("OnShow", addon.OnShow)
		self.bankFrame = f
	end

	--self.bankFrame:UpdateAllSlots();
end

-----------------------------------------------------------------------------------------------
---										EVENTS
------------------------------------------------------------------------------------------------
function addon:OnEvent( event, ...)
	--print( "Event: ", self, event, ...)
	if event == "BAG_UPDATE" then

		for _, bagID in ipairs( self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				addon:CreateLayout( self.isBank);
				return;
			end
		end

		--dprint( event, ": ", ...)
		addon:UpdateBagSlots( self, ...);

		--Refresh search in case we moved items around
		if addon:IsSearching() then
			addon:SetSearch(SEARCH_STRING);
		 end
	elseif event == 'ITEM_LOCK_CHANGED' or event == 'ITEM_UNLOCKED' then
		--dprint( event,  ": ", ...)
		local bag, slot = ...
		if bag == REAGENTBANK_CONTAINER then
			addon:UpdateReagentSlot(slot);
		else
			self:UpdateSlot(...)
		end
	elseif event == "PLAYERBANKSLOTS_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" then
		UpdateAllSlots( self, ...)
		doEquip = false
		--dprint( "event =", event, doEquip)
	elseif event == "PLAYERREAGENTBANKSLOTS_CHANGED" then
		addon:UpdateReagentSlot( ...)
	elseif (event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED") and self:IsShown() then
		UpdateAllSlots( self, ...)
	elseif event == "BANK_BAG_SLOT_FLAGS_UPDATED" then
		addon:CreateLayout( true);
	elseif event == "BAG_SLOT_FLAGS_UPDATED" then
		addon:CreateLayout()
	elseif event == "USE_BIND_CONFIRM" then

	elseif event == 'BAG_UPDATE_COOLDOWN' then
		addon:UpdateCooldowns( self)
		--dprint( "event =", event, doEquip)
	-- else
		-- print( "|cffff0000Unknow:|r ", event, ...)

	end
end

function addon:BANKFRAME_OPENED()
	--print( "Event BANKFRAME_OPENED")
	if not self.bankFrame then
		self:InitBank()
	end

	_G.BankFrame:UnregisterAllEvents()
	_G.BankFrame:UnregisterEvent( "BAG_UPDATE_COOLDOWN")
	_G.BankFrame:Show()

	self:CreateLayout( true)

	UpdateAllSlots( self.bankFrame)
	self.bankFrame:Show()
	addon:Open()

	if yo.Bags.autoReagent then
		PlaySound(841)
		DepositReagentBank()
	end
end

function addon:PLAYERBANKBAGSLOTS_CHANGED() addon:CreateLayout( true) end
function addon:MERCHANT_CLOSED() 			addon:Close() end
function addon:SCRAPPING_MACHINE_SHOW() 	addon:Open() end
function addon:SCRAPPING_MACHINE_CLOSE()	addon:Close() end
function addon:AUCTION_HOUSE_SHOW() 		addon:Open() end
function addon:AUCTION_HOUSE_CLOSED() 		addon:Close() end
function addon:GUILDBANKFRAME_OPENED() 		addon:Open() end
function addon:GUILDBANKFRAME_CLOSED() 		addon:Close() end
function addon:TRADE_SHOW() 				addon:Open() end
function addon:TRADE_CLOSED() 				addon:Close() end
function addon:TRADE_SKILL_SHOW() 			addon:Open() end
function addon:TRADE_SKILL_CLOSE() 			addon:Close() end
function addon:BANKFRAME_CLOSED()
	HideUIPanel(self);
	_G.BankFrame:Hide()

	if self.bankFrame then
		self.bankFrame:Hide()
		addon:Close()
	end
end

function addon:ADDON_LOADED( event, var)

	if var == "Blizzard_Soulbinds" then
		_G.SoulbindViewer.Fx:HookScript( "OnShow", addon.Open)
		_G.SoulbindViewer.Fx:HookScript( "OnHide", addon.Close)

		addon:UnregisterEvent("ADDON_LOADED")
	end
end

function addon:PLAYER_ENTERING_WORLD()
	addon:UnregisterEvent("PLAYER_ENTERING_WORLD")

	--C_Timer.After( 2,  function(f, ...)
		self:InitBags( self)
	--end)

	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	self:RegisterEvent("ADDON_LOADED")
	-- Events for trade skill UI handling
	self:RegisterEvent("SCRAPPING_MACHINE_SHOW");
	self:RegisterEvent("SCRAPPING_MACHINE_CLOSE");
	self:RegisterEvent('AUCTION_HOUSE_SHOW')
	self:RegisterEvent('AUCTION_HOUSE_CLOSED')
	self:RegisterEvent('GUILDBANKFRAME_OPENED')
	self:RegisterEvent('GUILDBANKFRAME_CLOSED')

	self:RegisterEvent('TRADE_SHOW')
	self:RegisterEvent('TRADE_CLOSED')

	self:RegisterEvent('MERCHANT_CLOSED')
	---- self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	-- self:RegisterEvent("BAG_CLOSED")
	---- self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	--self:RegisterEvent("REAGENTBANK_UPDATE")

	_G.BankFrame:UnregisterAllEvents()
	Kill( _G.BankFrame)

	for i=1, NUM_CONTAINER_FRAMES do
		Kill( _G['ContainerFrame'..i])
	end

	_G.BankFrame:SetScale(0.00001)
	_G.BankFrame:SetSize(1, 1)
	_G.BankFrame:SetAlpha(0)
	_G.BankFrame:SetPoint("TOPLEFT")

	_G.BankFrame.GetRight = function() return 100 end

	SetInsertItemsLeftToRight( yo.Bags.LeftToRight)
	SetSortBagsRightToLeft( not yo.Bags.LeftToRight)

	ToggleBackpack 	= addon.Toggle
	ToggleBag 		= addon.Toggle
	ToggleAllBags 	= addon.Toggle

	OpenAllBags 	= addon.Open
	OpenBackpack 	= addon.Open
	CloseAllBags 	= addon.Close
	CloseBackpack 	= addon.Close

	tinsert( UISpecialFrames, "yoFrame_BagsFrame")
	----Hook onto Blizzard Functions
	--B:SecureHook('BackpackTokenFrame_Update', 'UpdateTokens')
	--hooksecurefunc('OpenAllBags', 	addon.Open)
	--hooksecurefunc('OpenBackpack', 	addon.Open)
	--hooksecurefunc('CloseAllBags', 	addon.Close)
	--hooksecurefunc('CloseBackpack', addon.Close)

	--hooksecurefunc('ToggleBag', 	addon.Toggle)
	--hooksecurefunc('ToggleAllBags', addon.Toggle)
	--hooksecurefunc('ToggleBackpack',addon.Toggle)
	--hooksecurefunc('ToggleBag', 	addon.Toggle)

	--hooksecurefunc( "ToggleGameMenu", tryToClose)
	--Bag Assignment Dropdown Menu
	UIDropDownMenu_Initialize( ElvUIAssignBagDropdown, self.AssignBagFlagMenu, "MENU");
end
