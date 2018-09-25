
local function GetXP(unit)
	return UnitXP(unit), UnitXPMax(unit)
end

local function SetTooltip(self)
	local unit = "player"
	local min, max = GetXP( unit)

	local bars = 20

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -5)
	GameTooltip:AddLine(COMBAT_XP_GAIN.." "..format(LEVEL_GAINED, UnitLevel("player")))
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(string.format("|cff00ff96Осталось: %s ( %d%% - %d/%d)", commav( max - min), (max - min) / max * 100, 1 + bars * (max - min) / max, bars))
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(string.format("Собрано: %s ( %d%% - %d/%d)", commav(min, min / max * 100), (min) / max * 100, bars - (bars * (max - min) / max), bars))
	GameTooltip:AddLine(string.format("|c008250ffВсего: %s", commav( max)))

	if(self.rested) then
		GameTooltip:AddLine(string.format("|cff0090ffОтдых: +%d ( %d%%)", self.rested, self.rested / max * 100))
	end

	GameTooltip:Show()
end

local function UpdateExp(self, event, owner)
	--print( "UpdateExp: ", self, event, owner)
	
	local experience = self --.Experience
	-- Conditional hiding
	if(UnitLevel('player') == MAX_PLAYER_LEVEL) then
		return experience:Hide()
	end

	local unit = "player"
	local min, max = GetXP(unit)
	experience:SetMinMaxValues(0, max)
	experience:SetValue(min)
	experience:Show()

	if(experience.Text) then
		experience.Text:SetFormattedText('%d / %d', min, max)
	end

	if(experience.Rested) then
		local rested = GetXPExhaustion()
		if(unit == 'player' and rested and rested > 0) then
			experience.Rested:SetMinMaxValues(0, max)
			experience.Rested:SetValue(math.min(min + rested, max))
			experience.rested = rested
		else
			experience.Rested:SetMinMaxValues(0, 1)
			experience.Rested:SetValue(0)
			experience.rested = nil
		end
	end

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

	element:RegisterEvent('PLAYER_XP_UPDATE')
	element:RegisterEvent('PLAYER_LEVEL_UP')
	element:RegisterEvent('UNIT_PET')
		
	if(element.Rested) then
		element:RegisterEvent('UPDATE_EXHAUSTION')
	end
	
	element:SetScript("OnEvent", UpdateExp)
	
	UpdateExp( element)
	return true
end

local function Experience( f)
	if not f then return end
	local Experience = CreateFrame('StatusBar', nil, f)
	Experience:SetStatusBarTexture( texture)
	Experience:SetPoint('CENTER', yo_MoveExperience, 'CENTER', 0, 0)
	Experience:SetStatusBarColor(.901, .8, .601)
	Experience:EnableMouse(true)
	Experience:SetWidth(6)
	Experience:SetHeight(168)
	Experience:SetOrientation("VERTICAL")
	Experience:SetFrameLevel(3)

	Experience.Rested = CreateFrame('StatusBar', nil, f)
	Experience.Rested:SetStatusBarTexture( texture)
	Experience.Rested:SetPoint('CENTER', yo_MoveExperience, 'CENTER', 0, 0)
	Experience.Rested:SetStatusBarColor( 0, 0.5, 1, 0.4)
	Experience.Rested:SetWidth(6)
	Experience.Rested:SetHeight(168)
	Experience.Rested:SetOrientation("VERTICAL")
	Experience.Rested:SetFrameLevel(4)
	
	local h = CreateFrame("Frame", nil, Experience)
	h:SetFrameLevel(1)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)

	f.Experience = Experience
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if (UnitLevel('player') == MAX_PLAYER_LEVEL) then return end  -- not yo["Addons"].Experience or
	
	Experience( plFrame)
	EnableExp( plFrame)
end)
