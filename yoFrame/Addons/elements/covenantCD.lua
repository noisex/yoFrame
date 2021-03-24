local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.covenantsCD then return end

----------------------------------------------------------------------------------------
--	Raid cooldowns(alcovenCD by Allez)
----------------------------------------------------------------------------------------
local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch, band
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch, bit.band

local GetSpellInfo, GameTooltip, CreateFrame, CreateStyle, UnitClass, GetTime, UnitInRaid, SendChatMessage, GetNumGroupMembers, CombatLogGetCurrentEventInfo, tinsert, table_sort, RAID_CLASS_COLORS, UnitExists
	= GetSpellInfo, GameTooltip, CreateFrame, CreateStyle, UnitClass, GetTime, UnitInRaid, SendChatMessage, GetNumGroupMembers, CombatLogGetCurrentEventInfo, tinsert, table.sort, RAID_CLASS_COLORS, UnitExists

local filter 	= COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local tc 		= n.Addons.torgastClicks
local mf 		= n.Addons.moveFrames
local spellArray= {}
local barsNum 	= 6
local barsHalf	= floor( barsNum / 2 + 0.5)

local covenCD 	= CreateFrame("Frame", "yo_covenCD", UIParent)
covenCD:SetSize(186 + 32, 20)
covenCD.barsFrame = {}
covenCD.bars 	  = {}

n.Addons.covenantCD = covenCD

local function spellPrepare(...)
	for spellID, value in pairs( n.raidCoveSpellsCD) do
		local spell, _, icon = GetSpellInfo(spellID)
		spellArray[spellID] = { spell = spell, icon = icon}
	end
end

local FormatTime = function(time)
	if time >= 60 then
		return format("%.2d:%.2d", floor(time / 60), time  %60)
	else
		return format("%.2d", time)
	end
end

local CreateFS = function(frame, font, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont( font or n.font, fsize or n.fontsize -1, "OUTLINE")
	fstring:SetShadowOffset(1 and 1 or 0, 1 and -1 or 0)
	return fstring
end

local function updatePositions( self)
	local index, barSort = 1, {}

	for k in pairs( self.bars) do tinsert( barSort, k) end
	table_sort( barSort)

	for i, key in pairs( barSort) do
		if ( #barSort < barsNum) or (  i <= barsHalf or i >= #barSort -1 ) then
			local bars = self.bars[key]
			local bar = covenCD.createBar( self, index)
			bar.tick 		= 1
			bar.name 		= bars.name
			bar.endTime 	= bars.endTime
			bar.startTime 	= bars.startTime
			bar.spell 		= bars.spell
			bar.left:SetText( bars.left)
			bar.right:SetText( bars.right)
			bar.icon:SetNormalTexture( bars.icon)
			bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			bar:SetStatusBarColor(bars.color.r, bars.color.g, bars.color.b)
			bar.bg:SetVertexColor(bars.color.r, bars.color.g, bars.color.b, 0.25)
			bar:EnableMouse(true)
			bar:SetScript("OnUpdate", covenCD.barUpdate)

			bar:Show()
			index = index + 1
		end
	end

	for i = index, #self.barsFrame do self.barsFrame[i]:Hide() end
end

local StopTimer = function(self, bar)
	if not bar then return end

	bar:SetScript("OnUpdate", nil)
	self.bars[bar.endTime] = nil
	updatePositions( self)

end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.spell, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if GetNumGroupMembers() > 5 then
			SendChatMessage( format("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
		elseif GetNumGroupMembers() > 0 and not UnitInRaid("player") then
			SendChatMessage( format("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
		else
			SendChatMessage( format("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer( self:GetParent(), self)
	end
end

covenCD.barUpdate = function(self, elapsed)
	self.tick = self.tick + elapsed
	if self.tick < 0.07 then return end
	self.tick = 0

	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer( self:GetParent(), self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

covenCD.createBar = function( self, index)

	if self.barsFrame[index] then return self.barsFrame[index] end

	local bar = CreateFrame("Statusbar", nil, self)
	bar.index = index
	bar:SetSize(186 + 28, 20)
	bar:SetStatusBarTexture( n.texture)
	bar:SetMinMaxValues(0, 100)
	bar:Hide()
	CreateStyle(bar, 3)

	if index == 1 then
		bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
	else
		bar:SetPoint("TOPLEFT", self.barsFrame[index -1], "BOTTOMLEFT", 0, -7)
	end

	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints( bar)
	bar.bg:SetTexture( n.texture)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(186 - 10, 20)

	bar.right = CreateFS(bar, n.fontpx, n.fontsize + 6)
	bar.right:SetPoint("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")
	bar.right:SetTextColor( 0.8, 0.8, 0.2, 1)

	bar.icon = CreateFrame( "Button", nil, bar)
	bar.icon:SetWidth( bar:GetHeight())
	bar.icon:SetHeight( bar:GetHeight())
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
	CreateStyle(bar.icon, 3)

	self.barsFrame[index] = bar

	return self.barsFrame[index]
end

local StartTimer = function(self, name, spellId)

	for k, bar in pairs(self.bars) do
		if bar.name == name then
			StopTimer( self, bar)
		end
	end

	--local spell, _, icon = GetSpellInfo(spellId)
	local color   = RAID_CLASS_COLORS[select(2, UnitClass(name))] or { 0.3, 0.7, 0.3}
	local gt 	  = GetTime()
	local endTime = gt + n.raidCoveSpellsCD[spellId]

	self.bars[endTime] = {
		["spell"] 	= spellArray[spellId].spell,
		["endTime"] = endTime,
		["startTime"] = gt,
		["icon"] 	= spellArray[spellId].icon,
		["name"] 	= name,
		["left"] 	= strsplit("-", name) .. " - " .. spellArray[spellId].spell,
		["right"] 	= FormatTime(n.raidCoveSpellsCD[spellId]),
		["color"]	= color,
	}

	updatePositions( self)
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, _, sourceName, sourceFlags, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo ()

		if band(sourceFlags, filter) == 0 then return end

		if n.raidCoveSpellsCD[spellId] and eventType == "SPELL_CAST_SUCCESS" then --and show[select(2, IsInInstance())] then
			StartTimer( self, strsplit( "-", sourceName), spellId)
		end

	elseif event == "CHALLENGE_MODE_START" then
		for k, bar in pairs(self.bars) do	StopTimer( self, bar)	end

	elseif event == "GROUP_ROSTER_UPDATE" then

		if UnitExists("party1")	and not n.Addons.torgastClicks.inTorghast and not UnitInRaid("player") then
			if not self.reged then
				for k, bar in pairs(self.bars) do StopTimer( self, bar)	end
				self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				self.reged = true
			end
		else
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self.reged = false
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		self:ClearAllPoints()
		self:SetPoint("BOTTOM", mf.yoMoveCovenCD)
		spellPrepare()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

n.moveCreateAnchor("yoMoveCovenCD", "Move Covenanat Party CD", 230, 150, 27, 73, "LEFT", "LEFT")

covenCD:RegisterEvent("PLAYER_ENTERING_WORLD")
covenCD:RegisterEvent("CHALLENGE_MODE_START")
covenCD:RegisterEvent("GROUP_ROSTER_UPDATE")

covenCD:SetScript("OnEvent", OnEvent)
