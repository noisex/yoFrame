local addon, ns = ...

local L, yo, N = unpack( ns)
local oUF = ns.oUF

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GetTime, UnitIsPlayer, UnitAura, UnitIsPlayer, SetRaidTarget, UnitIsUnit, UnitName, UnitClass, UnitHealth, UnitHealthMax, InCombatLockdown, UnitIsTapDenied
	= GetTime, UnitIsPlayer, UnitAura, UnitIsPlayer, SetRaidTarget, UnitIsUnit, UnitName, UnitClass, UnitHealth, UnitHealthMax, InCombatLockdown, UnitIsTapDenied

local GetRuneCooldown, UnitPower, GetSpecialization, UnitPowerMax, GetQuestDifficultyColor, GetUnitName, UnitLevel, UnitClassification, UnitChannelInfo, UnitCastingInfo
	= GetRuneCooldown, UnitPower, GetSpecialization, UnitPowerMax, GetQuestDifficultyColor, GetUnitName, UnitLevel, UnitClassification, UnitChannelInfo, UnitCastingInfo

local UnitExists, UnitInRaid, UnitPlayerControlled, UnitInParty, UnitGroupRolesAssigned, UnitReaction, UnitIsOtherPlayersPet, UnitDetailedThreatSituation
	= UnitExists, UnitInRaid, UnitPlayerControlled, UnitInParty, UnitGroupRolesAssigned, UnitReaction, UnitIsOtherPlayersPet, UnitDetailedThreatSituation

local nameplateheight, nameplatewidth, auras_size, aurasB_size, showPercTreat, 	dissIcons,	buffIcons,	classDispell, badClassTypes, showToolTip
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

--DebuffTypeColor.none = { r = 0.09, g = 0.09, b = 0.09}

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

--local function ShowGuune( unitFrame, showGuune)
--	--https://ru.wowhead.com/npc=136461  Порождение Г'ууна

--	if showGuune then
--		unitFrame.guune.icon:SetTexture( 2032223)
--		unitFrame.guune:Show()
--	else
--		unitFrame.guune:Hide()
--	end
--end

local function scanToQuest( self, ...)
	local tt, showMe = N.ScanTooltip
	tt:SetOwner( UIParent, "ANCHOR_NONE")
	tt:SetUnit( self.unit)
	tt:Show()
	local p1, p2, p4
	for i = 3, min( 8, tt:NumLines()) do
		local line = _G["yoFrame_ScanTooltipTextLeft"..i]
		if line then
			local lineText = line:GetText()

			p1, p2 = lineText:match(": (%d+)/(%d+)$")
			if p1 and p2 and not (p1 == p2) then showMe = true	break end

			p1 = lineText:match ("%. %((%d+%%)%)$")
			if p1 and not (p1 == "100%") then showMe = true break end

			p1 = lineText:match ("%.: (%d+%%)$")
			if p1 and not (p1 == "100%") then showMe = true break end

			p4 = lineText:match (" %((%d+%%)%)$")
			if p4 and not (p4 == "100%") then showMe = true break end
		end
	end
	--print( p1, p2, p3, p4, showMe)
	if p4 	then self.Class.Icon:SetTexture( [[Interface\GossipFrame\DailyQuestIcon]])
			else self.Class.Icon:SetTexture( [[Interface\GossipFrame\AvailableLegendaryQuestIcon]])	end

	if showMe then self.Class:Show() else self.Class:Hide() end
	tt:Hide()
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

			--if spellID ==212431 then print(name, count, debuffType, caster, nameplateShowPersonal, spellID, namepmateshowall) end
			--if idebuff > ( nameplatewidth / 2) / auras_size then break end
			if not yo.NamePlates.moreDebuffIcons then nameplateShowPersonal = false end

			if ((caster == "player" or caster == "pet" or caster == "vehicle") and ( N.DebuffWhiteList[name] or nameplateShowPersonal)) or namepmateshowall or N.tauntsSpell[name] then --or isStealable then or nameplateShowPersonal

				debuffType = blueDebuff and debuffType or nil

				local aIcon = CreateAuraIcon( unitFrame.debuffIcons, idebuff)
				UpdateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
				idebuff = idebuff + 1

			--elseif spellID == 277242 then showGuune = true

			elseif ( filter == "HELPFUL" and not isPlayer and not N.blackSpells[spellID]) then

				if dissIcons ~= "none"	or iDisp > 2 then
					if ( dissIcons == "dispell" and badClassTypes[myClass][debuffType])
						or ( dissIcons == "all" and debuffType) then

						local aIcon = CreateAuraIcon( unitFrame.disIcons, iDisp)
						UpdateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
						iDisp = iDisp + 1
					end
				end

				if buffIcons ~= "none" or ibuff > 4 then
					if buffIcons == "all"
						or ( buffIcons == "dispell" and badTypes[debuffType])
						or ( buffIcons == "buff" and not badTypes[debuffType]) then

						local aIcon = CreateAuraIcon( unitFrame.buffIcons, ibuff)
						UpdateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, unit)
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

	--ShowGuune( unitFrame, showGuune)
