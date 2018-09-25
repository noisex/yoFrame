
QuestTypesIndex = {
	[0] = "",           --default
	[1] =  " |cff00ff00Группа|r",		--Group
	[41] = " |cffff0000ПвП|r",			--PvP
	[62] = " |cff00ff00Рэйд|r",			--Raid
	[81] = " |cff0080ffПодземелье|r",	--Dungeon
	[83] = " |cffff7000Легенда|r", 		--Legendary
	[85] = " |cff8000ffГероик|r",		--Heroic 
	[98] = " |cffff8000Сценарий|r", 	--Scenario QUEST_TYPE_SCENARIO
	[102]= " |cff0080ffАкаунт|r", 		-- Account
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

local TimerMovie

local function GetAvailableQuests( ... )
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
		
		if not yo["Addons"].AutoQuest then return end
		
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
		if not yo["Addons"].AutoQuestComplete then return end

		--local isDaily = QuestIsDaily();
		--local isWeekly = QuestIsWeekly();
		--local curNum = GetNumQuestCurrencies()
		local name, texture, amount = GetQuestCurrencyInfo("required", 1)

		if name then
			print("|cffffff00Потрать |cff00ff00" .. amount .. " |r" .. name .. "|cffffff00 сам! :)|r")
		else
			CompleteQuest()
		end

	elseif event == "CINEMATIC_START" then
		if not yo["Addons"].AutoQuestSkipScene then return end

		if TimerMovie == nil then
			TimerMovie = self:CreateAnimationGroup()
			TimerMovie.anim = TimerMovie:CreateAnimation()
			TimerMovie.anim:SetDuration(0.5)
			TimerMovie:SetLooping("REPEAT")
			TimerMovie:SetScript("OnLoop", function(self, event, ...)
				print("|cffffff00Автоквест: |cff00ffffПропустил потрясающее видео, какая жалость...|r")
				CinematicFrame_CancelCinematic()
				TimerMovie:Stop()
			end)
		end
		TimerMovie:Play()

	elseif event == "QUEST_COMPLETE" then
		if IsShiftKeyDown() == true then return end
		if not yo["Addons"].AutoQuestComplete then return end

		if GetNumQuestChoices() > 1 then
			if not yo["Addons"].AutoQuestComplete2Choice then return end

			local slvl, delta
			local bestString, bestChoice, bestDelta = "", 1, -9999
			
			for i=1, GetNumQuestChoices() do
				local _, _, itemRarity, _, _, _, _, _, itemEquipLoc = GetItemInfo(GetQuestItemLink("choice", i))
				local _, _, _, hexColor = GetItemQualityColor(itemRarity)

				local itemLink = GetQuestItemLink("choice", i)
				local clvl = GetDetailedItemLevelInfo( itemLink)
				local azeritItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink)

				if ignorTypes[itemEquipLoc] == true or azeritItem then
					print( "|cffff0000Выбери награду сам уж как-нибудь...|r")
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
	   					bestString = "|cffff0000Наш выбор: |r ".. _G[itemEquipLoc] .. " |c" .. hexColor.. "[".. clvl .. "]|r " .. itemLink .. " ( " .. clvl - slvl .. " от [" .. slvl.. "])|r"
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
		if not yo["Addons"].AutoQuest then return end

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
		if not yo["Addons"].AutoQuest then return end

		GetAvailableQuests( GetGossipAvailableQuests())
		GetActiveQuests( GetGossipActiveQuests())

	elseif	event == "QUEST_GREETING" then
		if IsShiftKeyDown() == true then return end
		if not yo["Addons"].AutoQuest then return end

		for index=1, GetNumActiveQuests() do
			local quest, isComplete = GetActiveTitle(index)
			if isComplete then
				SelectActiveQuest(index)
			end
		end

   		for index=1, GetNumAvailableQuests() do
           	local isTrivial, isDaily, isRepeatable, isIgnored = GetAvailableQuestInfo(index)
			if (isIgnored) then return end 
			
           	if isTrivial ~= true then --and not ( isDaily == LE_QUEST_FREQUENCY_DAILY or isDaily == LE_QUEST_FREQUENCY_WEEKLY ) then
            	SelectAvailableQuest(index)
            else
				print("|cffff0000SKIP_IT: |r" .. titleText)
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

		--print( "|cffffff00Квест: " .. cHeader .. " [" .. level .."] " .. tagString .. " " .. cHeader .. questTitle)
		
		if #questObjectives > 1 then
			print( "|cffffff00Задание: |r|cff00ffff" .. questObjectives)
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
	   				bestString = " |cffff0000Лучше чем [" .. slvl .. "] " .. " на " .. ilvl - slvl .. "|r"
	   			end

				print( "|cffffff00Выбор #" .. i ..": |r" .. " [|c" ..hexColor .. ilvl .. "|r] " .. ( _G[itemEquipLoc] or "") .. " " .. itemLink .. bestString)	
			end	
		end	

		if GetNumQuestLogRewards() > 0 then
			for i = 1, GetNumQuestLogRewards() do
				if GetQuestLogItemLink("reward", i) then
					print( "|cffffff00Награда #" .. i ..": |r" .. GetQuestLogItemLink("reward", i).. "|r")	
				end
			end
		end

		if GetNumRewardCurrencies() then
			for i = 1, GetNumRewardCurrencies() do
				local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i)

				if currencyID then
					local link = GetCurrencyLink( currencyID, numItems or 10)
					print( "|cffffff00Валютка: |r" .. numItems .. " x " .. ( link or name).. "|r")
				end
			end		
		end

		if GetQuestLogRewardXP() > 0 then
			qString =  qString ..  "|cffffff00Опыт: |r|cff0080ff" .. commav( GetQuestLogRewardXP()) .. "|r "
		end

		local skillName, icon, points = GetQuestLogRewardSkillPoints()
		if skillName then
			qString =  qString .. "|cffffff00Очки умений: |r+" .. points .. " " .. skillName.. "|r "
		end


		if GetQuestLogRewardMoney() > 0 then
			 qString =  qString .. "|cffffff00Денюжка: |r" .. formatMoney( GetQuestLogRewardMoney()).. "|r "
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