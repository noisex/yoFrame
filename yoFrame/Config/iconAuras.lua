local addon, ns = ...

local L, yo, N = unpack( ns)

-----------------------------------------------------------------------------------------------
--	AURAS
-----------------------------------------------------------------------------------------------

--String (optional) - list of filters, separated by spaces or pipes. "HELPFUL" by default. The following filters are available:
--	HELPFUL - buffs.
--	HARMFUL - debuffs.
--	PLAYER - auras that were applied by the player.
--	RAID - auras that can be applied (if HELPFUL) or dispelled (if HARMFUL) by the player.
--	CANCELABLE - buffs that can be removed (such as by right-clicking or using the /cancelaura command)
--	NOT_CANCELABLE - buffs that cannot be removed

-- ( self, unit, filter, customFilter, func)

--N.AurasFrame = CreateFrame("Frame")

--local auras = N.AurasFrame
--local spells = {
--	[48025] 	= true,
--	[186403]	= true,
--	--["Водные ноги Рыболовов"] = true,
--}
--local filters = { "HELPFUL", "HARMFUL" }

--auras.modules = {}
--tinsert( auras.modules, { self, "player", "HELPFUL", spells, anyFunc })


--function auras:onEvent( event, spellUnit)
--	for i = 1, 2 do
--		local index = 1
--		while true do
--			local spellName, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura( spellUnit, index, filters[i]) --[, "filter"])
--			if not spellName then break end
--			index = index + 1
--			for ind, data in pairs( self.modules) do

--				local unit, spellFilter  = data[2], data[4]

--				if unit == spellUnit and ( spellFilter[spellId] or spellFilter[spellName]) then
--					print( ind, spellName, unit, spellId, filters[i])
--				end

--			end
--			--print( unit, name)
--		end
--	end
--end

--auras:RegisterEvent("UNIT_AURA")
--auras:SetScript("OnEvent", auras.onEvent)

local aGlow = LibStub("LibCustomGlow-1.0", true)

local posz = {
    [1] =  { [1] = "TOPLEFT",   [2] = 3,    [3] = -3},
    [2] =  { [1] = "TOP",       [2] = 0,    [3] = -3},
    [3] =  { [1] = "TOPRIGHT",  [2] = -3,   [3] = -3},
    [4] =  { [1] ="BOTTOMRIGHT",[2] = -3,   [3] = 3},
    [5] =  { [1] = "BOTTOM",    [2] = 0,    [3] = 3},
    [6] =  { [1] = "BOTTOMLEFT",[2] = 3,    [3] = 3},
}

local function BuffOnEnter( self)

if self.showToolTip ~= "none" then
	if(not pcall(self.GetCenter, self)) then
			GameTooltip:SetOwner( self, "ANCHOR_CURSOR", 20, 5)
		else
			GameTooltip:SetOwner( self, "ANCHOR_BOTTOMRIGHT", 8, -16)
		end
	else
		GameTooltip:SetOwner( self, "ANCHOR_NONE", 0, 0)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	end
	GameTooltip:SetUnitAura( self.unit or self:GetParent().unit, self.id, self.filter)
	GameTooltip:Show()
end

local function BuffOnLeave( self)
	GameTooltip:Hide()
end
--math.mod(number, 2) == 0
local function checkForFilter( button)

	if button.countFilter[button.name] then
		local checkForShow = button.countCount >= button.countFilter[button.name]

		if button.countGlow then
			if checkForShow then
				if not button.glowing then
					--aGlow.PixelGlow_Start( button, {0.95, 0.95, 0.32, 1}, 7, 0.5, 8, 4, 2, 2, false, 1 )
					aGlow.PixelGlow_Start( button, { 1, 1, 0, 1}, 7, 0.5, 6, 3, 4, 4, false, 1 )
					button.glowing = true
				end
			else
				aGlow.PixelGlow_Stop( button, 1)
				button.glowing = false
			end
		end

		if button.countAnim then
			if checkForShow then
				if not button.icon.anim.playing then
					button.icon.anim:Play()
					button.icon.anim.playing = true
				end
			else
				button.icon.anim:Stop()
				button.icon.anim.playing = nil;
			end
		end

		if button.countColor then
			if checkForShow then
				if not button.countColor.anim.playing then
					button.countColor.anim:Play()
					button.countColor.anim.playing = true
				end
			else
				button.countColor.anim:Stop()
				button.countColor.anim.playing = nil;
			end
		end
	else
		if button.countAnim then
			button.icon.anim:Stop()
			button.icon.anim.playing = nil;
		end
		if button.countColor then
			button.countColor.anim:Stop()
			button.countColor.anim.playing = nil;
		end
		if button.countGlow then
			aGlow.PixelGlow_Stop( button, 1)
			button.glowing = false
		end
	end
