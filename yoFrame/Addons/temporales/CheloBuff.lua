local L, yo, n = unpack( select( 2, ...))

--if not yo.Addons.cheloBuff then return end
if not n.myDev[n.myName] then return end

local _G = _G
local wipe, pairs, print, UnitName, UnitGUID, UnitExists, UnitGroupRolesAssigned, UnitDetailedThreatSituation, CombatLogGetCurrentEventInfo, PlaySoundFile, UnitInRaid, UnitInParty, unpack, strsplit, gsub
	= wipe, pairs, print, UnitName, UnitGUID, UnitExists, UnitGroupRolesAssigned, UnitDetailedThreatSituation, CombatLogGetCurrentEventInfo, PlaySoundFile, UnitInRaid, UnitInParty, unpack, strsplit, gsub

local UnitIsDeadOrGhost, GetSpellInfo, tonumber, dprint, tremove, tinsert, RaidNotice_AddMessage, ChatTypeInfo
	= UnitIsDeadOrGhost, GetSpellInfo, tonumber, dprint, tremove, tinsert, RaidNotice_AddMessage, ChatTypeInfo

local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

local LSM = n.LIBS.LSM

local tc = n.Addons.torgastClicks
local cb = CreateFrame("Frame", nil, UIParent)
local alertDB = yo.alerts.alertsPool

n.Addons.cheloBuff = cb

cb.units = { roles = { TANK = {}, HEALER = {}, DAMAGER = {}, NONE = {},}, raid = {}, boses = {}}

local markPool = {8, 7, 5, 4, 3, 1, 6, 2}
local markIndex = 1

local chatN = "party"
local chatN = "raid"
local chatN = "RAID_WARNING"

local bossesBW = {
	[1810] 		= "Warlord Parjesh",
	[166644] 	= "Artificer Xy'mox",
	[166969]	= "The Council of Blood", -- Baroness Frieda
	--[166970]	= "The Council of Blood", -- Lord Stavros
	--[166971]	= "The Council of Blood", -- Castellan Niklaus
	[165805]	= "Sun King's Salvation", -- Shade of Kael'thas,
	[165759]	= "Sun King's Salvation", -- Kael'thas,
	[168973]	= "Sun King's Salvation", -- High Torturer Darithos
	[168112]	= "Stone Legion Generals", -- General Kaal
	[168113]	= "Stone Legion Generals", -- General Grashaal
	[164407]	= "Sludgefist",
	[164406] 	= "Shriekwing",
	[165521]	= "Lady Inerva Darkvein",
	[164261] 	= "Hungering Destroyer",
	[167406] 	= "Sire Denathrius",
	[165066]	= "Huntsman Altimor", -- Huntsman Altimor
	--[165067] 	= "Huntsman Altimor",-- Margore
	--[169457] 	= "Huntsman Altimor",-- Bargast
	--[169458] 	= "Huntsman Altimor",-- Hecutis
}

local function unitsCheck()
	wipe( cb.units.raid)
	wipe( cb.units.boses)
	wipe( cb.units.roles.TANK)
	wipe( cb.units.roles.HEALER)
	wipe( cb.units.roles.DAMAGER)

	if UnitInRaid("player") then
		cb.prefix = "raid"
	elseif UnitInParty("player") then
		cb.prefix = "party"

		cb.units.raid[n.myGUID]				= { unit = "player", name = n.myName, fullName = n.myName, }
		cb.units.roles[n.myRole][n.myGUID] 	= { unit = "player", name = n.myName, fullName = n.myName, }
	else
		cb.prefix = "party"
		cb.units.raid[n.myGUID]				= { unit = "player", name = n.myName, fullName = n.myName, }
	end

	for index = 1, 40 do
		local unit = cb.prefix .. index
		if not UnitExists( unit) then break end

		local role 		= UnitGroupRolesAssigned( unit)
		local guid 		= UnitGUID( unit)
		local fullName 	= UnitName( unit)
		local name 		= strsplit( "-", fullName)

		cb.units.raid[guid]			= { unit = unit, name = name, fullName = fullName}
		cb.units.roles[role][guid] 	= { unit = unit, name = name, fullName = fullName}
	end

	for i = 1, MAX_BOSS_FRAMES do
		local boss = "boss" .. i

		if UnitExists( boss) then
			local guid = UnitGUID( boss)
			local name = UnitName( boss)
			cb.units.boses[guid] = { unit = boss, name = name, fullName = name}
			cb.units.raid[guid]	 = { unit = boss, name = name, fullName = name}
		end
	end
