local L, yo, n = unpack( select( 2, ...))

local _G = _G
local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub

local GameTooltip, CreateFrame, ipairs, hooksecurefunc, select, GetContainerNumSlots, GetContainerItemInfo, pairs, unpack, CreateStyle, LoadAddOn, GameTooltip_Hide, PickupContainerItem, CursorHasItem, ToggleFrame
	= GameTooltip, CreateFrame, ipairs, hooksecurefunc, select, GetContainerNumSlots, GetContainerItemInfo, pairs, unpack, CreateStyle, LoadAddOn, GameTooltip_Hide, PickupContainerItem, CursorHasItem, ToggleFrame

local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local BACKPACK_CONTAINER= BACKPACK_CONTAINER
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local CHALLENGE_MODE_POWER_LEVEL= CHALLENGE_MODE_POWER_LEVEL
local CHALLENGE_MODE_GUILD_BEST_LINE= CHALLENGE_MODE_GUILD_BEST_LINE

local rowCount = 3
local affCount = 3
local iSize = 35
local currentWeek, designed

local mythicRewards = {
--	{"Level","End","Weekly","Azer Weekly"},
	{2,187,200},
	{3,190,203},
	{4,194,207},
	{5,194,210},
	{6,197,210},
	{7,200,213},
	{8,200,216},
	{9,200,216},
	{10,204,220},
	{11,204,220},
	{12,207,223},
	{13,207,223},
	{14,207,226},
	{15,210,226},
}

local affixWeeks = { --affixID as used in C_ChallengeMode.GetAffixInfo(affixID)
    [1] = 	{[2]=11,	[3]=3,	[1]=10,	[4]=121},
    [2] = 	{[2]=7,		[3]=124,[1]=9,	[4]=121},
    [3] = 	{[2]=123,	[3]=12,	[1]=10,	[4]=121},
    [4] = 	{[2]=122,	[3]=4,	[1]=9,	[4]=121},
    [5] = 	{[2]=8,		[3]=14,	[1]=10,	[4]=121},
    [6] = 	{[2]=6,		[3]=13,	[1]=9,	[4]=121},
    [7] = 	{[2]=123,	[3]=3,	[1]=10,	[4]=121},
    [8] = 	{[2]=7,		[3]=4,	[1]=9,	[4]=121},
    [9] = 	{[2]=122,	[3]=124,[1]=10,	[4]=121},
    [10] =	{[2]=11,	[3]=13,	[1]=9,	[4]=121},
    [11] = 	{[2]=8,		[3]=12,	[1]=10,	[4]=121},
    [12] = 	{[2]=6,		[3]=14,	[1]=9,	[4]=121},
}

local function GuildLeadersOnLeave(...)
    GameTooltip:Hide()
end

local function GuildLeadersOnEnter( self)
	--local leaderInfo = self.leadersInfo;

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    local name = C_ChallengeMode.GetMapUIInfo(self.leadersInfo.mapChallengeModeID);
    GameTooltip:SetText(name, 1, 1, 1);
    GameTooltip:AddLine(CHALLENGE_MODE_POWER_LEVEL:format(self.leadersInfo.keystoneLevel));
    for i = 1, #self.leadersInfo.members do
        local classColorStr = RAID_CLASS_COLORS[self.leadersInfo.members[i].classFileName].colorStr;
        GameTooltip:AddLine(CHALLENGE_MODE_GUILD_BEST_LINE:format(classColorStr,self.leadersInfo.members[i].name));
    end
    GameTooltip:Show();
end

