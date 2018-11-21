
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

function SetUpAnimGroup(object, type, ...)
	if not type then type = 'Flash' end

	if type == 'Flash' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
		object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
		object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)
	elseif type == 'FlashLoop' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
		object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
		object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)

		object.anim:SetScript("OnFinished", function(_, requested)
			if(not requested) then
				object.anim:Play()
			end
		end)
	elseif type == 'Shake' then
		object.shake = object:CreateAnimationGroup("Shake")
		object.shake:SetLooping("REPEAT")
		object.shake.path = object.shake:CreateAnimation("Path")
		object.shake.path[1] = object.shake.path:CreateControlPoint()
		object.shake.path[2] = object.shake.path:CreateControlPoint()
		object.shake.path[3] = object.shake.path:CreateControlPoint()
		object.shake.path[4] = object.shake.path:CreateControlPoint()
		object.shake.path[5] = object.shake.path:CreateControlPoint()
		object.shake.path[6] = object.shake.path:CreateControlPoint()

		object.shake.path:SetDuration(0.7)
		object.shake.path[1]:SetOffset(random(-9, 7), random(-7, 12))
		object.shake.path[1]:SetOrder(1)
		object.shake.path[2]:SetOffset(random(-5, 9), random(-9, 5))
		object.shake.path[2]:SetOrder(2)
		object.shake.path[3]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[3]:SetOrder(3)
		object.shake.path[4]:SetOffset(random(-9, 9), random(-9, 9))
		object.shake.path[4]:SetOrder(4)
		object.shake.path[5]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[5]:SetOrder(5)
		object.shake.path[6]:SetOffset(random(-9, 7), random(-9, 5))
		object.shake.path[6]:SetOrder(6)
	elseif type == 'Shake_Horizontal' then
		object.shakeh = object:CreateAnimationGroup("ShakeH")
		object.shakeh:SetLooping("REPEAT")
		object.shakeh.path = object.shakeh:CreateAnimation("Path")
		object.shakeh.path[1] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[2] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[3] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[4] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[5] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[6] = object.shakeh.path:CreateControlPoint()

		object.shakeh.path:SetDuration(2)
		object.shakeh.path[1]:SetOffset(-5, 0)
		object.shakeh.path[1]:SetOrder(1)
		object.shakeh.path[2]:SetOffset(5, 0)
		object.shakeh.path[2]:SetOrder(2)
		object.shakeh.path[3]:SetOffset(-2, 0)
		object.shakeh.path[3]:SetOrder(3)
		object.shakeh.path[4]:SetOffset(5, 0)
		object.shakeh.path[4]:SetOrder(4)
		object.shakeh.path[5]:SetOffset(-2, 0)
		object.shakeh.path[5]:SetOrder(5)
		object.shakeh.path[6]:SetOffset(5, 0)
		object.shakeh.path[6]:SetOrder(6)

	elseif type == 'Fadein' then
		local minAlpha, maxAlpha, duration, finalAlpha, parent = ...
		object.Fadein = object:CreateAnimationGroup( "Fadein")
		object.Fadein:SetToFinalAlpha( finalAlpha)

		object.Fadein.AlphaAnim = object.Fadein:CreateAnimation("Alpha")
		object.Fadein.AlphaAnim:SetFromAlpha( minAlpha or 0)
		object.Fadein.AlphaAnim:SetToAlpha( maxAlpha or 1)
		object.Fadein.AlphaAnim:SetDuration( duration or 0.5)		
		--object.Fadein.AlphaAnim:SetSmoothing("IN")
		object.Fadein.maxAlpha = maxAlpha or 1
  		if parent then object.Fadein.AlphaAnim:SetTarget( parent) end  		
  		--object.Fadein:SetScript("OnFinished", function() 	--	object.Fadein.AlphaAnim:GetTarget():SetAlpha( object.Fadein.maxAlpha) --end)
  		
	elseif type == 'Fadeout' then
		local minAlpha, maxAlpha, duration, finalAlpha, parent = ...
		object.Fadeout = object:CreateAnimationGroup( "Fadeout")
		object.Fadeout:SetToFinalAlpha( finalAlpha)

		object.Fadeout.AlphaAnim = object.Fadeout:CreateAnimation("Alpha")
		object.Fadeout.AlphaAnim:SetFromAlpha( maxAlpha or 1)
		object.Fadeout.AlphaAnim:SetToAlpha( minAlpha or 0)
		object.Fadeout.AlphaAnim:SetDuration( duration or 0.5)
		--object.Fadeout.AlphaAnim:SetSmoothing("OUT")
		object.Fadeout.minAlpha = minAlpha or 0
		if parent then	object.Fadeout.AlphaAnim:SetTarget( parent)	end  		
		--object.Fadeout:SetScript("OnFinished", function()	--	object.Fadeout.AlphaAnim:GetTarget():SetAlpha( object.Fadeout.minAlpha) --end )
	else
		local x, y, duration, customName = ...
		if not customName then
			customName = 'anim'
		end
		object[customName] = object:CreateAnimationGroup("Move_In")
		object[customName].in1 = object[customName]:CreateAnimation("Translation")
		object[customName].in1:SetDuration(0)
		object[customName].in1:SetOrder(1)
		object[customName].in2 = object[customName]:CreateAnimation("Translation")
		object[customName].in2:SetDuration(duration)
		object[customName].in2:SetOrder(2)
		object[customName].in2:SetSmoothing("OUT")
		object[customName].out1 = object:CreateAnimationGroup("Move_Out")
		object[customName].out2 = object[customName].out1:CreateAnimation("Translation")
		object[customName].out2:SetDuration(duration)
		object[customName].out2:SetOrder(1)
		object[customName].out2:SetSmoothing("IN")
		object[customName].in1:SetOffset( (x), (y))
		object[customName].in2:SetOffset( (-x),(-y))
		object[customName].out2:SetOffset((x), (y))
		object[customName].out1:SetScript("OnFinished", function() object:Hide() end)
	end
