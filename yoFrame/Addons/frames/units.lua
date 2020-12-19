local _, ns = ...
local oUF = ns.oUF or oUF
--local colors = oUF.colors
local L, yo, n = ns[1], ns[2], ns[3]

local fontsymbol 	= "Interface\\AddOns\\yoFrame\\Media\\symbol.ttf"
local texhl 		= "Interface\\AddOns\\yoFrame\\Media\\raidbg"

local _G = _G
local yoUF = n.unitFrames
local MAX_BOSS_FRAMES= MAX_BOSS_FRAMES

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GetColors, CreateFrame, CreateStyle, GetTime, IsResting, tinsert
	= GetColors, CreateFrame, CreateStyle, GetTime, IsResting, tinsert

local updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end

	if frame.holyShards then frame.holyShards:recolorShards( frame.holyShards.cols) end
end

------------------------------------------------------------------------------------------------------
---											BEGIN
------------------------------------------------------------------------------------------------------

local function unitShared(self, unit)
	local cunit = (unit and unit:find("boss%d")) and "boss" or unit
	if cunit == "boss" then self.isboss = true end
	self.cunit 	= cunit

	GetColors( self)
	n.importUnitsAPI( self)

	local height 			= _G["yoMove" .. cunit]:GetHeight()
	local width 			= _G["yoMove" .. cunit]:GetWidth()
	local enablePower 		= true
	local enablePowerText	= false
	local nameLeight		= "namelong"
	local namePos			= { "BOTTOMLEFT", self, "BOTTOMLEFT", 4, 13}
	local rtargetPos 		= { "CENTER", self, "TOP", 0, 2}
	local healthTextPos		= { "TOPRIGHT", self, "TOPRIGHT", 0, -2}
	local powerPos			= { "BOTTOM", self, "BOTTOM", 0, 4}
	local powerHeight		= 4
	local showLeader 		= true
	local combatPos 		= 6
	local nameTextSize		= n.fontsize

	if yo.UF.simpleUF then
		height 			= height / 1.8
		width 			= width / 1.1
		enablePower 	= yo.UF.enableSPower
		enablePowerText	= false
		powerPos		= { "BOTTOM", self, "BOTTOM", 0, 2}
		powerHeight		= 3
		showLeader 		= false
		nameTextSize	= n.fontsize + 0
		combatPos 		= 0
		nameLeight		= "namemedium"
		namePos			= { "LEFT", self, "TOPLEFT", 5, 1}
		healthTextPos	= { "BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 2}
		rtargetPos 		= { "CENTER", self, "TOPRIGHT", -15, 0}
		self.simpleUF	= true
	end

	if unit == "pet" or unit == "focus" or unit == "targettarget" or unit == "focustarget" then
		powerHeight = 2
	end

	_G["yoMove" .. cunit]:SetHeight( height)
	_G["yoMove" .. cunit]:SetWidth( width)
	self:SetWidth( width)
	self:SetHeight( height)

	------------------------------------------------------------------------------------------------------
	---											HEALTH BAR
	------------------------------------------------------------------------------------------------------
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetAllPoints( self)
	self.Health:SetWidth( width)
	self.Health:SetHeight(height)
	self.Health:SetStatusBarTexture( n.texture)
	self.Health:SetFrameLevel( 1)
	self.Health:GetStatusBarTexture():SetHorizTile(false)
	tinsert( n.statusBars, self.Health)

	self.Health.hbg = self.Health:CreateTexture(nil, "BACKGROUND")		-- look 	AssistantIndicator.PostUpdate
	self.Health.hbg:SetAllPoints()
	self.Health.hbg:SetTexture( n.texture)

	if unit == "player" or unit == "target" or unit == "pet" then
		self.Health.AbsorbBar = self:addAbsorbBar()
		self.Health.healPred  = self:addHealPred()
		self.Health.Override  = self.updateHealth
	end
	if unit == "player" then
		--self.Health.stoper = self.Health.AbsorbBar:CreateTexture(nil, "OVERLAY")
		--self.Health.stoper:SetSize( 3, self:GetHeight() +5)
		--self.Health.stoper:SetTexture(texture)
		--self.Health.stoper:SetVertexColor(0, 1, 0, 1)

		self.Health.stoper = CreateFrame("StatusBar", nil, self)

		if yo.UF.rightAbsorb then
			self.Health.stoper:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
		else
			self.Health.stoper:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
		end

		self.Health.stoper:SetStatusBarTexture( n.texture)
		self.Health.stoper:SetFrameLevel( 5)
		self.Health.stoper:SetWidth( 1)
		self.Health.stoper:SetHeight( 4)
		tinsert( n.statusBars, self.Health.stoper)
		CreateStyle( self.Health.stoper, 2, 4, .3, .9)

		--self.Health.stoper.bg = self.Health.stoper:CreateTexture(nil, 'BORDER')
		--self.Health.stoper.bg:SetAllPoints( self.Health.stoper)
		--self.Health.stoper.bg:SetVertexColor( 0.4, 0.4, 0.4, 0.5)
		--self.Health.stoper.bg:SetAlpha(0.2)
		--self.Health.stoper.bg:SetTexture( n.texture)
	end

	self.fader 						= yo.Raid.fadeColor
	self.darkAbsorb  				= yo.Raid.darkAbsorb
	self.Health.colorThreat 		= true
	self.Health.colorTapping 		= true
	self.Health.colorSelection 		= true
	self.Health.colorDisconnected 	= true
	self.Health.frequentUpdates 	= true
	self.Health.UpdateColor 		= self.updateHealthColor

------------------------------------------------------------------------------------------------------
---											POWER BAR
------------------------------------------------------------------------------------------------------

	if enablePower then
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint( unpack( powerPos))
		self.Power:SetStatusBarTexture( n.texture)
		self.Power:SetFrameLevel( 5)
		self.Power:SetWidth( width - 10)
		self.Power:SetHeight( powerHeight)
		tinsert( n.statusBars, self.Power)

		self.Power.bg = self.Power:CreateTexture(nil, 'BORDER')
		self.Power.bg:SetAllPoints( self.Power)
		self.Power.bg:SetVertexColor( 0.4, 0.4, 0.4, 0.5)
		self.Power.bg:SetAlpha(0.2)
		self.Power.bg:SetTexture( n.texture)

		if unit == "player" then
			local powerFlashBar = CreateFrame("StatusBar" , nil, self)
			powerFlashBar:SetPoint("TOPLEFT", self.Power:GetStatusBarTexture(),"TOPRIGHT", 0, 0);
			powerFlashBar:SetPoint("BOTTOMLEFT", self.Power:GetStatusBarTexture(),"BOTTOMRIGHT", 0, 0);
			powerFlashBar:SetStatusBarTexture( n.texture)
			powerFlashBar:SetHeight( 4)
			powerFlashBar:SetWidth( self.Power:GetWidth())
			powerFlashBar:SetFrameLevel( 4)
			powerFlashBar:SetMinMaxValues(0, 0)
			powerFlashBar:SetValue( 0)
			self.Power.powerFlashBar = powerFlashBar
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", self.updateManaCost)
			tinsert( n.statusBars, self.Power.powerFlashBar)

		elseif unit == "targettarget" then
			self.Power.pDebuff = CreateFrame("Frame", nil, self)
			self.Power.pDebuff:SetPoint("TOPLEFT", self, "BOTTOMLEFT",  0, -5)
			self.Power.pDebuff:SetWidth( 16) -- self:GetWidth())
			self.Power.pDebuff:SetHeight( 16)
			self.Power.pDebuff.direction 	= "RIGHT"
			self.Power.pDebuff.unit 		= "targettarget"
			self.Power.pDebuff.count 		= self:GetWidth() / self.Power.pDebuff:GetHeight()
			self.Power.tickTOT 				= GetTime()
		end

		self.Power.frequentUpdates = true
    	self.Power.UpdateColor = n.dummy
    	self.Power.PostUpdate = self.updatePower
    	CreateStyle( self.Power, 2, 4, .3, .9)
    end

