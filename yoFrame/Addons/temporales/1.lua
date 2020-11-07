local bars = {
	["bar1"] = { 1, 1, 1, 1},
	["bar2"] = { 1, 1, 1, 1},
	["bar3"] = { 1, 1, 1, 1},
	["bar4"] = { 1, 1, 1, 1},
	["bar5"] = { 1, 1, 1, 1},
	["bar6"] = { 1, 1, 1, 1},
	["bar7"] = { 1, 1, 1, 1},
}

print( table.maxn(bars))

local t = { [223]="asd", [23]="fgh", [543]="hjk", [7]="qwe" }
local tkeys = {}
-- populate the table that holds the keys
for k in pairs(t) do table.insert(tkeys, k) end
-- sort the keys
table.sort(tkeys)
-- use the keys to retrieve the values in the sorted order
for _, k in ipairs(tkeys) do print(k, t[k]) end

local a = false
local b = false
local a = true
--local b = true

local n = "name"
local t = ""

local afk = " |cffFF0000[AFK]|r "
local dnd = " |cff0000ff[DND] |r"

t = ( b and dnd) or (a and afk) or  "----"

function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end
--["CHAT_MSG_BN_WHISPER_INFORM"]	= {	r = 0.172, g = 0.635, b = 1.000, d = " < "},
bnetColor = hex( 0.000, 0.486, 0.654)
bnetColor = hex( 0.172, 0.635, 1)
print(bnetColor)

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local arr = { a = 1, b = 2, c = 3, d = 5, e = 4}

for k,v in spairs( arr, function(t,a,b) return t[b] < t[a] end) do
    print(k,v)
end
print("...")
for k,v in spairs( arr, function(t,a,b) return t[b] > t[a] end) do
    print(k,v)
end
print("...")
for k,v in pairs(arr) do
	print(k,v)
end