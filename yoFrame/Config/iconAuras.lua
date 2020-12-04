local addon, ns = ...

local L, yo, n = unpack( ns)

local GameTooltip, pcall, unpack, max, GetTime, DebuffTypeColor, CreateFrame, ceil, UIParent, formatTimeSec, formatTime, CreateStyleSmall, min, floor, SetUpAnimGroup
	= GameTooltip, pcall, unpack, max, GetTime, DebuffTypeColor, CreateFrame, ceil, UIParent, formatTimeSec, formatTime, CreateStyleSmall, math.min, floor, SetUpAnimGroup
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

--n.AurasFrame = CreateFrame("Frame")

--local auras = n.AurasFrame
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
    [1] =  { [1] = "LEFT",   	 [2] = 1,    [3] = 0},
    [2] =  { [1] = "BOTTOMLEFT", [2] = 1,    [3] = 1},
    [3] =  { [1] = "BOTTOM",     [2] = 0,    [3] = 1},
    [4] =  { [1] = "BOTTOMRIGHT",[2] = -1,   [3] = 1},
    [5] =  { [1] = "RIGHT",  	 [2] = -1,   [3] = 0},
    [6] =  { [1] = "TOPLEFT",    [2] = 1,    [3] = -1},
}

local function BuffOnLeave( self) GameTooltip:Hide() end
local function BuffOnEnter( self)
	if self.showToolTip ~= "none" then
		if ( not pcall(self.GetCenter, self)) then
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

function n.createAuraIcon( parent, index)
	if parent[index] then return parent[index] end

	local size = parent:GetHeight()
	local sh   = ceil( size / 6)

	local button = CreateFrame("Frame", nil, parent)
	button:SetWidth( size)
	button:SetHeight( size)

	parent.timerPosition= parent.timerPosition or "BOTTOM"
	button.unit 		= parent.unit
	button.countGlow 	= parent.countGlow
	button.countFilter 	= parent.countFilter
	button.countAnim	= parent.countAnim
	button.countColor	= parent.countColor
	button.showBorder	= parent.showBorder 	-- по-дефолту = фэлс, что бы рисовать смолстайл
	button.minTimer 	= button.minTimer or 100
	button.tFormat 		= parent.timeSecOnly and formatTimeSec or formatTime
	button.redTimer		= parent.redTimer or 2
	button.timerDefCol	= parent.timerDefCol or { 1, 1, 0}
	button.timerRedCol	= parent.timerRedCol or { 1, 0, 0}


	button.icon = button:CreateTexture(nil, "BORDER")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	--button.icon:SetGradient("VERTICAL", 1, 1, 1, 1, 0, 0);
	button.icon:SetTexCoord( unpack( yo.tCoord))

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont( yo.fontpx, max( 10, size / 1.9), "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)
	button.count:SetTextColor( 0, 1, 0)

	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetFont( yo.fontpx, max( 10, size / 1.9), "OUTLINE")
	button.timer:SetShadowColor(0, 0, 0, 0.5)
	button.timer:SetShadowOffset( 1, -1)

	if parent.timerPosition == "BOTTOM" then
		button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 6, 6)
		button.timer:SetPoint("CENTER", button, "BOTTOM", 2, 0)
	else
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -2)
		button.timer:SetPoint("CENTER", button, "CENTER", 2, 0)
	end

    if parent.direction == "ICONS" then
       button:SetPoint( posz[index][1], parent, posz[index][1], posz[index][2], posz[index][3])

 	else
		local sizeSh 	= size + sh
		local anchor 	= parent.anchor or 'BOTTOMLEFT'
		local growthx 	= ( parent.direction  == 'LEFT' and -1) or 1
		local growthy 	= ( parent.directionY == 'DOWN' and -1) or 1
		local cols 		= parent.inRow or 20  --math.floor(parent:GetWidth() / size + 0.5)

		local col 		= (index - 1) % cols
		local row 		= floor((index - 1) / cols)

		button:ClearAllPoints()
		button:SetPoint( anchor, parent, anchor, col * sizeSh * growthx, row * sizeSh * growthy)
 	end

	if not button.showBorder then
		CreateStyleSmall( button, max( 1, sh - 5))

	elseif button.showBorder == "border" then
		n.CreateBorder( button, size / 3)
		n.SetBorderColor( button, 0.19, 0.19, 0.19, 0.9)
	end

	if button.countAnim then
		SetUpAnimGroup( button.icon, "FlashLoop", 1, 0.2)
		button.icon.anim.fadein:SetDuration( 1 * .5)
		button.icon.anim.fadeout:SetDuration( 1)
	end

	if button.countColor then
		button.countColor = button:CreateTexture(nil, "OVERLAY")
		button.countColor:SetAllPoints( button)
		button.countColor:SetTexture( yo.texture)  --texhl
		button.countColor:SetBlendMode("ADD")
		button.countColor:SetColorTexture( 1, 0, 0, 1) -- SetColorTexture SetVertexColor
		button.countColor:SetAlpha( 0)

		SetUpAnimGroup( button.countColor, "FlashLoop", 1, 0)
		button.countColor.anim.fadein:SetDuration( 1 * .4)
		button.countColor.anim.fadeout:SetDuration( 1.3)
	end

	if not parent.hideTooltip then
		button:EnableMouse(true)
		button:SetScript("OnEnter", BuffOnEnter)
		button:SetScript("OnLeave", BuffOnLeave)
	end

	parent.iMAx 	= index
	parent[index] 	= button

	return parent[index]
end



function n.updateAuraIcon(button, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)

	button.expirationTime 	= expirationTime
	button.duration 		= duration
	button.countCount 		= count
	button.spellID 			= spellID
	button.name 			= name
	button.filter 			= filter
	button.id 				= index
	button.tick 			= 1

	button.timer:SetTextColor( button.timerDefCol[1], button.timerDefCol[2], button.timerDefCol[3])

	if button.color then
		button.icon:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\plain_white.tga")--texture)
		button.icon:SetVertexColor( unpack( button.color))
	else
		button.icon:SetTexture(icon)
	end

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

		if est <= button.redTimer then
			button.timer:SetTextColor( button.timerRedCol[1], button.timerRedCol[2], button.timerRedCol[3])

		elseif est <= 0 then
			button:Hide()
			self:SetScript("OnUpdate", nil)
			return
		--else
		--	button.timer:SetTextColor( 1, 1, 0)
		end

		if ( duration and duration > 0) and est > 0.1 then
			if est < button.minTimer then
				button.timer:SetText( button.tFormat( est, true)) --formatTime( est))
			else
				button.timer:SetText( "")
			end

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
