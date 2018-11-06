local L, yo = unpack( select( 2, ...))

local _G = _G
local type, ipairs, pairs, unpack, select, assert, pcall = type, ipairs, pairs, unpack, select, assert, pcall
local tinsert = table.insert
local floor, ceil, abs, mod = math.floor, math.ceil, math.abs, math.fmod
local format, len, sub = string.format, string.len, string.sub
local BankFrameItemButton_Update = BankFrameItemButton_Update
local BankFrameItemButton_UpdateLocked = BankFrameItemButton_UpdateLocked
local C_NewItems_IsNewItem = C_NewItems.IsNewItem
local Search = LibStub('LibItemSearch-1.2')

local addon = CreateFrame("Frame", nil, UIParent)
	--addon:RegisterEvent("ADDON_LOADED")
	addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	addon:SetScript('OnEvent', function(self, event, ...) 
		self[event](self, event, ...) 
	end)

ProfessionColors = {
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

AssignmentColors = {
	[0] = {252/255, 59/255, 54/255}, -- fallback
	[2] = {0/255, 127/255, 121/255}, -- equipment
	[3] = {145/255, 242/255, 123/255}, -- consumables
	[4] = {255/255, 81/255, 168/255}, -- tradegoods
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
	local res = ""
	local t={}
	str:gsub(".",function(c) 
		if enrus[c] then 
			c = enrus[c]
		end
		table.insert( t, c ) 
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

function addon:OpenEditbox()
	addon.BagFrame.detail:Hide();
	addon.BagFrame.editBox:Show();
	addon.BagFrame.editBox:SetText( SEARCH);
	addon.BagFrame.editBox:HighlightText();
end

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

	if not (holder and holder.id and holder.id > 0) then return end

	local inventoryID = ContainerIDToInventoryID(holder.id)
	if IsInventoryItemProfessionBag("player", inventoryID) then return end

	local info = UIDropDownMenu_CreateInfo()
    info.text = BAG_FILTER_ASSIGN_TO
    info.isTitle = 1
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info)

    info.isTitle = nil
    info.notCheckable = nil
    info.tooltipWhileDisabled = 1
    info.tooltipOnButton = 1

	for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
		if i ~= LE_BAG_FILTER_FLAG_JUNK then
			info.text = BAG_FILTER_LABELS[i]
			info.func = function(_, _, _, value)
				value = not value

				if holder.id > NUM_BAG_SLOTS then
					SetBankBagSlotFlag(holder.id - NUM_BAG_SLOTS, i, value)
				else
					SetBagSlotFlag(holder.id, i, value)
				end

				holder.tempflag = (value and i) or -1
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
end

function addon:Tooltip_Hide()
	GameTooltip:Hide()
end

function addon:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID);
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.1)
					end
				end
			end
		end
	end
end

local function SetUpAnimGroup(object, type, ...)
	if not type then type = 'Flash' end

	if type == 'Flash' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
		object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
		object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)
	elseif type == 'FlashLoop' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
		object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
		object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)

		object.anim:SetScript("OnFinished", function(_, requested)
			if(not requested) then
				object.anim:Play()
			end
		end)
	elseif type == 'Shake' then
		object.shake = object:CreateAnimationGroup("Shake")
		object.shake:SetLooping("REPEAT")
		object.shake.path = object.shake:CreateAnimation("Path")
		object.shake.path[1] = object.shake.path:CreateControlPoint()
		object.shake.path[2] = object.shake.path:CreateControlPoint()
		object.shake.path[3] = object.shake.path:CreateControlPoint()
		object.shake.path[4] = object.shake.path:CreateControlPoint()
		object.shake.path[5] = object.shake.path:CreateControlPoint()
		object.shake.path[6] = object.shake.path:CreateControlPoint()

		object.shake.path:SetDuration(0.7)
		object.shake.path[1]:SetOffset(random(-9, 7), random(-7, 12))
		object.shake.path[1]:SetOrder(1)
		object.shake.path[2]:SetOffset(random(-5, 9), random(-9, 5))
		object.shake.path[2]:SetOrder(2)
		object.shake.path[3]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[3]:SetOrder(3)
		object.shake.path[4]:SetOffset(random(-9, 9), random(-9, 9))
		object.shake.path[4]:SetOrder(4)
		object.shake.path[5]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[5]:SetOrder(5)
		object.shake.path[6]:SetOffset(random(-9, 7), random(-9, 5))
		object.shake.path[6]:SetOrder(6)
	elseif type == 'Shake_Horizontal' then
		object.shakeh = object:CreateAnimationGroup("ShakeH")
		object.shakeh:SetLooping("REPEAT")
		object.shakeh.path = object.shakeh:CreateAnimation("Path")
		object.shakeh.path[1] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[2] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[3] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[4] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[5] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[6] = object.shakeh.path:CreateControlPoint()

		object.shakeh.path:SetDuration(2)
		object.shakeh.path[1]:SetOffset(-5, 0)
		object.shakeh.path[1]:SetOrder(1)
		object.shakeh.path[2]:SetOffset(5, 0)
		object.shakeh.path[2]:SetOrder(2)
		object.shakeh.path[3]:SetOffset(-2, 0)
		object.shakeh.path[3]:SetOrder(3)
		object.shakeh.path[4]:SetOffset(5, 0)
		object.shakeh.path[4]:SetOrder(4)
		object.shakeh.path[5]:SetOffset(-2, 0)
		object.shakeh.path[5]:SetOrder(5)
		object.shakeh.path[6]:SetOffset(5, 0)
		object.shakeh.path[6]:SetOrder(6)
	else
		local x, y, duration, customName = ...
		if not customName then
			customName = 'anim'
		end
		object[customName] = object:CreateAnimationGroup("Move_In")
		object[customName].in1 = object[customName]:CreateAnimation("Translation")
		object[customName].in1:SetDuration(0)
		object[customName].in1:SetOrder(1)
		object[customName].in2 = object[customName]:CreateAnimation("Translation")
		object[customName].in2:SetDuration(duration)
		object[customName].in2:SetOrder(2)
		object[customName].in2:SetSmoothing("OUT")
		object[customName].out1 = object:CreateAnimationGroup("Move_Out")
		object[customName].out2 = object[customName].out1:CreateAnimation("Translation")
		object[customName].out2:SetDuration(duration)
		object[customName].out2:SetOrder(1)
		object[customName].out2:SetSmoothing("IN")
		object[customName].in1:SetOffset( (x), (y))
		object[customName].in2:SetOffset( (-x),(-y))
		object[customName].out2:SetOffset((x), (y))
		object[customName].out1:SetScript("OnFinished", function() object:Hide() end)
	end
end
 
local function Flash(object, duration, loop)
	if not object.anim then
		SetUpAnimGroup(object, loop and "FlashLoop" or 'Flash')
	end

	if not object.anim.playing then
		object.anim.fadein:SetDuration(duration)
		object.anim.fadeout:SetDuration(duration)
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

function addon:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			local numSlots = GetContainerNumSlots(bagID);
			for slotID = 1, numSlots do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
				end
			end
		end
	end
