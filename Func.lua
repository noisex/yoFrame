
----------------------------------------------------------------------------------------
--	Kill object function
----------------------------------------------------------------------------------------
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()
function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = dummy
	end
	object:Hide()
end

function formatMoney(money, noColor)	
	local goldColor, silverColor, copperColor, back = "|cffffaa00", "|cffbbbbbb", "|cffff6600", "|r"
	if noColor then
		goldColor, silverColor, copperColor, back = "", "", "", ""
	end

	local gold   = commav( floor(math.abs(money) / 10000))
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	gold = tonumber(gold) ~= 0 and 	goldColor   .. format( GOLD_AMOUNT_TEXTURE_STRING, gold) .. back .. " "	or ""
	silver = 	silver ~= 0 and 	silverColor .. format( SILVER_AMOUNT_TEXTURE, silver) 	 .. back .. " "	or ""
	copper = 	copper ~= 0 and 	copperColor .. format( COPPER_AMOUNT_TEXTURE, copper)    .. back 		or ""

	return gold .. silver .. copper
end

function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255), r, g, b
end

function tprint(t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
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

function ShortValue( value)
	if value >= 1e11 then
		return ("%.0fb"):format(value / 1e9)
	elseif value >= 1e10 then
		return ("%.1fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e9 then
		return ("%.2fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e8 then
		return ("%.0fm"):format(value / 1e6)
	elseif value >= 1e7 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e6 then
		return ("%.2fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e5 then
		return ("%.0fk"):format(value / 1e3)
	elseif value >= 1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

function utf8sub(string, i, dots)
    i = math.floor( i)
    if not string then return end
    local bytes = string:len()
    if bytes <= i then
        return string
    else
        local len, pos = 0, 1
        while (pos <= bytes) do
            len = len + 1
            local c = string:byte(pos)
            if c > 0 and c <= 127 then
                pos = pos + 1
            elseif c >= 192 and c <= 223 then
                pos = pos + 2
            elseif c >= 224 and c <= 239 then
                pos = pos + 3
            elseif c >= 240 and c <= 247 then
                pos = pos + 4
            end
            if len == i then break end
        end
        if len == i and pos <= bytes then
            return string:sub(1, pos - 1)..(dots and "..." or "")
        else
            return string
        end
    end
end

function formatTime( s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

function formatTimeSec( s)
	local day, hour, minute = 86400, 3600, 60
	if s == -1 then
		return LESS_THAN_ONE_MINUTE, s
	elseif s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	--elseif s >= minute / 12 then
	--	return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%ds", s), (s * 100 - floor(s * 100))/100
end

function SecondsToClock(seconds, noSec, noMin)
  local seconds = tonumber(seconds)

  if seconds <= 0 then   --return "00:00:00";
    return LESS_THAN_ONE_MINUTE;
  else
  	local years	= floor(seconds/31556926)
  	local month	= floor(mod(seconds, 31556926)/ 2592000)
  	local days 	= floor(mod(seconds, 2592000)/ 86400)
  	local hours	= floor(mod(seconds, 86400)/3600)
  	local mins 	= noMin and 0 or floor(mod(seconds,3600)/60)
  	local secs 	= noSec and 0 or floor(mod(seconds,60))

  	years 	= years == 0 and "" or ( format( LASTONLINE_YEARS, years) .. " ")
  	month 	= month == 0 and "" or ( format( LASTONLINE_MONTHS, month) .. " ")
    days 	= days  == 0 and "" or ( format( LASTONLINE_DAYS, days) .. " ") 
    hours 	= hours == 0 and "" or ( format( LASTONLINE_HOURS, hours) .. " ")
	mins 	= mins  == 0 and "" or ( format( LASTONLINE_MINUTES, mins) .. " ")
	secs 	= secs  == 0 and "" or ( format( INT_SPELL_DURATION_SEC, secs))

    return years..month..days..hours..mins..secs
  end
end

function timeFormatMS(timeAmount)
	local seconds = floor(timeAmount / 1000)
	local ms = timeAmount - seconds * 1000
	local hours = floor(seconds / 3600)
	local minutes = floor((seconds / 60) - (hours * 60))
	seconds = seconds - hours * 3600 - minutes * 60

	if hours == 0 then
		return format("%d:%.2d.%.3d", minutes, seconds, ms)
	else
		return format("%d:%.2d:%.2d.%.3d", hours, minutes, seconds, ms)
	end
end

function commav(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end
	
function nums(num)
	TRILLION = 1000000000000
	BILLION  = 1000000000
	MILLION  = 1000000
	THOUSAND = 1000

    if not num then return " " end
    if num == 0 then return "0" end
    if num < THOUSAND then
        return math.floor(num)
    elseif num >= TRILLION then
        return string.format('%.3ft', num/TRILLION)
    elseif num >= BILLION then
        return string.format('%.3fb', num/BILLION)
    elseif num >= MILLION then
        return string.format('%.2fm', num/MILLION)
    elseif num >= THOUSAND then
        return string.format('%.1fk', num/THOUSAND)
    end
end

function CreateVirtualFrame(frame, point, size, alpha, alphaback)
	if point == nil then point = frame end
	if point.backdrop then return end

	size = ( size or 3)
	alpha = ( alpha or 1)
	alphaback = ( alphaback or 0)

	frame.back = frame:CreateTexture(nil, "BORDER")
	frame.back:SetDrawLayer("BORDER", -8)
	frame.back:SetPoint("TOPLEFT", point, "TOPLEFT", -3, 3)
	frame.back:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", 3, -3)
	frame.back:SetColorTexture( 0.15, 0.15, 0.15, alphaback) 

	frame.bordertop = frame:CreateTexture(nil, "BORDER")
	frame.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -size, size)
	frame.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, size)
	frame.bordertop:SetHeight( size)
	frame.bordertop:SetColorTexture( 0, 0, 0, alpha)
	frame.bordertop:SetDrawLayer("BORDER", -7)

	frame.borderbottom = frame:CreateTexture(nil, "BORDER")
	frame.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -size, -size)
	frame.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", size, -size)
	frame.borderbottom:SetHeight( size)
	frame.borderbottom:SetColorTexture( 0, 0, 0, alpha)
	frame.borderbottom:SetDrawLayer("BORDER", -7)

	frame.borderleft = frame:CreateTexture(nil, "BORDER")
	frame.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -size, 0)
	frame.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", size, 0)
	frame.borderleft:SetWidth( size)
	frame.borderleft:SetColorTexture( 0, 0, 0, alpha)
	frame.borderleft:SetDrawLayer("BORDER", -7)

	frame.borderright = frame:CreateTexture(nil, "BORDER")
	frame.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, 0)
	frame.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -size, 0)
	frame.borderright:SetWidth( size)
	frame.borderright:SetColorTexture( 0, 0, 0, alpha)
	frame.borderright:SetDrawLayer("BORDER", -7)
