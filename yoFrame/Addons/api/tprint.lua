
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
            	print( format( "%s: %-30s %-10s = %s", type(t), s or '', kfmt, vfmt))
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