end

function addon:NewItemGlowSlotSwitch(slot, show)
	if slot and slot.newItemGlow then
		if show then
			slot.newItemGlow:SetVertexColor(1, 1, 1, 0)
			slot.newItemGlow:Show()
			if yo.Bags.newIconAnimation then
				Flash(slot.newItemGlow, 0.5, yo.Bags.newAnimationLoop)
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
				break
			end
		end
	end

	if not active then
		holder.shadow:SetBackdropBorderColor(0.09, 0.09, 0.09)
		--holder.ignoreBorderColors = nil --restore these borders to be updated
	else
		holder.shadow:SetBackdropBorderColor(unpack(color or AssignmentColors[0]))
		--holder.ignoreBorderColors = true --dont allow these border colors to update for now
		return active
	end
end

local function SetOutside(obj, anchor, xOffset, yOffset, anchor2)
	xOffset = xOffset or 1
	yOffset = yOffset or 1
	anchor = anchor or obj:GetParent()

	-- assert(anchor)
	-- if obj:GetPoint() then
		-- obj:ClearAllPoints()
	-- end

	-- obj:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	-- obj:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset, anchor2)
	xOffset = xOffset or 1
	yOffset = yOffset or 1
	anchor = anchor or obj:GetParent()

	assert(anchor)
	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint('TOPLEFT', anchor, 'TOPLEFT', xOffset, -yOffset)
	obj:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', -xOffset, yOffset)
end

local function StyleButton(button, noHover, noPushed, noChecked)
	if button.SetHighlightTexture and not button.hover and not noHover then
		local hover = button:CreateTexture("frame", nil, self)
			hover:SetTexture( texture)
			hover:SetVertexColor( 0, 1, 0, 1)
			hover:SetPoint("TOPLEFT", 2, -2)
			hover:SetPoint("BOTTOMRIGHT", -2, 2)
			hover:SetAlpha( 0.4)
		button.hover = hover
		button:SetHighlightTexture( hover)
			--button:SetHighlightTexture(hover)
	end
	
	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture("frame", nil, self)
			pushed:SetTexture( texture)
			pushed:SetVertexColor( 0, 1, 0, 1)
			pushed:SetPoint("TOPLEFT", 2, -2)
			pushed:SetPoint("BOTTOMRIGHT", -2, 2)
			pushed:SetAlpha( 0.5)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture("frame", nil, self)
			checked:SetTexture( texture)
			checked:SetVertexColor( 1, 1, 0, 1)
			checked:SetPoint("TOPLEFT", 2, -2)
			checked:SetPoint("BOTTOMRIGHT", -2, 2)
			checked:SetAlpha( 0.2)
		button.checked = checked
		button:SetCheckedTexture( checked)
	end
	
	--local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
	--if cooldown then
	--	cooldown:ClearAllPoints()
	--	SetInside( cooldown)
	--	cooldown:SetDrawEdge(false)
	--	cooldown:SetSwipeColor(0, 0, 0, 1)
	--end
end

-----------------------------------------------------------------------------------------------
----													UPDATES
-----------------------------------------------------------------------------------------------
--local function UpgradeCheck_OnUpdate(self, elapsed)
--	self.timeSinceUpgradeCheck = self.timeSinceUpgradeCheck + elapsed;

--	if (self.timeSinceUpgradeCheck >= ITEM_UPGRADE_CHECK_TIME) then
--		UpdateItemUpgradeIcon(self);
--	end
--end

--function UpdateItemUpgradeIcon(slot)
--	--if true then
--	--	slot.UpgradeIcon:SetShown(false);
--	--	slot:SetScript("OnUpdate", nil);
--	--	return
--	--end

--	slot.timeSinceUpgradeCheck = 0;

--	local itemIsUpgrade = IsContainerItemAnUpgrade(slot:GetParent():GetID(), slot:GetID());
--	if itemIsUpgrade == nil then -- nil means not all the data was available to determine if this is an upgrade.
--		slot.UpgradeIcon:SetShown(false);
--		slot:SetScript("OnUpdate", UpgradeCheck_OnUpdate);
--	else
--		slot.UpgradeIcon:SetShown(itemIsUpgrade);
--		slot:SetScript("OnUpdate", nil);
--	end
--	print("check update", itemIsUpgrade)
--end

