
local L, yo, N = unpack( select( 2, ...))

--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------
local AVD_DECAY_RATE, chanceString = 1.5, '%.2f%%'
local displayString, lastPanel, targetlv, playerlv
local basemisschance, leveldifference, dodge, parry, block, unhittable, avoidance

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
	[10] = {17, SECONDARYHANDSLOT, 1000}
	--[11] = {18, RANGEDSLOT, 1000}
}

local function IsWearingShield()
	local slotID = GetInventorySlotInfo('SecondaryHandSlot')
	local itemID = GetInventoryItemID('player', slotID)

	if itemID then
		local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemID)
		return itemEquipLoc == 'INVTYPE_SHIELD'
	end
end

local function AvoidCheck(self)
	targetlv, playerlv = UnitLevel('target'), myLevel

	basemisschance = myRace == 'NightElf' and 7 or 5
	if targetlv == -1 then
		leveldifference = 3
	elseif targetlv > playerlv then
		leveldifference = (targetlv - playerlv)
	elseif targetlv < playerlv and targetlv > 0 then
		leveldifference = (targetlv - playerlv)
	else
		leveldifference = 0
	end

	if leveldifference >= 0 then
		dodge = (GetDodgeChance() - leveldifference * AVD_DECAY_RATE)
		parry = (GetParryChance() - leveldifference * AVD_DECAY_RATE)
		block = (GetBlockChance() - leveldifference * AVD_DECAY_RATE)
		basemisschance = (basemisschance - leveldifference * AVD_DECAY_RATE)
	else
		dodge = (GetDodgeChance() + abs(leveldifference * AVD_DECAY_RATE))
		parry = (GetParryChance() + abs(leveldifference * AVD_DECAY_RATE))
		block = (GetBlockChance() + abs(leveldifference * AVD_DECAY_RATE))
		basemisschance = (basemisschance+ abs(leveldifference * AVD_DECAY_RATE))
	end

	local unhittableMax = 100
	local numAvoidances = 4
	if dodge <= 0 then dodge = 0 end
	if parry <= 0 then parry = 0 end
	if block <= 0 then block = 0 end

	if myClass == 'DRUID' and GetBonusBarOffset() == 3 then
		parry = 0
		numAvoidances = numAvoidances - 1
	end

	if not IsWearingShield() then
		block = 0
		numAvoidances = numAvoidances - 1
	end

	unhittableMax = unhittableMax + ((AVD_DECAY_RATE * leveldifference) * numAvoidances)

	local avoided = (dodge+parry+basemisschance) --First roll on hit table determining if the hit missed
	local blocked = (100 - avoided)*block/100 --If the hit landed then the second roll determines if the his was blocked
	avoidance = (avoided+blocked)
	unhittable = avoidance - unhittableMax
end

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
		Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
		Text:SetHeight(LeftInfoPanel:GetHeight())
		Text:SetPoint("LEFT", LeftInfoPanel, "LEFT", 120, 0)
		LeftInfoPanel.durText = Text
	end

	local Total = 0
	local current, cmax

	for i = 1, 10 do
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
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)

	AvoidCheck( self)
	Total = 0
end

local function OnEnter( self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6);
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
	GameTooltip:ClearLines()

	--Avoidence
	local rightString = targetlv > 1 and strjoin('', ' (', "lvl", ' ', targetlv, ')') or targetlv == -1 and strjoin('', ' (', BOSS, ')') or strjoin('', ' (', "lvl", ' ', playerlv, ')')
	GameTooltip:AddDoubleLine( format( "ЗАЩИТА: " .. chanceString, avoidance), rightString)
	--GameTooltip:AddLine(' ')

	GameTooltip:AddDoubleLine("Уклонение", format(chanceString, dodge), 1, 1, 1)
	GameTooltip:AddDoubleLine("Паррирование", format(chanceString, parry), 1, 1, 1)
	GameTooltip:AddDoubleLine("Блок", format(chanceString, block), 1, 1, 1)
	GameTooltip:AddDoubleLine("Промах", format(chanceString, basemisschance), 1, 1, 1)
	--GameTooltip:AddLine(' ')
	GameTooltip:AddDoubleLine("Защита от удара:", (unhittable > 0 and '+' or '')..format(chanceString, unhittable), 1, 1, 1, (unhittable < 0 and 1 or 0), (unhittable > 0 and 1 or 0), 0)
	GameTooltip:AddLine(' ')
	--

	GameTooltip:AddLine("Прочность")
	local costTotal = 0
	for i = 1, 10 do
		local cost = select(3, N.ScanTooltip:SetInventoryItem( "player", localSlots[i][1]))
		costTotal = costTotal + cost
		--print(i, localSlots[i][2], cost, costTotal)

		if localSlots[i][3] ~= 1000 then
			local cols1, cols2, cols3, cols4 = gradient( localSlots[i][3])
			GameTooltip:AddDoubleLine(localSlots[i][2], floor(localSlots[i][3]*100).."%",1 ,1 , 1, cols2, cols3, cols4)
		end
	end

	if costTotal > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine( REPAIR_ITEMS, formatMoney( costTotal), 1, .75, 0)
	end
	GameTooltip:Show()
end

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Stat:RegisterEvent("MERCHANT_SHOW")

Stat:RegisterEvent('UNIT_TARGET')
Stat:RegisterEvent('UNIT_STATS')
Stat:RegisterEvent('UNIT_AURA')
Stat:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
Stat:RegisterEvent('PLAYER_TALENT_UPDATE')
Stat:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')

Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnEnter", OnEnter)
