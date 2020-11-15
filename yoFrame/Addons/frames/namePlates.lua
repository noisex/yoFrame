local addon, ns = ...

local L, yo, N = unpack( ns)
local oUF = ns.oUF

if not yo.NamePlates.enable then return end

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
	[93619] = true, 	--	Дамми у лока
	[144082]	= true,

	[136330] = true, 	-- голиаф шипы
	[137103] = true, 	-- кровавый образ
	[120651] = true,  	-- 	Взрывчатка

	[136461] = true,	--  Порождение Г'ууна
	[141851] = true, 	--  Порождение Г'ууна 2
}

local function NamePlates_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if yo.NamePlates.enable then

			SetCVar("nameplateOccludedAlphaMult",1)
			SetCVar("nameplateMinScale",1)
    		--SetCVar("nameplateMaxScale",1)
			SetCVar("nameplateShowFriendlyNPCs", 0)

			SetCVar("nameplateOverlapH",  0.8) 	--default is 0.8
			SetCVar("nameplateOverlapV",  0.6) 	--default is 1.5
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

			SetCVar("nameplateMaxDistance", yo.NamePlates.maxDispance)
		end
	end
end

--						http://wowprogramming.com/docs/api/UnitDetailedThreatSituation.html

local NamePlatesFrame = CreateFrame("Frame", "yo_NamePlatesFrame", UIParent)
	NamePlatesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)




local function UpdateBuffs(self)
	if not self.unit then return end

	local unit, showGuune = self.unit, nil
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

				local aIcon = N.createAuraIcon( self.debuffIcons, idebuff)
				aIcon.unit = unit
				N.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
				idebuff = idebuff + 1

			--elseif spellID == 277242 then showGuune = true

			elseif ( filter == "HELPFUL" and not isPlayer and not N.blackSpells[spellID]) then

				if dissIcons ~= "none"	or iDisp > 2 then
					if ( dissIcons == "dispell" and badClassTypes[myClass][debuffType])
						or ( dissIcons == "all" and debuffType) then

						local aIcon = N.createAuraIcon( self.disIcons, iDisp)
						aIcon.unit = unit
						N.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
						iDisp = iDisp + 1
					end
				end

				if buffIcons ~= "none" or ibuff > 4 then
					if buffIcons == "all"
						or ( buffIcons == "dispell" and badTypes[debuffType])
						or ( buffIcons == "buff" and not badTypes[debuffType]) then

						local aIcon = N.createAuraIcon( self.buffIcons, ibuff)
						aIcon.unit = unit
						N.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
						ibuff = ibuff + 1
					end
				end
			end

			index = index + 1
		end
	end

	for index = idebuff, #self.debuffIcons do self.debuffIcons[index]:Hide() end
	for index = ibuff,   #self.buffIcons   do self.buffIcons[index]:Hide()   end
	for index = iDisp,   #self.disIcons    do self.disIcons[index]:Hide()   end

	--ShowGuune( self, showGuune)
end

local function myUnitGroupRolesAssigned( unit)

	if yo.NamePlates.tankMode then 	--and unit == "player"
		return "TANK"
	else
		return UnitGroupRolesAssigned( unit)
	end
end

local function UpdateRaidTarget(self)
	local icon = self.RaidTargetFrame.RaidTargetIcon
	local index = GetRaidTargetIndex(self.unit)
	if index then
		SetRaidTargetIconTexture(icon, index)
		icon:Show()
	else
		icon:Hide()
	end
end

local function OnRaidTargetUpdate()
	for _, namePlate in pairs(C_NamePlate.GetNamePlates()) do
		UpdateRaidTarget(namePlate.self)
	end
end

local function scanToQuest( self, ...)
	local tt, showMe = N.scanTooltip
	tt:SetOwner( UIParent, "ANCHOR_NONE")
	tt:SetUnit( self.unit)
	tt:Show()
	local p1, p2, p4
	for i = 3, min( 8, tt:NumLines()) do
		local line = _G["yoFrame_STTTextLeft"..i]
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
	if p4 	then self.questIcon:SetTexture( [[Interface\GossipFrame\DailyQuestIcon]])
			else self.questIcon:SetTexture( [[Interface\GossipFrame\AvailableLegendaryQuestIcon]])	end

	self.questIcon:SetShown( showMe)
	tt:Hide()
end

