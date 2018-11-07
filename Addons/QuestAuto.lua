
local L, yo = unpack( select( 2, ...))

QuestTypesIndex = {
	[0] = "",           --default
	[1] =  " |cff00ff00"..PARTY.."|r",		--Group
	[41] = " |cffff0000PvP|r",			--PvP
	[62] = " |cff00ff00"..LFG_TYPE_RAID.."|r",			--Raid
	[81] = " |cff0080ff" ..LFG_TYPE_DUNGEON.. "|r",
	[83] = " |cffff7000"..LOOT_JOURNAL_LEGENDARIES.."|r", 		--Legendary
	[85] = " |cff8000ff"..ITEM_HEROIC.."|r",		--Heroic 
	[98] = " |cffff8000"..TRACKER_HEADER_SCENARIO.."|r", 	--Scenario QUEST_TYPE_SCENARIO
	[102]= " |cff0080ffAccount|r", 		-- Account
}

local WeaponTypes = {
	["INVTYPE_WEAPON"]			=	true,
	["INVTYPE_SHIELD"]			=	true,
	["INVTYPE_2HWEAPON"]		=	true,
	["INVTYPE_WEAPONMAINHAND"]	=	true,
	["INVTYPE_WEAPONOFFHAND"]	=	true,
	["INVTYPE_HOLDABLE"]		=	true,
	["INVTYPE_RANGED"]			= 	true,
	["INVTYPE_THROWN"]			= 	true,
	["INVTYPE_RANGEDRIGHT"]		= 	true,
}

local ignorTypes = {
	["INVTYPE_TRINKET"]			= 	true,

	["INVTYPE_SHIELD"]			=	true,
	["INVTYPE_2HWEAPON"]		=	true,
	["INVTYPE_WEAPONMAINHAND"]	=	true,
	["INVTYPE_WEAPONOFFHAND"]	=	true,
	["INVTYPE_HOLDABLE"]		=	true,
	["INVTYPE_RANGED"]			= 	true,
	["INVTYPE_THROWN"]			= 	true,
	["INVTYPE_RANGEDRIGHT"]		= 	true,
	["INVTYPE_WEAPON"]			=	true,
}

local autoGossipNPC = {
	[138476]	= true,

	[144476]	= true,
	[144350]	= true,
	[144351]	= true,
	[144354]	= true,
	
	[144478]	= true,
	[144353]	= true,
	[144354]	= true,
	[144355]	= true,
	[144356]	= true,
	[144357]	= true,
	[144358]	= true,

	[144360]	= true,
	[144361]	= true,
	[144362]	= true,
}

local autoGossipInstance = {
	["party"]	= true,
	["raid"]	= true,
	["scenario"]= true,
}

local TimerMovie

