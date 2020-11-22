local _, ns = ...
local oUF 	= ns.oUF or oUF
--local colors = oUF.colors
local cols 	= {}

local L, yo, N = ns[1], ns[2], ns[3]

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local CreateFrame, CreateStyle, InCombatLockdown, IsAddOnLoaded, tostring, texture, CreateStyleSmall, type, print, tinsert, UnitClass, texglow, GetColors
	= CreateFrame, CreateStyle, InCombatLockdown, IsAddOnLoaded, tostring, texture, CreateStyleSmall, type, print, tinsert, UnitClass, texglow, GetColors

local UnitSpecific = {
	player = function(self)
		-- Player specific layout code.
	end,

    party = function(self)
		-- Party specific layout code.
    end,
}

local PostIconUpdate = function( self, button)
	if not button.shadow then
		button.icon:SetTexCoord( unpack( yo.tCoord))
		CreateStyle( button, 4)
	end
end

local funcWhiteList = function( self, button, ...)
	local spellID = select( 11, ...)
	if not N.blackSpells[spellID] then
		return true
	else
		return false
	end
end

local funcTankList = function( self, button, ...)
	local spellID = select( 11, ...)

	if N.tankDefs[spellID] then
		return true
	else
		return false
	end
end

local funcBlackList = function( self, button, ...)
	local spellID = select( 11, ...)
	if N.RaidDebuffList[spellID] then
		return true
	else
		return false
	end
end

function N.updateAllRaid(...)
	for ind, button in pairs( yo_Raid) do
		--print(ind, button)
		if type(button) == "table" then
			if button.updateOptions then
				button:updateOptions( button)
				button:updateAllElements( button)
			end
		end
		--print(k,v, v.updateOptions)
	end
end

