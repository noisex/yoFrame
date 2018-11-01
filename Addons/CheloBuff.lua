local L, yo = unpack( select( 2, ...))

local markPool = {8, 7, 5, 4, 3, 1, 6, 2}
local markIndex = 1

local chatN = "party"
local chatN = "raid"
local chatN = "RAID_WARNING"

--local badCast = {
--	--[8690]		= true,
--	[271296]	= true,	-- 01 - Талок 	: Кровавый Отбойник			2144
--	[264382]	= true, -- 04 - Зек'Воз : Пронзающий Взгляд  		2136
--}

-- useMark, textWarning, withName, channelWarning, markClearDelay, foundTarget, delayAnonce 

local badDBM = {
	["SPELL_AURA_APPLIED"]	= { 
		--[164812] = { 2, "Used moon", true,	"RAID_WARNING"},
		--[164815] = { 2, "Used sun",  true,	"RAID_WARNING"},

		--01 - Талок 	: Выброс Плазмы		2144
		[271224] = { 2, "Выброс начался 1й", true,	"RAID_WARNING"},
		[278888] = { 2, "Выброс начался 2й", true,	"RAID_WARNING"},

		--04 - Зек'Воз 	: Сделка с Осквернителем	2136
		[265662] = { 2, "Сделка осквернителя", true,	"RAID_WARNING"},
		[265363] = { 2, "Тревожный туман", 	true,	"RAID_WARNING"},

		--05 - Вектис 	: Вызревание	1134
		[265212] = { 2, "Какое-то вызревание", true,	"RAID_WARNING"},

 		--06 - Зул Перерожденный : Желание Смерти	2145
		[274271] = { 2, "Скоро диспел: Желание Смерти", true,	"RAID_WARNING"},
		--07 272536
		--[272536] = { 2, "Неизбежное уничтожение", true,	"RAID_WARNING"},
	},     

	["SPELL_AURA_REMOVED"]	= { 
		--[164812] = { 1, "Used sun",  true,	"RAID_WARNING"},
		--[164815] = { 1,  "Used sun",  true,	"RAID_WARNING"},

		--01 - Талок 	: Выброс Плазмы		2144
		[271225] = { 1, "Выброс кончился 1й", 	true,	"RAID_WARNING"},
		[278889] = { 1, "Выброс кончился 2й", 	true,	"RAID_WARNING"},

		--04 - Зек'Воз 	: Воля Осквернителя	2136
		[265646] = { 1, "Воля осквернителя", 	true,	"RAID_WARNING"},
		[265363] = { 1, "Тревожный туман", 		true,	"RAID_WARNING"},

 		--05 - Вектис 	: Вызревание	1134
		[265212] = { 2, "Скоро диспел: Желание Смерти", true,	"RAID_WARNING"},

		--06 - Зул Перерожденный : Желание Смерти	2145
		[274271] = { 1, "Желание Смерти", 		true,	"RAID_WARNING"},
		--07 272536
		--[272536] = { 1, "Неизбежное уничтожение", true,	"RAID_WARNING"},
	},

	["SPELL_CAST_START"]	= { 
		--[5176] = 	{ 0, "Выброс начался", 		false,	"RAID_WARNING"},273554
		[271296] = 	{ 0, "RUN AWAY Кровавый Отбойник", 	false,	"RAID_WARNING"},
		
		[264382] = 	{ 2, "Пронзающий Взгляд", 	true,	"RAID_WARNING", 3, "boss2target"},
		--07 - Митракс Развоплотитель
		[273282] = 	{ 0, "RUN AWAY Разрыв сущности START", false,	"RAID_WARNING"},
		[273538] = 	{ 0, "RUN AWAY уничтожающий-взрыв START", false,	"RAID_WARNING"},
	},

	["SPELL_CAST_SUCCESS"]	= { 
		--[5176] 	= 	{ 2, "Выброс кончился 1й", 	true,	"RAID_WARNING", 3},
		--277973 - 7	269827 - 15
		[277973] = 	{ 0, "Ульдирский защитный луч Нормал",	false,	"RAID_WARNING"},
		[269827] = 	{ 0, "Ульдирский защитный луч Героик",	false,	"RAID_WARNING"},
		
		[268253] = 	{ 0, "Ульдирский защитный луч",	false,	"RAID_WARNING"},
		[268245] = 	{ 0, "Ульдирский защитный луч",	false,	"RAID_WARNING"},
		--[264382] = 	{ 2, "Пронзающий Взгляд", 	true,	"RAID_WARNING", 3.5},
	},
}

--https://wow.gamepedia.com/UnitFlag
--local _, sevent, _, _, sName, sourceFlags, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo ()
--COMBATLOG_OBJECT_TYPE_NPC 	0x 0 0 0 0 0 8 0 0 
--COMBATLOG_OBJECT_TYPE_PLAYER 	0x 0 0 0 0 0 4 0 0 
--class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID("guid")
--print(sourceFlags, destFlags, bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) )
--local eventData = {CombatLogGetCurrentEventInfo()};
--	local logEvent = eventData[2];
--	local unitGUID = eventData[8];

