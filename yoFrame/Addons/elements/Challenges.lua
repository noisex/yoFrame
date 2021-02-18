local L, yo, n = unpack( select( 2, ...))

local _G = _G
local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub

local GetContainerNumSlots, GetContainerItemInfo, date, time, strlower, print, strsub, CreateFrame, timeFormat, SendChatMessage, SecondsToClock, SecondsToTime, dprint
	= GetContainerNumSlots, GetContainerItemInfo, date, time, strlower, print, strsub, CreateFrame, timeFormat, SendChatMessage, SecondsToClock, SecondsToTime, dprint

local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local LANDING_PAGE_REPORT = LANDING_PAGE_REPORT
local CHALLENGE_MODE_POWER_LEVEL = CHALLENGE_MODE_POWER_LEVEL
local CHALLENGE_MODE_DEATH_COUNT_TITLE = CHALLENGE_MODE_DEATH_COUNT_TITLE
local CHALLENGE_MODE_DEATH_COUNT_DESCRIPTION = CHALLENGE_MODE_DEATH_COUNT_DESCRIPTION

local requestKeystoneCheck, registered

local challengeMapID
local TIME_FOR_3 = 0.6
local TIME_FOR_2 = 0.8
local oldParent, oldPosition

local yo_OldKey, yo_OldKey2 = nil, nil

local function CheckInventoryKeystone()
	local keyslink = nil

	n.allData.myData.KeyStone 		= nil
	n.allData.myData.KeyStoneDay 	= nil
	n.allData.myData.KeyStoneTime 	= nil

	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do  -- 198 16 8 4 10  -- keystone:challengeMapID:mythicLevel:isActive:affix1:affix2:affix3
			local _, _, _, _, _, _, slotLink = GetContainerItemInfo(container, slot)
			local itemString = slotLink and slotLink:match("|Hkeystone:([0-9:]+)|h(%b[])|h")

			if itemString then
				keyslink  = slotLink
				n.allData.myData.KeyStone 	  = slotLink
				n.allData.myData.KeyStoneDay  = date()
				n.allData.myData.KeyStoneTime = time()
			end
		end
	end
	requestKeystoneCheck = false

	return keyslink
end