end

function TurnOn(frame, texture, toAlpha)
	print(frame, texture, toAlpha)
	local alphaValue = texture:GetAlpha();
	frame.Fadein:Stop();
	frame.Fadeout:Stop();
	texture:SetAlpha(alphaValue);
	frame.on = true;
	if (alphaValue < toAlpha) then
		if (texture:IsVisible()) then
			frame.Fadein.AlphaAnim:SetFromAlpha(alphaValue);
			frame.Fadein:Play();
		else
			texture:SetAlpha(toAlpha);
		end
	end
end

function TurnOff(frame, texture, toAlpha)
	local alphaValue = texture:GetAlpha();
	frame.Fadein:Stop();
	frame.Fadeout:Stop();
	texture:SetAlpha(alphaValue);
	frame.on = false;
	if (alphaValue > toAlpha) then
		if (texture:IsVisible()) then
			frame.Fadeout.AlphaAnim:SetFromAlpha(alphaValue);
			frame.Fadeout:Play();
		else
			texture:SetAlpha(toAlpha);
		end
	end
end

function makeUIButton(id, text, w, h, x, y)
	local button = CreateFrame("Button", id, InboxFrame, "UIPanelButtonTemplate")
	button:SetWidth(w)
	button:SetHeight(h)
	button:SetPoint("CENTER", InboxFrame, "TOP", x, y)
	button:SetText(text)
	return button
end

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

function gradient(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255), r, g, b
end


function timeLastWeeklyReset()
	local resetDays = { 2, 4, 3, 4, 4}
	local region = GetCurrentRegion()
	
	local weekDayReset = resetDays[region]
	local nextResetTime = time() + GetQuestResetTime()
	local nextResetTimeWeekDay = tonumber( date("%w", nextResetTime))

	local timeNextWeeklyReset = nextResetTime + mod( 7 + weekDayReset - nextResetTimeWeekDay, 7) * 86400
	local timeLastWeeklyReset = timeNextWeeklyReset - 7 * 86400
	return timeLastWeeklyReset, timeNextWeeklyReset
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
		return format("%dd", floor(s/day + 0.5))	--, s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5))	--, s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5))	--, s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5) --, (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s) --, (s * 100 - floor(s * 100))/100
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

function CreateNewBorder( f)
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
	--f.border.glow:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\boder6px.blp")
	--f.border.glow:SetVertexColor( 0.05, 0.05, 0.05, 0.9)
	--f.border.glow:SetHeight( f:GetHeight() * 1.3)
	--f.border.glow:SetWidth( f:GetWidth() * 1.3)
end

function CreateStyle(f, size, level, alpha, alphaborder) 
    if f.shadow then return end
    local size = size or 3
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

