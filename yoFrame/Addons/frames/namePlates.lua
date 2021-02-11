local addon, ns = ...

local L, yo, n = unpack( ns)
local oUF = ns.oUF

if not yo.NamePlates.enable then return end
--https://ru.wowhead.com/spell=299150/%D0%B1%D0%B5%D0%B7%D1%83%D0%B4%D0%B5%D1%80%D0%B6%D0%BD%D0%B0%D1%8F-%D0%BC%D0%BE%D1%89%D1%8C
n.namePlates = {}
local np = n.namePlates

local _G = _G

local CreateStyle, C_NamePlate, ShortValue, DebuffTypeColor, tinsert, SetRaidTargetIconTexture, GameTooltip, GetSpellInfo
	= CreateStyle, C_NamePlate, ShortValue, DebuffTypeColor, tinsert, SetRaidTargetIconTexture, GameTooltip, GetSpellInfo

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GetTime, UnitIsPlayer, UnitAura, UnitIsPlayer, SetRaidTarget, UnitIsUnit, UnitName, UnitClass, UnitHealth, UnitHealthMax, InCombatLockdown, UnitIsTapDenied, GetRaidTargetIndex
	= GetTime, UnitIsPlayer, UnitAura, UnitIsPlayer, SetRaidTarget, UnitIsUnit, UnitName, UnitClass, UnitHealth, UnitHealthMax, InCombatLockdown, UnitIsTapDenied, GetRaidTargetIndex

local GetRuneCooldown, UnitPower, GetSpecialization, UnitPowerMax, GetQuestDifficultyColor, GetUnitName, UnitLevel, UnitClassification, UnitChannelInfo, UnitCastingInfo, UnitGUID, UIParent
	= GetRuneCooldown, UnitPower, GetSpecialization, UnitPowerMax, GetQuestDifficultyColor, GetUnitName, UnitLevel, UnitClassification, UnitChannelInfo, UnitCastingInfo, UnitGUID, UIParent

local UnitExists, UnitInRaid, UnitPlayerControlled, UnitInParty, UnitGroupRolesAssigned, UnitReaction, UnitIsOtherPlayersPet, UnitDetailedThreatSituation, SetCVar, CreateFrame, GetCVar, Round, isDruid
	= UnitExists, UnitInRaid, UnitPlayerControlled, UnitInParty, UnitGroupRolesAssigned, UnitReaction, UnitIsOtherPlayersPet, UnitDetailedThreatSituation, SetCVar, CreateFrame, GetCVar, Round, isDruid

local nameplateheight 	= yo.NamePlates.height
local nameplatewidth 	= yo.NamePlates.width
local auras_size		= yo.NamePlates.iconDSize
local aurasB_size		= yo.NamePlates.iconBSize
local iconDiSize		= yo.NamePlates.iconDiSize
local showPercTreat		= yo.NamePlates.showPercTreat
local showArrows		= yo.NamePlates.showArrows
local blueDebuff		= yo.NamePlates.blueDebuff
local dissIcons			= yo.NamePlates.dissIcons
local buffIcons			= yo.NamePlates.buffIcons
local classDispell		= yo.NamePlates.classDispell
local showToolTip		= yo.NamePlates.showToolTip

local auraFilter = { "HARMFUL", "HELPFUL"}
local tempSpells = {}
--local tc = n.Addons.elements.torgastClicks.CELLS

--glowColor, glowN, glowLength, glowBadStart, glowBadStop

local aGlow 			= n.LIBS.ButtonGlow

np.glowTargetStart		= yo.NamePlates.glowTarget and aGlow.PixelGlow_Start or n.dummy
np.glowTargetStop 		= yo.NamePlates.glowTarget and aGlow.PixelGlow_Stop  or n.dummy

if yo.NamePlates.glowBadType == "pixel" then
	np.glowBadStart 	= aGlow.PixelGlow_Start
	np.glowBadStop  	= aGlow.PixelGlow_Stop
	np.glowColor 		= { 0.95, 0.1, 0.1, 1}
	np.glowN			= 12
	np.glowLength		= 12
