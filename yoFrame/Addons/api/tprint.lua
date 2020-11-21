
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