function CreateStyleSmall(f, size, level, alpha, alphaborder) 
    if f.shadow then return end

    local size = size or 3
	local style = {
	--bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
	--edgeFile = "Interface\\TUTORIALFRAME\\UI-TutorialFrame-CalloutGlow.blp",
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	edgeSize = 1,
	insets = { left = size, right = size, top = size, bottom = size}};

    local shadow = CreateFrame("Frame", nil, f)
    shadow:SetFrameLevel(level or 0)
    shadow:SetFrameStrata(f:GetFrameStrata())
    shadow:SetPoint("TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop(style)
    shadow:SetBackdropColor(.08,.08,.08, alpha or 1)
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







--------------------------------------------------------------------------------------------------------------

local borderColor = { 0.5, 0.5, 0.5 }
local borderSize = 16
local sections = { "TOPLEFT", "TOPRIGHT", "TOP", "BOTTOMLEFT", "BOTTOMRIGHT", "BOTTOM", "LEFT", "RIGHT" }

local function SetBorderColor(self, r, g, b, a, glow)
	local t = self.BorderTextures
	if not t then return end

	if not r or not g or not b or a == 0 then
		r, g, b = unpack( borderColor)
	end

	for pos, tex in pairs(t) do
		tex:SetVertexColor(r, g, b)
	end

	--if self.Glow then
	--	if glow then
	--		self.Glow:SetVertexColor(r, g, b, a)
	--		self.Glow:Show()
	--	else
	--		self.Glow:SetVertexColor(1, 1, 1, 1)
	--		self.Glow:Hide()
	--	end
	--end
end

local function GetBorderColor(self)
	return self.BorderTextures and self.BorderTextures.TOPLEFT:GetVertexColor()
end

local function SetBorderParent(self, parent)
	local t = self.BorderTextures
	if not t then return end
	if not parent then
		parent = type(self.overlay) == "Frame" and self.overlay or self
	end
	for pos, tex in pairs(t) do
		tex:SetParent(parent)
	end
	self:SetBorderSize(self:GetBorderSize())
end

local function SetBorderSize(self, size, dL, dR, dT, dB)
	local t = self.BorderTextures
	if not t then return end

	size = size or borderSize
	dL, dR, dT, dB = dL or t.LEFT.offset or 0, dR or t.RIGHT.offset or 0, dT or t.TOP.offset or 0, dB or t.BOTTOM.offset or 0

	for pos, tex in pairs(t) do
		tex:SetSize(size, size)
	end

	local d = floor(size * 7 / 16 + 0.5)
	local parent = t.TOPLEFT:GetParent()

	t.TOPLEFT:SetPoint("TOPLEFT", parent, -d - dL, d + dT)
	t.TOPRIGHT:SetPoint("TOPRIGHT", parent, d + dR, d + dT)
	t.BOTTOMLEFT:SetPoint("BOTTOMLEFT", parent, -d - dL, -d - dB)
	t.BOTTOMRIGHT:SetPoint("BOTTOMRIGHT", parent, d + dR, -d - dB)

	t.LEFT.offset, t.RIGHT.offset, t.TOP.offset, t.BOTTOM.offset = dL, dR, dT, dB
end


local function GetBorderSize(self)
	local t = self.BorderTextures
	if not t then return end
	return t.TOPLEFT:GetWidth(), t.LEFT.offset, t.RIGHT.offset, t.TOP.offset, t.BOTTOM.offset
end

function CreateBorder(self, size, offset, parent, layer)
	if type(self) ~= "table" or not self.CreateTexture or self.BorderTextures then return end

	local t = {}

	for i = 1, #sections do
		local x = self:CreateTexture(nil, layer or "ARTWORK")
		x:SetTexture([[Interface\AddOns\yoFrame\Media\SimpleSquare]])
		t[sections[i]] = x
	end

	t.TOPLEFT:SetTexCoord(0, 1/3, 0, 1/3)
	t.TOP:SetTexCoord(1/3, 2/3, 0, 1/3)
	t.TOPRIGHT:SetTexCoord(2/3, 1, 0, 1/3)
	t.RIGHT:SetTexCoord(2/3, 1, 1/3, 2/3)
	t.BOTTOMRIGHT:SetTexCoord(2/3, 1, 2/3, 1)
	t.BOTTOM:SetTexCoord(1/3, 2/3, 2/3, 1)
	t.BOTTOMLEFT:SetTexCoord(0, 1/3, 2/3, 1)
	t.LEFT:SetTexCoord(0, 1/3, 1/3, 2/3)

	t.TOP:SetPoint("TOPLEFT", t.TOPLEFT, "TOPRIGHT")
	t.TOP:SetPoint("TOPRIGHT", t.TOPRIGHT, "TOPLEFT")

	t.RIGHT:SetPoint("TOPRIGHT", t.TOPRIGHT, "BOTTOMRIGHT")
	t.RIGHT:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "TOPRIGHT")

	t.BOTTOM:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "BOTTOMRIGHT")
	t.BOTTOM:SetPoint("BOTTOMRIGHT", t.BOTTOMRIGHT, "BOTTOMLEFT")

	t.LEFT:SetPoint("TOPLEFT", t.TOPLEFT, "BOTTOMLEFT")
	t.LEFT:SetPoint("BOTTOMLEFT", t.BOTTOMLEFT, "TOPLEFT")

	self.BorderTextures = t

	self.SetBorderColor  = SetBorderColor
	self.SetBorderLayer  = SetBorderLayer
	self.SetBorderParent = SetBorderParent
	self.SetBorderSize   = SetBorderSize

	self.GetBorderColor  = GetBorderColor
	self.GetBorderLayer  = GetBorderLayer
	self.GetBorderParent = GetBorderParent
	self.GetBorderSize   = GetBorderSize

	if self.GetBackdrop then
		local backdrop = self:GetBackdrop()
		if type(backdrop) == "table" then
			if backdrop.edgeFile then
				backdrop.edgeFile = nil
			end
			if backdrop.insets then
				backdrop.insets.top = 0
				backdrop.insets.right = 0
				backdrop.insets.bottom = 0
				backdrop.insets.left = 0
			end
			self:SetBackdrop(backdrop)
		end
	end

	if self.SetBackdropBorderColor then
		self.SetBackdropBorderColor = SetBorderColor
	end

	--tinsert(ns.borderedObjects, self)

	self:SetBorderColor()
	self:SetBorderParent(parent)
	self:SetBorderSize(size, offset)

	return true
