local _, ns = ...
local oUF = ns.oUF or oUF

local L, yo, N = ns[1], ns[2], ns[3]

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

function testers(...)

end

local function CreateClique()
	Clique = CreateFrame("Frame", "yo_Clique", UIParent)
	local header = CreateFrame( "Frame", "yo_CliqueHeader", UIParent, "SecureHandlerBaseTemplate,SecureHandlerAttributeTemplate")
	Clique.header = header

	--local set, clr = nil, nil --self:GetBindingAttributes()
	local set, clr = {}, {}

	local B_SET = [[print( "onEnter", self:GetName());self:SetBindingClick(true, %q, self, %q);]]
	local B_CLR = [[print( "onLeaver");self:ClearBinding(%q);]]

	local attr = B_SET:format( "Q", "buttonQ")
	set[#set + 1] = attr
	clr[#clr + 1] = B_CLR:format( "Q")

	attr = B_SET:format( "A", "buttonA")
	set[#set + 1] = attr
	clr[#clr + 1] = B_CLR:format( "A")

	attr = B_SET:format( "MOUSEWHEELDOWN", "whell1")
	set[#set + 1] = attr
	clr[#clr + 1] = B_CLR:format( "MOUSEWHEELDOWN")

	set1 = table.concat(set, "\n")
	clr1 = table.concat(clr, "\n")

	header:SetAttribute("setup_onenter", set1)
	header:SetAttribute("setup_onleave", clr1)

	local setup, remove = nil, nil --self:GetClickAttributes()

	header:SetAttribute("setup_clicks", setup)
	--header:SetAttribute("remove_clicks", remove)

	header:SetAttribute("clickcast_onenter", [===[
        local header = self:GetParent():GetFrameRef("clickcast_header")
       	header:RunFor(self, header:GetAttribute("setup_onenter"))
]===])

	header:SetAttribute("clickcast_onleave", [===[
        local header = self:GetParent():GetFrameRef("clickcast_header")
        header:RunFor(self, header:GetAttribute("setup_onleave"))
]===])

	header:SetAttribute("clickcast_register", [===[
		local button = self:GetAttribute("clickcast_button")

		-- Export this frame so we can display it in the insecure environment
		self:SetAttribute("export_register", button)

		button:SetAttribute("clickcast_onenter", self:GetAttribute("clickcast_onenter"))
		button:SetAttribute("clickcast_onleave", self:GetAttribute("clickcast_onleave"))
		--ccframes[button] = true

		--self:RunFor(button, self:GetAttribute("setup_clicks"))
]===])
end

local UnitSpecific = {
	player = function(self)
		-- Player specific layout code.
	end,

    party = function(self)
		-- Party specific layout code.
    end,
}

--SpawnMenu = function(self)
--	local unit = self.unit:gsub("(.)", string.upper, 1)
--	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

--	if _G[unit.."FrameDropDown"] then
--		ToggleDropDownMenu(nil, nil, _G[unit.."FrameDropDown"], "cursor")
--	elseif self.unit:match("party") then
--		ToggleDropDownMenu(nil, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
--	else
--		FriendsDropDown.unit = self.unit
--		FriendsDropDown.id = self.id
--		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
--		ToggleDropDownMenu(nil, nil, FriendsDropDown, "cursor")
--	end
--end

function OnChangeTarget( self)
	--if(unit ~= self.unit) then return end

	local unit = self.unit
	local status = UnitThreatSituation( unit)

	if (status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.shadow:SetBackdropBorderColor(r, g, b)
	else
		self.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09)
	end

	if UnitIsUnit( unit, "target") then
		local _, class = UnitClass(unit)
		local t = self.colors.class[class]
		self.shadow:SetBackdropBorderColor( t[1], t[2], t[3])
		if yo.Raid.simpeRaid then
			--self
		end
	end
end

local PostIconUpdate = function( self, button)
	button.icon:SetTexCoord( unpack( yo.tCoord))
	CreateStyle( button, 4)
end

local function OnEnter( f)
	if f.bgHlight then
		f.bgHlight:Show()
	end
	GameTooltip:SetOwner( f:GetParent(), "ANCHOR_NONE", 0, 0)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetUnit( f.unit)
	GameTooltip:Show()
end

local function OnLeave( f)
	if f.bgHlight then
		f.bgHlight:Hide()
	end
	if GameTooltip:IsShown() then
		GameTooltip:FadeOut( 2)
	end
end

local funcWhiteList = function( self, button, ...)
	local spellID = select( 11, ...)
	if not blackSpells[spellID] then
		return true
	else
		return false
	end
end

local funcBlackList = function( self, button, ...)
	local spellID = select( 11, ...)
	if RaidDebuffList[spellID] then
		return true
	else
		return false
	end
end

-------------------------------------------------------------------------------------------------------
--											SHARED
-------------------------------------------------------------------------------------------------------

local Shared = function(self, unit)
	local fontsymbol 	= "Interface\\AddOns\\yoFrame\\Media\\symbol.ttf"
	local texhl 		= "Interface\\AddOns\\yoFrame\\Media\\raidbg"

	-- Shared layout code.
	local unit = 	( self:GetParent():GetName():match( "yo_Part")) and "party" or
					( self:GetParent():GetName():match( "yo_Raid")) and "raid" or
					( self:GetParent():GetName():match( "yo_Tank")) and "tank" or unit

	-- Set our own colors
	self.colors = oUF_colors

	-- Register click
	self:RegisterForClicks("AnyUp")

	local posInfo		= {"LEFT", self, "LEFT", 2, 2}
	local posDead 		= {"TOPRIGHT", self, "TOPRIGHT", -2, -1}
	local posLFD 		= {"RIGHT", self, "RIGHT", -1, -1}
	local posAuras		= {'LEFT', self, 'RIGHT', 12, 0}
	local posRCheck		= {'RIGHT', self, 'RIGHT', -15, 0}
	local sizeInfoFont 	= fontsize
	local sizeLFDFont 	= fontsize - 1
	local sizeDeadFont 	= fontsize - 1
	local sizeRTarget	= 16
	local sizeResurrect	= 25
	local enablePower	= true
	local enableBorder	= true
	local enableAuras	= yo.Raid.aurasParty
	local enableDeHight = yo.Raid.debuffHight
	local enableHealPr	= yo.Raid.healPrediction
	local sizeAuras 	= self:GetHeight() * 0.95
	local spacingAuras 	= 6
	local numAuras 		= 10
	local initialAnchor = "LEFT"
	local growthX 		= "RIGHT"
	local CustomFilter 	= funcWhiteList
	local outsideAlpha	= 0.5

	if yo.Raid.simpeRaid then
		posInfo			= {"LEFT", self, "RIGHT", 12, 0}
		posDead 		= {"RIGHT", self, "RIGHT", -8, 1}
		posLFD			= {"RIGHT", self, "RIGHT", -1, 0}
		posRCheck		= {'RIGHT', self, 'RIGHT', -25, 0}
		sizeInfoFont 	= fontsize + 2
		sizeLFDFont 	= fontsize - 3
		sizeRTarget		= 12
		sizeResurrect	= 16
		enablePower		= false
		enableAuras 	= false
		CreateStyleSmall(self, 1)
	else
		CreateStyle(self, 2)
	end

	if unit == "raid" then
		spacingAuras	= 2
		numAuras		= 2
		sizeAuras		= 20
		posAuras 		= {'TOPRIGHT', self, 'TOPRIGHT', -2, -2}
		initialAnchor 	= "RIGHT"
		growthX 		= 'LEFT'
		CustomFilter	= funcBlackList
	elseif unit == "tank" then
		posInfo			= {"LEFT", self, "LEFT", 2, 2}
		enableDeHight 	= false
		enableBorder 	= true
		enableHealPr	= yo.Raid.healPrediction
		enableAuras 	= true
		enablePower		= true
		numAuras		= 3
		spacingAuras	= 3
		sizeInfoFont	= fontsize
		initialAnchor 	= "RIGHT"
		growthX 		= 'LEFT'
		sizeAuras 		= self:GetHeight() * 0.8
		posAuras		= {'TOPRIGHT', self, 'TOPRIGHT', -2, -2}
		CustomFilter	= funcWhiteList --funcWhiteList
		outsideAlpha	= 0.5
	end

	if self:GetParent():GetName():match( "yo_TanketsTar") then
		enablePower		= false
		enableAuras 	= false
		sizeInfoFont	= fontsize - 1
		sizeDeadFont 	= fontsize - 1
	end

	--print(unit, self:GetParent():GetName(), self.unit)
	------------------------------------------------------------------------------------------------------
	---											HEALTH BAR
	------------------------------------------------------------------------------------------------------
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	self.Health:SetAllPoints()
	self.Health:SetStatusBarTexture( texture)
	table.insert( N.statusBars, self.Health)

	self.Health.frequentUpdates = true
	self.Health.colorDisconnected = true
	self.colors.disconnected = { 0.3, 0.3, 0.3}
	self.Range = { insideAlpha = 1, outsideAlpha = outsideAlpha, }

	self.Health.hbg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.hbg:SetAllPoints()
	self.Health.hbg:SetTexture( texture)
	self.Health.hbg:SetVertexColor( 0.3, 0.3, 0.3, 0.9)

	if yo.Raid.hpBarRevers 	 then self.Health:SetFillStyle( 'REVERSE'); end
	if yo.Raid.hpBarVertical then self.Health:SetOrientation( 'VERTICAL') 	end

	if yo.Raid.classcolor == 1 then
		self.Health.colorClass = true
	    self.Health.colorReaction = true

	elseif yo.Raid.classcolor == 2 then
		self.Health.colorSmooth = true
		self.Health.colorReaction = true

	else
		self.Health.colorHealth = true
		self.colors.health = { 0.2, 0.2, 0.2 }
		self.Health.hbg:SetVertexColor( 0.7, 0.7, 0.7, 0.9)
	end

	if yo.Raid.simpeRaid and yo.Raid.classcolor ~= 3 then
		self.Health.bg = self.Health.hbg
		self.Health.bg.multiplier = .5
	end

	------------------------------------------------------------------------------------------------------
	---											POWER BAR
	------------------------------------------------------------------------------------------------------

	if enablePower then
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint("BOTTOM", self, "BOTTOM", 0, 4)
		self.Power:SetStatusBarTexture( texture)
		self.Power:SetFrameStrata( "MEDIUM")
		self.Power:SetWidth( self:GetWidth() - 6)
		self.Power:SetHeight( 2)
		table.insert( N.statusBars, self.Power)

		self.Power.PostUpdate = function(power, unit, cur, min, max)
			local role = UnitGroupRolesAssigned( unit)

			if yo.Raid.manabar == 1 or ( role == "HEALER" and yo.Raid.manabar == 2 ) or self:GetParent():GetName():match( "yo_Tanke") then
				power:Show( )
				if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
					power:SetValue( max)
				end
			else
				power:Hide( )
			end
		end

		self.Power:SetFrameLevel(10)
		self.Power.frequentUpdates = false
		self.Power.colorDisconnected = true
		if yo.Raid.manacolorClass then
			self.Power.colorClass = true
		else
			self.Power.colorPower = true
		end

		-- Power bar background
		self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture( texture)
		self.Power.bg:SetAlpha(1)
		self.Power.bg.multiplier = 0.2

		CreateStyle( self.Power, 2)
	end

--	    -- Position and size
--    local mainBar = CreateFrame('StatusBar', nil, self.Power)
--    mainBar:SetReverseFill(true)
--    mainBar:SetPoint('TOP')
--    mainBar:SetPoint('BOTTOM')
--    mainBar:SetPoint('RIGHT', self.Power:GetStatusBarTexture(), 'RIGHT')
--    mainBar:SetWidth( self:GetWidth() - 6)

--    --local altBar = CreateFrame('StatusBar', nil, self.AdditionalPower)
--    --altBar:SetReverseFill(true)
--    --altBar:SetPoint('TOP')
--    --altBar:SetPoint('BOTTOM')
--    --altBar:SetPoint('RIGHT', self.AdditionalPower:GetStatusBarTexture(), 'RIGHT')
--    --altBar:SetWidth(200)

--    -- Register with oUF
--    self.PowerPrediction = {
--        mainBar = mainBar
----        altBar = altBar
--    }
	------------------------------------------------------------------------------------------------------
	----										OVERLAY
	------------------------------------------------------------------------------------------------------
	self.Overlay = CreateFrame( 'Frame', nil, self)
	self.Overlay:SetAllPoints( self)
	self.Overlay:SetFrameLevel( 100)

	self.bgHlight = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.bgHlight:SetAllPoints( self)
	self.bgHlight:SetVertexColor( 0.5,0.5,0.5,0.9)
	self.bgHlight:SetTexture( texhl)
	self.bgHlight:SetBlendMode( "ADD")
	self.bgHlight:SetAlpha( 0.2)
	self.bgHlight:Hide()

	self.Info = self.Overlay:CreateFontString( nil, "OVERLAY")
	self.Info:SetPoint( unpack( posInfo))
	self.Info:SetFont( font, sizeInfoFont)
	self.Info:SetShadowOffset( 1, -1)
	self.Info:SetShadowColor( 0, 0, 0, 1)
	table.insert( N.strings, self.Info)
	self:Tag( self.Info, "[GetNameColor][namemedium][afk]")

    local RaidTargetIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
    RaidTargetIndicator:SetSize( sizeRTarget, sizeRTarget)
    RaidTargetIndicator:SetPoint('CENTER', self, 'TOP', 0, 0)
    RaidTargetIndicator:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidicons")
    self.RaidTargetIndicator = RaidTargetIndicator

    local ResurrectIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
    ResurrectIndicator:SetSize( sizeResurrect, sizeResurrect)
    ResurrectIndicator:SetPoint('CENTER', self, 'CENTER', 0, 0)
    self.ResurrectIndicator = ResurrectIndicator

	local DeadText = self.Overlay:CreateFontString(nil ,"OVERLAY")
	DeadText:SetFont( font, sizeDeadFont)
	DeadText:SetPoint( unpack( posDead))
	DeadText:SetShadowOffset( 1, -1)
	DeadText:SetShadowColor( 0, 0, 0, 1)
	self.DeadText = DeadText
	table.insert( N.strings, self.DeadText)
	self:Tag( DeadText, "[GetNameColor]".. yo.Raid.showHPValue)

	if unit == "raid" and yo.Raid.showGroupNum then
		self.rText = self.Overlay:CreateFontString(nil ,"OVERLAY")
		self.rText:SetFont( fontpx, fontsize, "OUTLINE")
		self.rText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, -4)
		table.insert( N.strings, self.rText)
		self:Tag(self.rText, "[GetNameColor][group]")
	end

	local LeaderIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
   	LeaderIndicator:SetSize(10, 10)
   	LeaderIndicator:SetPoint('LEFT', self, 'TOPLEFT', 10, 0)
   	self.LeaderIndicator = LeaderIndicator

	local AssistantIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
   	AssistantIndicator:SetSize(10, 10)
   	AssistantIndicator:SetPoint('LEFT', self.rText, 'RIGHT', 0, 0)
   	AssistantIndicator.PostUpdate = function(self)
		if yo.Raid.classBackground == true and yo.Raid.classcolor == 3 then
			local parent = self:GetParent():GetParent()
			local t = self.__owner.colors.class[select( 2, UnitClass( parent.unit))]
			if t then
				parent.Health.hbg:SetVertexColor( t[1], t[2], t[3], 0.9)
			end
		end
   	end
   	self.AssistantIndicator = AssistantIndicator

   	local ReadyCheckIndicator = self.Overlay:CreateTexture(nil, 'BORDER')
   	ReadyCheckIndicator:SetSize(16, 16)
   	ReadyCheckIndicator:SetPoint( unpack( posRCheck))
   	self.ReadyCheckIndicator = ReadyCheckIndicator
	self.ReadyCheckIndicator.finishedTime = 5

	if yo.Raid.showLFD and unit ~= "tank" then
		local lfd =   self.Overlay:CreateFontString(nil ,"OVERLAY")
		lfd:SetFont( fontsymbol, sizeLFDFont)
		lfd:SetPoint( unpack( posLFD))
		lfd:SetJustifyH"LEFT"
		self:Tag(lfd, '[LFD]')
	end
	--end

	------------------------------------------------------------------------------------------------------
	---											AURAS
	------------------------------------------------------------------------------------------------------
	if enableAuras then
		local Buffs = CreateFrame('Frame', nil, self)
		Buffs:SetPoint( unpack( posAuras))
		Buffs:SetFrameLevel( 100)
		Buffs:SetSize( sizeAuras * ( numAuras +1), sizeAuras)
		Buffs.disableCooldown = false
		Buffs.spacing 		= spacingAuras
		Buffs.num 			= numAuras
		Buffs.disableMouse 	= false
		Buffs.size   		= sizeAuras
		Buffs.initialAnchor = initialAnchor
		Buffs['growth-x'] 	= growthX
		self.Debuffs = Buffs
		self.Debuffs.CustomFilter = CustomFilter

		self.Debuffs.PostCreateIcon = function( self, button)
			--button:SetAlpha( 1)
			--button:EnableMouse(false)
			--button.icon:SetDesaturated( true)
			button.icon:SetTexCoord( unpack( yo.tCoord))
			button.count:SetFont( fontpx, self:GetHeight() / 1.5, 'OUTLINE')
			button.count:ClearAllPoints()
			button.count:SetPoint( 'CENTER', button, 'TOPRIGHT', 0, 0)
			button.count:SetTextColor( 0, 1, 0)
			button.cd:SetDrawEdge( false)
			button.cd:SetDrawSwipe( false)
			CreateStyle( button, 3)
		end
	end

	------------------------------------------------------------------------------------------------------
	---										HEAL PREDICTION
	------------------------------------------------------------------------------------------------------
	if enableHealPr then
		--local myBar = CreateFrame('StatusBar', nil, self.Health)
	 	--myBar:SetPoint('TOP')
  		--myBar:SetPoint('BOTTOM')
  		--myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
  		--myBar:SetWidth(200)
  		--myBar:SetStatusBarTexture(texture)

    	local otherBar = CreateFrame('StatusBar', nil, self.Health)
    	otherBar:SetPoint('TOP')
    	otherBar:SetPoint('BOTTOM')
    	otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    	otherBar:SetWidth( self:GetWidth())
    	otherBar:SetStatusBarTexture(texture)
		otherBar:SetStatusBarColor( 0.5, 1, 0, 0.7)

    	local absorbBar = CreateFrame('StatusBar', nil, self.Health)
    	absorbBar:SetPoint('TOP')
    	absorbBar:SetPoint('BOTTOM')
    	absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    	absorbBar:SetWidth( self:GetWidth())
		absorbBar:SetStatusBarTexture(texture)
		--absorbBar:SetFillStyle( 'REVERSE')
		absorbBar:SetStatusBarColor( 1, 1, 0, 0.7)

		local healAbsorbBar = CreateFrame('StatusBar', nil, self.Health)
    	healAbsorbBar:SetPoint('TOP')
    	healAbsorbBar:SetPoint('BOTTOM')
    	healAbsorbBar:SetPoint('RIGHT', self.Health:GetStatusBarTexture())
    	healAbsorbBar:SetWidth( self:GetWidth())
		healAbsorbBar:SetStatusBarTexture(texture)
		healAbsorbBar:SetStatusBarColor( 0, .5, 1, 0.7)
    	healAbsorbBar:SetReverseFill(true)

    	self.HealthPred = {
        	--myBar = myBar,
        	otherBar = otherBar,
        	absorbBar = absorbBar,
   	        healAbsorbBar = healAbsorbBar,
        	maxOverflow = 1,
    	    frequentUpdates = true,
	    }
	    table.insert( N.statusBars, self.HealthPred.otherBar)
	    table.insert( N.statusBars, self.HealthPred.absorbBar)
	    table.insert( N.statusBars, self.HealthPred.healAbsorbBar)
	end

   	if enableBorder then
		table.insert(self.__elements, OnChangeTarget)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', OnChangeTarget)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnChangeTarget)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", OnChangeTarget)
	end

	------------------------------------------------------------------------------------------------------
	---										Debuff highlight
	------------------------------------------------------------------------------------------------------
	if enableDeHight then
		self.DebuffHighlightMy = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlightMy:SetAllPoints(self.Health)
		self.DebuffHighlightMy:SetTexture(texture)
		self.DebuffHighlightMy:SetVertexColor(0, 1, 0, 0)
		self.DebuffHighlightMy:SetBlendMode("BLEND")
		self.DebuffHighlightMyAlpha = 0.4
		self.DebuffHighlightMyFilter = yo.Raid.filterHighLight
		--self.DebuffHighlightUseTexture = true
	end


	--self:SetAttribute("unit", "player") ------------------!!!!!!!!!!!!!!!!!!

	if yo.healBotka.enable then

		self.menu = nil
--		self:SetScript("OnEnter", nil)
--		self:SetScript("OnLeave", nil)
		self:EnableMouseWheel( 1)
		self:EnableKeyboard( true)

		--self:SetAttribute("type-cliquebuttonQ", "spell")
		--self:SetAttribute("spell-cliquebuttonQ", "Восстановление")

		--self:SetAttribute("type-cliquebuttonA", "spell")
		--self:SetAttribute("spell-cliquebuttonA", "Омоложение")

		--self:SetAttribute("type-w1", "spell")
		--self:SetAttribute("spell-w1", "Буйный рост")

		self:SetAttribute("type-buttonQ", "macro")
		self:SetAttribute("macrotext-buttonQ", "/cast [@mouseover] Восстановление")

		self:SetAttribute("type-buttonA", "macro")
		self:SetAttribute("macrotext-buttonA", "/cast [@mouseover] Омоложение")

		self:SetAttribute("type-whell1", "macro")
		self:SetAttribute("macrotext-whell1", "/cast [@mouseover] Буйный рост")
	else
		--self.menu = SpawnMenu
		self:SetScript("OnEnter", OnEnter)
		self:SetScript("OnLeave", OnLeave)
	end

	--if(UnitSpecific[unit]) then
	--	return UnitSpecific[unit](self)
	--end
	--self.testers = testers
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
    local shadowMove = CreateFrame("Frame", nil, f)
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

local function CreateMovier(frame)
	local delta = 8
	CreateStyle( frame, delta, 0, 0, 0)
	CreateTempStyle( frame, delta, 0, .2, .9)

	local movePartyFrame = frame.shadow
	movePartyFrame:EnableMouse(true)
	movePartyFrame:SetMovable(true)
	movePartyFrame:RegisterForDrag("LeftButton", "RightButton")

	movePartyFrame:ClearAllPoints()
	movePartyFrame:SetPoint( yo_MoveRaid:GetPoint())
	movePartyFrame:SetWidth( frame:GetWidth() + delta * 2)
	movePartyFrame:SetHeight( frame:GetHeight() + delta * 2)

	frame:SetPoint( "TOPLEFT", movePartyFrame, "TOPLEFT", delta, - delta)

	movePartyFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	movePartyFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		yo_MoveRaid:ClearAllPoints()
		yo_MoveRaid:SetPoint( self:GetPoint())
		SetAnchPosition( yo_MoveRaid, self)
	end)

	movePartyFrame:SetScript("OnShow", function(self)
		if InCombatLockdown() then return end

		self:ClearAllPoints()
		self:SetPoint( yo_MoveRaid:GetPoint())
	end)

	movePartyFrame:SetScript("OnHide", function(self)
		if InCombatLockdown() then return end

		yo_MoveRaid:ClearAllPoints()
		yo_MoveRaid:SetPoint( self:GetPoint())
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

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if not yo.Raid.enable then return end
	if yo.Raid.noHealFrames and ( IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2") or IsAddOnLoaded("HealBot") or IsAddOnLoaded("VuhDo") or IsAddOnLoaded("oUF_Freebgrid")) then return end
	if yo.healBotka.enable then CreateClique() end

	local unit_width = 	yo.Raid.width
	local unit_height = yo.Raid.height
	local spaicing = ( yo.Raid.spaicing or 6)
	local unitsPerColumn = 5

	if yo.Raid.simpeRaid then
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

	oUF:RegisterStyle("Raid", Shared)
	oUF:Factory(function(self)
		self:SetActiveStyle("Raid")
		local groupBy, groupingOrder

		if yo.Raid.groupingOrder == "GROUP" then
			local raid = {}
			for i = 1, yo.Raid.numgroups do
				local raidgroup = self:SpawnHeader("yo_RaidGroup"..i, nil, "raid",--"custom [@raid6,exists] show;hide",
					"oUF-initialConfigFunction", [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute("initial-width"))
						self:SetHeight(header:GetAttribute("initial-height"))
					]],
					"initial-width", unit_width,
					"initial-height", unit_height,
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
					raidgroup:SetPoint("TOPLEFT", yo_MoveRaid, "TOPLEFT", 0, 0)
				--elseif i == 5 then
				--	raidgroup:SetPoint("TOPLEFT", raid[1], "TOPRIGHT", 7, 0)
				else
					raidgroup:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", spaicing, 0)
				end
				raid[i] = raidgroup
			end
			CreateMovier( raid[1], yo.Raid.numgroups, spaicing)

		else

			if yo.Raid.groupingOrder == "THD" then
				groupBy 	= 'ASSIGNEDROLE'
				groupingOrder = 'TANK,HEALER,DAMAGER,NONE'
			elseif yo.Raid.groupingOrder == "TDH" then
				groupBy = 'ASSIGNEDROLE'
				groupingOrder = 'TANK,DAMAGER,HEALER,NONE'
			else
				groupBy = "GROUP"
				groupingOrder = "1,2,3,4,5,6,7,8"
			end

			local raid = self:SpawnHeader( 'yo_Raid', nil, 'raid',
				"oUF-initialConfigFunction", [[
					local header = self:GetParent()
					self:SetWidth(header:GetAttribute("initial-width"))
					self:SetHeight(header:GetAttribute("initial-height"))
				]],

				"groupBy", groupBy,
				"groupingOrder", groupingOrder,
				"initial-width", unit_width,
				"initial-height", unit_height,
			--	"showSolo", false,
			--	"showPlayer", true,
				"showRaid", true,
				"xOffset", spaicing,
				"yOffset", -spaicing,			---6,
				"maxColumns", yo.Raid.numgroups,
				"unitsPerColumn", unitsPerColumn,
				"columnSpacing", spaicing,
				"point", "TOP",
				"columnAnchorPoint", "LEFT"
			)
			--raid:SetPoint("TOPLEFT", yo_MoveRaid, "TOPLEFT", 0, 0)
			CreateMovier( yo_Raid)
		end


		local party = self:SpawnHeader( 'yo_Party', nil, 'party,solo',
			"oUF-initialConfigFunction", [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute("initial-width"))
				self:SetHeight(header:GetAttribute("initial-height"))
			]],
			"initial-width", unit_width * yo.Raid.partyScale,
			"initial-height", unit_height * yo.Raid.partyScale,
			"showSolo", yo.Raid.showSolo,
			"showPlayer", true,
			"showParty", true,
			"showRaid", false,
			"xOffset", spaicing * yo.Raid.partyScale,
			"groupBy", groupBy,
			"groupingOrder", groupingOrder,
			"yOffset", -spaicing * yo.Raid.partyScale * 1.0,			---6,
			"unitsPerColumn", unitsPerColumn,
			"columnSpacing", yo.Raid.spaicing,
			"point", "TOP",
			"columnAnchorPoint", "LEFT"
		)
		--party:SetPoint("TOPLEFT", yo_MoveRaid, "TOPLEFT", 0, 0)
		CreateMovier( yo_Party)

		if yo.Raid.showMT then --and not yo.Raid.simpeRaid then
			local heightMT = yo.Raid.heightMT
			local widthMT = yo.Raid.widthMT
			local offsetMT = 6

			local heightMTT, offsetMTT, widthMTT
			local fullMTT = 0

			if yo.Raid.showMTT then
				heightMTT	= min( 25, heightMT * .7)
				widthMTT	= min( 120, widthMT * .8)
				offsetMTT	= offsetMT + heightMT - heightMTT
				fullMTT		= offsetMT + widthMTT
			end
			local showParty = true

			local mt = self:SpawnHeader( 'yo_Tankets', nil, 'raid,party',
    			'showRaid', true,
    			'showParty', showParty,
    			'showPlayer', showParty,
    			--'groupFilter', 'MAINTANK',
    			'roleFilter', 'TANK',
    			'yOffset', -offsetMT,
    			'widthMT', fullMTT + offsetMT,
    			'point', "TOP",
    			'oUF-initialConfigFunction', ([[
            		self:SetWidth(%d)
            		self:SetHeight(%d)
            		self:SetScale(%d)
            	]]):format( widthMT, heightMT, 1)
			)
			mt:SetPoint("TOPLEFT", yo_MoveTanks, "TOPLEFT", 0, 0)

			if yo.Raid.showMTT then
				local mtt = self:SpawnHeader( 'yo_TanketsTar', nil, 'raid,party',
    				'showRaid', true,
    				'showParty', showParty,
    				'showPlayer', showParty,
    				--'groupFilter', 'MAINTANK',
    				'roleFilter', 'TANK',
    				'yOffset', -offsetMTT,
    				'point', "TOP",
    				'oUF-initialConfigFunction', ([[
        				self:SetAttribute('unitsuffix', 'target')
        				self:SetWidth(%d)
            			self:SetHeight(%d)
            			self:SetScale(%d)
            			]]):format( widthMTT, heightMTT, 1)
				)
				mtt:SetPoint("TOPLEFT", mt, "TOPRIGHT", offsetMT, 0)
			end
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
--]]
