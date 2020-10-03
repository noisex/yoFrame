local L, yo, N = unpack( select( 2, ...))
--wearBySlot = {}

local slotsRight = {
	["MainHandSlot"] = 1,
	["HandsSlot"] = 1,
	["WaistSlot"] = 1,
	["LegsSlot"] = 1,
	["FeetSlot"] = 1,
	["Finger0Slot"] = 1,
	["Finger1Slot"] = 1,
	["Trinket0Slot"] = 1,
	["Trinket1Slot"] = 1,
}

local slotArmorTypeCheck = {
	["INVTYPE_HEAD"]	= true,
	["INVTYPE_SHOULDER"]= true,
	["INVTYPE_CHEST"]	= true,
	["INVTYPE_WAIST"]	= true,
	["INVTYPE_LEGS"]	= true,
	["INVTYPE_FEET"]	= true,
	["INVTYPE_WRIST"]	= true,
	["INVTYPE_HAND"]	= true,
}

local MATCH_ENCHANT = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)')
--Trinket1Slot бесцветное гнездо

local function CreateButtonsText(frame)
	local p1, p2, x, y
	for _, slot in pairs(N.slots) do
		local button = _G[frame..slot]
		button.textLVL = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.textLVL:SetPoint("TOP", button, "TOP", 0, -2)
		button.textLVL:SetText("")

		if slotsRight[slot] then p1, p2, p3, x, y = "LEFT", "RIGHT","LEFT", -10, 0
		else  p1, p2, p3, x, y = "RIGHT", "LEFT", "RIGHT", 10, 0 end

		button.textEnch = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.textEnch:SetJustifyH( p2)

		button.textEnch:SetPoint( p1, button, p3, x-120, y)
		button.textEnch:SetPoint( p2, button, p3, x, y)
		button.textEnch:SetText("")
	end
end

local function UpdateButtonsText(frame)
	local unit = "player"

	if frame == "Inspect" and InspectFrame:IsShown() == false then return end
	if frame == "Inspect" then unit = InspectFrame.unit end

	for _, slot in pairs(N.slots) do
		local id = GetInventorySlotInfo(slot)
		--print(id, slot, slotsRight[slot])

		local tt = N.ScanTooltip --CreateFrame("GameTooltip", "yoFrame_ItemScanningTooltip", UIParent, "GameTooltipTemplate")
		tt:SetOwner( UIParent, "ANCHOR_NONE")
		tt:SetInventoryItem( unit, id)
		tt:Show()

		local text = _G[frame..slot].textEnch
		text:SetText( "")

		for x = 1, tt:NumLines() do
			local line = _G['yoFrame_ItemScanningTooltipTextLeft'..x]

			if line then
				local lineText = line:GetText()
				if x == 1 and lineText == RETRIEVING_ITEM_INFO then
					return 'tooSoon'
				else
					local enchant = strmatch(lineText, MATCH_ENCHANT)
					if enchant then
						local lr, lg, lb = line:GetTextColor()
						text:SetText( enchant, 1, 200)
						text:SetTextColor(lr, lg, lb)
					end
				end
			end
		end

		local text = _G[frame..slot].textLVL
		local level

		if frame == "Inspect" then
			local itemLink = GetInventoryItemLink( unit, id)
			if itemLink then
				level = GetDetailedItemLevelInfo( itemLink)
				--print(itemLink, level)
				--level = _getRealItemLevel( id, "target", itemLink, true)
			end
		else
			local item = Item:CreateFromEquipmentSlot( id)
			level = item:GetCurrentItemLevel()
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")

		elseif level then
			--local itemLocation = ItemLocation:CreateFromEquipmentSlot( id)
			--local item = Item:CreateFromItemLocation( itemLocation)
			--local itemLocation = ItemLocation:CreateFromEquipmentSlot(self:GetID());
			--if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) then
				--print( "AZERIT", itemLink)
			--end
			--if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation) then
				--tprint( item)
			--end
			--wearBySlot[id] = ilvl

			text:SetText("|cFFFFFF00"..level)
		else
			text:SetText("")
		end
		tt:Hide()
		tt:ClearLines()
	end
