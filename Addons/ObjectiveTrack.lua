local L, yo = unpack( select( 2, ...))

----------------------------------------------------------------------------------------
--	Add quest level and type
----------------------------------------------------------------------------------------
QuestLevelFormat = " [%d] %s"
WatchFrameLevelFormat = "[%d%s%s] %s"
--QuestTypesIndex = {
--	[0] = "",           --default
--	[1] = "g",			--Group
--	[41] = "+",			--PvP
--	[62] = "r",			--Raid
--	[81] = "d",			--Dungeon
--	[83] = "L", 		--Legendary
--	[85] = "h",			--Heroic
--	[98] = "s", 		--Scenario QUEST_TYPE_SCENARIO
--	[102] = "a", 		-- Account
--}

local function ShowQuestLevelInLog()

	for button in QuestMapFrame.QuestsFrame.titleFramePool:EnumerateActive() do
		if (button and button.questLogIndex) then
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID,
				  startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = C_QuestLog.GetTitleForLogIndex( button.questLogIndex) --GetQuestLogTitle(button.questLogIndex)
			local text = button.Text:GetText()
			if title and text and (not string.find(text, "^%[.*%].*")) then
				local prevHeight = button:GetHeight() - button.Text:GetHeight()
				button.Text:SetText( QuestLevelFormat:format(level, title))
				button:SetHeight(prevHeight + button.Text:GetHeight())
				-- replacind checkbox image to the new position
				button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0);
			end
		end
	end

end

local function ShowQuestLevelInWatchFrame()
	local tracker = ObjectiveTrackerFrame
	if ( not tracker.initialized )then 	return end

	for i = 1, #tracker.MODULES do
		local xxx = tracker.MODULES[i].usedBlocks.ObjectiveTrackerBlockTemplate
		if xxx then
			for i, block in pairs(xxx) do
				if block.id and block.HeaderText and block.HeaderText:GetText() and (not string.find(block.HeaderText:GetText(), "^%[.*%].*")) then
					--print( i, block, block.id, block.HeaderText, block.HeaderText:GetText())
					local questLogIndex = C_QuestLog.GetLogIndexForQuestID( block.id)
					local questInfo = C_QuestLog.GetInfo( questLogIndex)

					if ( questLogIndex ~= 0 and questInfo.title and questInfo.title ~= "" ) then
						local questTypeIndex = GetQuestLogQuestType(questLogIndex)
						local tagString = QuestTypesIndex[questTypeIndex] or ""
						local dailyMod = ( questInfo.frequency == 1 or questInfo.frequency == 2) and "|cff0080ff*!*|r" or ""

						--resizing the block if new line requires more spaces.
						local h = block.height - block.HeaderText:GetHeight()
						block.HeaderText:SetText( WatchFrameLevelFormat:format( questInfo.level, tagString, dailyMod, questInfo.title))
						block.height = h + block.HeaderText:GetHeight()
						block:SetHeight(block.height)

						-- Icon Quest Item resize
						if block.itemButton then
							block.itemButton:SetSize( 30, 30)
							if block.itemButton.SetPushedTexture and not block.itemButton.pushed then
								local pushed = block.itemButton:CreateTexture("frame", nil, self)
								pushed:SetTexture( texture)
								pushed:SetVertexColor( 0, 1, 1, 1)
								pushed:SetPoint("TOPLEFT", 2, -2)
								pushed:SetPoint("BOTTOMRIGHT", -2, 2)
								pushed:SetAlpha( 0.7)
								block.itemButton.pushed = pushed
								block.itemButton:SetPushedTexture(pushed)
							end

							block.itemButton.NormalTexture = nil
							block.itemButton:SetNormalTexture( nil)
							block.itemButton.icon:SetTexCoord(unpack( yo.tCoord))
							CreateStyle( block.itemButton, 4, 0, 0)
			--				--block.itemButton.shadow:SetBackdropColor( 0, 0, 0, 0)
							block.itemButton.shadow:SetBackdropBorderColor( 1, 0.7, 0, 1)
						end
					end
				end
			end
		end
	end
end
hooksecurefunc("ObjectiveTracker_Update", ShowQuestLevelInWatchFrame)
hooksecurefunc("QuestLogQuests_Update", ShowQuestLevelInLog)

----------------------------------------------------------------------------------------
--	Add quest/achievement wowhead link and Abandon
----------------------------------------------------------------------------------------
local linkQuest, linkAchievement, linkText
local locale = GetLocale()

if locale == "ruRU" then
	linkQuest = "http://ru.wowhead.com/quest=%d"
	linkText = "Ссылка на Wowhead"
	linkAchievement = "http://ru.wowhead.com/achievement=%d"