local function updateName( self)
	local name = GetUnitName(self.unit, false)
	if name then
		local level = UnitLevel( self.unit)
		local classification = UnitClassification( self.unit)

		local r, g, b
		if level == -1 or not level then
			level = "??"
			r, g, b = 0.8, 0.05, 0
		else
			local color = GetQuestDifficultyColor(level)
			r, g, b = color.r, color.g, color.b
		end

		if level == UnitLevel( "player") then --myLevel then
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

		self.level:SetText(level)
		self.name:SetText(name)
		self.level:SetTextColor(r, g, b)

		if UnitIsUnit( self.unit, "target") then
			glowTargetStart( self.Health, {0.95, 0.95, 0.32, 1}, 20, 0.125, 4, 2, 0, 0, false, 1, 3)
			if showArrows then self.arrows:Show() end
			if self.classPower then
				UpdateUnitPower( self.classPower)
				self.classPower:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
				self.classPower:SetShown( isDruid())
			end
		else
			glowTargetStop( self.Health, 1)
			if showArrows then self.arrows:Hide() end
			if self.classPower and self.classPower:IsVisible() then
				self.classPower:Hide()
				self.classPower:UnregisterEvent("UNIT_POWER_UPDATE")
			end
		end

		local _, _, _, _, _, mobID = strsplit( "-", UnitGUID( self.unit))
		mobID = tonumber( mobID)

		if mobID and badMobes[mobID] then
			--lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key)
			glowBadStart( self.Health, glowColor, glowN, 0.2, glowLength, 3, 0, 0, false, 2)
		else
			glowBadStop( self.Health, 2)
		end

		--if 	--UnitClass( self.unit)
		--	UnitIsPlayer( self.unit) or eTeam[mobID] 	then

			--if self.Class then
				--local _, class = UnitClass( self.unit)
				--local texcoord = CLASS_ICON_TCOORDS[class]
				--self.Class.Icon:SetTexCoord(texcoord[1] + 0.015, texcoord[2] - 0.02, texcoord[3] + 0.018, texcoord[4] - 0.02)
				----local specID = GetInspectSpecialization( self.unit)
				--GetSpecializationInfoByID(specID, sex);
				----local id, name, description, icon, background, role = GetSpecializationInfo(specID)
				--print( self.unit, specID, id, name, description, icon)
				--self.Class:Show()
			--end
			--if eTeam[mobID] and not GetRaidTargetIndex( self.unit) then
			--	SetRaidTarget( self.unit, eTeam[mobID]);
			--end
		--else
		--	if self.Class then
		--		self.Class:Hide()
		--	end
		--end
	end
	scanToQuest( self)
end

local function updateHealthColor(self, elapsed)

	self.tick = ( self.tick or 1) + elapsed
	if self.tick <= 0.5 then return end
	self.tick = 0

	--if InCombatLockdown() then self:SetScript("OnUpdate", nil) end

	local unit = self.unit
	local cols = { .6, .6, .6}
	local unitTarget = unit .. "target"
	local treatText, fader = "", 1

	local isTanking, status, scaledPercent, rawPercent = UnitDetailedThreatSituation( "player", unit)

	if UnitIsTapDenied( unit) then
		cols = { .6, .6, .6}

	elseif UnitPlayerControlled( unit) then 											-- юнит-игрок / цвет класса
		cols = oUF.colors.class[ select( 2, UnitClass( unit))]
		fader = yo.Raid.fadeColor - 0.2
		--self.castBar.spark:Hide()														-- прячем спарку на икроках

	elseif status then
		cols = treatColor[status]

		if UnitInParty("player") then
			if showPercTreat == "scaledPercent" then
				treatText = Round( scaledPercent) .. "%"
			elseif showPercTreat == "rawPercent" then
				treatText = Round( rawPercent) .. "%"
			end
			self.threat:SetTextColor( cols[1], cols[2], cols[3])
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
		cols = oUF.colors.reaction[UnitReaction( unit, "player")]						-- цвет реакшн
	end

	self.threat:SetText( treatText)
	self.Health:SetStatusBarColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
	--self.Health.shadow:SetBackdropBorderColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
	self.name:SetTextColor( cols[1], cols[2], cols[3])

	self.Health.focusInd:SetShown( UnitIsUnit ( unit, "focus"))
end

