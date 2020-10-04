local _, ns = ...
local oUF = ns.oUF or oUF
local colors = oUF.colors
local L, yo, N = ns[1], ns[2], ns[3]
local fontsymbol 	= "Interface\\AddOns\\yoFrame\\Media\\symbol.ttf"
local texhl 		= "Interface\\AddOns\\yoFrame\\Media\\raidbg"

local UpdateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

local function OnEnter(f, event)
	f.bgHlight:Show()
	GameTooltip:SetOwner( f:GetParent(), "ANCHOR_NONE", 0, 0)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetUnit( f.unit)
	GameTooltip:Show()
end

local function OnLeave(f, event)
	f.bgHlight:Hide()
	if GameTooltip:IsShown() then
		GameTooltip:FadeOut(2)
	end
end

local function updateFlash( self)
	local timeElapsed = GetTime() - self.startTime

	if ( timeElapsed > self.tick ) then
		self.powerFlashBar:SetValue( 0)
		self:SetScript("OnUpdate", nil)
	else
		local predPlus 	= timeElapsed / self.tick
		local predMinus = 1 - predPlus
		local pmin 		= UnitPower( "player")
		local cost 		= self.predictedPowerCost - self.predictedPowerCost * predPlus
		self.powerFlashBar:SetStatusBarColor( self.colr * predMinus, self.colg * predMinus, self.colb * predMinus, 1)-- - predPlus)
		self.powerFlashBar:SetValue( min( cost, self.powerMax - pmin))
	end
end

local function powerManaCost(self, event, _, _, spellID) -- 240022
	if myClass == "WARLOCK" and mySpec == 3 or spellID == 240022 then return end

	local cost 		= 0;
	local powerType = UnitPowerType("player")
	local costTable = GetSpellPowerCost( spellID)
	for _, costInfo in pairs( costTable) do
		if (costInfo.type == powerType) then
			cost = costInfo.cost;
			break;
		end
	end

	if cost > 0 then
		self.Power.powerFlashBar:SetMinMaxValues( self.Power:GetMinMaxValues())
		--self.powerFlashBar:SetValue( cost)
		self.Power.tick 	=  0.5
		self.Power.startTime= GetTime()
		self.Power.predictedPowerCost = cost;
		self.Power:SetScript("OnUpdate", updateFlash)
	else
		self.Power.powerFlashBar:SetMinMaxValues( 0 ,0)
		self.Power.powerFlashBar:SetValue( 0)
		self.Power:SetScript("OnUpdate", nil)
	end
end

local function healthUpdate( f, event, unit)
	local thText
	local absorb = UnitGetTotalAbsorbs( unit) or 0
	local absorbText = absorb > 0 and "|cffffff00 " .. nums( absorb).. "|r" or ""

	local healthMax = UnitHealthMax( unit)
	local healthCur = UnitHealth( unit)

	if not UnitIsConnected( unit) then
		thText = "Off"
	elseif UnitIsDead( unit) then
        thText = "Dead"
	elseif UnitIsGhost( unit) then
        thText = "Ghost"
	else
		if unit == "targettarget" or unit == "pet"  or unit == "focus" or unit == "focustarget" then
			--thText = math.ceil( UnitHealth( unit) / UnitHealthMax( unit) * 100) .. "%"
			thText = ""
		else
			if healthCur == healthMax then
				thText = nums( healthCur)
			else
				thText = nums( healthCur) .. absorbText .. " | " .. ceil( healthCur / healthMax * 100) .. "%"
			end
		end
    end

    f.Health.healthText:SetText( thText)
	f.Health:SetMinMaxValues( 0, healthMax + absorb)

	if f.Health.AbsorbBar then
		f.Health.AbsorbBar:SetMinMaxValues( 0, healthMax)-- + absorb)
		f.Health.AbsorbBar:SetValue( absorb)
	end

	if not UnitIsConnected(unit) then
		f.Health:SetValue( healthMax + absorb)
	else
		f.Health:SetValue( healthCur + absorb)
	end
