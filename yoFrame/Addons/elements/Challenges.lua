local L, yo, n = unpack( select( 2, ...))

local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub

local GetContainerNumSlots, GetContainerItemInfo, date, time, strlower, print, strsub, CreateFrame, timeFormatMS, SendChatMessage
	= GetContainerNumSlots, GetContainerItemInfo, date, time, strlower, print, strsub, CreateFrame, timeFormatMS, SendChatMessage

local BACKPACK_CONTAINER = BACKPACK_CONTAINER
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local LANDING_PAGE_REPORT = LANDING_PAGE_REPORT
local CHALLENGE_MODE_POWER_LEVEL = CHALLENGE_MODE_POWER_LEVEL

local requestKeystoneCheck, registered

local challengeMapID
local TIME_FOR_3 = 0.6
local TIME_FOR_2 = 0.8

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
		local c = name:match("|Hkeystone:")
		local y = name:match("^Вы ")
		local z = name:match("^Ваша ")

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
		local name, _, timeLimit = C_ChallengeMode.GetMapUIInfo(challengeMapID)

		timeLimit = timeLimit * 1000
		local timeLimit2 = timeLimit * TIME_FOR_2
		local timeLimit3 = timeLimit * TIME_FOR_3

		--print(name, level, timeFormatMS(time), timeFormatMS(time - timeLimit), L["completion0"])
		--"Гробница королей"," 2, "1:05:01.321", "26:01.321"
		--L["completion0"] = "|cff8787ED[%s] %s|r окончили за |cffff0000%s|r, вы отстали на %s от общего лимита времени."
		print("|cff00ffff--------------------------------------------------------------------------")
		print( "|cff00ffff" .. LANDING_PAGE_REPORT)
		print("|cff00ffff--------------------------------------------------------------------------")
		if time <= timeLimit3 then
			DEFAULT_CHAT_FRAME:AddMessage( format( L["completion3"], level, name, timeFormatMS(time), timeFormatMS(timeLimit3 - time)), 255/255, 215/255, 1/255)
		elseif time <= timeLimit2 then
			DEFAULT_CHAT_FRAME:AddMessage( format( L["completion2"], level, name, timeFormatMS(time), timeFormatMS(timeLimit2 - time), timeFormatMS(time - timeLimit3)), 199/255, 199/255, 199/255)
		elseif onTime then
			DEFAULT_CHAT_FRAME:AddMessage( format( L["completion1"], level, name, timeFormatMS(time), timeFormatMS(timeLimit - time), timeFormatMS(time - timeLimit2)), 237/255, 165/255, 95/255)
		else
			DEFAULT_CHAT_FRAME:AddMessage( format( L["completion0"], name, level, timeFormatMS(time), timeFormatMS(time - timeLimit)), 255/255, 32/255, 32/255)
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

local timeFormat = timeFormat
local timeFormatMS = timeFormatMS

local function GetTimerFrame(block)
	if not block.TimerFrame then

		block.TimeLeft:SetFont(n.font, n.fontsize + 2)

		local TimerFrame = CreateFrame("Frame", nil, block)
		TimerFrame:SetAllPoints(block)

		TimerFrame.Text2 = TimerFrame:CreateFontString(nil, "OVERLAY")--, "GameFontHighlightLarge")
		TimerFrame.Text2:SetFont( n.font, n.fontsize +2)
		TimerFrame.Text2:SetPoint("LEFT", block.TimeLeft, "LEFT", 70, 0)

		TimerFrame.Text = TimerFrame:CreateFontString(nil, "OVERLAY")--, "GameFontHighlightLarge")
		TimerFrame.Text:SetFont( n.font, n.fontsize +2)
		TimerFrame.Text:SetPoint("LEFT", TimerFrame.Text2, "LEFT", 50, 0)

		TimerFrame.Bar3 = TimerFrame:CreateTexture(nil, "OVERLAY")
		TimerFrame.Bar3:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - TIME_FOR_3) - 4, 4)
		TimerFrame.Bar3:SetSize(2, 14)
		TimerFrame.Bar3:SetTexture( n.texture)
		TimerFrame.Bar3:SetVertexColor( 0, 1, 0, 1)
		--TimerFrame.Bar3:SetTexCoord(0, 0.5, 0, 1)

		TimerFrame.Bar2 = TimerFrame:CreateTexture(nil, "OVERLAY")
		TimerFrame.Bar2:SetPoint("TOPLEFT", block.StatusBar, "TOPLEFT", block.StatusBar:GetWidth() * (1 - TIME_FOR_2) - 4, 4)
		TimerFrame.Bar2:SetSize(2, 14)
		TimerFrame.Bar2:SetTexture( n.texture)
		TimerFrame.Bar2:SetVertexColor(0, 1, 0, 1)
		--TimerFrame.Bar2:SetTexCoord(0.5, 1, 0, 1)

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

	if elapsedTime > block.timeLimit then
		--block.TimeLeft:SetText(GetTimeStringFromSeconds(elapsedTime - block.timeLimit, false, true))
	end
end

local function ShowBlock(timerID, elapsedTime, timeLimit)
	local block = ScenarioChallengeModeBlock
	local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
	local dmgPct, healthPct = C_ChallengeMode.GetPowerLevelDamageHealthMod(level)
	if true then --Addon.Config.showLevelModifier then
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
			--	self.Bar.Label:SetFormattedText("%.2f%%", currentQuantity/totalQuantity*100)
			--	self.Bar.Label:SetFormattedText("%d/%d", currentQuantity, totalQuantity)
			--	self.Bar.Label:SetFormattedText("%.2f %%- %d/%d", currentQuantity/totalQuantity*100, currentQuantity, totalQuantity)
			self.Bar.Label:SetFormattedText("%.2f %%(%.2f%%)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100)
			--	self.Bar.Label:SetFormattedText("%d/%d (%d)", currentQuantity, totalQuantity, totalQuantity - currentQuantity)
			--	self.Bar.Label:SetFormattedText("%.2f %%(%.2f%%) - %d/%d (%d)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100, currentQuantity, totalQuantity, totalQuantity - currentQuantity)
		end
	end
end

hooksecurefunc("Scenario_ChallengeMode_UpdateTime", UpdateTime)
hooksecurefunc("Scenario_ChallengeMode_ShowBlock", ShowBlock)
hooksecurefunc("ScenarioTrackerProgressBar_SetValue", ProgressBar_SetValue)

--name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
--name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel = GetLFGDungeonInfo(dungeonID)