local function OnEvent( self, event, name, sender, ...)

	if event == "BAG_UPDATE" then
		requestKeystoneCheck = true

	elseif event == "PLAYER_ENTERING_WORLD" then
		--self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not registered then
			self:RegisterEvent("BAG_UPDATE")
			self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
			self:RegisterEvent("CHAT_MSG_PARTY")
			self:RegisterEvent("CHAT_MSG_GUILD")
			self:RegisterEvent("CHAT_MSG_LOOT")
			self:RegisterEvent("CHAT_MSG_WHISPER")
			registered = true
		end

		challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
		yo_OldKey = CheckInventoryKeystone()

		ObjectiveTrackerFrame:Show()

	elseif event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_PARTY" then
		name = strlower( name)
		if name == "!key" or name == "!ключ" or name == "!keys" then
			local keys = CheckInventoryKeystone()
			if keys then
				SendChatMessage( keys, "PARTY")
			end
		end
	elseif event == "CHAT_MSG_GUILD" then
		name = strlower( name)
		if name == "!key" or name == "!ключ" or name == "!keys" then
			local keys = CheckInventoryKeystone()
			if keys then
				SendChatMessage( keys, "GUILD")
			end
		end
	elseif event == "CHAT_MSG_WHISPER" then
		name = strlower( name)
		if name == "!key" or name == "!ключ" or name == "!keys" then
			local keys = CheckInventoryKeystone()
			if keys then
				SendChatMessage( keys, "WHISPER", "Common", sender)
			end
		end

	elseif event == "CHAT_MSG_LOOT" then

		local b --= name:match("Эпохальный ключ")
		local c = name:match( "|Hkeystone:")
		local y = name:match( L.keyYOU)
		local z = name:match( L.keyYOUR)

	--	--print( name, b, c, y, z, a)
		if ( z or y) and ( b or c ) then
			local keys = CheckInventoryKeystone()
			--print( "KEY Find: ", name, b, c, y, z)
			if keys then
				--print( "WIN: ", b or c)
			--SendChatMessage( a, "PARTY")
			end
		end

	elseif event == "CHALLENGE_MODE_START"  or event == "CHALLENGE_MODE_RESET" then
		challengeMapID = C_ChallengeMode.GetActiveChallengeMapID()
		yo_OldKey = CheckInventoryKeystone()

	elseif event == "CHALLENGE_MODE_COMPLETED" then

		if not challengeMapID then return end

		local mapID, level, time, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
		local name, _, timeLimit 	= C_ChallengeMode.GetMapUIInfo(challengeMapID)
		local count, timeLost 		= C_ChallengeMode.GetDeathCount();

		time = time / 1000
		--timeLimit = timeLimit * 1000
		local timeLimit2 = timeLimit * TIME_FOR_2
		local timeLimit3 = timeLimit * TIME_FOR_3

		--print("|cff00ffff--------------------------------------------------------------------------")
		print( "|cff00ffff" .. LANDING_PAGE_REPORT)
		print("|cff00ffff--------------------------------------------------------------------------")
		if time <= timeLimit3 then
			_G.DEFAULT_CHAT_FRAME:AddMessage( format( L["completion3"], level, name, timeFormat(time), SecondsToTime(timeLimit3 - time)), 255/255, 215/255, 1/255)
		elseif time <= timeLimit2 then
			_G.DEFAULT_CHAT_FRAME:AddMessage( format( L["completion2"], level, name, timeFormat(time), SecondsToTime(timeLimit2 - time), SecondsToTime(time - timeLimit3)), 199/255, 199/255, 199/255)
		elseif onTime then
			_G.DEFAULT_CHAT_FRAME:AddMessage( format( L["completion1"], level, name, timeFormat(time), SecondsToTime(timeLimit - time), SecondsToTime(time - timeLimit2)), 237/255, 165/255, 95/255)
		else
			_G.DEFAULT_CHAT_FRAME:AddMessage( format( L["completion0"], name, level, timeFormat(time), SecondsToTime(time - timeLimit)), 255/255, 32/255, 32/255)
		end

		if (timeLost and timeLost > 0 and count and count > 0) then
			_G.DEFAULT_CHAT_FRAME:AddMessage( CHALLENGE_MODE_DEATH_COUNT_TITLE:format( count), 0.9, 0.8, 0.1);
			_G.DEFAULT_CHAT_FRAME:AddMessage( CHALLENGE_MODE_DEATH_COUNT_DESCRIPTION:format( SecondsToTime( timeLost)), 09, 0.8, 0.1);
		end
		print("|cff00ffff--------------------------------------------------------------------------")

		yo_OldKey2 = CheckInventoryKeystone()

		C_Timer.After( 2, function()
			local newKey = CheckInventoryKeystone()
			--print("Debug: OLd: ", yo_OldKey, ". OLd2: ", yo_OldKey2, ". New: " , newKey)
			if newKey and newKey ~= yo_OldKey then
				--print(yo_OldKey, newKey)
				SendChatMessage( "My new key is: " .. newKey, "PARTY")
			end
		end)

		if oldPosition and oldParent then
			--ScenarioBlocksFrame:SetParent( oldParent)
			--ScenarioBlocksFrame:ClearAllPoints()
			--ScenarioBlocksFrame:SetPoint( unpack( oldPosition))

			--ObjectiveTrackerFrame:Show()
		end
	end
end


local logan = CreateFrame("Frame", "yo_WeeklyAffixes", UIParent)
	logan:RegisterEvent("PLAYER_ENTERING_WORLD")

	logan:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    logan:RegisterEvent("CHALLENGE_MODE_RESET");
    logan:RegisterEvent("CHALLENGE_MODE_START")
	logan:SetScript("OnEvent", OnEvent)


----------------------------------------------------------------------------------
---			ObjectiveTracker ( Angry KeyStone)
----------------------------------------------------------------------------------

local function GetTimerFrame(block)
--	local instanceType, difficultyID = select( 2, GetInstanceInfo())

--print( ScenarioBlocksFrame:GetParent())

--	if not moved and IsInInstance() and difficultyID == 8 and yo.Addons.hideObjective then
--		moved 		= true
--		oldParent 	= ScenarioBlocksFrame:GetParent()
--		oldPosition = ScenarioBlocksFrame:GetPoint( 1)

--		print( GetTime(), "SHOW", oldParent)

--		---ScenarioBlocksFrame:SetParent(UIParent)
--		--ScenarioBlocksFrame:ClearAllPoints()
--		--ScenarioBlocksFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -20)

--		ObjectiveTrackerFrame:Hide()
--	end

	if not block.TimerFrame then

		block.TimeLeft:SetFont(n.font, n.fontsize + 4)

		local TimerFrame = CreateFrame("Frame", nil, block)
		TimerFrame:SetAllPoints(block)

		TimerFrame.Text2 = TimerFrame:CreateFontString(nil, "OVERLAY")--, "GameFontHighlightLarge")
		TimerFrame.Text2:SetFont( n.font, n.fontsize +2)
		TimerFrame.Text2:SetPoint("LEFT", block.TimeLeft, "LEFT", 55, 0)

		TimerFrame.Text = TimerFrame:CreateFontString(nil, "OVERLAY")--, "GameFontHighlightLarge")
		TimerFrame.Text:SetFont( n.font, n.fontsize +2)
		TimerFrame.Text:SetPoint("LEFT", TimerFrame.Text2, "LEFT", 55, 0)

		TimerFrame.Bar3 = TimerFrame:CreateTexture(nil, "OVERLAY")
		TimerFrame.Bar3:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - TIME_FOR_3) - 4, 4)
		TimerFrame.Bar3:SetSize(2, 14)
		TimerFrame.Bar3:SetTexture( n.texture)
		TimerFrame.Bar3:SetVertexColor( 0, 1, 0, 1)

		TimerFrame.Bar2 = TimerFrame:CreateTexture(nil, "OVERLAY")
		TimerFrame.Bar2:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - TIME_FOR_2) - 4, 4)
		TimerFrame.Bar2:SetSize(2, 14)
		TimerFrame.Bar2:SetTexture( n.texture)
		TimerFrame.Bar2:SetVertexColor(0, 1, 0, 1)

		TimerFrame:Show()

		block.TimerFrame = TimerFrame
	end
	return block.TimerFrame