end

local function updateTOTAuras( self, unit)
	local index, fligerPD = 1, 1
	local filter = UnitPlayerControlled( unit) and "HARMFUL" or "HELPFUL"

	while true and fligerPD < self.pDebuff.count do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if not N.blackSpells[spellID] then
			local aIcon	= CreateAuraIcon( self.pDebuff, fligerPD, false, "BOTTOM") --end
			UpdateAuraIcon( aIcon, filter, icon, count, nil, duration, expirationTime, spellID, index, unit)
			fligerPD = fligerPD + 1
		end

		index = index + 1
	end

	for index = fligerPD, #self.pDebuff	do self.pDebuff[index]:Hide()   end
end

local function powerUpdate( f, unit, pmin, min, pmax)
	local uPP, uPText

	if myClass == "WARLOCK" and mySpec == 3 then
		pmin, pmax = UnitPower( unit, 7, true), 10
		pmin = mod( pmin, 10)
	end

	if pmin >= 1 then uPP = math.floor( pmin / pmax * 100) else uPP = 0 end

    if UnitIsDead( unit) or unit == "targettarget" or unit == "focus" or unit == "focustarget" or unit == "pet" or not UnitIsConnected( unit) or UnitIsGhost( unit) or pmin == 0 then
        uPText = ""
	elseif f.isboss then
		uPText = uPP .. "%"
    else
    	if pmin == pmax then
    		uPText = nums( pmin)
    	else
    		if myClass == "WARLOCK" and mySpec == 3 then
				uPText = nums( pmin) .. " | 10"
   			else
   				uPText = nums( pmin) .. " | " .. uPP .. "%"
   			end
   		end
   	end

	f.powerText:SetText( uPText)
	f:SetMinMaxValues( 0, pmax)
	f:SetValue( pmin)
	f.powerMax = pmax
end

local function powerColor( f, unit, cur, min, max, displayType, event)
	local cols = colors.disconnected

	if unit == "targettarget" and event == "OnUpdate" then updateTOTAuras( f, unit) --return
	elseif event:match( "UNIT_POWER_") then return end

	--f.dead = false
	if not UnitIsConnected( unit) then
		cols = colors.disconnected
	elseif UnitIsDead( unit) or UnitIsGhost( unit) then
		--f.dead = UnitIsDeadOrGhost( unit)
		cols = colors.disconnected
	elseif UnitIsPlayer( unit) then
		cols = colors.class[select( 2,UnitClass( unit))]
	elseif UnitIsTapDenied( unit) then
		cols = colors.tapped
	elseif f:GetParent().isboss then
		cols = colors.reaction[UnitReaction( unit, "player")]
	elseif UnitReaction( unit, 'player') or UnitPlayerControlled( unit) then
		cols = colors.reaction[UnitReaction( unit, "player")]
	end

	f.colr, f.colg, f.colb = cols[1], cols[2], cols[3]
	f:GetParent().colr, f:GetParent().colg, f:GetParent().colb = cols[1], cols[2], cols[3]

	f:SetStatusBarColor( f.colr, f.colg, f.colb, 1)
	f.bgPower:SetVertexColor( f.colr, f.colg, f.colb, 0.2)
	f.powerText:SetTextColor( f.colr, f.colg, f.colb, 1)
	if UnitPowerMax( unit) == 0 then f:Hide() else f:Show() end

	if yo.Raid.classcolor == 1 then
		local fader = 0.7
		local dark  = 0.5
		f:GetParent().Health:SetStatusBarColor( f.colr * fader, f.colg * fader, f.colb * fader, 0.9)
		f:GetParent().Health.hbg:SetVertexColor( 0.1, 0.1, 0.1, 0.9)
		if unit == "player" or unit == "target" or unit == "pet" then
			f:GetParent().Health.AbsorbBar:SetStatusBarColor( f.colr * dark, f.colg * dark, f.colb * dark , 0.9)
		end
	elseif yo.Raid.classcolor == 2 then
		local fader = 0.7
		local dark  = 0.5
		f:GetParent().Health:SetStatusBarColor( f.colr * fader, f.colg * fader, f.colb * fader, 1)
		f:GetParent().Health.hbg:SetVertexColor( 0.8, 0.8, 0.8, 0.9)
		if unit == "player" or unit == "target" or unit == "pet" then
			f:GetParent().Health.AbsorbBar:SetStatusBarColor( f.colr * dark, f.colg * dark, f.colb * dark , 0.9)
		end
	else
		f:GetParent().Health:SetStatusBarColor( 0.13, 0.13, 0.13, 0.9)
		f:GetParent().Health.hbg:SetVertexColor( 0.5, 0.5, 0.5, 0.9)
		if unit == "player" or unit == "target" or unit == "pet" then
			f:GetParent().Health.AbsorbBar:SetStatusBarColor( 0.25, 0.25, 0.25, 0.9)
		end
	end

	if f:GetParent().holyShards then f:GetParent().holyShards:recolorShards( cols) end