local function updateHealth(self)--, unit, minHealth, maxHealth)
	local unit = self.unit
	if not unit then return end

	local minHealth, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local perc = minHealth / maxHealth

	local perc_text = string.format("%s - %d%%", ShortValue(minHealth), math.floor(perc * 100))

	self.Health:SetValue(perc)
	self.Health.perc:SetText( perc_text )

	if yo.NamePlates.executePhaze then
		if yo.NamePlates.executeProc >= perc * 100  then
			self.Health.HightLight:Show()
		else
			self.Health.HightLight:Hide()
		end
	end
	--if UnitIsPlayer(unit) then
	--	if perc <= 0.5 and perc >= 0.2 then
	--		SetVirtualBorder(self.Health, 1, 1, 0)
	--	elseif perc < 0.2 then
	--		SetVirtualBorder(self.Health, 1, 0, 0)
	--	else
	--		SetVirtualBorder(self.Health, 0.05, 0.05, 0.05, 1)
	--	end
	--elseif not UnitIsPlayer(unit) then
	--	SetVirtualBorder(self.Health, 0.05, 0.05, 0.05, 1)
	--end
end

local function updateAll(self, event, unit)

	if UnitExists(self.unit) then
		updateName(self)
		updateHealthColor(self, 1)
		updateHealth(self)
		UpdateBuffs(self)
		UpdateRaidTarget(self)
		scanToQuest( self, unit)

		if self.Castbar then
			self.Castbar:ForceUpdate( self)
			--updateCastBar( self.castBar, self.unit, true)
			if UnitIsUnit("player", self.unit) then
				self.CastBar:UnregisterAllEvents()
			end
		end
	end
end

local function callback(self, ...)
	if self then
		self.UpdateAllElements( self)
	end
end

local function onEvent( self, event, unit)

	if event == "PLAYER_REGEN_DISABLED" then
		--self:SetScript("OnUpdate", nil)

	elseif event == "PLAYER_REGEN_ENABLED" then
		self.tick = 1
		self:SetScript("OnUpdate", updateHealthColor)

	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		updateHealthColor(self, 1)
	end
end


