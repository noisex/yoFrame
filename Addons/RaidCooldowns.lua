----------------------------------------------------------------------------------------
--	Raid cooldowns(alRaidCD by Allez)
----------------------------------------------------------------------------------------
local show = {
	raid = true,
	party = true,
--	arena = true,
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}

CreateAnchor("yo_MoveRaidCD", "Move RaidCD", 230, 150, 30, 150, "LEFT", "LEFT")

local RaidCDAnchor = CreateFrame("Frame", "yo_RaidCD", UIParent)
RaidCDAnchor:SetPoint("BOTTOM", "yo_MoveRaidCD")
RaidCDAnchor:SetSize(186 + 32, 20)

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont( font, fontsize -1, "OUTLINE")
	--fstring:SetShadowOffset(1 and 1 or 0, 1 and -1 or 0)
	return fstring
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("BOTTOMRIGHT", RaidCDAnchor, "BOTTOMRIGHT", -2, 2)
		else
			bars[i]:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, 5)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
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
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
		elseif GetNumGroupMembers() > 0 and not UnitInRaid("player") then
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
		else
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("HIGH")
	bar:SetSize(186 + 28, 20)
	
	bar:SetStatusBarTexture( texture)
	bar:SetMinMaxValues(0, 100)

	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(bar.backdrop, 2)
	bar.backdrop:SetFrameStrata("BACKGROUND")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints( bar)
	bar.bg:SetTexture( texture)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(186 - 30, 20)

	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetWidth(bar:GetHeight())
	bar.icon:SetHeight(bar.icon:GetWidth())
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)

	bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
	bar.icon.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.icon.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(bar.icon.backdrop, 2)
	bar.icon.backdrop:SetFrameStrata("BACKGROUND")
	
	return bar
end

local StartTimer = function(name, spellId)
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + raid_spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText( strsplit("-", name) .. " - " .. spell)
	bar.right:SetText(FormatTime(raid_spells[spellId]))
	bar.icon:SetNormalTexture( icon)
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	bar.spell = spell
	bar:Show()
	local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	if color then
		--print( color.r, color.g, color.b)
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar.bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
		bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.25)
	end
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		--print( CombatLogGetCurrentEventInfo ())
		local _, eventType, _, _, sourceName, sourceFlags, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo ()

		if band(sourceFlags, filter) == 0 then return end
		
		if raid_spells[spellId] and eventType == "SPELL_CAST_SUCCESS" then --and show[select(2, IsInInstance())] then
			StartTimer( strsplit( "-", sourceName), spellId)
		end
	
	elseif event == "CHALLENGE_MODE_START" then
		for k, v in pairs(bars) do	StopTimer(v)	end
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	elseif event == "CHALLENGE_MODE_COMPLETED" then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	else
		if not yo["Addons"].RaidCoolDowns then 
			self:UnregisterAllEvents()
			self:SetScript("OnMouseDown", nil)
			self:SetScript("OnEnter", nil)
			self:SetScript("OnLeave", nil)
			self:SetScript("OnEvent", nil)
			self:SetScript("OnUpdate", nil)
			bar = nil
		return
	end
	
	end
end

local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", OnEvent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("CHALLENGE_MODE_COMPLETED")
addon:RegisterEvent("CHALLENGE_MODE_START")
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

--GetInstanceInfo
--https://wow.gamepedia.com/API_GetInstanceInfo
--DifficultyID
--https://wow.gamepedia.com/DifficultyID