end

------------------------------------------------------------------------------------------------------
---											BEGIN
------------------------------------------------------------------------------------------------------

local function Shared(self, unit)
	local cunit = (unit and unit:find("boss%d")) and "boss" or unit
	if cunit == "boss" then self.isboss = true end
	self.cunit 	= cunit
	self.colors = oUF_colors
	self.colors.disconnected = { 0.2, 0.2, 0.2}
	self:SetSize( _G["yo_Move" .. cunit]:GetSize())

	------------------------------------------------------------------------------------------------------
	---											HEALTH BAR
	------------------------------------------------------------------------------------------------------
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetAllPoints( self)
	self.Health:SetWidth( self:GetWidth())
	self.Health:SetStatusBarTexture( yo.texture)
	self.Health:SetFrameLevel( 1)
	----self.Health:SetStatusBarColor( 0.09, 0.09, 0.09, 0.9)
	--self.Health:SetStatusBarColor( 0.13, 0.13, 0.13, 0.9)
	self.Health:GetStatusBarTexture():SetHorizTile(false)
	self.Health.frequentUpdates = true
	table.insert( N.statusBars, self.Health)

	self.Health.hbg = self.Health:CreateTexture(nil, "BACKGROUND")		-- look 	AssistantIndicator.PostUpdate
	self.Health.hbg:SetAllPoints()
	self.Health.hbg:SetTexture( yo.texture)
	--self.Health.hbg:SetVertexColor( 0.5, 0.5, 0.5, 0.9)

	if yo.Raid.hpBarRevers 	 then self.Health:SetFillStyle( 'REVERSE'); end
	if yo.Raid.hpBarVertical then self.Health:SetOrientation( 'VERTICAL') 	end

	self.bgHlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.bgHlight:SetAllPoints()
	self.bgHlight:SetVertexColor( 0.4,0.4,0.4,0.9)
	self.bgHlight:SetTexture( texhl)
	self.bgHlight:SetBlendMode("ADD")
	self.bgHlight:SetAlpha(0.1)
	self.bgHlight:Hide()

--	if yo.Raid.classcolor == 1 then
--		cols = colors.class[select( 2,UnitClass( unit))]
--print(unit)
--		tprint( cols)
--		self.Health:SetStatusBarColor( 0.13, 0.13, 0.13, 0.9)
--		self.Health.hbg:SetVertexColor( 0.5, 0.5, 0.5, 0.9)

--	elseif yo.Raid.classcolor == 222 then
--		self.Health.colorSmooth = true
--		self.Health.colorReaction = true