local function CreateLeadersIcon( self, index)
	if not self[index] then
		local frame = CreateFrame("Frame", nil, self)
		if index == 1 then
			frame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		else
			frame:SetPoint("TOPLEFT", self[index-1], "BOTTOMLEFT", 0, -5)
		end
		frame:SetSize( iSize +10, iSize +10)

		frame.icon = frame:CreateTexture(nil, "OVERLAY")
		frame.icon:SetAllPoints(frame)
		--frame.icon:SetTexCoord( 0.365, 0.636, 0.352, 0.742)

		frame.level = frame:CreateFontString(nil, "OVERLAY")
		frame.level:SetFont( n.font, n.fontsize + 4, "OUTLINE")
		frame.level:SetTextColor( 1, 0.75, 0, 1)
		frame.level:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", 0, 1)

		frame.mapname = frame:CreateFontString(nil, "ARTWORK")
		frame.mapname:SetFont( n.font, n.fontsize, "OUTLINE")
		frame.mapname:SetTextColor( 1, 0.75, 0, 1)
		frame.mapname:SetPoint("TOPLEFT", frame.icon, "TOPRIGHT", 5, 0)

		frame.leadername = frame:CreateFontString(nil, "ARTWORK")
		frame.leadername:SetFont( n.font, n.fontsize, "OUTLINE")
		frame.leadername:SetPoint("LEFT", frame.icon, "RIGHT", 5, 0)
		CreateStyle( frame, 4, 2)

		frame:SetScript("OnEnter", GuildLeadersOnEnter)
		frame:SetScript("OnLeave", GuildLeadersOnLeave)

		self[index] = frame
	end

	return self[index]
end

local function CreateLiders( self)

	local self = _G.ChallengesFrame
	local leaders = C_ChallengeMode.GetGuildLeaders()
	--print("leaders:")
	--tprint(leaders)
	if leaders and #leaders > 0 then

		if not self.leaderBest then
			self.leaderBest = CreateFrame("Frame", nil, _G.ChallengesFrame)
			self.leaderBest:SetSize(175, ( 35+5) * #leaders)
			self.leaderBest:SetPoint("TOPLEFT", _G.ChallengesFrame, "TOPLEFT", 10, -120)

			self.leaderBest.title = self.leaderBest:CreateFontString(nil, "ARTWORK")
			self.leaderBest.title:SetFont( n.font, n.fontsize + 3, "OUTLINE")
			self.leaderBest.title:SetTextColor( 1, 0.75, 0, 1)
			self.leaderBest.title:SetText(  L["WeekLeader"])
			self.leaderBest.title:SetPoint("BOTTOM", self.leaderBest, "TOP", -15, 10)
		end

		for ind, leadersInfo in ipairs( leaders) do
   			local icons = CreateLeadersIcon( self.leaderBest, ind)
			local map, _, _, mapTexture =  C_ChallengeMode.GetMapUIInfo( leadersInfo.mapChallengeModeID)

			icons.level:SetText( leadersInfo.keystoneLevel)
			icons.leadername:SetText( "|c" .. RAID_CLASS_COLORS[leadersInfo.classFileName].colorStr .. leadersInfo.name)
			icons.mapname:SetText( map)
			icons.icon:SetTexture( mapTexture)

			icons.leadersInfo = leadersInfo
		end
	end
end

local function skinDungens()
	for k, map in pairs( _G.ChallengesFrame.DungeonIcons) do
		map.HighestLevel:ClearAllPoints()
		map.HighestLevel:SetPoint("BOTTOMRIGHT", map, "BOTTOMRIGHT", -1, 2)

		map.Icon:SetHeight( map:GetHeight() - 10)
		map.Icon:SetWidth( map:GetWidth() - 10)
		map.Icon:SetTexCoord(unpack( n.tCoord))
		map:GetRegions(1):SetAtlas( nil) --GetAtlas())
		if not map.shadow then
			CreateStyle( map, 4)
		end
	end
end