elseif yo.NamePlates.glowBadType == "button" then
	np.glowBadStart 	= aGlow.ButtonGlow_Start
	np.glowBadStop  	= aGlow.ButtonGlow_Stop
	np.glowColor 		= { 1, 0.75, 0, 1}
	np.glowN			= 2
elseif yo.NamePlates.glowBadType == "cast" then
	np.glowBadStart 	= aGlow.AutoCastGlow_Start
	np.glowBadStop  	= aGlow.AutoCastGlow_Stop
	np.glowColor 		= { 1, 0.75, 0, 1}
	np.glowN			= 8
	np.glowLength		= 1
else
	np.glowBadStart = n.dummy
	np.glowBadStop  = n.dummy
end

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

local badTypes = classDispell and badClassTypes[n.myClass] or badClassTypes["HUNTER"]

local treatColor = {
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

local br, bg, bb = strsplit( ",", yo.Media.shadowColor)
if yo.Media.classBorder then
	br, bg, bb = n.myColor.r, n.myColor.g, n.myColor.b
end
DebuffTypeColor.none = { r = br, g = bg, b = bb}

local function OnLeave( self) GameTooltip:Hide() end
local function OnEnter( self)
	GameTooltip:SetOwner( self, "ANCHOR_CURSOR", 20, 5)
	--GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 15, 5)
	GameTooltip:SetHyperlink( "spell:" .. self.id)
	GameTooltip:Show()
end

local function updateMarks( self)
	local index = GetRaidTargetIndex( self.unit)

	if(index) then
		SetRaidTargetIconTexture( self.RaidTargetIndicator, index)
		self.RaidTargetIndicator:Show()
	else
		self.RaidTargetIndicator:Hide()
	end
end

local function updateBuffs(self)
	if not self.unit then return end

	local unit, showGuune = self.unit, nil
	local isPlayer = UnitIsPlayer( unit)
	local idebuff, ibuff, iDisp = 1, 1, 1

	for	j = 1, 2 do
		local filter = auraFilter[j]
		local index = 1
		while true do
			local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellID, _, _, _, namepmateshowall = UnitAura(unit, index, filter)
			if not name then break end

			if not yo.NamePlates.moreDebuffIcons then nameplateShowPersonal = false end
			if ((caster == "player" or caster == "pet" or caster == "vehicle") and ( n.DebuffWhiteList[name] or nameplateShowPersonal)) or namepmateshowall or n.tauntsSpell[name] then --or isStealable then or nameplateShowPersonal
			--if ((caster == "player" or caster == "pet" or caster == "vehicle") and n.DebuffWhiteList[name] ) or namepmateshowall or n.tauntsSpell[name] then
				debuffType = blueDebuff and debuffType or nil

				local aIcon = n.createAuraIcon( self.debuffIcons, idebuff)
				aIcon.unit = unit
				n.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
				idebuff = idebuff + 1

			--elseif spellID == 277242 then showGuune = true

			elseif ( filter == "HELPFUL" and not isPlayer and not n.blackSpells[spellID]) then
				--true then
				if dissIcons ~= "none"	or iDisp > 2 then
					if ( dissIcons == "dispell" and badClassTypes[n.myClass][debuffType])
						or ( dissIcons == "all" and debuffType) then

						local aIcon = n.createAuraIcon( self.disIcons, iDisp)
						aIcon.unit = unit
						n.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
						iDisp = iDisp + 1
					end
				end

				if buffIcons ~= "none" or ibuff > 4 then
					if buffIcons == "all"
						or ( buffIcons == "dispell" and badTypes[debuffType])
						or ( buffIcons == "buff" and not badTypes[debuffType]) then

						local aIcon = n.createAuraIcon( self.buffIcons, ibuff)
						aIcon.unit = unit
						n.updateAuraIcon( aIcon, filter, icon, count, debuffType, duration, expirationTime, spellID, index, name)
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

	--for index = idebuff, self.debuffIcons.iMax or 0 do self.debuffIcons[index]:Hide() end
	--for index = ibuff,   self.buffIcons.iMax   or 0 do self.buffIcons[index]:Hide()   end
	--for index = iDisp,   self.disIcons.iMax    or 0 do self.disIcons[index]:Hide()    end

	--self.debuffIcons.iMax 	= idebuff
	--self.buffIcons.iMax 	= ibuff
	--self.disIcons.iMax 		= iDisp

	--print( index, self.debuffIcons.iMax)
	--ShowGuune( self, showGuune)