end

-----------------------------------------------------------------------------------------------
--	CREATE PLATE
-----------------------------------------------------------------------------------------------

local function myUnitGroupRolesAssigned( unit)

	if yo.NamePlates.tankMode then 	--and unit == "player"
		return "TANK"
	else
		return UnitGroupRolesAssigned( unit)
	end
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
	local treatText, fader = "", 1

	local isTanking, status, scaledPercent, rawPercent = UnitDetailedThreatSituation( "player", unit)

	if UnitIsTapDenied( unit) then
		cols = { .6, .6, .6}

	elseif UnitPlayerControlled( unit) then 											-- юнит-игрок / цвет класса
		cols = oUF.colors.class[ select( 2, UnitClass( unit))]
		fader = yo.Raid.fadeColor - 0.25
		--unitFrame.castBar.spark:Hide()												-- прячем спарку на икроках

	elseif status then
		cols = treatColor[status]

		if UnitInParty("player") then
			if showPercTreat == "scaledPercent" then
				treatText = Round( scaledPercent) .. "%"
			elseif showPercTreat == "rawPercent" then
				treatText = Round( rawPercent) .. "%"
			end
			unitFrame.threat:SetTextColor( cols[1], cols[2], cols[3])
		end

		if myUnitGroupRolesAssigned( "player") == "TANK" then
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
		cols = oUF.colors.reaction[UnitReaction( unit, "player")]			-- цвет реакшн
	end

	unitFrame.threat:SetText( treatText)
	unitFrame.healthBar:SetStatusBarColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
	--unitFrame.healthBar.shadow:SetBackdropBorderColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
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

		if level == myLevel then
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

		--if (tonumber(level) == UnitLevel("player") and not classification == "elite") or UnitIsUnit(unitFrame.displayedUnit, "player") then
		--	unitFrame.level:SetText("")
		--else
			unitFrame.level:SetText(level)
		--end

		local _, _, _, _, _, mobID = strsplit( "-", UnitGUID( unitFrame.displayedUnit))
		mobID = tonumber( mobID)

		unitFrame.name:SetText(name)
		unitFrame.level:SetTextColor(r, g, b)

		if UnitIsUnit( unitFrame.displayedUnit, "target") then
			glowTargetStart( unitFrame.healthBar, {0.95, 0.95, 0.32, 1}, 20, 0.125, 4, 2, 0, 0, false, 1, 3)
			if showArrows then unitFrame.arrows:Show() end
			if unitFrame.classPower then
				UpdateUnitPower( unitFrame.classPower)
				unitFrame.classPower:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
				unitFrame.classPower:SetShown( isDruid())
			end
		else
			glowTargetStop( unitFrame.healthBar, 1)
			if showArrows then unitFrame.arrows:Hide() end
			if unitFrame.classPower and unitFrame.classPower:IsVisible() then
				unitFrame.classPower:Hide()
				unitFrame.classPower:UnregisterEvent("UNIT_POWER_UPDATE")
			end
		end

		--if mobID and ( badMobes[mobID] or eTeam[mobID]) then
		--	--lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key)
		--	glowBadStart( unitFrame.healthBar, glowColor, glowN, 0.2, glowLength, 3, 0, 0, false, 2)
		--else
		--	glowBadStop( unitFrame.healthBar, 2)
		--end

		--if 	--UnitClass( unitFrame.displayedUnit)
		--	UnitIsPlayer( unitFrame.displayedUnit) or eTeam[mobID] 	then

			--if unitFrame.Class then
				--local _, class = UnitClass( unitFrame.displayedUnit)
				--local texcoord = CLASS_ICON_TCOORDS[class]
				--unitFrame.Class.Icon:SetTexCoord(texcoord[1] + 0.015, texcoord[2] - 0.02, texcoord[3] + 0.018, texcoord[4] - 0.02)
				----local specID = GetInspectSpecialization( unitFrame.displayedUnit)
				--GetSpecializationInfoByID(specID, sex);
				----local id, name, description, icon, background, role = GetSpecializationInfo(specID)
				--print( unitFrame.displayedUnit, specID, id, name, description, icon)
				--unitFrame.Class:Show()
			--end
			--if eTeam[mobID] and not GetRaidTargetIndex( unitFrame.displayedUnit) then
			--	SetRaidTarget( unitFrame.displayedUnit, eTeam[mobID]);
			--end
		--else
		--	if unitFrame.Class then
		--		unitFrame.Class:Hide()
		--	end
		--end
	end
	scanToQuest( unitFrame)
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
		scanToQuest( unitFrame, displayedUnit)
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
	table.insert( N.statusBars, f.healthBar)
	--f.healthBar:SetAllPoints(f)

	f.healthBar:SetStatusBarTexture( yo.texture)
	f.healthBar:SetMinMaxValues(0, 1)
	CreateStyle( f.healthBar, 2)

	f.healthBar.Background = f.healthBar:CreateTexture(nil, "BACKGROUND")
	f.healthBar.Background:SetAllPoints( f.healthBar)
	f.healthBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.healthBar.Background:SetTexture( yo.texture)

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
	f.healthBar.perc:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	f.healthBar.perc:SetPoint("RIGHT", f.healthBar, "RIGHT", -5, 0)
	f.healthBar.perc:SetTextColor(1, 1, 1)
	table.insert( N.strings, f.healthBar.perc)

	--f.healthBar.value = f.healthBar:CreateFontString(nil, "OVERLAY")
	--f.healthBar.value:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	--f.healthBar.value:SetPoint("RIGHT", f.healthBar.perc, "LEFT", 0, 0)
	--f.healthBar.value:SetTextColor(1, 1, 1)

	f.name = f:CreateFontString(nil, "OVERLAY")
	f.name:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	f.name:SetPoint("BOTTOM", f.healthBar, "TOP", 0, 2)
	f.name:SetTextColor(1, 1, 1)
	table.insert( N.strings, f.name)

	f.level = f.healthBar:CreateFontString(nil, "OVERLAY")
	f.level:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	f.level:SetTextColor(1, 1, 1)
	f.level:SetPoint("LEFT", f.healthBar, "LEFT", 10, 0)
	table.insert( N.strings, f.level)

	--if yo.NamePlates.showPercTreat then
		f.threat = f.healthBar:CreateFontString(nil, "OVERLAY")
		f.threat:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
		f.threat:SetTextColor(1, 1, 1)
		f.threat:SetPoint("LEFT", f.level, "RIGHT", 6, 0)
		table.insert( N.strings, f.threat)
	--end

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

	f.debuffIcons = CreateFrame("Frame", f:GetName() .. "debuffIcons", f)
	f.debuffIcons:SetPoint("BOTTOMLEFT", f.healthBar, "TOPLEFT",  0, 15)
	f.debuffIcons:SetWidth( nameplatewidth / 2)
	f.debuffIcons:SetHeight( auras_size)
	f.debuffIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.debuffIcons.direction = "RIGHT"

	f.buffIcons = CreateFrame("Frame", f:GetName() .. "buffIcons", f)
	f.buffIcons:SetPoint("BOTTOMRIGHT", f.healthBar, "TOPRIGHT",  0, 15)
	f.buffIcons:SetWidth( nameplatewidth / 2)
	f.buffIcons:SetHeight( aurasB_size)
	f.buffIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.buffIcons.direction = "LEFT"

	f.disIcons = CreateFrame("Frame", f:GetName() .. "disIcons", f)
	f.disIcons:SetPoint("BOTTOM", f.healthBar, "TOP",  0, 15)
	f.disIcons:SetWidth( iconDiSize)
	f.disIcons:SetHeight( iconDiSize)
	f.disIcons:SetFrameLevel(f:GetFrameLevel() + 20)
	f.disIcons.direction = "UP"

	f.Class = CreateFrame("Frame", nil, f)
	f.Class:SetPoint("RIGHT", f.healthBar, "LEFT", -2, 0)
	f.Class:SetSize( 18, 18)
	f.Class:Hide()
	f.Class.Icon = f.Class:CreateTexture(nil, "OVERLAY")
	f.Class.Icon:SetAllPoints()
	f.Class.Icon:SetTexture( [[Interface\GossipFrame\AvailableLegendaryQuestIcon]] ) --"Interface\\WorldStateFrame\\Icons-Classes") --Interface\GossipFrameDailyQuestIcon

	--f.Class.Icon:SetTexCoord(0, 0, 0, 0)
	--CreateStyle(f.Class, 1)

	--f.Shine = CreateFrame("Frame", "$parentShine", f.healthBar, "AutoCastShineTemplate")
	--f.Shine:SetPoint("CENTER", f.healthBar, "CENTER", 0, 0)
	--f.Shine:SetSize( nameplatewidth, nameplateheight)

	--f.guune = CreateFrame("Frame", nil, f)
	--f.guune:SetSize( 30, 30)
	--f.guune:SetPoint("LEFT", f.disIcons, "RIGHT", 3, 0)
	--f.guune.icon = f.guune:CreateTexture(nil, "OVERLAY")
	--f.guune.icon:SetAllPoints()
	--f.guune.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	--CreateStyle(f.guune, 3)

	f:EnableMouse(false)

	CreateCastBarNP( f)

	if yo.NamePlates.showResourses and N.pType[myClass] then
		CreateCPpoints( f)
	end

	frame.UnitFrame = f