local function UpdateAffixes( self)
	if designed then return end

	if self.WeeklyInfo.Child.WeeklyChest.RunStatus then
		self.WeeklyInfo.Child.WeeklyChest.RunStatus:SetFont( n.font, n.fontsize + 1, "OUTLINE")
		self.WeeklyInfo.Child.WeeklyChest.RunStatus:ClearAllPoints()
		self.WeeklyInfo.Child.WeeklyChest.RunStatus:SetPoint("TOP", self, "TOP", 10, -140)
		self.WeeklyInfo.Child.WeeklyChest.RunStatus:SetWidth( 250)
		self.WeeklyInfo.Child.WeeklyChest.RunStatus.ClearAllPoints = n.dummy
	end

	if self.WeeklyInfo.Child.RunStatus then
		self.WeeklyInfo.Child.RunStatus:SetFont( n.font, n.fontsize + 1, "OUTLINE")
		self.WeeklyInfo.Child.RunStatus:ClearAllPoints()
		self.WeeklyInfo.Child.RunStatus:SetPoint("TOP", self, "TOP", 0, -150)
		self.WeeklyInfo.Child.RunStatus:SetWidth( 200)
		self.WeeklyInfo.Child.RunStatus.ClearAllPoints = n.dummy
	end

	if self.WeeklyInfo.Child.Description then
		self.WeeklyInfo.Child.Description:SetFont( n.font, n.fontsize + 1, "OUTLINE")
		self.WeeklyInfo.Child.Description:ClearAllPoints()
		self.WeeklyInfo.Child.Description:SetPoint("TOP", self, "TOP", 10, -140)
		self.WeeklyInfo.Child.Description:SetWidth( 250)
		self.WeeklyInfo.Child.Description.ClearAllPoints = n.dummy
	end

	if self.WeeklyInfo.Child.WeeklyChest then
		local weekly = self.WeeklyInfo.Child.WeeklyChest
		weekly.RewardButton = CreateFrame( "Button", nil, weekly)
		weekly.RewardButton:SetAllPoints(weekly)
		weekly.RewardButton:EnableMouse(true)
		weekly.RewardButton:SetScript("OnEnter", function(self, ...)
			weekly.Icon:SetDesaturated(true)
			weekly.Icon:SetVertexColor(1, 0.8, 0.2, 1)
		end)

		weekly.RewardButton:SetScript("OnLeave", function(self, ...)
			weekly.Icon:SetDesaturated( false)
			weekly.Icon:SetVertexColor(1, 1, 1, 1)
		end)

		weekly.RewardButton:SetScript("OnClick", function (...)
			LoadAddOn("Blizzard_WeeklyRewards");
			_G.WeeklyRewardsFrame:SetShown( not _G.WeeklyRewardsFrame:IsShown())
		end)
	end

	C_MythicPlus.RequestCurrentAffixes()
	local scheduleWeek
    local affixIds = C_MythicPlus.GetCurrentAffixes() --table - 2 3 1 in BFA my table
    if not affixIds then return end

    for week, affixes in ipairs( affixWeeks) do
       	if affixes[1] == affixIds[1].id and affixes[2] == affixIds[2].id and affixes[3] == affixIds[3].id then
           	currentWeek = week
       	end
    end

	if currentWeek then
		for i = 1, rowCount do
			local entry = self.Frame.Entries[i]
			entry:Show()

			scheduleWeek = (currentWeek - 2 + i)  %12 + 1
			local affixes = affixWeeks[scheduleWeek]
			for j = 1, affCount do
				local affix = entry.Affixes[j]
				affix:SetUp( affixes[j])
			end
		end
	end

	--tprint( affixIds)
	--if affixIds[4].id == 119 then
    	if not self.seasonAffix then
    		local seasonAffix = self:CreateFontString( nil, "ARTWORK") --, "GameFontNormalMed1")
			seasonAffix:SetFont( n.font, n.fontsize +2, "OUTLINE")
			seasonAffix:SetTextColor( 0.529, 0.529, 0.929, 1)
			seasonAffix:SetJustifyH("CENTER")
			seasonAffix:SetPoint("BOTTOM", self.WeeklyInfo.Child.RunStatus, "TOP", 0, 15)

			self.seasonAffix = seasonAffix
		end
		--self.seasonAffix:SetText( "|cffffff00Манящий: |r" .. affixWeeks[scheduleWeek][5])
    --end

    if self.WeeklyInfo.Child.WeeklyChest.ownedKeystoneLevel and self.WeeklyInfo.Child.WeeklyChest.ownedKeystoneLevel > 1 then
		if not self.weekReward then
			local weekReward = self:CreateFontString( nil, "ARTWORK") --, "GameFontNormalMed1")
			weekReward:SetFont( n.font, n.fontsize +9, "OUTLINE")
			weekReward:SetTextColor( 1, 0, 0)
			weekReward:SetJustifyH("LEFT")
			weekReward:SetPoint("LEFT", self.WeeklyInfo.Child.Label, "RIGHT", 5, 0)
			self.weekReward = weekReward
		end

		self.weekReward:SetText( self.WeeklyInfo.Child.WeeklyChest.ownedKeystoneLevel)
    end

    designed = true
	skinDungens()
	C_Timer.After( 0.7, CreateLiders) --CreateLiders( self)
