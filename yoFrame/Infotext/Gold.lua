
local L, yo = unpack( select( 2, ...))

local resetIntervals = { daily = 1, weekly = 2, unknown = 3 }
local bossDefeated = "|TInterface\\WorldMap\\Skull_64Red:14|t"
local bossStatus = "|TInterface\\WorldMap\\Skull_64Red:14|t"
local bossAvailable = "|TInterface\\WorldMap\\Skull_64Grey:14|t"

local function GetBoss(encounterID, questID, resetInterval, faction)
	local boss = {}

	if not resetInterval then resetInterval = resetIntervals.weekly end

	boss.name = EJ_GetEncounterInfo(encounterID)
	boss.questId = questID
	boss.resetInterval = resetInterval
	boss.faction = faction
	boss.displayName = boss.name
	--print( boss.name, faction, resetInterval, questID)
	return boss
end

local category = {}
	category.name = 'Zandalar/Kul Tiras'
	category.maxKills = 2
	category.bosses = bosses
	category.bonusRollCurrencies = {1580}
	category.maps = {
		942, -- STORMSONG_VALLEY,
		896, -- DRUSTVAR
		895, -- TIRAGARDE_SOUND
		864, -- VOLDUN
		863, -- NAZMIR
		862, -- ZULDAZAR
		14   -- ARATHI_HIGHLANDS
	}
	category.bosses = {
		GetBoss(2210, 52196), -- Dunegorger Kraulok
		GetBoss(2141, 52169), -- Ji'arak
		GetBoss(2139, 52181), -- T'zane
		GetBoss(2198, 52166), -- Warbringer Yenajz
		GetBoss(2199, 52163), -- Azurethos, The Winged Typhoon
		GetBoss(2197, 52157), -- Hailstone Construct
		GetBoss(2213, 52847, resetIntervals.unknown, 'Alliance'), -- Doom's Howl (Alliance)
		GetBoss(2212, 52848, resetIntervals.unknown, 'Horde')  -- The Lion's Roar (Horde)
	}

