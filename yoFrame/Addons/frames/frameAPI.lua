local _, ns = ...
local oUF = ns.oUF or oUF
--local colors = oUF.colors
local L, yo, N = ns[1], ns[2], ns[3]

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch


local updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

local function frameOnEnter(f, event)

	if not f.bgHlight then
		f.bgHlight = f.Health:CreateTexture(nil, "OVERLAY")
		f.bgHlight:SetAllPoints()
		f.bgHlight:SetVertexColor( 0.4,0.4,0.4,0.9)
		f.bgHlight:SetTexture( texhl)
		f.bgHlight:SetBlendMode("ADD")
		f.bgHlight:SetAlpha(0.1)
		f.bgHlight:Show()
	else
		f.bgHlight:Show()
	end

	GameTooltip:SetOwner( f:GetParent(), "ANCHOR_NONE", 0, 0)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetUnit( f.unit)
	GameTooltip:Show()
end

local function frameOnLeave(f, event)
	if f.bgHlight then
		f.bgHlight:Hide()
	end
	if GameTooltip:IsShown() then
		GameTooltip:FadeOut(2)
	end
end

local function updatePowerBar ( power, event, unit)

	if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then return end

	local role = UnitGroupRolesAssigned( unit)
	if yo.Raid.manabar == 1 or ( role == "HEALER" and yo.Raid.manabar == 2 ) then --or power:GetName():match( "yo_Tanke")
		power.Power:SetAlpha( 1)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
			power.Power:SetValue( UnitPowerMax(unit))
		end
	else
		power.Power:SetAlpha(0)
		power.Power.Override = dummy
	end
end

local function onChangeTarget( self)

	local r, g, b, treatText = 0.09, 0.09, 0.09, ""
	local unit = self.unit
	local status = UnitThreatSituation( unit)

	if (status and status > 0) then
		r, g, b = GetThreatStatusColor(status)
	end
	self.shadow:SetBackdropBorderColor(r, g, b)

	if UnitIsUnit( unit, "target") then
		local _, class = UnitClass(unit)
		local t = self.colors.class[class]
		self.shadow:SetBackdropBorderColor( t[1], t[2], t[3])
		--if yo.Raid.simpeRaid then
			--self
		--end
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

local function updateManaCost(self, event, _, _, spellID) -- 240022
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
		self.Power:SetScript("OnUpdate", self.updateFlash)
	else
		self.Power.powerFlashBar:SetMinMaxValues( 0 ,0)
		self.Power.powerFlashBar:SetValue( 0)
		self.Power:SetScript("OnUpdate", nil)
	end
end

local function addDebuffHigh( self)
	self.DebuffHighlightMy = self.Health:CreateTexture(nil, "OVERLAY")
	self.DebuffHighlightMy:SetAllPoints(self.Health:GetStatusBarTexture())
	self.DebuffHighlightMy:SetTexture(texture)
	self.DebuffHighlightMy:SetVertexColor(0, 1, 0, 0)
	self.DebuffHighlightMy:SetBlendMode("BLEND")
	self.DebuffHighlightMyAlpha = 0.7
	self.DebuffHighlightMyFilter = yo.Raid.filterHighLight
end

local function addAbsorbBar( self)
	local AbsorbBar = CreateFrame('StatusBar', nil, self.Health)
   	AbsorbBar:SetPoint('TOP')
   	AbsorbBar:SetPoint('BOTTOM')
   	AbsorbBar:SetPoint('RIGHT', self.Health:GetStatusBarTexture(), 'RIGHT')
   	AbsorbBar:SetWidth( self.Health:GetWidth())
	AbsorbBar:SetStatusBarTexture( yo.texture)
	AbsorbBar:SetFillStyle( 'REVERSE')
	AbsorbBar:SetFrameLevel(2)
	self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", self.updateHealth)
	table.insert( N.statusBars, AbsorbBar)
	return AbsorbBar
end

local function addHealPred( self)
	local healPred = CreateFrame('StatusBar', nil, self.Health)
    healPred:SetPoint('TOP')
    healPred:SetPoint('BOTTOM')
    healPred:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    healPred:SetWidth( self.Health:GetWidth())
	healPred:SetStatusBarTexture( yo.texture)
	healPred:SetStatusBarColor( 0.3, 0.9, 0.3, 0.6)
	healPred:SetFrameLevel(2)
	table.insert( N.statusBars, healPred)

	self:RegisterEvent("UNIT_HEAL_PREDICTION", self.updateHealth)
	self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", self.updateHealth)
	return healPred