end

local function UpdateTime(block, elapsedTime)
	local TimerFrame = GetTimerFrame(block)

	local time3 = block.timeLimit * TIME_FOR_3
	local time2 = block.timeLimit * TIME_FOR_2

	TimerFrame.Bar3:SetShown(elapsedTime < time3)
	TimerFrame.Bar2:SetShown(elapsedTime < time2)

	if elapsedTime < time3 then
		TimerFrame.Text:SetText( timeFormat(time3 - elapsedTime) )
		TimerFrame.Text:SetTextColor(1, 0.843, 0)
		TimerFrame.Text:Show()
		if true then --Addon.Config.silverGoldTimer then
			TimerFrame.Text2:SetText( timeFormat(time2 - elapsedTime) )
			TimerFrame.Text2:SetTextColor(0.78, 0.78, 0.812)
			TimerFrame.Text2:Show()
		else
			TimerFrame.Text2:Hide()
		end
	elseif elapsedTime < time2 then
		TimerFrame.Text:SetText( timeFormat(time2 - elapsedTime) )
		TimerFrame.Text:SetTextColor(0.78, 0.78, 0.812)
		TimerFrame.Text:Show()
		TimerFrame.Text2:Hide()
	else
		TimerFrame.Text:Hide()
		TimerFrame.Text2:Hide()
	end

	if elapsedTime < block.timeLimit then
		block.TimeLeft:SetText( timeFormat( block.timeLimit - elapsedTime, false, true))
	else
		block.TimeLeft:SetText( "-" .. timeFormat( elapsedTime - block.timeLimit, false, true))
	end
end

local function ShowBlock(timerID, elapsedTime, timeLimit)
	local block = ScenarioChallengeModeBlock
	local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
	local dmgPct, healthPct = C_ChallengeMode.GetPowerLevelDamageHealthMod(level)
	if false then --Addon.Config.showLevelModifier then
		block.Level:SetText( format("%s, +%d%%", CHALLENGE_MODE_POWER_LEVEL:format(level), dmgPct) )
	else
		block.Level:SetText(CHALLENGE_MODE_POWER_LEVEL:format(level))
	end
end

local function ProgressBar_SetValue(self, percent)
	if self.criteriaIndex then
		local _, _, _, _, totalQuantity, _, _, quantityString, _, _, _, _, _ = C_Scenario.GetCriteriaInfo(self.criteriaIndex)
		local currentQuantity = quantityString and tonumber( strsub(quantityString, 1, -2) )

		if currentQuantity and totalQuantity then
			self.Bar.Label:SetFormattedText("|cff00ff00%.2f%% |r( |cffddaa11%.2f%%|r)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100)
		end
	end

	if not self.Bar.shadow then
		self.Bar:SetStatusBarTexture( n.texture)
		self.Bar.BarFrame:Hide()
		self.Bar.BarFrame2:Hide()
		self.Bar.BarFrame3:Hide()
		CreateStyle( self.Bar, 2, 0, 0)
	end
end

hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateTime)
hooksecurefunc("Scenario_ChallengeMode_ShowBlock", ShowBlock)
hooksecurefunc("ScenarioTrackerProgressBar_SetValue", ProgressBar_SetValue)

--name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
--name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel = GetLFGDungeonInfo(dungeonID)

--	self.Bar.Label:SetFormattedText("%.2f%%", currentQuantity/totalQuantity*100)
--	self.Bar.Label:SetFormattedText("%d/%d", currentQuantity, totalQuantity)
--	self.Bar.Label:SetFormattedText("%.2f %%- %d/%d", currentQuantity/totalQuantity*100, currentQuantity, totalQuantity)
--	self.Bar.Label:SetFormattedText("%d/%d (%d)", currentQuantity, totalQuantity, totalQuantity - currentQuantity)
--	self.Bar.Label:SetFormattedText("%.2f %%(%.2f%%) - %d/%d (%d)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100, currentQuantity, totalQuantity, totalQuantity - currentQuantity)
