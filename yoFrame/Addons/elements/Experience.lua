
local L, yo, n = unpack( select( 2, ...))

local yoUF = n.Addons.unitFrames

local function GetXP(unit)
	return UnitXP(unit), UnitXPMax(unit)
end

local function SetTooltip(self)
	local unit = "player"
	local min, max = GetXP( unit)

	--local bars = 20

	GameTooltip:SetOwner(self, self.tooltipAnchor) --'ANCHOR_BOTTOM', 0, -5)
	GameTooltip:AddLine(COMBAT_XP_GAIN.." "..format(LEVEL_GAINED, UnitLevel("player")))
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["Left"], "|cff00ff00" .. nums( max - min) .. " ( " .. floor((max - min) / max * 100 + 0.5) .. "%)")
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine( L["Collected"], "|cff00ff96" .. nums(min, min / max * 100) .. " ( " .. floor((min) / max * 100 + 0.5) .. "%)")

	if(self.rested) then
		GameTooltip:AddDoubleLine( L["Rest"], "|cff0090ff" .. nums( self.rested) .. " ( " .. floor( self.rested / max * 100 + .5).. "%)")
	end

	GameTooltip:AddDoubleLine(L["Totals"],  nums( max))
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
	local perc = min / max

	experience:SetStatusBarColor( 1 - perc, 0 + perc, 0, 0.9)
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
	Experience:SetStatusBarTexture( n.texture)
	Experience:SetPoint('CENTER', yoMoveExperience, 'CENTER', 0, 0)
	Experience:SetStatusBarColor(.901, .8, .601)
	Experience:EnableMouse(true)
	Experience:SetSize( yoMoveExperience:GetSize())
	Experience:SetOrientation("VERTICAL")
	Experience:SetFrameLevel(3)
	table.insert( n.Addons.elements.statusBars, Experience)

	Experience.Rested = CreateFrame('StatusBar', nil, f)
	Experience.Rested:SetStatusBarTexture( n.texture)
	Experience.Rested:SetPoint('CENTER', Experience, 'CENTER', 0, 0)
	--Experience.Rested:SetPoint('TOPLEFT', Experience, 'TOPLEFT', 0, 0)
	--Experience.Rested:SetPoint('BOTTOMRIGHT', Experience:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	Experience.Rested:SetStatusBarColor( 0, 1, 1, 0.2)
	Experience.Rested:SetSize( Experience:GetSize())
	Experience.Rested:SetOrientation("VERTICAL")
	Experience.Rested:SetFrameLevel(2)
	table.insert( n.Addons.elements.statusBars, Experience.Rested)
	CreateStyle( Experience, 3)

	f.Experience = Experience
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if (UnitLevel('player') == MAX_PLAYER_LEVEL) then return end  -- not yo["Addons"].Experience or

	Experience( yoUF.player)
	EnableExp( yoUF.player)
end)