--	BOSS_DATA[#BOSS_DATA +1] = category
local function FlagActiveBosses()
	--local bossData = BOSS_DATA
	local worldQuests = {}
	local ret = ""

	--for _, category in pairs(bossData) do
		local zones = category.maps or {}

		for zoneIndex = 1, #zones do
			local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(zones[zoneIndex])
			if taskInfo and #taskInfo then
			   for taskIndex = 1, #taskInfo do
			   		--tprint( taskInfo)
			   		--print(taskInfo[taskIndex].mapID, taskInfo[taskIndex].questId)

					worldQuests[taskInfo[taskIndex].questId] = time()
			   end
			end
		end

		for _, boss in pairs(category.bosses) do
			if boss.questId then
				if worldQuests[boss.questId] or IsQuestFlaggedCompleted(boss.questId) then
					boss.active = true
					if IsQuestFlaggedCompleted(boss.questId) then
						ret = ret .. bossAvailable
					else
						ret = ret .. bossDefeated
					end
					--print(boss.questId, IsQuestFlaggedCompleted(boss.questId))
				end
			end
		end
	--end
	return ret
end

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Profit	= 0
local Spent		= 0
local OldMoney	= 0

local function newConfigData( personalConfig)

	if yo_AllData == nil then
		yo_AllData = {}
	end

	if yo_AllData[myRealm] == nil then
		yo_AllData[myRealm] = {}
	end

	if yo_AllData[myRealm][myName] == nil then
		yo_AllData[myRealm][myName] = {}
	end

	yo_AllData[myRealm][myName]["Money"] 	= GetMoney()
	yo_AllData[myRealm][myName]["MoneyDay"] = date()
	yo_AllData[myRealm][myName]["MoneyTime"]= time()
	yo_AllData[myRealm][myName]["Class"] 	= myClass
	yo_AllData[myRealm][myName]["Race"]		= select(2, UnitRace('player'))
	yo_AllData[myRealm][myName]["Sex"]		= UnitSex('player')
	yo_AllData[myRealm][myName]["Color"] = { ["r"] = myColor.r, ["g"] = myColor.g, ["b"] = myColor.b, ["colorStr"] = myColor.colorStr}
	yo_AllData[myRealm][myName]["ColorStr"] = myColorStr
	yo_AllData[myRealm][myName]["PersonalConfig"] = yo_AllData[myRealm][myName].PersonalConfig or personalConfig
	yo_AllData[myRealm][myName]["WorldBoss"] =  nil 							--FlagActiveBosses() ~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!
end

local function OnEvent(self, event, ...)
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self:SetScript("OnEvent", nil)
		self:SetScript("OnUpdate", nil)
		Text = nil
		self = nil
		RightInfoPanel.goldText = nil
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
		Text:SetHeight(RightInfoPanel:GetHeight())
		Text:SetPoint("LEFT", RightInfoPanel, "LEFT", 10, 0)
		RightInfoPanel.goldText = Text
		OldMoney = GetMoney()

		local ofunc = ChatFrame_DisplayTimePlayed
		function ChatFrame_DisplayTimePlayed() ChatFrame_DisplayTimePlayed = ofunc end
		RequestTimePlayed()

	elseif event == "TIME_PLAYED_MSG" then
		local playedtotal, playedlevel = ...
		yo_AllData[myRealm][myName]["Played"] = playedtotal
		yo_AllData[myRealm][myName]["PlayedLvl"] = playedlevel
	end

	local NewMoney	= GetMoney()
	local Change = NewMoney-OldMoney -- Positive if we gain money

	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	Text:SetText( formatMoney(NewMoney))

	newConfigData()

	self:SetAllPoints( Text)
	self:SetScript("OnEnter", function()
		local totalMoney = 0

		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()

		if Change ~= 0 then
			GameTooltip:AddLine(L["For the game"])
			if Profit > 0 then
				GameTooltip:AddDoubleLine(L["Received"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
			end

			if Spent > 0 then
				GameTooltip:AddDoubleLine(L["Spent"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)
			end

			if Profit < Spent then
				GameTooltip:AddDoubleLine(L["Loss"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine(L["Profit"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end
			GameTooltip:AddLine' '
		end

		GameTooltip:AddLine(L["General information"])

		local oneDate
		for k, realm in pairs ( yo_AllData) do
			if type( realm) == "table" then

      			local tkeys = {}
      			for k, v in pairs( realm) do
         			table.insert(tkeys, { money = v.Money, name = k})
      			end

      			local function tableSortCat (a,b) return a.money < b.money end
       			table.sort( tkeys, tableSortCat)

				oneDate = false
				for _, v in pairs(tkeys) do
					value = realm[v.name]

					if value.KeyStone and timeLastWeeklyReset() < value.KeyStoneTime then
						v.name = v.name .. value.KeyStone
					end
					if tonumber( value.Money) and tonumber( value.Money) > 100000 then
						if not oneDate then
							GameTooltip:AddDoubleLine( "  ", k, 0.5, .5, .5, 0, 1, 1)  --- Realmane
							oneDate = true
						end
						totalMoney = totalMoney + tonumber( value.Money)
						local cols = value.Color and value.Color or { 1, 0.75, 0}
							GameTooltip:AddDoubleLine( v.name, formatMoney( value.Money, true), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
					end

				end
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddDoubleLine( L["TOTAL"], formatMoney( totalMoney), 1, 1, 0, 0, 1, 0)

		for i = 1, MAX_WATCHED_TOKENS do
			local curTable = C_CurrencyInfo.GetBackpackCurrencyInfo(i)
			if curTable then

				local curInfo = C_CurrencyInfo.GetCurrencyInfo( curTable.currencyTypesID)
				local maxQ, maxW = "", ""
				--tprint( curInfo) print("....")
				if curTable.name and i == 1 then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(CURRENCY .. ":")
				end
				--print( curTable.name, curTable.quantity, curTable.iconFileID, curTable.currencyTypesID, curInfo )
				local r, g, b = 1, 1, 0
				if curTable.currencyTypesID then r, g, b = GetItemQualityColor( curInfo.quality) end
				if curInfo.maxQuantity > 0 then maxQ = "/" .. commav( curInfo.maxQuantity) .. "" end
				if curInfo.maxWeeklyQuantity > 0 then
					maxW = " (" .. curInfo.quantityEarnedThisWeek .. "/" .. curInfo.maxWeeklyQuantity .. " за неделю)"
				end

				if curTable.name and curTable.quantity then
					GameTooltip:AddDoubleLine( " |T" .. curTable.iconFileID .. ":16:16:0:0:64:64:4:60:4:60:255:255:255|t " .. curTable.name, commav( curTable.quantity) .. maxQ .. maxW, r, g, b, 1, 1, 1)
				end
			end
		end
		GameTooltip:Show()
	end)

	self:SetScript("OnLeave", function() GameTooltip:Hide() end)

	OldMoney = NewMoney
end

Stat:RegisterEvent("PLAYER_MONEY")
Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
Stat:RegisterEvent("PLAYER_TRADE_MONEY")
Stat:RegisterEvent("TRADE_MONEY_CHANGED")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("TIME_PLAYED_MSG")

Stat:SetScript("OnMouseDown", function( self)
	isOpen = not isOpen
	if IsShiftKeyDown() then
		local myPersonalConfig
		if yo_AllData[myRealm][myName] and yo_AllData[myRealm][myName].PersonalConfig then
			myPersonalConfig = true
		end
		yo_AllData = nil
		newConfigData( myPersonalConfig)
		print("|cffff0000All data reset.|r")
	else
		if isOpen then
			OpenAllBags()
		else
			CloseAllBags()
		end
	end
end)

Stat:SetScript("OnEvent", OnEvent)