local function cheloEvent( self, event, arg1, arg2, arg3, ...)

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, 
				extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10 = CombatLogGetCurrentEventInfo()
		--print(CombatLogGetCurrentEventInfo())

		if not badDBM[subEvent] then return end
		if not badDBM[subEvent][extraArg1] then return end

		local barArgs = badDBM[subEvent][extraArg1]
		local useMark, textWarning, withName, channelWarning, markClearDelay, foundTarget, delayAnonce = barArgs[1], barArgs[2], barArgs[3], barArgs[4], barArgs[5], barArgs[6], barArgs[7]
		local rt, dest = "", ""

		--print(CombatLogGetCurrentEventInfo())

		if useMark == 2 then
			--SetRaidTarget( sourceName, markPool[markIndex]); --destName
			rt = " {rt" .. markIndex .. "} "
			markIndex = markIndex + 1			
		elseif useMark == 1 then
			--SetRaidTarget( sourceName, 9);	--destName
			markIndex =  max( 1, markIndex - 1)
		end

		if foundTarget and UnitExists( foundTarget) then
			destName = UnitName( foundTarget)
		end

		if withName == true then
			local classFilename = select( 2, UnitClass( destName)) or "PRIEST"
			dest = rt .. "|c" .. RAID_CLASS_COLORS[classFilename].colorStr .. strsplit( "-", destName) .. "|r" .. rt .. " - "
		end

		if textWarning then
			print( "|cff00ffff" .. extraArg1 .. " " .. dest ..  textWarning)
		end

		if markClearDelay then
			C_Timer.After( markClearDelay, function(self, ...)
				--SetRaidTarget( sourceName, 9)
				markIndex =  max( 1, markIndex - 1)	
			end)
		end

		PlaySoundFile( LSM:Fetch( "sound", yo.Addons.CastWatchSound))

		--print( extraArg1, extraArg2, foundTarget, destName, dest, markIndex)


	elseif event == "UNIT_SPELLCAST_START" then
		local unit, spellID  = arg1, arg3
		if not unit then return end

		local unitTarget =  unit .. "target"

		if badCast[spellID] then
			local spellName, _, icon, startTime, endTime = UnitCastingInfo( unit)

			if UnitExists( unitTarget) then
				local targetName = UnitName( unitTarget)
				if targetName then
					local cTargetName = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( unitTarget))].colorStr .. strsplit( "-", targetName) .. "|r"
					print( "--Target cast: {rt8} " .. cTargetName .. " {rt8} " .. spellName)
					--SendChatMessage( "{rt8} " .. cTargetName .. " {rt8} " .. spellName, chatN) 
					--SetRaidTarget( unit .. "target", 8);
				end
			else
				print( "--SoloCast: " .. UnitName( unit), spellName)
				--SendChatMessage( "{rt8} " .. spellName .. " {rt8} " .. spellName, chatN) 
			end
		end							

	elseif event == "ENCOUNTER_START" then
		if UnitInRaid("player") or UnitInParty("player") then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			--self:RegisterUnitEvent("UNIT_SPELLCAST_START", "boss1", "boss2")
			markIndex = 1
			self.bossID = arg1
			self.isBoss = true
		end
	elseif event == "ENCOUNTER_END" then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		--self:UnregisterEvent("UNIT_SPELLCAST_START")
		self.bossID = false
		self.isBoss = false

	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.Addons.cheloBuff then return end

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		--self:RegisterUnitEvent("UNIT_SPELLCAST_START", "boss1", "boss2", "target", "player")
		self:RegisterEvent("ENCOUNTER_START")
		self:RegisterEvent("ENCOUNTER_END")

		if UnitExists( "boss1") then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")			
			--self:RegisterUnitEvent("UNIT_SPELLCAST_START", "boss1", "boss2")
		else
			--self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			--self:UnregisterEvent("UNIT_SPELLCAST_START")
		end
	end
end

local chelobuff = CreateFrame("Frame", nil, UIParent)
chelobuff:RegisterEvent("PLAYER_ENTERING_WORLD")
chelobuff:SetScript("OnEvent", cheloEvent)


		--if subEvent == "SPELL_AURA_APPLIED" then
		--	local spellID = tonumber( extraArg1)

		--	if extraArg2 == "Выброс Плазмы" or spellID == 271224 or spellID == 278888 or spellID == 271225 or spellID == 278889 then
		--		print("KJH LKJH LKJSHLDJSH ", extraArg1, extraArg2, badBuff[extraArg2], destName)
		--	end

		--	--print(CombatLogGetCurrentEventInfo())
		--	if badBuff[extraArg2] then

		--		local _, classFilename, _, _, _, name = GetPlayerInfoByGUID(sourceGUID)
		--		local unitColor = "|c" .. RAID_CLASS_COLORS[classFilename].colorStr .. strsplit( "-", name) .. "|r"
		--		local textMark = "--{rt" .. markIndex .. "} "

		--		print( textMark .. unitColor .. textMark .. extraArg2, extraArg1, badBuff[extraArg2])
		--		--SendChatMessage( textMark .. unitColor .. textMark .. extraArg2, chatN) 
		--		--SetRaidTarget( sourceName, markPool[markIndex]);
		--		markIndex = markIndex + 1
		--	end

		--elseif subEvent == "SPELL_AURA_REMOVED" then
		--	if badBuff[tonumber(extraArg1)] then
		--		--SetRaidTarget( sourceName, 9);
		--		markIndex =  max( 1, markIndex - 1)
		--		print("--SPELL_AURA_REMOVED", markIndex)
		--	end
		--end	
