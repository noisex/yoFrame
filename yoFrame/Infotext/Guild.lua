local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)
--------------------------------------------------------------------
-- GUILD ROSTER
--------------------------------------------------------------------
function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end
function ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

-- localized references for global functions (about 50 %faster)
local join 			= string.join
local format		= string.format
local find			= string.find
local gsub			= string.gsub
local sort			= table.sort
local ceil			= math.ceil

local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local displayString = GUILD ..": ".. n.myColorStr .. "%d|r"
local noGuildString = n.myColorStr .. "No Guild"
local guildInfoString = "%s [%d]"
local guildInfoString2 = GUILD .. ": %d/%d"
local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
local nameRankString = "%s |cff999999-|cffffffff %s"
local guildXpCurrentString = gsub( RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b).. GUILD_EXPERIENCE_CURRENT,": ", ":|r |cffffffff", 1)
local guildXpDailyString = gsub( RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)..GUILD_EXPERIENCE_DAILY, ": ", ":|r |cffffffff", 1)
local standingString = RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b).. "%s:|r |cFFFFFFFF%s/%s (%s%%)"
local moreMembersOnlineString = "+ %d ".. FRIENDS_LIST_ONLINE.. "..."
local noteString = "|cff999999   ".. LABEL_NOTE.. ":|r %s"
local officerNoteString = "|cff999999   ".. GUILD_RANK1_DESC.. ":|r %s"
local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
local guildTable, guildXP, guildMotD = {}, {}, ""
local totalOnline = 0


local function BuildGuildTable()
	totalOnline = 0
	wipe(guildTable)
	local name, rank, level, zone, note, officernote, connected, status, class
	for i = 1, GetNumGuildMembers() do
		name, rank, rankIndex, level, _, zone, note, officernote, connected, status, class = GetGuildRosterInfo(i)
		name = string.gsub(name, "-.*", "")
		-- we are only interested in online members

		if status == 1 then
			status = "|cffFFFFFF[|r|cffFF0000"..'AFK'.."|r|cffFFFFFF]|r"
		elseif status == 2 then
			status = "|cffFFFFFF[|r|cffFF0000"..'DND'.."|r|cffFFFFFF]|r"
		else
			status = '';
		end

		guildTable[i] = { name, rank, level, zone, note, officernote, connected, status, class, rankIndex }
		if connected then totalOnline = totalOnline + 1 end
	end
	table.sort(guildTable, function(a, b)
		if a and b then
			return a[1] < b[1]
		end
	end)
end

local function UpdateGuildXP()
	local currentXP, remainingXP = UnitGetGuildXP("player")
	local nextLevelXP = currentXP + remainingXP

	if nextLevelXP == 0 or maxDailyXP == 0 then return end

	local percentTotal = tostring(math.ceil((currentXP / nextLevelXP) * 100))

	guildXP[0] = { currentXP, nextLevelXP, percentTotal }
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = OPTIONS_MENU, isTitle = true, notCheckable=true},
	{ text = INVITE, hasArrow = true, notCheckable=true,},
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true, notCheckable=true,}
}

local function inviteClick(self, arg1, arg2, checked)
	menuFrame:Hide()
	C_PartyInfo.InviteUnit(arg1)
end

local function whisperClick(self,arg1,arg2,checked)
	menuFrame:Hide()
	SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
end

function Stat:onMouseDown( btn)
 	if btn == "LeftButton" then
 		ToggleGuildFrame()
 		return
 	end

	if not IsInGuild() then return end
	if InCombatLockdown() then return end

	GameTooltip:Hide()

	local classc, levelc, grouped
	local menuCountWhispers = 0
	local menuCountInvites = 0

	menuList[2].menuList = {}
	menuList[3].menuList = {}

	for i = 1, #guildTable do
		if (guildTable[i][7] and (guildTable[i][1] ~= UnitName("player") and guildTable[i][1] ~= UnitName("player").."-"..GetRealmName())) then
			local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

			if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
				grouped = "|cffaaaaaa*|r"
			else
				grouped = ""
				if not guildTable[i][11] then
					menuCountInvites = menuCountInvites + 1
					menuList[2].menuList[menuCountInvites] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], ""), arg1 = guildTable[i][1],notCheckable=true, func = inviteClick}
				end
			end
			menuCountWhispers = menuCountWhispers + 1
			menuList[3].menuList[menuCountWhispers] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
		end
	end

	EasyMenu(menuList, menuFrame, "cursor", -50, 100, "MENU", 2)