end

 local markerIcons = {
 	"|T137001:0|t",
 	"|T137002:0|t",
 	"|T137003:0|t",
 	"|T137004:0|t",
 	"|T137005:0|t",
 	"|T137006:0|t",
 	"|T137007:0|t",
 	"|T137008:0|t",
 }

local colors = {
	["green"] 	= { colorStr = "|cff00ff00", color = {0,1,0,1}},
	["red"] 	= { colorStr = "|cffff0000", color = {1,0,0,1}},
	["orange"] 	= { colorStr = "|cffffff00", color = {1,1,0,1}},
	["blue"]	= { colorStr = "|cff00ffff", color = {0,1,1,1}},
	["white"]	= { colorStr = "|cffffffff", color = {1,1,1,1}},
	["black"]	= { colorStr = "|cff000000", color = {0,0,0,1}},
}

-- raidWarning
-- alertTimer
-- alertRepeate
-- sourceUnit


------------- AURA EVENTS

cb.auraStack = function( cleuInfo, alertData)
	local event 	= cleuInfo[2]
	local stack 	= cleuInfo[16] or 0
	local fromStack = alertData.fromStack or 1
	local toStack 	= alertData.toStack

	if event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" then

		if not toStack and stack == fromStack then return true end

		if stack >= fromStack and stack <= toStack then return true end
	end

	return false
end

--cb.auraRemovedDose = function( cleuInfo, alertData)
--	local event 	= cleuInfo[2]
--	local stack 	= cleuInfo[16]
--	local fromStak 	= alertData.fromStack or 0
--	local toStack 	= alertData.toStack or 100

--	if event == "SPELL_AURA_REMOVED_DOSE" and ( stack <= fromStak and stack >= toStack ) then return true end
--	return false
--end

------------- AURA TARGETS

cb.freeTank = function( destGUID, sourceGUID)
	if not cb.units.boses[sourceGUID] then return end
	if not cb.units.roles.TANK[destGUID] then return end

	local sourceUnit = cb.units.boses[sourceGUID].unit
	local unitTank 	 = cb.units.roles.TANK[destGUID].unit

	return not UnitDetailedThreatSituation( unitTank, sourceUnit), unitTank
end

cb.currentTank = function( destGUID, sourceGUID)
	if not cb.units.boses[sourceGUID] then return end
	if not cb.units.roles.TANK[destGUID] then return end

	local sourceUnit = cb.units.boses[sourceGUID].unit
	local unitTank 	 = cb.units.roles.TANK[destGUID].unit

	return UnitDetailedThreatSituation( unitTank, sourceUnit), unitTank
end

cb.me = function( destGUID, sourceGUID)
	if not cb.units.raid[destGUID] then return end

	return n.myGUID == destGUID, cb.units.raid[destGUID].unit
end

cb.any = function( destGUID, sourceGUID)
	--print( "THIS ANY: ", destGUID, sourceGUID, cb.units.raid[destGUID])
	if not cb.units.raid[destGUID] then return end

	return true, cb.units.raid[destGUID].unit
end

cb.empty = function( destGUID, sourceGUID)
	return true, "emptyUnit"
end

cb.target = {
	--["auraApplaed"] = cb.auraApplaed,
	["auraStack"]		= cb.auraStack,
	--["auraRemovedDose"] = cb.auraRemovedDose,

	["me"] 			= cb.me,
	["currentTank"]	= cb.currentTank,
	["freeTank"]	= cb.freeTank,
	["any"]			= cb.any,
	["empty"]		= cb.empty,
}


------------- ALERT TARGETS

cb.toMe = function( destGUID, sourceGUID)
	---if not cb.units.raid[n.myGUID] then return end

	--return n.myName, cb.units.raid[n.myGUID].unit, n.myGUID
	return n.myName, "player", n.myGUID
end

cb.toTarget	= function( destGUID, sourceGUID)
	if not cb.units.raid[destGUID] then return end

	return cb.units.raid[destGUID].name, cb.units.raid[destGUID].unit, destGUID
end

cb.toCurrentTank= function( destGUID, sourceGUID)
	if not cb.units.boses[sourceGUID] then return end
	local sourceUnit = cb.units.boses[sourceGUID].unit

	for tankGUID, tankData in pairs( cb.units.roles.TANK) do
		local isTank = UnitDetailedThreatSituation( tankData.unit, sourceUnit)

		if isTank then
			return tankData.name, tankData.unit, tankGUID
		end
	end
end

