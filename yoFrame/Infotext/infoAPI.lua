local L, yo, n = unpack( select( 2, ...))

--if not yo.InfoTexts.enable then return end
local _G = _G

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GameTooltip, Round, nums, wipe, IsShiftKeyDown, spairs, WorldFrame, SecondsToClocks, rawset
	= GameTooltip, Round, nums, wipe, IsShiftKeyDown, spairs, WorldFrame, SecondsToClocks, rawset

local infoText = n.infoTexts

local time, max, strjoin, format, find, GetSpellInfo, gsub
	= time, max, strjoin, format, find, GetSpellInfo, gsub

local mt = {}
infoText.infosSorted = {}

function mt.__newindex(self, key, value)
	table.insert( infoText.infosSorted, key)
	rawset( self, key, value)
end

infoText.texts = setmetatable({}, mt)
infoText.texts["1empty"]= "--NONE--"

infoText.pets = {}
infoText.petBlacklist 	= {}
infoText.strIcon 		= "|T%s:14:14:0:0:64:64:10:54:10:54|t %s %-3s" --|cff888888
infoText.damag 			= "%s (%.1f%%)"
infoText.displayString 	= "%s: ".. n.myColorStr .. "%s%s|r"
infoText.parentCount 	= yo.InfoTexts.countLeft
infoText.shift 			= 0

