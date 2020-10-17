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
	for _, slot in pairs(N.slots) do
		local button = _G[frame..slot]
		button.textLVL = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.textLVL:SetPoint("TOP", button, "TOP", 0, -2)
		button.textLVL:SetText("")

		button.textEnch = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.textEnch:SetText("")

		if slotsRight[slot] then 				--- слоты справа
			button.textEnch:SetJustifyH( "RIGHT")
			button.textEnch:SetPoint( "LEFT", button, "LEFT", -120, 0)
			button.textEnch:SetPoint( "RIGHT", button, "LEFT", -7, 0)
		else
			button.textEnch:SetJustifyH( "LEFT")
			button.textEnch:SetPoint( "LEFT", button, "RIGHT", 7, 0)
			button.textEnch:SetPoint( "RIGHT", button, "RIGHT", 120, 0)
		end
	end
end

local function UpdateButtonsText(frame)
	local unit = "player"

	if frame == "Inspect" and InspectFrame:IsShown() == false then return end
	if frame == "Inspect" then unit = InspectFrame.unit end

	for _, slot in pairs(N.slots) do
		local id = GetInventorySlotInfo(slot)
		--print(id, slot, slotsRight[slot])

		local tt = CreateFrame("GameTooltip", "yoFrame_ItemScanningTooltip", UIParent, "GameTooltipTemplate") --N.ScanTooltip --
		tt:SetOwner( UIParent, "ANCHOR_NONE")
		tt:SetInventoryItem( unit, id)
		tt:Show()

		local text = _G[frame..slot].textEnch
		text:SetText( "")

		for x = 9, tt:NumLines() do
			local line = _G['yoFrame_ItemScanningTooltipTextLeft'..x]

			if line then
				local lineText = line:GetText()
				if x == 1 and lineText == RETRIEVING_ITEM_INFO then
					break -- 'tooSoon'
				else
					local enchant = strmatch(lineText, MATCH_ENCHANT)
					if enchant then
						text:SetText( enchant)
						text:SetTextColor( line:GetTextColor())
						break
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
