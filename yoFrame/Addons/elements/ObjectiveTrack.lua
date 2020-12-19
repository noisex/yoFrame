local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.ObjectiveTracker then return end

----------------------------------------------------------------------------------------
--	Add quest level and type
----------------------------------------------------------------------------------------

QuestLevelFormat = " [%d] %s"
--WatchFrameLevelFormat = "[%d%s%s] %s"
WatchFrameLevelFormat = "%s%s %s"

hooksecurefunc("ObjectiveTrackerProgressBar_OnEvent", function(self, ...)
	if not self.Bar.shadow then
		self.Bar:SetStatusBarTexture(texture)
		--self.Bar.BorderLeft 	= nil
		self.Bar.BorderLeft:Hide()
		self.Bar.BorderRight:Hide()
		self.Bar.BorderMid:Hide()

		CreateStyle( self.Bar, 2)
	end
end)


hooksecurefunc("BonusObjectiveTrackerProgressBar_OnEvent", function(self, ...)
	if not self.Bar.shadow then
		self.Bar:SetStatusBarTexture(texture)
		self.Bar.BarFrame:Hide()
		self.Bar.BarFrame2:Hide()
		self.Bar.BarFrame3:Hide()
		self.Bar.IconBG:Hide()
		self.Bar.Icon:SetMask( nil)
		self.Bar.Icon:SetTexCoord( unpack( n.tCoord))

		CreateStyle( self.Bar, 2)
	end
end)

--[[
local function CompareQuestWatchInfos(info1, info2)
	local quest1, quest2 = info1.quest, info2.quest;
	if quest1:IsCalling() 			~= quest2:IsCalling() 			then return quest1:IsCalling(); end
	if quest1.overridesSortOrder 	~= quest2.overridesSortOrder 	then return quest1.overridesSortOrder; end
	return info1.index < info2.index;
end

origBuildQuestWatchInfos = QUEST_TRACKER_MODULE.BuildQuestWatchInfos

myShortQuester = function ()
	local infos = {};

	for i = 1, C_QuestLog.GetNumQuestWatches() do
		local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i);
		if questID then
			local quest = QuestCache:Get(questID);
			local onMap, hasLocalPOI = C_QuestLog.IsOnMap( questID)
			--if ( yo.Addons.ObjectiveShort and ( hasLocalPOI or onMap)) then --and self:ShouldDisplayQuest(quest) then
			if QUEST_TRACKER_MODULE:ShouldDisplayQuest(quest) then
				--print( onMap, hasLocalPOI, questID, self:ShouldDisplayQuest(quest))
				if yo.Addons.ObjectiveShort and not onMap then
				else
					table.insert(infos, { quest = quest, index = i });
				end
			end
		end
	end
	table.sort(infos, CompareQuestWatchInfos);
	return infos;
end

local shortButton = CreateFrame("CheckButton", nil, ObjectiveTrackerFrame.HeaderMenu, "InterfaceOptionsCheckButtonTemplate")
shortButton:SetPoint("RIGHT", ObjectiveTrackerFrame.HeaderMenu, "LEFT", -120, 0)
shortButton:SetChecked( yo.Addons.ObjectiveShort)
shortButton.Text:SetText("ShortMenu")
shortButton:SetScript("OnClick", function(self, ...)
	Setlers( "Addons#ObjectiveShort", self:GetChecked(), true)
	if self:GetChecked() then 	QUEST_TRACKER_MODULE.BuildQuestWatchInfos = myShortQuester
	else 						QUEST_TRACKER_MODULE.BuildQuestWatchInfos = origBuildQuestWatchInfos end
	QUEST_TRACKER_MODULE:Update()
end)

if yo.Addons.ObjectiveShort then
	QUEST_TRACKER_MODULE.BuildQuestWatchInfos = myShortQuester
	--QUEST_TRACKER_MODULE:Update()
end
 --QUEST_TRACKER_MODULE:BuildQuestWatchInfos
--ObjectiveTrackerFrame.HeaderMenu
--yo.Addons.ObjectiveShort
	--ObjectiveTrackerFrame.HeaderMenu.ShortButton = shortButton
]]
local function ShowQuestLevelInLog()
	--for button in QuestMapFrame.QuestsFrame.titleFramePool:EnumerateActive() do
	--	if (button and button.questLogIndex) then
	--		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID,
	--			  startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = C_QuestLog.GetTitleForLogIndex( button.questLogIndex) --GetQuestLogTitle(button.questLogIndex)
	--		local text = button.Text:GetText()
	--		if title and text and (not string.find(text, "^%[.*%].*")) then
	--			local prevHeight = button:GetHeight() - button.Text:GetHeight()
	--			--button.Text:SetText( QuestLevelFormat:format(level, title))
	--			button:SetHeight(prevHeight + button.Text:GetHeight())
	--			-- replacind checkbox image to the new position
	--			button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0);
	--		end
	--	end
	--end