------------------------------------------------------------------------------------------------------
---											TEXTS
------------------------------------------------------------------------------------------------------
	self.Overlay = CreateFrame( 'Frame', nil, self)
	self.Overlay:SetAllPoints( self)
	self.Overlay:SetFrameLevel( 10)

	self.nameText =  self.Overlay:CreateFontString(nil ,"OVERLAY")
	self.nameText:SetFont( n.font, nameTextSize, "OUTLINE")
	self.nameText:SetPoint(unpack( namePos))
	if unit == "targettarget" or unit == "focustarget" or unit == "focus" or unit == "pet" then
			self:Tag( self.nameText, "[GetNameColor][unitLevel][nameshort][afk]")
	else	self:Tag( self.nameText, "[GetNameColor][unitLevel][".. nameLeight .."][afk]")end
	tinsert( n.strings, self.nameText)

	if unit ~= "pet" or unit ~= "targettarget" or unit ~= "focus" or unit ~= "focustarget" then

		self.Health.healthText =  self.Overlay:CreateFontString(nil ,"OVERLAY", 8)
		self.Health.healthText:SetFont( n.font, n.fontsize -1, "OUTLINE")
		self.Health.healthText:SetPoint( unpack( healthTextPos))
		tinsert( n.strings, self.Health.healthText)

		if enablePower and enablePowerText then
			self.Power.powerText =  self.Overlay:CreateFontString(nil ,"OVERLAY")
			self.Power.powerText:SetFont( n.font, n.fontsize -1, "OUTLINE")
			self.Power.powerText:SetPoint("TOPRIGHT", self.Health.healthText, "BOTTOMRIGHT", 0, -3)
			tinsert( n.strings, self.Power.powerText)
		end
		if showLeader then
			self.rText =  self:CreateFontString(nil ,"OVERLAY")
			self.rText:SetFont( yo.Media.fontpx, n.fontsize, "OUTLINE")
			self.rText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, -2)
			self:Tag( self.rText, "[GetNameColor][group]")
		end
	end

