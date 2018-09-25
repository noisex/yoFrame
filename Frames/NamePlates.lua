local nameplateheight, nameplatewidth, auras_size, aurasB_size, showPercTreat, 	dissIcons,	buffIcons,	classDispell, badTypes, showToolTip

DebuffTypeColor.none = { r = 0.09, g = 0.09, b = 0.09}

local badClassTypes = {
	["WARRIOR"]		=	{},
	["PALADIN"]		=	{},
	["HUNTER"]		=	{[""] = true, ["Magic"] = true,},
	["ROGUE"]		=	{},
	["PRIEST"]		=	{["Magic"] = true,},
	["DEATHKNIGHT"]	=	{},
	["SHAMAN"]		=	{["Magic"] = true,},
	["MAGE"]		=	{["Magic"] = true,},
	["WARLOCK"]		=	{},
	["MONK"]		=	{},
	--["DRUID"]		=	{[""] = true, ["Magic"] = true,},
	["DRUID"]		=	{[""] = true,},
	["DEMONHUNTER"]	=	{},
}

local badMobes = {
	[113864] = true,	--	Дамми у ханта
	--[102052] = true, 	--	Дамми у лока

	[120651] = true,  	-- 	Взрывчатка
	[136461] = true,	--  Порождение Г'ууна

}