--qwert = function(self, ...)
--	print("...")
--end
-------------------------------------------------------------------------------------------------------
--											SHARED
-------------------------------------------------------------------------------------------------------
local function raidShared(self, unit)

	local fontsymbol 	= "Interface\\AddOns\\yoFrame\\Media\\symbol.ttf"
	local texhl 		= "Interface\\AddOns\\yoFrame\\Media\\raidbg"

	local unit   = 	( self:GetParent():GetName():match( "yo_Part")) and "party" or
					( self:GetParent():GetName():match( "yo_Raid")) and "raid" or
					( self:GetParent():GetName():match( "yo_Tank")) and "tank" or unit

	self.unitT  = 	self:GetAttribute("unitsuffix") == "target" and true
	self.unitTT = 	self:GetAttribute("unitsuffix") == "targettarget" and true
	self.updateOptions = raidShared

	GetColors( self)
	importAPI( self)

	self:RegisterForClicks("AnyUp")
	--self.qwert = qwert

	CreateStyleSmall(self, 1)

	local posInfo		= {"LEFT", self, "LEFT", 2, 2}
	local posDead 		= {"TOPRIGHT", self, "TOPRIGHT", -2, -1}
	local posLFD 		= {"RIGHT", self, "RIGHT", -1, -1}
	local posAuras		= {'LEFT', self, 'RIGHT', 12, 0}
	local posRCheck		= {'RIGHT', self, 'RIGHT', -15, 0}
	local posAuraTank	= { "LEFT", self, "LEFT", 5, 0}
	local sizeInfoFont 	= yo.fontsize
	local sizeLFDFont 	= yo.fontsize - 1
	local sizeDeadFont 	= yo.fontsize - 1
	local sizeRTarget	= 16
	local sizeResurrect	= 25
	local enablePower	= true
	local enableBorder	= true
	local enableAuras	= yo.Raid.aurasParty
	local enableDeHight = yo.Raid.debuffHight
	local enableHealPr	= yo.Raid.healPrediction
	local enableAbsorb	= false
	local enableLFD		= yo.Raid.showLFD
	local enableIcons 	= true
	local sizeAuras 	= self:GetHeight() * 0.95
	local spacingAuras 	= 6
	local numAuras 		= 10
	local initialAnchor = "LEFT"
	local growthX 		= "RIGHT"
	local CustomFilter 	= funcWhiteList
	local outsideAlpha	= 0.5
	local frameWidth 	= yo.Raid.width
	local frameHeight	= yo.Raid.height
	local growAuraTank  = "RIGHT"
	local anchTankAura 	= "CENTER"

	if yo.Raid.raidTemplate == 2 then
		posInfo			= {"LEFT", self, "RIGHT", 12, 0}
		posDead 		= {"RIGHT", self, "RIGHT", -8, 1}
		posLFD			= {"RIGHT", self, "RIGHT", -1, 0}
		posRCheck		= {'RIGHT', self, 'RIGHT', -25, 0}
		sizeInfoFont 	= yo.fontsize + 2
		sizeLFDFont 	= yo.fontsize - 3
		sizeRTarget		= 12
		sizeResurrect	= 16
		enablePower		= false
		enableAuras 	= false

	elseif yo.Raid.raidTemplate == 3 then
		posInfo			= {"CENTER", self, "CENTER", 0, 3}
		posAuras		= {'TOPRIGHT', self, 'TOPRIGHT', -1, -3}
		posAuraTank		= {"CENTER", self, "CENTER"}
		posDead 		= {"TOP", self, "CENTER", 0, -5}
		enablePower		= false
		enableHealPr	= false
		enableAbsorb	= false
		enableLFD		= false
		enableAuras		= true
		sizeAuras 		= 12
		spacingAuras 	= 1
	 	numAuras 		= 3
		initialAnchor 	= "TOPRIGHT"
		growthX 		= "LEFT"
		growAuraTank 	= "LEFT"
		--CustomFilter 	= funcWhiteList --funcBlackList
		CustomFilter 	= nil
		outsideAlpha	= 0.2
		frameWidth		= 90
		frameHeight		= 40
		CreateStyleSmall( self.shadow, 2)
		self.overShadow = self.shadow.shadow
		self.overShadow:Hide()
		self.overShadow:SetBackdropBorderColor(1, 0, 0, 1)
		anchTankAura 	= "CENTER"
	end

	if unit == "raid" then
		spacingAuras	= 2
		numAuras		= 2
		--sizeAuras		= 20
		posAuras 		= {'TOPRIGHT', self, 'TOPRIGHT', -2, -2}
		initialAnchor 	= "RIGHT"
		growthX 		= 'LEFT'
		CustomFilter	= funcBlackList

	elseif unit == "tank" then
		posInfo			= {"TOPLEFT", self, "TOPLEFT", 2, -1}
		enableDeHight 	= true
		enableBorder 	= true
		enableHealPr	= yo.Raid.healPrediction
		enableAuras 	= true
		enablePower		= false
		enableAbsorb	= true
		numAuras		= 3
		spacingAuras	= 3
		sizeInfoFont	= yo.fontsize
		initialAnchor 	= "RIGHT"
		growthX 		= 'LEFT'
		sizeAuras 		= self:GetHeight() * 0.7
		posAuras		= {'TOPRIGHT', self, 'TOPRIGHT', -2, -2}
		CustomFilter	= funcBlackList --funcWhiteList
		frameHeight 	= yo.Raid.heightMT
		frameWidth 		= yo.Raid.widthMT
		posAuraTank		= { "LEFT", self, "LEFT", 3, -5}
		growAuraTank  	= "RIGHT"
		anchTankAura 	= "LEFT"

		if self.unitT then
			enableBorder 	= true
			enableHealPr	= false
			enableAuras 	= false
			enableAbsorb	= false
			enableDeHight 	= false
			enableIcons 	= false
			enablePower		= false
			sizeInfoFont	= yo.fontsize - 1
			sizeDeadFont 	= yo.fontsize - 1
		end
		if self.unitTT then
			enableDeHight 	= false
			enableHealPr	= false
			enableAuras 	= false
			enableAbsorb	= false
			enableBorder 	= false
			enableIcons 	= false
			enablePower		= false
			sizeInfoFont	= yo.fontsize - 1
			sizeDeadFont 	= yo.fontsize - 1
		end
	end

	--self:SetWidth( frameWidth)
	--self:SetHeight( frameHeight)

	--print(unit, self:GetParent():GetName(), self.unit)
	------------------------------------------------------------------------------------------------------
	---											HEALTH BAR
	------------------------------------------------------------------------------------------------------
	self.Health = self.Health or CreateFrame("StatusBar", nil, self)
	self.Health:SetAllPoints( self)
	self.Health:SetWidth( self:GetWidth())
	self.Health:SetFrameLevel(1)
	self.Health:SetStatusBarTexture( texture)
	tinsert( N.statusBars, self.Health)

	self.Health.hbg = self.Health.hbg or self.Health:CreateTexture(nil, "BACKGROUND")		-- look 	AssistantIndicator.PostUpdate
	self.Health.hbg:SetAllPoints()
	self.Health.hbg:SetTexture( texture)

	if yo.Raid.hpBarRevers 	 then self.Health:SetFillStyle( 'REVERSE'); end
	if yo.Raid.hpBarVertical then self.Health:SetOrientation( 'VERTICAL') 	end
	if enableHealPr 		 then self.Health.healPred  = self:addHealPred( self) end --self.Health.healPred or
	if enableAbsorb		 	 then self.Health.AbsorbBar = self:addAbsorbBar( self) end --self.Health.AbsorbBar or

	if yo.Raid.classcolor == 1 then
		self.shadowAlpha = 0.5
		outsideAlpha = 0.3

	elseif yo.Raid.classcolor == 2 then
		--self.Health.colorSmooth = true
		self.shadowAlpha = 0.5
		outsideAlpha = 0.3

	else
		--self.colors.disconnected = { 0.4, 0.4, 0.4}
		self.shadowAlpha = 0.2
	end

	if yo.Raid.raidTemplate == 2 and yo.Raid.classcolor ~= 3 then
		self.Health.bg = self.Health.hbg
		self.Health.bg.multiplier = .5
	end

	if unit ~= "tank" then
		self.Range = { insideAlpha = 1, outsideAlpha = outsideAlpha, }
		self.Range.PostUpdate = function(object, self, inRange, checkedRange, connected)
			if connected then
				if checkedRange and not inRange then
		--			self.Health.hbg:SetAlpha( self.Range.outsideAlpha) --.Health.hbg:SetAlpha(0)
					self.shadow:SetBackdropColor( .075,.075,.086, self.shadowAlpha) --:SetAlpha( self.shadowAlpha)
				else
		--			self.Health.hbg:SetAlpha( self.Range.insideAlpha) --.Health.hbg:SetAlpha(0)
					self.shadow:SetBackdropColor( .075,.075,.086, 0.9)
		--			--self.shadow:SetAlpha(0.9) --( self.Range.insideAlpha)
				end
			else
		--		self.Health.hbg:SetAlpha( self.Range.insideAlpha) --.Health.hbg:SetAlpha(1)
				self.shadow:SetBackdropColor( .075,.075,.086, 0.9)
		--		--self.shadow:SetAlpha(0.9) --( self.Range.insideAlpha)
			end
		end
	end

	self.fader 						= yo.Raid.fadeColor
	self.darkAbsorb					= yo.Raid.darkAbsorb
	self.colors.disconnected 		= { 0.3, 0.3, 0.3}

	self.Health.colorThreat 		= true
	self.Health.colorTapping 		= true
	self.Health.colorSelection 		= true
	self.Health.colorDisconnected 	= true
	self.Health.frequentUpdates 	= false
	self.Health.Override 			= self.updateHealth
	self.Health.UpdateColor 		= self.updateHealthColor

	------------------------------------------------------------------------------------------------------
	---											POWER BAR
	------------------------------------------------------------------------------------------------------

	if enablePower then
		self.Power = self.Power or CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint("BOTTOM", self, "BOTTOM", 0, 4)
		self.Power:SetStatusBarTexture( texture)
		self.Power:SetFrameStrata( "MEDIUM")
		self.Power:SetWidth( self:GetWidth() - 6)
		self.Power:SetHeight( 2)
		tinsert( N.statusBars, self.Power)

		self.Power:SetFrameLevel(10)
		self.Power.frequentUpdates = false
		self.Power.colorDisconnected = true
		if yo.Raid.manacolorClass then
			self.Power.colorClass = true
		else
			self.Power.colorPower = true
		end
		self.Power:Hide()

		self.Power.bg = self.Power.bg or self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture( texture)
		self.Power.bg:SetAlpha(1)
		self.Power.bg.multiplier = 0.2
		CreateStyle( self.Power, 1)

		self.Power.UpdateColor = self.updatePowerBar
	end

	------------------------------------------------------------------------------------------------------
	----										OVERLAY
	------------------------------------------------------------------------------------------------------
	self.Overlay = self.Overlay or CreateFrame( 'Frame', nil, self)
	self.Overlay:SetAllPoints( self)
	self.Overlay:SetFrameLevel( 100)

	self.Info = self.Info or self.Overlay:CreateFontString( nil, "OVERLAY")
	self.Info:SetPoint( unpack( posInfo))
	self.Info:SetFont( yo.font, sizeInfoFont, "OUTLINE")
	--self.Info:SetShadowOffset( 1, -1)
	--self.Info:SetShadowColor( 0, 0, 0, 1)
	tinsert( N.strings, self.Info)

	if unit == "tank" then
		self:Tag( self.Info, "[GetNameColor][nameshort]")

		if yo.Raid.showValueTreat and ( not self.unitTT or self.unitT) then
			self.threat = self.threat or self.Overlay:CreateFontString(nil, "OVERLAY")
			self.threat:SetFont( yo.fontpx, yo.fontsize +1)--, "THINOUTLINE")
			self.threat:SetShadowOffset( 1, -1)
			self.threat:SetPoint("BOTTOMLEFT", self.Overlay, "BOTTOMLEFT", 3, 2)
			tinsert( N.strings, self.threat)
		end
	elseif  yo.Raid.raidTemplate == 3 then
		 self:Tag( self.Info, "[GetNameColor][namemedium]\n[afk]")
	else
		 self:Tag( self.Info, "[GetNameColor][namemedium][afk]")
	end

	self.RaidTargetIndicator = self.RaidTargetIndicator or self.Overlay:CreateTexture(nil, 'OVERLAY')
    self.RaidTargetIndicator:SetSize( sizeRTarget, sizeRTarget)
    self.RaidTargetIndicator:SetPoint('CENTER', self, 'TOP', 0, 0)
    self.RaidTargetIndicator:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidicons")

    self.PhaseIndicator = CreateFrame('Frame', nil, self)
    self.PhaseIndicator:SetSize( 28, 28)
    self.PhaseIndicator:SetPoint('CENTER', self)
    self.PhaseIndicator:EnableMouse(true)
    self.PhaseIndicator.Icon = self.PhaseIndicator:CreateTexture(nil, 'OVERLAY')
    self.PhaseIndicator.Icon:SetAllPoints()

    if enableIcons then
    	self.ResurrectIndicator = self.ResurrectIndicator or self.Overlay:CreateTexture(nil, 'OVERLAY')
    	self.ResurrectIndicator:SetSize( sizeResurrect, sizeResurrect)
    	self.ResurrectIndicator:SetPoint('CENTER', self, 'CENTER', 0, 0)

    	self.LeaderIndicator = self.LeaderIndicator or self.Overlay:CreateTexture(nil, 'OVERLAY')
   		self.LeaderIndicator:SetSize(10, 10)
   		self.LeaderIndicator:SetPoint('LEFT', self, 'TOPLEFT', 15, 0)

		self.AssistantIndicator = self.AssistantIndicator or self.Overlay:CreateTexture(nil, 'OVERLAY')
   		self.AssistantIndicator:SetSize(10, 10)
   		self.AssistantIndicator:SetPoint('LEFT', self.rText, 'RIGHT', 0, 0)
   		self.AssistantIndicator.PostUpdate = function(self)											-- BACK COLORING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			if yo.Raid.classBackground == true and yo.Raid.classcolor == 3 then
				local parent = self:GetParent():GetParent()
				local t = self.__owner.colors.class[select( 2, UnitClass( parent.unit))]
				if t then
					parent.Health.hbg:SetVertexColor( t[1], t[2], t[3], 0.9)
				end
			end
   		end

   		self.ReadyCheckIndicator = self.ReadyCheckIndicator or self.Overlay:CreateTexture(nil, 'BORDER')
   		self.ReadyCheckIndicator:SetSize(17, 17)
   		self.ReadyCheckIndicator:SetPoint( unpack( posRCheck))
		self.ReadyCheckIndicator.finishedTime = 5
	end

	self.DeadText = self.DeadText or self.Overlay:CreateFontString(nil ,"OVERLAY")
	self.DeadText:SetFont( yo.font, sizeDeadFont -3)
	self.DeadText:SetPoint( unpack( posDead))
	self.DeadText:SetShadowOffset( 1, -1)
	self.DeadText:SetShadowColor( 0, 0, 0, 1)
	tinsert( N.strings, self.DeadText)
	self:Tag( self.DeadText, "[GetNameColor]".. yo.Raid.showHPValue)

	if unit == "raid" and yo.Raid.showGroupNum and ( not self.unitTT or self.unitT) then
		self.rText = self.rText or self.Overlay:CreateFontString(nil ,"OVERLAY")
		self.rText:SetFont( yo.fontpx, yo.fontsize, "OUTLINE")
		self.rText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, -4)
		tinsert( N.strings, self.rText)
		self:Tag(self.rText, "[GetNameColor][group]")
	end

	if enableLFD and unit ~= "tank" then
		self.lfd = self.lfd or self.Overlay:CreateFontString(nil ,"OVERLAY")
		self.lfd:SetFont( fontsymbol, sizeLFDFont)
		self.lfd:SetPoint( unpack( posLFD))
		self.lfd:SetJustifyH"LEFT"
		self:Tag( self.lfd, '[LFD]')
	end

	------------------------------------------------------------------------------------------------------
	---											AURAS
	------------------------------------------------------------------------------------------------------
	if enableAuras then
		self.Debuffs = self.Debuffs or CreateFrame('Frame', nil, self)
		self.Debuffs:ClearAllPoints()
		self.Debuffs:SetPoint( unpack( posAuras))
		self.Debuffs:SetFrameLevel( 100)
		self.Debuffs:SetSize( sizeAuras * ( numAuras +1), sizeAuras)
		self.Debuffs.disableCooldown = false
		self.Debuffs.spacing 		= 1 --spacingAuras
		self.Debuffs.num 			= numAuras
		self.Debuffs.disableMouse 	= false
		self.Debuffs.size   		= sizeAuras
		self.Debuffs.initialAnchor 	= initialAnchor
		self.Debuffs['growth-x'] 	= growthX
		self.Debuffs.CustomFilter 	= CustomFilter

		self.Debuffs.PostCreateIcon = function( self, button)
			button.icon:SetTexCoord( unpack( yo.tCoord))
			button.cd:SetDrawEdge( false)
			button.cd:SetDrawSwipe( false)
			--CreateStyleSmall( button, 1)
		end
	end

	if yo.Raid.raidTemplate == 3 or unit == "tank" then
		self.Buffs = self.Buffs or CreateFrame('Frame', nil, self)
		self.Buffs:SetPoint( unpack( posAuraTank))
		self.Buffs:SetFrameLevel( 100)
		self.Buffs:SetSize( 20 * 3, 20)
		self.Buffs.disableCooldown 	= false
		self.Buffs.spacing 			= 3
		self.Buffs.num 				= 2
		self.Buffs.disableMouse 	= true
		self.Buffs.size   			= 16
		self.Buffs.initialAnchor 	= anchTankAura
		self.Buffs['growth-x'] 		= growAuraTank
		self.Buffs.CustomFilter 	= funcTankList

		self.Buffs.tankOverlay = self:CreateTexture(nil, "OVERLAY")
		self.Buffs.tankOverlay:SetAllPoints(self)
		self.Buffs.tankOverlay:SetTexture("Interface\\AddOns\\yoFrame\\Media\\aggro")
		self.Buffs.tankOverlay:SetVertexColor(1, 1, 0.3, 1)
		self.Buffs.tankOverlay:SetBlendMode("ADD")
		self.Buffs.tankOverlay:SetAlpha(0)

		SetUpAnimGroup( self.Buffs.tankOverlay, "FlashLoop", 1, 0)
   		self.Buffs.tankOverlay.anim.fadein:SetDuration( 0.4)
   		self.Buffs.tankOverlay.anim.fadeout:SetDuration( 1)

		self.Buffs.PostCreateIcon = function( self, button)
			button.icon:SetTexCoord( unpack( yo.tCoord))
			--button.icon:ClearAllPoints()
			button.cd.timerPos 	= { 'CENTER', button.cd, 'BOTTOM', 0, 2}
			--button.cd.timerPos1 	= { 'RIGHT', button.cd, 'BOTTOMRIGHT', 0, 2}
			--button.cd.timerPos2 	= { 'RIGHT', button.cd, 'BOTTOMRIGHT', 10, 2}
			button.cd:SetDrawEdge( false)
			button.cd:SetDrawSwipe( false)

			button:SetScript("OnShow", function(self, ...) button:GetParent().tankOverlay.anim:Play() end)
			button:SetScript("OnHide", function(self, ...)
				if not button:GetParent()[1]:IsShown() then
					button:GetParent().tankOverlay.anim:Stop()
				end
			end)
			--CreateStyleSmall( button, 2)
		end
	end

   	if enableBorder then
		tinsert(self.__elements, self.onChangeTarget)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', self.onChangeTarget, true)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", self.onChangeTarget)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", self.onChangeTarget)
	end

	------------------------------------------------------------------------------------------------------
	---										Debuff highlight
	------------------------------------------------------------------------------------------------------
	if enableDeHight then self.addDebuffHigh( self) end


	if yo.healBotka.hEnable and unit ~= "tank" then self:addBuffHost()	end

	if yo.healBotka.enable  then
		self:addQliqueButton()
		self:HookScript("OnEnter", self.frameOnEnter)
		self:HookScript("OnLeave", self.frameOnLeave)
	else
		self:SetScript("OnEnter", self.frameOnEnter)
		self:SetScript("OnLeave", self.frameOnLeave)
	end

	if self.unitT or self.unitTT then
		self:SetSize( yo.Raid.widthMT * 0.75, yo.Raid.heightMT * 0.7)
		self:SetAttribute('*type1', 'target')
		self:SetAttribute('*type2', 'togglemenu')
	end

	if self.unitTT then
		self.tick = 1
		self:SetScript("OnUpdate", self.updateAllTarget)
	end
