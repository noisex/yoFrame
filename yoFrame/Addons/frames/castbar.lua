local L, yo, N = unpack( select( 2, ...))

if not yo.Addons.unitFrames then return end


local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch


--/dump GetCVar("SpellQueueWindow") – чтобы узнать текущее значение
--/console spellqueuewindow 200 – чтобы установить значение 200
--/cqs
--/cancelqueuedspell
--/cast Команда «Взять!»
-- do unterapt text
-- do latency text

local cfg = {}

local function DisableBlizzardFrame( f)
	f.RegisterEvent = noop
	f.Show = noop
	f:UnregisterAllEvents()
	f:Hide()
end

local function FadingOut( f)
	--print( ...)
	local now = GetTime()
	local alpha = f.fadeDuration - (now - f.endTime)
	if alpha > 0 then
		f:SetAlpha( math.min( alpha, 1.0))
	else
		f:SetScript('OnUpdate', nil)
		f:Hide()
	end
end

function spellDelay( self)
	for spellID, _ in pairs( N.interuptSpells) do
		local _, duration = GetSpellCooldown( spellID)
		if duration ~= 0 then
			return false
		end
	end
	return true
end

local function UnitColors( f)
	local cols = {}
	local unit = f.unit

	if f.classcolor then
		if UnitIsPlayer( unit) then
			cols = f.colors.class[select( 2, UnitClass( unit))]
		else --if UnitReaction( unit, 'player') or UnitPlayerControlled( unit) then
			cols = f.colors.reaction[ UnitReaction( unit, "player")]
		end
	else
		--print( f.notInterruptible)
		if f.notInterruptible then
			cols[1], cols[2], cols[3] = 0.8, 0.15, 0.25
		else
			if spellDelay() then
				cols[1], cols[2], cols[3] = 0.5, 1, 0
			else
				cols[1], cols[2], cols[3] = 0, 1, 1
			end
		end
	end

	f:SetStatusBarColor( cols[1], cols[2], cols[3]	, 1)
end

local function TimerUpdate( f)
	if f.spellDelay ~= yo.General.spellDelay then UnitColors( f)	end

	local now = GetTime()

	if f.reversed then
		f:SetValue(f.endTime - now)
	else
		f:SetValue(now - f.startTime)
	end
end

local function stopCast( f, unit, ...)
	if unit and unit ~= f.unit then return end

	f.spellID = nil
	if f.latency then f.latency:Hide() end
	if f.ibg and f.ibg:IsShown() then f.ibg:Hide() end

	f.spark:Hide()
	f:SetValue( f.reversed and 0 or ( f.endTime or GetTime()))	-- - f.startTime))
	f.endTime = GetTime()
	f:SetScript('OnUpdate', FadingOut)
end

---------------------------------------------------------------------------------------
-- 												START CAST
---------------------------------------------------------------------------------------

