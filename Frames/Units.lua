local _, ns = ...
local _, playerClass = UnitClass("player")
local oUF = ns.oUF or oUF 
local colors = oUF.colors
local config
local L, yo = ns[1], ns[2]


ns.frames, ns.headers, ns.objects = {}, {}, {}
ns.statusbars = {}

function ns.CreateSB(parent, size, justify, noBG, noSmoothing)

	local sb = CreateFrame("StatusBar", "yo_StatusBar"..(1 + #ns.statusbars), parent) -- global name to avoid Blizzard /fstack error
	sb:SetStatusBarTexture( texture)
	tinsert(ns.statusbars, sb)

	sb.fg = sb:GetStatusBarTexture()
	sb.fg:SetDrawLayer("BORDER")
	sb.fg:SetHorizTile(false)
	sb.fg:SetVertTile(false)

	--if size then
	--	sb.value = ns.CreateFontString(sb, size, justify)
	--end

	if not noBG then
		sb.bg = sb:CreateTexture(nil, "BACKGROUND")
		sb.bg:SetTexture( texture)
		sb.bg:SetAllPoints(true)
		tinsert(ns.statusbars, sb.bg)
	end

	return sb
end

local function Spawn(self, unit, isSingle)
	if self:GetParent():GetAttribute("useOwnerUnit") then
		local suffix = self:GetParent():GetAttribute("unitsuffix")
		self:SetAttribute("useOwnerUnit", true)
		self:SetAttribute("unitsuffix", suffix)
		unit = unit .. suffix
	end

--	local uconfig = ns.uconfig[unit]
	self.spawnunit = unit

	-- print("Spawn", self:GetName(), unit)
	tinsert(ns.objects, self)

	-- turn "boss2" into "boss" for example
	unit = gsub(unit, "%d", "")

--	self.menu = ns.UnitFrame_DropdownMenu

--	self:HookScript("OnEnter", ns.UnitFrame_OnEnter)
--	self:HookScript("OnLeave", ns.UnitFrame_OnLeave)

	self:RegisterForClicks("anyup")

	local FRAME_WIDTH  = 250
	local FRAME_HEIGHT = 45
	local POWER_HEIGHT = 10

	local BAR_TEXTURE = "Interface\\TargetingFrame\\UI-StatusBar"

	if isSingle then
		self:SetAttribute("initial-width", FRAME_WIDTH)
		self:SetAttribute("initial-height", FRAME_HEIGHT)
		self:SetWidth(FRAME_WIDTH)
		self:SetHeight(FRAME_HEIGHT)
	else
		-- used for aura filtering
		self.isGroupFrame = true
	end

	--for k, v in pairs(ns.framePrototype) do
	--	self[k] = v
	--end


	-----------------------------------------------------------
	-- Overlay to avoid reparenting stuff on powerless units --
	-----------------------------------------------------------
	self.overlay = CreateFrame("Frame", nil, self)
	self.overlay:SetAllPoints(true)

	--health.value:SetParent(self.overlay)
	----self:SetBorderParent(self.overlay)

	-------------------------
	-- Health bar and text --
	-------------------------
	local health = ns.CreateSB(self, 24, "RIGHT")
	health:SetAllPoints(self)

	health.fg:SetDrawLayer("ARTWORK")
	health.bg.multiplier = 0.5

	health.value = health:CreateFontString(nil, "Overlay")
	health.value:SetFont( font, fontsize, "OUTLINE")
	--health.value:SetParent(self.overlay)
	health.value:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, - 4)

	local healthColorMode = "CLASS"
	health.colorClass = healthColorMode == "CLASS"
	health.colorReaction = healthColorMode == "CLASS"
	health.colorSmooth = healthColorMode == "HEALTH"

	if healthColorMode == "CUSTOM" then
		local r, g, b = unpack(config.healthColor)
		health:SetStatusBarColor(r, g, b)
		health.bg:SetVertexColor(r * healthBG, g * healthBG, b * healthBG)
	end

	health.frequentUpdates = true
--	health.PostUpdate = ns.Health_PostUpdate
	--self:RegisterForMouseover(health)
	--self:SmoothBar(health)
	self.Health = health
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	oUF:RegisterStyle("Phanx", Spawn)
	oUF:SetActiveStyle("Phanx")
	yo_oUFPLayer = oUF:Spawn("player", true)
	yo_oUFPLayer:SetPoint("CENTER", UIParent, "CENTER", -300, 0)

	yo_oUFTarget = oUF:Spawn("target", true)
	yo_oUFTarget:SetPoint("CENTER", UIParent, "CENTER", 300, 0)
end)