end


----------------------------------------------------------------------------------------------------------------
-- 		NAMEPLATES CONSTRUCT
----------------------------------------------------------------------------------------------------------------


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
	ClassNameplateManaBarFrame:UnregisterAllEvents()
	ClassNameplateManaBar = dummy
	NamePlateDriverMixin = dummy

	--- TODO
	--hooksecurefunc(NamePlateDriverFrame, "SetupClassNameplateBar", function()
	--	NamePlateTargetResourceFrame:Hide()
	--	NamePlatePlayerResourceFrame:Hide()
	--end)

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
	elseif event == "PLAYER_ENTERING_WORLD"  or event == "UNIT_QUEST_LOG_CHANGED" then
		UpdateAll(self)
	elseif event == "PLAYER_REGEN_DISABLED" then
		self:SetScript("OnUpdate", nil)
	elseif event == "PLAYER_REGEN_ENABLED" then
		self.tick = 1
		self:SetScript("OnUpdate", UpdateHealthColor)

	elseif arg1 == self.unit or arg1 == self.displayedUnit then
		if event == "UNIT_HEALTH" then
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

	unitFrame:RegisterUnitEvent("UNIT_HEALTH", unit)
	unitFrame:RegisterUnitEvent("UNIT_AURA", unit)
	unitFrame:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unit)
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:RegisterEvent("UNIT_NAME_UPDATE")
	unitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
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
	unitFrame:SetAttribute("unit", unit)
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
	--UpdateBuffs(unitFrame)
	unitFrame.tick = 1
	unitFrame:SetScript("OnUpdate", UpdateHealthColor)

	--if pType[myClass] then
	--	CreateShardsBar( unitFrame)
	--end
	scanToQuest(unitFrame, unit)
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

			ClassNameplateManaBar = dummy
			NamePlateDriverMixin = dummy

			SetCVar("nameplateOccludedAlphaMult",1)
			SetCVar("nameplateMinScale",1)
    		--SetCVar("nameplateMaxScale",1)
			SetCVar("nameplateShowFriendlyNPCs", 0)

			SetCVar("nameplateOverlapH",  0.8) 	--default is 0.8
			SetCVar("nameplateOverlapV",  2) 	--default is 1.5
			SetCVar("nameplateTargetRadialPosition", 1)
			SetCVar("nameplateMotion", 1)

			SetCVar("nameplateMaxAlpha", 0.7) -- 0.7
			SetCVar("nameplateMinAlpha", 0.2)
			SetCVar("nameplateMaxAlphaDistance", 100)
			SetCVar("nameplateMinAlphaDistance", -30)

			SetCVar("nameplateSelectedAlpha", 1)
			SetCVar("nameplateSelectedScale", 1.25)

			SetCVar( "nameplateOtherTopInset", 0.1)
			SetCVar( "nameplateOtherBottomInset", -1)

			SetCVar( "nameplateLargeTopInset", 0.1)
			SetCVar( "nameplateLargeBottomInset", -1)

			SetCVar( "nameplateSelfTopInset", 0.1)
			SetCVar( "nameplateSelfBottomInset", -1)

			SetCVar("ShowClassColorInNameplate", 1)

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

			local br, bg, bb = strsplit( ",", yo.Media.shadowColor)
			if yo.Media.classBorder then
				br, bg, bb = myColor.r, myColor.g, myColor.b
			end
			DebuffTypeColor.none = { r = br, g = bg, b = bb}

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


--local function UpdateTheatSit( self)
--	if yo.NamePlates.showPercTreat == "none" then return end

--	if UnitInRaid("player") or UnitInParty("player") then
--		local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation( "player", self.displayedUnit)

--		if status then
--			cols = treatColor[status]

--			if yo.NamePlates.showPercTreat == "scaledPercent" then
--				self.threat:SetText( Round( scaledPercent) .. "%")
--			else
--				self.threat:SetText( Round( rawPercent) .. "%")
--			end

--			--self.threat:SetTextColor( GetThreatStatusColor( status))
--			self.threat:SetTextColor( cols[1], cols[2], cols[3])
--		else
--			self.threat:SetText( "")
--		end
--	end
--end