local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_q was unable to locate oUF install.")

local L, yo = ns[1], ns[2]


local foo = {""}
local spellcache = setmetatable({},
{__index=function(t,id)
	local a = {GetSpellInfo(id)}

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

	--print("Invalid spell ID: ", id)
        t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local GetTime = GetTime

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

local x = "M"

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

oUF.Tags["Threat"] = function(unit)
	local tanking, status, percent = UnitDetailedThreatSituation("player", "target")
	if percent and percent > 0 then
		return ("%s%d%%|r"):format(Hex(GetThreatStatusColor(status)), percent)
	end
end
oUF.Tags.Events["Threat"] = "UNIT_THREAT_LIST_UPDATE"


oUF.Tags["PetNameColor"] = function(unit)
	return string.format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
end
oUF.Tags.Events["PetNameColor"] = "UNIT_POWER"

oUF.Tags.Methods['GetNameColor'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")

	--if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
	--	return "|cffA0A0A0"
	if (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events['GetNameColor'] = 'UNIT_HEALTH'

oUF.Tags["NameArena"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 4, false)
end
oUF.Tags.Events["NameArena"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameShort"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 8, false)
end
oUF.Tags.Events["NameShort"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameMedium"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 10, false)
end
oUF.Tags.Events["NameMedium"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameLong"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 18, true)
end
oUF.Tags.Events["NameLong"] = "UNIT_NAME_UPDATE"

oUF.Tags["LFD"] = function(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "HEALER" then
		return "|cff8AFF30[H]|r"
	elseif role == "TANK" then
		return "|cffFFF130[T]|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161[D]|r"
	end
end
oUF.Tags.Events["LFD"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

oUF.Tags["AltPower"] = function(unit)
	local min = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ("%s%%"):format(math.floor(min / max * 100 + 0.5))
	end
end
oUF.Tags.Events["AltPower"] = "UNIT_POWER"

oUF.Tags["IncHeal"] = function(unit)
	local incheal = UnitGetIncomingHeals(unit) or 0
	local player = UnitGetIncomingHeals(unit, "player") or 0
	incheal = incheal - player
	if incheal > 0 then
		return "|cff00FF00+"..ShortValue(incheal).."|r"
	end
end
oUF.Tags.Events["IncHeal"] = "UNIT_HEAL_PREDICTION"

if class == "DRUID" then
	for i = 1, 3 do
		oUF.Tags["WM"..i] = function(unit)
			local _, _, _, dur = GetTotemInfo(i)
			if dur > 0 then
				return "|cffFF2222_|r"
			end
		end
		oUF.Tags.Events["WM"..i] = "PLAYER_TOTEM_UPDATE"
		oUF.UnitlessTagEvents.PLAYER_TOTEM_UPDATE = true
	end
end


oUF.Tags.Events['nameshort'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['nameshort'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 9, false)
end

oUF.Tags.Events['namemedium'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['namemedium'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 10, false)
end

oUF.Tags.Events['namelong'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['namelong'] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 35, true)
end

oUF.Tags.Methods['hp']  = function(u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags.Methods['DDG'](u)
	else
		local per = oUF.Tags.Methods['perhp'](u) or 0
		if per < 100 or per < 1 then
			local min = UnitHealth(u)
			return ShortValue( min) .. " | " .. per .. "%"
		--else
			--local max = UnitHealthMax(u)
			--return ShortValue( max)
		end
	end
end
oUF.Tags.Events['hp'] = 'UNIT_HEALTH'

oUF.Tags.Methods['per']  = function(u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags.Methods['DDG'](u)
	else
		local per = oUF.Tags.Methods['perhp'](u) or 0
		if per < 100 or per < 1 then
			return per .. "%"
		end
	end
end

oUF.Tags.Events['per'] = 'UNIT_HEALTH'

oUF.Tags.Methods['power']  = function(u)
	local min, max = UnitPower(u), UnitPowerMax(u)
	if min~=max then
		return SVal(min)
	else
		return SVal(max)
	end
end
oUF.Tags.Events['power'] = 'UNIT_POWER'



oUF.Tags.Methods['color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")

	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events['color'] = 'UNIT_HEALTH'

oUF.Tags.Methods["afk"] = function(unit)

	return UnitIsAFK(unit) and "|cffCFCFCF afk|r" or ""
end
oUF.Tags.Events["afk"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods['DDG'] = function(u)
	if UnitIsDead(u) then
		return "Dead"
	elseif UnitIsGhost(u) then
		return "Ghost"
	elseif not UnitIsConnected(u) then
		return "D/C"
	end
end
oUF.Tags.Events['DDG'] = 'UNIT_HEALTH'

-- oUF.Tags.Methods['DDG'] = function(u)
	-- if UnitIsDead(u) then
		-- return "|cffCFCFCF Dead|r"
	-- elseif UnitIsGhost(u) then
		-- return "|cffCFCFCF Ghost|r"
	-- elseif not UnitIsConnected(u) then
		-- return "|cffCFCFCF D/C|r"
	-- end
-- end
-- oUF.Tags.Events['DDG'] = 'UNIT_HEALTH'

oUF.Tags.Methods['LFD'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff8AFF30H|r"
	elseif role == "TANK" then
		return "|cff5F9BFFT|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161D|r"
	end
end
oUF.Tags.Events['LFD'] = 'PLAYER_ROLES_ASSIGNED'
-- Level
oUF.Tags.Methods["level"] = function(unit)

	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)

	local str = l

	if l <= 0 then l = "??" end

	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end
	end

	return str
end
oUF.Tags.Events["level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- AltPower value tag
oUF.Tags.Methods['altpower'] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if(max > 0 and not UnitIsDeadOrGhost(unit)) then
		return ("%s%%"):format(math.floor(cur/max*100+.5))
	end
end
oUF.Tags.Events['altpower'] = 'UNIT_POWER'

oUF.Tags.Methods["NameplateHealth"] = function(unit)
	local hp = UnitHealth(unit)
	local maxhp = UnitHealthMax(unit)
	if maxhp == 0 then
		return 0
	else
		return ("%s - %d%%"):format( ShortValue(hp), hp / maxhp * 100 + 0.5)
	end
end
oUF.Tags.Events["NameplateHealth"] = "UNIT_HEALTH UNIT_MAXHEALTH NAME_PLATE_UNIT_ADDED"

oUF.Tags.Methods["NameplateLevel"] = function(unit)
	local level = UnitLevel(unit)
	local c = UnitClassification(unit)
	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
	end

	if level == UnitLevel( "player") and c == "normal" then return end
	if level > 0 then
		return level
	else
		return "??"
	end
end
oUF.Tags.Events["NameplateLevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP"

oUF.Tags.Methods["NameplateNameColor"] = function(unit)
	local reaction = UnitReaction(unit, "player")
	if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) and (reaction and reaction >= 5) then
		local c = yo_Party[1].colors.power["MANA"]
		return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
	elseif UnitIsPlayer(unit) then
		return _TAGS["raidcolor"](unit)
	elseif reaction then
		local c = yo_Player.colors.reaction[reaction]
		return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = 0.33, 0.59, 0.33
		return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end
oUF.Tags.Events["NameplateNameColor"] = "UNIT_POWER_UPDATE UNIT_FLAGS"

oUF.Tags.Methods["NameLongAbbrev"] = function(unit)
	local name = UnitName(unit)
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return utf8sub(newname, 18, false)
end
oUF.Tags.Events["NameLongAbbrev"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["DiffColor"] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if level < 1 then
		r, g, b = 0.69, 0.31, 0.31
	else
		local DiffColor = UnitLevel(unit) - UnitLevel("player")
		if DiffColor >= 5 then
			r, g, b = 0.69, 0.31, 0.31
		elseif DiffColor >= 3 then
			r, g, b = 0.71, 0.43, 0.27
		elseif DiffColor >= -2 then
			r, g, b = 0.84, 0.75, 0.65
		elseif -DiffColor <= GetQuestGreenRange() then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end
oUF.Tags.Events["DiffColor"] = "UNIT_LEVEL"
