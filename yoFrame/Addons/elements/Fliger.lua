local L, yo, N = unpack( select( 2, ...))

local lib = LibStub("LibCooldown")
if not lib then error("CooldownFlash requires LibCooldown") return end

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local UnitAura, GetItemInfo, GetSpellInfo, GetSpecialization
	= UnitAura, GetItemInfo, GetSpellInfo, GetSpecialization

N.PlayerProcWhiteList = {}
N.DebuffPlayerTargetList = {}

N.filgerBuffSpells = {
	--[205473] 	= 5,
}
local pStr = "Дано: |cffffff00%s,|r А получилось: |cff00ffff%s|r >= |cff00ffff%d|r стаков"

local atemp = {}
for buffCount in string.gmatch( yo.fliger.fligerBuffCount, "(%d+)" ) do
    table.insert( atemp, tonumber(buffCount) or 1)
    --print( tonumber(buffCount))
end

local str = string.gsub( yo.fliger.fligerBuffSpell, "\n", ",")  -- чистим перенос строки
local index = 1
for buffSpell in string.gmatch( str, "%s*(%P+)" ) do   			-- без пробелов впереди по знакам препинания
    buffSpell = string.gsub( buffSpell, "%s+$", "" ) 			-- чистим пробелы сзади
    local spellName = select( 1, GetSpellInfo( buffSpell))
    local spellCount = atemp[index]

    if spellName and spellCount then
    	N.filgerBuffSpells[spellName] = spellCount
    end

    print( format( pStr, buffSpell or "Error", spellName or "Error", atemp[index]) or 0)--N.filgerBuffSpells
    index = index + 1
end