infoText.spellSchool = {
	[-1]=   {name = STRING_SCHOOL_PHYSICAL, 	formated = "|cFFFFFFFF" .. STRING_SCHOOL_PHYSICAL 	.. "|r", 	hex = "FFFFFF00", rgb = {255, 255, 255},	decimals = {1.00, 1.00, 1.00}},
	[0] =   {name = STRING_SCHOOL_PHYSICAL, 	formated = "|cFFFFFFFF" .. STRING_SCHOOL_PHYSICAL 	.. "|r", 	hex = "FFFFFF00", rgb = {255, 255, 255},	decimals = {1.00, 1.00, 1.00}},
	[1] =   {name = STRING_SCHOOL_PHYSICAL, 	formated = "|cFFFFFF00" .. STRING_SCHOOL_PHYSICAL 	.. "|r", 	hex = "FFFFFF00", rgb = {255, 255, 0}, 		decimals = {1.00, 1.00, 0.00}},
	[2] =   {name = STRING_SCHOOL_HOLY , 		formated = "|cFFFFE680" .. STRING_SCHOOL_HOLY 		.. "|r", 	hex = "FFFFE680", rgb = {255, 230, 128},	decimals = {1.00, 0.90, 0.50}},
	[4] =   {name = STRING_SCHOOL_FIRE , 		formated = "|cFFFF8000" .. STRING_SCHOOL_FIRE 		.. "|r", 	hex = "FFFF8000", rgb = {255, 128, 0}, 		decimals = {1.00, 0.50, 0.00}},
	[8] =   {name = STRING_SCHOOL_NATURE , 		formated = "|cFFbeffbe" .. STRING_SCHOOL_NATURE 	.. "|r", 	hex = "FFbeffbe", rgb = {190, 190, 190}, 	decimals = {0.7451, 1.0000, 0.7451}},
	[16] =  {name = STRING_SCHOOL_FROST, 		formated = "|cFF80FFFF" .. STRING_SCHOOL_FROST 		.. "|r", 	hex = "FF80FFFF", rgb = {128, 255, 255}, 	decimals = {0.50, 1.00, 1.00}},
	[32] =  {name = STRING_SCHOOL_SHADOW, 		formated = "|cFF8080FF" .. STRING_SCHOOL_SHADOW 	.. "|r", 	hex = "FF8080FF", rgb = {128, 128, 255}, 	decimals = {0.50, 0.50, 1.00}},
	[64] =  {name = STRING_SCHOOL_ARCANE, 		formated = "|cFFFF80FF" .. STRING_SCHOOL_ARCANE 	.. "|r", 	hex = "FFFF80FF", rgb = {255, 128, 255}, 	decimals = {1.00, 0.50, 1.00}},
	[3] =   {name = STRING_SCHOOL_HOLYSTRIKE , 	formated = "|cFFFFF240" .. STRING_SCHOOL_HOLYSTRIKE .. "|r", 	hex = "FFFFF240", rgb = {255, 64, 64}, 		decimals = {1.0000, 0.9490, 0.2510}},--#FFF240
	[5] =   {name = STRING_SCHOOL_FLAMESTRIKE, 	formated = "|cFFFFB900" .. STRING_SCHOOL_FLAMESTRIKE.. "|r", 	hex = "FFFFB900", rgb = {255, 0, 0}, 		decimals = {1.0000, 0.7255, 0.0000}},--#FFB900
	[6] =   {name = STRING_SCHOOL_HOLYFIRE , 	formated = "|cFFFFD266" .. STRING_SCHOOL_HOLYFIRE  	.. "|r", 	hex = "FFFFD266", rgb = {255, 102, 102}, 	decimals = {1.0000, 0.8235, 0.4000}},--#FFD266
	[9] =   {name = STRING_SCHOOL_STORMSTRIKE, 	formated = "|cFFAFFF23" .. STRING_SCHOOL_STORMSTRIKE.. "|r", 	hex = "FFAFFF23", rgb = {175, 35, 35}, 		decimals = {0.6863, 1.0000, 0.1373}},--#AFFF23
	[10] =  {name = STRING_SCHOOL_HOLYSTORM , 	formated = "|cFFC1EF6E" .. STRING_SCHOOL_HOLYSTORM  .. "|r", 	hex = "FFC1EF6E", rgb = {193, 110, 110}, 	decimals = {0.7569, 0.9373, 0.4314}},--#C1EF6E
	[12] =  {name = STRING_SCHOOL_FIRESTORM, 	formated = "|cFFAFB923" .. STRING_SCHOOL_FIRESTORM 	.. "|r", 	hex = "FFAFB923", rgb = {175, 35, 35}, 		decimals = {0.6863, 0.7255, 0.1373}},--#AFB923
	[17] =  {name = STRING_SCHOOL_FROSTSTRIKE , formated = "|cFFB3FF99" .. STRING_SCHOOL_FROSTSTRIKE.. "|r", 	hex = "FFB3FF99", rgb = {179, 153, 153}, 	decimals = {0.7020, 1.0000, 0.6000}},--#B3FF99
	[18] =  {name = STRING_SCHOOL_HOLYFROST , 	formated = "|cFFCCF0B3" .. STRING_SCHOOL_HOLYFROST  .. "|r", 	hex = "FFCCF0B3", rgb = {204, 179, 179}, 	decimals = {0.8000, 0.9412, 0.7020}},--#CCF0B3
	[20] =  {name = STRING_SCHOOL_FROSTFIRE, 	formated = "|cFFC0C080" .. STRING_SCHOOL_FROSTFIRE 	.. "|r", 	hex = "FFC0C080", rgb = {192, 128, 128}, 	decimals = {0.7529, 0.7529, 0.5020}},--#C0C080
	[24] =  {name = STRING_SCHOOL_FROSTSTORM, 	formated = "|cFF69FFAF" .. STRING_SCHOOL_FROSTSTORM .. "|r", 	hex = "FF69FFAF", rgb = {105, 175, 175}, 	decimals = {0.4118, 1.0000, 0.6863}},--#69FFAF
	[33] =  {name = STRING_SCHOOL_SHADOWSTRIKE, formated = "|cFFC6C673" .. STRING_SCHOOL_SHADOWSTRIKE.."|r", 	hex = "FFC6C673", rgb = {198, 115, 115}, 	decimals = {0.7765, 0.7765, 0.4510}},--#C6C673
	[34] =  {name = STRING_SCHOOL_SHADOWHOLY, 	formated = "|cFFD3C2AC" .. STRING_SCHOOL_SHADOWHOLY .. "|r", 	hex = "FFD3C2AC", rgb = {211, 172, 172}, 	decimals = {0.8275, 0.7608, 0.6745}},--#D3C2AC
	[36] =  {name = STRING_SCHOOL_SHADOWFLAME , formated = "|cFFB38099" .. STRING_SCHOOL_SHADOWFLAME.. "|r", 	hex = "FFB38099", rgb = {179, 153, 153}, 	decimals = {0.7020, 0.5020, 0.6000}},--#B38099
	[40] =  {name = STRING_SCHOOL_SHADOWSTORM, 	formated = "|cFF6CB3B8" .. STRING_SCHOOL_SHADOWSTORM.. "|r", 	hex = "FF6CB3B8", rgb = {108, 184, 184}, 	decimals = {0.4235, 0.7020, 0.7216}},--#6CB3B8
	[48] =  {name = STRING_SCHOOL_SHADOWFROST , formated = "|cFF80C6FF" .. STRING_SCHOOL_SHADOWFROST.. "|r", 	hex = "FF80C6FF", rgb = {128, 255, 255}, 	decimals = {0.5020, 0.7765, 1.0000}},--#80C6FF
	[65] =  {name = STRING_SCHOOL_SPELLSTRIKE, 	formated = "|cFFFFCC66" .. STRING_SCHOOL_SPELLSTRIKE.. "|r", 	hex = "FFFFCC66", rgb = {255, 102, 102}, 	decimals = {1.0000, 0.8000, 0.4000}},--#FFCC66
	[66] =  {name = STRING_SCHOOL_DIVINE, 		formated = "|cFFFFBDB3" .. STRING_SCHOOL_DIVINE 	.. "|r", 	hex = "FFFFBDB3", rgb = {255, 179, 179}, 	decimals = {1.0000, 0.7412, 0.7020}},--#FFBDB3
	[68] =  {name = STRING_SCHOOL_SPELLFIRE, 	formated = "|cFFFF808C" .. STRING_SCHOOL_SPELLFIRE 	.. "|r", 	hex = "FFFF808C", rgb = {255, 140, 140}, 	decimals = {1.0000, 0.5020, 0.5490}},--#FF808C
	[72] =  {name = STRING_SCHOOL_SPELLSTORM, 	formated = "|cFFAFB9AF" .. STRING_SCHOOL_SPELLSTORM .. "|r", 	hex = "FFAFB9AF", rgb = {175, 175, 175}, 	decimals = {0.6863, 0.7255, 0.6863}},--#AFB9AF
	[80] =  {name = STRING_SCHOOL_SPELLFROST , 	formated = "|cFFC0C0FF" .. STRING_SCHOOL_SPELLFROST .. "|r", 	hex = "FFC0C0FF", rgb = {192, 255, 255}, 	decimals = {0.7529, 0.7529, 1.0000}},--#C0C0FF
	[96] =  {name = STRING_SCHOOL_SPELLSHADOW, 	formated = "|cFFB980FF" .. STRING_SCHOOL_SPELLSHADOW.. "|r", 	hex = "FFB980FF", rgb = {185, 255, 255}, 	decimals = {0.7255, 0.5020, 1.0000}},--#B980FF
	[28] =  {name = STRING_SCHOOL_ELEMENTAL, 	formated = "|cFF0070DE" .. STRING_SCHOOL_ELEMENTAL 	.. "|r", 	hex = "FF0070DE", rgb = {0, 222, 222}, 		decimals = {0.0000, 0.4392, 0.8706}},
	[124] = {name = STRING_SCHOOL_CHROMATIC, 	formated = "|cFFC0C0C0" .. STRING_SCHOOL_CHROMATIC 	.. "|r", 	hex = "FFC0C0C0", rgb = {192, 192, 192}, 	decimals = {0.7529, 0.7529, 0.7529}},
	[126] = {name = STRING_SCHOOL_MAGIC , 		formated = "|cFF1111FF" .. STRING_SCHOOL_MAGIC  	.. "|r", 	hex = "FF1111FF", rgb = {17, 255, 255}, 	decimals = {0.0667, 0.0667, 1.0000}},
	[127] = {name = STRING_SCHOOL_CHAOS, 		formated = "|cFFFF1111" .. STRING_SCHOOL_CHAOS 		.. "|r", 	hex = "FFFF1111", rgb = {255, 17, 17}, 		decimals = {1.0000, 0.0667, 0.0667}},
	--[[custom]]
	[1024] = {name = "Reflection", 				formated = "|cFFFFFFFF" .. "Reflection" 			.. "|r", 	hex = "FFFFFFFF", rgb = {255, 255, 255}, 	decimals = {1, 1, 1}},
}

