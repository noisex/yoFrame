local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.ArtifactPowerbar then return end

local yoUF = n.Addons.unitFrames

local function GetXP(unit)
	return UnitXP(unit), UnitXPMax(unit)

end

local function SetTooltip(self)
	local unit = "player"

	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, self.tooltipAnchor) -- 'ANCHOR_CURSOR', 0, -5)

	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()

	if factionID and C_Reputation.IsFactionParagon( factionID) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo( factionID)
		if currentValue and threshold then
			min, max = 0, threshold
			value = currentValue  %threshold
			if hasRewardPending then
				value = value + threshold
			end
		end
	end

	if name then
		local friendID, friendTextLevel, _
		if factionID then friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID) end
		local backupColor = FACTION_BAR_COLORS[1]
		local color = FACTION_BAR_COLORS[reaction] or backupColor

		GameTooltip:AddLine(name)
		GameTooltip:AddDoubleLine(STANDING..':', (friendID and friendTextLevel) or _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1, color.r, color.g, color.b)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L["Left"], format('%s (%d%%)', nums( max - value), (max - value) / ((max - min == 0) and max or (max - min)) * 100), 1, 1, 1, 0, 1, 0)
		GameTooltip:AddDoubleLine(REPUTATION..':', format('%s / %s', nums( value - min), nums( max - min)), 1, 1, 1, 0, 1, 1)
	end

	GameTooltip:Show()
end

local function UpdateExp(self, event, unit)
	local bar = self  --.Experience
	if(not GetWatchedFactionInfo()) then return bar:Hide() end

	local ID, isFriend, friendText, standingLabel
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()

	if factionID and C_Reputation.IsFactionParagon(factionID) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		if currentValue and threshold then
			min, max = 0, threshold
			value = currentValue  %threshold
			if hasRewardPending then
				value = value + threshold
			end
		end
	end

	--local backupColor = FACTION_BAR_COLORS[1]
	--local color = FACTION_BAR_COLORS[reaction] or backupColor
	--bar:SetStatusBarColor(color.r, color.g, color.b)
	local perc
	if value ~= max then
		perc = ( abs(value) - abs(min)) / ( abs(max) - abs(min))
	else
		perc = 1
	end

	bar:SetStatusBarColor( 1 - perc, 0 + perc, 0, 0.7)

	bar:SetMinMaxValues(min, max)
	bar:SetValue(value)
	bar:Show()
end

local function EnableExp( self)
	unit = self.unit
	local element = self.Experience
	if (not element or unit ~= "player") then return end

	if (not element:GetStatusBarTexture()) then
		element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		element:SetStatusBarColor(.901, .8, .601)
	end

	if (element:IsMouseEnabled()) then
		element.onAlpha = element.onAlpha or 1
		element.offAlpha = element.offAlpha or 1
		element:SetAlpha(element.offAlpha)

		element:HookScript('OnLeave', GameTooltip_Hide)
		element:HookScript('OnEnter', SetTooltip)
--		element:SetScript("OnLeave", element.OnLeave or HideTooltip)
	end

	element:RegisterEvent('UPDATE_FACTION')
	element:SetScript("OnEvent", UpdateExp)

	UpdateExp( element)
	return true
end

local function Experience( f)
	if not f then return end
	local Experience = CreateFrame('StatusBar', nil, f)
	Experience:SetStatusBarTexture( n.texture)
	Experience:SetPoint('CENTER', yoMoveExperience, 'CENTER', 0, 0)
	Experience:SetStatusBarColor(.901, .8, .601)
	Experience:EnableMouse(true)
	Experience:SetSize( yoMoveExperience:GetSize())
	Experience:SetOrientation("VERTICAL")
	Experience:SetFrameLevel(3)
	table.insert( n.Addons.elements.statusBars, Experience)
	CreateStyle(Experience, 3)

	f.Experience = Experience
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	if not yo.Addons.ArtifactPowerbar  or not yoUF.player then return end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if (UnitLevel('player') ~= MAX_PLAYER_LEVEL) then return end  -- not yo["Addons"].Experience or

	Experience( yoUF.player)
	EnableExp( yoUF.player)
end)
