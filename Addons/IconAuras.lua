local addon, ns = ...

local L, yo, N = unpack( ns)

-----------------------------------------------------------------------------------------------
--	AURAS
-----------------------------------------------------------------------------------------------

local posz = {
    [1] =  { [1] = "TOPLEFT",   [2] = 3,    [3] = -3},
    [2] =  { [1] = "TOP",       [2] = 0,    [3] = -3},
    [3] =  { [1] = "TOPRIGHT",  [2] = -3,   [3] = -3},
    [4] =  { [1] ="BOTTOMRIGHT",[2] = -3,   [3] = 3},
    [5] =  { [1] = "BOTTOM",    [2] = 0,    [3] = 3},
    [6] =  { [1] = "BOTTOMLEFT",[2] = 3,    [3] = 3},
}

local function BuffOnEnter( f)
	if true or showToolTip == "cursor" then
		GameTooltip:SetOwner( f, "ANCHOR_BOTTOMRIGHT", 8, -16)
	else
		GameTooltip:SetOwner( f, "ANCHOR_NONE", 0, 0)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	end
	GameTooltip:SetUnitAura( f.unit or f:GetParent().unit, f.id, f.filter)
	--GameTooltip:AddDoubleLine("Caster", f.caster, 1, 1, 0, 1, 1, 1)
	GameTooltip:Show()
end

local function BuffOnLeave( f)
	GameTooltip:Hide()
end

function CreateAuraIcon( parent, index)
	if parent[index] then return parent[index] end

	local size = parent:GetHeight()
	local sh = ceil( size / 6)
	if not parent.timerPosition then parent.timerPosition = "BOTTOM" end

	local button = CreateFrame("Frame", nil, parent)
	button:SetWidth( size)
	button:SetHeight( size)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.icon:SetTexCoord( unpack( yo.tCoord))

	--button.cd = CreateFrame("Cooldown", nil, button)
	--button.cd:SetAllPoints(button)
	--button.cd:SetReverse(true)

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont( fontpx, max( 10, size / 1.5), "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)
	button.count:SetTextColor( 0, 1, 0)
	table.insert( N.strings, button.count)

	if parent.timerPosition == "BOTTOM" then
		button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 6, 6)
	else
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -2)
	end

	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetFont( fontpx, max( 10, size / 1.5), "THINOUTLINE")
	button.timer:SetShadowOffset(1, -1)
	table.insert( N.strings, button.timer)

	if parent.timerPosition == "BOTTOM" then
		button.timer:SetPoint("CENTER", button, "BOTTOM", 0, 0)
	else
		button.timer:SetPoint("CENTER", button, "CENTER", 0, 0)
	end

	if not parent.noShadow then CreateStyle( button, max( 1, sh - 3)) end
    if parent.timeSecOnly then
    	button.tFormat = formatTimeSec --formatTimeSec
    else
    	button.tFormat = formatTime
    end

    local p1, p2, shX, shY, pc = "LEFT", "RIGHT", sh, 0, parent

    if parent.direction == "LEFT" then
        p1, p2, shX, shY, pc = "RIGHT", "LEFT", -sh, 0, parent[index-1]
	elseif parent.direction == "RIGHT" then
    	p1, p2, shX, shY, pc = "LEFT", "RIGHT", sh, 0, parent[index-1]
    elseif parent.direction == "UP" then
        p1, p2, shX, shY, pc = "BOTTOM", "TOP", 0, sh, parent[index-1]
    elseif parent.direction == "ICONS" then
        p1, p2, shX, shY, pc = posz[index][1], posz[index][1], posz[index][2], posz[index][3], parent:GetParent()
    end

	if index == 1 then
        button:SetPoint( p1, parent, p1)
    else
    	--print( index, p1, p2, shX, shY, pc)
        button:SetPoint( p1, pc, p2, shX, shY)
    end

	if not parent.hideTooltip then
		button:EnableMouse(true)
		button:SetScript("OnEnter", BuffOnEnter)
		button:SetScript("OnLeave", BuffOnLeave)
	end

	parent[index] = button

	return parent[index]
end


function UpdateAuraIcon(button, filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
	button.icon:SetTexture(icon)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	button.filter = filter
	button.unit = unit
	button.id = index
	button.tick = 1

	if button.shadow then
		local color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
		button.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	if count and count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText( "")
	end

	button:SetScript("OnUpdate", function(self, el)
		button.tick = button.tick + el
		if button.tick <= 0.1 then return end
		button.tick = 0

		local est = expirationTime - GetTime()

		if est <= 2 then
			button.timer:SetTextColor( 1, 0, 0)
		elseif est <= 0 then
			button:Hide()
			self:SetScript("OnUpdate", nil)
			return
		else
			button.timer:SetTextColor( 1, 1, 0)
		end

		if ( duration and duration > 0) and est > 0.1 then
			--print( button.tFormat( 12))
			button.timer:SetText( button.tFormat( est, true)) --formatTime( est))
		else
			button.timer:SetText( "")
			button:Hide()
			self:SetScript("OnUpdate", nil)
		end
	end)

	button:Show()
end