cb.toFreeTank = function( destGUID, sourceGUID)
	if not cb.units.boses[sourceGUID] then return end
	local sourceUnit = cb.units.boses[sourceGUID].unit

	for tankGUID, tankData in pairs( cb.units.roles.TANK) do
		local isTank = UnitDetailedThreatSituation( tankData.unit, sourceUnit)
		local isDEad = UnitIsDeadOrGhost( tankData.unit)

		if not isTank and not isDEad then
			return tankData.name, tankData.unit, tankGUID
		end
	end
end

cb.toAnotherTank = function( destGUID, sourceGUID)
	if not cb.units.roles.TANK[destGUID] then return end

	for tankGUID, tankData in pairs( cb.units.roles.TANK) do
		local isDEad = UnitIsDeadOrGhost( tankData.unit)

		if tankGUID ~= destGUID  and not isDEad then
			return tankData.name, tankData.unit, tankGUID
		end
	end
end

cb.alert = {
	["me"] 			= cb.toMe,
	["currentTank"] = cb.toCurrentTank,
	["freeTank"]	= cb.toFreeTank,
	["anotherTank"]	= cb.toAnotherTank,
	["target"]		= cb.toTarget,
}

cb.aurasOLD = {
	--[774] 		= { event = "auraApplaed", stack = 0, target = "currentTank",   alertTarget = "me", 			msg = "REJUVKA", 	mark = false, sound = false, color = "green"},
	--[8936]  	= { event = "auraApplaed", stack = 0, target = "currentTank", 	alertTarget = "currentTank", 	msg = "REGROS", 	mark = false, sound = true,  color = "green"},

	--[192131]   	= {{ event = "auraApplaed", target = "currentTank",   alertTarget = "me", 			msg = "192131", 	sound = true,  color = "red"},},
	--[192053]   	= {{ event = "auraApplaed", target = "me",  		  alertTarget = "me", 			msg = "ПЕСОК,ТОНУ", sound = true,  color = "orange"},},
	--[191977]   	= {{ event = "auraApplaed", target = "currentTank",   alertTarget = "currentTank",	msg = "TAUNT BOSS!",sound = true,  color = "blue"},},

	--[8936]  	= {{ event = "castStart", target = "any", 	alertTarget = "me", 	msg = "REGROS CAST", 	mark = false, sound = true,  color = "red"},},
	--[338825]  	= {{ event = "auraStack", target = "me", 	alertTarget = "me", 	msg = "ПАЛЕЦ ЗАРЯДИЛ", 	sound = true,  color = "green", stack = 4},},
	[340533]   	= {{ event = "auraApplaed", target = "currentTank",  alertTarget = "freeTank",		msg = "!!!!!!", 		sound = true,  color = "red"},},
--Лорд Ставрос
	--[327503]   	= { event = "auraApplaed", target = "currentTank",  alertTarget = "freeTank",		msg = "!!!!!!", 		sound = true,  color = "red"},
	[327610]   	= {{ event = "auraApplaed", target = "currentTank",  alertTarget = "freeTank",		msg = "!!!!!!", color = "red"},},
	[331637] 	= {{ event = "auraRemoved", target = "any",  		 alertTarget = "target",		msg = "$target, ты чист!", 		color = "green"},},
	[331636] 	= {{ event = "auraRemoved", target = "any",  		 alertTarget = "target",		msg = "$target, ты чист!", 		color = "green"},},
-- визгунья 342863
	[328897]   	= {
		{ event = "auraRemoved", 	target = "any",  		 alertTarget = "target",		msg = "$target, ты чист!", 	color = "green"},
		{ event = "auraApplaed", 	target = "currentTank",  alertTarget = "freeTank",		msg = "$target, таунт $boss",},
		{ event = "auraStack",		target = "currentTank",  alertTarget = "currentTank",	msg = "$target, прожмись! $stack стаков", fromStack = 7, toStack = 9},
	},
	[330711]	= {{ event = "castStart", target = "any",  alertTarget = "me",	msg = "ПРЯЧЬСЯ фаза! ( #$count)", 	sound = true,  color = "red"},},
	[345936]	= {{ event = "castStart", target = "any",  alertTarget = "me",	msg = "ПРЯЧЬСЯ переход! ( #$count)", sound = true,  color = "red"},},
--грязешмяк
	[331209]   	= {
		{ event = "auraRemoved", target = "any",    alertTarget = "target",		msg = "$target, ты чист!", 		color = "green"},
		{ event = "auraApplaed", target = "any",   	alertTarget = "me",			msg = "Отойди от колонны! Скоро дамажить ( 6 сек)", sound = true,  color = "blue"},
		{ event = "auraApplaed", target = "any",   	alertTarget = "target",		msg = "$target, Беги в колону #$count!", },
		{ event = "auraApplaed", target = "any",  	alertTarget = "freeTank",	msg = "$target, TAUNT $boss", },
	},
	--[331212] 	= {{ event = "castStart",  target = "any",  	alertTarget = "me",	msg = "Отойди от колонны! Скоро дамажить ( 4 сек)", sound = true, color = "blue"},},
-- изобретатель
	[325236]   	= {
		{ event = "auraRemoved", target = "any",    alertTarget = "target",		msg = "$target, ты чист!", 	color = "green"},
		{ event = "auraApplaed", target = "any",  	alertTarget = "target",		msg = "Выноси говно!", color = "blue"},
		{ event = "auraApplaed", target = "any",  	alertTarget = "freeTank",	msg = "$target, TAUNT $boss!!!",  color = "red"},
	},
	[328437]	= { ---Пространственный разрыв
		{ event = "castStart", target = "any",  	alertTarget = "me",	msg = "Выносим 1й портал в центр",	sound = true,  color = "orange", stage = 3},},
	--328448   castSuccs
	--328468
	[334971]   	= {{ event = "auraApplaed", target = "currentTank",  alertTarget = "freeTank",		msg = "HUNTERS!!!", 	sound = true},},
--Алчущий разрушитель 338614
	[338614]   	= {{ event = "auraApplaed", target = "any",  alertTarget = "me",	msg = "LASER 1",	sound = true },},
	[334064]   	= {{ event = "auraApplaed", target = "any",  alertTarget = "me",	msg = "LASER 2", 	sound = true,  color = "blue"},},
	[334266]   	= {{ event = "auraApplaed", target = "any",  alertTarget = "me",	msg = "LASER 3", 	sound = true,  color = "blue"},},
}

