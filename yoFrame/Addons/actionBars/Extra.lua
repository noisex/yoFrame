local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]
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
	for SpellButton in ZoneAbilities.SpellButtonContainer:EnumerateActive() do
		if not SpellButton.IsSkinned then
			SpellButton:CreateBackdrop()
			SpellButton:StyleButton()
			SpellButton:CreateShadow()

			SpellButton.Backdrop:SetFrameLevel(SpellButton:GetFrameLevel() - 1)

			SpellButton.Icon:SetTexCoord(unpack(T.IconCoord))
			SpellButton.Icon:ClearAllPoints()
			SpellButton.Icon:SetInside(SpellButton.Backdrop)

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

	hooksecurefunc("ExtraActionBar_Update", self.DisableExtraButtonTexture)
	hooksecurefunc(ZoneAbilities, "UpdateDisplayedZoneAbilities", ActionBars.SkinZoneAbilities)
end