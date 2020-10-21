local L, yo, N = unpack( select( 2, ...))

if not yo.NamePlates.enable then return end

-----------------------------------------------------------------------------------------------
--	CASTBAR
-----------------------------------------------------------------------------------------------

local function NamePlates_UpdateCastBar( f, ...)
	if not f:IsShown() then return end
	local current, width, min, max = f:GetValue(), f:GetWidth(), f:GetMinMaxValues()

	f.Time:SetFormattedText("%.1f / %.2f", current-min, max-min)
end

local function FadingOut( f)
	local now = GetTime()
	local alpha = f.fadeDuration - (now - f.endTime)
	if alpha > 0 then
		f:SetAlpha( math.min( alpha, 1.0))
	else
		f:SetScript('OnUpdate', nil)
		f:Hide()
	end
end

local function stopCast( f)
	f:SetValue( 0)   --f.reversed and 0 or (f.endTime - f.startTime))
	f.endTime = GetTime()
	--f:SetScript('OnUpdate', FadingOut)
	-- no fading - hide
	f:Hide()
end

function UpdateCastBar( f, id)
	local unit = f:GetParent().unit
	if not unit then return  end

	local name, icon, startTime, endTime, notInterruptible, spellID

	if f.reversed then
		name, _, icon, startTime, endTime, _, notInterruptible = UnitChannelInfo( unit)
	else
		name, _, icon, startTime, endTime, _, _, notInterruptible, spellID = UnitCastingInfo( unit)
	end

	if not name then
		stopCast( f)
		return
	end

	if notInterruptible then
		--f.BorderShield:Show()
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 0.8, 0.15, 0.25, 1)
		end
		f:SetStatusBarColor( 0.8, 0.15, 0.25, 1)
		f.spark:SetVertexColor( 0.8, 0.15, 0.25, 1)
	else
		--f.BorderShield:Hide()
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
		if spellDelay() then
			f:SetStatusBarColor( 0.5, 1, 0, 1)
			f.spark:SetVertexColor( 0.5, 1, 0, 1)
		else
			f:SetStatusBarColor( 0, 1, 1, 1)
			f.spark:SetVertexColor( 0, 1, 1, 1)
		end
	end

	if f.ibg then
		if icon then
			f.Icon:SetTexture( icon)
			f.ibg:Show( )
		else
			f.ibg:Hide()
		end
	end

	f.spellDelay = yo.General.spellDelay
	f.endTime = endTime/1000
	f.startTime = startTime/1000

	f:SetMinMaxValues(0, f.endTime - f.startTime)

	if yo.NamePlates.showCastName then
		local text = ""
		if yo.NamePlates.showCastTarget then
			if UnitExists( unit .. "target") then
				if yo.NamePlates.anonceCast and not UnitInRaid("player") then
					if UnitIsUnit("player", unit .. "target")
						--and ( myRole == "HEALER" or myRole == "DAMAGER" )
						then
							print( myColorStr .. name .. " on me!")
					end
				end
				local uname = UnitName( unit .. "target")
				if uname then
					local cname = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( unit .. "target"))].colorStr
					text = " / " .. cname .. uname
				end
			end
		end

		--local spellName = ( GetSpellInfo( id or spellID) or "БЭД КАСТ")
		--f.Text:SetText( spellName  .. text)
		f.Text:SetText( name  .. text)
	else
		f.Text:SetText( "")
	end

	if yo.NamePlates.badCasts then
		f.spark:Show()
		glowTargetStart( f.ibg, {0.95, 0.95, 0.32, 1}, 8, 0.5, 5, 2, 2, 2, false, 1, 11 )
	else
		f.spark:Hide()
		glowBadStop( f.ibg, 1)
	end

	f:SetScript('OnUpdate', CastTimerUpdate)
	f:SetAlpha( 1)
	f:Show()
end

function CastTimerUpdate( f)
	if f.spellDelay ~= yo.General.spellDelay then UpdateCastBar( f)	end

	local now = GetTime()
	if f.reversed then
		f:SetValue(f.endTime - now)
	else
		f:SetValue(now - f.startTime)
	end
end

