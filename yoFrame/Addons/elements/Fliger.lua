local L, yo, n = unpack( select( 2, ...))

--if not yo.fliger.enable then return end

local _G = _G
local lib = n.LIBS.LibCooldown

local fliger = CreateFrame( "Frame", "yo_Fliger", UIParent)
n.Addons.fliger = fliger

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local UnitAura, GetItemInfo, GetSpellInfo, GetSpecialization, print, CreateFrame, tinsert, wipe, GetTime, Countdown
	= UnitAura, GetItemInfo, GetSpellInfo, GetSpecialization, print, CreateFrame, tinsert, wipe, GetTime, Countdown

------------------------------------------------------------------------------------------------------------
---								Buf Icons Anime
------------------------------------------------------------------------------------------------------------
n.playerProcWhiteList = {}
n.targetDebuffList = {}
n.filgerBuffSpells = {}
local icons = {}

--local pStr = "Дано: |cffffff00%s,|r А получилось: |cff00ffff%s|r >= |cff00ffff%d|r стаков"
--local pStrErr = "Дано: |cffff0000%s,|r А получилось: |cffff0000%s|r >= |cffff0000%d|r стаков"

local function checkAnimeSpells()
	wipe( n.filgerBuffSpells)

	local str = 	gsub( yo.fliger.fligerBuffCount, "\n", ";") -- чистим перенос строки
	local buffStr = { strsplit( ";", str) }

	local str = gsub( yo.fliger.fligerBuffSpell, "\n", ",")  	-- чистим перенос строки
	local index = 1
	for spellName in gmatch( str, "%s*(%P+)" ) do   			-- без пробелов впереди по знакам препинания
    	spellName = gsub( spellName, "%s+$", "" ) 				-- чистим пробелы сзади
    	--local spellName = select( 1, GetSpellInfo( buffSpell))
    	local spellCount = buffStr[index]

    	if spellName and spellCount then

    		local spellTimer = spellCount:find( "t") and tonumber( match( spellCount, "t(%d+)")) or nil
    		local spellStack = spellCount:find( "s") and tonumber( match( spellCount, "s(%d+)")) or nil

    		n.filgerBuffSpells[spellName] 		= n.filgerBuffSpells[spellName] or {}
    		n.filgerBuffSpells[spellName].timer = spellTimer and spellTimer or nil
    		n.filgerBuffSpells[spellName].stack = spellStack and spellStack or nil
    	end

    	index = index + 1
	end
end