local function startCast( f, unit, ...)

	if f.castBoss and f.isBoss then unit = f.secondUnit end

	if unit and unit ~= f.unit then return end

	if not UnitExists( unit) then
		f:SetScript('OnUpdate', nil)
		--stopCast( f, f.unit)
		print( "NO BOSS")
	end

	local name,  texture, startTime, endTime, notInterruptible, spellID

	if f.reversed then
		if unit == "player" then
			f.latSpell:Hide()
			f.latency = f.latChan
		end
		name, _, texture, startTime, endTime, _, notInterruptible = UnitChannelInfo( unit)
		spellID = "CHANNEL"
	else
		if unit == "player" then
			f.latChan:Hide()
			f.latency = f.latSpell
		end
		name,  _, texture, startTime, endTime, _, _, notInterruptible, spellID = UnitCastingInfo( unit)
	end

	if not name then return end

	local iconincombat = 	f.iconincombat
	local treatborder = 	f.treatborder

	if f.ibg and ( iconincombat == true or ( iconincombat == false and f.inCombat == false)) then

		if texture then
			f.icon:SetTexture( texture)
			f.ibg:Show( )
		else
			f.ibg:Hide()
		end
	end

	if notInterruptible then
		f.notInterruptible = true
		if f.ibg and f.ibg:IsShown() then
			f.ibg.shadow:SetBackdropBorderColor( 1, 0, 0, 1)
		end
		if treatborder then
			f.shadow:SetBackdropBorderColor( 1, 0, 0, 1)
		else
			f.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
	else
		f.notInterruptible = false
		if f.ibg and f.ibg:IsShown() then
			f.ibg.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
		if treatborder then
			f.shadow:SetBackdropBorderColor( 0, 1, 0, 1)
		else
			f.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
	end

	f.fadeDuration 	= 1.0
	f.spellID 		= spellID
	f.endTime 		= endTime/1000
	f.startTime 	= startTime/1000
	f.max 			= ( endTime - startTime) / 1000
	f.spellDelay 	= yo.General.spellDelay

	f:SetMinMaxValues(0, f.endTime - f.startTime)
	if unit ~= "focus" then
		f.nameText:SetText( utf8sub( name, f:GetWidth() / 10, true))
	else
		f.nameText:SetText( utf8sub( name, f:GetWidth() / 7, false))
	end

	if f.latency then
		--local delay = select( 4, GetNetStats()) / 1000
		local delay =  GetCVar("SpellQueueWindow") / 1000
		f.latency:SetWidth( f:GetWidth() * min( delay / ( f.endTime - f.startTime), 1.0))
		f.latency:Show()
	end

	if unit ~= "focus" then f.spark:Show()	end

	f:SetScript('OnUpdate', TimerUpdate)
	f:SetAlpha( 1)
	UnitColors( f, unit)
	f:Show()
end

function hideTicks( self)
	for i = 1, #self.ticks do
		self.ticks[i]:Hide()
	end
	self.ticked = false
end

local function createTicks( self, extraTickRatio)
	extraTickRatio = extraTickRatio or 0

	local d = self:GetWidth() / ( self.numTicks + extraTickRatio)

	for i = 1, self.numTicks do
		if not self.ticks[i] then
			self.ticks[i] = self:CreateTexture(nil, 'OVERLAY')
			self.ticks[i]:SetTexture( texture)
			self.ticks[i]:SetVertexColor( 0.09, 0.09, 0.09, 0.5)
			self.ticks[i]:SetWidth( 2)
			self.ticks[i]:SetHeight( self:GetHeight())
		end

		self.ticks[i]:ClearAllPoints()
		self.ticks[i]:SetPoint('RIGHT', self, 'LEFT', d * i, 0)
		self.ticks[i]:Show()
		self.ticked = true
	end
end

local function makeTicks( self, empty, spellID)

	self.numTicks = N.channelTicks[spellID] and N.channelTicks[spellID] or 0
	hideTicks( self)

	if self.numTicks > 0 then
		local extraTickRatio

		if spellID == 198590 then
			local curHaste = UnitSpellHaste('player') * 0.01
			local baseTickSize = 1
			local hastedTickSize = baseTickSize / (1 +  curHaste)
			local extraTick = self.max - hastedTickSize * (self.numTicks)
			extraTickRatio = extraTick / hastedTickSize
		end

		createTicks( self, extraTickRatio)
	end
end

