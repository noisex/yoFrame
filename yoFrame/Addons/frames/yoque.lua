local L, yo, N = unpack( select( 2, ...))

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local IsSpellKnown, IsPlayerSpell, type, strmatch, GetSpellBookItemInfo, GetSpellCooldown, UnitAura, CreateFrame
	= IsSpellKnown, IsPlayerSpell, type, strmatch, GetSpellBookItemInfo, GetSpellCooldown, UnitAura, CreateFrame

local spells = {}
local sIsSwiftmend, readyToSwift = false, false

--REGROWTH 	= GetSpellInfo(8936);
--WILD_GROWTH 	= GetSpellInfo(48438);
--REJUVENATION = GetSpellInfo(774);
--GERMINATION 	= GetSpellInfo(155777);

local ID = {
	[GetSpellInfo(18562)] = true,
	[GetSpellInfo(8936)] = true,
	[GetSpellInfo(48438)] = true,
	[GetSpellInfo(774)] = true,
	[GetSpellInfo(155777)] = true,

	[GetSpellInfo(53563)] = true,
	[GetSpellInfo(156910)] = true,
}

local SWIFTMEND 	= GetSpellInfo(18562);
local NEZERKALO 	= GetSpellInfo(53563);
local NEZERKALO2 	= GetSpellInfo(156910);
local ICONS_NUMBER	= 5

local function isSpellKnown(aSpellName)
	return (type(aSpellName) == "number" and IsSpellKnown(aSpellName))
		or (type(aSpellName) == "number" and IsPlayerSpell(aSpellName))
		or GetSpellBookItemInfo(aSpellName) ~= nil
--		or VUHDO_NAME_TO_SPELL[aSpellName] ~= nil and GetSpellBookItemInfo(VUHDO_NAME_TO_SPELL[aSpellName]);
end

local function isSpellReady( aSpellName)
	local tStart, tSmDuration, tEnabled = GetSpellCooldown( aSpellName);
	if tEnabled ~= 0 and (tStart == nil or tSmDuration == nil or tStart <= 0 or tSmDuration <= 1.6) then
		return true
	end
end

local function onAuras( self, event, unit, ...)

	if event == "UNIT_AURA" and self:GetParent().unit  == unit then --- remover GetParent().unit
		local index, vkl = 0, {}

		sIsSwiftmend, readyToSwift = false, false
		while true do
			index = index + 1
			local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, "HELPFUL")
			if not name then break end

			if caster == "player" then
				if ( isSpellKnown( NEZERKALO) or isSpellKnown( NEZERKALO2)) and not sIsSwiftmend then
					if ID[name] then
						sIsSwiftmend = true
					end
				end

				if isSpellKnown( SWIFTMEND) and not sIsSwiftmend then
					if ID[name] then
						readyToSwift = true
						if isSpellReady( SWIFTMEND) then sIsSwiftmend = true; end
					end
				end

				for i = 1, ICONS_NUMBER do
					if spells[i] and spells[i] == name then
						vkl[i] = true
						self[i]:Show()
						N.updateAuraIcon( self[i], "HELPFUL", icon, count, nil, duration, expirationTime, spellID, i, name)
					end
				end
			end
		end

		for i = 1, ICONS_NUMBER do
			if not vkl[i] then
				self[i]:Hide()
			end
		end

		if sIsSwiftmend then self.swift:Show()
		else 				 self.swift:Hide() end

	else
		if isSpellKnown( SWIFTMEND) and readyToSwift and isSpellReady( SWIFTMEND) then self.swift:Show() end
	end
end