end

function N.createAuraIcon( parent, index)
	if parent[index] then return parent[index] end

	local size = parent:GetHeight()
	local sh = ceil( size / 6)
	if not parent.timerPosition then parent.timerPosition = "BOTTOM" end

	local button = CreateFrame("Frame", nil, parent)
	button:SetWidth( size)
	button:SetHeight( size)

	button.unit 		= parent.unit
	button.countGlow 	= parent.countGlow
	button.countFilter 	= parent.countFilter
	button.countAnim	= parent.countAnim
	button.countColor	= parent.countColor
	button.showBorder	= parent.showBorder 	-- по-дефолту = фэлс, что бы рисовать смолстайл

	button.icon = button:CreateTexture(nil, "BORDER")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	--button.icon:SetGradient("VERTICAL", 1, 1, 1, 1, 0, 0);

	button.icon:SetTexCoord( unpack( yo.tCoord))

	if not button.showBorder then
		CreateStyleSmall( button, max( 1, sh - 5))

	elseif button.showBorder == "border" then
		N.CreateBorder( button, size / 3)
		N.SetBorderColor( button, 0.19, 0.19, 0.19, 0.9)
	end

	if button.countAnim then
		SetUpAnimGroup( button.icon, "FlashLoop", 1, 0.2)
		button.icon.anim.fadein:SetDuration( 1 * .5)
		button.icon.anim.fadeout:SetDuration( 1)
	end

	if button.countColor then
		button.countColor = button:CreateTexture(nil, "OVERLAY")
		button.countColor:SetAllPoints( button)
		button.countColor:SetTexture( texture)  --texhl
		button.countColor:SetBlendMode("ADD")
		button.countColor:SetColorTexture( 1, 0, 0, 1) -- SetColorTexture SetVertexColor
		button.countColor:SetAlpha( 0)

		SetUpAnimGroup( button.countColor, "FlashLoop", 1, 0)
		button.countColor.anim.fadein:SetDuration( 1 * .4)
		button.countColor.anim.fadeout:SetDuration( 1.3)
	end

	--button.cd = CreateFrame("Cooldown", nil, button)
	--button.cd:SetAllPoints(button)
	--button.cd:SetReverse(true)

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont( yo.fontpx, max( 10, size / 1.5), "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)
	button.count:SetTextColor( 0, 1, 0)
	table.insert( N.strings, button.count)

	if parent.timerPosition == "BOTTOM" then
		button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 6, 6)
	else
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -2)
	end

	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetFont( yo.fontpx, max( 10, size / 1.7), "THINOUTLINE")
	button.timer:SetShadowOffset(1, -1)
	table.insert( N.strings, button.timer)

	if parent.timerPosition == "BOTTOM" then
		button.timer:SetPoint("CENTER", button, "BOTTOM", 0, 0)
	else
		button.timer:SetPoint("CENTER", button, "CENTER", 0, 0)
	end

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


function N.updateAuraIcon(button, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
	button.icon:SetTexture(icon)
	button.expirationTime 	= expirationTime
	button.duration 		= duration
	button.countCount 		= count
	button.spellID 			= spellID
	button.name 			= name
	button.filter 			= filter
	button.id 				= index
	button.tick 			= 1

	button.timer:SetTextColor( 1, 1, 0)

	if button.shadow then
		local color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
		button.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	if count and count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText( "")
	end

	if button.countFilter then checkForFilter( button) end

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
		--else
		--	button.timer:SetTextColor( 1, 1, 0)
		end

		if ( duration and duration > 0) and est > 0.1 then
			button.timer:SetText( button.tFormat( est, true)) --formatTime( est))
		elseif duration and duration == 0 then
			button.timer:SetText( "")
			self:SetScript("OnUpdate", nil)
		else
			button.timer:SetText( "")
			button:Hide()
			self:SetScript("OnUpdate", nil)
		end
	end)

	button:Show()
end
