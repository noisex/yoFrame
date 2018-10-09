local _, ns = ...
local oUF = ns.oUF or oUF 

local UnitSpecific = {
	player = function(self)
		-- Player specific layout code.
	end,
        
    party = function(self)
		-- Party specific layout code.         
    end,
}

SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end
	print( unit)
	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(nil, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif self.unit:match("party") then
		ToggleDropDownMenu(nil, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(nil, nil, FriendsDropDown, "cursor")
	end
end

function OnChangeTarget( self)
	--if(unit ~= self.unit) then return end

	local unit = self.unit	
	local status = UnitThreatSituation( unit)
	
	if (status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.shadow:SetBackdropBorderColor(r, g, b)
	else
		self.shadow:SetBackdropBorderColor( 0, 0, 0)
	end
	
	if UnitIsUnit( unit, "target") then 
		local _, class = UnitClass(unit)
		local t = self.colors.class[class]
		self.shadow:SetBackdropBorderColor( t[1], t[2], t[3])
	end
end

local PostIconUpdate = function( self, button)
	button.icon:SetTexCoord( 0.07, 0.93, 0.07, 0.93)
	CreateStyle( button, 4)
end

local function OnEnter( f)
	f.bgHlight:Show()
	GameTooltip:SetOwner( f:GetParent(), "ANCHOR_NONE", 0, 0)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetUnit( f.unit)
	GameTooltip:Show()

	--f:EnableMouseWheel( true)
	--f:EnableKeyboard( true)
	--SetBindingClick( "F", f:GetName(), "cliquebuttonF")
end

local function OnLeave( f)
	f.bgHlight:Hide()
	if GameTooltip:IsShown() then
		GameTooltip:FadeOut( 2) 
	end

	--f:EnableMouseWheel( false)
	--f:EnableKeyboard( false)
	--SetBinding("F");
end

-------------------------------------------------------------------------------------------------------
--											SHARED
-------------------------------------------------------------------------------------------------------

local Shared = function(self, unit)
	local fontsymbol 	= "Interface\\AddOns\\yoFrame\\Media\\symbol.ttf"
	local texhl 		= "Interface\\AddOns\\yoFrame\\Media\\raidbg"
	
	-- Shared layout code.
	local unit = ( self:GetParent():GetName():match( "yo_Party")) and "party" or ( self:GetParent():GetName():match( "yo_Raid")) and "raid"

	-- Set our own colors
	self.colors = oUF_colors

	-- Register click
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)

	self.menu = SpawnMenu
	CreateStyle(self, 3)
		
	------------------------------------------------------------------------------------------------------
	---											HEALTH BAR
	------------------------------------------------------------------------------------------------------
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	self.Health:SetAllPoints()
	self.Health:SetStatusBarTexture( texture)
	
	self.Health.hbg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.hbg:SetAllPoints( self.Health)
	self.Health.hbg:SetTexture( texture)

	if yo.Raid.hpBarRevers then 
		self.Health:SetFillStyle( 'REVERSE');
	end
	if yo.Raid.hpBarVertical then 
		self.Health:SetOrientation( 'VERTICAL')
	end
	
	self.Health.frequentUpdates = true
	self.Health.colorDisconnected = true
	self.colors.disconnected = { 0.3, 0.3, 0.3}
	self.Range = { insideAlpha = 1, outsideAlpha = 0.5, }	

	if yo.Raid.classcolor == 1 then 
		self.Health.colorClass = true
		self.Health.hbg:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	elseif yo.Raid.classcolor == 2 then
		self.Health.colorSmooth = true 
		self.Health.hbg:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	else
		self.Health.colorHealth = true
		self.colors.health = { 0.2, 0.2, 0.2 }
		self.Health.hbg:SetVertexColor( 0.7, 0.7, 0.7, 0.9)
		self.Range = { insideAlpha = 1, outsideAlpha = .5, }
	end

	------------------------------------------------------------------------------------------------------
	---											POWER BAR
	------------------------------------------------------------------------------------------------------	
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetPoint("BOTTOM", self, "BOTTOM", 0, 4)
	self.Power:SetStatusBarTexture( texture)
	self.Power:SetFrameStrata( "MEDIUM")
	self.Power:SetWidth( self:GetWidth() - 6)
	self.Power:SetHeight( 2)

	self.Power.PostUpdate = function(power, unit, cur, min, max)
		local role = UnitGroupRolesAssigned( unit)

		if yo.Raid.manabar == 1 or ( role == "HEALER" and yo.Raid.manabar == 2 ) then
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
	self.Info:SetPoint("LEFT", self, "LEFT", 2, 2)
	self.Info:SetFont( font, fontsize)
	self.Info:SetShadowOffset( 1, -1)
	self.Info:SetShadowColor( 0, 0, 0, 1)
	self:Tag( self.Info, "[GetNameColor][namemedium][afk]")
	
	if unit == "raid" and yo.Raid.showGroupNum then
		self.rText = self.Overlay:CreateFontString(nil ,"OVERLAY")
		self.rText:SetFont( fontpx, fontsize, "OUTLINE")
		self.rText:SetPoint("BOTTOMLEFT", self.Overlay, "TOPLEFT", 2, -4)
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

    local RaidTargetIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
    RaidTargetIndicator:SetSize( 16, 16)
    RaidTargetIndicator:SetPoint('CENTER', self, 'TOP', 0, 0)
    RaidTargetIndicator:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\raidicons")
    self.RaidTargetIndicator = RaidTargetIndicator

    local ReadyCheckIndicator = self.Overlay:CreateTexture(nil, 'BORDER')
    ReadyCheckIndicator:SetSize(16, 16)
    ReadyCheckIndicator:SetPoint('RIGHT', self, 'RIGHT', -15, 0)
    self.ReadyCheckIndicator = ReadyCheckIndicator
	self.ReadyCheckIndicator.finishedTime = 5
	
    local ResurrectIndicator = self.Overlay:CreateTexture(nil, 'OVERLAY')
    ResurrectIndicator:SetSize( 25, 25)
    ResurrectIndicator:SetPoint('CENTER', self, 'CENTER', 0, 0)
    self.ResurrectIndicator = ResurrectIndicator
	
	local DeadText = self.Overlay:CreateFontString(nil ,"OVERLAY")
	DeadText:SetFont( font, fontsize - 1) --, "OUTLINE")
	DeadText:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -1)
	DeadText:SetShadowOffset( 1, -1)
	DeadText:SetShadowColor( 0, 0, 0, 1)
	self:Tag( DeadText, "[GetNameColor]".. yo.Raid.showHPValue)

	if yo.Raid.showLFD then
		local lfd =   self.Overlay:CreateFontString(nil ,"OVERLAY")
		lfd:SetFont( fontsymbol, fontsize - 1, "OUTLINE")
		lfd:SetPoint("RIGHT", self, "RIGHT", -1, -1)
		lfd:SetJustifyH"LEFT"
		self:Tag(lfd, '[LFD]')
	end

	------------------------------------------------------------------------------------------------------
	---											AURAS
	------------------------------------------------------------------------------------------------------
	if ( unit == "party" or unit == "player") and yo.Raid.aurasParty then
		local size = self:GetHeight() * 0.8
		
		local Buffs = CreateFrame('Frame', nil, self)
		--self.Info:SetPoint( 'LEFT', self.Power, 'LEFT', 3, 5)
		Buffs:SetPoint( 'LEFT', self, 'RIGHT', 12, 0)
		Buffs:SetFrameLevel( 100)
		Buffs:SetSize( size * 12, size)
		Buffs.disableCooldown = false
		--Buffs.filter = 'HARMFUL'
		Buffs.spacing = 6
		Buffs.num = 10
		Buffs.disableMouse = false
		Buffs.size   =  size
		self.Debuffs = Buffs
		self.Debuffs.CustomFilter = function( self, button, ...)
			spellID = select( 11, ...)
			if not blackSpells[spellID] then
				return true
			else
				return false
			end
		end

		DeadText:SetFont( font, fontsize - 1)

		self.Debuffs.PostCreateIcon = function( self, button)
			button.icon:SetTexCoord( 0.07, 0.93, 0.07, 0.93)
			button.count:SetFont( fontpx, fontsize + 8, 'OUTLINE')
			button.count:ClearAllPoints()
			button.count:SetPoint( 'CENTER', button, 'TOPRIGHT', 0, 0)
			button.count:SetTextColor( 1, 0.9, 0)
			
			--button.cd:ClearAllPoints()
			--button.cd:SetPoint( 'CENTER', button, 'BOTTOM', 0, 0)
			button.cd:SetDrawSwipe( false)
			button.cd:SetDrawEdge( false)
			CreateStyle( button, 4)
		end
		--self.Debuffs.PostUpdate = function( self, button, ...)
			--print( ...)
		--end
	elseif unit == "raid" and yo.Raid.aurasRaid then
		DeadText:SetFont( font, fontsize - 2)

		local size = 15	--self:GetHeight() * 0.7
		
		local Buffs = CreateFrame('Frame', nil, self)
		--Buffs:SetPoint( 'TOPRIGHT', self, 'TOPRIGHT', -20, 0)
		--Buffs:SetPoint( 'BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		Buffs:SetPoint( 'TOPRIGHT', self, 'TOPRIGHT', -2, -2)
		--Buffs:SetPoint( 'BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		
		Buffs:SetFrameLevel( 150)
		--Buffs:SetSize( ( size + 6) * 10, size * 2)
		Buffs:SetSize( size * 10, size)

		Buffs.disableCooldown = false
		----Buffs.filter = 'HARMFUL'
		Buffs.spacing = 1
		Buffs.num = 2
		Buffs.disableMouse = true
		Buffs.initialAnchor = "RIGHT"
		Buffs.size   =  size
		Buffs['growth-x'] = 'LEFT'
		self.Debuffs = Buffs
		
		self.Debuffs.CustomFilter = function( self, button, ...)
			local spellID = select( 11, ...)
			
			if whiteList[spellID] then
				return true
			else
				return false
			end
		end
		self.Debuffs.PostCreateIcon = function( self, button)
			button.icon:SetTexCoord( 0.07, 0.93, 0.07, 0.93)
			--button.icon:SetDesaturated( true)
			button.count:SetFont( fontpx, fontsize +4, 'OUTLINE')
			button.count:ClearAllPoints()
			button.count:SetPoint( 'CENTER', button, 'TOPRIGHT', 0, 0)
			button.count:SetTextColor( 1, 0.9, 0)			
			button:SetAlpha( 0.8)
			--CreateStyle( button, 4, 150)
		end	
	end
	
	------------------------------------------------------------------------------------------------------
	---										HEAL PREDICTION
	------------------------------------------------------------------------------------------------------	
	if yo.Raid.healPrediction then
		--local myBar = CreateFrame('StatusBar', nil, self.Health)
	 --   myBar:SetPoint('TOP')    
  --  	myBar:SetPoint('BOTTOM')
  --  	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
  --  	myBar:SetWidth(200)
  --  	myBar:SetStatusBarTexture(texture)

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
	end
    
	table.insert(self.__elements, OnChangeTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', OnChangeTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", OnChangeTarget)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", OnChangeTarget)
		
	-- Debuff highlight
	if yo.Raid.debuffHight then
		self.DebuffHighlightMy = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlightMy:SetAllPoints(self.Health)
		self.DebuffHighlightMy:SetTexture(texture)
		self.DebuffHighlightMy:SetVertexColor(0, 1, 0, 0)
		self.DebuffHighlightMy:SetBlendMode("BLEND")
		self.DebuffHighlightMyAlpha = 0.4
		self.DebuffHighlightMyFilter = false
		--self.DebuffHighlightUseTexture = true
	end


	self:SetAttribute("unit", "player")

	if yo.healBotka.enable then

		self.menu = nil

		self:EnableMouseWheel( 1)
		self:EnableKeyboard( true)

		self:SetAttribute("type2", "spell");
		self:SetAttribute("spell2", "Омоложение");	

		self:SetAttribute( "type1", "spell");
		self:SetAttribute( "spell1", "Восстановление");	

		self:SetAttribute( "shift-type1", "spell");
		self:SetAttribute( "shift-spell1", "Буйный рост");	

		self:SetAttribute( "shift-type2", "spell");
		self:SetAttribute( "shift-spell2", "Жизнецвет");

		--self:SetAttribute(aModiKey .. "type" .. aButtonId, "macro");
		--self:SetAttribute(aModiKey .. "macrotext" .. aButtonId, VUHDO_buildAssistMacroText(tUnit));

		self:SetAttribute( "type-w1", "macro");
		self:SetAttribute( "macrotext-w1", "/use буйный рост");	

		self:SetAttribute("type-cliquebuttonF", "macro")
		self:SetAttribute("macrotext-cliquebuttonF", "/use буйный рост")

		local B_SET = [[self:SetBindingClick(true, "Q", self, "cliquebuttonF")]]
		
		local attr = B_SET	--:format(key, suffix)
		
		self:SetScript("OnMouseWheel", function(self, delta) if delta>0 then KeyPressed( self, "MOUSEWHEELUP") else KeyPressed( self, "MOUSEWHEELDOWN") end end)

	--self:SetAttribute("_onstate-wpbinding", [[
 --		if newstate == "on" then
 -- 			self:SetBindingSpell(false, "SHIFT-B", "Восстановление")
 -- 			self:SetBindingSpell(false, "SHIFT-O", "Омоложение")
 -- 			self:SetBindingClick( "F", self:GetName(), "cliquebuttonF")

 --		elseif newstate == "off" then
 -- 			self:ClearBindings()
 --		end
	--]])
	--RegisterStateDriver( self, "wpbinding", "[@mouseover] on; off")
	end
		
	--if(UnitSpecific[unit]) then
	--	return UnitSpecific[unit](self)
	--end
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
local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if not yo.Raid.enable then return end
	if yo.Raid.noHealFrames and ( IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2") or IsAddOnLoaded("HealBot") or IsAddOnLoaded("VuhDo") or IsAddOnLoaded("oUF_Freebgrid")) then return end
	
	local unit_width = 	yo.Raid.width
	local unit_height = yo.Raid.height

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
		local spaicing = ( yo.Raid.spaicing or 6)
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
				groupingOrder = 'TANK,HEALER,DAMAGER'
			elseif yo.Raid.groupingOrder == "TDH" then
				groupBy = 'ASSIGNEDROLE'
				groupingOrder = 'TANK,DAMAGER,HEALER'
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
				"showSolo", false,
				"showPlayer", true,
				"showRaid", true,
				"xOffset", spaicing,
				"yOffset", -spaicing,			---6,
				"maxColumns", yo.Raid.numgroups,
				"unitsPerColumn", 5,
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
			"unitsPerColumn", 5,
			"columnSpacing", yo.Raid.spaicing,
			"point", "TOP",
			"columnAnchorPoint", "LEFT"
		)
		--party:SetPoint("TOPLEFT", yo_MoveRaid, "TOPLEFT", 0, 0) 		
		CreateMovier( yo_Party)
	end)	
end)

