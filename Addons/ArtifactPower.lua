local addonName, ns = ...
local L = ns.L

----------------------------------------------------------------------------------------
--	Based on oUF_ArtifactPower(by Rainrider)
----------------------------------------------------------------------------------------

local function ShowTooltip(element)
	element:SetAlpha(element.onAlpha)
	GameTooltip:SetOwner(element)
	GameTooltip:SetText(element.name, HIGHLIGHT_FONT_COLOR:GetRGB())
	GameTooltip:AddLine( L["LEVEL"]  .. element.traitsLearned)
	--GameTooltip:AddLine("")
	GameTooltip:AddLine( "|cff00ff96" .. L["Left"] .. commav(element.powerForNextTrait - element.power) .. "|r\n\n|cff0090ff" .. L["Collected"] .. commav( element.totalPower) .. "|r\n|c008250ff" .. L["Totals"] .. commav( element.powerForNextTrait) .. "|r")
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine( L["CANLEARN"] .." |cff00ff96" .. element.numTraitsLearnable .. "|r "..L["features"])
	GameTooltip:Show()
end

local function HideTooltip(element)
	element:SetAlpha(element.offAlpha)
	GameTooltip_Hide()
end

local function UpdateAP(self, ...)
	--print( "UpdateAP: ", self, ...)
	local element = self   ---.ArtifactPower

	local show = HasArtifactEquipped() and not UnitHasVehicleUI("player")
	if (show) then
		local _, _, name, _, totalPower, traitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
		local numTraitsLearnable, power, powerForNextTrait = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(traitsLearned, totalPower, tier)
		
		--print( "UpdateAP: ", name, powerForNextTrait, power)
		element:SetMinMaxValues(0, powerForNextTrait)
		element:SetValue(power)

		element.name = name
		element.power = power
		element.powerForNextTrait = powerForNextTrait
		element.totalPower = totalPower
		element.numTraitsLearnable = numTraitsLearnable
		element.traitsLearned = traitsLearned
		element.tier = tier

		element:Show()
	else
		element:Hide()
	end
end

local function EnableAP(self)
	unit = self.unit
	local element = self.ArtifactPower
	if (not element or unit ~= "player") then return end

	--element.__owner = self

	if (not element:GetStatusBarTexture()) then
		element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]]) 
		element:SetStatusBarColor(.901, .8, .601)
	end

	if (element:IsMouseEnabled()) then
		element.onAlpha = element.onAlpha or 1
		element.offAlpha = element.offAlpha or 1
		element:SetAlpha(element.offAlpha)
		element:SetScript("OnEnter", element.OnEnter or ShowTooltip)
		element:SetScript("OnLeave", element.OnLeave or HideTooltip)
	end

	element:RegisterEvent("ARTIFACT_XP_UPDATE")
	element:RegisterEvent("UNIT_INVENTORY_CHANGED")
	element:SetScript("OnEvent", UpdateAP)
	
	UpdateAP( element)
	return true
end

local function ArtifactPower( f)
	if not f then return end
	local ArtifactPower = CreateFrame('StatusBar', nil, f)
	ArtifactPower:SetStatusBarTexture( texture)
	ArtifactPower:SetPoint('CENTER', yo_MoveArtifact, 'CENTER', 0, 0)
	ArtifactPower:SetStatusBarColor(.901, .8, .601)
	ArtifactPower:EnableMouse(true)
	ArtifactPower:SetWidth(6)
	ArtifactPower:SetHeight(168)
	ArtifactPower:SetOrientation("VERTICAL")
	ArtifactPower:SetFrameLevel(2)

	local h = CreateFrame("Frame", nil, ArtifactPower)
	h:SetFrameLevel(1)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)

	f.ArtifactPower = ArtifactPower
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.ArtifactPowerbar then return end
	
	ArtifactPower( plFrame)
	EnableAP( plFrame)
end)