end

local function CreateFlyoutText( self)
	if self and not self.text then
		self.text = self:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		self.text:SetPoint("TOP", self, "TOP", 0, -2)
		self.text:SetText("")
	end

	if self.UpgradeIcon and not self.UpgradeMoved then
		self.UpgradeIcon:ClearAllPoints()
		self.UpgradeIcon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -7)
		self.UpgradeIcon.ClearAllPoints 	= dummy
		self.UpgradeIcon.SetPoint 			= dummy
		self.UpgradeIcon:SetTexture("Interface\\AddOns\\yoFrame\\media\\bagUpgradeIcon");
		self.UpgradeIcon:SetTexCoord(0,1,0,1);
		self.UpgradeMoved = true
	end
end

local function CheckSlotLocationUpgrade( self, slotID, itemLocation, bags)
	if self.count and self.count == 0 then return end

	local upgrade = false

	local itemSlotLocation = ItemLocation:CreateFromEquipmentSlot( slotID);
	local itemSlot = Item:CreateFromItemLocation( itemSlotLocation)
	local levelSlot = itemSlot:GetCurrentItemLevel()

	local itemLoc = Item:CreateFromItemLocation( itemLocation)
	local levelLoc = itemLoc:GetCurrentItemLevel()

	if bags and ( not levelSlot or levelSlot < levelLoc) then

		local linkLoc = itemLoc:GetItemLink()
		local subTypeLoc = select( 13, GetItemInfo( linkLoc))	-- 6
		local locTypeLoc = select( 9, GetItemInfo( linkLoc))

		if slotArmorTypeCheck[locTypeLoc] then
			if N.classEquipMap[myClass] == subTypeLoc then
				upgrade = true
			end
		else
			upgrade = true
		end
	end

	return upgrade
end

function MultiCheckLockation( self, itemLocation, itemEquipLoc, BagID, SlotID)
	local needUp = false

	local slotIndexes = N.slotEquipType[itemEquipLoc]
	if slotIndexes then
		--print(itemLocation, locTypeLoc)

		for i, slotID in ipairs( slotIndexes) do

			if slotID == 16 or slotID == 17 then
				local availableItems = {}

				GetInventoryItemsForSlot( slotID, availableItems);

				for packedLocation, itemID in pairs(availableItems) do
					local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(packedLocation);
					--print( bags, slot, bag)

					if BagID == bag and SlotID == slot then
						--print(itemEquipLoc, slotID, SlotID, BagID)
						needUp = CheckSlotLocationUpgrade( self, slotID, itemLocation, true)
					else

					end
				end
			else
				needUp = needUp or	CheckSlotLocationUpgrade( self, slotID, itemLocation, true)
			end
		end
	end
	self.UpgradeIcon:SetShown( needUp)
end

local function UpdateFlyoutText(self)
	CreateFlyoutText( self)

	if self then
		local location = self.location
		local slotID = self.id
		if location then
			--local itemID, name, textureName, count, durability, maxDurability, invType, locked, start, duration, enable, setTooltip, quality, isUpgrade = EquipmentManager_GetItemInfoByLocation(location);
			--print(itemID, name, textureName, count, durability, maxDurability, invType, locked, start, duration, enable, setTooltip, quality, isUpgrade)
			local player, bank, bags, loc, slot, bag = EquipmentManager_UnpackLocation(location)
			local itemLocation = bags and ItemLocation:CreateFromBagAndSlot(bag, slot) or ItemLocation:CreateFromEquipmentSlot( slot)
			local item = Item:CreateFromItemLocation( itemLocation)

			self.UpgradeIcon:SetShown( CheckSlotLocationUpgrade( self, slotID, itemLocation, bags))

			if item then
				local level = item:GetCurrentItemLevel() or ""
				if level then
					self.text:SetText( "|cFFFFFF00" .. level)
				end
			end
		end
	end
end

hooksecurefunc("EquipmentFlyout_DisplayButton", UpdateFlyoutText) --EquipmentFlyout_DisplayButton(button, paperDollItemSlot)