local function OnEvent( f, event, unit, ...)
	--print(event, unit, f.unit, f.cfgname, f.isBoss, f.castBoss)

	if event == "PLAYER_TARGET_CHANGED" then
		if f.unit == "target" then
			if UnitExists( "target") then
				if UnitCastingInfo( f.unit) then
					f.reversed = false
					startCast( f, f.unit, ...)
				elseif UnitChannelInfo( f.unit) then
					f.reversed = true
					startCast( f, f.unit, ...)
				elseif f:IsShown() then
					f.castId = nil
					f:Hide()
				end
			elseif f:IsShown() then
				f.castId = nil
				f:Hide()
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		f.inCombat = false
	elseif event == "PLAYER_REGEN_DISABLED" then
		f.inCombat = true

	elseif event == "ENCOUNTER_END" then
		stopCast( f, unit, ...)
		if f.castBoss then
			f.isBoss = false
			f.unit = f.firstUnit
		end

	elseif event == "ENCOUNTER_START" then
		if f.castBoss then
			f.isBoss = true
			f.unit = f.secondUnit
		end

	end

	if unit == f.unit then

		if event == "UNIT_SPELLCAST_START" then
			f.reversed = false
			startCast( f, unit, ...)
			if unit == "player" and f.ticked then hideTicks( f) end

		elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			f.reversed = true
			startCast( f, unit, ...)
			if unit == "player" then makeTicks( f, ...) end

		elseif event == "UNIT_SPELLCAST_STOP" then
			stopCast( f, unit, ...)
		elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			stopCast( f, unit, ...)
		elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
			f:SetStatusBarColor( 1, 0, 0, 1)
			--f.nameText:SetText( f.nameText:GetText() .. "|cffff0000 (interupt)")
			--f.bgcBar:SetVertexColor( 1, 0, 0, 1)
			--stopCast( f, unit, ...)
			--print(GetTime(), f, unit, ...)

		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			yo.General.spellDelay = spellDelay()
		end
	end
end

local function OnBarValuesChange(f)
	if not f:IsShown() then return end
	local current, width, min, max = f:GetValue(), f:GetWidth(), f:GetMinMaxValues()

	if f.unit ~= "focus" then
		f.timeText:SetFormattedText("%.1f / %.2f", current-min, max-min)
		f.spark:SetPoint("CENTER", f, "LEFT", width * (current-min) / (max-min), 0)
	end
end