------------------------------------------------------------------------------------------------------
---											ICONS
------------------------------------------------------------------------------------------------------

	self.RaidTargetIndicator = self:CreateTexture(nil,'OVERLAY')
    self.RaidTargetIndicator:SetPoint( unpack( rtargetPos))
	self.RaidTargetIndicator:SetTexture("Interface\\AddOns\\yoFrame\\Media\\raidicons")
    self.RaidTargetIndicator:SetSize(18, 18)

    if cunit ~= "boss" or unit ~= "focustarget" then

    	if showLeader then
    		self.LeaderIndicator = CreateFrame("Button", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    		self.LeaderIndicator:SetPoint("CENTER", self, "TOPLEFT", 15, 2)
			self.LeaderIndicator:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-LeaderIcon", })
    		self.LeaderIndicator:SetSize(10, 10)

			self.AssistantIndicator = CreateFrame("Button", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    		self.AssistantIndicator:SetPoint("CENTER", self.LeaderIndicator, "CENTER", 0, 0)
			self.AssistantIndicator:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-AssistantIcon"})
    		self.AssistantIndicator:SetSize(10, 10)
    	end

    	self.ResurrectIndicator = self:CreateTexture(nil, 'OVERLAY')
    	self.ResurrectIndicator:SetSize( 20, 20)
    	self.ResurrectIndicator:SetPoint('CENTER', self, "CENTER", 0, 0)

    	self.SummonIndicator = self:CreateTexture(nil, 'OVERLAY')
    	self.SummonIndicator:SetSize(32, 32)
    	self.SummonIndicator:SetPoint('CENTER', self)
    end

	if unit == "player" or unit == "target" then
		self.PvPIndicator = self:CreateTexture(nil,'OVERLAY')
		self.PvPIndicator:SetPoint("CENTER", self, "CENTER", 0, -1)
		self.PvPIndicator:SetSize( 20, 20)
		self.PvPIndicator:SetAlpha( 0.7)
		self.PvPIndicator:SetDesaturated(true)

		self.PhaseIndicator = CreateFrame('Frame', nil, self)
    	self.PhaseIndicator:SetSize( 28, 28)
    	self.PhaseIndicator:SetPoint('CENTER', self)
    	self.PhaseIndicator:EnableMouse(true)
    	self.PhaseIndicator.Icon = self.PhaseIndicator:CreateTexture(nil, 'OVERLAY')
    	self.PhaseIndicator.Icon:SetAllPoints()

    	self.ReadyCheckIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
    	self.ReadyCheckIndicator:SetSize( 17, 17)
    	self.ReadyCheckIndicator:SetPoint('LEFT', self.Overlay, "CENTER", 40, 5)
    	self.ReadyCheckIndicator.finishedTime = 5
    	--	oUF ReadyCheckIndicator.lua at 123: if(element and (unit == 'party' or unit == 'raid' or unit == 'player' or unit == 'target')) then
	end

	if unit == "player" then
		self.RestingIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.RestingIndicator:SetSize( 17, 17)
		self.RestingIndicator:SetPoint( "CENTER", self, "LEFT", 0, 6)
		self.RestingIndicator:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.RestingIndicator:SetTexCoord(0, .5, 0, .421875)

		self.CombatIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.CombatIndicator:SetSize( 15, 15)
		self.CombatIndicator:SetPoint( "CENTER", self, "LEFT", 0, combatPos)
		self.CombatIndicator:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.CombatIndicator:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		self.CombatIndicator.PostUpdate = function( f, inCombat)
			if inCombat then self.RestingIndicator:Hide() elseif not inCombat and IsResting() then	self.RestingIndicator:Show()end end

		if yo.UF.showGCD then
			self.GCD = CreateFrame("StatusBar", nil, self)
			self.GCD:SetPoint("LEFT", self, "TOPLEFT", 0, 0)
			self.GCD:SetWidth( width)
			self.GCD:SetHeight( 2)
			self.GCD:SetFrameLevel( 5)
			self.GCD:SetStatusBarTexture( n.texture)
			self.GCD:SetStatusBarColor( 1, 1, 1, 0)
		end
		if n.pType[n.myClass] and n.pType[n.myClass].powerID then n.createShardsBar( self) end

	elseif unit == "target" and yo.healBotka.enable then
		--n.makeQuiButton(self)

	elseif cunit == "boss" then
		self.tarBorder = self:CreateFontString(nil ,"OVERLAY", 'GameFontNormal')
		self:Tag( self.tarBorder, '[bossTarget]')
	end

------------------------------------------------------------------------------------------------------
---											BEFORE END
------------------------------------------------------------------------------------------------------
	if yo.UF.debuffHight then self.addDebuffHigh( self) end

	--makeCastBar( self)

	--self:HookScript("OnShow", UpdateAllElements)
	self:UpdateTags()
	self:SetAlpha(1)
	self:SetFrameStrata("BACKGROUND")
	self:RegisterForClicks("AnyDown")

	if yo.healBotka.enable and unit == "target" then
		self:addQliqueButton()
		self:HookScript("OnEnter", self.frameOnEnter)
		self:HookScript("OnLeave", self.frameOnLeave)
	else
		self:SetScript("OnEnter", self.frameOnEnter)
		self:SetScript("OnLeave", self.frameOnLeave)
	end

	CreateStyle( self, 4)
	--self.updateAllElements( self)
end

------------------------------------------------------------------------------------------------------
---											END
------------------------------------------------------------------------------------------------------


local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if yo.UF.unitFrames then
		oUF:RegisterStyle("yoFrames", unitShared)
		oUF:SetActiveStyle("yoFrames")

		yoUF.player = oUF:Spawn("player", "yo_Player")
		if yo.UF.simpleUF then 	yoUF.player:SetPoint( "TOPRIGHT", n.moveFrames.yoMoveplayer, "TOPRIGHT", 15, 40)
		else 					yoUF.player:SetPoint( "CENTER", n.moveFrames.yoMoveplayer, "CENTER", 0 , 0)
		end

		yoUF.target = oUF:Spawn("target", "yo_Target")

		if yo.UF.simpleUF then 	yoUF.target:SetPoint( "TOPLEFT", n.moveFrames.yoMovetarget, "TOPLEFT", -15, 40)
		else					yoUF.target:SetPoint( "CENTER", n.moveFrames.yoMovetarget, "CENTER", 0 , 0)
		end

		yoUF.targetTarget = oUF:Spawn("targettarget", "yo_ToT")
		yoUF.targetTarget:SetPoint( "TOPLEFT", yoUF.target, "TOPRIGHT", 8 , 0)

		yoUF.focus = oUF:Spawn("focus", "yo_Focus")
		yoUF.focus:SetPoint( "CENTER", n.moveFrames.yoMovefocus, "CENTER", 0 , 0)

		yoUF.focusTarget = oUF:Spawn("focustarget", "yo_FocusTarget")
		yoUF.focusTarget:SetPoint( "TOPLEFT", yoUF.focus, "TOPRIGHT", 7 , 0)

		yoUF.pet = oUF:Spawn("pet", "yo_Pet")
		yoUF.pet:SetPoint( "TOPRIGHT", yoUF.player, "TOPLEFT", -8 , 0)

		--local boses = {}
		for i = 1, MAX_BOSS_FRAMES do
			--boses[i] = "boss"..i.."Frame"
			yoUF["boss" .. i] = oUF:Spawn( "boss" .. i, "yo_Boss" .. i)
			yoUF["boss" .. i]:SetPoint( "CENTER", n.moveFrames.yoMoveboss, "CENTER", 0 , -(i -1) * 65)
			--yoUF["boss" .. i] = boses[i]

			updateAllElements( yoUF["boss" .. i])
		end

		updateAllElements( yoUF.player)
		updateAllElements( yoUF.target)
		updateAllElements( yoUF.pet)
		--UpdateAllElements( focus)
	end
end)


--local healthColorMode = "CLASS"
--health.colorClass = healthColorMode == "CLASS"
--health.colorReaction = healthColorMode == "CLASS"
--health.colorSmooth = healthColorMode == "HEALTH"