N.CreateClique = function( self)
	--Clique = Clique or CreateFrame("Frame", "yo_Clique", UIParent)
	local header = Clique.header --or CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate, SecureHandlerAttributeTemplate")
	--Clique.header = header
	--SecureHandlerSetFrameRef(header, 'clickcast_header', Clique.header)

	local ret, cet = "", ""

	for i = 1, 15 do
		local key   = yoFrame[2].healBotka["key"..i]
		local spell = yoFrame[2].healBotka["spell"..i]
		local amod, kamod, bmod  = "", ""

		if key and key ~= "" and spell and spell ~= "" then
			key = key:lower()
			if strmatch( key, "-") then
				kamod, bmod = strsplit( "-", key, 2)
				amod = kamod .. "-"
			end

			if strmatch( key, "button") then

			elseif strmatch( key, "wheel") then
				bmod = strmatch( key, "down") or "up"
				ret = format("%sself:SetBindingClick( true, \"%s\", self:GetName(), \"%s\");\n", ret, key, kamod .. "wheel" .. bmod);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, key);
				--print(ret)
				--print(cet)
			elseif strmatch( key, "numpad") then
				amod = strmatch( key, "%d+")
				ret = format("%sself:SetBindingClick( true, \"%s\", self:GetName(), \"%s\");\n", ret, key, kamod .. "numpad" .. amod);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, key);
			else
				--print( key, kamod, bmod, self:GetName())
				ret = format("%sself:SetBindingClick( true, \"%s\", header:GetName(), \"%s\");\n", ret, key, kamod .. bmod);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, key);
			end
		end
	end
	--print( ret, cet)
	header:SetAttribute("setup_onenter", ret)   -- set1
	header:SetAttribute("setup_onleave", cet)   -- clr1

	local setup, remove = nil, nil --self:GetClickAttributes()
	--local setup, remove = self:GetClickAttributes()

	header:SetAttribute("setup_clicks", setup)
	header:SetAttribute("remove_clicks", remove)

	header:SetAttribute("clickcast_onenter", [===[
		local header = self:GetParent():GetFrameRef("clickcast_header")
		header:RunFor(self, header:GetAttribute("setup_onenter"))
		--local button = self:GetAttribute("clickcast_button")
		--print(  self, self:GetAttribute("unit"))
]===])

	header:SetAttribute("clickcast_onleave", [===[
		local header = self:GetParent():GetFrameRef("clickcast_header")
		header:RunFor(self, header:GetAttribute("setup_onleave"))
		--print( self:GetAttribute("clickcast_button"))
]===])

	header:SetAttribute("clickcast_register", [===[
		local button = self:GetAttribute("clickcast_button")
		--print( button:GetName(), button)
		-- Export this frame so we can display it in the insecure environment
		self:SetAttribute("export_register", button)

		button:SetAttribute("clickcast_onenter", self:GetAttribute("clickcast_onenter"))
		button:SetAttribute("clickcast_onleave", self:GetAttribute("clickcast_onleave"))
		--ccframes[button] = true self.frameOnLeave

		--self:RunFor(button, self:GetAttribute("setup_clicks"))
]===])
end

