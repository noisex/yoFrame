--wearBySlot = {}

local slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
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
		local ulvl

		if frame == "Inspect" then
			itemLink = GetInventoryItemLink("target", id)
			ulvl = UnitLevel("target")
		else
			itemLink = GetInventoryItemLink("player", id)
			ulvl = UnitLevel("player")
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")
		
		elseif itemLink then
			local itemLocation = ItemLocation:CreateFromEquipmentSlot( id)
			local item = Item:CreateFromItemLocation( itemLocation)
			local ilvl = item:GetCurrentItemLevel()
		
			--local itemLocation = ItemLocation:CreateFromEquipmentSlot(self:GetID());
			--if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) then
				--print( "AZERIT", itemLink)
			--end
			--if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation) then
				--tprint( item)
			--end
			--wearBySlot[id] = ilvl
			if ilvl then
				text:SetText("|cFFFFFF00"..ilvl)
			end
		else
			--wearBySlot[id] = nil
			text:SetText("")
		end
	end
end

local function CreateFlyoutText( frame)
	for i = 1, 15 do
		local button = _G["EquipmentFlyoutFrameButton" .. i]
		if button and not button.text then
			button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
			button.text:SetPoint("TOP", button, "TOP", 0, -2)
			button.text:SetText("")
		end
	end
end

local function UpdateFlyoutText(f, el)
	tick = tick + el
	if tick < 0.5 then return end
	tick = 0
	
	CreateFlyoutText()
	local numButtons = EquipmentFlyoutFrame.numItemButtons
	local link
	local itemLocation
	local item
	--print( "------------------------")
	for i = 2, numButtons do
		local frame = _G["EquipmentFlyoutFrameButton" .. i]
		if frame then
			local location = frame.location
			if location then
				
				local player, bank, bags, loc, slot, bag = EquipmentManager_UnpackLocation(location)

				if bags then
					item = Item:CreateFromBagAndSlot(bag, slot)
				else
					itemLocation = ItemLocation:CreateFromEquipmentSlot( slot)
					item = Item:CreateFromItemLocation( itemLocation)
				end
					
				if item then
					local level = item:GetCurrentItemLevel()
					if level then
						frame.text:SetText( "|cFFFFFF00" .. level)					
						--print( i, player, bags, loc, bag, slot, link, level)
					end
				end
			end
		end
	end
end

local OnEvent = CreateFrame("Frame")
OnEvent:RegisterEvent("PLAYER_LOGIN")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		CreateButtonsText("Character")
		UpdateButtonsText("Character")
		self:UnregisterEvent("PLAYER_LOGIN")
		CharacterFrame:HookScript("OnShow", function(self) UpdateButtonsText("Character") end)
		
		tick = 1
		--EquipmentFlyoutFrame:HookScript("OnShow", function(self) UpdateFlyoutText() end)
		EquipmentFlyoutFrame:HookScript("OnUpdate", UpdateFlyoutText)


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