local function createNP(self, unit)
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit)

	self.unit = unit
	self:SetScale( GetCVar("uiScale"))

	self:SetPoint("CENTER", nameplate, "CENTER")
	self:SetSize( nameplatewidth, nameplateheight)

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetPoint("CENTER", self, "CENTER", 0, 0)
	--self.Health:SetAllPoints(self)
	self.Health:SetSize( nameplatewidth, nameplateheight)
	self.Health:SetMinMaxValues(0, 1)
	self.Health:SetStatusBarTexture( yo.texture)
	table.insert( N.statusBars, self.Health)

	self.Health.frequentUpdates = true
	self.Health.Override = updateHealth --dummy
	CreateStyle( self.Health, 2)

	self.Health.Background = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.Background:SetAllPoints( self.Health)
	self.Health.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	self.Health.Background:SetTexture( yo.texture)

	local r, g, b = strsplit( "," , yo.NamePlates.executeColor)
	local textureHL = "Interface\\AddOns\\yoFrame\\Media\\highlight2"
	self.Health.HightLight = self.Health:CreateTexture(nil, "OVERLAY")
   	self.Health.HightLight:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT')
   	self.Health.HightLight:SetPoint('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	self.Health.HightLight:SetVertexColor( r, g, b, 1)
	self.Health.HightLight:SetBlendMode( "ADD")
	self.Health.HightLight:SetTexture( texhl)
	self.Health.HightLight:SetAlpha( 0.5)
	self.Health.HightLight:Hide()

	self.Health.focusInd = self.Health:CreateTexture(nil, "OVERLAY", 2)
   	self.Health.focusInd:SetAllPoints( self.Health)
	self.Health.focusInd:SetVertexColor( 0, 0.7, 0.9)
	self.Health.focusInd:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\overlay_indicator_1.blp")
	self.Health.focusInd:SetAlpha( 0.4)

	self.Health.perc = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.perc:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	self.Health.perc:SetPoint("RIGHT", self.Health, "RIGHT", -5, 0)
	self.Health.perc:SetTextColor(1, 1, 1)
	table.insert( N.strings, self.Health.perc)

	self.name = self:CreateFontString(nil, "OVERLAY")
	self.name:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	self.name:SetPoint("BOTTOM", self.Health, "TOP", 0, 2)
	self.name:SetTextColor(1, 1, 1)
	table.insert( N.strings, self.name)

	self.level = self.Health:CreateFontString(nil, "OVERLAY")
	self.level:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	self.level:SetTextColor(1, 1, 1)
	self.level:SetPoint("LEFT", self.Health, "LEFT", 10, 0)
	table.insert( N.strings, self.level)

	--if yo.NamePlates.showPercTreat then
		self.threat = self.Health:CreateFontString(nil, "OVERLAY")
		self.threat:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
		self.threat:SetTextColor(1, 1, 1)
		self.threat:SetPoint("LEFT", self.level, "RIGHT", 6, 0)
		table.insert( N.strings, self.threat)
	--end

	if showArrows then
		self.arrows = CreateFrame( "Frame", nil, self.Health)
		self.arrows:SetFrameLevel( 10)
		self.arrows:SetPoint( "CENTER")
		self.arrows:Hide()

    	self.arrows.arrowleft = self.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	self.arrows.arrowleft:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
    	self.arrows.arrowleft:SetTexCoord(0,.72,0,1)
		self.arrows.arrowleft:SetSize( auras_size, auras_size)
    	self.arrows.arrowleft:SetPoint( "RIGHT", self.Health, "LEFT", 10, 0)
		self.arrows.arrowleft:SetVertexColor( 0.8, 1, 0)

    	self.arrows.arrowright = self.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	self.arrows.arrowright:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\target-arrow")
		self.arrows.arrowright:SetTexCoord(.72,0,0,1)
    	self.arrows.arrowright:SetSize(  auras_size, auras_size)
    	self.arrows.arrowright:SetPoint( "LEFT", self.Health, "RIGHT", -10, 0)
		self.arrows.arrowright:SetVertexColor( 0.8, 1, 0)
    end

	self.RaidTargetFrame = CreateFrame("Frame", nil, self)
	self.RaidTargetFrame:SetSize( auras_size +3, auras_size +3)
	self.RaidTargetFrame:SetPoint("LEFT", self.Health, "RIGHT", 10, 0)

	self.RaidTargetFrame.RaidTargetIcon = self.RaidTargetFrame:CreateTexture(nil, "OVERLAY")
	self.RaidTargetFrame.RaidTargetIcon:SetTexture([[Interface\AddOns\yoFrame\Media\raidicons]])
	self.RaidTargetFrame.RaidTargetIcon:SetAllPoints()
	self.RaidTargetFrame.RaidTargetIcon:Hide()

	self.debuffIcons = CreateFrame("Frame", nil, self)
	self.debuffIcons:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT",  0, 15)
	self.debuffIcons:SetWidth( nameplatewidth / 2)
	self.debuffIcons:SetHeight( auras_size)
	self.debuffIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.debuffIcons.direction = "RIGHT"

	self.buffIcons = CreateFrame("Frame", nil, self)
	self.buffIcons:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT",  0, 15)
	self.buffIcons:SetWidth( nameplatewidth / 2)
	self.buffIcons:SetHeight( aurasB_size)
	self.buffIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.buffIcons.direction = "LEFT"

	self.disIcons = CreateFrame("Frame", nil, self)
	self.disIcons:SetPoint("BOTTOM", self.Health, "TOP",  0, 15)
	self.disIcons:SetWidth( iconDiSize)
	self.disIcons:SetHeight( iconDiSize)
	self.disIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.disIcons.direction = "UP"

	self.questIcon = self:CreateTexture(nil, "OVERLAY")
	self.questIcon:SetPoint("RIGHT", self.Health, "LEFT", -2, 0)
	self.questIcon:SetSize( 18, 18)
	self.questIcon:Hide()

	createCastBarNP( self)

	self.UpdateAllElements = updateAll

	self.tick = 1
	self:SetScript("OnUpdate", updateHealthColor)

	self:RegisterEvent("PLAYER_TARGET_CHANGED", updateName, true)
	self:RegisterEvent("UNIT_AURA", UpdateBuffs)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", onEvent, true)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", onEvent, true)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", onEvent)

	--self.castBar:RegisterEvent("UNIT_SPELLCAST_START", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_STOP", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", self.castBar.castOnEven, unit)

	if yo.NamePlates.showResourses and N.pType[myClass] then CreateCPpoints( self) end
end

oUF:RegisterStyle(	"yo", createNP)
oUF:SetActiveStyle(	"yo")
oUF:SpawnNamePlates("yo", callback)