local OnEvent = CreateFrame("Frame")
OnEvent:RegisterEvent("PLAYER_LOGIN")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		CreateButtonsText("Character")
		UpdateButtonsText("Character")
		self:UnregisterEvent("PLAYER_LOGIN")
		CharacterFrame:HookScript("OnShow", function(self) UpdateButtonsText("Character") end)
		--tick = 1
		--EquipmentFlyoutFrame:HookScript("OnUpdate", UpdateFlyoutText)

	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		UpdateButtonsText("Character")
	else
		UpdateButtonsText("Inspect")
	end
end)

local OnLoad = CreateFrame("Frame")
OnLoad:RegisterEvent("ADDON_LOADED")
OnLoad:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		CreateButtonsText("Inspect")
		InspectFrame:HookScript("OnShow", function(self) UpdateButtonsText("Inspect") end)
		OnEvent:RegisterEvent("UNIT_INVENTORY_CHANGED")
		OnEvent:RegisterEvent("PLAYER_TARGET_CHANGED")
		OnEvent:RegisterEvent("INSPECT_READY")
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

--- Character Info Sheet ItemLvL / Average
hooksecurefunc("PaperDollFrame_SetItemLevel", function(self, unit)
	if unit ~= "player" then return end

	local total, equip = GetAverageItemLevel()
	if total > 0 then total = string.format("%.1f", total) end
	if equip > 0 then equip = string.format("%.1f", equip) end

	local ilvl = equip
	if equip ~= total then
		ilvl = equip.." / "..total
	end

	CharacterStatsPane.ItemLevelFrame.Value:SetText(ilvl)
end)


--function EquipmentFlyout_Show(itemButton)
--	print("...")
--	itemDisplayTable = {}
--	itemTable = {}

--	local id = itemButton.id or itemButton:GetID();

--	local flyout = EquipmentFlyoutFrame;
--	if flyout:IsShown() and (flyout.button ~= itemButton) then
--		flyout:Hide();
--	end

--	local buttons = flyout.buttons;

--	if ( flyout.button ~= itemButton ) then
--		flyout.currentPage = nil;
--	end

--	if ( flyout.button and flyout.button ~= itemButton ) then
--		local popoutButton = flyout.button.popoutButton;
--		if ( popoutButton and popoutButton.flyoutLocked ) then
--			popoutButton.flyoutLocked = false;
--			EquipmentFlyoutPopoutButton_SetReversed(popoutButton, false);
--		end
--	end
--	flyout.button = itemButton;

--	wipe(itemDisplayTable);
--	wipe(itemTable);

--	local flyoutSettings = itemButton:GetParent().flyoutSettings;

--	print( itemButton, itemButton:GetName())

--	local useItemLocation = flyoutSettings.useItemLocation;

--	flyout:SetScript("OnUpdate", flyoutSettings.customFlyoutOnUpdate or EquipmentFlyout_OnUpdate);

--	flyout.Highlight:SetShown(not flyoutSettings.hideFlyoutHighlight);

--	EquipmentFlyout_SetBackgroundTexture(flyoutSettings.customBackground or [[Interface\PaperDollInfoFrame\UI-GearManager-Flyout]]);

--	flyoutSettings.getItemsFunc(id, itemTable);
--	for location, itemID in next, itemTable do
--		if ( not useItemLocation and ((location - id) == ITEM_INVENTORY_LOCATION_PLAYER) ) then -- Remove the currently equipped item from the list
--			itemTable[location] = nil;
--		else
--			tinsert(itemDisplayTable, location);
--			print("fsfdsfsdfsd", id, itemTable,itemID, location)
--		end
--	end

--	if useItemLocation then
--		local locationToItemID = {};
--		local function ItemLocationSort(lhsLocation, rhsLocation)
--			locationToItemID[lhsLocation] = locationToItemID[lhsLocation] or C_Item.GetItemID(lhsLocation);
--			locationToItemID[rhsLocation] = locationToItemID[rhsLocation] or C_Item.GetItemID(rhsLocation);