else
	linkText = "Link to Wowhead"
	linkQuest = "http://wowhead.com/quest=%d"
	linkAchievement = "http://wowhead.com/achievement=%d"
end

StaticPopupDialogs.WATCHFRAME_URL = {
	text = "Wowhead link",
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 350,
	OnShow = function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	preferredIndex = 5,
}

hooksecurefunc("QuestObjectiveTracker_OnOpenDropDown", function(self)
	local _, b, i, info, questID
	b = self.activeFrame
	questID = b.id
	info = UIDropDownMenu_CreateInfo()
	info.text = linkText
	info.func = function(id)
		local inputBox = StaticPopup_Show("WATCHFRAME_URL")
		inputBox.editBox:SetText(linkQuest:format(questID))
		inputBox.editBox:HighlightText()
	end
	info.arg1 = questID
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL)

	info2 = UIDropDownMenu_CreateInfo()
	info2.text = ABANDON_QUEST .. questID
	info2.func = function(id)
		C_QuestLog.SetSelectedQuest( questID)
		C_QuestLog.SetAbandonQuest()
		C_QuestLog.AbandonQuest()
		PlaySound( SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST)
		--SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST = 846
	end
	info2.arg1 = questID
	info2.notCheckable = true
	UIDropDownMenu_AddButton(info2, UIDROPDOWN_MENU_LEVEL)
end)

hooksecurefunc("AchievementObjectiveTracker_OnOpenDropDown", function(self)
	local _, b, i, info
	b = self.activeFrame
	i = b.id
	info = UIDropDownMenu_CreateInfo()
	info.text = linkText
	info.func = function(_, i)
		local inputBox = StaticPopup_Show("WATCHFRAME_URL")
		inputBox.editBox:SetText(linkAchievement:format(i))
		inputBox.editBox:HighlightText()
	end
	info.arg1 = i
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL)
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_AchievementUI" then
		hooksecurefunc("AchievementButton_OnClick", function(self)
			if self.id and IsControlKeyDown() then
				local inputBox = StaticPopup_Show("WATCHFRAME_URL")
				inputBox.editBox:SetText(linkAchievement:format(self.id))
				inputBox.editBox:HighlightText()
			end
		end)
	end
end)


----------------------------------------------------------------------------------------
--	Move ObjectiveTrackerFrame
----------------------------------------------------------------------------------------
--local frame = CreateFrame("Frame", "yo_WatchFrameAnchor", UIParent)
--frame:ClearAllPoints()
--frame.ClearAllPoints = function() return end
--frame:SetWidth( yo_MoveQuestFrame:GetWidth())
--frame:SetHeight( yo_MoveQuestFrame:GetHeight())
--frame:SetPoint("TOPRIGHT", yo_MoveQuestFrame, "TOPRIGHT", -5, 0)
--frame.SetPoint = function() return end

yo_MoveQuestFrame:SetHeight( yo["Addons"].ObjectiveHeight )
--yo_MoveQuestFrame:SetHeight( 250)

ObjectiveTrackerFrame:SetSize( yo_MoveQuestFrame:GetSize())
ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPLEFT", yo_MoveQuestFrame, "TOPLEFT", -2, 2)
ObjectiveTrackerFrame.ClearAllPoints = dummy
ObjectiveTrackerFrame.SetPoint = dummy


--hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
--	--if parent ~= frame then
--		ObjectiveTrackerFrame:ClearAllPoints()
--		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", yo_MoveQuestFrame, "TOPRIGHT", -2, 2)
--		--ObjectiveTrackerFrame:SetSize( yo_WatchFrameAnchor:GetSize())
--	--end
--end)


----------------------------------------------------------------------------------------
--	Clear ObjectiveTrackerFrame Backgrouns
----------------------------------------------------------------------------------------

for i, frame in ipairs({ObjectiveTrackerBlocksFrame:GetChildren()}) do
	if frame.Background then
		frame.Background:Hide()
	end
end



----------------------------------------------------------------------------------------
--	Hide Objectives in Dungeon ( not Scenario)
----------------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD") ------------------------ COLLAPSE
frame:SetScript("OnEvent", function(self, event)
	if UIWidgetTopCenterContainerFrame then
		UIWidgetTopCenterContainerFrame:ClearAllPoints()
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", UIParent, "TOP", 0, -40)
	end

	local instanceType = select( 2, GetInstanceInfo())
	if IsInInstance() and instanceType ~= "scenario" and yo.Addons.hideObjective then
		ObjectiveTracker_Collapse()
	elseif ObjectiveTrackerFrame.collapsed and not InCombatLockdown() then
		ObjectiveTracker_Expand()
	end
end)