------------------------------------------------------------------------------------------------------------
---
------------------------------------------------------------------------------------------------------------
local function UpdateAura( self, unit)
	local fligerTD, fligerTB, fligerPB, fligerPD, fligerProc = 1, 1, 1, 1, 1

	-- DEBUFFS
	local index = 1
	local filter = "HARMFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if self.tDebuff then
			if unit == self.tDebuff.unit and caster == "player"	and n.targetDebuffList then -- n.DebuffWhiteList[name] then
				--if not self.tDebuff[fligerTD] then self.tDebuff[fligerTD] = n.createAuraIcon( self.tDebuff, fligerTD) end

				n.updateAuraIcon( n.createAuraIcon( self.tDebuff, fligerTD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerTD = fligerTD + 1
			end
		end

		if self.pDebuff and unit == self.pDebuff.unit then
			if  not n.blackSpells[spellID] then
			--if unit == self.pDebuff.unit and n.RaidDebuffList[spellID] then
				--if not self.pDebuff[fligerPD] then self.pDebuff[fligerPD] = n.createAuraIcon( self.pDebuff, fligerPD) end
				n.updateAuraIcon( n.createAuraIcon( self.pDebuff, fligerPD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerPD = fligerPD + 1
			end
		end

		if n.alertCasts[spellID] and unit == "player" and expirationTime > GetTime() then Countdown( spellID, expirationTime - GetTime(), n.alertCasts[spellID].text, n.alertCasts[spellID].sec) end

		index = index + 1
	end

	-- BUFFS
	local index = 1
	local filter = "HELPFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if self.tDebuff then
			if unit == self.tDebuff.unit and caster == "player" and n.BuffWhiteList[name] then
				n.updateAuraIcon( n.createAuraIcon( self.tDebuff, fligerTD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerTD = fligerTD + 1
			end
		end

		if self.pBuff and unit == self.pBuff.unit then
			if n.playerBuffList[name] then
				n.updateAuraIcon( n.createAuraIcon( self.pBuff, fligerPB), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerPB = fligerPB + 1
			end
		end

		if self.pProc then
			if unit == self.pProc.unit and n.playerProcWhiteList[spellID] then
				n.updateAuraIcon( n.createAuraIcon( self.pProc, fligerProc), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerProc = fligerProc + 1
			end
		end

		if n.alertCasts[spellID] and unit == "player" and expirationTime > GetTime() then Countdown( spellID, expirationTime - GetTime(), n.alertCasts[spellID].text, n.alertCasts[spellID].sec) end

		index = index + 1
	end

	-- CLEARING
	if unit == "target" then
		if self.tDebuff then for index = fligerTD,		#self.tDebuff	do self.tDebuff[index]:Hide() end end

	elseif unit == "player"	then
		if self.pBuff 	then for index = fligerPB,		#self.pBuff		do self.pBuff[index]:Hide()   end end
		if self.pDebuff then for index = fligerPD,		#self.pDebuff	do self.pDebuff[index]:Hide() end end
		if self.pProc 	then for index = fligerProc,	#self.pProc		do self.pProc[index]:Hide()   end end
	end
end

local function UpdatePCD( watched)
	local fligerPCD = 1

	--if watched then tprint(watched) end

	for id, val in pairs( watched) do
		local starttime 	= val.start
		local duration 		= val.duration
		local class 		= val.class
		local expirationTime= starttime + duration

		if class == "item" then
			icons[id] = icons[id] or select( 10, GetItemInfo( id))
		else
			icons[id] = icons[id] or select( 3, GetSpellInfo( id))
		end

		if starttime ~= 0 and duration  >= yo.fliger.pCDTimer then
			n.updateAuraIcon( n.createAuraIcon( fliger.pCD, fligerPCD), "HELPFUL", icons[id], 0, nil, duration, expirationTime, id, fligerPCD)
			fligerPCD = fligerPCD + 1
		end
	end

	if fliger.pCD then for index = fligerPCD,	#fliger.pCD	do fliger.pCD[index]:Hide() end end
end

local function setIcons( self)
	for index, icon in ipairs( self) do
		icon.buffFilter = n.filgerBuffSpells
		icon.doGlowAnim 	= yo.fliger.fligerBuffGlow
		icon.doAlhpaAim 	= yo.fliger.fligerBuffAnim
		icon.doColorAnim	= yo.fliger.fligerBuffColr
		icon:SetSize( self:GetSize())
		n.setIconPosition( self, icon, index)
	end
end

local function clearIcons( self)
end

local function MakeFligerFrame( self)
	local pdebuffSize 	= yo.fliger.pDebuffSize
	local tdebuffSize 	= yo.fliger.tDebuffSize
	local pbuffSize 	= yo.fliger.pBuffSize
	local pProcSize		= yo.fliger.pProcSize
	local cdSize		= yo.fliger.pCDSize

	if yo.fliger.tDebuffEnable then
		n.moveCreateAnchor("T_DEBUFF",			"Target Debuff/Buff ", 		tdebuffSize, tdebuffSize,	300, 	0, 		"CENTER", "CENTER")
		local tDebuff = self.tDebuff or CreateFrame("Frame", nil, self)
		tDebuff:ClearAllPoints()
		tDebuff:SetPoint("CENTER", T_DEBUFF, "CENTER",  0, 0)
		tDebuff:SetWidth( tdebuffSize)
		tDebuff:SetHeight( tdebuffSize)
		tDebuff.direction 	= yo.fliger.tDebuffDirect
		tDebuff.unit 		= "target"
		tDebuff.buffFilter 	= n.filgerBuffSpells
		tDebuff.doGlowAnim 	= yo.fliger.fligerBuffGlow
		tDebuff.doAlhpaAim 	= yo.fliger.fligerBuffAnim
		tDebuff.doColorAnim	= yo.fliger.fligerBuffColr
		self.tDebuff 		= tDebuff
		setIcons( self.tDebuff)
	else
		self.tDebuff = nil
		clearIcons( self.tDebuff)
	end

	if yo.fliger.pProcEnable then
		n.moveCreateAnchor("P_PROC", 				"Player Trinkets Procs", 	pProcSize, pProcSize,	-300, 	-50, 	"CENTER", "CENTER")
		local pProc = self.pProc or CreateFrame("Frame", nil, self)
		pProc:ClearAllPoints()
		pProc:SetPoint("CENTER", P_PROC, "CENTER",  0, 0)
		pProc:SetWidth( pProcSize)
		pProc:SetHeight( pProcSize)
		pProc.direction 	= yo.fliger.pProcDirect
		pProc.unit 			= "player"
		pProc.doGlowAnim 	= yo.fliger.fligerBuffGlow
		pProc.doAlhpaAim 	= yo.fliger.fligerBuffAnim
		pProc.doColorAnim	= yo.fliger.fligerBuffColr
		pProc.showBorder	= nil--"border"
		pProc.buffFilter 	= n.filgerBuffSpells
		self.pProc 			= pProc
	else
		self.pProc = nil
	end

	if yo.fliger.pBuffEnable then
		n.moveCreateAnchor("P_BUFF", 	"Player Buff", 				pbuffSize, pbuffSize,	-300, 	50, 		"CENTER", "CENTER")
		local pBuff = self.pBuff or CreateFrame("Frame", nil, self)
		pBuff:ClearAllPoints()
		pBuff:SetPoint("CENTER", P_BUFF, "CENTER",  0, 0)
		pBuff:SetWidth( pbuffSize)
		pBuff:SetHeight( pbuffSize)
		pBuff.direction 	= yo.fliger.pBuffDirect
		pBuff.hideTooltip	= true
		pBuff.unit 			= "player"
		pBuff.doGlowAnim 	= yo.fliger.fligerBuffGlow
		pBuff.doAlhpaAim 	= yo.fliger.fligerBuffAnim
		pBuff.doColorAnim	= yo.fliger.fligerBuffColr
		pBuff.showBorder	= nil--"border"
		pBuff.buffFilter 	= n.filgerBuffSpells
		self.pBuff 			= pBuff
	end

	if yo.fliger.pDebuffEnable then
		n.moveCreateAnchor("P_DEBUFF",	"Player Debuff",			pdebuffSize,	pdebuffSize,-300, 	150, 	"CENTER", "CENTER")
		local pDebuff = self.pDebuff or CreateFrame("Frame", nil, self)
		pDebuff:ClearAllPoints()
		pDebuff:SetPoint("CENTER", P_DEBUFF, "CENTER",  0, 0)
		pDebuff:SetWidth( pdebuffSize)
		pDebuff:SetHeight( pdebuffSize)
		pDebuff.direction 	= yo.fliger.pBuffDirect
		pDebuff.unit 		= "player"
		self.pDebuff 		= pDebuff
	end

	if yo.fliger.pCDEnable then
		n.moveCreateAnchor("P_CD", 				"Players Cooldowns",		cdSize,	cdSize,	20, 	0, 		"TOPLEFT", "TOPRIGHT", n.infoTexts.LeftDataPanel)
		local pCD = self.pCD or CreateFrame("Frame", nil, self)
		pCD:ClearAllPoints()
		pCD:SetPoint("CENTER", P_CD, "CENTER",  0, 0)
		pCD:SetWidth( cdSize)
		pCD:SetHeight( cdSize)
		pCD.direction 	= yo.fliger.pCDDirect
		pCD.hideTooltip = true
		pCD.unit 		= "player"
		self.pCD 		= pCD
	end
end

local function checkClassTemplates( myClass, mySpec)

	if mySpec == 5 then return 	end

	for i,v in pairs( n.templates.class[n.myClass][n.mySpec][1]["args"]) do
		local spellId = GetSpellInfo( v.spell)
		if spellId then
			n.playerBuffList[spellId] = true
		else
			--print("Spell ".. v.spell .. " removed from his game...")
		end
	end

	if n.templates.class[n.myClass][n.mySpec][5]["args"] then
		for i,v in pairs( n.templates.class[n.myClass][n.mySpec][5]["args"]) do
			local spellId = GetSpellInfo( v.spell)
			if spellId then
				n.playerBuffList[spellId] = true
			end
		end
	end

	for i,v in pairs( n.playerBuffListAll) do n.playerBuffList[GetSpellInfo( i)] = v end

	n.targetDebuffList = {}
	for i,v in pairs( n.templates.class[n.myClass][n.mySpec][2]["args"]) do
		if GetSpellInfo( v.spell) then
			--print( v.spell, n.myClass, n.mySpec, GetSpellInfo( v.spell))
			n.targetDebuffList[GetSpellInfo( v.spell)] = true
		end
	end
end


local function checkTemplates( myClass, mySpec)

	for i, v in pairs( n.templates.items)    			do n.playerProcWhiteList[v] 	  = true end
	for i, v in pairs( n.generalLegendaries) 			do n.playerProcWhiteList[v.spell] = true end
	for i, v in pairs( n.classLegendaries[n.myClass]) 	do n.playerProcWhiteList[v.spell] = true end

	if n.templates.covenants and yo.fliger.gAzetit then

		local covaData = n.templates.covenants[C_Covenants.GetActiveCovenantID()]
		if covaData and covaData.args then
			for k, spellData in pairs( covaData.args) do

				if spellData.class and spellData.class ~= n.myClass then
				else
					if 		spellData.type == "buff" and 	spellData.unit == "player" then n.playerBuffList[ GetSpellInfo( spellData.spell)] = true
					elseif 	spellData.type == "debuff" and 	spellData.unit == "target" then n.targetDebuffList[ GetSpellInfo( spellData.spell)] = true
					--elseif spellData.type == "debuff" and spellData.unit == "player" then n.targetDebuffList[ GetSpellInfo( spellData.spell)] = true
					end
				end
			end
		end

		--wipe( n.templates.covenants)
	end

	checkClassTemplates( n.myClass, n.mySpec)
end

function fliger:updateAllOption()
	if yo.fliger.enable then

		self:SetFrameStrata("BACKGROUND")
		self:SetFrameLevel( 0)

		MakeFligerFrame( self)

		checkTemplates( n.myClass, GetSpecialization())
		checkAnimeSpells()

		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterUnitEvent("UNIT_AURA", "player", "target")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

		if yo.fliger.pCDEnable then
			lib:RegisterCallback("start", function(id, class, watched) UpdatePCD( watched) end)
			lib:RegisterCallback("stop", function(id, class, watched) UpdatePCD( watched) end)
		end

		fliger.checkAnimeSpells 	= checkAnimeSpells
		n.conFuncs.fligerBuffCount 	= n.Addons.fliger.checkAnimeSpells
		n.conFuncs.fligerBuffSpell 	= n.Addons.fliger.checkAnimeSpells
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

		lib:RegisterCallback("start", nil)
		lib:RegisterCallback("stop", nil)
	end
end

local function onEvent( self, event, ...)

	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:updateAllOption()

	elseif event == "UNIT_AURA" then
		UpdateAura( self, ...)
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdateAura( self, "target")
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		n.mySpec = GetSpecialization()
		checkClassTemplates( n.myClass, n.mySpec)
	end
end

fliger:RegisterEvent("PLAYER_ENTERING_WORLD")
fliger:SetScript("OnEvent", onEvent)