--	else
--		self.Health:SetStatusBarColor( 0.13, 0.13, 0.13, 0.9)
--		self.Health.hbg:SetVertexColor( 0.5, 0.5, 0.5, 0.9)
--	end

	local AbsorbBar = CreateFrame('StatusBar', nil, self.Health)
	if unit == "player" or unit == "target" or unit == "pet" then
    	AbsorbBar:SetPoint('TOP')
    	AbsorbBar:SetPoint('BOTTOM')
    	AbsorbBar:SetPoint('RIGHT', self.Health:GetStatusBarTexture(), 'RIGHT')
    	AbsorbBar:SetWidth( self.Health:GetWidth())
		AbsorbBar:SetStatusBarTexture( yo.texture)
		AbsorbBar:SetFillStyle( 'REVERSE')
		--AbsorbBar:SetStatusBarColor( 0.25, 0.25, 0.25, 1)
		AbsorbBar:SetFrameLevel(2)
		self.Health.AbsorbBar = AbsorbBar
		self.Health.Override = healthUpdate
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", healthUpdate)
	end

------------------------------------------------------------------------------------------------------
---											POWER BAR
------------------------------------------------------------------------------------------------------

	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetPoint("BOTTOM", self, "BOTTOM", 0, 4)
	self.Power:SetStatusBarTexture( yo.texture)
	self.Power:SetFrameLevel( 5)
	self.Power:SetWidth( self:GetWidth() - 10)
	self.Power:SetHeight( 4)
	table.insert( N.statusBars, self.Power)

	self.Power.frequentUpdates = false
    self.Power.UpdateColor = powerColor
    self.Power.PostUpdate = powerUpdate

	self.Power.bgPower = self.Power:CreateTexture(nil, 'BORDER')
	self.Power.bgPower:SetAllPoints( self.Power)
	self.Power.bgPower:SetVertexColor( 0.4, 0.4, 0.4, 0.5)
	self.Power.bgPower:SetAlpha(0.2)
	self.Power.bgPower:SetTexture( yo.texture)

	if unit == "player" then
		local powerFlashBar = CreateFrame("StatusBar" , nil, self)
		powerFlashBar:SetPoint("TOPLEFT", self.Power:GetStatusBarTexture(),"TOPRIGHT", 0, 0);
		powerFlashBar:SetPoint("BOTTOMLEFT", self.Power:GetStatusBarTexture(),"BOTTOMRIGHT", 0, 0);
		powerFlashBar:SetStatusBarTexture( yo.texture)
		powerFlashBar:SetHeight( 4)
		powerFlashBar:SetWidth( self.Power:GetWidth())
		powerFlashBar:SetFrameLevel( 4)
		powerFlashBar:SetMinMaxValues(0, 0)
		powerFlashBar:SetValue( 0)
		self.Power.powerFlashBar = powerFlashBar
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", powerManaCost)
		table.insert( N.statusBars, powerFlashBar)

	elseif unit == "targettarget" then
		self.Power.pDebuff = CreateFrame("Frame", nil, self)
		self.Power.pDebuff:SetPoint("TOPLEFT", self, "BOTTOMLEFT",  0, -5)
		self.Power.pDebuff:SetWidth( 16) -- self:GetWidth())
		self.Power.pDebuff:SetHeight( 16)
		self.Power.pDebuff.direction 	= "RIGHT"
		self.Power.pDebuff.unit 		= "targettarget"
		self.Power.pDebuff.count 		= self:GetWidth() / self.Power.pDebuff:GetHeight()
	end