--			local lhsItemID = locationToItemID[lhsLocation];
--			local rhsItemID = locationToItemID[rhsLocation];
--			return lhsItemID < rhsItemID;
--		end

--		table.sort(itemDisplayTable, ItemLocationSort);
--	else
--		table.sort(itemDisplayTable); -- Sort by location. This ends up as: inventory, backpack, bags, bank, and bank bags.
--	end

--	local numTotalItems = #itemDisplayTable;

--	if ( flyoutSettings.postGetItemsFunc ) then
--		numTotalItems = flyoutSettings.postGetItemsFunc(itemButton, itemDisplayTable, numTotalItems);
--	end

--	local numPageItems = min(numTotalItems, EQUIPMENTFLYOUT_ITEMS_PER_PAGE);
--	while #buttons < numPageItems do -- Create any buttons we need.
--		EquipmentFlyout_CreateButton();
--	end

--	if ( numPageItems == 0 ) then
--		flyout:Hide();
--		return;
--	end

--	flyout.totalItems = numTotalItems;
--	EquipmentFlyout_UpdateItems();
--	flyout:Show();
--end
---- Walk all the character item slots and create a list of items in the player's inventory
---- that can be equipped into those slots and is a higher ilvl
---- @return a table of all slots that have higher ilvl items in the player's pags. Each table is a list of STRUCT_ItemContainer

--function Class_EquipFirstItemWatcher:GetPotentialItemUpgrades()
--	local potentialUpgrades = {};

--	local playerClass = TutorialHelper:GetClass();

--	for i = 0, INVSLOT_LAST_EQUIPPED do
--		local existingItemIlvl = 0;
--		local existingItemWeaponType;

--		local existingItemLink = GetInventoryItemLink("player", i);
--		if (existingItemLink ~= nil) then
--			existingItemIlvl = GetDetailedItemLevelInfo(existingItemLink) or 0;

--			if (i == INVSLOT_MAINHAND) then
--				local existingItemID = GetInventoryItemID("player", i);
--				existingItemWeaponType = self:GetWeaponType(existingItemID);
--			end
--		end

--		local availableItems = {};
--		GetInventoryItemsForSlot(i, availableItems);

--		for packedLocation, itemLink in pairs(availableItems) do
--			local itemInfo = {GetItemInfo(itemLink)};
--			local ilvl = GetDetailedItemLevelInfo(itemLink) or 0;

--			if (ilvl ~= nil) then
--				if (ilvl > existingItemIlvl) then

--					-- why can't I just have a continue statement?
--					local match = true;

--					-- if it's a main-hand, make sure it matches the current type, if there is one
--					if (i == INVSLOT_MAINHAND) then
--						local weaponType = self:GetWeaponType(itemID);
--						match = (not existingItemWeaponType) or (existingItemWeaponType == weaponType);

--						-- rouge's should only be recommended daggers
--						if ( playerClass == "ROGUE" and not IsDagger(itemInfo)) then
--							match = false;
--						end
--					end

--					-- if it's an off-hand, make sure the player doesn't have a 2h or rnaged weapon
--					if (i == INVSLOT_OFFHAND) then
--						local mainHandID = GetInventoryItemID("player", INVSLOT_MAINHAND);
--						if (mainHandID) then
--							local mainHandType = self:GetWeaponType(mainHandID);
--							if ((mainHandType == self.WeaponType.TwoHand) or (mainHandType == self.WeaponType.Ranged)) then
--								match = false;
--							end
--						end

--						-- rouge's should only be recommended daggers
--						if ( playerClass == "ROGUE" and not IsDagger(itemInfo)) then
--							match = false;
--						end
--					end

--					if (match) then
--						local player, bank, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(packedLocation);

--						if ((player == true) and (bags == true)) then
--							if (potentialUpgrades[i] == nil) then
--								potentialUpgrades[i] = {};
--							end

--							table.insert(potentialUpgrades[i], self:STRUCT_ItemContainer(itemLink, i, bag, slot));
--						end
--					end
--				end
--			end
--		end
--	end

--	return potentialUpgrades;
--end

--function Class_EquipFirstItemWatcher:OnComplete()
--end

--