end

function SetVirtualBorder(frame, r, g, b)
	if not frame.bordertop then
		CreateVirtualFrame(frame)
	end

	frame.bordertop:SetColorTexture(r, g, b)
	frame.borderbottom:SetColorTexture(r, g, b)
	frame.borderleft:SetColorTexture(r, g, b)
	frame.borderright:SetColorTexture(r, g, b)
end

function CreateBorder( f)
	if f.border then return end
	
	f.border = CreateFrame( "Button", nil, f)
	f.border:SetAllPoints( f)
	f.border:SetFrameLevel( level or 0)
	f.border:SetFrameStrata( f:GetFrameStrata())
	--f.border:SetFrameStrata( "BACKGROUND")

	f.border.glow = f.border:CreateTexture(nil, "BORDER")
	f.border.glow:SetPoint( "CENTER", f.border, "CENTER", 0, 0)
	f.border.glow:SetVertexColor( 0.15, 0.15, 0.15, 0.9)
	f.border.glow:SetTexture( "Interface\\Buttons\\UI-Quickslot2")
	f.border.glow:SetHeight( f:GetHeight() * 1.85)
	f.border.glow:SetWidth( f:GetWidth() * 1.85)
end

function CreateStyle(f, size, level, alpha, alphaborder) 
    if f.shadow then return end

	local style = {
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = texglow, 
		edgeSize = 4,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
    local shadow = CreateFrame("Frame", nil, f)
    shadow:SetFrameLevel(level or 0)
    shadow:SetFrameStrata(f:GetFrameStrata())
    shadow:SetPoint("TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop(style)
    shadow:SetBackdropColor(.08,.08,.08, alpha or .9)
    shadow:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
    f.shadow = shadow
    return shadow
end

function CreatePanel(f, w, h, a1, p, a2, x, y, alpha, alphaborder)
	f:SetFrameLevel( 1)
	f:SetHeight( h)
	f:SetWidth( w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
      edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = 1, 
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(.05,.05,.05, alpha or .9)
	f:SetBackdropBorderColor(.15,.15,.15, alphaborder  or 0)
	return f
end

function frame1px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(.05,.05,.05, .9)
	f:SetBackdropBorderColor(.15,.15,.15, 0)	
end 

function SimpleBackground(f, w, h, a1, p, a2, x, y, alpha, alphaborder)
	--local _, class = UnitClass("player")
	--local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	f:SetFrameLevel(1)
	f:SetHeight(h)
	f:SetWidth(w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = texture,
		edgeFile = texture, 
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	f:SetBackdropColor(.07,.07,.07, alpha or 1)
	f:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
end