cb.auras = {}
---alertDB
function cb:auraTable( spellData, alertName)
	local spellID 		= tonumber( spellData.spellID)
	local name, _, icon = GetSpellInfo( spellID)

	if name then
		if not cb.auras[spellID] then cb.auras[spellID] = {} end

		for i,v in pairs( cb.auras[spellID]) do
			if alertName == v.alertName then
				tremove( cb.auras[spellID], i)
			end
		end

		local option = {
			spellId 	= spellID,
			alertName 	= alertName,
			event 		= spellData.event,
			target		= spellData.destUnit,
			alertTarget	= spellData.alertUnit,
			msg 		= spellData.message,
			color		= spellData.color,
			fromStack 	= tonumber( spellData.fromStack),
			toStack		= tonumber( spellData.toStack),
			raidAlert	= spellData.raidAlert,
			sound		= spellData.sound,
			stage 		= tonumber( spellData.stage),
			lowHealth 	= spellData.lowHealth,
			index 		= 0,
			name 		= name,
			icon 		= icon,
			spellMSG	= " |cff00ffff|T".. icon ..":11:11:0:0:44:44:4:40:4:40|t " .. name .. "|r",
			colorStr 	= spellData.color and colors[spellData.color].colorStr 	or "|cffff0000",
			colorRGB	= spellData.color and colors[spellData.color].color 	or {1,0,0,1},
		}

		if not option.stack then option.stack = 0 end
		if not option.msg   then option.msg = "$spell" end

		if option.event == "auraApplaed" then
			option.events = { ["SPELL_AURA_APPLIED"] = true, }

		elseif option.event == "auraRemoved" then
			option.events = { ["SPELL_AURA_REMOVED"] = true,}
		--elseif option.event == "auraRemovedDose" then
			--option.events = { ["SPELL_AURA_REMOVED_DOSE"] = true,}
		--elseif option.event == "auraStack" then
			--option.events = { ["SPELL_AURA_APPLIED_DOSE"] = true,} --["SPELL_AURA_APPLIED"] = true,
		elseif option.event == "castStart" then
			option.events = { ["SPELL_CAST_START"] = true,}
			option.target = "empty"
			elseif option.event == "castSuccs" then
			option.events = { ["SPELL_CAST_SUCCESS"] = true,}
			option.target = "empty"
		end

		tinsert( cb.auras[spellID], option)
	else
		print( alertName, " - SPELL ERROR:", spellID )
	end
end

function cb:spellPrepare( key)
	if key then
		local spellData = alertDB[key]
		cb:auraTable( spellData, key)
	end
end

function cb:spellsPrepare( key)
	for alertName, spellData in pairs( alertDB) do
		cb:auraTable( spellData, alertName)
	end