end

local function updatePower( f, unit, pmin, min, pmax)
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


local function updateTOTAuras( self, f, unit)

	if f.tickTOT - GetTime() > - 0.7 then return end
	f.tickTOT = GetTime()

	local index, fligerPD = 1, 1
	local filter = UnitPlayerControlled( unit) and "HARMFUL" or "HELPFUL"

	while true and fligerPD < f.pDebuff.count do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end

		if not N.blackSpells[spellID] then
			local aIcon	= CreateAuraIcon( f.pDebuff, fligerPD, false, "BOTTOM") --end
			UpdateAuraIcon( aIcon, filter, icon, count, nil, duration, expirationTime, spellID, index, unit)
			fligerPD = fligerPD + 1
		end

		index = index + 1
	end

	for index = fligerPD, #f.pDebuff	do f.pDebuff[index]:Hide()   end
end

local function updateThreat( f, unit)

	if f.threat and not unit:find( "target")  then
		local treatText, procText = "", ""
		local status = UnitThreatSituation( unit)
		if status then
			local r, g, b = GetThreatStatusColor(status)
			local _, _, scaledPercent, rawPercent, threatvalue  = UnitDetailedThreatSituation( unit, unit .. "target")

			if scaledPercent and yo.Raid.showPercTreat == "scaledPercent" then
				procText = " (" .. Round(scaledPercent) .. "%)"
			elseif rawPercent and yo.Raid.showPercTreat == "rawPercent" then
				procText = " (" .. Round(rawPercent) .. "%)"
			end

			if threatvalue then
				treatText =  format( "%s%s", ShortValue(threatvalue), procText)
			end

			f.threat:SetTextColor( r, g, b)
		end

		f.threat:SetText( treatText)
	end
end

local function updateAllTarget( self, elapsed)
	self.tick = self.tick + elapsed
	if self.tick > 0.5 then
		self.tick = 0

		self.updateAllElements( self)
		--local unit 		= self.unit
		--local healthMax = UnitHealthMax( unit)
		--local healthCur	= UnitHealth( unit)

		--self.Health:SetMinMaxValues( 0, healthMax)
		--self.Health:SetValue( healthCur)
	end
end

local function updateHealth( f, event, unit)
	local unit 			= unit or f.unit
	local healthMax 	= UnitHealthMax( unit)
	local healthCur 	= UnitHealth( unit)
	local absorb 		= UnitGetTotalAbsorbs( unit) or 0

	local stoperc 		= f:GetWidth() / ( healthMax + absorb + 0.01)
	local perc 			= stoperc * absorb --healthMax

	if f.Health.healthText then
		local thText = ""

		if not UnitIsConnected( unit) then
			thText = "Off"
		elseif UnitIsDead( unit) then
        	thText = "Dead"
		elseif UnitIsGhost( unit) then
        	thText = "Ghost"
		else
			if healthCur == healthMax 	then
				thText = nums( healthCur)
			elseif f.simpleUF then
				thText = Round( healthCur / healthMax * 100) .. "%"
				--thText = nums( healthCur)
			else
				local absorbText 	= absorb > 0 and "|cffffff00 " .. nums( absorb).. "|r" or ""
				thText = nums( healthCur) .. absorbText .. " | " .. Round( healthCur / healthMax * 100) .. "%"
			end
    	end

		f.Health.healthText:SetText( thText)
	end

	if yo.UF.hideOldAbsorb then
		absorb 	= 0
	end

	f.Health:SetMinMaxValues( 0, healthMax + absorb)

	if f.Health.AbsorbBar then
		f.Health.AbsorbBar:SetMinMaxValues( 0, healthMax + absorb)
		f.Health.AbsorbBar:SetValue( absorb)
	end

	if f.Health.stoper then
		--f.Health.stoper:ClearAllPoints()
		--f.Health.stoper:SetPoint("LEFT", f, "LEFT", perc, 0)
		f.Health.stoper:SetWidth(perc)
	end

	if f.Health.healPred then
		local incomingHeal 	= UnitGetIncomingHeals(unit) or 0
		f.Health.healPred:SetMinMaxValues(0, healthMax)
		f.Health.healPred:SetValue( min( incomingHeal, healthMax - healthCur))
		f.Health.healPred:Show()
	end

	if not UnitIsConnected(unit) then
		f.Health:SetValue( healthMax + absorb)
	else
		f.Health:SetValue( healthCur + absorb)
	end

	updateThreat( f, unit)
