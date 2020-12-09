local addon, ns = ...

local L, yo, n = unpack( ns)
local oUF = ns.oUF

if not yo.ToolTip.enable then return end
if not yo.ToolTip.showBorder then return end

local _G = _G

local GameTooltip, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax, select, CreateStyle, UnitIsConnected, UnitPlayerControlled, UnitReaction, GetItemInfo, GetItemQualityColor, GetMouseFocus, floor, UnitClass
	= GameTooltip, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax, select, CreateStyle, UnitIsConnected, UnitPlayerControlled, UnitReaction, GetItemInfo, GetItemQualityColor, GetMouseFocus, floor, UnitClass

local DEAD = DEAD

-------------------------------------------------------------------------------------------------------
--                                   based on Tukui
------------------------------------------------------------------------------------------------------

local HealthBar = GameTooltipStatusBar
local icon = "Interface\\AddOns\\yoFrame\\Media\\spec_icons_normal"

local function SetHealthValue(self, unit)
	if (UnitIsDeadOrGhost(unit)) then
		self.Text:SetText(DEAD)
	else
		local Health, MaxHealth = UnitHealth(unit), UnitHealthMax(unit)
		local String = (Health and MaxHealth and (floor(Health / MaxHealth * 100) .. "%")) or "???"

		self.Text:SetText(String)
	end
end

local function OnValueChanged()

	local unit = select(2, HealthBar:GetParent():GetUnit())

	if (not unit) then
		local GMF = GetMouseFocus()

		if (GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
	end

	if not unit then
		return
	end

	SetHealthValue(HealthBar, unit)
end

local function SkinHealthBar()
	HealthBar:SetScript("OnValueChanged", OnValueChanged)
	HealthBar:SetStatusBarTexture( yo.texture)
	HealthBar:ClearAllPoints()
	HealthBar:SetPoint("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 0, 5)
	HealthBar:SetPoint("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", 0, 5)

	HealthBar.icon = HealthBar:CreateTexture(nil, "OVERLAY")
	HealthBar.icon:SetPoint("TOPRIGHT", HealthBar, "BOTTOMRIGHT", -10, -10)
	HealthBar.icon:SetSize(30, 30)
	HealthBar.icon:SetTexture( icon)
	HealthBar.icon:Hide()
	CreateStyle( HealthBar, 1)

	if not HealthBar.Text then
		HealthBar.Text = HealthBar:CreateFontString(nil, "OVERLAY")
		HealthBar.Text:SetFont( yo.fontpx, yo.fontsize +5, "OUTLINE")
		HealthBar.Text:SetPoint("CENTER", HealthBar, "TOP", 0, 2)
	end
end

local function SetUnitBorderColor( Unit)
	local Unit = select(2, HealthBar:GetParent():GetUnit()) or "mouseover"
	local cols = { 0.09, 0.09, 0.09}

	if not GameTooltip.shadow then CreateStyle(GameTooltip, 1) end
--print(UnitIsUnit( Unit, "player"), select( 2,UnitClass( Unit)))
	if not UnitIsConnected( Unit) then
		cols = oUF.colors.disconnected
	elseif UnitPlayerControlled( Unit) then
		cols = oUF.colors.class[select( 2,UnitClass( Unit))]
--	elseif UnitIsUnit( Unit, "player") then
--		cols = oUF.colors.class[select( 2,UnitClass( "player"))]
	elseif UnitReaction( Unit, 'player') then
		cols = oUF.colors.reaction[UnitReaction( Unit, "player")]
	end

	HealthBar:SetStatusBarColor( cols[1], cols[2], cols[3])
	HealthBar.Text:SetTextColor( cols[1], cols[2], cols[3])
	GameTooltip.shadow:SetBackdropBorderColor( cols[1], cols[2], cols[3], 0.9)
end

local function getMyColor()
	local R, G, B = 0.3, 0.3, 0.3
	if yo.ToolTip.borderClass then
		R, G, B = yo.myColor.r, yo.myColor.g, yo.myColor.b
	end
	return R, G, B
end

local function Skin(style)
	local self = GameTooltip

	if not self.shadow then CreateStyle(self, 1) end

	local Link = select(2, self:GetItem())
	local R, G, B = getMyColor()

	if Link then
		local Quality = select(3, GetItemInfo(Link))
		if Quality then
			R, G, B = GetItemQualityColor(Quality)
		end
	end

	self.shadow:SetBackdropBorderColor( R, G, B, 0.9)
	self:ClearBackdrop()
end

local function SetCompareItemBorderColor(anchorFrame)
	for i = 1, 2 do
		local TT = _G["ShoppingTooltip"..i]

		if TT:IsShown() then
			local FrameLevel = GameTooltip:GetFrameLevel()
			local Item = TT:GetItem()

			if FrameLevel == TT:GetFrameLevel() then
				TT:SetFrameLevel(i + 1)
			end

			if not TT.shadow then CreateStyle( TT, 1) end

			local R, G, B = getMyColor()
			if Item then
				local Quality = select(3, GetItemInfo(Item))
				if Quality then
					R, G, B = GetItemQualityColor(Quality)
				end
				TT.shadow:SetBackdropBorderColor(R, G, B)
			end
		end
		TT:ClearBackdrop()
	end
end

hooksecurefunc("SharedTooltip_SetBackdropStyle", Skin)
--hooksecurefunc("UnitFrame_UpdateTooltip", SetUnitBorderColor)
hooksecurefunc("GameTooltip_ShowCompareItem", SetCompareItemBorderColor)
hooksecurefunc("GameTooltip_UnitColor", SetUnitBorderColor)

hooksecurefunc("ReputationParagonFrame_SetupParagonTooltip", function(self, ...)
	local TT = EmbeddedItemTooltip
	TT:ClearBackdrop()
	if not TT.shadow then
		CreateStyle( TT, 1)
		TT.shadow:SetBackdropBorderColor( getMyColor())
	end
end)

SkinHealthBar()

