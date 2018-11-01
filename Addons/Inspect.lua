local L, yo = unpack( select( 2, ...))
--wearBySlot = {}

local slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}

local classDefaultArmorType = {
	["WARRIOR"] 	= 4,
	["PALADIN"] 	= 4,
	["HUNTER"] 		= 3,
	["ROGUE"] 		= 2,
	["PRIEST"] 		= 1,
	["DEATHKNIGHT"] = 4,
	["SHAMAN"] 		= 3,
	["MAGE"] 		= 1,
	["WARLOCK"] 	= 1,
	["MONK"] 		= 2,
	["DRUID"] 		= 2,
	["DEMONHUNTER"] = 2,
};

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

local slotEquipType = {
	["INVTYPE_HEAD"]	=	{1},
	["INVTYPE_NECK"]	=	{2},
	["INVTYPE_SHOULDER"]=	{3},
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
	--["INVTYPE_HOLDABLE"]=	{17},
	["INVTYPE_RANGED"]	=	{16},
	--["INVTYPE_THROWN"]	=	{18},
	--["INVTYPE_RANGEDRIGHT"]={16},
}

local tooltip = CreateFrame("GameTooltip", "QulightUI_ItemScanningTooltip", UIParent, "GameTooltipTemplate")
tooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function CreateButtonsText(frame)
	for _, slot in pairs(slots) do
		local button = _G[frame..slot]
		button.t = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.t:SetPoint("TOP", button, "TOP", 0, -2)
		button.t:SetText("")
	end
end

local function UpdateButtonsText(frame)
	if frame == "Inspect" and not InspectFrame:IsShown() then return end

	for _, slot in pairs(slots) do
		local id = GetInventorySlotInfo(slot)
		local text = _G[frame..slot].t
		local itemLink

		if frame == "Inspect" then
			itemLink = GetInventoryItemLink("target", id)
		else
			itemLink = GetInventoryItemLink("player", id)
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")
		
		elseif itemLink then
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

			local item = Item:CreateFromItemLink( itemLink)	
			local ilvl = item:GetCurrentItemLevel()
		
			if ilvl then
				text:SetText("|cFFFFFF00"..ilvl)
			else
				text:SetText("")	
			end
		else
			text:SetText("")
		end
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
			if classDefaultArmorType[myClass] == subTypeLoc then
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

	local slotIndexes = slotEquipType[itemEquipLoc]
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