local function CastingBarFrame_OnEvent( f, event, unit, name, id)
	--print( event, unit, id) --, ...)
	if event == "UNIT_SPELLCAST_START" then
		f.reversed = false
		UpdateCastBar( f, id)
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		f.reversed = true
		UpdateCastBar( f, id)
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		stopCast( f)
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		stopCast( f)
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		f:SetStatusBarColor( 1, 0, 0, 1)
		stopCast( f)
		--f.fadeDuration = 1.5
	--elseif event == "UNIT_SPELLCAST_CHANNEL_INTERRUPTED" then
	--	f:SetStatusBarColor( 1, 0, 0, 1)
	--	f.fadeDuration = 1.5
	end
end

function CreateCastBarNP( f)

	f.castBar = CreateFrame("StatusBar", nil, f)
	f.castBar:Hide()
	f.castBar:SetPoint("TOP", f.healthBar, "BOTTOM", 0, -2)
	f.castBar:SetSize( yo.NamePlates.width, 5)
	f.castBar:SetStatusBarTexture( yo.texture)
	f.castBar:SetStatusBarColor(1, 0.8, 0)
	table.insert( N.statusBars, f.castBar)
	f.castBar:SetFrameLevel( 12)
	--f.castBar:SetScript('OnMinMaxChanged', OnBarValuesChange)
	--f.castBar:SetScript('OnValueChanged', OnBarValuesChange)
	--f.castBar:SetScript('OnShow', OnBarValuesChange)

	f.castBar.Background = f.castBar:CreateTexture(nil, "BACKGROUND")
	f.castBar.Background:SetAllPoints( f.castBar)
	f.castBar.Background:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.castBar.Background:SetTexture( yo.texture)

	f.castBar.Time = f.castBar:CreateFontString(nil, "ARTWORK")
	f.castBar.Time:SetPoint("RIGHT", f.castBar, "RIGHT", -5, 0)
	f.castBar.Time:SetFont( yo.font, yo.fontsize - 1, "THINOUTLINE")
	f.castBar.Time:SetShadowOffset(1, -1)
	f.castBar.Time:SetTextColor(1, 1, 1)
	table.insert( N.strings, f.castBar.Time)

	f.castBar.Text = f.castBar:CreateFontString(nil, "OVERLAY")
	f.castBar.Text:SetPoint("TOP", f.castBar, "BOTTOM", 0, -1)
	f.castBar.Text:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	f.castBar.Text:SetTextColor(1, 1, 1)
	f.castBar.Text:SetJustifyH("CENTER")
	table.insert( N.strings, f.castBar.Text)

	f.castBar.ibg = CreateFrame("Frame", nil, f.castBar)
   	f.castBar.ibg:SetPoint("BOTTOM", f.healthBar,"CENTER", 0, 0);
   	f.castBar.ibg:SetSize( yo.NamePlates.iconCastSize, yo.NamePlates.iconCastSize)
	f.castBar.ibg:SetFrameLevel( 10)
	CreateStyle( f.castBar.ibg, 1, 6)

	f.castBar.spark = f.castBar:CreateTexture(nil, "OVERLAY")
	f.castBar.spark:SetTexture([[Interface\Addons\yoFrame\Media\CastSparker.tga]])
	f.castBar.spark:SetPoint("BOTTOM", f.castBar:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, -19)
	f.castBar.spark:SetHeight( 56)
	f.castBar.spark:SetWidth(45)
	f.castBar.spark:Hide()

	f.castBar.Icon = f.castBar.ibg:CreateTexture(nil, "BORDER")
	f.castBar.Icon:SetAllPoints( f.castBar.ibg)
	f.castBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	--f.castBar.Flash = f.castBar:CreateTexture(nil, "OVERLAY")
	--f.castBar.Flash:SetAllPoints()
	--f.castBar.Flash:SetTexture("")
	--f.castBar.Flash:SetBlendMode("ADD")
	--CreateStyle( f.castBar, 3)

	f.castBar:SetScript("OnEvent", CastingBarFrame_OnEvent)
	f.castBar:HookScript("OnValueChanged", function() NamePlates_UpdateCastBar(f.castBar) end)

end