end

local function myUnitGroupRolesAssigned( unit)

	if yo.NamePlates.tankMode then 	--and unit == "player"
		return "TANK"
	else
		return UnitGroupRolesAssigned( unit)
	end
end

local function scanToQuest( self, ...)
	local tt, showMe = n.scanTooltip
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

		if level == UnitLevel( "player") then --n.myLevel then
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
			np.glowTargetStart( self.Health, {0.95, 0.95, 0.32, 1}, 20, 0.125, 4, 2, 0, 0, false, 1, 3)
			if showArrows then self.arrows:Show() end
			if self.classPower then
				n.updateUnitPower( self.classPower)
				self.classPower:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
				self.classPower:SetShown( isDruid())
			end
		else
			np.glowTargetStop( self.Health, 1)
			if showArrows then self.arrows:Hide() end
			if self.classPower and self.classPower:IsVisible() then
				self.classPower:Hide()
				self.classPower:UnregisterEvent("UNIT_POWER_UPDATE")
			end
		end

		local _, _, _, _, _, mobID = strsplit( "-", UnitGUID( self.unit))
		mobID = tonumber( mobID)

		if mobID and n.badMobs[mobID] then
			local cols = n.badMobs[mobID]
			--lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key)
			--np.glowBadStart( self.Health, np.glowColor, np.glowN, 0.2, np.glowLength, 3, 0, 0, false, 2)
			np.glowBadStart( self.Health, cols, np.glowN, 0.2, np.glowLength, 2, 2, 2, false, 2)
			self.Health.focusInd:SetVertexColor( cols[1], cols[2], cols[3], 0.3)
			self.Health.focusInd:Show()
			--self.Health.shadow:SetBackdropBorderColor( self.mcols[1], self.mcols[2], self.mcols[3], 1)
		else
			np.glowBadStop( self.Health, 2)
			self.Health.focusInd:Hide()
			--self.Health.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 0.9)
		end

		if mobID and ( n.npcProgress[mobID] and not n.npcProgress[mobID].stun) then
			self.stun:Show()
		else
			self.stun:Hide()
		end

		if mobID and n.animainfoNPC[mobID] and ( n.namePlates.CELLS and n.namePlates.CELLS > 0 ) then
			local spellID 	= n.animainfoNPC[mobID]
            local icon 		= tempSpells[spellID] or select( 3, GetSpellInfo( spellID))

            self.anima.id 	= spellID
			self.animaIcon:SetTexture( icon)
			self.anima:Show()
		else
			self.anima:Hide()
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
		cols = oUF.colors.class[ select( 2, UnitClass( unit))] or { .6, .6, .6}
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
		cols = oUF.colors.reaction[UnitReaction( unit, "player")]	or { .6, .6, .6}					-- цвет реакшн
	end

	self.threat:SetText( treatText)
	self.Health:SetStatusBarColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
	--self.Health.shadow:SetBackdropBorderColor( cols[1]*fader, cols[2]*fader, cols[3]*fader)
	self.name:SetTextColor( cols[1], cols[2], cols[3])

	self.cols = cols

	--if self.mcols then cols = 	self.mcols end
	--self.name:SetTextColor( cols[1], cols[2], cols[3])

	--self.Health.focusInd:SetShown( UnitIsUnit ( unit, "focus"))

end

local function updateHealth(self)--, unit, minHealth, maxHealth)
	local unit = self.unit
	if not unit then return end

	local minHealth, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local perc = minHealth / maxHealth

	local perc_text = format("%s - %d%%", ShortValue(minHealth), floor(perc * 100))

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
		updateBuffs(self)
		scanToQuest( self, unit)
		updateMarks( self)

		if self.Castbar then
			self.Castbar:ForceUpdate( self)
			--updateCastBar( self.castBar, self.unit, true)
			if UnitIsUnit("player", self.unit) then
				--self.CastBar:UnregisterAllEvents()
			end
		end
	end
end