end





------------------------------------------------------------------------------------------------------
---										CREATE MOVIER
------------------------------------------------------------------------------------------------------
local function CreateTempStyle(f, size, level, alpha, alphaborder)
    if f.shadowMove then return end

	local style = {
		bgFile =  texture,
		edgeFile = texglow,
		edgeSize = 4,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
    local shadowMove = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate")
    shadowMove:SetFrameLevel(level or 0)
    shadowMove:SetFrameStrata(f:GetFrameStrata())
    shadowMove:SetPoint("TOPLEFT", -size, size)
    shadowMove:SetPoint("BOTTOMRIGHT", size, -size)
    shadowMove:SetBackdrop(style)
    shadowMove:SetBackdropColor(.08,.08,.08, alpha or .9)
    shadowMove:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
    f.shadowMove = shadowMove
    return shadowMove
end

local function CreateMovier(frame, f)
	--print( frame:GetWidth(), #f)

	local delta = 8
	CreateStyle( frame, delta, 0, 0, 0)
	CreateTempStyle( frame, delta, 0, .2, .9)

	local movePartyFrame = frame.shadow
	movePartyFrame:EnableMouse(true)
	movePartyFrame:SetMovable(true)
	movePartyFrame:RegisterForDrag("LeftButton", "RightButton")
	movePartyFrame:ClearAllPoints()
	movePartyFrame:SetPoint( yoMoveRaid:GetPoint())
	movePartyFrame:SetWidth( frame:GetWidth() + delta * 2)
	movePartyFrame:SetHeight( frame:GetHeight() + delta * 2)

	frame:SetPoint( "TOPLEFT", movePartyFrame, "TOPLEFT", delta, - delta)

	movePartyFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	movePartyFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		yoMoveRaid:ClearAllPoints()
		yoMoveRaid:SetPoint( self:GetPoint())
		SetAnchPosition( yoMoveRaid, self)
	end)

	movePartyFrame:SetScript("OnShow", function(self)
		if InCombatLockdown() then return end

		self:ClearAllPoints()
		self:SetPoint( yoMoveRaid:GetPoint())
	end)

	movePartyFrame:SetScript("OnHide", function(self)
		if InCombatLockdown() then return end

		yoMoveRaid:ClearAllPoints()
		yoMoveRaid:SetPoint( self:GetPoint())
	end)

	frame:SetScript("OnSizeChanged", function(self, w, h)
		if h < 10 then
			self.shadowMove:Hide()
		else
			self.shadowMove:Show()
		end

		if InCombatLockdown() then return end

		self.shadow:SetWidth( self:GetWidth() + delta * 2)
		self.shadow:SetHeight(self:GetHeight() + delta * 2)

		if h < 10 then
			self.shadow:Hide()
		else
			self.shadow:Show()
		end
	end)
end


------------------------------------------------------------------------------------------------------
---										MAKE RAID/PARTY FRAMES
------------------------------------------------------------------------------------------------------
--   groupheader:SetFrameRef("clickcast_header", addon.header)
CreateAnchor("yoMoveRaid", 		"Move Raid Party Frame", 520, 170, 10, -10, "TOPLEFT", "TOPLEFT")
CreateAnchor("yoMoveTanks", 		"Move Raid Tanks Frame", 200, 55, 5, 320, 	"TOPLEFT", "BOTTOMLEFT")

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if not yo.Raid.enable then return end

	if yo.Raid.noHealFrames and ( IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2") or IsAddOnLoaded("HealBot") or IsAddOnLoaded("VuhDo") or IsAddOnLoaded("oUF_Freebgrid")) then return end
	if yo.healBotka.enable then N.CreateClique( self) end

	local spaicing 		= ( yo.Raid.spaicing or 6)
	local unitsPerColumn= 5
	local unit_width 	= yo.Raid.raidTemplate == 3 and yo.healBotka.hTempW or yo.Raid.width
	local unit_height 	= yo.Raid.raidTemplate == 3 and yo.healBotka.hTempH or yo.Raid.height
	local partyScale 	= yo.Raid.raidTemplate == 3 and 1 					or yo.Raid.partyScale
	local point 		= yo.Raid.raidTemplate == 3 and "LEFT" 				or "TOP"
	local colAnchorPoint= yo.Raid.raidTemplate == 3 and "TOP" 				or "LEFT"

	if yo.Raid.raidTemplate == 2 then
		unit_width 	= unit_width * 1.2
		unit_height = 13
		spaicing	= 4
		unitsPerColumn = 40
	end

	InterfaceOptionsFrameCategoriesButton10:SetScale(0.00001)
	InterfaceOptionsFrameCategoriesButton10:SetAlpha(0)
	if not InCombatLockdown() then
		Kill(CompactRaidFrameManager)
		Kill(CompactRaidFrameContainer)
	end
	ShowPartyFrame = dummy
	HidePartyFrame = dummy
	CompactUnitFrameProfiles_ApplyProfile = dummy
	CompactRaidFrameManager_UpdateShown = dummy
	CompactRaidFrameManager_UpdateOptionsFlowContainer = dummy

	oUF:RegisterStyle("Raid", raidShared)
	oUF:Factory(function(self)
		self:SetActiveStyle("Raid")
		local groupBy, groupingOrder

		if yo.Raid.groupingOrder == "GROUP" then
			local raid = {}
			for i = 1, yo.Raid.numgroups do
				local raidgroup = self:SpawnHeader("yo_RaidGroup"..i, nil, "custom [@raid6,exists] show;hide",
					"oUF-initialConfigFunction", [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute("initial-width"))
						self:SetHeight(header:GetAttribute("initial-height"))
					]],
					"initial-width", unit_width,
					"initial-height", unit_height,
					--'sortMethod', 'NAME',
					"showRaid", true,
					"yOffset", -spaicing,
					"point", "TOPLEFT",
					"groupFilter", tostring(i),
					"maxColumns", 5,
					"unitsPerColumn", 1,
					"columnSpacing", spaicing,
					"columnAnchorPoint", "TOP"
				)
				if i == 1 then
					raidgroup:SetPoint("TOPLEFT", yoMoveRaid, "TOPLEFT", 0, 0)
				--elseif i == 5 then
				--	raidgroup:SetPoint("TOPLEFT", raid[1], "TOPRIGHT", 7, 0)
				else
					raidgroup:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", spaicing, 0)
				end
				raid[i] = raidgroup
			end
			CreateMovier( raid[1], raid, yo.Raid.numgroups, spaicing)

		else
			if yo.Raid.groupingOrder == "THD" then
				groupBy 	= 'ASSIGNEDROLE'
				groupingOrder = 'TANK,HEALER,DAMAGER,NONE'
			elseif yo.Raid.groupingOrder == "LGBT" then
				groupBy = 'CLASS'
				groupingOrder = 'DEATHKNIGHT,DRUID,ROGUE,HUNTER,MONK,MAGE,SHAMAN,WARLOCK,DEMONHUNTER,PALADIN,PRIEST,WARRIOR'
				--groupingOrder = 'DEMONHUNTER,DEATHKNIGHT,WARRIOR,ROGUE,MONK,PALADIN,DRUID,SHAMAN,HUNTER,PRIEST,MAGE,WARLOCK'
			elseif yo.Raid.groupingOrder == "TDH" then
				groupBy = 'ASSIGNEDROLE'
				groupingOrder = 'TANK,DAMAGER,HEALER,NONE'
			else
				groupBy = "GROUP"
				groupingOrder = "1,2,3,4,5,6,7,8"
			end

			local raid = self:SpawnHeader( 'yo_Raid', nil, "custom [@raid6,exists] show;hide", --'raid',
				"oUF-initialConfigFunction", [[
					local header = self:GetParent()
					self:SetWidth(header:GetAttribute("initial-width"))
					self:SetHeight(header:GetAttribute("initial-height"))
				]],

				"groupBy", groupBy,
				"groupingOrder", groupingOrder,
				"initial-width", unit_width,
				"initial-height", unit_height,
				'sortMethod', 'NAME',
				"showSolo", false,
				"showPlayer", true,
				"showRaid", true,
				"showParty", true,
				"xOffset", spaicing,
				"yOffset", -spaicing,			---6,
				"maxColumns", yo.Raid.numgroups,
				"unitsPerColumn", unitsPerColumn,
				"columnSpacing", spaicing,
				"point", point, --"LEFT", --"TOP",
				"columnAnchorPoint", colAnchorPoint --"TOP" -- "LEFT"
			)
			--raid:SetPoint("TOPLEFT", yoMoveRaid, "TOPLEFT", 0, 0)
			CreateMovier( yo_Raid)
		end


		local party = self:SpawnHeader( 'yo_Party', nil, "custom [@raid6,exists] hide;show", --'party,solo',
			"oUF-initialConfigFunction", [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute("initial-width"))
				self:SetHeight(header:GetAttribute("initial-height"))
			]],
			"initial-width", unit_width * partyScale, --yo.Raid.partyScale,
			"initial-height", unit_height * partyScale, --yo.Raid.partyScale,
			"showSolo", yo.Raid.showSolo,
			'sortMethod', 'NAME',
			"showPlayer", true,
			"showParty", true,
			"showRaid", true,
			"xOffset", spaicing * partyScale, --yo.Raid.partyScale,
			"groupBy", "ASSIGNEDROLE", --groupBy,
			"groupingOrder", 'TANK,HEALER,DAMAGER,NONE', --groupingOrder,
			"yOffset", -spaicing * partyScale,			---6,
			"unitsPerColumn", unitsPerColumn,
			"columnSpacing", yo.Raid.spaicing,
			"point", "TOP",
			"columnAnchorPoint", colAnchorPoint --"LEFT"
		)

		CreateMovier( yo_Party)

		if yo.Raid.showMT then --and not yo.Raid.simpeRaid then

			local heightMT = yo.Raid.heightMT
			local widthMT = yo.Raid.widthMT
			local offsetMT = -6
			local showParty = true
			local template = ""

			if yo.Raid.showMTT  then template = "oUF_MainTank" end
			if yo.Raid.showMTTT then template = "oUF_MainTankTT" end

			local mt = self:SpawnHeader( 'yo_Tankets', nil, 'raid,party',
    			'showRaid', true,
    			'showParty', showParty,
    			'showPlayer', showParty,
    			----'groupFilter', 'MAINTANK',
    			'roleFilter', 'TANK',
    			'yOffset', offsetMT,
    			'sortMethod', 'NAME',
    			'template', template,
    			'oUF-initialConfigFunction', ([[
            		self:SetWidth(%d)
            		self:SetHeight(%d)
            		self:SetScale(%d)
            	]]):format( widthMT, heightMT, 1)
			)
			mt:SetPoint("BOTTOMLEFT", yoMoveTanks, "BOTTOMLEFT", 0, 0)
		end
	end)
