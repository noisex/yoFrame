local addon, ns = ...
local L, yo, N = unpack( ns)


function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255), r, g, b
end

function GetColors( f)

	local colors = {
		disc = {.3, .3, .3},
		tapped = {.6,.6,.6},
		class = {},
		reaction = {},
	}
	for eclass, color in next, RAID_CLASS_COLORS do
		colors.class[eclass] = {color.r, color.g, color.b}
	end
	for eclass, color in next, FACTION_BAR_COLORS do
		colors.reaction[eclass] = {color.r, color.g, color.b}
	end
	f.colors = colors
end


function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end