end

local function designItemButton( itemButton, block)

	--local p1, f1, p2 = itemButton:GetPoint()
	itemButton:ClearAllPoints()
	itemButton:SetPoint("TOPRIGHT", block, "TOPLEFT", -35, 5)

	if not itemButton.shadow then

		if itemButton.SetPushedTexture and not itemButton.pushed then
			local pushed = itemButton:CreateTexture("frame", nil, self)
			pushed:SetTexture( texture)
			pushed:SetVertexColor( 0, 1, 1, 1)
			pushed:SetPoint("TOPLEFT", 1, -1)
			pushed:SetPoint("BOTTOMRIGHT", -1, 1)
			pushed:SetAlpha( 0.7)
			itemButton.pushed = pushed
			itemButton:SetPushedTexture(pushed)
		end

		itemButton.NormalTexture = nil
		itemButton:SetNormalTexture( nil)
		if itemButton.icon then itemButton.icon:SetTexCoord(unpack( n.tCoord))
			itemButton:SetSize( 30, 30)
			CreateStyle( itemButton, 4, 0, 0)
			itemButton.shadow:SetBackdropBorderColor( 0, 1, 0.8)--( 1, 0.7, 0, 1)
			end
		if itemButton.Icon then
			itemButton.Icon:ClearAllPoints()
			itemButton.Icon:SetPoint("TOPLEFT", itemButton, "TOPLEFT", 3, -3)
			itemButton.Icon:SetPoint("BOTTOMRIGHT", itemButton, "BOTTOMRIGHT", -3, 3)
			CreateStyle( itemButton, 1, 0, 0, 0)
		end
	end
end

local function ShowQuestLevelInWatchFrame()
	local tracker = ObjectiveTrackerFrame
	if ( not tracker.initialized )then 	return end

	for i = 1, #tracker.MODULES do
		local xxx =  tracker.MODULES[i].usedBlocks.ObjectiveTrackerBlockTemplate --tracker.MODULES[i].usedBlocks.BonusObjectiveTrackerBlockTemplate --
		if xxx then
			for i, block in pairs(xxx) do
				if block.id and block.HeaderText and block.HeaderText:GetText() and (not string.find(block.HeaderText:GetText(), "^%[.*%].*")) then
					local questLogIndex = C_QuestLog.GetLogIndexForQuestID( block.id)
					--print( i, block.id, questLogIndex, block.HeaderText:GetText())
					if not questLogIndex then break end

					local questInfo = C_QuestLog.GetInfo( questLogIndex)

--if questInfo.questID == 60457 then

--end

					if questInfo and ( questLogIndex ~= 0 and questInfo.title and questInfo.title ~= "" ) then
						local questTypeIndex = GetQuestLogQuestType(questLogIndex)
						local tagString = n.questTypesIndex[questTypeIndex] or ""
						local dailyMod = ( questInfo.frequency == 1 or questInfo.frequency == 2) and "|cff0080ff*!*|r" or ""

						--resizing the block if new line requires more spaces.
						local h = block.height - block.HeaderText:GetHeight()
						--block.HeaderText:SetText( WatchFrameLevelFormat:format( questInfo.level, tagString, dailyMod, questInfo.title))
						block.HeaderText:SetText( WatchFrameLevelFormat:format( tagString, dailyMod, questInfo.title))
						block.height = h + block.HeaderText:GetHeight()
						block:SetHeight(block.height)

						-- Icon Quest Item resize
						if block.itemButton then
							designItemButton( block.itemButton, block)
						end
						if block.groupFinderButton then
							--block.groupFinderButton:SetSize( 20, 20)
							block.groupFinderButton.Icon:SetSize( 20, 20)
							block.groupFinderButton:SetNormalTexture(nil)
						end
					end
				end
			end
		end
	end
	local xxx =  tracker.MODULES[4].usedBlocks.BonusObjectiveTrackerBlockTemplate
	if xxx then
		for i, block in pairs(xxx) do
			if block.itemButton then
				designItemButton( block.itemButton, block)
			end
			if block.rightButton then
				designItemButton( block.rightButton, block)
			end
		end
	end
