local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local resetIntervals = { daily = 1, weekly = 2, unknown = 3 }
local bossDefeated = "|TInterface\\WorldMap\\Skull_64Red:14|t"
local bossStatus = "|TInterface\\WorldMap\\Skull_64Red:14|t"
local bossAvailable = "|TInterface\\WorldMap\\Skull_64Grey:14|t"
local Profit	= 0
local Spent		= 0
local OldMoney	= 0

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

local function newConfigData( personalConfig)

	n.allData.myData.Money 		= GetMoney()
	n.allData.myData.MoneyDay 	= date()
	n.allData.myData.MoneyTime	= time()
	n.allData.myData.Class 		= n.myClass
	n.allData.myData.Race		= select(2, UnitRace('player'))
	n.allData.myData.Sex		= UnitSex('player')
	n.allData.myData.Color 		= { ["r"] = n.myColor.r, ["g"] = n.myColor.g, ["b"] = n.myColor.b, ["colorStr"] = n.myColor.colorStr}
	n.allData.myData.ColorStr 	= n.myColorStr
	n.allData.myData.WorldBoss =  nil 							--FlagActiveBosses() ~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!
end

function Stat:onEvent( event, ...)

	if event == "TIME_PLAYED_MSG" then
		local playedtotal, playedlevel = ...
		n.allData.myData.Played 	= playedtotal
		n.allData.myData.PlayedLvl  = playedlevel

	elseif event == "PLAYER_ENTERING_WORLD" then
		OldMoney = GetMoney()						-- так надо, ибо не считает раньше деньгу
		self:RegisterEvent("PLAYER_MONEY")
		self:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
		self:RegisterEvent("SEND_MAIL_COD_CHANGED")
		self:RegisterEvent("PLAYER_TRADE_MONEY")
		self:RegisterEvent("TRADE_MONEY_CHANGED")
		self:RegisterEvent("TIME_PLAYED_MSG")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	local NewMoney	= GetMoney()
	local Change = NewMoney-OldMoney -- Positive if we gain money

	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	self.Text:SetText( formatMoney(NewMoney, nil, true))

	newConfigData()
	OldMoney = NewMoney
end

function Stat:onEnter()
	local totalMoney = 0

	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);

	if Change ~= 0 then
		GameTooltip:AddLine(L["ForTheGame"])
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

	GameTooltip:AddLine(L["GeneralInfo"])

	local oneDate
	for k, realm in pairs ( n.allData.charData) do
		if type( realm) == "table" and k ~= "editHistory" then

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
				maxW = " (" .. curInfo.quantityEarnedThisWeek .. "/" .. curInfo.maxWeeklyQuantity .. L.perWeekCur
			end

			if curTable.name and curTable.quantity then
				GameTooltip:AddDoubleLine( " |T" .. curTable.iconFileID .. ":16:16:0:0:64:64:4:60:4:60:255:255:255|t " .. curTable.name, commav( curTable.quantity) .. maxQ .. maxW, r, g, b, 1, 1, 1)
			end
		end
	end
	GameTooltip:Show()
end

function Stat:onClick( )
	isOpen = not isOpen
	if IsShiftKeyDown() then
		--local myPersonalConfig
		--if n.allData[n.myRealm][n.myName] and n.allData[n.myRealm][n.myName].PersonalConfig then
		--	myPersonalConfig = true
		--end
		n.allData.charData = nil
		newConfigData( myPersonalConfig)
		print("|cffff0000All data reset.|r")
	else
		if isOpen then
			OpenAllBags()
		else
			CloseAllBags()
		end
	end
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", self.onEnter)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onClick)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( n.font, n.fontsize, "OVERLAY")
	self:SetWidth( self.Text:GetWidth())

	local ofunc = ChatFrame_DisplayTimePlayed
	function ChatFrame_DisplayTimePlayed() ChatFrame_DisplayTimePlayed = ofunc end
	RequestTimePlayed()
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)
	--CreateStyle( self, 2)
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

infoText.infos.gold 	= Stat
infoText.infos.gold.name= "Money"

infoText.texts.gold 	= "Money"