function CreateCastBar( frame, cfg)
	if not frame or not cfg.enable then return end

	local width 		= cfg.width
	local height 		= cfg.height
	local unit 			= cfg.unit
	local isicon 		= cfg.icon
	local point 		= cfg.point
	local iconSize 		= cfg.iconSize
	local iconoffsetX 	= cfg.iconoffsetX
	local iconoffsetY 	= cfg.iconoffsetY
	local cfgname 		= cfg.cfgname

	local bar = CreateFrame("Frame", nil, frame)

	bar.castBar = CreateFrame("StatusBar", nil, bar)
	bar.castBar:SetPoint( unpack( point))
	bar.castBar:SetStatusBarTexture( texture)
	bar.castBar:SetHeight( height)
	bar.castBar:SetWidth( width)
	bar.castBar:SetFrameLevel( 12)
	table.insert( N.statusBars, bar.castBar)

	bar.castBar.unit 		= unit
	bar.castBar.noLag 		= noLag
	bar.castBar.inCombat 	= false
	bar.castBar.cfgname 	= cfgname
	bar.castBar.classcolor 	= cfg.classcolor
	bar.castBar.treatborder	= cfg.treatborder
	bar.castBar.iconincombat= cfg.iconincombat
	bar.castBar.fadeDuration= cfg.fadeDuration or 1.5

	bar.castBar.bgcBar = bar.castBar:CreateTexture(nil, 'BACKGROUND')
	bar.castBar.bgcBar:SetAllPoints( bar.castBar)
	bar.castBar.bgcBar:SetVertexColor(0.09, 0.09, 0.09, 1)
	bar.castBar.bgcBar:SetTexture( texture)

	--bar.castBar.shield = bar.castBar:CreateTexture(nil, 'BACKGROUND')
	--bar.castBar.shield:SetPoint( "RIGHT", bar.castBar, "LEFT", -4, 0)
	--bar.castBar.shield:SetVertexColor(0.09, 0.09, 0.09, 1)
	--bar.castBar.shield:SetSize( height * 1.3, height * 1.3)
	--bar.castBar.shield:SetAtlas("nameplates-InterruptShield")
	--bar.castBar.shield:SetTexture("Interface\\AddOns\\yoFrame\\Media\\Shield");

	--bar.castBar.shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield");
	--bar.castBar.shield:SetTexCoord(0.00, 0.145, 0, 1.00);
	--bar.castBar.shield:SetSize( 70, 100)

	bar.castBar.nameText =  bar.castBar:CreateFontString(nil ,"OVERLAY")
	bar.castBar.nameText:SetFont( font, max( 10, height * 0.65), "OUTLINE")
	bar.castBar.nameText:SetPoint("LEFT", bar.castBar, "LEFT", 2, 0)

	bar.castBar.timeText =  bar.castBar:CreateFontString(nil ,"OVERLAY")
	bar.castBar.timeText:SetFont( font, max( 10, height * 0.65), "OUTLINE")
	bar.castBar.timeText:SetPoint("RIGHT", bar.castBar, "RIGHT", -2, 0)

	bar.castBar.spark = bar.castBar:CreateTexture(nil, "OVERLAY")
	bar.castBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.castBar.spark:SetBlendMode('ADD')
	bar.castBar.spark:SetWidth(20)
	bar.castBar.spark:SetHeight( height*2.2)
	bar.castBar.spark:SetPoint("CENTER", bar.castBar, "LEFT", 0, 0)
	bar.castBar.spark:Hide()

	if unit == "player" then
		bar.castBar.latSpell = bar.castBar:CreateTexture(nil, "OVERLAY")
		bar.castBar.latSpell:SetColorTexture(0.7, 0.1, 0.1, 0.8)
		bar.castBar.latSpell:SetBlendMode("BLEND")
		bar.castBar.latSpell:SetHeight( height)
		bar.castBar.latSpell:SetAlpha(0.5)
		bar.castBar.latSpell:SetPoint("RIGHT", bar.castBar, "RIGHT", 0, 0)

		bar.castBar.latChan = bar.castBar:CreateTexture(nil, "OVERLAY")
		bar.castBar.latChan:SetColorTexture(0.7, 0.1, 0.1, 0.8)
		bar.castBar.latChan:SetBlendMode("BLEND")
		bar.castBar.latChan:SetHeight( height)
		bar.castBar.latChan:SetAlpha(0.5)
		bar.castBar.latChan:SetPoint("LEFT", bar.castBar, "LEFT", 0, 0)

		bar.castBar:RegisterEvent("PLAYER_REGEN_ENABLED")
		bar.castBar:RegisterEvent("PLAYER_REGEN_DISABLED")
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

		bar.castBar.ticks = {}
	end

	if isicon then
		bar.castBar.ibg = CreateFrame("Frame", "BACKGROUND", bar.castBar)
		bar.castBar.ibg:SetPoint("CENTER", bar.castBar,"CENTER", iconoffsetX, iconoffsetY);
		bar.castBar.ibg:SetSize( iconSize, iconSize)
		bar.castBar.ibg:SetFrameLevel( 10)
		bar.castBar.ibg:Hide()

		bar.castBar.icon =  bar.castBar.ibg:CreateTexture(nil, "BORDER")
		bar.castBar.icon:SetAllPoints( bar.castBar.ibg)
		bar.castBar.icon:SetTexCoord(unpack( yo.tCoord))
		CreateStyle( bar.castBar.ibg, 3)
	end

	if cfgname == "BCB" then bar:SetAlpha( yo.CastBar.BCB.castbarAlpha) end
	if unit == "target" then
		bar.castBar:RegisterEvent("PLAYER_TARGET_CHANGED")
	end

	if unit == "player" then
		DisableBlizzardFrame(CastingBarFrame)
	elseif unit == "target" or unit == "boss1" then
		DisableBlizzardFrame(TargetFrameSpellBar)
	elseif unit == "focus" then
		DisableBlizzardFrame(FocusFrameSpellBar)
	elseif unit == "pet" then
		DisableBlizzardFrame(PetCastingBarFrame)
	end

	CreateStyle( bar.castBar, 3)
	GetColors( bar.castBar)

	bar.castBar:Hide()
	frame.castbar = bar.castBar

	if cfgname == "BCB" and cfg.castBoss then

		bar.castBar.castBoss	= cfg.castBoss
		bar.castBar.firstUnit 	= unit
		bar.castBar.secondUnit 	= "boss1"

		if cfg.castBoss and UnitExists("boss1") then
			bar.castBar.isBoss 	= true
			bar.castBar.unit 	= bar.castBar.secondUnit
		end

		bar.castBar:RegisterEvent("ENCOUNTER_END")
		bar.castBar:RegisterEvent("ENCOUNTER_START")
		bar.castBar:RegisterEvent("PLAYER_TARGET_CHANGED")

		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_START", unit, bar.castBar.secondUnit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit, bar.castBar.secondUnit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit, bar.castBar.secondUnit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit, bar.castBar.secondUnit)

		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit, bar.castBar.secondUnit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit, bar.castBar.secondUnit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit, bar.castBar.secondUnit)
	else
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_START", unit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit)

		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit)
		bar.castBar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit)
	end

	bar.castBar:SetScript('OnMinMaxChanged', OnBarValuesChange)
	bar.castBar:SetScript('OnValueChanged', OnBarValuesChange)
	bar.castBar:SetScript('OnShow', OnBarValuesChange)
	bar.castBar:SetScript('OnEvent', OnEvent)
