local addon, ns = ...
local L, yo, n = unpack( ns)

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

--usage
--for k,v in spairs( arr, function(t,a,b) return t[b] '<' / '>' t[a] end) do
--    print(k,v)
--end
-----------------------------------------------------------------------------------------------
--                  Count Piars Table
-----------------------------------------------------------------------------------------------

function n.tCount( table)
    local index = 0
    for k in pairs( table) do
        index = index + 1
    end
    return index
end

-----------------------------------------------------------------------------------------------
--                  DeepCopy Full Table
-----------------------------------------------------------------------------------------------

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


-----------------------------------------------------------------------------------------------
--                  Table Print
-----------------------------------------------------------------------------------------------
function tprint(t, s, indent)
    if not t or type( t) ~= "table" then
        dprint( "This is not a table!")
        return
    end

	--print(indent)
	if not indent then indent = 0 end

    for k, v in pairs(t) do
    	local meta = tostring(k):find( "__")
        local kfmt = '[' .. tostring(k) ..']'
        local vfmt = '"'.. tostring(v) ..'"'

        if not meta then
        	if type(v) == 'table' and type(v) ~= 'userdata' and indent < 2 then
            	tprint(v, (s or '')..kfmt, indent + 1)
        	else
            	if type(v) ~= 'string' then
                	vfmt = tostring(v)
            	end
            	print( format( "%s:%-8s %s=%s", type(t), s or '', kfmt, vfmt))
        	end
        end
    end
end


function tdump (t, s, deep)
    s = s or ""
    deep = deep or 0
    local space = ""
    for i = 1, deep do
        space = space .. "   "
    end

    for key, value in pairs (t) do
        local tpe = _type (value)

        if (type (key) == "function") then
            key = "#function#"
        elseif (type (key) == "table") then
            key = "#table#"
        end

        if (type (key) ~= "string" and type (key) ~= "number") then
            key = "unknown?"
        end

        if (tpe == "table") then
            if (type (key) == "number") then
                s = s .. space .. "[" .. key .. "] = |cFFa9ffa9 {|r\n"
            else
                s = s .. space .. "[\"" .. key .. "\"] = |cFFa9ffa9 {|r\n"
            end
            s = s .. DF.table.dump (value, nil, deep+1)
            s = s .. space .. "|cFFa9ffa9},|r\n"

        elseif (tpe == "string") then
            s = s .. space .. "[\"" .. key .. "\"] = \"|cFFfff1c1" .. value .. "|r\",\n"

        elseif (tpe == "number") then
            s = s .. space .. "[\"" .. key .. "\"] = |cFFffc1f4" .. value .. "|r,\n"

        elseif (tpe == "function") then
            s = s .. space .. "[\"" .. key .. "\"] = function()end,\n"

        elseif (tpe == "boolean") then
            s = s .. space .. "[\"" .. key .. "\"] = |cFF99d0ff" .. (value and "true" or "false") .. "|r,\n"
        end
    end

    return s
end



--function tprint(t, s, indent)
--	if not indent then indent = 0 end

--    for k, v in pairs(t) do
--    	local meta = tostring(k):find( "__")
--    	--print( tostring(k), meta, tostring(v) )

--        local kfmt = '["' .. tostring(k) ..'"]'

--        if type(k) ~= 'string' then
--            kfmt = '[' .. tostring(k) .. ']'
--        end

--        local vfmt = '"'.. tostring(v) ..'"'
--        if not meta then
--        	if type(v) == 'table' and type(v) ~= 'userdata' and indent < 1 then
--        		indent = indent + 1
--            	tprint(v, (s or '')..kfmt, indent)
--        	else
--            	if type(v) ~= 'string' then
--                	vfmt = tostring(v)
--            	end
--            	print(type(t), (s or ''), kfmt, ' = ', vfmt)
--        	end
--        end
--    end
--end

--function tprint (tbl, indent)
--	--tbl = tableAPIShow( tbl)
--  	if not indent then indent = 0 end
--  	for k, v in pairs(tbl) do
--    	formatting = string.rep("-", indent) .. k or "--" .. ": "
--    	if type(v) == "table" then
--      		print(formatting)
--      		tprint(v, indent+1)
--    	elseif type(v) == 'boolean' then
--      		print(formatting, tostring(v))
--    	else
--      		print(formatting, v)
--    	end
--  	end
--end