end

local function makeAffix(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(iSize +2, iSize +2)  --(16, 16)

	local border = frame:CreateTexture(nil, "OVERLAY")
	border:SetAllPoints()
	border:SetAtlas("ChallengeMode-AffixRing-Sm")
	frame.Border = border

	local portrait = frame:CreateTexture(nil, "ARTWORK")
	portrait:SetSize( iSize, iSize)  --(14, 14)
	portrait:SetPoint("CENTER", border)
	frame.Portrait = portrait

	frame.SetUp = ScenarioChallengeModeAffixMixin.SetUp
	frame:SetScript("OnEnter", ScenarioChallengeModeAffixMixin.OnEnter)
	frame:SetScript("OnLeave", GameTooltip_Hide)

	return frame
end

local function Blizzard_ChallengesUI( self)
	local frame = CreateFrame("Frame", nil, _G.ChallengesFrame)
	frame:SetSize( (iSize + 10) * affCount, (iSize + 7) * rowCount + 50 + 120)
	frame:SetPoint("TOPRIGHT", _G.ChallengesFrame.WeeklyInfo.Child, "TOPRIGHT", -6, -15)

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetAtlas("ChallengeMode-guild-background")
	bg:SetAlpha( .4)
	frame.bg = bg

	local title = frame:CreateFontString(nil, "ARTWORK")--, "GameFontNormalMed1")
	title:SetFont( n.font, n.fontsize + 3, "OUTLINE")
	title:SetTextColor(1, 0.75, 0, 1)
	title:SetText( L["Schedule"])
	title:SetPoint("TOP", 0, -3)
	frame.title = title

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize( frame:GetWidth() - 10, 9)
	line:SetAtlas("ChallengeMode-RankLineDivider", false)
	line:SetPoint("TOP", 0, -16)
	frame.line = line

	local Levels = frame:CreateFontString(nil, "ARTWORK") --, "GameFontNormalMed1")
	Levels:SetFont( n.font, n.fontsize + 3, "OUTLINE")
	Levels:SetTextColor( 0.5, 0.5, 0.5, 1)
	--Levels:SetText( "2+      4+      7+      10+")
	Levels:SetText( "2+      4+      7+")
	Levels:SetPoint("TOPLEFT", 20, -24)
	frame.Levels = Levels

	local line2 = frame:CreateTexture(nil, "ARTWORK")
	line2:SetSize( frame:GetWidth() - 10, 9)
	line2:SetAtlas("ChallengeMode-RankLineDivider", false)
	line2:SetPoint("TOP", 0, -35)
	frame.line2 = line2

	local line3 = frame:CreateTexture(nil, "ARTWORK")
	line3:SetSize( frame:GetWidth() - 10, 9)
	line3:SetAtlas("ChallengeMode-RankLineDivider", false)
	line3:SetPoint("TOP", 0, -(iSize + 7) * rowCount - 43)
	frame.line3 = line3

	local title2 = frame:CreateFontString(nil, "ARTWORK")--, "GameFontNormalMed1")
	title2:SetFont( n.font, n.fontsize + 3, "OUTLINE")
	title2:SetTextColor(1, 0.75, 0, 1)
	title2:SetText( L["Rewards"])
	title2:SetPoint("TOP", line3, "BOTTOM", 0, 0)
	frame.title2 = title2

	local line4 = frame:CreateTexture(nil, "ARTWORK")
	line4:SetSize( frame:GetWidth() - 10, 9)
	line4:SetAtlas("ChallengeMode-RankLineDivider", false)
	line4:SetPoint("TOP", title2, "BOTTOM", 0, 0)
	frame.line4 = line4

	local outReward = "|cffffc300Level  Reward   Week Chest|r\n"
	for i, v in ipairs( mythicRewards ) do
		outReward = outReward .. format("|cffff0000%5d|r|cff00ffff%12d|r|cffff9900%15d\n|r", v[1], v[2], v[3])
	end
	frame.outReward = outReward

	local rewards = frame:CreateFontString(nil, "ARTWORK") --, "GameFontNormalMed1")
	rewards:SetFont( n.font, n.fontsize, "OUTLINE")
	rewards:SetText( outReward)
	rewards:SetJustifyH("LEFT")
	rewards:SetPoint("TOP", line4, "BOTTOM", 0, 0)
	frame.rewards = rewards

	local entries = {}
	for i = 1, rowCount do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetSize( frame:GetWidth(), iSize)

		local affixes = {}
		local prevAffix
		for j = 1, affCount, 1 do
			local affix = makeAffix(entry)
			if prevAffix then
				affix:SetPoint("LEFT", prevAffix, "RIGHT", 5, 0)
			else
				affix:SetPoint("LEFT", 5, 0)
			end
			prevAffix = affix
			affixes[j] = affix
		end
		entry.Affixes = affixes

		if i == 1 then
			entry:SetPoint("TOP", line2, "BOTTOM", 0, -5)
		else
			entry:SetPoint("TOP", entries[i-1], "BOTTOM", 0, -5)
		end

		entries[i] = entry
	end

	frame.Entries = entries
	_G.ChallengesFrame.Frame = frame

	frame:SetScript("OnShow", function(self, ...)
		CreateLiders( _G.ChallengesFrame)
		--UpdateAffixes( _G.ChallengesFrame)
	end)

	hooksecurefunc("ChallengesFrame_Update", UpdateAffixes)