local function IsItemEligibleForItemLevelDisplay(classID, subClassID, equipLoc, rarity)
	if ((classID == 3 and subClassID == 11) --Artifact Relics
		or (equipLoc ~= nil and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_QUIVER" and equipLoc ~= "INVTYPE_TABARD"))
		and (rarity and rarity > 1) then

		return true
	end

	return false
end

local slotEquipType = {
	["INVTYPE_HEAD"]	=	{1},
	["INVTYPE_NECK"]	=	{2},
	["INVTYPE_SHOULDER"]=	{3},
	--["INVTYPE_BODY"]	=	4,
	["INVTYPE_CHEST"]	=	{5},
	["INVTYPE_ROBE"]	=	{5},
	["INVTYPE_WAIST"]	=	{6},
	["INVTYPE_LEGS"]	=	{7},
	["INVTYPE_FEET"]	=	{8},
	["INVTYPE_WRIST"]	=	{9},
	["INVTYPE_HAND"]	=	{10},
	["INVTYPE_FINGER"]	= 	{11, 12},
	["INVTYPE_TRINKET"]	=	{13, 14},
	["INVTYPE_CLOAK"]	=	{15},
	["INVTYPE_WEAPON"]	=	{16, 17},
	["INVTYPE_SHIELD"]	=	{17},
	["INVTYPE_2HWEAPON"]=	{16},
	["INVTYPE_WEAPONMAINHAND"]	=	{16},
	["INVTYPE_WEAPONOFFHAND"]	=	{17},
	--["INVTYPE_HOLDABLE"]=	{17,},
	["INVTYPE_RANGED"]	=	{16},
	--["INVTYPE_THROWN"]	=	{18,},
	--["INVTYPE_RANGEDRIGHT"]={18,},
	--["INVTYPE_RELIC"]	=	{18,},
}

local function checkSloLocUpdate( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink)  --- C_NewItems_IsNewItem(bagID, slotID))
	local ret = false
	local slotIndexes = slotEquipType[itemEquipLoc]
	--print( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink)
	if slotIndexes and iLvl then

		for i, locSlotID in ipairs( slotIndexes ) do
			local itemLocation = ItemLocation:CreateFromEquipmentSlot( locSlotID)
			local item = Item:CreateFromItemLocation( itemLocation)
			local locLvl = item:GetCurrentItemLevel()
			--tprint( item)
			
			if locLvl and iLvl > locLvl then
				local locLink = item:GetItemLink()
				local locItemSutType = select( 7, GetItemInfo( locLink))
				--local unitLvl = UnitLevel( "player") < GetMaxPlayerLevel()

				if ( C_NewItems.IsNewItem(bagID, slotID) == true) and ( locItemSutType == itemSubType) then
					local locitemRarity = select( 3, GetItemInfo( locLink))
					local loclhexColor = "|c" .. select( 4, GetItemQualityColor(locitemRarity))

					local itemRarity = select( 3, GetItemInfo( clink))
					local hexColor = "|c" .. select( 4, GetItemQualityColor(itemRarity))
					local text = ( _G[itemEquipLoc] or "") .. hexColor .. " [" ..  iLvl .. "] > " .. loclhexColor .. "[".. locLvl .. "] " .. clink .. L["instead"].. locLink

					if yo.Addons.equipNewItem and yo.Addons.equipNewItemLevel > iLvl then					
											
						if InCombatLockdown() then
							print( L["put on"] .. text)
						else
							print( L["weared"] .. text)
							EquipItemByName( clink)	
						end
						C_NewItems.RemoveNewItem(bagID, slotID)

					else
						print( L["can change"] .. text)
						C_NewItems.RemoveNewItem(bagID, slotID)
						ret = true	
					end
				else
					ret = true
				end
			end
		end
	end
	
	slot.UpgradeIcon:SetShown( ret);
end

-----------------------------------------------------------------------------------------------------------------
--																	UPDATE SLOT
-----------------------------------------------------------------------------------------------------------------
function UpdateSlot( self, bagID, slotID)
	--print ("UPDATE_SLOT: ", bagID, slotID)
	if (self.Bags[bagID] and self.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not self.Bags[bagID] or not self.Bags[bagID][slotID] then
		return;
	end

	local slot, _ = self.Bags[bagID][slotID], nil;
	local bagType = self.Bags[bagID].type;

	local assignedID = (self.isBank and bagID) or bagID - 1
	local assignedBag = self.Bags[assignedID] and self.Bags[assignedID].assigned

	slot.name, slot.rarity = nil, nil;
	local texture, count, locked, readable, noValue
	texture, count, locked, slot.rarity, readable, _, _, _, noValue = GetContainerItemInfo(bagID, slotID);

	local clink = GetContainerItemLink(bagID, slotID);

	slot:Show();
	if(slot.questIcon) then
		slot.questIcon:Hide();
	end

	if Search:InSet( clink) then
		slot.SetIcon:Show()
	else		
		slot.SetIcon:Hide()
	end

	if (slot.JunkIcon) then
		if (slot.rarity) and (slot.rarity == LE_ITEM_QUALITY_POOR and not noValue)  then
			slot.JunkIcon:Show();
		else
			slot.JunkIcon:Hide()
		end
	end

	if slot.UpgradeIcon then
		slot.UpgradeIcon:Hide()
	end
	slot.itemLevel:SetText("")

	if ProfessionColors[bagType] then
		local r, g, b = unpack( ProfessionColors[bagType])
		--slot.newItemGlow:SetVertexColor(r, g, b , 0.2)
		slot.shadow:SetBackdropBorderColor(r, g, b, 0.9)
		--slot.ignoreBorderColors = true
	elseif (clink) then
		local iLvl, itemEquipLoc, itemClassID, itemSubClassID
		slot.name, _, _, _, _, _, itemSubType, _, itemEquipLoc, _, _, itemClassID, itemSubClassID = GetItemInfo(clink);
		--iLvl = GetDetailedItemLevelInfo(clink)
		
		local item = Item:CreateFromBagAndSlot(bagID, slotID)
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
			if (iLvl >= 10) then
				slot.itemLevel:SetText(iLvl)
				slot.itemLevel:SetTextColor(r, g, b)		
			end
		end
	
		if slot.UpgradeIcon then
			--Check if item is an upgrade and show/hide upgrade icon accordingly
			--UpdateItemUpgradeIcon(slot)
			--local itemLocation = ItemLocation:CreateFromBagAndSlot( bagID, slotID)
			checkSloLocUpdate( bagID, slotID, slot, itemEquipLoc, itemSubType, iLvl, clink)  --- C_NewItems_IsNewItem(bagID, slotID))
			--MultiCheckLockation( slot, itemLocation, itemEquipLoc, bagID, slotID)
		end

		-- color slot according to item quality
		if questId and not isActiveQuest then
			--slot.newItemGlow:SetVertexColor(1.0, 0.3, 0.2);
			slot.shadow:SetBackdropBorderColor(1.0, 0.3, 0.3, 0.9);
			--slot.ignoreBorderColors = true
			if(slot.questIcon) then
				slot.questIcon:Show();
			end
		elseif questId or isQuestItem then
			--slot.newItemGlow:SetVertexColor(1.0, 0.3, 0.2);
			slot.shadow:SetBackdropBorderColor(1.0, 0.3, 0.3, 0.9);
			--slot.ignoreBorderColors = true
			if(slot.questIcon) then
				slot.questIcon:Show();
			end
		elseif slot.rarity and slot.rarity > 1 then
			--slot.newItemGlow:SetVertexColor(r, g, b, 0.2);
			slot.shadow:SetBackdropBorderColor(r, g, b, 0.9);
			--slot.ignoreBorderColors = true
		elseif AssignmentColors[assignedBag] then
			local rr, gg, bb = unpack( AssignmentColors[assignedBag])
			--slot.newItemGlow:SetVertexColor(rr, gg, bb, 0.2)
			slot.shadow:SetBackdropBorderColor(rr, gg, bb, 0.9)
			--slot.ignoreBorderColors = true
		else
			--slot.newItemGlow:SetVertexColor(1, 1, 1 , 0.2)
			slot.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 1)
			--slot.ignoreBorderColors = nil
		end
	elseif AssignmentColors[assignedBag] then
		local rr, gg, bb = unpack( AssignmentColors[assignedBag])
		--slot.newItemGlow:SetVertexColor(rr, gg, bb, 0.2)
		slot.shadow:SetBackdropBorderColor(rr, gg, bb, 0.25)    -- Prof Bags
		--slot.ignoreBorderColors = true
	else
		--slot.newItemGlow:SetVertexColor(1, 0.5, 0, 0.2)
		slot.shadow:SetBackdropBorderColor( .09, .09, .09, .9)
		--slot.ignoreBorderColors = nil
	end

	addon:NewItemGlowSlotSwitch(slot, C_NewItems_IsNewItem(bagID, slotID))

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

	if GameTooltip:GetOwner() == slot and not slot.hasItem then
		GameTooltip:Hide()
	end
end

function addon:UpdateBagSlots(bagID)
	if(bagID == REAGENTBANK_CONTAINER) then
		for i=1, 98 do
			self:UpdateReagentSlot(i);
		end
	else
		for slotID = 1, GetContainerNumSlots(bagID) do
			if self.UpdateSlot then
				self:UpdateSlot(bagID, slotID);
			else
				self:GetParent():GetParent():UpdateSlot(bagID, slotID);
			end
		end
	end
end

function UpdateAllSlots( self, ...)
	--print( "UpdateAllSlots: ", self:GetName(), self.BagIDs)

	for _, bagID in ipairs( self.BagIDs) do
		if self.Bags[bagID] then
			--self.Bags[bagID]:UpdateBagSlots( bagID);
			addon.UpdateBagSlots( self, bagID);
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