------------------------------------------------------------------------------------------------------
---											TEXTS
------------------------------------------------------------------------------------------------------

	self.nameText =  AbsorbBar:CreateFontString(nil ,"OVERLAY")
	self.nameText:SetFont( yo.font, yo.fontsize, "OUTLINE")
	self.nameText:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", 0, 3)
	if unit == "targettarget" or unit == "focustarget" or unit == "focus" then
			self:Tag( self.nameText, "[GetNameColor][unitLevel][nameshort][afk]")
	else	self:Tag( self.nameText, "[GetNameColor][unitLevel][namelong][afk]")end
	table.insert( N.strings, self.nameText)

	if unit ~= "pet" or unit ~= "targettarget" or unit ~= "focus" or unit ~= "focustarget" then
		self.Health.healthText =  AbsorbBar:CreateFontString(nil ,"OVERLAY")
		self.Health.healthText:SetFont( yo.font, yo.fontsize -1, "OUTLINE")
		self.Health.healthText:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -2)
		table.insert( N.strings, self.Health.healthText)

		self.Power.powerText =  AbsorbBar:CreateFontString(nil ,"OVERLAY")
		self.Power.powerText:SetFont( yo.font, yo.fontsize -1, "OUTLINE")
		self.Power.powerText:SetPoint("TOPRIGHT", self.Health.healthText, "BOTTOMRIGHT", 0, -3)
		table.insert( N.strings, self.Power.powerText)

		self.rText =  self:CreateFontString(nil ,"OVERLAY")
		self.rText:SetFont( yo.Media.fontpx, yo.fontsize, "OUTLINE")
		self.rText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 0)
		self:Tag( self.rText, "[GetNameColor][group]")
	end

