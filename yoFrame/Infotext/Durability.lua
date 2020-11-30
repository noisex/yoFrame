local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------
local 	GetInventorySlotInfo, GetInventoryItemID, GetItemInfo, UnitLevel, GetDodgeChance, abs, GetBonusBarOffset, GetInventoryItemLink, GetInventoryItemDurability, floor, strjoin, format, select, CanGuildBankRepair =
	    GetInventorySlotInfo, GetInventoryItemID, GetItemInfo, UnitLevel, GetDodgeChance, abs, GetBonusBarOffset, GetInventoryItemLink, GetInventoryItemDurability, floor, strjoin, format, select, CanGuildBankRepair

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

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

function Stat:isWearingShield()
	local slotID = GetInventorySlotInfo('SecondaryHandSlot')
	local itemID = GetInventoryItemID('player', slotID)

	if itemID then
		local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemID)
		return itemEquipLoc == 'INVTYPE_SHIELD'
	end
end

function Stat:avoidCheck()
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

	if not Stat:isWearingShield() then
		block = 0
		numAvoidances = numAvoidances - 1
	end

	unhittableMax = unhittableMax + ((AVD_DECAY_RATE * leveldifference) * numAvoidances)

	local avoided = (dodge+parry+basemisschance) --First roll on hit table determining if the hit missed
	local blocked = (100 - avoided)*block/100 --If the hit landed then the second roll determines if the his was blocked
	avoidance = (avoided+blocked)
	unhittable = avoidance - unhittableMax
end

function Stat:onEvent( event)

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
			self.Text:SetText("Armor: ".. "|cffff0000" ..floor(localSlots[1][3]*100).."%" )
		elseif localSlots[1][3] <= 0.3 then
			self.Text:SetText("Armor: ".. "|cffff1000" ..floor(localSlots[1][3]*100).."%" )
		else
			self.Text:SetText("Armor: ".. myColorStr ..floor(localSlots[1][3]*100).."%" )
		end
	else
		self.Text:SetText("Armor: ".. myColorStr..": 100%")
	end

	self:avoidCheck()
	Total = 0
end

function Stat:onEnter( )
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
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
		local cost = select(3, n.scanTooltip:SetInventoryItem( "player", localSlots[i][1]))
		costTotal = costTotal + cost
		--print(i, localSlots[i][2], cost, costTotal)

		if localSlots[i][3] ~= 1000 then
			local cols1, cols2, cols3, cols4 = gradient( localSlots[i][3])
			GameTooltip:AddDoubleLine(localSlots[i][2], floor(localSlots[i][3]*100).."%",1 ,1 , 1, cols2, cols3, cols4)
		end
	end

	if costTotal > 0 then
		GameTooltip:AddLine(" ")
		local repText = REPAIR_ITEMS
		if CanGuildBankRepair() and yo.Addons.RepairGuild then repText = "Ремонт за счет гильдии" end

		GameTooltip:AddDoubleLine( repText, formatMoney( costTotal), 1, .75, 0)

	end
	GameTooltip:Show()
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)

	--self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--Stat:RegisterEvent("MERCHANT_SHOW")
	--Stat:RegisterEvent('UNIT_AURA')
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent('UNIT_TARGET')
	self:RegisterEvent('UNIT_STATS')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	self:RegisterEvent('PLAYER_TALENT_UPDATE')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')

	self:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", self.onEnter)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:onEvent()
	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	self:UnregisterAllEvents()
	self:Hide()
end

infoText.infos.dura 	= Stat
infoText.infos.dura.name= "Durability"

infoText.texts.dura = "Durability"

--Stat.index = 2
--Stat:Enable()