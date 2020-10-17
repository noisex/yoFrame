local addon, ns = ...
local L, yo, N = unpack( ns)

local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub
local texture, texglow = yo.texture, yo.texglow


function formatMoney(money, noColor)
	local goldColor, silverColor, copperColor, back = "|cffffaa00", "|cffbbbbbb", "|cffff6600", "|r"
	if noColor then
		goldColor, silverColor, copperColor, back = "", "", "", ""
	end

	if money == 0 then return format( copperColor .. COPPER_AMOUNT_TEXTURE, money) end

	local gold   = commav( floor(math.abs(money) / 10000))
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	gold = tonumber(gold) ~= 0 and 	goldColor   .. format( GOLD_AMOUNT_TEXTURE_STRING, gold) .. back .. " "	or ""
	silver = 	silver ~= 0 and 	silverColor .. format( SILVER_AMOUNT_TEXTURE, silver) 	 .. back .. " "	or ""
	copper = 	copper ~= 0 and 	copperColor .. format( COPPER_AMOUNT_TEXTURE, copper)    .. back 		or ""

	return gold .. silver .. copper
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

function paddString(str, paddingChar, minLength, paddRight)
    str = tostring(str or "");
    paddingChar = tostring(paddingChar or " ");
    minLength = tonumber(minLength or 0);
    while(string.len(str) < minLength) do
        if(paddRight) then
            str = str..paddingChar;
        else
            str = paddingChar..str;
        end
    end
    return str;
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

function SplitToTable(str, inSplitPattern, outResults )
  if not outResults then
    return;
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( str, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( str, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( str, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( str, theStart ) )
  --if(#outResults > 0) then
  --  table.remove(outResults, 1);
  --end
end