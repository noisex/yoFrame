local L, yo, N = unpack( select( 2, ...))


if not yo.Addons.ArtifactPowerbar then return end

----------------------------------------------------------------------------------------
--	Based on oUF_ArtifactPower(by Rainrider)
----------------------------------------------------------------------------------------
n.moveCreateAnchor("yoMoveArtifact", 	"Move Artifact", 7, 173, 5, -1, "TOPLEFT", "TOPRIGHT", LeftDataPanel)

local function ShowTooltip(element)
	element:SetAlpha(element.onAlpha)

	if (azeriteItemLocation) then
		local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
		ItemDataLoadedCancelFunc = azeriteItem:ContinueWithCancelOnItemLoad(function()
			GameTooltip:SetOwner(element, element.tooltipAnchor)
			--GameTooltip:SetText(AZERITE_POWER_TOOLTIP_TITLE:format(element.level, element.max - element.current), HIGHLIGHT_FONT_COLOR:GetRGB())
			--GameTooltip:AddLine(AZERITE_POWER_TOOLTIP_BODY:format(azeriteItem:GetItemName()))
			GameTooltip:AddDoubleLine( azeriteItem:GetItemName(), "|cff00ffff" .. element.level )
			GameTooltip:AddLine( " ")
			GameTooltip:AddDoubleLine( L["Left"], "|cff00ff00" .. nums( element.max - element.current) .. "|r (" .. floor( ( element.max - element.current) / element.max * 100 + .5) .. "%)")
			GameTooltip:AddDoubleLine( L["Collected"],	"|cff00ffff" .. nums( element.current ) .. "|r (" .. floor( element.current / element.max * 100 + .5) .. "%)")
			GameTooltip:AddDoubleLine( L["Totals"], nums( element.max ))
			GameTooltip:Show()
		end)
	elseif (HasArtifactEquipped()) then
		local _, _, name = C_ArtifactUI.GetEquippedArtifactInfo()
		GameTooltip:SetOwner(element, element.tooltipAnchor)
		GameTooltip:SetText(name, HIGHLIGHT_FONT_COLOR:GetRGB())
		GameTooltip:AddLine(
			ARTIFACT_POWER_TOOLTIP_TITLE:format(
				ShortValue(element.unspentPower),
				ShortValue(element.current),
				ShortValue(element.max)
			),
			nil, nil, nil, true
		)
		GameTooltip:AddLine(ARTIFACT_POWER_TOOLTIP_BODY:format(element.numTraitsLearnable), nil, nil, nil, true)
		GameTooltip:Show()
	end
end

local function HideTooltip(element)
	element:SetAlpha(element.offAlpha)
	GameTooltip_Hide()
end

local function GetNumTraitsLearnable(numTraitsLearned, power, tier)
	local numPoints = 0;
	local powerForNextTrait = C_ArtifactUI.GetCostForPointAtRank(numTraitsLearned, tier)
	while power >= powerForNextTrait and powerForNextTrait > 0 do
		power = power - powerForNextTrait

		numTraitsLearned = numTraitsLearned + 1
		numPoints = numPoints + 1

		powerForNextTrait = C_ArtifactUI.GetCostForPointAtRank(numTraitsLearned, tier)
	end
	return numPoints, power, powerForNextTrait
end

local function UpdateAP(self, ...)
	--print( "UpdateAP: ", self, ...)
	local element = self   ---.ArtifactPower
	local current, level, show, cmax, isUsable

	if (not UnitHasVehicleUI('player')) then
		azeriteItemLocation = C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem()
		if (azeriteItemLocation) then
			current, cmax = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
			level = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
			show = true
		elseif (HasArtifactEquipped()) then
			local _, _, _, _, unspentPower, numTraitsLearned, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
			local numTraitsLearnable, power, powerForNextTrait = GetNumTraitsLearnable(numTraitsLearned, unspentPower, tier)
			current = power
			cmax = powerForNextTrait
			level = numTraitsLearnable + numTraitsLearned
			isUsable = not GetInventoryItemEquippedUnusable('player', INVSLOT_MAINHAND)

			element.numTraitsLearnable = numTraitsLearnable
			element.unspentPower = unspentPower
			show = true
		end
	end

	element.current = current
	element.max = cmax
	element.level = level

	if (show) then
		local perc = current / cmax
		element:SetStatusBarColor( 1 - perc, 0 + perc, 0, 0.7)
		element:SetMinMaxValues(0, cmax)
		element:SetValue(current)
		element:Show()
	else
		element:Hide()
	end
end

local function EnableAP(self)
	local unit = self.unit
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

	element:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")
	element:RegisterEvent("UNIT_INVENTORY_CHANGED")
	element:SetScript("OnEvent", UpdateAP)

	UpdateAP( element)
	return true
end

local function ArtifactPower( f)
	if not f then return end
	local ArtifactPower = CreateFrame('StatusBar', nil, f)
	ArtifactPower:SetStatusBarTexture( texture)
	ArtifactPower:SetPoint('CENTER', yoMoveArtifact, 'CENTER', 0, 0)
	ArtifactPower:SetStatusBarColor(.901, .8, .601)
	ArtifactPower:EnableMouse(true)
	ArtifactPower:SetSize( yoMoveArtifact:GetSize())
	ArtifactPower:SetOrientation("VERTICAL")
	ArtifactPower:SetFrameLevel(2)
	table.insert( N.statusBars, ArtifactPower)
	CreateStyle( ArtifactPower)

	f.ArtifactPower = ArtifactPower
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.ArtifactPowerbar or not plFrame then return end

	ArtifactPower( plFrame)
	EnableAP( plFrame)
end)
