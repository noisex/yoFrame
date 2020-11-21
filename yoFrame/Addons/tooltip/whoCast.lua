local addon, ns = ...

local L, yo, N = unpack( ns)
local oUF = ns.oUF

if not yo.ToolTip.enable then return end

----------------------------------------------------------------------------------------
--	Tells you who cast a buff or debuff in its tooltip(prButler by Renstrom)
----------------------------------------------------------------------------------------

local T = {}
T.class = select(2, UnitClass("player"))
T.color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.class]

local function addAuraSource(self, func, unit, index, filter)
	local srcUnit = select(7, func(unit, index, filter))
	--print(srcUnit, unit, index, filter)
	if srcUnit then
		local src = GetUnitName(srcUnit, true)
		if srcUnit == "pet" or srcUnit == "vehicle" then
			src = format("%s (|cff%02x%02x%02x%s|r)", src, T.color.r * 255, T.color.g * 255, T.color.b * 255, GetUnitName("player", true))
		else
			local partypet = srcUnit:match("^partypet(%d+)$")
			local raidpet = srcUnit:match("^raidpet(%d+)$")
			if partypet then
				src = format("%s (%s)", src, GetUnitName("party"..partypet, true))
			elseif raidpet then
				src = format("%s (%s)", src, GetUnitName("raid"..raidpet, true))
			end
		end
		if UnitIsPlayer(srcUnit) then
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(srcUnit))]
			if color then
				src = format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, src)
			end
		else
			local color = oUF.colors.reaction[UnitReaction(srcUnit, "player")]
			if color then
				src = format("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, src)
			end
		end
		self:AddDoubleLine( "Caster:", src)
		self:Show()
	end
end

local funcs = {
	SetUnitAura = UnitAura,
	SetUnitBuff = UnitBuff,
	SetUnitDebuff = UnitDebuff,
}

for k, v in pairs(funcs) do
	hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
		addAuraSource(self, v, unit, index, filter)
	end)
end
