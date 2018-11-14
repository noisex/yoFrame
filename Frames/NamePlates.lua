local L, yo = unpack( select( 2, ...))

local nameplateheight, nameplatewidth, auras_size, aurasB_size, showPercTreat, 	dissIcons,	buffIcons,	classDispell, badTypes, showToolTip
local treatColor = {}
local auraFilter = { "HARMFUL", "HELPFUL"}

local aGlow = LibStub("LibCustomGlow-1.0", true)
local glowColor, glowN, glowLength

local glowStart = aGlow.PixelGlow_Start
local glowStop = aGlow.PixelGlow_Stop

local castStart = aGlow.AutoCastGlow_Start
local castStop = aGlow.AutoCastGlow_Stop

local buttonStart = aGlow.ButtonGlow_Start
local buttonStop = aGlow.ButtonGlow_Stop


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
	--[130771] = true,	--	Дамми у ханта
	--[123352] = true, 	--	Дамми у лока
	[144082]	= true, 

	[136330] = true, 	-- голиаф шипы 
	[137103] = true, 	-- кровавый образ
	[120651] = true,  	-- 	Взрывчатка

	[136461] = true,	--  Порождение Г'ууна
	[141851] = true, 	--  Порождение Г'ууна 2
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

	[135770] = 8,	--Старший сержант Слэйд <7-й легион>

	[129062] = 8,	--Вестник солнца Фираси		<Пылающие Солнечные Ястребы>
	[129065] = 7,	--Маг-феникс Рилея			<Пылающие Солнечные Ястребы>
	[129064] = 5,	--Маг-феникс Ридрас			<Пылающие Солнечные Ястребы>

	[130301] = 5,	--Темный охотник Джу'лощина	<Охотники за головами>
	[130302] = 7,	--Берсерк Зар'Рилея 		<Охотники за головами>
	[130303] = 8,	--Знахарка Унбугу			<Охотники за головами>

	[134269] = 7,	--Маана Шепчущее Пламя		<Воители>
	[134271] = 5,	--Служитель солнца Ордел	<Воители>
	[134270] = 8,	--Духостранница Куура		<Воители>

	[133733] = 7,	--Лунный серп Пелани		<Высокорожденные>
	[133738] = 5,	--Астралит Визара			<Высокорожденные>
	[133734] = 8,	--Начертатель рун Лузарис	<Высокорожденные>

	[140682] = 8,	--Ледяной Кулак				<Снегобородый патриарх>
	
	[130872] = 8,	--Леди Сена					<Механики Газлоу>
	[134997] = 7,	--Газлоу					<Механики Газлоу>
	[134998] = 7,	--Газлоу					<Механики Газлоу>
	[130871] = 5,	--Скеггит					<Механики Газлоу>
	
	[134332] = 7,	--Капитан Зеленобрюшка		<Налетчики Зеленобрюшки>
	[129364] = 8,	--Пит Проныра				<Налетчики Зеленобрюшки>
	[134333] = 5,	--Тупень					<Налетчики Зеленобрюшки>
	
}

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
	GameTooltip:SetUnitAura( f.unit, f.id, f.filter)
	GameTooltip:Show()
end

local function BuffOnLeave( f)
	GameTooltip:Hide()	
end

