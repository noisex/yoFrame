local addon, ns = ...
local L, yo, N = unpack( ns)

if true then return end

--------------------------------------------------------------------------------------------------------------

local borderColor = { 0.5, 0.5, 0.5 }
local borderSize = 16
local sections = { "TOPLEFT", "TOPRIGHT", "TOP", "BOTTOMLEFT", "BOTTOMRIGHT", "BOTTOM", "LEFT", "RIGHT" }

local function SetBorderColor(self, r, g, b, a, glow)
	local t = self.BorderTextures
	if not t then return end

	if not r or not g or not b or a == 0 then
		r, g, b = unpack( borderColor)
	end

	for pos, tex in pairs(t) do
		tex:SetVertexColor(r, g, b)
	end

	--if self.Glow then
	--	if glow then
	--		self.Glow:SetVertexColor(r, g, b, a)
	--		self.Glow:Show()
	--	else
	--		self.Glow:SetVertexColor(1, 1, 1, 1)
	--		self.Glow:Hide()
	--	end
	--end
end

local function GetBorderColor(self)
	return self.BorderTextures and self.BorderTextures.TOPLEFT:GetVertexColor()
end

local function SetBorderParent(self, parent)
	local t = self.BorderTextures
	if not t then return end
	if not parent then
		parent = type(self.overlay) == "Frame" and self.overlay or self
	end
	for pos, tex in pairs(t) do
		tex:SetParent(parent)
	end
	self:SetBorderSize(self:GetBorderSize())
end

local function SetBorderSize(self, size, dL, dR, dT, dB)
	local t = self.BorderTextures
	if not t then return end

	size = size or borderSize
	dL, dR, dT, dB = dL or t.LEFT.offset or 0, dR or t.RIGHT.offset or 0, dT or t.TOP.offset or 0, dB or t.BOTTOM.offset or 0

	for pos, tex in pairs(t) do
		tex:SetSize(size, size)
	end

	local d = floor(size * 7 / 16 + 0.5)
	local parent = t.TOPLEFT:GetParent()

	t.TOPLEFT:SetPoint("TOPLEFT", parent, -d - dL, d + dT)
	t.TOPRIGHT:SetPoint("TOPRIGHT", parent, d + dR, d + dT)
	t.BOTTOMLEFT:SetPoint("BOTTOMLEFT", parent, -d - dL, -d - dB)
	t.BOTTOMRIGHT:SetPoint("BOTTOMRIGHT", parent, d + dR, -d - dB)

	t.LEFT.offset, t.RIGHT.offset, t.TOP.offset, t.BOTTOM.offset = dL, dR, dT, dB
end


local function GetBorderSize(self)
	local t = self.BorderTextures
	if not t then return end
	return t.TOPLEFT:GetWidth(), t.LEFT.offset, t.RIGHT.offset, t.TOP.offset, t.BOTTOM.offset
end

function CreateBorder(self, size, offset, parent, layer)
	if type(self) ~= "table" or not self.CreateTexture or self.BorderTextures then return end

	local t = {}

	for i = 1, #sections do
		local x = self:CreateTexture(nil, layer or "ARTWORK")
		x:SetTexture([[Interface\AddOns\yoFrame\Media\boder6px]])  --.blp   SimpleSquare
		t[sections[i]] = x
	end

	t.TOPLEFT:SetTexCoord(0, 1/3, 0, 1/3)
	t.TOP:SetTexCoord(1/3, 2/3, 0, 1/3)
	t.TOPRIGHT:SetTexCoord(2/3, 1, 0, 1/3)
	t.RIGHT:SetTexCoord(2/3, 1, 1/3, 2/3)
	t.BOTTOMRIGHT:SetTexCoord(2/3, 1, 2/3, 1)
	t.BOTTOM:SetTexCoord(1/3, 2/3, 2/3, 1)
	t.BOTTOMLEFT:SetTexCoord(0, 1/3, 2/3, 1)
	t.LEFT:SetTexCoord(0, 1/3, 1/3, 2/3)

	t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT")
	t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT")

	t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT")
	t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT")

	t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT")
	t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT")

	t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT")
	t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT")

	self.BorderTextures = t

	self.SetBorderColor  = SetBorderColor
	self.SetBorderLayer  = SetBorderLayer
	self.SetBorderParent = SetBorderParent
	self.SetBorderSize   = SetBorderSize

	self.GetBorderColor  = GetBorderColor
	self.GetBorderLayer  = GetBorderLayer
	self.GetBorderParent = GetBorderParent
	self.GetBorderSize   = GetBorderSize

	if self.GetBackdrop then
		local backdrop = self:GetBackdrop()
		if type(backdrop) == "table" then
			if backdrop.edgeFile then
				backdrop.edgeFile = nil
			end
			if backdrop.insets then
				backdrop.insets.top = 0
				backdrop.insets.right = 0
				backdrop.insets.bottom = 0
				backdrop.insets.left = 0
			end
			self:SetBackdrop(backdrop)
		end
	end

	if self.SetBackdropBorderColor then
		self.SetBackdropBorderColor = SetBorderColor
	end

	--tinsert(ns.borderedObjects, self)

	self:SetBorderColor()
	self:SetBorderParent(parent)
	self:SetBorderSize(size, offset)

	return true
end

local borderFrame1 = CreateFrame("Frame", nil, UIParent)
borderFrame1:SetPoint("CENTER")
borderFrame1:SetSize(250, 50)
borderFrame1:Hide()
CreateStyle( borderFrame1, 4)

--borderFrame1.texture = borderFrame1:CreateTexture(nil, "OVERLAY")
--borderFrame1.texture:SetAllPoints()
--borderFrame1.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\bar_dground")

local borderFrame2 = CreateFrame("Frame", nil, UIParent)
borderFrame2:SetPoint("CENTER", borderFrame1, "CENTER", 0, 70)
borderFrame2:SetSize(250, 50)
borderFrame2:Hide()
borderFrame2.texture = borderFrame2:CreateTexture(nil, "OVERLAY")
borderFrame2.texture:SetAllPoints()
borderFrame2.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidbg")

local borderFrame3 = CreateFrame("Frame", nil, UIParent)
borderFrame3:SetPoint("CENTER", borderFrame2, "CENTER", 0, 70)
borderFrame3:SetSize(250, 50)
borderFrame3:Hide()
borderFrame3.texture = borderFrame3:CreateTexture(nil, "OVERLAY")
borderFrame3.texture:SetAllPoints()
borderFrame3.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidbg")

--CreateBorder(borderFrame1, 16)
CreateBorder(borderFrame2, 12)
CreateBorder(borderFrame3, 8)


--borderFrame1.texture:SetVertexColor( 0.2, 0.2, 0.2, 0.9)
borderFrame2.texture:SetVertexColor( 1, 0.75, 0, 0.9)
borderFrame3.texture:SetVertexColor( 0, 1, 1, 0.9)

SetBorderColor(borderFrame1, 1, 0.75, 0, 1)
SetBorderColor(borderFrame2, 1, 0, 0, 1)

local toggle = true
SlashCmdList["TB"] = function()
	borderFrame1:SetShown( toggle)
	borderFrame2:SetShown( toggle)
	borderFrame3:SetShown( toggle)
	toggle = not toggle
end

SLASH_TB1 = "/tb"
SLASH_TB2 = "/еи"