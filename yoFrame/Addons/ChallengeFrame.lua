local L, yo = unpack( select( 2, ...))

local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub

local rowCount = 3
local affCount = 3
local iSize = 35
local currentWeek, designed

--Уровни добычи Замка Нафрия
--Режим	1-8 боссы	9-10 боссы
--Поиск рейда	187	194
--Обычный	200	207
--Героический	213	220
--Эпохальный	226	233

-- 1: Overflowing, 2: Skittish, 3: Volcanic, 4: Necrotic, 5: Teeming, 6: Raging, 7: Bolstering, 8: Sanguine, 9: Tyrannical, 10: Fortified, 11: Bursting, 12: Grievous, 13: Explosive, 14: Quaking
-- 20: Void, 21: "Tides", 22: "Enchanted"

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
	{11,204,200},
	{12,207,223},
	{13,207,223},
	{14,207,226},
	{15,210,226},
}

local affixWeeks = { --affixID as used in C_ChallengeMode.GetAffixInfo(affixID)

    [1] =  	{[1]=10,	[2]=11,		[3]=124,	[4]=120, 	[5] = "Меченная Бездной посланница",},
    [2] =  	{[1]=9,		[2]=8,		[3]=12,  	[4]=120, 	[5] = "Посланница глубин",},
    [3] = 	{[1]=10, 	[2]=112,	[3]=13,		[4]=120, 	[5] = "Зачарованная посланница",},
    [4] = 	{[1]=9,  	[2]=6,		[3]=14,		[4]=120, 	[5] = "Меченная Бездной посланница",},
    [5] = 	{[1]=10, 	[2]=8,		[3]=12,		[4]=120, 	[5] = "Посланница глубин",},			---
    [6] =  	{[1]=9,  	[2]=11,		[3]=4, 		[4]=120, 	[5] = "Зачарованная посланница",},
    [7] =  	{[1]=10, 	[2]=8,		[3]=14,		[4]=120, 	[5] = "Меченная Бездной посланница",},
    [8] =  	{[1]=9,  	[2]=7,		[3]=13,		[4]=120, 	[5] = "Посланница глубин",},
    [9] = 	{[1]=10, 	[2]=11,		[3]=3, 		[4]=120, 	[5] = "Зачарованная посланница",},
    [10] = 	{[1]=9,  	[2]=6,		[3]=4, 		[4]=120, 	[5] = "Меченная Бездной посланница",},
    [11] = 	{[1]=10, 	[2]=5,		[3]=14,		[4]=120, 	[5] = "Посланница глубин",},
    [12] = 	{[1]=9,  	[2]=11,		[3]=2, 		[4]=120, 	[5] = "Зачарованная посланница",},
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
		frame.level:SetFont( yo.font, yo.fontsize + 4, "OUTLINE")
		frame.level:SetTextColor( 1, 0.75, 0, 1)
		frame.level:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", 0, 1)

		frame.mapname = frame:CreateFontString(nil, "ARTWORK")
		frame.mapname:SetFont( yo.font, yo.fontsize, "OUTLINE")
		frame.mapname:SetTextColor( 1, 0.75, 0, 1)
		frame.mapname:SetPoint("TOPLEFT", frame.icon, "TOPRIGHT", 5, 0)

		frame.leadername = frame:CreateFontString(nil, "ARTWORK")
		frame.leadername:SetFont( yo.font, yo.fontsize, "OUTLINE")
		frame.leadername:SetPoint("LEFT", frame.icon, "RIGHT", 5, 0)
		CreateStyle( frame, 4, 2)

		frame:SetScript("OnEnter", GuildLeadersOnEnter)
		frame:SetScript("OnLeave", GuildLeadersOnLeave)

		self[index] = frame
	end

	return self[index]
end

local function CreateLiders( self)

	local leaders = C_ChallengeMode.GetGuildLeaders()
	if leaders and #leaders > 0 then

		if not self.leaderBest then
			self.leaderBest = CreateFrame("Frame", nil, ChallengesFrame)
			self.leaderBest:SetSize(175, ( 35+5) * #leaders)
			self.leaderBest:SetPoint("TOPLEFT", ChallengesFrame, "TOPLEFT", 10, -120)

			self.leaderBest.title = self.leaderBest:CreateFontString(nil, "ARTWORK")
			self.leaderBest.title:SetFont( yo.font, yo.fontsize + 3, "OUTLINE")
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
	for k, map in pairs( ChallengesFrame.DungeonIcons) do
		map.HighestLevel:ClearAllPoints()
		map.HighestLevel:SetPoint("BOTTOMRIGHT", map, "BOTTOMRIGHT", -1, 2)

		map.Icon:SetHeight( map:GetHeight() - 4)
		map.Icon:SetWidth( map:GetWidth() - 4)
		map.Icon:SetTexCoord(unpack( yo.tCoord))
		map:GetRegions(1):SetAtlas( nil) --GetAtlas())
		if not map.shadow then
			CreateStyle( map, 4)
		end
	end
end

local function UpdateAffixes( self)
	if designed then return end
	if self.WeeklyInfo.Child.RunStatus then
		self.WeeklyInfo.Child.RunStatus:SetFont( yo.font, yo.fontsize + 2, "OUTLINE")
		self.WeeklyInfo.Child.RunStatus:ClearAllPoints()
		self.WeeklyInfo.Child.RunStatus:SetPoint("TOP", self, "TOP", 0, -150)
		self.WeeklyInfo.Child.RunStatus:SetWidth( 250)
		self.WeeklyInfo.Child.RunStatus.ClearAllPoints = dummy
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
			seasonAffix:SetFont( yo.font, yo.fontsize +2, "OUTLINE")
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
			weekReward:SetFont( yo.font, yo.fontsize +9, "OUTLINE")
			weekReward:SetTextColor( 1, 0, 0)
			weekReward:SetJustifyH("LEFT")
			weekReward:SetPoint("LEFT", self.WeeklyInfo.Child.Label, "RIGHT", 5, 0)
			self.weekReward = weekReward
		end

		self.weekReward:SetText( self.WeeklyInfo.Child.WeeklyChest.ownedKeystoneLevel)
    end

    designed = true
	CreateLiders( self)
	skinDungens()
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
	local frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetSize( (iSize + 10) * affCount, (iSize + 7) * rowCount + 50 + 120)
	frame:SetPoint("TOPRIGHT", ChallengesFrame.WeeklyInfo.Child, "TOPRIGHT", -6, -15)

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetAtlas("ChallengeMode-guild-background")
	bg:SetAlpha( .4)
	frame.bg = bg

	local title = frame:CreateFontString(nil, "ARTWORK")--, "GameFontNormalMed1")
	title:SetFont( yo.font, yo.fontsize + 3, "OUTLINE")
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
	Levels:SetFont( yo.font, yo.fontsize + 3, "OUTLINE")
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
	title2:SetFont( yo.font, yo.fontsize + 3, "OUTLINE")
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
	rewards:SetFont( yo.font, yo.fontsize, "OUTLINE")
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
	ChallengesFrame.Frame = frame

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

local function OnEvent( self, event, name, sender, ...)
	--print ( "Load: " .. event, self:GetName(), name, sender, ...)
	if event == "ADDON_LOADED" and name == "Blizzard_ChallengesUI" then
		Blizzard_ChallengesUI( self)
		ChallengesKeystoneFrame:HookScript("OnShow", SlotKeystone)
	end
end


local logan = CreateFrame("Frame", nil, UIParent)
logan:RegisterEvent("ADDON_LOADED")
logan:SetScript("OnEvent", OnEvent)