local function GetNPCID()
	return tonumber(string.match(UnitGUID("npc") or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

local function GetActiveOptions(...)
	local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
	if ( autoGossipInstance[instance] or autoGossipNPC[GetNPCID()]) and GetNumGossipOptions() == 1 then
		SelectGossipOption(1, "", true)
	end	
end

local function GetAvailableQuests( ... )
	--print(...)
	for i=1, select("#", ...), 7 do

		local titleText, level, isTrivial, isDaily, isRepeatable, isLegendary, isIgnored = select(i, ...);
		if isTrivial ~= true then
			SelectGossipAvailableQuest( math.floor( i/7) + 1)
		else
			print("|cffff0000SKIP_IT: |r" .. titleText)
		end
	end
end

local function GetActiveQuests( ... )
	for i=1, select("#", ...), 6 do
		local isComplete = select( i+3, ...) 
		if ( isComplete ) then
			SelectGossipActiveQuest( math.floor( i/6) + 1)
		end
	end
end

local function CheckSlot( itemType )
	local retlvl
	for i = 1, 18 do
		local itemLink = GetInventoryItemLink("player", i)
		if itemLink then
			
			local _, _, _, _, _, _, _, _, slotName = GetItemInfo(itemLink)
			if WeaponTypes[slotName] == true then
				slotName = "INVTYPE_MYWEAPON"
			end

			if (slotName == itemType) then
				local itemLocation = ItemLocation:CreateFromEquipmentSlot( i);
				local item = Item:CreateFromItemLocation( itemLocation)
     			local ilvl = item:GetCurrentItemLevel()

				retlvl = math.min( ilvl, ( retlvl or 9999))
			end
		end
	end
	return retlvl
end

local function OnEvent( self, event, ...)
	
	--print(event, ...)
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		
		if not yo.Addons.AutoQuest then return end
		
		self:RegisterEvent("QUEST_GREETING")
		self:RegisterEvent("GOSSIP_SHOW")	
		self:RegisterEvent("QUEST_DETAIL")	
		self:RegisterEvent("QUEST_PROGRESS")
		self:RegisterEvent("QUEST_COMPLETE")
		self:RegisterEvent("QUEST_ACCEPTED")
		self:RegisterEvent("CINEMATIC_START")
	end

	if event == "QUEST_PROGRESS" then
		if IsShiftKeyDown() == true then return end
		if not yo.Addons.AutoQuestComplete then return end
		
		local isDaily = QuestIsDaily();
		local isWeekly = QuestIsWeekly();
		--print( isWeekly, isDaily)

		if ( isDaily or isWeekly) then --or (UnitLevel('player') == MAX_PLAYER_LEVEL) then 
			local money = GetQuestMoneyToGet()
			local name, texture, amount = GetQuestCurrencyInfo("required", 1)
			local iname, itexture, numItems, iquality, isUsable = GetQuestItemInfo("required", 1)

			if name then
				local r, g, b, hexColor = GetItemQualityColor( select( 8, GetCurrencyInfo( name)))
				print("|cffff0000"..L["Spend"].." |cff00ff00" .. amount .. " |r" .. '|T'.. texture ..':14|t |c' .. hexColor .. name .. "|cffffff00 "..L["myself"].."|r" .. L["DONT_SHIFT"])
				CloseQuest()
			elseif money > 1 then
				print("|cffff0000"..L["Pay"]..": |cff00ff00" .. formatMoney( money) .. "|cffffff00"..L["this huckster"].."|r" .. L["DONT_SHIFT"])
				CloseQuest()
			elseif iname then
				print("|cffff0000"..L["Give it to him"].." |cff00ff00" .. numItems .. " |r" .. '|T'.. itexture ..':14|t |c' .. select( 4, GetItemQualityColor( iquality)).. iname .. L["DONT_SHIFT"])
				CloseQuest()
			else
				CompleteQuest()
			end
		else
			CompleteQuest()
		end

	elseif event == "CINEMATIC_START" then
		if not yo.Addons.AutoQuestSkipScene then return end

		if TimerMovie == nil then
			TimerMovie = self:CreateAnimationGroup()
			TimerMovie.anim = TimerMovie:CreateAnimation()
			TimerMovie.anim:SetDuration(0.5)
			TimerMovie:SetLooping("REPEAT")
			TimerMovie:SetScript("OnLoop", function(self, event, ...)
				print( L["SCIP_VIDEO"])
				CinematicFrame_CancelCinematic()
				TimerMovie:Stop()
			end)
		end
		TimerMovie:Play()

	elseif event == "QUEST_COMPLETE" then
		if IsShiftKeyDown() == true then return end
		if not yo.Addons.AutoQuestComplete then return end

		if GetNumQuestChoices() > 1 then
			if not yo.Addons.AutoQuestComplete2Choice then return end

			local slvl, delta
			local bestString, bestChoice, bestDelta = "", 1, -9999
			
			for i=1, GetNumQuestChoices() do
				local _, _, itemRarity, _, _, _, _, _, itemEquipLoc = GetItemInfo(GetQuestItemLink("choice", i))
				local _, _, _, hexColor = GetItemQualityColor(itemRarity)

				local itemLink = GetQuestItemLink("choice", i)
				local clvl = GetDetailedItemLevelInfo( itemLink)
				local azeritItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink)

				if ignorTypes[itemEquipLoc] == true or azeritItem then
					print( L["MAKE_CHOICE"])
					return
				end

				if WeaponTypes[itemEquipLoc] == true then
					slvl = CheckSlot( "INVTYPE_MYWEAPON")
				else
					slvl = CheckSlot( itemEquipLoc)
				end

	   			if slvl then
	   				delta = clvl - slvl
	   				if delta > bestDelta then
	   					bestDelta = delta
	   					bestChoice = i
	   					bestString = "|cffff0000"..L["Your choice"]..": |r ".. _G[itemEquipLoc] .. " |c" .. hexColor.. "[".. clvl .. "]|r " .. itemLink .. " ( " .. clvl - slvl .. " "..L["from"].." [" .. slvl.. "])|r"
	   				end
	   			end
			end
				print( bestString)
				GetQuestReward( bestChoice)
		else
			GetQuestReward( 1)
		end

	elseif event == "QUEST_DETAIL" then
		if IsShiftKeyDown() == true then return end
		if not yo.Addons.AutoQuest then return end

		if QuestGetAutoAccept() then
			CloseQuest()
		else
			--print("Q_Detail: ", isDaily, isWeekly, curNum)
			QuestInfoDescriptionText:SetAlphaGradient(0, -1)
			QuestInfoDescriptionText:SetAlpha(1)
			AcceptQuest()		
		end	

	elseif event == "GOSSIP_SHOW" then
		if IsShiftKeyDown() == true then return end
		if not yo.Addons.AutoQuest then return end

		GetAvailableQuests( GetGossipAvailableQuests())
		GetActiveQuests( GetGossipActiveQuests())
		GetActiveOptions( GetGossipOptions())

	elseif	event == "QUEST_GREETING" then
		if IsShiftKeyDown() == true then return end
		if not yo.Addons.AutoQuest then return end

		local numActiveQuests = GetNumActiveQuests();
		local numAvailableQuests = GetNumAvailableQuests();

		for index=1, numActiveQuests do
			local quest, isComplete = GetActiveTitle(index)
			if isComplete then
				SelectActiveQuest(index)
			end
		end

   		for index=1, numAvailableQuests do -- index=(numActiveQuests + 1), (numActiveQuests + numAvailableQuests) do
           	local isTrivial, isDaily, isRepeatable, isLegendary  = GetAvailableQuestInfo(index)
			--if (isIgnored) then return end 
			
           	if isTrivial ~= true then --and not ( isDaily == LE_QUEST_FREQUENCY_DAILY or isDaily == LE_QUEST_FREQUENCY_WEEKLY ) then
            	SelectAvailableQuest(index)
            else
				print("|cffff0000SKIP_IT: |r", isTrivial ) --.. titleText)
            end
   		end
   		
	elseif event == "QUEST_ACCEPTED" then
		
		local index, questID = select( 1, ...)
		if QuestUtils_IsQuestWorldQuest(questID) then return end
		
		SelectQuestLogEntry(index)

		local questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle( index);
		
		if questTitle == nil then return end

		local questDescription, questObjectives = GetQuestLogQuestText( index)
		local questTypeIndex = GetQuestLogQuestType( index)
		local tagString = QuestTypesIndex[questTypeIndex] or ""

		if ( isDaily == LE_QUEST_FREQUENCY_DAILY or isDaily == LE_QUEST_FREQUENCY_WEEKLY ) then
			cHeader = "|cff0070de"
		else
			cHeader = hex( GetQuestDifficultyColor( UnitLevel("player"))) 
		end

		local qString = ""

	
		if #questObjectives > 1 then
			print( "|cffffff00"..QUESTS_COLON.." |r|cff00ffff" .. questObjectives)
		end

		if GetNumQuestLogChoices() > 0 then
			for i = 1, GetNumQuestLogChoices() do
				local bestString = ""
				local slvl
				local itemLink = GetQuestLogItemLink("choice", i)
				local itemName, itemLink1, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo( itemLink)
				local redComponent, greenComponent, blueComponent, hexColor = GetItemQualityColor(itemRarity)

				local ilvl = GetDetailedItemLevelInfo(itemLink)

				if WeaponTypes[itemEquipLoc] == true then
					slvl = CheckSlot( "INVTYPE_WEAPON")
				else
					slvl = CheckSlot( itemEquipLoc)
				end

	   			if slvl and slvl < ilvl then
	   				bestString = " |cffff0000"..L["Better than"].." [" .. slvl .. "] " .. L["on"] .. ilvl - slvl .. "|r"
	   			end

				print( "|cffffff00"..L["Choice"].." #" .. i ..": |r" .. " [|c" ..hexColor .. ilvl .. "|r] " .. ( _G[itemEquipLoc] or "") .. " " .. itemLink .. bestString)	
			end	
		end	

		if GetNumQuestLogRewards() > 0 then
			for i = 1, GetNumQuestLogRewards() do
				if GetQuestLogItemLink("reward", i) then
					print( "|cffffff00"..REWARD.." #" .. i ..": |r" .. GetQuestLogItemLink("reward", i).. "|r")	
				end
			end
		end

		if GetNumRewardCurrencies() then
			for i = 1, GetNumRewardCurrencies() do
				local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i)

				if currencyID then
					local link = GetCurrencyLink( currencyID, numItems or 10)
					print( "|cffffff00"..CURRENCY..": |r" .. numItems .. " x " .. ( link or name).. "|r")
				end
			end		
		end

		if GetQuestLogRewardXP() > 0 then
			qString =  qString ..  "|cffffff00"..EXPERIENCE_COLON.." |r|cff0080ff" .. commav( GetQuestLogRewardXP()) .. "|r "
		end

		local skillName, icon, points = GetQuestLogRewardSkillPoints()
		if skillName then
			qString =  qString .. "|cffffff00"..CHARACTER_POINTS2_COLON.." |r+" .. points .. " " .. skillName.. "|r "
		end


		if GetQuestLogRewardMoney() > 0 then
			 qString =  qString .. "|cffffff00"..MONEY_COLON.." |r" .. formatMoney( GetQuestLogRewardMoney()).. "|r "
		end

		print( qString)
		print( " ")
	else
		--print("|cffff0000Unknown event: " .. event)
	end
end

local quest = CreateFrame("Frame")
quest:RegisterEvent("PLAYER_ENTERING_WORLD")
quest:SetScript("OnEvent", OnEvent)