end)

--[[
List of the various configuration attributes
======================================================
showRaid = [BOOLEAN] -- true if the header should be shown while in a raid
showParty = [BOOLEAN] -- true if the header should be shown while in a party and not in a raid
showPlayer = [BOOLEAN] -- true if the header should show the player when not in a raid
showSolo = [BOOLEAN] -- true if the header should be shown while not in a group (implies showPlayer)
nameList = [STRING] -- a comma separated list of player names (not used if 'groupFilter' is set)
groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
roleFilter = [STRING] -- a comma seperated list of MT/MA/Tank/Healer/DPS role strings
strictFiltering = [BOOLEAN]
-- if true, then
---- if only groupFilter is specified then characters must match both a group and a class from the groupFilter list
---- if only roleFilter is specified then characters must match at least one of the specified roles
---- if both groupFilter and roleFilters are specified then characters must match a group and a class from the groupFilter list and a role from the roleFilter list
point = [STRING] -- a valid XML anchoring point (Default: "TOP")
xOffset = [NUMBER] -- the x-Offset to use when anchoring the unit buttons (Default: 0)
yOffset = [NUMBER] -- the y-Offset to use when anchoring the unit buttons (Default: 0)
sortMethod = ["INDEX", "NAME", "NAMELIST"] -- defines how the group is sorted (Default: "INDEX")
sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
template = [STRING] -- the XML template to use for the unit buttons
templateType = [STRING] - specifies the frame type of the managed subframes (Default: "Button")
groupBy = [nil, "GROUP", "CLASS", "ROLE", "ASSIGNEDROLE"] - specifies a "grouping" type to apply before regular sorting (Default: nil)
groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinite (Default: nil)
startingIndex = [NUMBER] - the index in the final sorted unit list at which to start displaying units (Default: 1)
columnSpacing = [NUMBER] - the amount of space between the rows/columns (Default: 0)
columnAnchorPoint = [STRING] - the anchor point of each new column (ie. use LEFT for the columns to grow to the right)

UF.headerGroupBy = {
	CLASS = function(header)
		header:SetAttribute('groupingOrder', 'DEATHKNIGHT,DEMONHUNTER,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR,MONK')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', 'CLASS')
	end,
	MTMA = function(header)
		header:SetAttribute('groupingOrder', 'MAINTANK,MAINASSIST,NONE')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', 'ROLE')
	end,
	ROLE = function(header)
		header:SetAttribute('groupingOrder', 'TANK,HEALER,DAMAGER,NONE')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', 'ASSIGNEDROLE')
	end,
	ROLE2 = function(header)
		header:SetAttribute('groupingOrder', 'TANK,DAMAGER,HEALER,NONE')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', 'ASSIGNEDROLE')
	end,
	NAME = function(header)
		header:SetAttribute('groupingOrder', '1,2,3,4,5,6,7,8')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', nil)
	end,
	GROUP = function(header)
		header:SetAttribute('groupingOrder', '1,2,3,4,5,6,7,8')
		header:SetAttribute('sortMethod', 'INDEX')
		header:SetAttribute('groupBy', 'GROUP')
	end,
	CLASSROLE = function(header)
		header:SetAttribute('groupingOrder', 'DEATHKNIGHT,WARRIOR,DEMONHUNTER,ROGUE,MONK,PALADIN,DRUID,SHAMAN,HUNTER,PRIEST,MAGE,WARLOCK')
		header:SetAttribute('sortMethod', 'NAME')
		header:SetAttribute('groupBy', 'CLASS')
	end,
	INDEX = function(header)
		header:SetAttribute('groupingOrder', '1,2,3,4,5,6,7,8')
		header:SetAttribute('sortMethod', 'INDEX')
		header:SetAttribute('groupBy', nil)
	end,
}
--]]