end


local function updateHealthColor( f, event, unit, ...)

	if f.Power and unit == "targettarget" and event == "OnUpdate" then f:updateTOTAuras( f.Power, unit) end--return
	if event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then return end

	local cols = f.colors.disconnected or ( { 1, 1, 1} )

	--f.dead = false
	if not UnitIsConnected( unit) then
		cols = f.colors.disconnected
	elseif UnitIsDead( unit) or UnitIsGhost( unit) then
		cols = f.colors.disconnected
	elseif UnitIsTapDenied( unit) then --	elseif not UnitPlayerControlled(unit) and UnitIsTapDenied( unit) then
		cols = f.colors.tapped
	elseif f:GetParent().isboss then
		cols = f.colors.reaction[UnitReaction( unit, "player")]
	elseif UnitIsPlayer( unit) and select( 2,UnitClass( unit)) then
		cols = f.colors.class[select( 2,UnitClass( unit))]
	elseif UnitReaction( unit, 'player') or UnitPlayerControlled( unit) then
		cols = f.colors.reaction[UnitReaction( unit, "player")]
	end

	if not cols then print( "ЖОПА!") end
	if not cols[1] then print( "Большая ЖОПА!") end

	f.colr, f.colg, f.colb = cols[1] or 1, cols[2] or 1, cols[3] or 1

	if f.Power then
		f.Power.colr, f.Power.colg, f.Power.colb = cols[1], cols[2], cols[3]
		f.Power:SetStatusBarColor( f.colr, f.colg, f.colb, 1)
		f.Power.bg:SetVertexColor( f.colr, f.colg, f.colb, 0.2)
		if UnitPowerMax( unit) == 0 then f.Power:Hide() else f.Power:Show() end
		if f.Power.powerText then f.Power.powerText:SetTextColor( f.colr, f.colg, f.colb, 1) end
	end

	if f.holyShards then f.holyShards:recolorShards( cols) end

	if yo.Raid.classcolor == 1 then
		f.Health:SetStatusBarColor( f.colr * f.fader, f.colg * f.fader, f.colb * f.fader, 0.9)
		f.Health.hbg:SetVertexColor( 0.1, 0.1, 0.1, 0.9)
		if f.Health.AbsorbBar then
			f.Health.AbsorbBar:SetStatusBarColor( f.colr * f.darkAbsorb, f.colg * f.darkAbsorb, f.colb * f.darkAbsorb , 0.9)
		end
	elseif yo.Raid.classcolor == 2 then
		f.Health:SetStatusBarColor( f.colr * f.fader, f.colg * f.fader, f.colb * f.fader, 1)
		f.Health.hbg:SetVertexColor( 0.8, 0.8, 0.8, 0.9)
		if f.Health.AbsorbBar then
			f.Health.AbsorbBar:SetStatusBarColor( f.colr * f.darkAbsorb, f.colg * f.darkAbsorb, f.colb * f.darkAbsorb , 0.9)
		end
	else
		if not UnitIsConnected( unit) then
			cols = f.colors.disconnected
		else
			cols = { 0.13, 0.13, 0.13} --{ 0.09, 0.09, 0.09}
		end

		f.Health:SetStatusBarColor( cols[1], cols[2], cols[3], 0.9)
		f.Health.hbg:SetVertexColor( 0.45, 0.45, 0.45, 0.9)
		if f.Health.AbsorbBar then
			f.Health.AbsorbBar:SetStatusBarColor( 0.3, 0.3, 0.3, 0.9)
		end
	end
	if f.Health.stoper then
		f.Health.stoper:SetStatusBarColor( f.colr * f.darkAbsorb, f.colg * f.darkAbsorb, f.colb * f.darkAbsorb , 0.9)
	end
end

function importAPI( self)
	self.updateHealthColor 	= updateHealthColor
	self.updateHealth 		= updateHealth
	self.updateAllTarget 	= updateAllTarget
	self.updatePower 		= updatePower
	self.updatePowerBar 	= updatePowerBar
	self.updateTOTAuras 	= updateTOTAuras
	self.updateFlash 		= updateFlash
	self.updateAllElements	= updateAllElements
	self.updateManaCost 	= updateManaCost
	self.addHealPred 		= addHealPred
	self.addAbsorbBar		= addAbsorbBar
	self.addDebuffHigh 		= addDebuffHigh
	self.frameOnLeave 		= frameOnLeave
	self.frameOnEnter 		= frameOnEnter
	self.onChangeTarget 	= onChangeTarget
end