end

local borderFrame1 = CreateFrame("Frame", nil, UIParent)
borderFrame1:SetPoint("CENTER")
borderFrame1:SetSize(250, 50)
borderFrame1:Hide()
CreateStyle( borderFrame1, 4)

--borderFrame1.texture = borderFrame1:CreateTexture(nil, "OVERLAY")
--borderFrame1.texture:SetAllPoints()
--borderFrame1.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\bar_dground")

local borderFrame2 = CreateFrame("Frame", nil, UIParent)
borderFrame2:SetPoint("CENTER", borderFrame1, "CENTER", 0, 70)
borderFrame2:SetSize(250, 50)
borderFrame2:Hide()
borderFrame2.texture = borderFrame2:CreateTexture(nil, "OVERLAY")
borderFrame2.texture:SetAllPoints()
borderFrame2.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidbg")

local borderFrame3 = CreateFrame("Frame", nil, UIParent)
borderFrame3:SetPoint("CENTER", borderFrame2, "CENTER", 0, 70)
borderFrame3:SetSize(250, 50)
borderFrame3:Hide()
borderFrame3.texture = borderFrame3:CreateTexture(nil, "OVERLAY")
borderFrame3.texture:SetAllPoints()
borderFrame3.texture:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidbg")

--CreateBorder(borderFrame1, 16) 
CreateBorder(borderFrame2, 12) 
CreateBorder(borderFrame3, 8) 


--borderFrame1.texture:SetVertexColor( 0.2, 0.2, 0.2, 0.9)
borderFrame2.texture:SetVertexColor( 1, 0.75, 0, 0.9)
borderFrame3.texture:SetVertexColor( 0, 1, 1, 0.9)

--SetBorderColor(borderFrame1, 1, 0.75, 0, 1)
SetBorderColor(borderFrame2, 1, 0, 0, 1)

local toggle = true
SlashCmdList["TB"] = function() 	
	borderFrame1:SetShown( toggle)
	borderFrame2:SetShown( toggle)
	borderFrame3:SetShown( toggle)
	toggle = not toggle
end

SLASH_TB1 = "/tb"
SLASH_TB2 = "/еи"