function infoText:reset( infos)
	--dprint("RESET")
	infos.combatTime, infos.amountTotal, infos.newFight = 0, 0, false
	wipe( infos.spellInfo)
	wipe( infos.spellDamage)
end

function infoText:start( infos)
	infos.newFight 		= true
	infos.inCombat 		= true
	infos.combatTime 	= 0
	infos.timeBegin 	= time()

	if infos.timerDPS then infos.timerDPS:Cancel() end

	infos.timerDPS 	= C_Timer.NewTicker( 1, function() infoText:getDPS( infos) end)
end

function infoText:stop( infos)
	--dprint( "STOPED")
	infos.inCombat = false
	if infos.timerDPS then infos.timerDPS:Cancel() end
end


function infoText:checkNewSpell( sourceGUID, spellId, spellName, spellDMG, over, school, spellCrit)

	local over = over == -1 and 0 or over or 0
	--print(spellId, spellName, spellDMG, over, school)
	if spellDMG - over == 0 then return end

	if self.newFight then infoText:reset( self) end

	if not self.spellDamage[spellName] then
		self.spellDamage[spellName]		= 0
		self.spellInfo[spellName] 		= {}
		self.spellInfo[spellName].count	= 0
		self.spellInfo[spellName].id	= spellId
		self.spellInfo[spellName].school= school
		self.spellInfo[spellName].crit	= 0
	end
	--print( spellName, spellCrit, self.spellInfo[spellName].crit)
	self.spellInfo[spellName].count = self.spellInfo[spellName].count 	+ 1
	self.spellInfo[spellName].crit 	= spellCrit and self.spellInfo[spellName].crit + 1 or self.spellInfo[spellName].crit
	self.spellDamage[spellName] 	= self.spellDamage[spellName] 		+ spellDMG - ( over or 0)
	self.amountTotal = self.amountTotal + spellDMG - ( over or 0)
