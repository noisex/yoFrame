local L, yo, n = unpack( select( 2, ...))
--wearBySlot = {}

local _G = _G

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch, GetTime
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch, GetTime

local UIParent, GetItemInfo, GetInventoryItemLink, GetDetailedItemLevelInfo, CreateFrame, GetInventorySlotInfo, GetAverageItemLevel, GetInventoryItemsForSlot, strmatch, GetInspectSpecialization
	= UIParent, GetItemInfo, GetInventoryItemLink, GetDetailedItemLevelInfo, CreateFrame, GetInventorySlotInfo, GetAverageItemLevel, GetInventoryItemsForSlot, strmatch, GetInspectSpecialization

local ItemLocation, Item, EquipmentManager_UnpackLocation
	= ItemLocation, Item, EquipmentManager_UnpackLocation

local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO

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

local enchSlots = {
	["ChestSlot"] 	= true,
	--["WristSlot"] = true,  -- инта
	--["HandsSlot"]	= true,  -- сила
	["Finger0Slot"] = true,
	["Finger1Slot"] = true,
	["BackSlot"] 	= true,
	--["FeetSlot"]	= true,  -- ловкость
	["MainHandSlot"]= true,
}

local MATCH_ENCHANT = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.+)')
--Trinket1Slot бесцветное гнездо

local function CreateButtonsText(frame)
	for index, slot in pairs(n.slots) do
		local button = _G[frame..slot]

		button.slotName  = slot
		button.slotID 	 = GetInventorySlotInfo( slot)

		button.textLVL = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.textLVL:SetPoint("TOP", button, "TOP", 0, -2)
		button.textLVL:SetText("")

		button.textEnch = button:CreateFontString(nil, "OVERLAY") --, "SystemFont_Outline_Small")
		button.textEnch:SetFont( n.font, n.fontsize -1, n.fontstyle)
		button.textEnch:SetText("")

		button.IconBorder:SetTexture( yo.Media.borders)
		button.IconBorder.SetTexture = n.dummy

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

local function updateButtonSlotText( frameslot, unit)

	local button = _G[frameslot]
	local text 	 = button.textEnch
	if not text then return end

	button.IconBorder:SetTexture( yo.Media.borders)

	local slot 	 = button.slotName
	local id 	 = button.slotID
	local unit 	 = unit or "player"
	local specID = unit == "player" and n.mySpecNum or GetInspectSpecialization( unit)
	local enchFound

	local tt = CreateFrame("GameTooltip", "yoFrame_ItemScanningTooltip", UIParent, "GameTooltipTemplate") --n.scanTooltip --
	tt:SetOwner( UIParent, "ANCHOR_NONE")
	tt:SetInventoryItem( unit, id)
	tt:Show()

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
					enchFound = true
					text:SetText( enchant)
					text:SetTextColor( line:GetTextColor())
					break
				end
			end
		end
	end

	if specID and not enchFound and ( enchSlots[slot] or ( n.classSpecsCoords[specID] and n.classSpecsCoords[specID].enchSlot == slot)) then
		text:SetText( "No enchant")
		text:SetTextColor( 1, 0, 0)
	end

	local text = button.textLVL
	local level

	if unit ~= "player" then
		local itemLink = GetInventoryItemLink( unit, id)
		if itemLink then
			level = GetDetailedItemLevelInfo( itemLink)
		end
	else
		local item = Item:CreateFromEquipmentSlot( id)
		level = item:GetCurrentItemLevel()
	end

	if slot == "ShirtSlot" or slot == "TabardSlot" then
		text:SetText("")

	elseif level then
		text:SetText("|cFFFFFF00"..level)
	else
		text:SetText("")
	end
	tt:Hide()
	tt:ClearLines()
end

local function UpdateButtonsText(frame)
	local unit = "player"

	if frame == "Inspect" and _G.InspectFrame:IsShown() == false then return end
	if frame == "Inspect" then unit = _G.InspectFrame.unit end

	for _, slot in pairs(n.slots) do
		updateButtonSlotText( frame..slot, unit)
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
		self.UpgradeIcon.ClearAllPoints 	= n.dummy
		self.UpgradeIcon.SetPoint 			= n.dummy
		self.UpgradeIcon:SetTexture( yo.Media.path .. "icons\\bagUpgradeIcon");
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
			if n.classEquipMap[n.myClass] == subTypeLoc then
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

	local slotIndexes = n.slotEquipType[itemEquipLoc]
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
OnEvent:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:RegisterEvent("ITEM_CHANGED")

OnEvent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		CreateButtonsText("Character")
		_G.CharacterFrame:HookScript("OnShow", function(self) UpdateButtonsText("Character") end)

	elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		UpdateButtonsText("Character")

	elseif event == "ITEM_CHANGED" then
		--print("ITEM_CHANGED")
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
		_G.InspectFrame:HookScript("OnShow", function(self) UpdateButtonsText("Inspect") end)
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
	if total > 0 then total = format("%.1f", total) end
	if equip > 0 then equip = format("%.1f", equip) end

	local ilvl = equip
	if equip ~= total then
		ilvl = equip.." / "..total
	end

	CharacterStatsPane.ItemLevelFrame.Value:SetText(ilvl)
end)

--hooksecurefunc("BindEnchant", 	 function(self, ...)
--	--print("BIND IT")
--	C_Timer.After(2, function ()
--		UpdateButtonsText("Character")
--	end)
--end)

--hooksecurefunc("ReplaceEnchant", function(self, ...)
--	C_Timer.After( 2, function ()
--		UpdateButtonsText("Character")
--	end)
--end)

hooksecurefunc( "PaperDollItemSlotButton_Update", function(self, ...)
	--print( "PAPERDOLL ", self, self:GetName(), ...)
	updateButtonSlotText( self:GetName())
end)