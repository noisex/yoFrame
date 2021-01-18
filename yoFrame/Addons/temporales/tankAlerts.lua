 local _, ns 	= ...
local L, yo, n 	= unpack( ns)
local oUF 		= ns.oUF or oUF

local ta = CreateFrame("Frame", nil, UIParent)
n.Addons.tankAlerts = ta

local tankAlerts = {

	[172145] = { --Визгунья
		[328857] = { diffID = 1, stack = 10, alertTo = "another", alertMSG = "taunt boss" }, -- Обескровливающий укус
	},

	--Алчущий разрушитель
	[164261] = {
		[332295] = { diffID = 1, stack = 5, alertTo = "another", alertMSG = "taunt boss" }, -- Нарастающий голод
	},

	--Изобретатель Зи'Мокс
	[164261] = {
		[325361] = { diffID = 1, stack = 1, alertTo = "another", alertMSG = "taunt boss" }, 	-- Символ разрушения
		[325361] = { diffID = 1, stack = 1, alertTo = "buffed",  alertMSG = "fast run away" },	-- Символ разрушения
	},

	--Тень Кель'таса
	[165805] = {
		[326456] = { diffID = 1, stack = 3, alertTo = "another", alertMSG = "taunt boss" }, -- Горящие останки
		[325442] = { diffID = 1, stack = 3, alertTo = "another", alertMSG = "taunt mob" }, -- Уничтожение --Скальный покоритель [165764]
	},

	--Леди Инерва Дарквейн
	[165521] = {
		[325382] = { diffID = 1, stack = 2, alertTo = "another", alertMSG = "taunt boss" }, -- Извращенные желания
		--[331573] = { diffID = *, stack = 3, alertTo = "another", alertMSG = "taunt mob" }, -- Непомерная вина
	},

	--Грязешмяк
	[164407] = {
		[331209] = { diffID = 1, stack = 1, alertTo = "buffed", alertMSG = "za tumbu ubegal" }, -- Ненавидящий взгляд
	},
	--Генерал Кааль
	[165318] = {
		[343881] = { diffID = 1, stack = 4, alertTo = "another", alertMSG = "taunt boss" }, -- Рваная рана
	},

	--Сир Денатрий
	[167406] = {
		[329875] = { diffID = 1, stack = 4, alertTo = "another", alertMSG = "taunt boss" }, -- Бойня
		[329181] = { diffID = 1, stack = 2, alertTo = "another", alertMSG = "taunt boss" }, -- Нестерпимая боль
	},

	-- testing
	[666] = {
		[774]	= { diffID = 1, stack = 0, alertTo = "tanksGood", alertMSG = "taunt boss" }, -- Бойня
		[8936] 	= { diffID = 1, stack = 1, alertTo = "tanksBads", alertMSG = "taunt huyos" }, -- Нестерпимая боль
	},
}
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

	function ta:UnitGUID(unit)
		local guid = UnitGUID(unit)
		if guid then
			return guid
		end
	end

function ta:freeTank(targetUnit, sourceUnit)
	return UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
end

function ta:Tanking(targetUnit, sourceUnit)
	return UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
end

function ta:Tank(unit)
	if unit then
		return GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned( unit) == "TANK"
	else
		return n.myRole == "TANK"
	end
end

function ta:Me( guid)
	return n.myGUID == guid
end

local function updateGBTank(...)
	if n.tankOurHeros then
		local gt = GetTime()

		for unit, unitData in pairs( n.tankOurHeros.tanksPool) do
			local goodTank, badSpellID = true, false

			for spellID, spellData in pairs( unitData.spells) do

				if gt <= spellData.expiration then
					--print( "< BAD ", unit, unitData.name, spellID, expiration,  gt)
					badSpellID = spellID
					goodTank = false
				else
					--print( "> GOOD ", unit, unitData.name, spellID, expiration, gt)
					unitData.spells[spellID] = nil
				end
			end

			n.tankOurHeros.tanksGood[unit] 	= goodTank
			n.tankOurHeros.tanksBads[unit] 	= badSpellID
		end

		--tprint( n.tankOurHeros.tanksGood)
		--print("...")--, unit, name)
		--tprint( n.tankOurHeros.tanksBads)
		--print("---")
	end
end



local funcTankList = function(element, unit, button, name, texture, count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)

	--n.tankOurHeros[unit]
	n.myBossID = 666
	if n.tankOurHeros and tankAlerts[n.myBossID] and tankAlerts[n.myBossID][spellID] and count >= tankAlerts[n.myBossID][spellID].stack then

		local tanksPool = n.tankOurHeros.tanksPool
		local tankSpells = tanksPool[unit]["spells"]

		if not n.tankOurHeros.tanksPool[unit]["spells"][spellID] then n.tankOurHeros.tanksPool[unit]["spells"][spellID] = {} end

		n.tankOurHeros.tanksPool[unit]["spells"][spellID].expiration = expiration - 0.09
		n.tankOurHeros.tanksPool[unit]["spells"][spellID].stack 	 = count

		if n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert ~= "done" then
			n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert = "need"
		end

		print("BUFF", unit, name, count, n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert)

		--n.tankOurHeros.spells[spellID] = { unit = unit, expiration = expiration - 0.09, stack = count}

		updateGBTank()

		local alertMSG 	= tankAlerts[n.myBossID][spellID].alertMSG
		local alertTo 	= tankAlerts[n.myBossID][spellID].alertTo

		for alertUnit, toAlert in pairs(n.tankOurHeros[alertTo]) do

			--print( "--", unit, alertUnit, alertTo, toAlert, n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert)

			if toAlert
				and n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert == "need"
				and ( n.tankOurHeros.tanksPool[alertUnit]["spells"][spellID]
				and not n.tankOurHeros.tanksPool[alertUnit]["spells"][spellID].alerted) then

				n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert = "done"

				if not n.tankOurHeros.tanksPool[alertUnit]["spells"][spellID] then n.tankOurHeros.tanksPool[alertUnit]["spells"][spellID] = {} end
				n.tankOurHeros.tanksPool[alertUnit]["spells"][spellID].alerted = "done"

				print( unit, alertUnit, toAlert, n.tankOurHeros.tanksPool[alertUnit].name, alertMSG, n.tankOurHeros.tanksPool[unit]["spells"][spellID].needAlert)


			end
		end
	end

	updateGBTank()

	--if n.tankOurHeros and tankAlerts[n.myBossID] and tankAlerts[n.myBossID][spellID] and count >= tankAlerts[n.myBossID][spellID].stack then
	--end
	--print( n.myBossID, n.myRole, unit, name, count, debuffType, duration, expiration, caster, spellID, isBossDebuff)