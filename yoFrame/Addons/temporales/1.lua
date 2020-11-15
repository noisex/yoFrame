foo = {}
mt  = {}
function mt.__newindex(self, key, value)
	--foo[key] = value
	table.insert( foo, key)
	rawset( self, key, value)
end

bar = setmetatable({a = 10}, mt)
bar.key6 = 'value11'
bar.key1 = 'value11'
bar.key2 = 'value22'
bar.key1 = 'value333'
bar.key5 = 'value11'
bar.key1 = 'value11'

--print(foo, mt, bar)
print('bar.key', bar.key1) --> nil
print('foo.key', foo.key1) --> 'value'

print("---------------")

for i,v in pairs(bar) do
	print(i,v)
end

table.sort( foo)

print("---------------")
for i,v in pairs(foo) do
	print(i,v)
end

--local str = "1111.222 .3333;\n44444,455555"

----s = "from=world, to=Lua"
--for k, v in string.gmatch( str, "(%d+)" ) do
--    print( tonumber(k), v)
--end

--print("-----")
--local str = "asdsadsad sadsad as   .\n     fsd fsdfpdsf.33333; werewrwer  wer,    rrew r rwe 23423                             "
--local f = "-%s-%s-"

--str = string.gsub( str, "\n", ",")
----print(str)

----t = {}
----s = "from=world, to=Lua"
--for k, v in string.gmatch( str, "%s*(%P+)" ) do
--    --t[k] = v
--    k = string.gsub( k, "%s+$", "" )
--    print( string.format( f, k, " "))
--end

--tprint(t)
--local bars = {
--	["bar1"] = { 1, 1, 1, 1},
--	["bar2"] = { 1, 1, 1, 1},
--	["bar3"] = { 1, 1, 1, 1},
--	["bar4"] = { 1, 1, 1, 1},
--	["bar5"] = { 1, 1, 1, 1},
--	["bar6"] = { 1, 1, 1, 1},
--	["bar7"] = { 1, 1, 1, 1},
--}

--print( table.maxn(bars))

--local t = { [223]="asd", [23]="fgh", [543]="hjk", [7]="qwe" }
--local tkeys = {}
---- populate the table that holds the keys
--for k in pairs(t) do table.insert(tkeys, k) end
---- sort the keys
--table.sort(tkeys)
---- use the keys to retrieve the values in the sorted order
--for _, k in ipairs(tkeys) do print(k, t[k]) end

--local a = false
local b = false
local a = true
--local b = true

--local n = "name"
--local t = ""

local afk = " |cffFF0000[AFK]|r "
local dnd = " |cff0000ff[DND] |r"

t = ( b and dnd) or (a and afk) or  "----"

print(t)
--function hex(r, g, b)
--	if r then
--		if (type(r) == 'table') then
--			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
--		end
--		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
--	end
--end
----["CHAT_MSG_BN_WHISPER_INFORM"]	= {	r = 0.172, g = 0.635, b = 1.000, d = " < "},
--bnetColor = hex( 0.000, 0.486, 0.654)
--bnetColor = hex( 0.172, 0.635, 1)
--print(bnetColor)

--function spairs(t, order)
--    -- collect the keys
--    local keys = {}
--    for k in pairs(t) do keys[#keys+1] = k end

--    -- if order function given, sort by it by passing the table and keys a, b,
--    -- otherwise just sort the keys
--    if order then
--        table.sort(keys, function(a,b) return order(t, a, b) end)
--    else
--        table.sort(keys)
--    end

--    -- return the iterator function
--    local i = 0
--    return function()
--        i = i + 1
--        if keys[i] then
--            return keys[i], t[keys[i]]
--        end
--    end
--end

--local arr = { a = 1, b = 2, c = 3, d = 5, e = 4}

--for k,v in spairs( arr, function(t,a,b) return t[b] < t[a] end) do
--    print(k,v)
--end
--print("...")
--for k,v in spairs( arr, function(t,a,b) return t[b] > t[a] end) do
--    print(k,v)
--end
--print("...")
--for k,v in pairs(arr) do
--	print(k,v)
--end