local function UpdateAura( self, unit)
	local fligerTD, fligerTB, fligerPB, fligerPD, fligerProc = 1, 1, 1, 1, 1

	-- DEBUFFS
	local index = 1
	local filter = "HARMFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if yo.fliger.tDebuffEnable then
			if unit == self.tDebuff.unit and caster == "player"	and N.DebuffPlayerTargetList then -- N.DebuffWhiteList[name] then
				--if not self.tDebuff[fligerTD] then self.tDebuff[fligerTD] = N.createAuraIcon( self.tDebuff, fligerTD) end

				N.updateAuraIcon( N.createAuraIcon( self.tDebuff, fligerTD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerTD = fligerTD + 1
			end
		end

		if yo.fliger.pDebuffEnable then
			if unit == self.pDebuff.unit and not N.blackSpells[spellID] then
			--if unit == self.pDebuff.unit and N.RaidDebuffList[spellID] then
				--if not self.pDebuff[fligerPD] then self.pDebuff[fligerPD] = N.createAuraIcon( self.pDebuff, fligerPD) end
				N.updateAuraIcon( N.createAuraIcon( self.pDebuff, fligerPD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerPD = fligerPD + 1
			end
		end

		index = index + 1
	end

	-- BUFFS
	local index = 1
	local filter = "HELPFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if yo.fliger.tDebuffEnable then
			if unit == self.tDebuff.unit and caster == "player" and N.BuffWhiteList[name] then
				N.updateAuraIcon( N.createAuraIcon( self.tDebuff, fligerTD), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerTD = fligerTD + 1
			end
		end

		if yo.fliger.pBuffEnable then
			if unit == self.pBuff.unit and N.PlayerBuffWhiteList[name] then
				N.updateAuraIcon( N.createAuraIcon( self.pBuff, fligerPB), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerPB = fligerPB + 1
			end
		end

		if yo.fliger.pProcEnable then
			if unit == self.pProc.unit and N.PlayerProcWhiteList[spellID] then
				N.updateAuraIcon( N.createAuraIcon( self.pProc, fligerProc), filter, icon, count, nil, duration, expirationTime, spellID, index, name)
				fligerProc = fligerProc + 1
			end
		end

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
	local frame = _G["yo_Fliger"]
	local fligerPCD = 1
	local icon

	--if watched then tprint(watched) end

	for id, val in pairs( watched) do
		local starttime = val.start
		local duration = val.duration
		local class = val.class
		local expirationTime = starttime + duration
		if class == "item" then
			icon = select( 10, GetItemInfo( id))
		else
			icon = select( 3, GetSpellInfo( id))
		end
		if starttime ~= 0 and duration  >= yo.fliger.pCDTimer then
			--print(id, val.start, val.duration)
			--if not frame.pCD[fligerPCD] then frame.pCD[fligerPCD] = N.createAuraIcon( frame.pCD, fligerPCD)end
			N.updateAuraIcon( N.createAuraIcon( frame.pCD, fligerPCD), "HELPFUL", icon, 0, nil, duration, expirationTime, id, fligerPCD)
			fligerPCD = fligerPCD + 1
		end
	end

	if frame.pCD then for index = fligerPCD,	#frame.pCD	do frame.pCD[index]:Hide() end end
end

local function MakeFligerFrame( self)
	local pdebuffSize 	= yo.fliger.pDebuffSize
	local tdebuffSize 	= yo.fliger.tDebuffSize
	local pbuffSize 	= yo.fliger.pBuffSize
	local pProcSize		= yo.fliger.pProcSize
	local cdSize		= yo.fliger.pCDSize

	if yo.fliger.tDebuffEnable then
		CreateAnchor("T_DEBUFF",			"Target Debuff/Buff ", 		tdebuffSize, tdebuffSize,	450, 	0, 		"CENTER", "CENTER")
		local tDebuff = CreateFrame("Frame", nil, self)
		tDebuff:SetPoint("CENTER", T_DEBUFF, "CENTER",  0, 0)
		tDebuff:SetWidth( tdebuffSize)
		tDebuff:SetHeight( tdebuffSize)
		tDebuff.direction 	= yo.fliger.tDebuffDirect
		tDebuff.unit 		= "target"
		self.tDebuff 		= tDebuff
	end

	if yo.fliger.pProcEnable then
		CreateAnchor("P_PROC", 				"Player Trinkets Procs", 	pProcSize, pProcSize,	-450, 	-100, 	"CENTER", "CENTER")
		local pProc = CreateFrame("Frame", nil, self)
		pProc:SetPoint("CENTER", P_PROC, "CENTER",  0, 0)
		pProc:SetWidth( pProcSize)
		pProc:SetHeight( pProcSize)
		pProc.direction = yo.fliger.pProcDirect
		pProc.unit 		= "player"
		self.pProc 		= pProc
	end

	if yo.fliger.pBuffEnable then
		CreateAnchor("P_BUFF", 				"Player Buff", 				pbuffSize, pbuffSize,	-450, 	0, 		"CENTER", "CENTER")
		local pBuff = CreateFrame("Frame", nil, self)
		pBuff:SetPoint("CENTER", P_BUFF, "CENTER",  0, 0)
		pBuff:SetWidth( pbuffSize)
		pBuff:SetHeight( pbuffSize)
		pBuff.direction 	= yo.fliger.pBuffDirect
		pBuff.hideTooltip	= true
		pBuff.unit 			= "player"
		pBuff.countGlow 	= yo.fliger.fligerBuffGlow
		pBuff.countAnim 	= yo.fliger.fligerBuffAnim
		pBuff.countColor	= true
		pBuff.showBorder	= nil--"border"
		pBuff.countFilter 	= N.filgerBuffSpells
		self.pBuff 			= pBuff
	end

	if yo.fliger.pDebuffEnable then
		CreateAnchor("P_DEBUFF",			"Player Debuff",			pdebuffSize,	pdebuffSize,-450, 	150, 	"CENTER", "CENTER")
		local pDebuff = CreateFrame("Frame", nil, self)
		pDebuff:SetPoint("CENTER", P_DEBUFF, "CENTER",  0, 0)
		pDebuff:SetWidth( pdebuffSize)
		pDebuff:SetHeight( pdebuffSize)
		pDebuff.direction 	= yo.fliger.pBuffDirect
		pDebuff.unit 		= "player"
		self.pDebuff 		= pDebuff
	end

	if yo.fliger.pCDEnable then
		CreateAnchor("P_CD", 				"Players Cooldowns",		cdSize,	cdSize,	20, 	0, 		"TOPLEFT", "TOPRIGHT", LeftDataPanel)
		local pCD = CreateFrame("Frame", nil, self)
		pCD:SetPoint("CENTER", P_CD, "CENTER",  0, 0)
		pCD:SetWidth( cdSize)
		pCD:SetHeight( cdSize)
		pCD.direction 	= yo.fliger.pCDDirect
		pCD.hideTooltip = true
		pCD.unit 		= "player"
		self.pCD 		= pCD
	end
end

local function CheckClassTemplates( myClass, mySpec)

	if mySpec == 5 then return 	end

	for i,v in pairs( N.templates.class[myClass][mySpec][1]["args"]) do
		local spellId = GetSpellInfo( v.spell)
		if spellId then
			N.PlayerBuffWhiteList[spellId] = true
		else
			--print("Spell ".. v.spell .. " removed from his game...")
		end
	end

	if N.templates.class[myClass][mySpec][5]["args"] then
		for i,v in pairs( N.templates.class[myClass][mySpec][5]["args"]) do
			local spellId = GetSpellInfo( v.spell)
			if spellId then
				N.PlayerBuffWhiteList[spellId] = true
			end
		end
	end

	for i,v in pairs( N.PlayerBuffWhiteListAll) do
		N.PlayerBuffWhiteList[GetSpellInfo( i)] = v
	end

	N.DebuffPlayerTargetList = {}
	for i,v in pairs( N.templates.class[myClass][mySpec][2]["args"]) do
		if GetSpellInfo( v.spell) then
			--print( v.spell, myClass, mySpec, GetSpellInfo( v.spell))
			N.DebuffPlayerTargetList[GetSpellInfo( v.spell)] = true
		end
	end
end


local function CheckTemplates( myClass, mySpec)

	for i, v in pairs( N.templates.items) do N.PlayerProcWhiteList[ v] = true end

	--if N.templates.items[2] then
	--	for i,v in pairs( N.templates.items[2]["args"]) do
	--		local spellId = GetSpellInfo( v.spell)
	--		if spellId then PlayerProcWhiteList[spellId] = true end
	--	end

	--	for i,v in pairs( N.templates.items[3]["args"]) do PlayerProcWhiteList[v.title] = true 	end
	--	for i,v in pairs( N.templates.items[4]["args"]) do PlayerProcWhiteList[v.title] = true 	end

	--	wipe( N.templates.items)
	--end

	--if N.templates.spell_covenant and yo.fliger.gAzetit then
	--	for i,v in pairs( generalAzeriteTraits) do
	--		local spellId = GetSpellInfo( v.spell)
	--		if spellId then PlayerProcWhiteList[spellId] = true end
	--	end
	--	wipe( generalAzeriteTraits)
	--end

	CheckClassTemplates( myClass, mySpec)
end


local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.fliger.enable then return end

		MakeFligerFrame( self)
		CheckTemplates( myClass, GetSpecialization())

		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterUnitEvent("UNIT_AURA", "player", "target")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

		if yo.fliger.pCDEnable then
			lib:RegisterCallback("start", function( id, duration, class, watched) UpdatePCD( watched) end)
			lib:RegisterCallback("stop", function(id, class, watched) UpdatePCD( watched) end)
		end

	elseif event == "UNIT_AURA" then
		UpdateAura( self, ...)
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdateAura( self, "target")
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		mySpec = GetSpecialization()
		CheckClassTemplates( myClass, mySpec)
	end
end

local Fliger = CreateFrame("Frame", "yo_Fliger", UIParent)
--fliger:SetFrameStrata("BACKGROUND")
Fliger:SetFrameLevel( 0)
Fliger:RegisterEvent("PLAYER_ENTERING_WORLD")
Fliger:SetScript("OnEvent", OnEvent)

--CreateAnchor("SPECIAL_P_BUFF_ICON_Anchor", "SPECIAL_P_BUFF",	C["filger"].buffs_size, C["filger"].buffs_size,			-300, -50, "CENTER", "CENTER")