end

local function msgOut( alertData, cleuInfo, msgName, msgUnit)

	local alertTarget = alertData.alertTarget
	local stack 	  = cleuInfo[16] or ""
	local bossName	  = cleuInfo[5] or ""
	local msg 		  = alertData.msg
	local alerCount	  = alertData.index
	--local devStr = ""
	local devStr = "|cff888888>>> to '" .. alertData.alertTarget .. "' (" .. msgName .. " - ".. msgUnit .. ") :|r"

	msg = gsub( msg, "$stack", 	stack)
	msg = gsub( msg, "$target", msgName)
	msg = gsub( msg, "$boss", 	bossName)
	msg = gsub( msg, "$count", 	alerCount)
	msg = gsub( msg, "$spell", 	alertData.spellMSG)

	if alertTarget == "me" then
		local r, g, b = unpack( alertData.colorRGB)
		_G.UIErrorsFrame:AddMessage( msg, r, g, b, 1.0, 1);

		---print( alertData.colorStr .. ">>> to '" .. alertData.alertTarget .. "': " .. msgName .. " (".. msgUnit .. "), "  .. msg .. alertData.spellMSG)

	elseif alertTarget == "raid" or alertTarget == "party" then
		-- ананс в рейд/группу
		RaidNotice_AddMessage( _G.RaidWarningFrame, msg, ChatTypeInfo["RAID_WARNING"], 10);

	else
		-- ПМ жертве
	end

	print( devStr .. alertData.colorStr .. msg .. alertData.spellMSG)
end

local function checkBWBoss( self)
	for i = 1, MAX_BOSS_FRAMES do
		local boss = "boss" .. i
		if UnitExists( boss) then
			local _, _, _, _, _, mobID = strsplit( "-", UnitGUID( boss))
			local bossEng = bossesBW[tonumber( mobID)]
			--dprint(mobID, boss, bossEng )
			if bossEng and _G.BigWigs then
				local mod = _G.BigWigs:GetBossModule( bossEng)
				if mod then
					dprint("BWBoss found!", mobID, boss, bossEng)
					self.bossBW = mod
					self.bossed = true
				end
			end
		end
	end
end

local function checkSubEvent(self, alertData, cleuInfo)
	local subEvent	= cleuInfo[2]

	if not (( alertData.events and alertData.events[subEvent]) or ( self.target[alertData.event] and self.target[alertData.event]( cleuInfo, alertData))) then return false	end

	alertData.stageBW 	 = self.bossed and self.bossBW:GetStage() or 0
	--dprint( alertData.events[subEvent], "--==>> STAGE =", alertData.stageBW)
	if alertData.stage and self.bossed and alertData.stage ~= alertData.stageBW then return false end

	return true
end

local function cheloEvent( self, event, arg1, arg2, arg3, ...)

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local cleuInfo 	= {CombatLogGetCurrentEventInfo()}
		local spellId 	= cleuInfo[12]
		local destGUID	= cleuInfo[8]
		local sourceGUID= cleuInfo[4]
		--self.eventLog 	= cleuInfo

		--local ts, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags,
		--		spellId, spellName, spellSchool, extraArg15, extraArg16, extraArg17, extraArg18, extraArg19, extraArg20, extraArg21 = CombatLogGetCurrentEventInfo()

		if not self.auras[spellId] then return end

		for i, alertData in pairs( self.auras[spellId]) do
			-- CUSTOM EVENTS
			if checkSubEvent(self, alertData, cleuInfo) then

				alertData.index 	 = alertData.index + 1
				alertData.sourceGUID = sourceGUID
				alertData.sourceName = cleuInfo[6]
				alertData.sourceUnit = self.units.boses[sourceGUID] and self.units.boses[sourceGUID].unit or false

				alertData.destGUID 	 = destGUID
				alertData.destName	 = cleuInfo[9]
				alertData.destUnit 	 = self.units.raid[destGUID] and self.units.raid[destGUID].unit or false

				-- SEEK TARGET
				local target, unit = self.target[alertData.target]( destGUID, sourceGUID)

				if target and unit then
					--  DO MESAGE
					local msgName, msgUnit, msgGUID = self.alert[alertData.alertTarget]( destGUID, sourceGUID)

					if msgName then msgOut( alertData, cleuInfo, msgName, msgUnit) end

					--dprint("-------------------------------------------")
					--dprint( "Дано : id = ", spellId, " target = ", buffTarget, " toAlert = ", toAlert)
					--dprint( "Имеем: buff source = ", sourceName, "buff target = ", unit, UnitName(unit))
					--dprint( "Алерт: target =", alertUnit, UnitName( alertUnit), alertGUID)

					if alertData.sound then PlaySoundFile( LSM:Fetch( "sound", alertData.sound)) end
				end
			end
		end

	elseif event == "ENCOUNTER_START" or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" or event == "PLAYER_ENTERING_WORLD" then
		if ( UnitInRaid("player") or UnitInParty("player")) and not ( tc and tc.inTorghast) then
			checkBWBoss( self)
			unitsCheck()
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			--self:RegisterUnitEvent("UNIT_SPELLCAST_START", "boss1", "boss2")
			--markIndex = 1
		end
	elseif event == "ENCOUNTER_END" then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self.bossBW = false
		self.bossed = false
		--self:UnregisterEvent("UNIT_SPELLCAST_START")

	elseif event == "GROUP_ROSTER_UPDATE" then
		if not ( tc and tc.inTorghast) then
			n.myRole = UnitGroupRolesAssigned( "player")
			unitsCheck()
		end
	end