function addon_Toggle()
	--print( "addon_Toggle")
	if addon.bagFrame:IsShown() then
		addon.bagFrame:Hide()
	else
		addon.bagFrame:Show()
	end
	
end

function addon_Open()
	--print( "BAGS Frame Open")
	addon.bagFrame:Show()
	UpdateAllSlots( addon.bagFrame)
	--PlaySound ( 862, "Master")
end

function addon_Close()
	--print( "BAGS Close")
	addon.bagFrame:Hide()	
end

local function addon_OnShow()
	--print( "Event addon_ONShow")
	-- Stuffing:PLAYERBANKSLOTS_CHANGED(29)

	-- for i = 0, #BAGS_BACKPACK - 1 do
		-- Stuffing:BAG_UPDATE(i)
	-- end

	-- Stuffing:Layout()
	-- Stuffing:SearchReset()
	-- collectgarbage("collect")
end

local function addonBank_OnHide()
	--print( "Event addonBANK_ONhide")
	addon.bankFrame:Hide()
	addon.bagFrame:Hide()
	BankFrame:Hide()
	CloseBankFrame()
end

local function addonBank_OnShow()
	--print( "Event addonBANK_ONShow")
	--OpenBankFrame()
	ReagentBankHelpBox:Show();

	if addon.bankFrame then
		addon.bankFrame:Show()
		UpdateAllSlots( addon.bankFrame)
	end

	if yo.Bags.autoReagent then
		PlaySound(841) 
		DepositReagentBank()
	end
end

local function addon_OnHide()
	--print( "Event addonBAG_ONhide")

	if addon.bankFrame and addon.bankFrame:IsShown() then
		addon.bankFrame:Hide()
		CloseAllBags(self);
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
	local texture, count, locked = GetContainerItemInfo(bagID, slotID);
	local clink = GetContainerItemLink(bagID, slotID);
	local slot = _G["ReagentBankFrameItem"..slotID]
	if not slot then return; end

	slot:Show();
	if(slot.questIcon) then
		slot.questIcon:Hide();
	end

	slot.name, slot.rarity = nil, nil;

	local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
	CooldownFrame_Set(slot.Cooldown, start, duration, enable)
	if ( duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4);
	else
		SetItemButtonTextureVertexColor(slot, 1, 1, 1);
	end
	
	if not slot.shadow then
		CreateStyle( slot, 2)
	end
	
	if (clink) then
		local name, _, rarity = GetItemInfo(clink);
		slot.name, slot.rarity = name, rarity

		local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bagID, slotID);
		local r, g, b

		if slot.rarity then
			r, g, b = GetItemQualityColor(slot.rarity);
		end

		-- color slot according to item quality
		if questId and not isActiveQuest then
			--slot.newItemGlow:SetVertexColor(1.0, 0.3, 0.2);
			slot.shadow:SetBackdropBorderColor(1.0, 0.3, 0.9);
			--slot.ignoreBorderColors = true
			if (slot.questIcon) then
				slot.questIcon:Show();
			end
		elseif questId or isQuestItem then
			--slot.newItemGlow:SetVertexColor(1.0, 0.3, 0.2);
			slot.shadow:SetBackdropBorderColor(1.0, 0.3, 0.9);
			--slot.ignoreBorderColors = true
		elseif slot.rarity and slot.rarity > 1 then
			--slot.newItemGlow:SetVertexColor(r, g, b, 0.2);
			slot.shadow:SetBackdropBorderColor(r, g, b);
			--slot.ignoreBorderColors = true
		else
			--slot.newItemGlow:SetVertexColor(1, 1, 1, 0.2)
			slot.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 0.9)
			--slot.ignoreBorderColors = nil
		end
	else
		--slot.newItemGlow:SetVertexColor(1, 0.5, 0, 0);   ----------!!!!!!!!!!!!!!!
		slot.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 0.9)
		--slot.ignoreBorderColors = nil
	end

	addon:NewItemGlowSlotSwitch(slot, C_NewItems_IsNewItem(bagID, slotID))

	SetItemButtonTexture(slot, texture);
	SetItemButtonCount(slot, count);
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5);
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