function CreateAuraIcon(parent, index, noToolTip, timerPosition)
	local size = parent:GetHeight()
	local sh = ceil( size / 8)

	local button = CreateFrame("Frame", nil, parent)
	button:SetWidth( size)
	button:SetHeight( size)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	--button.cd = CreateFrame("Cooldown", nil, button)
	--button.cd:SetAllPoints(button)
	--button.cd:SetReverse(true)
	
	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont( fontpx, max( 10, size / 1.85), "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)	
	button.count:SetTextColor( 0, 1, 0)
	if timerPosition == "BOTTOM" then
		button.count:SetPoint("TOPRIGHT", button, "TOPRIGHT", 6, 6)
	else
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -2)
	end

	button.timer = button:CreateFontString(nil, "OVERLAY")
	button.timer:SetFont( fontpx, max( 10, size / 1.85), "THINOUTLINE")
	button.timer:SetShadowOffset(1, -1)
	if timerPosition == "BOTTOM" then
		button.timer:SetPoint("CENTER", button, "BOTTOM", 0, 0)	
	else
		button.timer:SetPoint("CENTER", button, "CENTER", 0, 0)	
	end
	
	
	CreateStyle( button, max( 3, sh - 1))

	local p1, p2, shX, shY = "LEFT", "RIGHT", sh, 0

	if parent.direction == "LEFT" then
		p1, p2, shX, shY = "RIGHT", "LEFT", -sh, 0
	elseif parent.direction == "UP" then
		p1, p2, shX, shY = "BOTTOM", "TOP", 0, sh
	end

	if index == 1 then
		button:SetPoint( p1, parent, p1)
	else
		button:SetPoint( p1, parent[index-1], p2, shX, shY)
	end
	
	if not noToolTip and showToolTip ~= "none" then
		button:EnableMouse(true)
		button:SetScript("OnEnter", BuffOnEnter)
		button:SetScript("OnLeave", BuffOnLeave)
	end
	
	return button
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

	local color = DebuffTypeColor[debuffType] or DebuffTypeColor.none
	button.shadow:SetBackdropBorderColor(color.r, color.g, color.b)	

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
			self:SetScript("OnUpdate", nil)
			return
		else
			button.timer:SetTextColor( 1, 1, 0)
		end

		if ( duration and duration > 0) and est > 0.1 then
			--print( formatTime( est), expirationTime, est)
			button.timer:SetText( formatTime( est))
		else
			button.timer:SetText( "")
		end		
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
			local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellID, _, _, _, namepmateshowall = UnitAura(unit, index, filter)
			if not name then break end
			--if idebuff > ( nameplatewidth / 2) / auras_size then break end

			if ( caster == "player" and DebuffWhiteList[name]) or namepmateshowall then --or isStealable then
				
				debuffType = blueDebuff and debuffType or nil

				if not unitFrame.debuffIcons[idebuff] then	unitFrame.debuffIcons[idebuff] = CreateAuraIcon(unitFrame.debuffIcons, idebuff)	end
										
				UpdateAuraIcon(unitFrame.debuffIcons[idebuff], filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
				idebuff = idebuff + 1
			
			elseif spellID == 277242 then showGuune = true

			elseif ( filter == "HELPFUL" and not isPlayer and not blackSpells[spellID]) then

				if dissIcons ~= "none"	or iDisp > 2 then
					if ( dissIcons == "dispell" and badClassTypes[myClass][debuffType])  
						or ( dissIcons == "all" and debuffType) then

						if not unitFrame.disIcons[iDisp] then unitFrame.disIcons[iDisp] = CreateAuraIcon(unitFrame.disIcons, iDisp)end			
						
						UpdateAuraIcon(unitFrame.disIcons[iDisp], filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
						iDisp = iDisp + 1		
					end
				end
				
				if buffIcons ~= "none" or ibuff > 4 then
					if buffIcons == "all" 
						or ( buffIcons == "dispell" and badTypes[debuffType])  
						or ( buffIcons == "buff" and not badTypes[debuffType]) then

						if not unitFrame.buffIcons[ibuff] then unitFrame.buffIcons[ibuff] = CreateAuraIcon(unitFrame.buffIcons, ibuff) end
				
						UpdateAuraIcon(unitFrame.buffIcons[ibuff], filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
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
	local perc_text = string.format("%s - %d%%", ShortValue(minHealth), math.floor(perc * 100))

	unitFrame.healthBar:SetValue(perc)
	unitFrame.healthBar.perc:SetText( perc_text )

	if yo.NamePlates.executePhaze then
		if yo.NamePlates.executeProc >= perc * 100  then
			unitFrame.healthBar.HightLight:Show()
		else
			unitFrame.healthBar.HightLight:Hide()
		end
	end
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

local function UpdateHealthColor(unitFrame, elapsed)
	
	if InCombatLockdown() then 
		unitFrame:SetScript("OnUpdate", nil) 
	else
		unitFrame.tick = ( unitFrame.tick or 1) + elapsed
		if unitFrame.tick <= 0.5 then 
			return 
		end
		unitFrame.tick = 0
	end
	
	local unit = unitFrame.displayedUnit
	local cols = { .6, .6, .6}
	local unitTarget = unit .. "target"
	local treatText = ""

	local isTanking, status, scaledPercent, rawPercent = UnitDetailedThreatSituation( "player", unit)

	if UnitIsTapDenied( unit) then
		cols = { .6, .6, .6}

	elseif UnitPlayerControlled( unit) then 											-- юнит-игрок / цвет класса
		cols = _G["yo_Player"].colors.class[ select( 2, UnitClass( unit))]

	elseif status then
		cols = treatColor[status]

		if UnitInParty("player") then
			if showPercTreat == "scaledPercent" then
				treatText = floor( scaledPercent) .. "%"
			elseif showPercTreat == "rawPercent" then
				treatText = floor( rawPercent) .. "%"
			end
			unitFrame.threat:SetTextColor( cols[1], cols[2], cols[3])
		end		

		if UnitGroupRolesAssigned( "player") == "TANK" then
			cols = treatColor[status +10]

			if not isTanking and UnitGroupRolesAssigned( unitTarget) == "TANK" then  	-- танк, бьет оффтанка
				cols = treatColor.tankOT

			elseif UnitIsOtherPlayersPet( unitTarget) then								-- танк, бьет чего-то пета --see UnitPlayerOrPetInParty
				cols = treatColor.myPet
			end

		elseif UnitIsUnit( "pet", unitTarget) then
			cols = treatColor.myPet														-- игрок, бьет его пета
		end

	elseif UnitExists( unitTarget) then
		cols = treatColor.badGood

	else 	--if UnitReaction( unit, 'player') then  --or UnitPlayerControlled( unit) then
		cols = _G["yo_Player"].colors.reaction[UnitReaction( unit, "player")]			-- цвет реакшн
	end    	

	unitFrame.threat:SetText( treatText)
	unitFrame.healthBar:SetStatusBarColor( cols[1], cols[2], cols[3])
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
				unitFrame.arrows:Show()
				glowTargetStart( unitFrame.healthBar, {0.95, 0.95, 0.32, 1}, 16, 0.125, 4, 1, 0, 0, false, 1 )
			else
				unitFrame.arrows:Hide()
				glowTargetStop( unitFrame.healthBar, 1)
			end
		else
			if showArrows then
				unitFrame.arrows:Hide()
				glowTargetStop( unitFrame.healthBar, 1)
			end
		end
		
		if mobID and ( badMobes[mobID] or eTeam[mobID]) then
			--lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key)
			glowBadStart( unitFrame.healthBar, glowColor, glowN, 0.2, glowLength, 3, 0, 0, false, 2)
			--unitFrame.healthBar.shadow:SetBackdropBorderColor( 0, 1, 1)
			--unitFrame.healthBar.HightLight:Show()
		else
			glowBadStop( unitFrame.healthBar, 2)
			--unitFrame.healthBar.shadow:SetBackdropBorderColor( .09, .09, .09)
			--unitFrame.healthBar.HightLight:Hide()
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
	if yo.NamePlates.showPercTreat == "none" then return end

	if UnitInRaid("player") or UnitInParty("player") then
		local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation( "player", self.displayedUnit)
	
		if status then
			if yo.NamePlates.showPercTreat == "scaledPercent" then
				self.threat:SetText( floor( scaledPercent) .. "%")	
			else
				self.threat:SetText( floor( rawPercent) .. "%")
			end
			
			self.threat:SetTextColor( GetThreatStatusColor( status))
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
		--UpdateTheatSit( unitFrame)
		 
		if UnitIsUnit("player", unitFrame.displayedUnit) then
			unitFrame.castBar:UnregisterAllEvents()
		end
	end
end

-----------------------------------------------------------------------------------------------
-- FRAME
-----------------------------------------------------------------------------------------------
local function OnNamePlateCreated( frame)

	local f = CreateFrame("Button", "$parentUnitFrame", frame)
	f:SetAllPoints( frame)
	f:SetFrameLevel( frame:GetFrameLevel())
	f:SetScale( UIParent:GetScale())
	
	f.healthBar = CreateFrame("StatusBar", nil, f)
	f.healthBar:SetPoint("CENTER", f, "CENTER", 0, 0)
	f.healthBar:SetSize( nameplatewidth, nameplateheight)
	--f.healthBar:SetAllPoints(f)

	f.healthBar:SetStatusBarTexture( texture)
	f.healthBar:SetMinMaxValues(0, 1)
	CreateStyle( f.healthBar, 3)

	f.healthBar.Background = f.healthBar:CreateTexture(nil, "BACKGROUND")
	f.healthBar.Background:SetAllPoints( f.healthBar)
	f.healthBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.healthBar.Background:SetTexture( texture)

	local r, g, b = strsplit( "," , yo.NamePlates.executeColor)
	local textureHL = "Interface\\AddOns\\yoFrame\\Media\\highlight2"
	f.healthBar.HightLight = f.healthBar:CreateTexture(nil, "OVERLAY")
   	f.healthBar.HightLight:SetPoint('TOPLEFT', f.healthBar:GetStatusBarTexture(), 'TOPLEFT')
   	f.healthBar.HightLight:SetPoint('BOTTOMRIGHT', f.healthBar:GetStatusBarTexture(), 'BOTTOMRIGHT')
	f.healthBar.HightLight:SetVertexColor( r, g, b, 1)
	f.healthBar.HightLight:SetBlendMode( "ADD")
	f.healthBar.HightLight:SetTexture( texhl)	
	f.healthBar.HightLight:SetAlpha( 0.2)
	f.healthBar.HightLight:Hide()	
	
	f.healthBar.perc = f.healthBar:CreateFontString(nil, "OVERLAY")
	f.healthBar.perc:SetFont( font, fontsize, "THINOUTLINE")
	f.healthBar.perc:SetPoint("RIGHT", f.healthBar, "RIGHT", -5, 0)
	f.healthBar.perc:SetTextColor(1, 1, 1)

	--f.healthBar.value = f.healthBar:CreateFontString(nil, "OVERLAY")
	--f.healthBar.value:SetFont( font, fontsize, "THINOUTLINE")
	--f.healthBar.value:SetPoint("RIGHT", f.healthBar.perc, "LEFT", 0, 0)
	--f.healthBar.value:SetTextColor(1, 1, 1)

	f.name = f:CreateFontString(nil, "OVERLAY")
	f.name:SetFont( font, fontsize, "THINOUTLINE")
	f.name:SetPoint("BOTTOM", f.healthBar, "TOP", 0, 2)
	f.name:SetTextColor(1, 1, 1)
	
	f.level = f.healthBar:CreateFontString(nil, "OVERLAY")
	f.level:SetFont( font, fontsize, "THINOUTLINE")
	f.level:SetTextColor(1, 1, 1)
	f.level:SetPoint("LEFT", f.healthBar, "LEFT", 10, 0)

	--if yo.NamePlates.showPercTreat then
		f.threat = f.healthBar:CreateFontString(nil, "OVERLAY")
		f.threat:SetFont( font, fontsize, "THINOUTLINE")
		f.threat:SetTextColor(1, 1, 1)
		f.threat:SetPoint("LEFT", f.level, "RIGHT", 6, 0)
	--end
			
	f.castBar = CreateFrame("StatusBar", nil, f)
	f.castBar:Hide()
	f.castBar:SetPoint("TOP", f.healthBar, "BOTTOM", 0, -2)
	f.castBar:SetSize( nameplatewidth, 5)
	f.castBar:SetStatusBarTexture( texture)
	f.castBar:SetStatusBarColor(1, 0.8, 0)

	f.castBar.Background = f.castBar:CreateTexture(nil, "BACKGROUND")
	f.castBar.Background:SetAllPoints( f.castBar)
	f.castBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.castBar.Background:SetTexture( texture)

	f.castBar.Time = f.castBar:CreateFontString(nil, "ARTWORK")
	f.castBar.Time:SetPoint("RIGHT", f.castBar, "RIGHT", -5, 0)
	f.castBar.Time:SetFont( font, fontsize - 1, "THINOUTLINE")
	f.castBar.Time:SetShadowOffset(1, -1)
	f.castBar.Time:SetTextColor(1, 1, 1)

	f.castBar.Spark = f.castBar:CreateTexture(nil, "OVERLAY")
	f.castBar.Spark:SetTexture("")
	
	f.castBar.Text = f.castBar:CreateFontString(nil, "OVERLAY")
	f.castBar.Text:SetPoint("TOP", f.castBar, "BOTTOM", 0, -1)
	f.castBar.Text:SetFont( font, fontsize, "THINOUTLINE")
	f.castBar.Text:SetTextColor(1, 1, 1)
	f.castBar.Text:SetJustifyH("CENTER")
	
	if yo.NamePlates.showCastIcon then
		f.castBar.ibg = CreateFrame("Frame", "BACKGROUND", f.castBar) 
    	f.castBar.ibg:SetPoint("BOTTOM", f.healthBar,"CENTER", 0, -2);  
    	f.castBar.ibg:SetSize( yo.NamePlates.iconCastSize, yo.NamePlates.iconCastSize)
		f.castBar.ibg:SetFrameLevel( 10)
		CreateStyle( f.castBar.ibg, 3, 6)
	
		f.castBar.Icon = f.castBar.ibg:CreateTexture(nil, "BORDER")
		f.castBar.Icon:SetAllPoints( f.castBar.ibg)
		f.castBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	
	--f.castBar.BorderShield = f.castBar:CreateTexture(nil, "OVERLAY", 1)
	--f.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
	--f.castBar.BorderShield:SetSize(12, 12)
	--f.castBar.BorderShield:SetPoint("RIGHT", f.castBar, "LEFT", -2, 0)

	--f.castBar.Flash = f.castBar:CreateTexture(nil, "OVERLAY")
	--f.castBar.Flash:SetAllPoints()
	--f.castBar.Flash:SetTexture("")
	--f.castBar.Flash:SetBlendMode("ADD")
	--CreateStyle( f.castBar, 3)
	if showArrows then
		f.arrows = CreateFrame( "Frame", nil, f.healthBar)
		f.arrows:SetFrameLevel( 10)
		f.arrows:SetPoint( "CENTER")
		f.arrows:Hide()

    	f.arrows.arrowleft = f.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	f.arrows.arrowleft:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
    	f.arrows.arrowleft:SetTexCoord(0,.72,0,1)
		f.arrows.arrowleft:SetSize( auras_size, auras_size)
    	f.arrows.arrowleft:SetPoint( "RIGHT", f.healthBar, "LEFT", 10, 0)
		f.arrows.arrowleft:SetVertexColor( 0.8, 1, 0)
			
    	f.arrows.arrowright = f.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	f.arrows.arrowright:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
		f.arrows.arrowright:SetTexCoord(.72,0,0,1)
    	f.arrows.arrowright:SetSize(  auras_size, auras_size)
    	f.arrows.arrowright:SetPoint( "LEFT", f.healthBar, "RIGHT", -10, 0)
		f.arrows.arrowright:SetVertexColor( 0.8, 1, 0)
    end	

	f.RaidTargetFrame = CreateFrame("Frame", nil, f)
	f.RaidTargetFrame:SetSize( auras_size +3, auras_size +3)
	f.RaidTargetFrame:SetPoint("LEFT", f.healthBar, "RIGHT", 10, 0)

	f.RaidTargetFrame.RaidTargetIcon = f.RaidTargetFrame:CreateTexture(nil, "OVERLAY")
	f.RaidTargetFrame.RaidTargetIcon:SetTexture([[Interface\AddOns\yoFrame\Media\raidicons]])
	f.RaidTargetFrame.RaidTargetIcon:SetAllPoints()
	f.RaidTargetFrame.RaidTargetIcon:Hide()

	f.debuffIcons = CreateFrame("Frame", nil, f)
	f.debuffIcons:SetPoint("BOTTOMLEFT", f.healthBar, "TOPLEFT",  0, 12)
	f.debuffIcons:SetWidth( nameplatewidth / 2)
	f.debuffIcons:SetHeight( auras_size)
	f.debuffIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.debuffIcons.direction = "RIGHT"

	f.buffIcons = CreateFrame("Frame", nil, f)
	f.buffIcons:SetPoint("BOTTOMRIGHT", f.healthBar, "TOPRIGHT",  0, 12)
	f.buffIcons:SetWidth( nameplatewidth / 2)
	f.buffIcons:SetHeight( aurasB_size)
	f.buffIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.buffIcons.direction = "LEFT"

	f.disIcons = CreateFrame("Frame", nil, f)
	f.disIcons:SetPoint("BOTTOM", f.healthBar, "TOP",  0, 12)
	f.disIcons:SetWidth( iconDiSize)
	f.disIcons:SetHeight( iconDiSize)
	f.disIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.disIcons.direction = "UP"

	f.Class = CreateFrame("Frame", nil, f)
	f.Class:SetPoint("BOTTOMRIGHT", f.healthBar, "BOTTOMLEFT", -8, 0)
	f.Class:SetSize( 30, 30)
	f.Class.Icon = f.Class:CreateTexture(nil, "OVERLAY")
	f.Class.Icon:SetAllPoints()
	f.Class.Icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	f.Class.Icon:SetTexCoord(0, 0, 0, 0)
	--CreateStyle(f.Class, 3) 

	--f.Shine = CreateFrame("Frame", "$parentShine", f.healthBar, "AutoCastShineTemplate")
	--f.Shine:SetPoint("CENTER", f.healthBar, "CENTER", 0, 0)
	--f.Shine:SetSize( nameplatewidth, nameplateheight)

	f.guune = CreateFrame("Frame", nil, f)
	f.guune:SetSize( 30, 30)
	f.guune:SetPoint("LEFT", f.disIcons, "RIGHT", 3, 0)
	f.guune.icon = f.guune:CreateTexture(nil, "OVERLAY")
	f.guune.icon:SetAllPoints()
	f.guune.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CreateStyle(f.guune, 3) 

	CastingBarFrame_OnLoad(f.castBar, nil, false, true)
	
	f.castBar:SetScript("OnEvent", CastingBarFrame_OnEvent)
	f.castBar:HookScript("OnValueChanged", function() NamePlates_UpdateCastBar(f.castBar) end)
	
	f:EnableMouse(false)

	frame.UnitFrame = f
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
			--UpdateTheatSit( self)
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
	--:GetParent().namePlateUnitToket = unit
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
		if yo.NamePlates.enable then

			treatColor = {
				[0]			={	strsplit(",", yo.NamePlates.c0)},
				[1]			={	strsplit(",", yo.NamePlates.c1)},
				[2]			={	strsplit(",", yo.NamePlates.c2)},
				[3]			={	strsplit(",", yo.NamePlates.c3)},
				
				[10]		={	strsplit(",", yo.NamePlates.c0t)},
				[11]		={	strsplit(",", yo.NamePlates.c1)},
				[12]		={	strsplit(",", yo.NamePlates.c2)},
				[13]		={	strsplit(",", yo.NamePlates.c3t)},
				
				["myPet"]	={	strsplit(",", yo.NamePlates.myPet)},
				["tankOT"]	={ 	strsplit(",", yo.NamePlates.tankOT)},
				["badGood"]	={ 	strsplit(",", yo.NamePlates.badGood)},
			}

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
			
			if yo.NamePlates.glowTarget then
				glowTargetStart	= glowStart
				glowTargetStop = glowStop
			else
				glowTargetStart	= dummy
				glowTargetStop  = dummy
			end

			if yo.NamePlates.glowBadType == "pixel" then 
				glowBadStart 	= glowStart
				glowBadStop  	= glowStop
				glowColor 		= { 0.95, 0.1, 0.1, 1}
				glowN			= 12
				glowLength		= 12
			elseif yo.NamePlates.glowBadType == "button" then 
				glowBadStart 	= buttonStart
				glowBadStop  	= buttonStop
				glowColor 		= { 1, 0.75, 0, 1}
				glowN			= 2
			elseif yo.NamePlates.glowBadType == "cast" then 
				glowBadStart 	= castStart
				glowBadStop  	= castStop
				glowColor 		= { 1, 0.75, 0, 1}
				glowN			= 8
				glowLength		= 1
			else
				glowBadStart = dummy
				glowBadStop  = dummy
			end

			badTypes = classDispell and badClassTypes[myClass] or badClassTypes["HUNTER"]
	
			HideBlizzard()
			NamePlates_UpdateNamePlateOptions()

			SetCVar("nameplateMaxDistance", yo.NamePlates.maxDispance)
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


	--NamePlatesFrame:SetScript("OnUpdate", AutoCastShine_OnUpdate)
--local function ActionButton_ShowOverlayGlow(self)
--	if ( self.overlay ) then
--		if ( self.overlay.animOut:IsPlaying() ) then
--			self.overlay.animOut:Stop();
--			self.overlay.animIn:Play();
--		end
--	else
--		self.overlay = ActionButton_GetOverlayGlow();
--		local frameWidth, frameHeight = self:GetSize();
--		self.overlay:SetParent(self);
--		self.overlay:ClearAllPoints();
--		--Make the height/width available before the next frame:
--		self.overlay:SetSize( frameWidth, frameHeight);
--		--self.overlay:SetPoint("CENTER", self, "CENTER", 0, 0)
--		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * .20, frameHeight * .45)
--		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * .20, -frameHeight * .45);
--		self.overlay:SetAlpha(0.2);
--		self.overlay.animIn:Play();
--	end
--end

