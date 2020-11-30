local L, yo, n = unpack( select( 2, ...))

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local type, strmatch, CreateFrame
	= type, strmatch, CreateFrame

--local function VUHDO_getAutoBattleRezText(anIsKeyboard)

--	if ("DRUID" == VUHDO_PLAYER_CLASS or "PALADIN" == VUHDO_PLAYER_CLASS) and VUHDO_SPELL_CONFIG["autoBattleRez"] then
--		tRezText = "/use [dead,combat,@" .. (anIsKeyboard and "mouseover" or "vuhdo");
--		if VUHDO_SPELL_CONFIG["smartCastModi"] ~= "all" then
--			tRezText = tRezText .. ",mod:" .. VUHDO_SPELL_CONFIG["smartCastModi"];
--		end
--		tRezText = tRezText .. "] " .. VUHDO_SPELL_ID.REBIRTH .. "\n";
--	else
--		tRezText = "";
--	end

--	return tRezText;
--end
--if VUHDO_SPELL_CONFIG["IS_CANCEL_CURRENT"] then
--		tStopText = "/stopcasting\n";
--	else
--		tStopText = "";
--	end
--if VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"] then
--	sFireText = sFireText .. "/use".. tModi .."13\n";
--end
--if VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"] then
--	sFireText = sFireText .. "/use".. tModi .."14\n";
--end


n.CreateClique = function( self)
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

n.makeQuiButton = function ( self )

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
				--		tRezText = "/use [dead,combat,@" .. (anIsKeyboard and "mouseover" or "vuhdo");

			if strmatch( key, "button") then
				key = strmatch( key, "%d+")
				self:SetAttribute( amod     .. "type"       .. key, "macro")
				--self:SetAttribute( amod     .. "macrotext"  .. key, "/cast [@mouseover] " .. spell)
				self:SetAttribute( amod     .. "macrotext"  .. key, "/use [help,nodead,@mouseover] " .. spell)

			elseif strmatch( key, "wheel") then
				bmod = strmatch( key, "down") or "up"
				--print("type-"       .. kamod .. "wheel" .. bmod, "macro")
				--print("macrotext-"  .. kamod .. "wheel" .. bmod, "/cast [@mouseover] " .. spell)
				self:SetAttribute("type-"       .. kamod .. "wheel" .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. "wheel" .. bmod, "/use [help,nodead,@mouseover] " .. spell)

			elseif strmatch( key, "numpad") then
				key = strmatch( key, "%d+")
				self:SetAttribute( "type-"      .. kamod .. "numpad" .. key, "macro")
				self:SetAttribute( "macrotext-" .. kamod .. "numpad" .. key, "/use [help,nodead,@mouseover] " .. spell)

			else
				self:SetAttribute("type-"       .. kamod .. bmod, "macro")
				self:SetAttribute("macrotext-"  .. kamod .. bmod, "/use [help,nodead,@mouseover] " .. spell)
			end
		end
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