function addon:CreateLayout( isBank)
	--f = addon:GetContainerFrame( true)
	
	local f = self:GetContainerFrame(isBank);
	
	if not f then return; end
	
	--local numContainerColumns 	= yo["Bags"]["numContainerColumns"]
	local buttonSize 			= yo["Bags"]["buttonSize"] 
	local buttonSpacing 		= yo["Bags"]["buttonSpacing"]
	local containerWidth 		= yo["Bags"]["containerWidth"]
	local numMaxRow 			= yo["Bags"]["numMaxRow"]

	local numContainerColumns, numContainerRows, holderWidth = 0, 0, 0
	local maxSlots = GetMaxSlots( f)

	repeat
		numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing));
		holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing;
		local rows = math.ceil( maxSlots / numContainerColumns)
		
		if rows > numMaxRow then
			containerWidth = containerWidth + buttonSize + buttonSpacing
		end
	until rows <= numMaxRow

	f.holderFrame:SetWidth(holderWidth);

	if(isBank) then
		f.reagentFrame:SetWidth(holderWidth)
	end

	f.totalSlots = 0
	local lastButton;
	local lastRowButton;
	local lastContainerButton;
	local numContainerSlots = GetNumBankSlots();
	
	for i, bagID in ipairs(f.BagIDs) do
		local assignedBag
	
		--print( i, bagID, isBank, numContainerSlots, f:GetName(), GetContainerNumSlots(bagID))

		--Bag Containers
		if (not isBank and bagID <= 3 ) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then
			if not f.ContainerHolder[i] then
				--print( 'PutOUT - 1')
				if(isBank) then
					f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIBankBag" .. (bagID-4), f.ContainerHolder, "BankItemButtonBagTemplate")
					f.ContainerHolder[i]:RegisterForClicks("AnyUp");
					f.ContainerHolder[i]:SetScript('OnClick', function( holder, button)
						if button == "RightButton" and holder.id then
							ElvUIAssignBagDropdown.holder = holder
							ToggleDropDownMenu(1, nil, ElvUIAssignBagDropdown, "cursor")
						else
							local inventoryID = holder:GetInventorySlot();
							PutItemInBag(inventoryID);--Put bag on empty slot, or drop item in this bag
						end
					end)
				else
					f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIMainBag" .. bagID .. "Slot", f.ContainerHolder, "BagSlotButtonTemplate")
					f.ContainerHolder[i]:RegisterForClicks("AnyUp");
					f.ContainerHolder[i]:SetScript('OnClick', function(holder, button)
						if button == "RightButton" and holder.id then
							ElvUIAssignBagDropdown.holder = holder
							ToggleDropDownMenu(1, nil, ElvUIAssignBagDropdown, "cursor")
						else
							local id = holder:GetID();
							PutItemInBag(id);--Put bag on empty slot, or drop item in this bag
						end
					end)
				end
							
				if not f.ContainerHolder[i].shadow then
					CreateStyle( f.ContainerHolder[i], 2)
					--frame1px( f.ContainerHolder[i])
					StyleButton( f.ContainerHolder[i])
				end
				
				f.ContainerHolder[i].IconBorder:SetAlpha(0)
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")

				f.ContainerHolder[i].id = isBank and bagID or bagID + 1
				f.ContainerHolder[i]:HookScript("OnEnter", function(self) addon.SetSlotAlphaForBag(self, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(self) addon.ResetSlotAlphaForBags(self, f) end)

				if isBank then
					f.ContainerHolder[i]:SetID(bagID - 4)
					if not f.ContainerHolder[i].tooltipText then
						f.ContainerHolder[i].tooltipText = ""
					end
				end

				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName()..'IconTexture'];
				SetInside( f.ContainerHolder[i].iconTexture)
				f.ContainerHolder[i].iconTexture:SetTexCoord( unpack( f.texCoord))			--( 0.07, 0.93, 0.07, 0.93)
			end

			f.ContainerHolder:SetSize(((buttonSize) * (isBank and i - 1 or i)) + 10, buttonSize + (buttonSpacing * 2))

			if isBank then
				--print( "erroe")
				BankFrameItemButton_Update( f.ContainerHolder[i])
				BankFrameItemButton_UpdateLocked( f.ContainerHolder[i])
			end

			assignedBag = addon:GetBagAssignedInfo(f.ContainerHolder[i])

			f.ContainerHolder[i]:SetSize( buttonSize, buttonSize)
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then
				f.ContainerHolder[i]:SetPoint('BOTTOMLEFT', f.ContainerHolder, 'BOTTOMLEFT', buttonSpacing, buttonSpacing)
			else
				f.ContainerHolder[i]:SetPoint('LEFT', lastContainerButton, 'RIGHT', 0, 0)
			end

			lastContainerButton = f.ContainerHolder[i];
		end

		--Bag Slots
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
			for i = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID][i] then
					f.Bags[bagID][i]:Hide();
				end
			end

			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1;
				if not f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID] = CreateFrame('CheckButton', f.Bags[bagID]:GetName()..'Slot'..slotID, f.Bags[bagID], bagID == -1 and 'BankItemButtonGenericTemplate' or 'ContainerFrameItemButtonTemplate');
					
					if not f.Bags[bagID][slotID].shadow then 
						CreateStyle( f.Bags[bagID][slotID], 2)
						--frame1px( f.Bags[bagID][slotID])
						StyleButton( f.Bags[bagID][slotID])
						--f.Bags[bagID][slotID].IconBorder:SetAlpha(0)
					end
					
					f.Bags[bagID][slotID]:SetNormalTexture(nil);
					f.Bags[bagID][slotID]:SetCheckedTexture(nil);

					if(_G[f.Bags[bagID][slotID]:GetName()..'NewItemTexture']) then
						_G[f.Bags[bagID][slotID]:GetName()..'NewItemTexture']:Hide()
					end

					f.Bags[bagID][slotID].Count:ClearAllPoints();
					f.Bags[bagID][slotID].Count:SetPoint('BOTTOMRIGHT', 0, 2);
					f.Bags[bagID][slotID].Count:SetFont( font, fontsize -0, "OUTLINE")
						
					if not(f.Bags[bagID][slotID].questIcon) then
						f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName()..'IconQuestTexture'] or _G[f.Bags[bagID][slotID]:GetName()].IconQuestTexture
						f.Bags[bagID][slotID].questIcon:SetTexture("Interface\\AddOns\\yoFrame\\media\\bagQuestIcon");
						f.Bags[bagID][slotID].questIcon:SetTexCoord(0,1,0,1);
						SetInside( f.Bags[bagID][slotID].questIcon)
						f.Bags[bagID][slotID].questIcon:Show();
					end

					if f.Bags[bagID][slotID].UpgradeIcon then
						f.Bags[bagID][slotID].UpgradeIcon:ClearAllPoints()
						f.Bags[bagID][slotID].UpgradeIcon:SetPoint("BOTTOMRIGHT", f.Bags[bagID][slotID], "BOTTOMRIGHT", 8, -7)
						f.Bags[bagID][slotID].UpgradeIcon.ClearAllPoints 	= dummy
						f.Bags[bagID][slotID].UpgradeIcon.SetPoint 			= dummy
						f.Bags[bagID][slotID].UpgradeIcon:SetTexture("Interface\\AddOns\\yoFrame\\media\\bagUpgradeIcon");
						f.Bags[bagID][slotID].UpgradeIcon:SetTexCoord(0,1,0,1);
						SetInside( f.Bags[bagID][slotID].UpgradeIcon)
						f.Bags[bagID][slotID].UpgradeIcon:Hide();
					end

					--.JunkIcon only exists for items created through ContainerFrameItemButtonTemplate
					if not f.Bags[bagID][slotID].JunkIcon then
						local JunkIcon = f.Bags[bagID][slotID]:CreateTexture(nil, "OVERLAY")
						JunkIcon:SetAtlas("bags-junkcoin")
						JunkIcon:SetPoint("TOPLEFT", 1, 0)
						JunkIcon:Hide()
						f.Bags[bagID][slotID].JunkIcon = JunkIcon
					end

					if not f.Bags[bagID][slotID].SetIcon then
						local SetIcon = f.Bags[bagID][slotID]:CreateTexture(nil, "OVERLAY")
						--SetIcon:SetAtlas("bags-junkcoin")
						SetIcon:SetPoint("BOTTOMLEFT", 1, 1)
						SetIcon:SetSize( 7, 7)
						SetIcon:SetTexture(texture)
						SetIcon:SetVertexColor(0, 1, 0, 1)
						SetIcon:Hide()
						f.Bags[bagID][slotID].SetIcon = SetIcon
					end

					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName()..'IconTexture'];
					SetInside( f.Bags[bagID][slotID].iconTexture) --, f.Bags[bagID][slotID]);
					f.Bags[bagID][slotID].iconTexture:SetTexCoord( unpack( f.texCoord))  		--( 0.07, 0.93, 0.07, 0.93)
					--f.Bags[bagID][slotID].iconTexture:SetAllPoints( f.Bags[bagID][slotID]);

					
					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName()..'Cooldown'];
					f.Bags[bagID][slotID].cooldown.ColorOverride = 'bags'
					--E:RegisterCooldown(f.Bags[bagID][slotID].cooldown)
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID

					f.Bags[bagID][slotID].itemLevel = f.Bags[bagID][slotID]:CreateFontString(nil, 'OVERLAY')
					f.Bags[bagID][slotID].itemLevel:SetPoint("TOP", 0, -2)
					f.Bags[bagID][slotID].itemLevel:SetFont( font, fontsize - 1, "OUTLINE")

					if(f.Bags[bagID][slotID].BattlepayItemTexture) then
						f.Bags[bagID][slotID].BattlepayItemTexture:Hide()
					end

					if not f.Bags[bagID][slotID].newItemGlow then
						local newItemGlow = f.Bags[bagID][slotID]:CreateTexture(nil, "OVERLAY")
						SetInside( newItemGlow)
						newItemGlow:SetTexture("Interface\\AddOns\\yoFrame\\media\\bagNewItemGlow")
						newItemGlow:Hide()
						f.Bags[bagID][slotID].newItemGlow = newItemGlow
						f.Bags[bagID][slotID]:HookScript("OnEnter", hideNewItemGlow)
					end
				end

				f.Bags[bagID][slotID]:SetID(slotID);
				f.Bags[bagID][slotID]:SetSize( buttonSize, buttonSize)

				if f.Bags[bagID][slotID].JunkIcon then
					f.Bags[bagID][slotID].JunkIcon:SetSize( buttonSize/2, buttonSize/2)
				end
				--print( "TO UPDARE: ", f, bagID, slotID)
				f:UpdateSlot( bagID, slotID);
				
				if f.Bags[bagID][slotID]:GetPoint() then
					f.Bags[bagID][slotID]:ClearAllPoints();
				end

				if lastButton then
					if (f.totalSlots - 1) % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing);
						lastRowButton = f.Bags[bagID][slotID];
						numContainerRows = numContainerRows + 1;
					else
						f.Bags[bagID][slotID]:SetPoint('LEFT', lastButton, 'RIGHT', buttonSpacing, 0);
					end
				else
					f.Bags[bagID][slotID]:SetPoint('TOPLEFT', f.holderFrame, 'TOPLEFT');
					lastRowButton = f.Bags[bagID][slotID];
					numContainerRows = numContainerRows + 1;
				end

				lastButton = f.Bags[bagID][slotID];
			end
		else
			--Hide unused slots
			for i = 1, MAX_CONTAINER_ITEMS do
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

			if(not f.reagentFrame.slots[i]) then
				f.reagentFrame.slots[i] = CreateFrame("Button", "ReagentBankFrameItem"..i, f.reagentFrame, "ReagentBankItemButtonGenericTemplate");
				f.reagentFrame.slots[i]:SetID(i)

				StyleButton( f.reagentFrame.slots[i])
				--frame1px( f.reagentFrame.slots[i])
				if not f.reagentFrame.slots[i].shadow then
					CreateStyle( f.reagentFrame.slots[i], 2)
				end
								
				f.reagentFrame.slots[i]:SetNormalTexture(nil);
				f.reagentFrame.slots[i].Count:ClearAllPoints();
				f.reagentFrame.slots[i].Count:SetPoint('BOTTOMRIGHT', 0, 2);
				f.reagentFrame.slots[i].Count:SetFont( font, fontsize -0, "OUTLINE") --, .db.bags.countFontOutline)

				f.reagentFrame.slots[i].iconTexture = _G[f.reagentFrame.slots[i]:GetName()..'IconTexture'];
				SetInside( f.reagentFrame.slots[i].iconTexture, f.reagentFrame.slots[i])
				f.reagentFrame.slots[i].iconTexture:SetTexCoord( .08, .92, .08, .92)
				f.reagentFrame.slots[i].IconBorder:SetAlpha(0)

				if not f.reagentFrame.slots[i].newItemGlow then
					local newItemGlow = f.reagentFrame.slots[i]:CreateTexture(nil, "OVERLAY")
					SetInside( newItemGlow)
					newItemGlow:SetTexture("Interface\\AddOns\\yoFrame\\media\\bagNewItemGlow")
					--newItemGlow:SetVertexColor(1, 1, 1, 0.1)
					newItemGlow:Hide()
					f.reagentFrame.slots[i].newItemGlow = newItemGlow
					f.reagentFrame.slots[i]:HookScript("OnEnter", hideNewItemGlow)
				end
			end
		 
			f.reagentFrame.slots[i]:ClearAllPoints()
			f.reagentFrame.slots[i]:SetSize( buttonSize, buttonSize)
			if(f.reagentFrame.slots[i-1]) then
				if(totalSlots - 1) % numContainerColumns == 0 then
					f.reagentFrame.slots[i]:SetPoint('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing);
					lastRowButton = f.reagentFrame.slots[i];
					numContainerRows = numContainerRows + 1;
				else
					f.reagentFrame.slots[i]:SetPoint('LEFT', f.reagentFrame.slots[i-1], 'RIGHT', buttonSpacing, 0);
				end
			else
				f.reagentFrame.slots[i]:SetPoint('TOPLEFT', f.reagentFrame, 'TOPLEFT');
				lastRowButton = f.reagentFrame.slots[i]
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
	f.texCoord = {.08, .92, .08, .92} --{ 0.07, 0.93, 0.07, 0.93}	
	
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
	f:SetScript("OnEvent", OnEvent)
	
	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4};
	f.Bags = {};
	
	if isBank then
		f:SetPoint( "BOTTOMLEFT", LeftDataPanel, "TOPLEFT", 2, 46)
	else
		f:SetPoint( "BOTTOMRIGHT", RightDataPanel, "TOPRIGHT", -2, 46)
	end
	
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnClick", function(self) if IsControlKeyDown() then print( "boom") end end)
	f:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	f.ContainerHolder = CreateFrame('Button', Bag..'ContainerHolder', f)
	f.ContainerHolder:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', -3, 3)
	--frame1px( f.ContainerHolder)
	CreateStyle( f.ContainerHolder, 2)
	f.ContainerHolder:Hide()
	
	f.holderFrame = CreateFrame('Frame', nil, f);
	f.holderFrame:SetPoint('TOP', f, 'TOP', 0, -f.topOffset);
	f.holderFrame:SetSize( 100, 10)
	
	f.holderFrame.closeButton = CreateFrame('Button', nil, f, 'UIPanelCloseButton');
	f.holderFrame.closeButton:SetPoint('BOTTOMRIGHT', f.holderFrame, 'TOPRIGHT', 10, -2)
	--f.holderFrame.closeButton:SetDesaturated( true)
	
	if isBank then		
	
		--Bags Button
		f.bagsButton = CreateFrame("Button", "yo_" .. Bag..'BagsButton', f);
		f.bagsButton:SetSize( 16, 16)
		--frame1px( f.bagsButton)
		CreateStyle( f.bagsButton, 2)
		f.bagsButton:SetPoint("RIGHT", f.holderFrame.closeButton, "LEFT", -2, 0)
		f.bagsButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsButton:GetNormalTexture())
		f.bagsButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsButton:GetPushedTexture())
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton.ttText2 = format("|cffFFFFFF%s|r", BAG_SETTINGS_TOOLTIP)
		f.bagsButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsButton:SetScript('OnClick', function() ToggleFrame(f.ContainerHolder) end)
				
		--Banks Sort Button
		f.bagsSortButton = CreateFrame("Button", "yo_" .. Bag..'bagsSortButton', f);
		f.bagsSortButton:SetSize( 17, 17)
		--frame1px( f.bagsSortButton)
		CreateStyle( f.bagsSortButton, 2)
		f.bagsSortButton:SetPoint("RIGHT", f.bagsButton, "LEFT", 0, 0)
		f.bagsSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsSortButton:GetNormalTexture())
		f.bagsSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsSortButton:GetPushedTexture())
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
		f.bagsToReagent = CreateFrame("Button", "yo_" .. Bag..'bagsToReagent', f);
		f.bagsToReagent:SetSize( 17, 17)
		CreateStyle( f.bagsToReagent, 2)
		f.bagsToReagent:SetPoint("RIGHT", f.bagsSortButton, "LEFT", -4, 0)
		f.bagsToReagent:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up.blp")
		f.bagsToReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down.blp")
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
		CreateStyle( f.purchaseBagButton, 2)
		f.purchaseBagButton:SetPoint("RIGHT", f.bagsToReagent, "LEFT", -5, 0)
		f.purchaseBagButton:SetNormalTexture("Interface\\ICONS\\INV_Misc_Coin_01")
		f.purchaseBagButton:GetNormalTexture():SetTexCoord(unpack( f.texCoord))
		SetInside(f.purchaseBagButton:GetNormalTexture())
		f.purchaseBagButton:SetPushedTexture("Interface\\ICONS\\INV_Misc_Coin_01")
		f.purchaseBagButton:GetPushedTexture():SetTexCoord(unpack( f.texCoord))
		SetInside( f.purchaseBagButton:GetPushedTexture())
		--f.purchaseBagButton:StyleButton(nil, true)
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
		f.bankToggle:SetBackdropColor(0.3, 0.3, 0.3, 0.5)

		f.bankToggle:RegisterForClicks("AnyUp")
		f.bankToggle:SetScript("OnLeave", function( self)  f.bankToggle:SetBackdropBorderColor(.15,.15,.15, 0) end)
		f.bankToggle:SetScript("OnEnter", function( self)
			local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
			f.bankToggle:SetBackdropBorderColor(color.r, color.g, color.b)
		end)
		
		f.bankToggle.text = f.bankToggle:CreateFontString( nil, "OVERLAY")
		f.bankToggle.text:SetFont( font, 10, "OUTLINE")
		f.bankToggle.text:SetPoint("CENTER")
		f.bankToggle.text:SetText( BANK)
		
		f.bankToggle:SetScript("OnMouseUp", function()
			PlaySound(841) --IG_CHARACTER_INFO_TAB
			if f.holderFrame:IsShown() then
				BankFrame.selectedTab = 2
				f.holderFrame:Hide()
				f.reagentFrame:Show()
				f.bagsSortButton.ttText = "|cffFFFFFF" ..KEY_BUTTON2 .. ": |r" .. BAG_CLEANUP_REAGENT_BANK
				f.bankToggle.text:SetText( REAGENT_BANK)
				--addon:CreateLayout( true)
			else
				BankFrame.selectedTab = 1
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
		--Gold Text
		-- f.goldText = f:CreateFontString(nil, 'OVERLAY')
		-- f.goldText:SetFont( font, fontsize)
		-- f.goldText:SetPoint('BOTTOM', f.holderFrame, 'TOP', 0, 4)
		-- f.goldText:SetJustifyH("RIGHT")
		-- f.goldText:SetText("BAGS FRAME")
		
		--Bags Button
		f.bagsButton = CreateFrame("Button", "yo_" .. Bag..'BagsButton', f);
		f.bagsButton:SetSize( 17, 17)
		--frame1px( f.bagsButton)
		CreateStyle( f.bagsButton, 2)
		f.bagsButton:SetPoint("RIGHT", f.holderFrame.closeButton, "LEFT", 0, 0)
		f.bagsButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsButton:GetNormalTexture())
		f.bagsButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Up")
		f.bagsButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsButton:GetPushedTexture())
		f.bagsButton.ttText = BAGSLOTTEXT
		f.bagsButton.ttText2 = format("|cffFFFFFF%s|r", BAG_SETTINGS_TOOLTIP)
		f.bagsButton:SetScript("OnEnter", addon.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", addon.Tooltip_Hide)
		f.bagsButton:SetScript('OnClick', function() ToggleFrame(f.ContainerHolder) end)

		--Bags Sort Button
		f.bagsSortButton = CreateFrame("Button", "yo_" .. Bag..'bagsSortButton', f);
		f.bagsSortButton:SetSize( 17, 17)
		--frame1px( f.bagsSortButton)
		CreateStyle( f.bagsSortButton, 2)
		f.bagsSortButton:SetPoint("RIGHT", f.bagsButton, "LEFT", 0, 0)
		f.bagsSortButton:SetNormalTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsSortButton:GetNormalTexture())
		f.bagsSortButton:SetPushedTexture("Interface\\ICONS\\INV_Pet_Broom")
		f.bagsSortButton:GetPushedTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsSortButton:GetPushedTexture())
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
		f.bagsToReagent = CreateFrame("Button", "yo_" .. Bag..'bagsToReagent', f);
		f.bagsToReagent:SetSize( 17, 17)
		CreateStyle( f.bagsToReagent, 2)
		f.bagsToReagent:SetPoint("RIGHT", f.bagsSortButton, "LEFT", -4, 0)
		f.bagsToReagent:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up.blp")
		f.bagsToReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		f.bagsToReagent:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down.blp")
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
		f.bagsAutoReagent = CreateFrame("Button", "yo_" .. Bag..'bagsAutoReagent', f);
		f.bagsAutoReagent:SetSize( 17, 17)
		CreateStyle( f.bagsAutoReagent, 2)
		f.bagsAutoReagent:SetPoint("RIGHT", f.bagsToReagent, "LEFT", -4, 0)
		f.bagsAutoReagent:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Check.blp")
		f.bagsAutoReagent:GetNormalTexture():SetTexCoord( unpack( f.texCoord))
		SetInside( f.bagsAutoReagent:GetNormalTexture())		
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
		f.editBox:SetFont( font, fontsize)

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, 'OVERLAY')
		f.editBox.searchIcon:SetTexture("Interface\\Common\\UI-Searchbox-Icon")
		f.editBox.searchIcon:SetPoint("RIGHT", f.editBox, "RIGHT", 0, -1)
		f.editBox.searchIcon:SetSize(15, 15)
	end
	
	CreateStyle( f, 5)
	tinsert( addon.BagFrames, f)
	return f