end

Stat.ShowGuild = function(self, btn, obj)
	local menuWIM = {
		{ text = "Гильдейский шептун", isTitle = true, notCheckable=true},
	}

	GameTooltip:Hide()

	BuildGuildTable()

	local classc, levelc, grouped
	local menuCountWhispers = 1

	for i = 1, #guildTable do
		if (guildTable[i][7] and (guildTable[i][1] ~= UnitName("player") and guildTable[i][1] ~= UnitName("player").."-"..GetRealmName())) then
			local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

			if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
				grouped = "|cffaaaaaa*|r"
			else
				grouped = ""
			end

			menuCountWhispers = menuCountWhispers + 1
			menuWIM[menuCountWhispers] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
		end
	end

	EasyMenu(menuWIM, menuFrame, obj, 25, 50, "MENU", 2)
end


function Stat:onEnter()

 	if not IsInGuild() then return end

	C_GuildInfo.GuildRoster()
	UpdateGuildMessage()
	BuildGuildTable()

	local name, rank, level, zone, note, officernote, connected, status, class, isMobile
	local zonec, classc, levelc
	local online = totalOnline
	local GuildInfo, GuildRank, GuildLevel = GetGuildInfo("player")

	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(format(guildInfoString, GuildInfo, GuildLevel), format(guildInfoString2, online, #guildTable),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
	GameTooltip:AddLine(GuildRank, unpack(tthead))
	GameTooltip:AddLine(' ')

	if guildMotD ~= "" then GameTooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) end

	local col = RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
	--GameTooltip:AddLine(' ')
	if GuildInfo and GuildLevel then
		if guildXP[0] then
			local currentXP, nextLevelXP, percentTotal = unpack(guildXP[0])

			GameTooltip:AddLine(format(guildXpCurrentString, ShortValue(currentXP), ShortValue(nextLevelXP), percentTotal))
		end
	end

	local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
	if standingID ~= 8 then -- Not Max Rep
		barMax = barMax - barMin
		barValue = barValue - barMin
		barMin = 0
		GameTooltip:AddLine(format(standingString, COMBAT_FACTION_CHANGE, ShortValue(barValue), ShortValue(barMax), ceil((barValue / barMax) * 100)))
	end

	if online > 1 then
		local Count = 0

	--GameTooltip:AddLine(' ')
	for i = 1, #guildTable do
			if online <= 1 then
				break
			end

			name, rank, level, zone, note, officernote, connected, status, class = unpack(guildTable[i])

			if connected and name ~= UnitName("player") then
				if 80 - Count <= 1 then
			if online - 30 > 1 then GameTooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b) end
				end

				if GetRealZoneText() == zone then zonec = activezone else zonec = inactivezone end
				classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)

				if isMobile then zone = "" end

				if IsShiftKeyDown() then
					GameTooltip:AddDoubleLine(string.format(nameRankString, name, rank), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
					if note ~= "" then GameTooltip:AddLine(string.format(noteString, note), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
					if officernote ~= "" then GameTooltip:AddLine(string.format(officerNoteString, officernote), ttoff.r, ttoff.g, ttoff.b ,1) end
				else
					GameTooltip:AddDoubleLine(string.format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
				end

				Count = Count + 1
			end
		end
	end

	GameTooltip:Show()
end

function Stat:onEvent( event, ...)

	if not GuildFrame and IsInGuild() then
		LoadAddOn("Blizzard_GuildUI")
		C_GuildInfo.GuildRoster()
	end

	if (not IsInGuild()) then
		self.Text:SetText(noGuildString) -- I need a string :(

		return
	end

	C_GuildInfo.GuildRoster() -- Bux Fix on 5.4.
	local _, online = GetNumGuildMembers()
	self.Text:SetFormattedText(displayString, online)
end


function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)

	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	--Stat:RegisterEvent("GUILD_ROSTER_SHOW")
	--Stat:RegisterEvent("GUILD_XP_UPDATE")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")
	self:RegisterEvent("GUILD_MOTD")
	self:RegisterEvent("CHAT_MSG_SYSTEM")

	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", self.onEnter)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onMouseDown)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( n.font, n.fontsize, "OVERLAY")
	--self.Text:SetFormattedText( infoText.displayString, "dps", 0,  SecondsToClocks( self.combatTime))
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

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

infoText.infos.guild 		= Stat
infoText.infos.guild.name 	= "Guild"

infoText.texts.guild = "Guild"
--Stat.index = 3
--Stat:Enable()