end




local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if not yo.Addons.unitFrames or not yo_Player then return end

	cfg 		= yo.CastBar.target
	cfg.width	= tarFrame:GetWidth()
	cfg.point	= { "BOTTOM", tarFrame, "TOP", 0, 8}
	CreateCastBar( tarFrame, cfg)

	if yo.CastBar.player.bigBar then
		cfg 		= yo.CastBar.player
		cfg.width 	= yo_MovePlayerCastBar:GetWidth()
		cfg.height 	= yo_MovePlayerCastBar:GetHeight()
		cfg.point 	= { "CENTER", yo_MovePlayerCastBar, "CENTER", 0, 0}
	else
		cfg 			= yo.CastBar.target
		cfg.width		= plFrame:GetWidth()
		cfg.unit 		= "player"
		cfg.point		= { "BOTTOM", plFrame, "TOP", 0, 8}
		cfg.classcolor	= yo.CastBar.player.classcolor
		cfg.icon 		= yo.CastBar.player.icon
		cfg.iconincombat= yo.CastBar.player.iconincombat
	end
	CreateCastBar( plFrame, cfg)

	cfg 		= yo.CastBar.focus
	cfg.width	= fcFrame:GetWidth()
	cfg.point 	= { "BOTTOM", fcFrame, "TOP", 0, 8}
	CreateCastBar( fcFrame, cfg)

	cfg 		= yo.CastBar.BCB
	cfg.cfgname = "BCB"
	cfg.point	= { "CENTER", UIParent, "CENTER", cfg.offsetX, cfg.offsetY}
	yo_castBig = CreateFrame("Frame", "yo_castBig", UIParent)
	CreateCastBar( yo_castBig, cfg)

	cfg 		= yo.CastBar.boss
	cfg.width 	= yo_Moveboss:GetWidth()
	for i = 1, MAX_BOSS_FRAMES do
		local bFrame = _G["yo_Boss"..i]
		cfg.point	= { "BOTTOM", bFrame, "TOP", 0, 6}
		cfg.unit	= "boss"..i
		CreateCastBar( bFrame, cfg)
	end
end)

 PetCastingBarFrame:HookScript( "OnShow", function(self, ...)
	if not self.shadow and UnitControllingVehicle("player") then
		self.Flash:SetTexture(nil)
		self.Border:SetTexture(nil)
		self.BorderShield:SetTexture(nil)

		self:SetWidth( 350)
		self:SetHeight( 25)
		self:SetStatusBarTexture( texture)
		self:ClearAllPoints()
		self:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 100)

		self.Icon:SetSize( self:GetHeight(), self:GetHeight())
		self.Icon:SetTexCoord(unpack( yo.tCoord))

		self.Text:SetFont( font, 11, "OUTLINE")
		self.Text:ClearAllPoints()
		self.Text:SetPoint("CENTER", self, "CENTER", 0, 0)

		CreateStyle( self, 4)
	end

	self.Text:SetTextColor(myColor.r, myColor.g, myColor.b)
	self:SetStatusBarColor(myColor.r, myColor.g, myColor.b)
end)
