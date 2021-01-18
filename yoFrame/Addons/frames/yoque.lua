local L, yo, n = unpack( select( 2, ...))

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local type, strmatch, CreateFrame
	= type, strmatch, CreateFrame

function n.makeKeyNotWar( button)

	local modder, modName, buttonNum, realbutton = "", "", "", button

	if ( button and button ~= "") then
		button = button:lower()
		if strmatch( button, "-") then
			modder, button = strsplit( "-", button, 2)
			modName = modder .. "-"
		end
	else
		return false
	end

	buttonNum = strmatch( button, "%d+")

	return button, modder, modName, buttonNum, realbutton
end

function n.makeMacroButton( button)
	local button, modder, modName, buttonNum = n.makeKeyNotWar( button)

	local macroAttr, macroButton = "", ""
	if strmatch( button, "button") then
		macroAttr 	= modName     .. "type"       .. buttonNum
		macroButton = modName     .. "macrotext"  .. buttonNum
	elseif strmatch( button, "wheel") then
		button 		= strmatch( button, "down") or "up"
		macroAttr 	= "type-"       .. modder .. "wheel" .. button
		macroButton = "macrotext-"  .. modder .. "wheel" .. button
	elseif strmatch( button, "numpad") then
		macroAttr 	= "type-"      .. modder .. "numpad" .. buttonNum
		macroButton = "macrotext-" .. modder .. "numpad" .. buttonNum
	else
		macroAttr 	= "type-"       .. modder .. button
		macroButton = "macrotext-"  .. modder .. button
	end

	return macroAttr, macroButton
end

--///////////////////////////////////////////////////
if not yo.healBotka.enable then return end
if not Clique then return end
--///////////////////////////////////////////////////

local Clique = Clique

 n.CreateClique = function( self)
	local header = Clique.header
	local ret, cet = "", ""

	for i = 1, 15 do
		local button, modder, modName, buttonNum, realbutton = n.makeKeyNotWar( yo.healBotka["key"..i])
		local spell = yo.healBotka["spell"..i]

		if button and button ~= "" and spell and spell ~= "" then

			if strmatch( button, "button") then

			elseif strmatch( button, "wheel") then
				local bmod = strmatch( button, "down") or "up"
				ret = format("%sself:SetBindingClick( true, \"%s\", self:GetName(), \"%s\");\n", ret, realbutton, modder .. "wheel" .. bmod);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, button);

			elseif strmatch( button, "numpad") then
				ret = format("%sself:SetBindingClick( true, \"%s\", self:GetName(), \"%s\");\n", ret, realbutton, modder .. "numpad" .. buttonNum);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, button);

			else
				ret = format("%sself:SetBindingClick( true, \"%s\", header:GetName(), \"%s\");\n", ret, realbutton, modder .. button);
				cet = format("%sself:ClearBinding( \"%s\");\n", cet, button);
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

n.cleanQuiButton = function(self)
	if self.atributed then
		for k, attr in pairs( self.atributed) do
			--print(k, attr)
			self:SetAttribute( attr, nil)
		end
	end
end

n.makeQuiButton = function ( self )

	self.atributed = self.atributed or {}
	n.cleanQuiButton(self)

	self:SetAttribute("*type1", nil)
	self:SetAttribute("*type2", nil)

	if #yo.healBotka.targ01 > 1 then
	   local button, modder, modName, buttonNum = n.makeKeyNotWar( yo.healBotka.targ01)
		self:SetAttribute( modName .. 'type' .. buttonNum, 'target')
	end

	if #yo.healBotka.menu01 > 1 then
		local button, modder, modName, buttonNum = n.makeKeyNotWar( yo.healBotka.menu01)
		self:SetAttribute( modName .. 'type' .. buttonNum, 'togglemenu')
	end

	for i = 1, 15 do
		local spell 	= yo.healBotka["spell"..i]
		local button 	= yo.healBotka["key"..i]

		if ( button and button ~= "") and ( spell and spell ~= "") then
			local takeTarget 	= yo.healBotka.takeTarget and "/target mouseover\n" or ""
			local beforCast 	= yo.healBotka["bStop" .. i]  and "/stopcasting\n" or ""
			beforCast = beforCast .. takeTarget

			if yo.healBotka["bTrink" .. i] then
				beforCast =  beforCast .. "/console Sound_EnableSFX 0\n"
				beforCast =  beforCast .. "/use [combat] 13\n"
				beforCast =  beforCast .. "/use [combat] 14\n"
				beforCast =  beforCast .. "/console Sound_EnableSFX 1\n"
				beforCast =  beforCast .. "/run UIErrorsFrame:Clear()\n"
			end

			local macroAttr, macroButton = n.makeMacroButton( button)
			self:SetAttribute( macroAttr, "macro")
			self:SetAttribute( macroButton, beforCast .. "/cast [help,nodead,@mouseover] " .. spell)

			tinsert( self.atributed, macroAttr)
			tinsert( self.atributed, macroButton)
		end
	end
end

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