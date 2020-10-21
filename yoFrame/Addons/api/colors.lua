local addon, ns = ...
local L, yo, N = unpack( ns)


function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255), r, g, b
end

function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

function GetColors( f)

	local colors = {
		disconnected = { .2 , .2, .2},
		tapped = {.6,.6,.6},
		runes = {
			{247 / 255, 65 / 255, 57 / 255}, -- blood
			{148 / 255, 203 / 255, 247 / 255}, -- frost
			{173 / 255, 235 / 255, 66 / 255}, -- unholy
		},
		selection = {
			[ 0] = {255 / 255, 0 / 255, 0 / 255}, -- HOSTILE
			[ 1] = {255 / 255, 129 / 255, 0 / 255}, -- UNFRIENDLY
			[ 2] = {255 / 255, 255 / 255, 0 / 255}, -- NEUTRAL
			[ 3] = {0 / 255, 255 / 255, 0 / 255}, -- FRIENDLY
			[ 4] = {0 / 255, 0 / 255, 255 / 255}, -- PLAYER_SIMPLE
			[ 5] = {96 / 255, 96 / 255, 255 / 255}, -- PLAYER_EXTENDED
			[ 6] = {170 / 255, 170 / 255, 255 / 255}, -- PARTY
			[ 7] = {170 / 255, 255 / 255, 170 / 255}, -- PARTY_PVP
			[ 8] = {83 / 255, 201 / 255, 255 / 255}, -- FRIEND
			[ 9] = {128 / 255, 128 / 255, 128 / 255}, -- DEAD
			-- [10] = {}, -- COMMENTATOR_TEAM_1, unavailable to players
			-- [11] = {}, -- COMMENTATOR_TEAM_2, unavailable to players
			[12] = {255 / 255, 255 / 255, 139 / 255}, -- SELF, buggy
			[13] = {0 / 255, 153 / 255, 0 / 255}, -- BATTLEGROUND_FRIENDLY_PVP
		},
		class = {},
		reaction = {},
		debuff = {},
		power = {},
		threat = {},
	}

	for eclass, color in next, RAID_CLASS_COLORS do
		colors.class[eclass] = {color.r, color.g, color.b}
	end
	for eclass, color in next, FACTION_BAR_COLORS do
		colors.reaction[eclass] = {color.r, color.g, color.b}
	end
	for debuffType, color in next, DebuffTypeColor do
		colors.debuff[debuffType] = {color.r, color.g, color.b}
	end
	for i = 0, 3 do
		colors.threat[i] = {GetThreatStatusColor(i)}
	end
	for power, color in next, PowerBarColor do
		if (type(power) == 'string') then
			if(type(select(2, next(color))) == 'table') then
				colors.power[power] = {}

				for index, color in next, color do
					colors.power[power][index] = {color.r, color.g, color.b}
				end
			else
				colors.power[power] = {color.r, color.g, color.b, atlas = color.atlas}
			end
		end
	end

	-- sourced from FrameXML/Constants.lua
	colors.power[0] = colors.power.MANA
	colors.power[1] = colors.power.RAGE
	colors.power[2] = colors.power.FOCUS
	colors.power[3] = colors.power.ENERGY
	colors.power[4] = colors.power.COMBO_POINTS
	colors.power[5] = colors.power.RUNES
	colors.power[6] = colors.power.RUNIC_POWER
	colors.power[7] = colors.power.SOUL_SHARDS
	colors.power[8] = colors.power.LUNAR_POWER
	colors.power[9] = colors.power.HOLY_POWER
	colors.power[11] = colors.power.MAELSTROM
	colors.power[12] = colors.power.CHI
	colors.power[13] = colors.power.INSANITY
	colors.power[16] = colors.power.ARCANE_CHARGES
	colors.power[17] = colors.power.FURY
	colors.power[18] = colors.power.PAIN

	-- alternate power, sourced from FrameXML/CompactUnitFrame.lua
	colors.power.ALTERNATE = {0.7, 0.7, 0.6}
	colors.power[10] = colors.power.ALTERNATE

	f.colors = colors
end