------------------------------------------------------------------------------------------------------
---											ICONS
------------------------------------------------------------------------------------------------------

	self.RaidTargetIndicator = self:CreateTexture(nil,'OVERLAY')
    self.RaidTargetIndicator:SetPoint("CENTER", self, "TOP", 0, 2)
	self.RaidTargetIndicator:SetTexture("Interface\\AddOns\\yoFrame\\Media\\raidicons")
    self.RaidTargetIndicator:SetSize(16, 16)

    if cunit ~= "boss" or unit ~= "focustarget" then
    	self.LeaderIndicator = CreateFrame("Button", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    	self.LeaderIndicator:SetPoint("CENTER", self, "TOPLEFT", 15, 4)
		self.LeaderIndicator:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-LeaderIcon", })
    	self.LeaderIndicator:SetSize(10, 10)

		self.AssistantIndicator = CreateFrame("Button", nil, self, BackdropTemplateMixin and "BackdropTemplate")
    	self.AssistantIndicator:SetPoint("CENTER", self.LeaderIndicator, "CENTER", 0, 0)
		self.AssistantIndicator:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-AssistantIcon"})
    	self.AssistantIndicator:SetSize(10, 10)

    	self.ReadyCheckIndicator = self:CreateTexture(nil, 'OVERLAY')
    	self.ReadyCheckIndicator:SetSize( 17, 17)
    	self.ReadyCheckIndicator:SetPoint('LEFT', self, "CENTER", 20, 0)

    	self.ResurrectIndicator = self:CreateTexture(nil, 'OVERLAY')
    	self.ResurrectIndicator:SetSize( 20, 20)
    	self.ResurrectIndicator:SetPoint('CENTER', self, "CENTER", 0, 0)

    	self.SummonIndicator = self:CreateTexture(nil, 'OVERLAY')
    	self.SummonIndicator:SetSize(32, 32)
    	self.SummonIndicator:SetPoint('CENTER', self)
    end

	if unit == "player" or unit == "target" then
		self.PvPIndicator = self:CreateTexture(nil,'OVERLAY')
		self.PvPIndicator:SetPoint("CENTER", self, "CENTER", 0, 4)
		self.PvPIndicator:SetSize( 20, 20)
		self.PvPIndicator:SetAlpha( 0.7)
		self.PvPIndicator:SetDesaturated(true)

		--self.Badge = self:CreateTexture(nil, 'ARTWORK')
  --  	self.Badge:SetSize(50, 52)
  --  	self.Badge:SetPoint('CENTER', self.PvPIndicator, 'CENTER')
  --  	self.PvPIndicator.Badge = Badge
		--self.PvPIndicator:Hide()

		self.lfd = self:CreateFontString(nil ,"OVERLAY")
		self.lfd:SetFont( fontsymbol, yo.fontsize - 1)
		self.lfd:SetPoint( "RIGHT", self, "RIGHT", -1, -1)
		self.lfd:SetJustifyH( "LEFT")
		self:Tag( self.lfd, '[LFD]')
	end

	if unit == "player" then
		self.RestingIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.RestingIndicator:SetSize( 17, 17)
		self.RestingIndicator:SetPoint( "CENTER", self, "LEFT", 0, 6)
		self.RestingIndicator:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.RestingIndicator:SetTexCoord(0, .5, 0, .421875)

		self.CombatIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.CombatIndicator:SetSize( 15, 15)
		self.CombatIndicator:SetPoint( "CENTER", self, "LEFT", 0, 6)
		self.CombatIndicator:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
		self.CombatIndicator:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		self.CombatIndicator.PostUpdate = function( f, inCombat)
			if inCombat then self.RestingIndicator:Hide() elseif not inCombat and IsResting() then	self.RestingIndicator:Show()end end

	elseif unit == "target" and yo.healBotka.enable then
		N.makeQuiButton(self)

		--self.PhaseIndicator = self:CreateTexture(nil, 'OVERLAY')
	  	--self.PhaseIndicator:SetSize( 25, 25)
  		--self.PhaseIndicator:SetPoint('CENTER', self.PvPIndicator, "CENTER", 0, 0)

	elseif cunit == "boss" then
		self.tarBorder = self:CreateFontString(nil ,"OVERLAY", 'GameFontNormal')
		self:Tag( self.tarBorder, '[bossTarget]')
	end

------------------------------------------------------------------------------------------------------
---											BEFORE END
------------------------------------------------------------------------------------------------------
	--self:HookScript("OnShow", UpdateAllElements)
	self:UpdateTags()
	self:SetAlpha(1)
	self:SetFrameStrata("BACKGROUND")
	self:RegisterForClicks("AnyDown")
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	CreateStyle( self, 4)
	CreateStyle( self.Power, 2, 4, .3, .9)
end

------------------------------------------------------------------------------------------------------
---											END
------------------------------------------------------------------------------------------------------


local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if yo.Addons.unitFrames then
		oUF:RegisterStyle("yoFrames", Shared)
		oUF:SetActiveStyle("yoFrames")

		plFrame = oUF:Spawn("player", "yo_Player")
		plFrame:SetPoint( "CENTER", yo_Moveplayer, "CENTER", 0 , 0)

		tarFrame = oUF:Spawn("target", "yo_Target")
		tarFrame:SetPoint( "CENTER", yo_Movetarget, "CENTER", 0 , 0)

		totFrame = oUF:Spawn("targettarget", "yo_ToT")
		totFrame:SetPoint( "TOPLEFT", yo_Movetarget, "TOPRIGHT", 8 , 0)

		fcFrame = oUF:Spawn("focus", "yo_Focus")
		fcFrame:SetPoint( "CENTER", yo_Movefocus, "CENTER", 0 , 0)

		fctFrame = oUF:Spawn("focustarget", "yo_FocusTarget")
		fctFrame:SetPoint( "TOPLEFT", fcFrame, "TOPRIGHT", 7 , 0)

		petFrame = oUF:Spawn("pet", "yo_Pet")
		petFrame:SetPoint( "TOPRIGHT", yo_Moveplayer, "TOPLEFT", -8 , 0)

		local boses = {}
		for i = 1, MAX_BOSS_FRAMES do
			--boses[i] = "boss"..i.."Frame"
			boses[i] = oUF:Spawn( "boss" .. i, "yo_Boss" .. i)
			boses[i]:SetPoint( "CENTER", yo_Moveboss, "CENTER", 0 , -(i -1) * 65)

			UpdateAllElements( boses[i])
		end

		UpdateAllElements( plFrame)
		UpdateAllElements( tarFrame)
		UpdateAllElements( petFrame)
		--UpdateAllElements( fcFrame)
	end
end)


--local healthColorMode = "CLASS"
--health.colorClass = healthColorMode == "CLASS"
--health.colorReaction = healthColorMode == "CLASS"
--health.colorSmooth = healthColorMode == "HEALTH"