local function callback(self, event, unit)
	if self then
		self.UpdateAllElements( self)
	end
	--oUF:DisableBlizzard( unit)
	ClassNameplateManaBar 	= yo.dummy
	NamePlateDriverMixin 	= yo.dummy
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
	self.Health:SetStatusBarTexture( n.texture)
	tinsert( n.Addons.elements.statusBars, self.Health)

	self.Health.frequentUpdates = true
	self.Health.Override = updateHealth --n.dummy
	CreateStyle( self.Health, 2)

	self.Health.Background = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.Background:SetAllPoints( self.Health)
	self.Health.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	self.Health.Background:SetTexture( n.texture)

	local r, g, b = strsplit( "," , yo.NamePlates.executeColor)
	local textureHL = yo.Media.path .. "textures\\highlight2"
	self.Health.HightLight = self.Health:CreateTexture(nil, "OVERLAY")
   	self.Health.HightLight:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT')
   	self.Health.HightLight:SetPoint('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	self.Health.HightLight:SetVertexColor( r, g, b, 1)
	self.Health.HightLight:SetBlendMode( "ADD")
	self.Health.HightLight:SetTexture( n.texhl)
	self.Health.HightLight:SetAlpha( 0.5)
	self.Health.HightLight:Hide()

	self.Health.focusInd = self.Health:CreateTexture(nil, "OVERLAY", 2)
   	--self.Health.focusInd:SetAllPoints( self.Health)
   	self.Health.focusInd:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT')
   	self.Health.focusInd:SetPoint('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	self.Health.focusInd:SetVertexColor( 0, 0.7, 0.9)
	self.Health.focusInd:SetTexture( yo.Media.path .. "textures\\overlay_indicator_1.blp")
	--self.Health.focusInd:SetBlendMode("ADD")
	--self.Health.focusInd:SetAlpha( 0.4)

	self.Health.perc = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.perc:SetFont( n.font, n.fontsize, "THINOUTLINE")
	self.Health.perc:SetPoint("RIGHT", self.Health, "RIGHT", -5, 0)
	self.Health.perc:SetTextColor(1, 1, 1)
	tinsert( n.Addons.elements.strings, self.Health.perc)

	self.name = self:CreateFontString(nil, "OVERLAY")
	self.name:SetFont( n.font, n.fontsize, "THINOUTLINE")
	self.name:SetPoint("BOTTOM", self.Health, "TOP", 0, 2)
	self.name:SetTextColor(1, 1, 1)
	tinsert( n.Addons.elements.strings, self.name)

	self.level = self.Health:CreateFontString(nil, "OVERLAY")
	self.level:SetFont( n.font, n.fontsize, "THINOUTLINE")
	self.level:SetTextColor(1, 1, 1)
	self.level:SetPoint("LEFT", self.Health, "LEFT", 13, 0)
	tinsert( n.Addons.elements.strings, self.level)

	--if yo.NamePlates.showPercTreat then
		self.threat = self.Health:CreateFontString(nil, "OVERLAY")
		self.threat:SetFont( n.font, n.fontsize, "THINOUTLINE")
		self.threat:SetTextColor(1, 1, 1)
		self.threat:SetPoint("LEFT", self.level, "RIGHT", 6, 0)
		tinsert( n.Addons.elements.strings, self.threat)
	--end

	if showArrows then
		self.arrows = CreateFrame( "Frame", nil, self.Health)
		self.arrows:SetFrameLevel( 10)
		self.arrows:SetPoint( "CENTER")
		self.arrows:Hide()

    	self.arrows.arrowleft = self.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	self.arrows.arrowleft:SetTexture( yo.Media.path .. "icons\\target-arrow")
    	self.arrows.arrowleft:SetTexCoord(0,.72,0,1)
		self.arrows.arrowleft:SetSize( auras_size, auras_size)
    	self.arrows.arrowleft:SetPoint( "RIGHT", self.Health, "LEFT", 10, 0)
		self.arrows.arrowleft:SetVertexColor( 0.8, 1, 0)

    	self.arrows.arrowright = self.arrows:CreateTexture( nil, 'ARTWORK', nil, 7)
    	self.arrows.arrowright:SetTexture( yo.Media.path .. "icons\\target-arrow")
		self.arrows.arrowright:SetTexCoord(.72,0,0,1)
    	self.arrows.arrowright:SetSize(  auras_size, auras_size)
    	self.arrows.arrowright:SetPoint( "LEFT", self.Health, "RIGHT", -10, 0)
		self.arrows.arrowright:SetVertexColor( 0.8, 1, 0)
    end

	self.RaidTargetIndicator = self.RaidTargetIndicator or self:CreateTexture(nil, 'OVERLAY')
    self.RaidTargetIndicator:SetSize( auras_size +3, auras_size +3)
    self.RaidTargetIndicator:SetPoint("LEFT", self.Health, "RIGHT", 10, 0)
    self.RaidTargetIndicator:SetTexture( yo.Media.path .. "icons\\raidicons")
    self.RaidTargetIndicator:Hide()

	self.debuffIcons = CreateFrame("Frame", nil, self)
	self.debuffIcons:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT",  0, 15)
	self.debuffIcons:SetWidth( nameplatewidth / 2)
	self.debuffIcons:SetHeight( auras_size)
	self.debuffIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.debuffIcons.direction 	 = "RIGHT"
	self.debuffIcons.hideTooltip = true
	self.debuffIcons.inRow  	 = 3

	self.buffIcons = CreateFrame("Frame", nil, self)
	self.buffIcons:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT",  0, 15)
	self.buffIcons:SetWidth( nameplatewidth / 2)
	self.buffIcons:SetHeight( aurasB_size)
	self.buffIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.buffIcons.direction = "LEFT"
	self.buffIcons.anchor 	 = "BOTTOMRIGHT"
	self.buffIcons.inRow  	 = 3

	self.disIcons = CreateFrame("Frame", nil, self)
	self.disIcons:SetPoint("BOTTOM", self.Health, "TOP",  0, 15)
	self.disIcons:SetWidth( iconDiSize)
	self.disIcons:SetHeight( iconDiSize)
	self.disIcons:SetFrameLevel(self:GetFrameLevel() + 20)
	self.disIcons.direction = "LEFT"
	self.disIcons.inRow  	= 1

	self.questIcon = self:CreateTexture(nil, "OVERLAY")
	self.questIcon:SetPoint("RIGHT", self.Health, "LEFT", -2, 0)
	self.questIcon:SetSize( 18, 18)
	self.questIcon:Hide()

	self.stun = self.disIcons:CreateTexture(nil, "BORDER")
	self.stun:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
	self.stun:SetTexture( yo.Media.path .. "icons\\icon_red")
	self.stun:SetSize( nameplateheight * 0.7, nameplateheight * 0.7)
	self.stun:Hide()

	self.anima = CreateFrame("Button", nil, self.Health)
	self.anima:SetPoint("BOTTOM", self.Health, "TOP", 0, 15)
	self.anima:SetSize( 25, 25)
	self.anima:createStyle( 3)
	self.anima:EnableMouse( true)
	self.anima:SetScript("OnLeave", OnLeave)
	self.anima:SetScript("OnEnter", OnEnter)
	self.anima:Hide()

	self.animaIcon = self.anima:CreateTexture(nil, "OVERLAY")
	self.animaIcon:SetAllPoints()
	self.animaIcon:SetTexCoord( unpack( n.tCoord))

	n.createCastBarNP( self)

	self.UpdateAllElements = updateAll

	self.tick = 1
	self:SetScript("OnUpdate", updateHealthColor)

	--tinsert(self.__elements, self.onChangeTarget)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", updateName, true)
	self:RegisterEvent("UNIT_AURA", updateBuffs)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", onEvent, true)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", onEvent, true)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", onEvent)

	--self.castBar:RegisterEvent("UNIT_SPELLCAST_START", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_STOP", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", self.castBar.castOnEven, unit)
	--self.castBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", self.castBar.castOnEven, unit)

	if yo.NamePlates.showResourses and n.pType[n.myClass] then n.createCPpoints( self) end
end

oUF:RegisterStyle(	"yo", createNP)
oUF:SetActiveStyle(	"yo")
oUF:SpawnNamePlates("yo", callback)