end	
--------------------------------------------------------------------------------------------------
-----							INIT BAGS
---------------------------------------------------------------------------------------------------
function addon:InitBags()

	addon.BagFrames = {};

	local f = self:CreateBagFrame("ElvUI_ContainerFrame")
	f:SetScript("OnShow", addon_OnShow)
	f:SetScript("OnHide", addon_OnHide)
	
	f:Hide()
	self.bagFrame = f
	self:CreateLayout( false)
end

function addon:InitBank()
	if not self.bankFrame then
		local f = self:CreateBagFrame("ElvUI_BankContainerFrame", true)
		f:SetScript("OnHide", addonBank_OnHide)
		f:SetScript("OnShow", addonBank_OnShow)
		self.bankFrame = f
	end

	--self.bankFrame:UpdateAllSlots();
end

-----------------------------------------------------------------------------------------------
---										EVENTS
------------------------------------------------------------------------------------------------
function OnEvent( self, event, ...)
	--print( "Event: ", self:GetName(), event, ...)
	if event == "BAG_UPDATE" then
		--print( "BAG_UPDATE: ", self, self.BagIDs, ...)
		for _, bagID in ipairs( self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				addon:CreateLayout( self.isBank);
				return;
			end
		end
		
		addon.UpdateBagSlots( self, ...);
		
		--Refresh search in case we moved items around
		if addon:IsSearching() then
			addon:SetSearch(SEARCH_STRING);
		 end
	elseif event == 'ITEM_LOCK_CHANGED' or event == 'ITEM_UNLOCKED' then
		local bag, slot = ...
		if bag == REAGENTBANK_CONTAINER then
			addon:UpdateReagentSlot(slot);
		else
			self:UpdateSlot(...)
		end
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		UpdateAllSlots( self, ...)
	elseif event == "PLAYERREAGENTBANKSLOTS_CHANGED" then
		addon.UpdateReagentSlot( self, ...)
	elseif (event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED") and self:IsShown() then
		UpdateAllSlots( self, ...)
	elseif event == "BANK_BAG_SLOT_FLAGS_UPDATED" then
		addon:CreateLayout( true);
	elseif event == "BAG_SLOT_FLAGS_UPDATED" then
		addon:CreateLayout()
	-- else
		-- print( "|cffff0000Unknow:|r ", event, ...)
	end
end

function addon:BANKFRAME_OPENED()
	--print( "Event BANKFRAME_OPENED")
	if not self.bankFrame then
		self:InitBank()
	end

	BankFrame:UnregisterAllEvents()
	BankFrame:UnregisterEvent( "BAG_UPDATE_COOLDOWN")
	BankFrame:Show()

	self:CreateLayout( true)
	
	UpdateAllSlots( self.bankFrame)
	self.bankFrame:Show()
	addon_Open()
	
	if yo.Bags.autoReagent then
		PlaySound(841) 
		DepositReagentBank()
	end
end

function addon:MERCHANT_CLOSED() addon_Close() end

function addon:SCRAPPING_MACHINE_SHOW() addon_Open() end
function addon:SCRAPPING_MACHINE_CLOSE() addon_Close() end
function addon:AUCTION_HOUSE_SHOW() addon_Open() end
function addon:AUCTION_HOUSE_CLOSED() addon_Close() end
function addon:GUILDBANKFRAME_OPENED() addon_Open() end
function addon:GUILDBANKFRAME_CLOSED() addon_Close() end
function addon:TRADE_SHOW() addon_Open() end
function addon:TRADE_CLOSED() addon_Close() end
function addon:TRADE_SKILL_SHOW() addon_Open() end
function addon:TRADE_SKILL_CLOSE() addon_Close() end


function addon:BANKFRAME_CLOSED()
	HideUIPanel(self);

	--print( "Event BANKFRAME_CLOSED")
	if _G["StuffingFrameReagent"] and _G["StuffingFrameReagent"]:IsShown() then
		--print( _G["StuffingFrameReagent"]:IsShown())
		--_G["StuffingFrameReagent"]:Hide()
	end
	BankFrame:Hide()

	if self.bankFrame then
		self.bankFrame:Hide()
		addon_Close()
	end
end

HiddenFrame = CreateFrame('Frame')
HiddenFrame:Hide()

function addon:PLAYERBANKBAGSLOTS_CHANGED( ...)
	--print( "PLAYERBANKBAGSLOTS_CHANGED", ...)
	self:CreateLayout( true)
end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent( HiddenFrame)
	else
		object.Show = object.Hide
	end

	object:Hide()
end

function addon:ADDON_LOADED( addon)
	-- if not yo["Bags"].enable then 
		-- self:UnregisterAllEvents()
		-- return 
	-- end
	-- print( "WTF&!", yo["Bags"].enable)

end

hooksecurefunc( 'SetItemButtonCount', function( slot)
	--print( "HOOKSEC", slot, slot:GetName())
	if slot:GetName() then
		local slotCount = _G[slot:GetName().."Count"]
		if slotCount then
			slotCount:SetTextColor( 1, 215/255, 0)				--- COUNT COLOR
		end
	end
end)

local needCloseBags = false
local function checkToClose(...)
	if addon.bagFrame:IsShown() then
		needCloseBags = true
	else
		needCloseBags = false
	end
end

local function tryToClose(...)
	if needCloseBags then
		addon_Close()
		--PlaySound ( 863, "Master")   -- 863	IG_BACKPACK_CLOSE
		HideUIPanel(GameMenuFrame);	
		needCloseBags = false
	end		
end


function addon:PLAYER_ENTERING_WORLD()
	addon:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	--print( "WTF BAG!", yo["Bags"].enable)
	if not yo.Bags.enable then return end
	
	self:InitBags()

	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")

	-- Events for trade skill UI handling
	--self:RegisterEvent("OBLITERUM_FORGE_SHOW");
	self:RegisterEvent("SCRAPPING_MACHINE_SHOW");
	self:RegisterEvent("SCRAPPING_MACHINE_CLOSE");
	self:RegisterEvent('AUCTION_HOUSE_SHOW')
	self:RegisterEvent('AUCTION_HOUSE_CLOSED')
	self:RegisterEvent('GUILDBANKFRAME_OPENED')
	self:RegisterEvent('GUILDBANKFRAME_CLOSED')

	self:RegisterEvent('TRADE_SHOW')
	self:RegisterEvent('TRADE_CLOSED')

	--self:RegisterEvent('TRADE_SKILL_SHOW')
	--self:RegisterEvent('TRADE_SKILL_CLOSE')

	self:RegisterEvent('MERCHANT_CLOSED')

	---- self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	-- self:RegisterEvent("BAG_CLOSED")
	---- self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	--self:RegisterEvent("REAGENTBANK_UPDATE")
	
	BankFrame:UnregisterAllEvents()
	Kill( BankFrame)
	
	for i=1, NUM_CONTAINER_FRAMES do
		Kill( _G['ContainerFrame'..i])
	end
	
	BankFrame:SetScale(0.00001)
	BankFrame:SetSize(1, 1)
	BankFrame:SetAlpha(0)
	BankFrame:SetPoint("TOPLEFT")
	
	BankFrame.GetRight = function()
		return 100
	end

	SetInsertItemsLeftToRight( false)
	
	ToggleBackpack = addon_Toggle
	ToggleBag = addon_Toggle
	ToggleAllBags = addon_Toggle
	OpenAllBags = addon_Open
	OpenBackpack = addon_Open
	CloseAllBags = addon_Close
	CloseBackpack = addon_Close
	
	hooksecurefunc( "CloseAllWindows", checkToClose)
	hooksecurefunc( "ToggleGameMenu", tryToClose)
end  