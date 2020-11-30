local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local _G = _G
local ActionBars = n["ActionBars"]
local Button = ExtraActionButton1
local Icon = ExtraActionButton1Icon
local Container = ExtraAbilityContainer
local ZoneAbilities = ZoneAbilityFrame

function ActionBars:DisableExtraButtonTexture()
	local Bar = ExtraActionBarFrame

	if (HasExtraActionBar()) then
		Button.style:SetTexture("")
	end
end

function ActionBars:SkinZoneAbilities()
	local buttons = ZoneAbilities.SpellButtonContainer:GetLayoutChildren()

	for ind, SpellButton in pairs( buttons) do
		if not SpellButton.IsSkinned then
			local shift, alpfa = 7, 0.9
			if SpellButton.CreateTexture then
				if SpellButton.SetHighlightTexture 	then SpellButton:SetHighlightTexture( 	myButtonBorder( SpellButton, "hover", shift, alpfa,   { 1, 1, 0})) end
				if SpellButton.SetNormalTexture 	then SpellButton:SetNormalTexture( 		myButtonBorder( SpellButton, "normal", shift, alpfa,  { 0, 1, 0})) end
				if SpellButton.SetCheckedTexture	then SpellButton:SetCheckedTexture( 	myButtonBorder( SpellButton, "checked", shift, alpfa, { 1, 0, 0})) end
			else
				CreateStyleSmall( SpellButton, 3, 0, 1)
			end

			SpellButton.Icon:SetTexCoord(unpack( yo.tCoord))
			SpellButton.NormalTexture:SetAlpha(0)

			SpellButton.IsSkinned = true
		end
	end
end

function ActionBars:SetupExtraButton()
	local Holder = CreateFrame("Frame", "yo_ExtraActionButton", UIParent)
	local Bar = ExtraActionBarFrame
	local Icon = ExtraActionButton1Icon

	Holder:SetSize( 32, 32)
	Holder:SetPoint("CENTER", yoMoveExtr, "CENTER", 0, 0)

	Container:SetParent(Holder)
	Container:ClearAllPoints()
	Container:SetPoint("CENTER", Holder, "CENTER", 0, 0)
	Container.ignoreFramePositionManager = true

	ActionButtonDesign( Holder, Button, 32, 32)

	ZoneAbilities.Style:SetAlpha(0)
	ZoneAbilities:SetScale(0.75)

	hooksecurefunc("ExtraActionBar_Update", self.DisableExtraButtonTexture)
	hooksecurefunc(ZoneAbilities, "UpdateDisplayedZoneAbilities", ActionBars.SkinZoneAbilities)
end