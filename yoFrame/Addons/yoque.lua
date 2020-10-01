local L, yo, N = unpack( select( 2, ...))

local spells = {
	[2]     = 155777,
	[3]     = 33763,
	[4]     = 48438,
	[5]     = 8936,
	[6]     = 774,
}

--ClickCastFrames = _G.ClickCastFrames or {}
--for _, v in pairs({
--	"yo_Player", "yo_Target",
--	--"PlayerFrame", "PetFrame",
--	---- Party members
--	--"PartyMemberFrame1", "PartyMemberFrame2", "PartyMemberFrame3", "PartyMemberFrame4", "PartyMemberFrame5",
--	---- Party pets
--	--"PartyMemberFrame1PetFrame", "PartyMemberFrame2PetFrame", "PartyMemberFrame3PetFrame", "PartyMemberFrame4PetFrame", "PartyMemberFrame5PetFrame",
--	-- Compact party member frame
--	--"CompactPartyFrameMemberSelf", "CompactPartyFrameMemberSelfBuff1", "CompactPartyFrameMemberSelfBuff2", "CompactPartyFrameMemberSelfBuff3", "CompactPartyFrameMemberSelfDebuff1", "CompactPartyFrameMemberSelfDebuff2", "CompactPartyFrameMemberSelfDebuff3",
--	--"CompactPartyFrameMember1Buff1", "CompactPartyFrameMember1Buff2", "CompactPartyFrameMember1Buff3", "CompactPartyFrameMember1Debuff1", "CompactPartyFrameMember1Debuff2", "CompactPartyFrameMember1Debuff3",
--	--"CompactPartyFrameMember2Buff1", "CompactPartyFrameMember2Buff2", "CompactPartyFrameMember2Buff3", "CompactPartyFrameMember2Debuff1", "CompactPartyFrameMember2Debuff2", "CompactPartyFrameMember2Debuff3",
--	--"CompactPartyFrameMember3Buff1", "CompactPartyFrameMember3Buff2", "CompactPartyFrameMember3Buff3", "CompactPartyFrameMember3Debuff1", "CompactPartyFrameMember3Debuff2", "CompactPartyFrameMember3Debuff3",
--	--"CompactPartyFrameMember4Buff1", "CompactPartyFrameMember4Buff2", "CompactPartyFrameMember4Buff3", "CompactPartyFrameMember4Debuff1", "CompactPartyFrameMember4Debuff2", "CompactPartyFrameMember4Debuff3",
--	--"CompactPartyFrameMember5Buff1", "CompactPartyFrameMember5Buff2", "CompactPartyFrameMember5Buff3", "CompactPartyFrameMember5Debuff1", "CompactPartyFrameMember5Debuff2", "CompactPartyFrameMember5Debuff3",
--	---- Target and focus frames
--	--"TargetFrame", "TargetFrameToT",
--	--"FocusFrame", "FocusFrameToT",
--	---- Boss and arena frames
--	--"Boss1TargetFrame", "Boss2TargetFrame", "Boss3TargetFrame", "Boss4TargetFrame",
--	--"ArenaEnemyFrame1", "ArenaEnemyFrame2", "ArenaEnemyFrame3", "ArenaEnemyFrame4", "ArenaEnemyFrame5",
--}) do
--	if _G[v] then ClickCastFrames[_G[v]] = true end
--end

--hooksecurefunc("CreateFrame", function(_, name, _, template)
--	if template and template:find("SecureUnitButtonTemplate") then
--		ClickCastFrames[_G[name]] = true
--	end
--end)


local function onAuras( self, event, unit, ...)
	if event == "UNIT_AURA" and self:GetParent().unit  == unit then
		index = 0
		while true do
			index = index + 1
			local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, "HELPFUL")
			if not name then break end

			if caster == "player" then
				for i = 1, 6 do
					local spell = spells[i]
					if spell and spell == spellID then
						self[i]:Show()
						UpdateAuraIcon( self[i], "HELPFUL", icon, count, nil, duration, expirationTime, spellID, i, unit)
					end
				end
			end
		end
	end