end


function infoText:checkPets( serial)
	--n.scanTooltip:SetOwner (WorldFrame, "ANCHOR_NONE")
	--n.scanTooltip:SetHyperlink ("unit:" .. serial or "")

	--local line1 = _G ["yoFrame_STTTextLeft2"]
	--local text1 = line1 and line1:GetText()
	--if (text1 and text1 ~= "") then
	--	local playerName = n.myName
	--	playerName = playerName:gsub ("%-.*", "") --remove realm name
	--	if text1:find( playerName) then
	--		self.pets[serial] = true
	--	end
	--end

	--local line2 = _G ["yoFrame_STTTextLeft3"]
	--local text2 = line2 and line2:GetText()
	--if (text2 and text2 ~= "") then
	--	local playerName = n.myName
	--	playerName = playerName:gsub ("%-.*", "") --remove realm name
	--	if text2:find( playerName) then
	--		self.pets[serial] = true
	--	end
	--end

	self.pets[serial] = true 	---------------------!!!!!!!!!!!!!!
	self.petBlacklist[serial] = true
end


function infoText:getDPS( infos)

	if infos.newFight then return end

	local DPS = 0
	infos.combatTime = time() - infos.timeBegin

	if infos.amountTotal ~= 0 and infos.combatTime ~= 0 then
		DPS = infos.amountTotal / infos.combatTime
	end

	infos.Text:SetFormattedText( self.displayString, infos.displayName, nums( DPS), "") --, SecondsToClocks( infos.combatTime))