end

local function SlotKeystone()
	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do
			local _, _, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
			if slotLink and slotLink:match("|Hkeystone:") then
				PickupContainerItem(container, slot)
				if (CursorHasItem()) then
					C_ChallengeMode.SlotKeystone()
				end
			end
		end
	end
end

local function makeSoulsBitton(...)

	local frame = _G.GarrisonLandingPage
	local invite = select( 2, frame.Report.Sections:GetChildren())

	if invite then
		invite:ClearAllPoints()
		invite:SetPoint( "TOPLEFT", frame, "TOPLEFT", 0, -295)

		local panel = frame.SoulbindPanel
		panel.NewButton = panel.NewButton or CreateFrame("Button", "$parentnewName", panel, "LandingPageRenownButtonTemplate")
		panel.NewButton:ClearAllPoints()
		panel.NewButton:SetPoint( "TOPLEFT", panel.SoulbindButton, "BOTTOMLEFT", 0, 0)
		panel.NewButton.Label:SetText( "Ежеднивничек")
		panel.NewButton.Label:SetTextColor( 0.9, 0.8, 0.2, 1)
		panel.NewButton.Renown:SetText("")

		panel.NewButton:SetScript("OnClick", function(self, ...)
			--frame:Hide()
			LoadAddOn("Blizzard_WeeklyRewards");
			ToggleFrame( _G.WeeklyRewardsFrame)
		end)
		--panel.NewButton.Portrait:SetTexture( n.texture)
		--panel.NewButton.Portrait:SetAtlas("shadowlands-landingpage-soulbindsbutton-theotar")
	end
end

local function OnEvent( self, event, name, sender, ...)

	if name == "Blizzard_ChallengesUI" then
		Blizzard_ChallengesUI( self)
		_G.ChallengesKeystoneFrame:HookScript("OnShow", SlotKeystone)

	elseif name == "Blizzard_WeeklyRewards" then
		_G.WeeklyRewardsFrame:SetScale(0.8)

	elseif name == "Blizzard_GarrisonUI" then
		if yo.Addons.AutoCovenantsMission then
			local missionComplete 	= _G.CovenantMissionFrame.MissionComplete
			local butonContinue 	= _G.CovenantMissionFrame.MissionComplete.CompleteFrame.ContinueButton
			local buttonComplete 	= _G.CovenantMissionFrame.MissionComplete.RewardsScreen.FinalRewardsPanel.ContinueButton

			butonContinue:HookScript("OnShow", function(self, ...)
				--C_Timer.After( 0.2, function() 	_G.CovenantMissionFrame.MissionComplete:AdvanceStage() end) end)
				--print( missionComplete.autoCombatResult)
				C_Timer.After( 0.2, function( ) buttonComplete:OnClick() end)
			end)

			--buttonComplete:HookScript("OnShow", function(self, ...)
			--	C_Timer.After( 0.2, function( ) buttonComplete:OnClick() end) end)
		end
	end
end

local logan = CreateFrame("Frame", nil, UIParent)
logan:RegisterEvent("ADDON_LOADED")
logan:SetScript("OnEvent", OnEvent)