--local AUTOCAST_SHINE_R = .95;
--local AUTOCAST_SHINE_G = .95;
--local AUTOCAST_SHINE_B = .32;

--local AUTOCAST_SHINE_SPEEDS = { 2, 4, 6, 8 };
--local AUTOCAST_SHINE_TIMERS = { 0, 0, 0, 0 };
--local AUTOCAST_SHINES = {};

--local function AutoCastShine_AutoCastStart(button, r, g, b)
--	local button = _G[ button:GetName() .. "Shine"]

--	if ( AUTOCAST_SHINES[button] ) then
--		return;
--	end

--	AUTOCAST_SHINES[button] = true;

--	if ( not r ) then
--		r, g, b = AUTOCAST_SHINE_R, AUTOCAST_SHINE_G, AUTOCAST_SHINE_B;
--	end

--	for _, sparkle in next, button.sparkles do
--		sparkle:Show();
--		sparkle:SetVertexColor(r, g, b);
--	end
--end

--local function AutoCastShine_AutoCastStop(button)
--	local button = _G[ button:GetName() .. "Shine"]

--	AUTOCAST_SHINES[button] = nil;

--	for _, sparkle in next, button.sparkles do
--		sparkle:Hide();
--	end
--end

--local function AutoCastShine_OnUpdate(self, elapsed)
--	for i in next, AUTOCAST_SHINE_TIMERS do
--		AUTOCAST_SHINE_TIMERS[i] = AUTOCAST_SHINE_TIMERS[i] + elapsed;
--		if ( AUTOCAST_SHINE_TIMERS[i] > AUTOCAST_SHINE_SPEEDS[i]*4 ) then
--			AUTOCAST_SHINE_TIMERS[i] = 0;
--		end
--	end