end


function infoText:onEnter( infos)
	GameTooltip:SetOwner( infos, "ANCHOR_TOP", 0, 6);
	GameTooltip:ClearLines()
	GameTooltip:AddLine( n.myColorStr .. L.dpsHeader)
	local ind = 1
	local shift = 2.9
	local stoPerc
	for spellName, data in spairs( infos.spellDamage, function(t,a,b) return t[b] < t[a] end) do

    	local _, _, icon = GetSpellInfo( infos.spellInfo[spellName].id)
		local col  = self.spellSchool[ infos.spellInfo[spellName].school].decimals		-- CombatLog_Color_ColorArrayBySchool( self.spellsSchool[spellID]) --COMBATLOG_DEFAULT_COLORS.schoolColoring[self.spellsSchool[spellID]
		local perc = infos.amountTotal * data == 0 and 0 or 100 / infos.amountTotal * data
    	if ind == 1 then
    		stoPerc = 100 / perc * shift
			GameTooltip:AddLine(" ")
			ind = nil
		end

		local crit  = ( IsShiftKeyDown() and infos.spellInfo[spellName].crit > 0) and " |cffffff00*" ..infos.spellInfo[spellName].crit .. " |r" or ""
		local count = IsShiftKeyDown() and infos.spellInfo[spellName].count .. crit or " "

		GameTooltip:AddDoubleLine( format( self.strIcon, icon, spellName, count) , format( self.damag, nums( data), perc), col[1], col[2], col[3], col[1], col[2], col[3])

    	if IsShiftKeyDown() then
    		local strPerc = ""
    		for i= 1, Round( stoPerc * perc) do strPerc = strPerc .. "|" end
    		GameTooltip:AddLine(strPerc, col[1], col[2], col[3])
    	end
	end

	if IsShiftKeyDown() then
		local strPerc = ""
   		for i= 1, 100 * shift do strPerc = strPerc .. "|" end
   		GameTooltip:AddLine(strPerc, 0.09, 0.09, 0.09)
   	else
		GameTooltip:AddLine(" ")
	end

	GameTooltip:AddDoubleLine( L.dpsFooter, format( "%s / %s%s", nums( infos.amountTotal), nums( infos.amountTotal / ( infos.combatTime+0.01)), SecondsToClocks( infos.combatTime)), nil, nil, nil, 0, 1, 1)
	if not IsShiftKeyDown() then
		GameTooltip:AddLine( L.dpsInfo, 0.3, 0.3, 0.3)
	end
	GameTooltip:Show()
end


--local function GetUnitInfoByUnitFlag(unitFlag,infoType)
--	--> TYPE
--	if infoType == 1 then
--		return bit_band(unitFlag,COMBATLOG_OBJECT_TYPE_MASK)
--		--[1024]="player", [2048]="NPC", [4096]="pet", [8192]="GUARDIAN", [16384]="OBJECT"

--	--> CONTROL
--	elseif infoType == 2 then
--		return bit_band(unitFlag,COMBATLOG_OBJECT_CONTROL_MASK)
--		--[256]="by players", [512]="by NPC",

--	--> REACTION
--	elseif infoType == 3 then
--		return bit_band(unitFlag,COMBATLOG_OBJECT_REACTION_MASK)
--		--[16]="FRIENDLY", [32]="NEUTRAL", [64]="HOSTILE"

--	--> Controller affiliation
--	elseif infoType == 4 then
--		return bit_band(unitFlag,COMBATLOG_OBJECT_AFFILIATION_MASK)
--		--[1]="player", [2]="PARTY", [4]="RAID", [8]="OUTSIDER"

--	--> Special
--	elseif infoType == 5 then
--		return bit_band(unitFlag,COMBATLOG_OBJECT_SPECIAL_MASK)
--		--Not all !  [65536]="TARGET", [131072]="FOCUS", [262144]="MAINTANK", [524288]="MAINASSIST"
--	end
--end