end

N.CreateClique = function( self)
	Clique = Clique or CreateFrame("Frame", "yo_Clique", UIParent)
	local header = Clique.header or CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate, SecureHandlerAttributeTemplate")
	Clique.header = header
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
]===])

	header:SetAttribute("clickcast_onleave", [===[
		local header = self:GetParent():GetFrameRef("clickcast_header")
		header:RunFor(self, header:GetAttribute("setup_onleave"))
]===])

	header:SetAttribute("clickcast_register", [===[
		local button = self:GetAttribute("clickcast_button")

		-- Export this frame so we can display it in the insecure environment
		self:SetAttribute("export_register", button)

		button:SetAttribute("clickcast_onenter", self:GetAttribute("clickcast_onenter"))
		button:SetAttribute("clickcast_onleave", self:GetAttribute("clickcast_onleave"))
		--ccframes[button] = true
		--self:RunFor(button, self:GetAttribute("setup_clicks"))
]===])

	if true then
		--SecureHandlerSetFrameRef(tarFrame, 'clickcast_header', Clique.header)
		----local clique = header:GetFrameRef('clickcast_header')
		----print("...", clique)
		----if(clique) then
		----tarFrame.header = header
		--tarFrame:SetAttribute('clickcast_button', tarFrame)
		----print( tarFrame.header:GetAttribute("clickcast_register"))
		--tarFrame:RunAttribute('clickcast_register')
		--end
	end
end

N.makeQuiButton = function ( self )

	self:SetAttribute("*type1", nil)
	self:SetAttribute("*type2", nil)

	if yoFrame[2].healBotka["targ01"] then
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

	if yoFrame[2].healBotka["menu01"] then
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

		if key and key ~= "" and spell and spell ~= "" then
			local name = GetSpellInfo( spell)
			key = key:lower()
			if strmatch( key, "-") then
				kamod, bmod = strsplit( "-", key, 2)
				amod = kamod .. "-"
			end

			if strmatch( key, "button") then
				key = strmatch( key, "%d+")
				self:SetAttribute( amod     .. "type"       .. key, "macro")
				self:SetAttribute( amod     .. "macrotext"  .. key, "/cast [@mouseover] " .. name)
			elseif strmatch( key, "wheel") then
				bmod = strmatch( key, "down") or "up"
				self:SetAttribute("type-"       .. kamod .. "wheel" .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. "wheel" .. bmod, "/cast [@mouseover] " .. name)
			elseif strmatch( key, "numpad") then
				key = strmatch( key, "%d+")
				self:SetAttribute( "type-"      .. kamod .. "numpad" .. key, "macro")
				self:SetAttribute( "macrotext-" .. kamod .. "numpad" .. key, "/cast [@mouseover] " .. name)
			else
				self:SetAttribute("type-"       .. kamod .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. bmod, "/cast [@mouseover] " .. name)
			end
		end
	end

	if self:GetName() == "yo_Target" then return end

	local buffHots = CreateFrame("Frame", nil, self)
	buffHots:SetPoint("TOPLEFT", self, "TOPLEFT",  3, -3)
	buffHots:SetWidth( 8)
	buffHots:SetHeight( 8)
	buffHots:SetFrameLevel(120)
	buffHots:SetFrameStrata( "MEDIUM")
	buffHots.direction   	= "ICONS"
	buffHots.noShadow   	= true
	buffHots.hideTooltip    = true
	buffHots.timeSecOnly    = true
	buffHots:RegisterEvent("UNIT_AURA")
	buffHots:SetScript("OnEvent", onAuras)
	self.buffHots        	= buffHots

	for i = 1, 6 do
		self.buffHots[i] = CreateAuraIcon( self.buffHots, i)
		self.buffHots[i]:Hide()
	end
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