end

--cb:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--unitsCheck()
--self:RegisterUnitEvent("UNIT_SPELLCAST_START", "boss1", "boss2", "target", "player")
cb:RegisterEvent("ENCOUNTER_START")
cb:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
cb:RegisterEvent("ENCOUNTER_END")
cb:RegisterEvent("PLAYER_ENTERING_WORLD")
cb:RegisterEvent("GROUP_ROSTER_UPDATE")
cb:SetScript("OnEvent", cheloEvent)

---spellsPrepare()
cb:spellsPrepare()
---spellsPrepareNEW()


	--------------------------------------------------------------------------------------------------
		--hooksecurefunc( mod, "ImpalingSpear", function(self, args)
		--	print("BOOOM")
		--	if args and type( args) == "table" then
		--		--tprint(args)
		--		mod:TargetMessageOld( args.spellId, args.destName, "red", "alarm", "???????????????????????", nil, true)
		--	end
		--end)

		--hooksecurefunc( mod, "ThrowSpear", function(self, args)
		--	print("BOOOM TRA", self, args)
		--	if args and type( args) == "table" then
		--		--tprint(args)
		--		mod:TargetMessageOld( args.spellId, args.destName, "red", "alarm", "!!!!!!!!!!!!!", nil, true)
		--	end

		--end)
		----print( "spell found ", spellId, spellMSG, destGUID, sourceGUID)

		--local spellAura 	= cb.auras[spellId]


		--print("MSG", cb.auras[spellId].msg)

		--print( destGUID, destName)
		--print( cb.funcs[cb.auras[spellId].target]( destGUID))
		--local barArgs = cb.badDBM[subEvent][extraArg1]
		--local useMark, textWarning, withName, channelWarning, markClearDelay, foundTarget, delayAnonce = barArgs[1], barArgs[2], barArgs[3], barArgs[4], barArgs[5], barArgs[6], barArgs[7]
		--local rt, dest = "", ""

		--print(CombatLogGetCurrentEventInfo())
		--cb.funcs[markClearDelay](destGUID)
		--print( markClearDelay, cb.funcs[markClearDelay](destGUID), extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10)

		--if useMark == 2 then
		--	--SetRaidTarget( sourceName, markPool[markIndex]); --destName
		--	rt = " {rt" .. markIndex .. "} "
		--	markIndex = markIndex + 1
		--elseif useMark == 1 then
		--	--SetRaidTarget( sourceName, 9);	--destName
		--	markIndex =  max( 1, markIndex - 1)
		--end

		--if foundTarget and UnitExists( foundTarget) then
		--	destName = UnitName( foundTarget)
		--end

		--if withName == true then
		--	local classFilename = select( 2, UnitClass( destName)) or "PRIEST"
		--	dest = rt .. "|c" .. RAID_CLASS_COLORS[classFilename].colorStr .. strsplit( "-", destName) .. "|r" .. rt .. " - "
		--end

		--if textWarning then
		--	print( "|cff00ffff" .. extraArg1 .. " " .. dest ..  textWarning)
		--end

		--if markClearDelayQQQQQQQQQQQQQQQQQQ then
		--	C_Timer.After( markClearDelay, function(self, ...)
		--		--SetRaidTarget( sourceName, 9)
		--		markIndex =  max( 1, markIndex - 1)
		--	end)
		--end



		--print( extraArg1, extraArg2, foundTarget, destName, dest, markIndex)




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

	--elseif event == "UNIT_SPELLCAST_START" then
	--	local unit, spellID  = arg1, arg3
	--	if not unit then return end

	--	local unitTarget =  unit .. "target"

	--	if badCast[spellID] then
	--		local spellName, _, icon, startTime, endTime = UnitCastingInfo( unit)

	--		if UnitExists( unitTarget) then
	--			local targetName = UnitName( unitTarget)
	--			if targetName then
	--				local cTargetName = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( unitTarget))].colorStr .. strsplit( "-", targetName) .. "|r"
	--				print( "--Target cast: {rt8} " .. cTargetName .. " {rt8} " .. spellName)
	--				--SendChatMessage( "{rt8} " .. cTargetName .. " {rt8} " .. spellName, chatN)
	--				--SetRaidTarget( unit .. "target", 8);
	--			end
	--		else
	--			print( "--SoloCast: " .. UnitName( unit), spellName)
	--			--SendChatMessage( "{rt8} " .. spellName .. " {rt8} " .. spellName, chatN)
	--		end
	--	end