--	for button in next, AUTOCAST_SHINES do
--		self = button;
--		--self = _G[self:GetName() .. "Shine"]
--		local parent, distance, heightce = self, self:GetWidth(), self:GetHeight();

--		-- This is local to this function to save a lookup. If you need to use it elsewhere, might wanna make it global and use a local reference.
--		local AUTOCAST_SHINE_SPACING = 6;

--		for i = 1, 4 do
--			local timer = AUTOCAST_SHINE_TIMERS[i];
--			local speed = AUTOCAST_SHINE_SPEEDS[i];

--			if ( timer <= speed ) then
--				local basePosition = timer/speed*distance;
--				self.sparkles[0+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0);
--				self.sparkles[4+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0);
--				self.sparkles[8+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -heightce);
--				self.sparkles[12+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, heightce);
--			elseif ( timer <= speed*2 ) then
--				local basePosition = (timer-speed)/speed*distance;
--				self.sparkles[0+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -heightce);
--				self.sparkles[4+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, heightce);
--				self.sparkles[8+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0);
--				self.sparkles[12+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0);
--			elseif ( timer <= speed*3 ) then
--				local basePosition = (timer-speed*2)/speed*distance;
--				self.sparkles[0+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0);
--				self.sparkles[4+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0);
--				self.sparkles[8+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, heightce);
--				self.sparkles[12+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -heightce);
--			else
--				local basePosition = (timer-speed*3)/speed*distance;
--				self.sparkles[0+i]:SetPoint("CENTER", parent, "BOTTOMLEFT", 0, heightce);
--				self.sparkles[4+i]:SetPoint("CENTER", parent, "TOPRIGHT", 0, -heightce);
--				self.sparkles[8+i]:SetPoint("CENTER", parent, "TOPLEFT", basePosition, 0);
--				self.sparkles[12+i]:SetPoint("CENTER", parent, "BOTTOMRIGHT", -basePosition, 0);
--			end
--		end
--	end
--end

