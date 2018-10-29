local addonName, ns = ...
local L = ns.L

--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------
CreateFrame("GameTooltip", "LPDURA")
LPDURA:SetOwner(WorldFrame, "ANCHOR_NONE")

local localSlots = {
	[1] = {1, HEADSLOT, 1000},
	[2] = {3, SHOULDERSLOT, 1000},
	[3] = {5, CHESTSLOT, 1000},
	[4] = {6, WAISTSLOT, 1000},
	[5] = {9, WRISTSLOT, 1000},
	[6] = {10, HANDSSLOT, 1000},
	[7] = {7, LEGSSLOT, 1000},
	[8] = {8, FEETSLOT, 1000},
	[9] = {16, MAINHANDSLOT, 1000},
	[10] = {17, SECONDARYHANDSLOT, 1000},
	[11] = {18, RANGEDSLOT, 1000}
}
	
local function OnEvent(self, event)
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnUpdate", nil)
		Text = nil
		LeftInfoPanel.durText = nil
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	if not LeftInfoPanel.durText then
		Text  = LeftInfoPanel:CreateFontString(nil, "OVERLAY")
		Text:SetFont( font, fontsize, "OVERLAY")
		Text:SetHeight(LeftInfoPanel:GetHeight())
		Text:SetPoint("LEFT", LeftInfoPanel, "LEFT", 120, 0)
		LeftInfoPanel.durText = Text
	end
	
	local Total = 0
	local current, cmax		
		
	for i = 1, 11 do
		if GetInventoryItemLink("player", localSlots[i][1]) ~= nil then
			current, cmax = GetInventoryItemDurability( localSlots[i][1])
			if current then 
				localSlots[i][3] = current/ cmax
				Total = Total + 1
			end
		end
	end
	
	table.sort(localSlots, function(a, b) return a[3] < b[3] end)

	if Total > 0 then
		if localSlots[1][3] <= 0.1 then
			Text:SetText("Armor: ".. "|cffff0000" ..floor(localSlots[1][3]*100).."%" )
		elseif localSlots[1][3] <= 0.3 then
			Text:SetText("Armor: ".. "|cffff1000" ..floor(localSlots[1][3]*100).."%" )
		else
			Text:SetText("Armor: ".. myColorStr ..floor(localSlots[1][3]*100).."%" )
		end
	else
		Text:SetText("Armor: ".. myColorStr..": 100%")
	end
		-- Setup Durability Tooltip
	self:SetAllPoints( Text)
	self:SetScript("OnEnter", function()	
		GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()
		--local costTotal = 0
		for i = 1, 11 do
			--local cost = select(3, LPDURA:SetInventoryItem( "player", i))
			--costTotal = costTotal + cost
			--local slot = GetInventorySlotInfo(i)
			--print(i, localSlots[i][2], slot, cost, costTotal)

			if localSlots[i][3] ~= 1000 then
				--green = localSlots[i][3]*2
				--red = 1 - green
				local cols1, cols2, cols3, cols4 = gradient( localSlots[i][3])
				--GameTooltip:AddDoubleLine(localSlots[i][2], floor(localSlots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
				GameTooltip:AddDoubleLine(localSlots[i][2], floor(localSlots[i][3]*100).."%",1 ,1 , 1, cols2, cols3, cols4)
			end
		end
		--GameTooltip:AddLine(" ")
		--GameTooltip:AddDoubleLine( REPAIR_ITEMS, formatMoney( costTotal), 1, .75, 0)
		GameTooltip:Show()
			
	end)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Total = 0

end

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Stat:RegisterEvent("MERCHANT_SHOW")
Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
Stat:SetScript("OnEvent", OnEvent)