-- useMark, textWarning, withName, channelWarning, markClearDelay, foundTarget, delayAnonce

--cb.badDBM = {
--	["SPELL_AURA_APPLIED"]	= {
--		--[164812] = { 2, "Used moon", true,	"RAID_WARNING"},
--		--[164815] = { 2, "Used sun",  true,	"RAID_WARNING"},
--		[774] = { 1, "Used sun",  true,	"RAID_WARNING", "Me"},

--		--01 - Талок 	: Выброс Плазмы		2144
--		[271224] = { 2, "Выброс начался 1й", true,	"RAID_WARNING"},
--		[278888] = { 2, "Выброс начался 2й", true,	"RAID_WARNING"},

--		--04 - Зек'Воз 	: Сделка с Осквернителем	2136
--		[265662] = { 2, "Сделка осквернителя", true,	"RAID_WARNING"},
--		[265363] = { 2, "Тревожный туман", 	true,	"RAID_WARNING"},

--		--05 - Вектис 	: Вызревание	1134
--		[265212] = { 2, "Какое-то вызревание", true,	"RAID_WARNING"},

-- 		--06 - Зул Перерожденный : Желание Смерти	2145
--		[274271] = { 2, "Скоро диспел: Желание Смерти", true,	"RAID_WARNING"},
--		--07 272536
--		--[272536] = { 2, "Неизбежное уничтожение", true,	"RAID_WARNING"},
--	},

--	["SPELL_AURA_REFRESH"]	= {
--		[774] = { 1, "Used sun  DOUBLE",  true,	"RAID_WARNING", "Me"},
--	},

--	["SPELL_AURA_REMOVED"]	= {
--		--[164812] = { 1, "Used sun",  true,	"RAID_WARNING"},
--		--[164815] = { 1,  "Used sun",  true,	"RAID_WARNING"},

--		--01 - Талок 	: Выброс Плазмы		2144
--		[271225] = { 1, "Выброс кончился 1й", 	true,	"RAID_WARNING"},
--		[278889] = { 1, "Выброс кончился 2й", 	true,	"RAID_WARNING"},

--		--04 - Зек'Воз 	: Воля Осквернителя	2136
--		[265646] = { 1, "Воля осквернителя", 	true,	"RAID_WARNING"},
--		[265363] = { 1, "Тревожный туман", 		true,	"RAID_WARNING"},

-- 		--05 - Вектис 	: Вызревание	1134
--		[265212] = { 2, "Скоро диспел: Желание Смерти", true,	"RAID_WARNING"},

--		--06 - Зул Перерожденный : Желание Смерти	2145
--		[274271] = { 1, "Желание Смерти", 		true,	"RAID_WARNING"},
--		--07 272536
--		--[272536] = { 1, "Неизбежное уничтожение", true,	"RAID_WARNING"},
--	},

--	["SPELL_CAST_START"]	= {
--		--[5176] = 	{ 0, "Выброс начался", 		false,	"RAID_WARNING"},273554
--		[271296] = 	{ 0, "RUN AWAY Кровавый Отбойник", 	false,	"RAID_WARNING"},

--		[264382] = 	{ 2, "Пронзающий Взгляд", 	true,	"RAID_WARNING", 3, "boss2target"},
--		--07 - Митракс Развоплотитель
--		[273282] = 	{ 0, "RUN AWAY Разрыв сущности START", false,	"RAID_WARNING"},
--		[273538] = 	{ 0, "RUN AWAY уничтожающий-взрыв START", false,	"RAID_WARNING"},
--	},

--	["SPELL_CAST_SUCCESS"]	= {
--		--[5176] 	= 	{ 2, "Выброс кончился 1й", 	true,	"RAID_WARNING", 3},
--		--277973 - 7	269827 - 15
--		[277973] = 	{ 0, "Ульдирский защитный луч Нормал",	false,	"RAID_WARNING"},
--		[269827] = 	{ 0, "Ульдирский защитный луч Героик",	false,	"RAID_WARNING"},

--		[268253] = 	{ 0, "Ульдирский защитный луч",	false,	"RAID_WARNING"},
--		[268245] = 	{ 0, "Ульдирский защитный луч",	false,	"RAID_WARNING"},
--		--[264382] = 	{ 2, "Пронзающий Взгляд", 	true,	"RAID_WARNING", 3.5},
--	},
--}

 --https://wow.gamepedia.com/UnitFlag