local eTeam = {
		--Razak's Roughriders
	[133556] = 7,	-- Razak Ironsides
	[133557] = 7,	-- Razak Ironsides
	[133585] = 8,	-- Dizzy Dina
	[133627] = 5,	-- Tally Zapnabber
		--Briona's Buccaneers
	[135246] = 8,	-- "Stabby" Lottie
	[135247] = 5,	-- Varigg
	[135248] = 7,	-- Briona the Bloodthirsty
		--Light's Vengeance
	[134286] = 5,	-- Archmage Tamuura
	[134280] = 7,	-- Vindicator Baatul
	[134283] = 8,	-- Anchorite Lanna
		--The Wolfpack
	[131726] = 5,	-- Gunnolf the Ferocious
	[131727] = 7,	-- Fenrae the Cunning
	[131728] = 8,	-- Raul the Tenacious
		--Auric`s Angels
	[130620] = 8,	-- Frostfencer Seraphi
	[130621] = 7,	-- Squallshaper Bryson
	[130622] = 5,	-- Squallshaper Auran
		--Riftrunners
	[134214] = 7,	-- Riftblade Kelain
	[134215] = 8,	-- Duskrunner Lorinas
	[134216] = 5,	-- Shadeweaver Zarra

	[135770] = 8,
}

local auraFilter = { "HARMFUL", "HELPFUL"}

-----------------------------------------------------------------------------------------------
--	AURAS
-----------------------------------------------------------------------------------------------

local function BuffOnEnter( f) 
	if showToolTip == "cursor" then
		GameTooltip:SetOwner( f, "ANCHOR_BOTTOMRIGHT", 8, -16)
	else
		GameTooltip:SetOwner( f, "ANCHOR_NONE", 0, 0)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	end	
	GameTooltip:SetUnitAura( f:GetParent():GetParent().displayedUnit, f.id, f.filter)
	GameTooltip:Show()
end

local function BuffOnLeave( f)
	GameTooltip:Hide()	
end

local function CreateAuraIcon(parent, index)
	local size = parent:GetHeight()

	local button = CreateFrame("Frame", nil, parent)
	button:SetWidth( size)
	button:SetHeight( size)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.cd = CreateFrame("Cooldown", nil, button)
	button.cd:SetAllPoints(button)
	button.cd:SetReverse(true)
	
	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont( font, fontsize, "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -2)
	button.count:SetTextColor( 0, 1, 0)
	
	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetFont( font, fontsize, "OUTLINE")
	--button.timer:SetShadowOffset(1, -1)
	button.timer:SetPoint("CENTER", button, "CENTER", 0, 0)
	
	CreateStyle( button, 3)

	local p1, p2, shX, shY = "LEFT", "RIGHT", 3, 0

	if parent.direction == "LEFT" then
		p1, p2, shX, shY = "RIGHT", "LEFT", -3, 0
	elseif parent.direction == "UP" then
		p1, p2, shX, shY = "BOTTOM", "TOP", 0, 3
	end

	if index == 1 then
		button:SetPoint( p1, parent, p1)
	else
		button:SetPoint( p1, parent[index-1], p2, shX, shY)
	end
	
	if showToolTip ~= "none" then
		button:EnableMouse(true)
		button:SetScript("OnEnter", BuffOnEnter)
		button:SetScript("OnLeave", BuffOnLeave)
	end
	
	return button
end


local function UpdateAuraIcon(button, filter, icon, count, debuffType, duration, expirationTime, spellID, index)
	button.icon:SetTexture(icon)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	button.filter = filter
	button.id = index
	button.tick = 1

	--if --filter == "HELPFUL" and debuffType ~= nil then

	local color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
	button.shadow:SetBackdropBorderColor(color.r, color.g, color.b)	
		--button:SetSize(auras_size * 1.3, auras_size * 1.3)
	--else
	--	button.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09)	
		--button:SetSize(auras_size, auras_size)
	--end	
	
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
		
		if est <= 0 then
			self:SetScript("OnUpdate", nil)
			return
		end
		
		if est <= 5 then
			button.timer:SetTextColor( 1, 0, 0)
		else
			button.timer:SetTextColor( 1, 1, 0)
		end
		button.timer:SetText( formatTime( est))
	end)

	button:Show()
end

local function ShowGuune( unitFrame, showGuune)
	--https://ru.wowhead.com/npc=136461  Порождение Г'ууна

	if showGuune then
		unitFrame.guune.icon:SetTexture( 2032223)
		unitFrame.guune:Show()
	else
		unitFrame.guune:Hide()
	end
end

local function UpdateBuffs(unitFrame)
	if not unitFrame.displayedUnit then return end

	local unit, showGuune = unitFrame.displayedUnit, nil
	local isPlayer = UnitIsPlayer( unit)
	local idebuff, ibuff, iDisp = 1, 1, 1

	for	j = 1, 2 do
		filter = auraFilter[j]
		local index = 1
		while true do
			local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, _, spellID, _, _, _, namepmateshowall = UnitAura(unit, index, filter)
			if not name then break end
			--if idebuff > ( nameplatewidth / 2) / auras_size then break end

			if ( caster == "player" and DebuffWhiteList[name]) or namepmateshowall then --or isStealable then
				
				debuffType = blueDebuff and debuffType or nil

				if not unitFrame.debuffIcons[idebuff] then	unitFrame.debuffIcons[idebuff] = CreateAuraIcon(unitFrame.debuffIcons, idebuff)	end
										
				UpdateAuraIcon(unitFrame.debuffIcons[idebuff], filter, icon, count, debuffType, duration, expirationTime, spellID, index)
				idebuff = idebuff + 1
			
			elseif spellID == 277242 then showGuune = true

			elseif ( filter == "HELPFUL" and not isPlayer and not blackSpells[spellID]) then

				if dissIcons ~= "none"	or iDisp > 2 then
					if ( dissIcons == "dispell" and badClassTypes[myClass][debuffType])  
						or ( dissIcons == "all" and debuffType) then

						if not unitFrame.disIcons[iDisp] then unitFrame.disIcons[iDisp] = CreateAuraIcon(unitFrame.disIcons, iDisp)end			
						
						UpdateAuraIcon(unitFrame.disIcons[iDisp], filter, icon, count, debuffType, duration, expirationTime, spellID, index)
						iDisp = iDisp + 1		
					end
				end
				
				if buffIcons ~= "none" or ibuff > 4 then
					if buffIcons == "all" 
						or ( buffIcons == "dispell" and badTypes[debuffType])  
						or ( buffIcons == "buff" and not badTypes[debuffType]) then

						if not unitFrame.buffIcons[ibuff] then unitFrame.buffIcons[ibuff] = CreateAuraIcon(unitFrame.buffIcons, ibuff) end
				
						UpdateAuraIcon(unitFrame.buffIcons[ibuff], filter, icon, count, debuffType, duration, expirationTime, spellID, index)
						ibuff = ibuff + 1
					end
				end
			end

			index = index + 1
		end
	end

	for index = idebuff, #unitFrame.debuffIcons do unitFrame.debuffIcons[index]:Hide() end
	for index = ibuff,   #unitFrame.buffIcons   do unitFrame.buffIcons[index]:Hide()   end
	for index = iDisp,   #unitFrame.disIcons    do unitFrame.disIcons[index]:Hide()   end

	ShowGuune( unitFrame, showGuune)
end

----------------------------------------------------------------------------------------------- 
--	CASTBAR
-----------------------------------------------------------------------------------------------

local function NamePlates_UpdateCastBar( f, ...)
	if not f:IsShown() then return end
	local current, width, min, max = f:GetValue(), f:GetWidth(), f:GetMinMaxValues()
	
	f.Time:SetFormattedText("%.1f / %.2f", current-min, max-min)
end

local function FadingOut( f)
	local now = GetTime()
	local alpha = f.fadeDuration - (now - f.endTime)
	if alpha > 0 then
		f:SetAlpha( math.min( alpha, 1.0))
	else
		f:SetScript('OnUpdate', nil)
		f:Hide()
	end
end

local function stopCast( f)
	f:SetValue( 0)   --f.reversed and 0 or (f.endTime - f.startTime))
	f.endTime = GetTime()	
	--f:SetScript('OnUpdate', FadingOut)
	-- no fading - hide
	f:Hide()
end

local function UpdateCastBar( f, id)
	local unit = f:GetParent().unit
	if not unit then return  end

	local name, icon, startTime, endTime, notInterruptible, spellID
	
	if f.reversed then
		name, _, icon, startTime, endTime, _, notInterruptible = UnitChannelInfo( unit)
	else
		name, _, icon, startTime, endTime, _, _, notInterruptible, spellID = UnitCastingInfo( unit)
	end
	
	if not name then
		stopCast( f)
		return
	end
	
	if notInterruptible then
		--f.BorderShield:Show()
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 1, 0, 0, 1)
		end
		f:SetStatusBarColor( 1, 0, 0, 1)
	else
		--f.BorderShield:Hide()
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
		if spellDelay() then
			f:SetStatusBarColor( 0, 1, 0, 1)
		else
			f:SetStatusBarColor( 0, 1, 1, 1)
		end
	end

	if f.ibg then
		if icon then
			f.Icon:SetTexture( icon)
			f.ibg:Show( )
		else
			f.ibg:Hide()
		end
	end
	
	f.spellDelay = yo.General.spellDelay
	f.endTime = endTime/1000
	f.startTime = startTime/1000
		
	f:SetMinMaxValues(0, f.endTime - f.startTime)

	if yo.NamePlates.showCastName then
		local text = ""
		if yo.NamePlates.showCastTarget then
			if UnitExists( unit .. "target") then
				if yo.NamePlates.anonceCast and not UnitInRaid("player") then
					if UnitIsUnit("player", unit .. "target") 
						--and ( myRole == "HEALER" or myRole == "DAMAGER" ) 
						then
							print( myColorStr .. name .. " on me!")
					end					
				end
				local uname = UnitName( unit .. "target")
				if uname then
					local cname = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( unit .. "target"))].colorStr
					text = " / " .. cname .. uname
				end
			end
		end

		--local spellName = ( GetSpellInfo( id or spellID) or "БЭД КАСТ")
		--f.Text:SetText( spellName  .. text)
		f.Text:SetText( name  .. text)
	else
		f.Text:SetText( "")
	end

	f:SetScript('OnUpdate', CastTimerUpdate)
	f:SetAlpha( 1)
	f:Show()	
end

function CastTimerUpdate( f)
	if f.spellDelay ~= yo.General.spellDelay then
		UpdateCastBar( f)		
	end
	local now = GetTime()
	if f.reversed then
		f:SetValue(f.endTime - now)
	else
		f:SetValue(now - f.startTime)
	end
end

local function CastingBarFrame_OnEvent( f, event, unit, name, id)
	--print( event, unit, id) --, ...)
	if event == "UNIT_SPELLCAST_START" then
		f.reversed = false
		UpdateCastBar( f, id)
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		f.reversed = true
		UpdateCastBar( f, id)
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		stopCast( f)
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		stopCast( f)
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		f:SetStatusBarColor( 1, 0, 0, 1)
		stopCast( f)
		--f.fadeDuration = 1.5
	--elseif event == "UNIT_SPELLCAST_CHANNEL_INTERRUPTED" then
	--	f:SetStatusBarColor( 1, 0, 0, 1)
	--	f.fadeDuration = 1.5		
	end
end


-----------------------------------------------------------------------------------------------
--	CREATE PLATE
-----------------------------------------------------------------------------------------------

local function SetVirtualBorder(frame, r, g, b)
	--frame.bordertop:SetColorTexture(r, g, b)
	--frame.borderbottom:SetColorTexture(r, g, b)
	--frame.borderleft:SetColorTexture(r, g, b)
	--frame.borderright:SetColorTexture(r, g, b)
end

local function UpdateRaidTarget(unitFrame)
	local icon = unitFrame.RaidTargetFrame.RaidTargetIcon
	local index = GetRaidTargetIndex(unitFrame.displayedUnit)
	if index then
		SetRaidTargetIconTexture(icon, index)
		icon:Show()
	else
		icon:Hide()
	end
end

local function OnRaidTargetUpdate()
	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		UpdateRaidTarget(namePlate.UnitFrame)
	end
end

local function UpdateHealth(unitFrame)
	local unit = unitFrame.displayedUnit
	local minHealth, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local perc = minHealth / maxHealth
	local perc_text = string.format("%d%%", math.floor(perc * 100))

	unitFrame.healthBar:SetValue(perc)

	--if UnitIsUnit("player", unitFrame.displayedUnit) then
	--	unitFrame.healthBar.value:SetText("")
	--else
	
	unitFrame.healthBar.perc:SetText( perc_text)
	unitFrame.healthBar.value:SetText( ShortValue(minHealth) .. " -")
	--end

	--if UnitIsPlayer(unit) then
	--	if perc <= 0.5 and perc >= 0.2 then
	--		SetVirtualBorder(unitFrame.healthBar, 1, 1, 0)
	--	elseif perc < 0.2 then
	--		SetVirtualBorder(unitFrame.healthBar, 1, 0, 0)
	--	else
	--		SetVirtualBorder(unitFrame.healthBar, 0.05, 0.05, 0.05, 1)
	--	end
	--elseif not UnitIsPlayer(unit) then
	--	SetVirtualBorder(unitFrame.healthBar, 0.05, 0.05, 0.05, 1)
	--end
end

local hpColors = {
	["tapped"] 		= {	.6,	.6,		.6},

	["tankGood"]	= { 0, 	1,		0},
	["tankOffTank"]	= { 0, 	0.5,	1},
	["tankBad"]		= { 1, 	0.5,	0.04},
	["tankAnother"]	= { 1, 	0, 		0.5},
	["playerGood"]	= { 1, 	0.25,	0},
	["playerBad"] 	= { 1, 	0, 		0.5} ,
}

local function UpdateHealthColor(unitFrame, elapsed)
	if InCombatLockdown() then unitFrame:SetScript("OnUpdate", nil) end

	unitFrame.tick = ( unitFrame.tick or 1) + elapsed
	if unitFrame.tick <= 0.5 then return end
	unitFrame.tick = 0
	
	local unit = unitFrame.displayedUnit
	local cols = hpColors["tapped"]  											-- дефолт колор - таппеd

	local max, perc = UnitHealthMax( unit), 0
	if( max ~= 0) then
		perc = math.floor( UnitHealth( unit) / max * 100 + .5)
	end

	if UnitIsTapDenied( unit) then
		cols = hpColors["tapped"]
	
	elseif yo.NamePlates.executePhaze and perc <= yo.NamePlates.executeProc then
		local r, g, b = strsplit(",", yo.NamePlates.executeColor)
		cols = { r, g, b}

	elseif UnitPlayerControlled( unit) then 									-- юнит-игрок / цвет класса
		cols = _G["yo_Player"].colors.class[ select( 2, UnitClass( unit))]

	elseif UnitExists( unit .. "target") then
		
		if UnitGroupRolesAssigned( "player") == "TANK" then 
			
			if UnitIsUnit( "player", unit .. "target") then  					-- танк, бьет тебя
				cols = hpColors["tankGood"]
			
			elseif UnitGroupRolesAssigned( unit .. "target") == "TANK" then  	-- танк, тьет оффтанка
				cols = hpColors["tankOffTank"]
			
			elseif UnitInParty( unit .. "target") then							-- танк, в таргете член группы/рейда
				
				if UnitThreatSituation( "player", unit) and UnitThreatSituation( "player", unit) >= 3 then				-- танк, бьет тебя, но ты не в таргете
					cols = hpColors["tankGood"]
				else
					cols = hpColors["tankBad"]									-- танк, бьет кого-то из группы/рейда
				end
			else 																-- танк, бьет кого-то другого
				cols = hpColors["tankAnother"]
			end				
	
		elseif UnitIsUnit( "player", unit .. "target") then						-- соло, бьет тебя 
			cols = hpColors["playerGood"]
		
		else
			cols = hpColors["playerBad"]										-- соло, бьет не тебя
		end
		
	elseif UnitReaction( unit, 'player') then  --or UnitPlayerControlled( unit) then
		cols = _G["yo_Player"].colors.reaction[UnitReaction( unit, "player")]	-- цвет реакшн
	end    	
	--print(GetTime(), unit, cols[1], cols[2], cols[3])
	unitFrame.healthBar:SetStatusBarColor( cols[1], cols[2], cols[3])
	--unitFrame.healthBar.Background:SetColorTexture( cols[1], cols[2], cols[3], 0.2)
	--unitFrame.healthBar.Background:SetColorTexture( 0.1, 0.1, 0.1, 0.9)
	unitFrame.name:SetTextColor( cols[1], cols[2], cols[3])
end


local function UpdateName( unitFrame)
	local name = GetUnitName(unitFrame.displayedUnit, false)
	if name then
		local level = UnitLevel( unitFrame.displayedUnit)
		local classification = UnitClassification( unitFrame.displayedUnit)

		local r, g, b
		if level == -1 or not level then
			level = "??"
			r, g, b = 0.8, 0.05, 0
		else
			local color = GetQuestDifficultyColor(level)
			r, g, b = color.r, color.g, color.b
		end

		if level == UnitLevel("player") then
			level = ""
		end

		if classification == "elite" then
			level = level.." +"
		elseif classification == "rare" then
			level = level.." R"
		elseif classification == "rareelite"  then
			level = level.." R+"
		elseif classification == "worldboss"  then
			level = level.." WB"
		end

		if (tonumber(level) == UnitLevel("player") and not classification == "elite") or UnitIsUnit(unitFrame.displayedUnit, "player") then
			unitFrame.level:SetText("")
		else
			unitFrame.level:SetText(level)
		end
		
		local _, _, _, _, _, mobID = strsplit( "-", UnitGUID( unitFrame.displayedUnit))
		mobID = tonumber( mobID)
		
		unitFrame.name:SetText(name)
		unitFrame.level:SetTextColor(r, g, b)
		
		if UnitExists( "target") and showArrows then
			if UnitIsUnit( unitFrame.displayedUnit, "target") then
				--unitFrame:SetAlpha( 1)
				unitFrame.arrowright:Show()
				unitFrame.arrowleft:Show()
				--unitFrame.healthBar.value:Show()
			else
				--unitFrame:SetAlpha( 0.7)
				unitFrame.arrowright:Hide()
				unitFrame.arrowleft:Hide()
				--unitFrame.healthBar.value:Hide()
			end
		else
			if showArrows then
				--unitFrame:SetAlpha( 1)
				unitFrame.arrowright:Hide()
				unitFrame.arrowleft:Hide()
			end
			--unitFrame.healthBar.value:Hide()
		end
		
		if mobID and ( badMobes[mobID] or eTeam[mobID]) then
			unitFrame.healthBar.shadow:SetBackdropBorderColor( 0, 1, 1)
			--unitFrame.healthBar.HightLight:Show()
			unitFrame:SetAlpha( 1)
			--ActionButton_ShowOverlayGlow( unitFrame.healthBar)
		else
			unitFrame.healthBar.shadow:SetBackdropBorderColor( .09, .09, .09)
			--unitFrame.healthBar.HightLight:Hide()
			--ActionButton_HideOverlayGlow( unitFrame.healthBar)
		end
		
		if 	--UnitClass( unitFrame.displayedUnit)
			UnitIsPlayer( unitFrame.displayedUnit) or eTeam[mobID] 	then

			if unitFrame.Class then
				local _, class = UnitClass( unitFrame.displayedUnit)
				local texcoord = CLASS_ICON_TCOORDS[class]
				unitFrame.Class.Icon:SetTexCoord(texcoord[1] + 0.015, texcoord[2] - 0.02, texcoord[3] + 0.018, texcoord[4] - 0.02)
				unitFrame.Class:Show()
			end
			if eTeam[mobID] and not GetRaidTargetIndex( unitFrame.displayedUnit) then
				SetRaidTarget( unitFrame.displayedUnit, eTeam[mobID]);
			end
		else
			if unitFrame.Class then
				--unitFrame.Class.Icon:SetTexCoord(0, 0, 0, 0)
				unitFrame.Class:Hide()
			end
		end		
	end
end

local function UpdateTheatSit( self)
	if not yo.NamePlates.showPercTreat then return end

	if UnitInRaid("player") or UnitInParty("player") then
		local unit = self.displayedUnit
		local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation( "player", unit)
	
		if status then
			local red, green, blue = GetThreatStatusColor( status)
			self.threat:SetText( floor( scaledPercent) .. "%")
			self.threat:SetTextColor( red, green, blue)
		else
			self.threat:SetText( "")
		end
	end
end

local function UpdateAll(unitFrame)
	--UpdateInVehicle(unitFrame)
	if UnitExists(unitFrame.displayedUnit) then
		UpdateName(unitFrame)
		UpdateHealthColor(unitFrame, 1)
		UpdateHealth(unitFrame)
		UpdateCastBar( unitFrame.castBar)
		UpdateBuffs(unitFrame)
		UpdateRaidTarget(unitFrame)
		UpdateTheatSit( unitFrame)

		 
		if UnitIsUnit("player", unitFrame.displayedUnit) then
			unitFrame.castBar:UnregisterAllEvents()
		end
	end
end

-----------------------------------------------------------------------------------------------
-- FRAME
-----------------------------------------------------------------------------------------------
local function OnNamePlateCreated( f)
	--local texture = "Interface\\AddOns\\yoFrame\\Media\\bar_dground"
	local textureHL = "Interface\\AddOns\\yoFrame\\Media\\bar20"
	--local texture = "Interface\\AddOns\\yoFrame\\Media\\flatsmooth" --"Interface\\AddOns\\yoFrame\\Media\\bar16"

	f.UnitFrame = CreateFrame("Button", "$parentUnitFrame", f)
	f.UnitFrame:SetAllPoints( f)
	f.UnitFrame:SetFrameLevel( f:GetFrameLevel())
	f.UnitFrame:SetScale( UIParent:GetScale())
	
	f.UnitFrame.healthBar = CreateFrame("StatusBar", nil, f.UnitFrame)
	f.UnitFrame.healthBar:SetPoint("CENTER", f, "CENTER", 0, 0)
	f.UnitFrame.healthBar:SetSize( nameplatewidth, nameplateheight)
	--f.UnitFrame.healthBar:SetAllPoints(f.UnitFrame)

	f.UnitFrame.healthBar:SetStatusBarTexture( texture)
	f.UnitFrame.healthBar:SetMinMaxValues(0, 1)
	CreateStyle( f.UnitFrame.healthBar, 3)

	f.UnitFrame.healthBar.Background = f.UnitFrame.healthBar:CreateTexture(nil, "BACKGROUND")
	f.UnitFrame.healthBar.Background:SetAllPoints( f.UnitFrame.healthBar)
	f.UnitFrame.healthBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.UnitFrame.healthBar.Background:SetTexture( texture)

	--f.UnitFrame.healthBar.HightLight = f.UnitFrame.healthBar:CreateTexture(nil, "OVERLAY")
	--f.UnitFrame.healthBar.HightLight:SetAllPoints( f.UnitFrame.healthBar)
	--f.UnitFrame.healthBar.HightLight:SetVertexColor( 1, 0.5, 0, 0.2)
	--f.UnitFrame.healthBar.HightLight:SetBlendMode( "BLEND")
	--f.UnitFrame.healthBar.HightLight:SetTexture( textureHL)	
	--f.UnitFrame.healthBar.HightLight:Hide()
	
	f.UnitFrame.healthBar.perc = f.UnitFrame.healthBar:CreateFontString(nil, "OVERLAY")
	f.UnitFrame.healthBar.perc:SetFont( font, fontsize, "THINOUTLINE")
	f.UnitFrame.healthBar.perc:SetPoint("RIGHT", f.UnitFrame.healthBar, "RIGHT", -5, 0)
	f.UnitFrame.healthBar.perc:SetTextColor(1, 1, 1)

	f.UnitFrame.healthBar.value = f.UnitFrame.healthBar:CreateFontString(nil, "OVERLAY")
	f.UnitFrame.healthBar.value:SetFont( font, fontsize, "THINOUTLINE")
	f.UnitFrame.healthBar.value:SetPoint("RIGHT", f.UnitFrame.healthBar.perc, "LEFT", 0, 0)
	f.UnitFrame.healthBar.value:SetTextColor(1, 1, 1)

	f.UnitFrame.name = f.UnitFrame:CreateFontString(nil, "OVERLAY")
	f.UnitFrame.name:SetFont( font, fontsize, "THINOUTLINE")
	f.UnitFrame.name:SetPoint("BOTTOM", f.UnitFrame.healthBar, "TOP", 0, 2)
	f.UnitFrame.name:SetTextColor(1, 1, 1)
	
	f.UnitFrame.level = f.UnitFrame.healthBar:CreateFontString(nil, "OVERLAY")
	f.UnitFrame.level:SetFont( font, fontsize, "THINOUTLINE")
	f.UnitFrame.level:SetTextColor(1, 1, 1)
	f.UnitFrame.level:SetPoint("LEFT", f.UnitFrame.healthBar, "LEFT", 10, 0)

	if yo.NamePlates.showPercTreat then
		f.UnitFrame.threat = f.UnitFrame.healthBar:CreateFontString(nil, "OVERLAY")
		f.UnitFrame.threat:SetFont( font, fontsize, "THINOUTLINE")
		f.UnitFrame.threat:SetTextColor(1, 1, 1)
		f.UnitFrame.threat:SetPoint("LEFT", f.UnitFrame.level, "RIGHT", 6, 0)
	end
			
	f.UnitFrame.castBar = CreateFrame("StatusBar", nil, f.UnitFrame)
	f.UnitFrame.castBar:Hide()
	f.UnitFrame.castBar:SetPoint("TOP", f.UnitFrame.healthBar, "BOTTOM", 0, -2)
	f.UnitFrame.castBar:SetSize( nameplatewidth, 5)
	f.UnitFrame.castBar:SetStatusBarTexture( texture)
	f.UnitFrame.castBar:SetStatusBarColor(1, 0.8, 0)

	f.UnitFrame.castBar.Background = f.UnitFrame.castBar:CreateTexture(nil, "BACKGROUND")
	f.UnitFrame.castBar.Background:SetAllPoints( f.UnitFrame.castBar)
	f.UnitFrame.castBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.UnitFrame.castBar.Background:SetTexture( texture)

	f.UnitFrame.castBar.Time = f.UnitFrame.castBar:CreateFontString(nil, "ARTWORK")
	f.UnitFrame.castBar.Time:SetPoint("RIGHT", f.UnitFrame.castBar, "RIGHT", -5, 0)
	f.UnitFrame.castBar.Time:SetFont( font, fontsize - 1, "THINOUTLINE")
	f.UnitFrame.castBar.Time:SetShadowOffset(1, -1)
	f.UnitFrame.castBar.Time:SetTextColor(1, 1, 1)

	f.UnitFrame.castBar.Spark = f.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
	f.UnitFrame.castBar.Spark:SetTexture("")
	
	f.UnitFrame.castBar.Text = f.UnitFrame.castBar:CreateFontString(nil, "OVERLAY")
	f.UnitFrame.castBar.Text:SetPoint("TOP", f.UnitFrame.castBar, "BOTTOM", 0, -1)
	f.UnitFrame.castBar.Text:SetFont( font, fontsize, "THINOUTLINE")
	f.UnitFrame.castBar.Text:SetTextColor(1, 1, 1)
	f.UnitFrame.castBar.Text:SetJustifyH("CENTER")
	
	if yo.NamePlates.showCastIcon then
		f.UnitFrame.castBar.ibg = CreateFrame("Frame", "BACKGROUND", f.UnitFrame.castBar) 
    	f.UnitFrame.castBar.ibg:SetPoint("BOTTOM", f.UnitFrame.healthBar,"CENTER", 0, -2);  
    	f.UnitFrame.castBar.ibg:SetSize( yo["NamePlates"].iconCastSize, yo["NamePlates"].iconCastSize)
		f.UnitFrame.castBar.ibg:SetFrameLevel( 10)
		CreateStyle( f.UnitFrame.castBar.ibg, 3, 6)
	
		f.UnitFrame.castBar.Icon = f.UnitFrame.castBar.ibg:CreateTexture(nil, "BORDER")
		f.UnitFrame.castBar.Icon:SetAllPoints( f.UnitFrame.castBar.ibg)
		f.UnitFrame.castBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	
	--f.UnitFrame.castBar.BorderShield = f.UnitFrame.castBar:CreateTexture(nil, "OVERLAY", 1)
	--f.UnitFrame.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
	--f.UnitFrame.castBar.BorderShield:SetSize(12, 12)
	--f.UnitFrame.castBar.BorderShield:SetPoint("RIGHT", f.UnitFrame.castBar, "LEFT", -2, 0)

	--f.UnitFrame.castBar.Flash = f.UnitFrame.castBar:CreateTexture(nil, "OVERLAY")
	--f.UnitFrame.castBar.Flash:SetAllPoints()
	--f.UnitFrame.castBar.Flash:SetTexture("")
	--f.UnitFrame.castBar.Flash:SetBlendMode("ADD")
	--CreateStyle( f.UnitFrame.castBar, 3)
	if showArrows then
		f.UnitFrame.arrows = CreateFrame( "Frame", nil, f.UnitFrame.healthBar)
		f.UnitFrame.arrows:SetFrameLevel( 10)
		f.UnitFrame.arrows:SetPoint( "CENTER")
	
    	f.UnitFrame.arrowleft = f.UnitFrame.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	f.UnitFrame.arrowleft:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
    	f.UnitFrame.arrowleft:SetTexCoord(0,.72,0,1)
		f.UnitFrame.arrowleft:SetSize( auras_size, auras_size)
    	f.UnitFrame.arrowleft:SetPoint( "RIGHT", f.UnitFrame.healthBar, "LEFT", 10, 0)
		f.UnitFrame.arrowleft:SetVertexColor( 0.8, 1, 0)
		f.UnitFrame.arrowleft:Hide()
	
    	f.UnitFrame.arrowright = f.UnitFrame.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	f.UnitFrame.arrowright:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
		f.UnitFrame.arrowright:SetTexCoord(.72,0,0,1)
    	f.UnitFrame.arrowright:SetSize(  auras_size, auras_size)
    	f.UnitFrame.arrowright:SetPoint( "LEFT", f.UnitFrame.healthBar, "RIGHT", -10, 0)
		f.UnitFrame.arrowright:SetVertexColor( 0.8, 1, 0)
    	f.UnitFrame.arrowright:Hide()
    end	
	f.UnitFrame.RaidTargetFrame = CreateFrame("Frame", nil, f.UnitFrame)
	f.UnitFrame.RaidTargetFrame:SetSize( auras_size +3, auras_size +3)
	f.UnitFrame.RaidTargetFrame:SetPoint("LEFT", f.UnitFrame.healthBar, "RIGHT", 10, 0)

	f.UnitFrame.RaidTargetFrame.RaidTargetIcon = f.UnitFrame.RaidTargetFrame:CreateTexture(nil, "OVERLAY")
	f.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetTexture([[Interface\AddOns\yoFrame\Media\raidicons]])
	f.UnitFrame.RaidTargetFrame.RaidTargetIcon:SetAllPoints()
	f.UnitFrame.RaidTargetFrame.RaidTargetIcon:Hide()

	f.UnitFrame.debuffIcons = CreateFrame("Frame", nil, f.UnitFrame)
	f.UnitFrame.debuffIcons:SetPoint("BOTTOMLEFT", f.UnitFrame.healthBar, "TOPLEFT",  0, 12)
	f.UnitFrame.debuffIcons:SetWidth( nameplatewidth / 2)
	f.UnitFrame.debuffIcons:SetHeight( auras_size)
	f.UnitFrame.debuffIcons:SetFrameLevel(f.UnitFrame:GetFrameLevel() + 20)
	f.UnitFrame.debuffIcons.direction = "RIGHT"

	f.UnitFrame.buffIcons = CreateFrame("Frame", nil, f.UnitFrame)
	f.UnitFrame.buffIcons:SetPoint("BOTTOMRIGHT", f.UnitFrame.healthBar, "TOPRIGHT",  0, 12)
	f.UnitFrame.buffIcons:SetWidth( nameplatewidth / 2)
	f.UnitFrame.buffIcons:SetHeight( aurasB_size)
	f.UnitFrame.buffIcons:SetFrameLevel(f.UnitFrame:GetFrameLevel() + 20)
	f.UnitFrame.buffIcons.direction = "LEFT"

	f.UnitFrame.disIcons = CreateFrame("Frame", nil, f.UnitFrame)
	f.UnitFrame.disIcons:SetPoint("BOTTOM", f.UnitFrame.healthBar, "TOP",  0, 12)
	f.UnitFrame.disIcons:SetWidth( iconDiSize)
	f.UnitFrame.disIcons:SetHeight( iconDiSize)
	f.UnitFrame.disIcons:SetFrameLevel(f.UnitFrame:GetFrameLevel() + 20)
	f.UnitFrame.disIcons.direction = "UP"

	--f.UnitFrame.Class = CreateFrame("Frame", nil, f.UnitFrame)
	--f.UnitFrame.Class:SetPoint("BOTTOMRIGHT", f.UnitFrame.healthBar, "TOPRIGHT", 0, 12 + aurasB_size)
	--f.UnitFrame.Class:SetSize( 30, 30)
	--f.UnitFrame.Class.Icon = f.UnitFrame.Class:CreateTexture(nil, "OVERLAY")
	--f.UnitFrame.Class.Icon:SetAllPoints()
	--f.UnitFrame.Class.Icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	--f.UnitFrame.Class.Icon:SetTexCoord(0, 0, 0, 0)
	--CreateStyle(f.UnitFrame.Class, 3) 

	f.UnitFrame.guune = CreateFrame("Frame", nil, f.UnitFrame)
	f.UnitFrame.guune:SetSize( 30, 30)
	f.UnitFrame.guune:SetPoint("LEFT", f.UnitFrame.disIcons, "RIGHT", 3, 0)
	f.UnitFrame.guune.icon = f.UnitFrame.guune:CreateTexture(nil, "OVERLAY")
	f.UnitFrame.guune.icon:SetAllPoints()
	f.UnitFrame.guune.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CreateStyle(f.UnitFrame.guune, 3) 

	CastingBarFrame_OnLoad(f.UnitFrame.castBar, nil, false, true)
	
	f.UnitFrame.castBar:SetScript("OnEvent", CastingBarFrame_OnEvent)
	--f.UnitFrame.castBar:SetScript("OnUpdate", CastingBarFrame_OnUpdate)
	--f.UnitFrame.castBar:SetScript("OnShow", CastingBarFrame_OnShow)
	--f.UnitFrame.castBar:SetScript("OnHide", function() f.UnitFrame.castBar:Hide() end)
	f.UnitFrame.castBar:HookScript("OnValueChanged", function() NamePlates_UpdateCastBar(f.UnitFrame.castBar) end)
	
	f.UnitFrame:EnableMouse(false)
	--f.UnitFrame:SetAlpha( 1)
end

function NamePlates_UpdateNamePlateOptions()
	-- Called at VARIABLES_LOADED and by "Larger Nameplates" interface options checkbox
	local baseNamePlateWidth = nameplatewidth 
	local baseNamePlateHeight = nameplateheight
	local horizontalScale = 1 --noscalemult	--tonumber(GetCVar("NamePlateHorizontalScale"))

	C_NamePlate.SetNamePlateFriendlySize(baseNamePlateWidth * horizontalScale, baseNamePlateHeight * horizontalScale)
	C_NamePlate.SetNamePlateEnemySize(baseNamePlateWidth * horizontalScale, baseNamePlateHeight * horizontalScale)
	C_NamePlate.SetNamePlateSelfSize(baseNamePlateWidth, baseNamePlateHeight)

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		--print( i, unitFrame)
		UpdateAll(unitFrame)
	end
end


local function HideBlizzard()
	NamePlateDriverFrame:UnregisterAllEvents()
	ClassNameplateManaBarFrame:Hide()

	hooksecurefunc(NamePlateDriverFrame, "SetupClassNameplateBar", function()
		NamePlateTargetResourceFrame:Hide()
		NamePlatePlayerResourceFrame:Hide()
	end)

	local checkBox = InterfaceOptionsNamesPanelUnitNameplatesMakeLarger
	function checkBox.setFunc(value)
		if value == "1" then
			SetCVar("NamePlateHorizontalScale", checkBox.largeHorizontalScale)
			SetCVar("NamePlateVerticalScale", checkBox.largeVerticalScale)
		else
			SetCVar("NamePlateHorizontalScale", checkBox.normalHorizontalScale)
			SetCVar("NamePlateVerticalScale", checkBox.normalVerticalScale)
		end
		NamePlates_UpdateNamePlateOptions()
		--print( checkBox.normalVerticalScale)
	end
end

local function OnUnitFactionChanged(unit)
	-- This would make more sense as a unitFrame:RegisterUnitEvent
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	if (namePlate) then
		UpdateName(namePlate.UnitFrame)
		UpdateHealthColor(namePlate.UnitFrame, 1)
	end
end

local function NamePlate_OnEvent(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	
	--print(event, InCombatLockdown(), self.tick)
	
	if event == "PLAYER_TARGET_CHANGED" then
		UpdateName(self)
	elseif event == "PLAYER_ENTERING_WORLD" then
		UpdateAll(self)
	elseif event == "PLAYER_REGEN_DISABLED" then
		self:SetScript("OnUpdate", nil)
	elseif event == "PLAYER_REGEN_ENABLED" then
		self.tick = 1
		self:SetScript("OnUpdate", UpdateHealthColor)

	elseif arg1 == self.unit or arg1 == self.displayedUnit then
		if event == "UNIT_HEALTH_FREQUENT" then
			UpdateHealth(self)
		elseif event == "UNIT_AURA" then
			UpdateBuffs(self)
		elseif event == "UNIT_THREAT_LIST_UPDATE" then
			UpdateHealthColor(self, 1)
			UpdateTheatSit( self)
		elseif event == "UNIT_NAME_UPDATE" then
			UpdateName(self)
		elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" then
			UpdateAll(self)
		end
	end
end


local function UpdateNamePlateEvents(unitFrame)
	-- These are events affected if unit is in a vehicle
	local unit = unitFrame.unit
	local displayedUnit
	if ( unit ~= unitFrame.displayedUnit ) then
		displayedUnit = unitFrame.displayedUnit
	end

	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_START", unit)
	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit)
	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit)
	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit)
	unitFrame.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit)

	unitFrame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
	unitFrame:RegisterUnitEvent("UNIT_AURA", unit)
	unitFrame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unit)
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:RegisterEvent("UNIT_NAME_UPDATE")
	unitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_PET")
	unitFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	unitFrame:RegisterEvent("UNIT_EXITED_VEHICLE")

	--InCombatLockdown()
	unitFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	unitFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	UpdateNamePlateEvents(unitFrame)
	unitFrame:SetScript("OnEvent", NamePlate_OnEvent)
	--unitFrame:SetAlpha( 1)
end

local function UnregisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", nil)
end

local function SetUnit(unitFrame, unit)
	unitFrame.unit = unit
	unitFrame.displayedUnit = unit	 -- For vehicles
	unitFrame.inVehicle = false
	--print(unitFrame.displayedUnit, unit)
	if unit then
		RegisterNamePlateEvents(unitFrame)
	else
		UnregisterNamePlateEvents(unitFrame)
	end
end

local function OnNamePlateAdded(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	local unitFrame = namePlate.UnitFrame
	SetUnit(unitFrame, unit)
	UpdateAll(unitFrame)
	unitFrame.tick = 1
	unitFrame:SetScript("OnUpdate", UpdateHealthColor)

	--if pType[myClass] then
	--	CreateShardsBar( unitFrame)	
	--end
end

local function OnNamePlateRemoved(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.UnitFrame, nil)
	namePlate.UnitFrame:SetScript("OnUpdate", nil)
	ActionButton_HideOverlayGlow( namePlate.UnitFrame.healthBar)
end

local function NamePlates_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if yo["NamePlates"].enable then
			nameplateheight = yo.NamePlates.height
			nameplatewidth 	= yo.NamePlates.width
			auras_size		= yo.NamePlates.iconDSize
			aurasB_size		= yo.NamePlates.iconBSize
			iconDiSize		= yo.NamePlates.iconDiSize
			showPercTreat	= yo.NamePlates.showPercTreat
			showArrows		= yo.NamePlates.showArrows
			blueDebuff		= yo.NamePlates.blueDebuff
			dissIcons		= yo.NamePlates.dissIcons
			buffIcons		= yo.NamePlates.buffIcons
			classDispell	= yo.NamePlates.classDispell
			showToolTip		= yo.NamePlates.showToolTip
			
			badTypes = classDispell and badClassTypes[myClass] or badClassTypes["HUNTER"]
	
			HideBlizzard()
			NamePlates_UpdateNamePlateOptions()
		else
			self:UnregisterAllEvents()
			return
		end
	elseif event == "NAME_PLATE_CREATED" then
		local namePlate = ...
		OnNamePlateCreated(namePlate)
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...
		OnNamePlateAdded(unit)
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		local unit = ...
		OnNamePlateRemoved(unit)
	elseif event == "RAID_TARGET_UPDATE" then
		OnRaidTargetUpdate()
	elseif event == "DISPLAY_SIZE_CHANGED" then
		--NamePlates_UpdateNamePlateOptions()
	elseif event == "UNIT_FACTION" then
		OnUnitFactionChanged(...)
	end
end

--						http://wowprogramming.com/docs/api/UnitDetailedThreatSituation.html

local NamePlatesFrame = CreateFrame("Frame", "yo_NamePlatesFrame", UIParent)
	--NamePlatesFrame:RegisterEvent("VARIABLES_LOADED") PLAYER_ENTERING_WORLD
	NamePlatesFrame:RegisterEvent("PLAYER_ENTERING_WORLD") 
	NamePlatesFrame:RegisterEvent("NAME_PLATE_CREATED")
	NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	NamePlatesFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
	NamePlatesFrame:RegisterEvent("RAID_TARGET_UPDATE")
	NamePlatesFrame:RegisterEvent("UNIT_FACTION")
	NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)