N.makeQuiButton = function ( self )

	self:SetAttribute("*type1", nil)
	self:SetAttribute("*type2", nil)

	if #yoFrame[2].healBotka["targ01"] > 1 then
	   local amod, kamod, bmod  = "", "", ""
	   local key = yoFrame[2].healBotka["targ01"]
		key = key:lower()
		if strmatch( key, "-") then
			kamod, bmod = strsplit( "-", key, 2)
			amod = kamod .. "-"
		end
		key = strmatch( key, "%d+")
		self:SetAttribute( amod .. 'type' .. key, 'target')
	end

	if #yoFrame[2].healBotka["menu01"] > 1 then
		local amod, kamod, bmod  = "", "", ""
		local key = yoFrame[2].healBotka["menu01"]
		key = key:lower()
		if strmatch( key, "-") then
			kamod, bmod = strsplit( "-", key, 2)
			amod = kamod .. "-"
		end
		key = strmatch( key, "%d+")
		self:SetAttribute( amod .. 'type' .. key, 'togglemenu')
	end

	for i = 1, 15 do
		local key   = yoFrame[2].healBotka["key"..i]
		local spell = yoFrame[2].healBotka["spell"..i]
		local amod, kamod, bmod  = "", "", ""

		if ( key and key ~= "") and ( spell and spell ~= "") then
			key = key:lower()
			if strmatch( key, "-") then
				kamod, bmod = strsplit( "-", key, 2)
				amod = kamod .. "-"
			end

			if strmatch( key, "button") then
				key = strmatch( key, "%d+")
				self:SetAttribute( amod     .. "type"       .. key, "macro")
				self:SetAttribute( amod     .. "macrotext"  .. key, "/cast [@mouseover] " .. spell)

			elseif strmatch( key, "wheel") then
				bmod = strmatch( key, "down") or "up"
				--print("type-"       .. kamod .. "wheel" .. bmod, "macro")
				--print("macrotext-"  .. kamod .. "wheel" .. bmod, "/cast [@mouseover] " .. spell)
				self:SetAttribute("type-"       .. kamod .. "wheel" .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. "wheel" .. bmod, "/cast [@mouseover] " .. spell)

			elseif strmatch( key, "numpad") then
				key = strmatch( key, "%d+")
				self:SetAttribute( "type-"      .. kamod .. "numpad" .. key, "macro")
				self:SetAttribute( "macrotext-" .. kamod .. "numpad" .. key, "/cast [@mouseover] " .. spell)

			else
				self:SetAttribute("type-"       .. kamod .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. bmod, "/cast [@mouseover] " .. spell)
			end
		end
	end

	if self:GetName() == "yo_Target" then return end

	local buffHots = CreateFrame("Frame", nil, self)
	--buffHots:SetPoint("TOPLEFT", self, "TOPLEFT",  3, -3)
	buffHots:SetAllPoints( self)
	buffHots:SetSize(12, 12)
	buffHots:SetFrameLevel(120)
	buffHots:SetFrameStrata( "MEDIUM")
	buffHots.direction   	= "ICONS"
	buffHots.noShadow   	= true
	buffHots.hideTooltip    = true
	buffHots.timeSecOnly    = true
	buffHots:RegisterEvent("UNIT_AURA", buffHots:GetParent().unit)
	buffHots:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self.buffHots        	= buffHots

	self.buffHots.swift = self.buffHots:CreateTexture(nil, "OVERLAY")
	self.buffHots.swift:SetPoint("LEFT", self.buffHots, "TOPLEFT", 20, 3)
	self.buffHots.swift:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\icon_red")
	self.buffHots.swift:SetVertexColor( 1, 0.8, 0.2, 1)
	self.buffHots.swift:SetSize( 12, 12)
	self.buffHots.swift:Hide()

	for i = 1, ICONS_NUMBER do
		self.buffHots[i] = N.createAuraIcon( self.buffHots, i)
		self.buffHots[i]:Hide()

		if yo.healBotka["hSpell" .. i] 	then spells[i] 					= yo.healBotka["hSpell" .. i]	end
		if yo.healBotka["hColEna" ..i] 	then self.buffHots[i].color 	= { strsplit( ",", yo.healBotka["hColor" ..i])} end
		if yo.healBotka["hTimEna" ..i] 	then self.buffHots[i].minTimer 	= yo.healBotka["hTimer" ..i] + 0.1 end

		self.buffHots[i]:SetScale( yo.healBotka["hScale" .. i] or 1)
	end

	buffHots:SetScript("OnEvent", onAuras)
end


--[[
function initialConfigFunction(child)
	print("plox")
end

local header = CreateFrame("Frame","Header",UIParent,"SecureGroupHeaderTemplate")
header:SetAttribute("template","SecureUnitButtonTemplate")
header.initialConfigFunction = initialConfigFunction
header:SetAttribute("point", "TOP")
header:SetAttribute("groupFilter", "")
header:SetAttribute("templateType", "Button")
header:SetAttribute("yOffset", -1)
header:SetAttribute("sortMethod", "INDEX")
header:SetAttribute("strictFiltering", false)
header:SetAttribute("groupBy", "GROUP")
header:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
header:SetAttribute("maxColumns", 8)
header:SetAttribute("unitsPerColumn", 5)
header:SetAttribute("columnSpacing", 4)
header:SetAttribute("columnAnchorPoint", "TOP")
header:SetAttribute("showParty", true)
header:SetAttribute("showRaid", true)
header:SetAttribute("showPlayer", true)
header:SetAttribute("showSolo", true)

header:SetWidth(200)
header:SetHeight(200)
header:SetPoint("CENTER", 0,0)
header.texture=header:CreateTexture()
header.texture:SetAllPoints(header)
header.texture:SetTexture(1,0,0,1)

header:Show()

]]