end

hooksecurefunc("ObjectiveTracker_Update", ShowQuestLevelInWatchFrame)
--hooksecurefunc("QuestLogQuests_Update", ShowQuestLevelInLog)
hooksecurefunc("QuestObjectiveItem_OnUpdate", function(self, elapsed) 		-- Rahge Check ItemButtom
	local rangeTimer = self.rangeTimer;
	rangeTimer = rangeTimer - elapsed;
	if ( rangeTimer <= 0 ) then
		local valid = IsQuestLogSpecialItemInRange(self:GetID());
		if valid and valid == 0
			then self.icon:SetVertexColor( 1, 0, 0, 1)
		else
			self.icon:SetVertexColor(1, 1, 1, 1)
		end
	end
end)

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
	info2.text = ABANDON_QUEST .. ": " .. questID
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
--frame:SetWidth( yoMoveQuestFrame:GetWidth())
--frame:SetHeight( yoMoveQuestFrame:GetHeight())
--frame:SetPoint("TOPRIGHT", yoMoveQuestFrame, "TOPRIGHT", -5, 0)
--frame.SetPoint = function() return end

yoMoveQuestFrame:SetHeight( yo["Addons"].ObjectiveHeight )
--yoMoveQuestFrame:SetHeight( 250)

ObjectiveTrackerFrame:SetSize( yoMoveQuestFrame:GetSize())
ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPLEFT", yoMoveQuestFrame, "TOPLEFT", -2, 2)
ObjectiveTrackerFrame.ClearAllPoints = n.dummy
ObjectiveTrackerFrame.SetPoint = n.dummy


--hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
--	--if parent ~= frame then
--		ObjectiveTrackerFrame:ClearAllPoints()
--		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", yoMoveQuestFrame, "TOPRIGHT", -2, 2)
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
	elseif 	instanceType == "scenario" and yo.Addons.hideObjective then
		QUEST_TRACKER_MODULE.Header.MinimizeButton:Click()
	elseif ObjectiveTrackerFrame.collapsed and not InCombatLockdown() then
		ObjectiveTracker_Expand()
		QUEST_TRACKER_MODULE.Header.MinimizeButton:Click()
	end
end)


-- objectiveFrameAutoHide
ObjectiveTrackerFrame.AutoHider = CreateFrame('Frame', nil, ObjectiveTrackerFrame, 'SecureHandlerStateTemplate')
ObjectiveTrackerFrame.AutoHider:SetAttribute('_onstate-objectiveHider', 'if newstate == 1 then self:Hide() else self:Show() end')
ObjectiveTrackerFrame.AutoHider:SetScript('OnHide', function()
	if not ObjectiveTrackerFrame.collapsed then
		if yo.Addons.hideObjective then
			_G.ObjectiveTracker_Collapse()
		else
			local _, _, difficultyID = GetInstanceInfo()
			if difficultyID and difficultyID ~= 8 then -- ignore hide in keystone runs
				_G.ObjectiveTracker_Collapse()
			end
		end
	end
end)

ObjectiveTrackerFrame.AutoHider:SetScript('OnShow', function()
	if ObjectiveTrackerFrame.collapsed then
		_G.ObjectiveTracker_Expand()
	end
end)

RegisterStateDriver(_G.ObjectiveTrackerFrame.AutoHider, 'objectiveHider', '[@arena1,exists][@arena2,exists][@arena3,exists][@arena4,exists][@arena5,exists][@boss1,exists][@boss2,exists][@boss3,exists][@boss4,exists] 1;0')