--local _, sevent, _, _, sName, sourceFlags, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo ()
--COMBATLOG_OBJECT_TYPE_NPC 	0x 0 0 0 0 0 8 0 0
--COMBATLOG_OBJECT_TYPE_PLAYER 	0x 0 0 0 0 0 4 0 0
--class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID("guid")
--print(sourceFlags, destFlags, bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) )
--local eventData = {CombatLogGetCurrentEventInfo()};
--	local logEvent = eventData[2];
--	local unitGUID = eventData[8];

--status = UnitThreatSituation("unit"[, "otherunit"])
--With otherunit specified
--nil = unit is not on otherunit's threat table.
--0 = not tanking, lower threat than tank.
--1 = not tanking, higher threat than tank.
--2 = insecurely tanking, another unit have higher threat but not tanking.
--3 = securely tanking, highest threat
--		r, g, b = GetThreatStatusColor(status)

--isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("unit", "mob")
--self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", self.onChangeTarget)
--self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", self.onChangeTarget)
--UNIT_THREAT_LIST_UPDATE: unitTarget

--cb.freeTank = function (targetUnit, sourceUnit)
--	return UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
--end

--function cb:Tanking(targetUnit, sourceUnit)
--	return UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
--end

--cb.Tanka = function (unit)
--	if unit then
--		return GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned( unit) == "TANK"
--	else
--		return n.myRole == "TANK"
--	end
--end

--cb.Tank = function ( guid)
--	print("TANK")
--	return cb.tanks.tanksPoolGUID[guid]
--end

--function cb:UnitGUID(unit)
--	local guid = UnitGUID(unit)
--	if guid then
--		return guid
--	end
--end

--local function spellsPrepare(...)
--	for spellId, spellData in pairs( cb.aurasOLD) do
--		local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo( spellId)
--		if name then
--			for  index, alertData in pairs( spellData) do
--				alertData.index 	= 0
--				alertData.name 		= name
--				alertData.icon 		= icon
--				alertData.spellMSG	= " |cff00ffff|T".. alertData.icon ..":11:11:0:0:44:44:4:40:4:40|t " .. alertData.name .. "|r"
--				alertData.colorStr 	= alertData.color and colors[alertData.color].colorStr 	or "|cffff0000"
--				alertData.colorRGB	= alertData.color and colors[alertData.color].color 	or {1,0,0,1}

--				if not alertData.mark  then alertData.mark  = false end
--				if not alertData.sound then alertData.sound = false end
--				--if not alertData.stack then alertData.stack = 0 end
--				if not alertData.msg   then alertData.msg 	= "$spell" end

--				if alertData.event == "auraApplaed" then
--					alertData.events = { ["SPELL_AURA_APPLIED"] = true, }

--				elseif alertData.event == "auraRemoved" then
--					alertData.events = { ["SPELL_AURA_REMOVED"] = true,}

--				--elseif alertData.event == "auraRemovedDose" then
--					--alertData.events = { ["SPELL_AURA_REMOVED_DOSE"] = true,}

--				--elseif alertData.event == "auraStack" then
--					--alertData.events = { ["SPELL_AURA_APPLIED_DOSE"] = true,} --["SPELL_AURA_APPLIED"] = true,

--				elseif alertData.event == "castStart" then
--					alertData.events = { ["SPELL_CAST_START"] = true,}
--					alertData.target = "empty"

--				elseif alertData.event == "castSuccs" then
--					alertData.events = { ["SPELL_CAST_SUCCESS"] = true,}
--					alertData.target = "empty"
--				end
--			end
--		else
--			print( spellId, "ERROR!!!")
--		end
--	end
--end