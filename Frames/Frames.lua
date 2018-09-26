local function unitPVP( f, unit)

	local status
	local element = f.pvpIcon
	if not element then return end

	local factionGroup = UnitFactionGroup(unit) 	

	if (UnitIsPVPFreeForAll( unit)) then
		status = 'FFA'
	elseif(factionGroup and factionGroup ~= 'Neutral' and UnitIsPVP(unit)) then
		
		if(unit == 'player' and UnitIsMercenary(unit)) then
			if(factionGroup == 'Horde') then
				factionGroup = 'Alliance'
			elseif(factionGroup == 'Alliance') then
				factionGroup = 'Horde'
			end
		end

		status = factionGroup
	end 

	if(status) then
		element:Show()

		element:SetTexture([[Interface\TargetingFrame\UI-PVP-]] .. status)
		element:SetTexCoord(0, 0.65625, 0, 0.65625)
	else
		element:Hide()
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

local function enableRC( f, unit, name)
	if UnitIsGroupAssistant( "player") or UnitIsGroupLeader( "player") then
		f:SetScript("OnMouseUp", function( this, a1)
			if a1 == "LeftButton" then
				DoReadyCheck()
			elseif a1 == "RightButton" then 
				DoReadyCheck()
			end 
		end)
		
		f:SetScript("OnEnter", function(this)
			GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT", 0, 0)
			GameTooltip:SetText("Разбудить коричневого", 0, 1, 0)
			GameTooltip:Show()
		end)
		f:SetScript("OnLeave", GameTooltipOnLeave)
	else
		f:SetScript("OnMouseUp", function() end)
		f:SetScript("OnEnter", function() end)
		f:SetScript("OnLeave", function() end)
	end
end

function flag_update( f, unit)
	if UnitIsGroupAssistant( unit) == true then
		f.rAssist:Show()		
		enableRC( f.rAssist)
		f.rLeader:Hide() 		
	elseif UnitIsGroupLeader( unit) == true then
		f.rLeader:Show()
		enableRC( f.rLeader)
		f.rAssist:Hide()
	else
		f.rAssist:Hide()
		f.rLeader:Hide() 
	end
	
	--local method, pid, rid = GetLootMethod()
	--if(method == 'master') then
	--	local mlUnit
	--	if( pid) then
	--		if( pid == 0) then
	--			mlUnit = 'player'
	--		else
	--			mlUnit = 'party'..pid
	--		end
	--	elseif( rid) then
	--		mlUnit = 'raid'..rid
	--	end
	--	if( UnitIsUnit( unit, mlUnit)) then
	--		f.rLoot:Show()
	--	elseif( f.rLoot:IsShown()) then
	--		f.rLoot:Hide()
	--	end
	--else
	--	f.rLoot:Hide()
	--end 
		
	f.rText:Hide()
	if IsInRaid() == true then
		for i=1, GetNumGroupMembers() do 
			local rname, _, grp = GetRaidRosterInfo( i)
			if UnitExists( rname) and UnitIsUnit( rname, unit) then
				f.rText:SetText( grp)		
				f.rText:Show()
				break
			end
		end
	else
	end
end

function nm_update( f, unit)
	local lenght = math.floor( f:GetWidth() / 8)
	f.nameText:SetText( utf8sub( UnitName( unit), lenght, false))
	if UnitIsAFK(unit) == true then
		f.nameText:SetText( f.nameText:GetText() .. " |cffffffff afk")
	end
end

function hp_update( f, unit)  
	local thText
	if not UnitIsConnected( unit) then
		thText = "Off"
	elseif UnitIsDead( unit) then
        thText = "Трупик"
	elseif UnitIsGhost( unit) then
        thText = "Каспер"
	else
		if unit == "targettarget" or unit == "pet"  or unit == "focus" then
			--thText = math.ceil( UnitHealth( unit) / UnitHealthMax( unit) * 100) .. "%"
			thText = ""
		else
			local min, max = UnitHealth( unit), UnitHealthMax( unit)
			if min == max then
				thText = nums( min)
			else
				thText = nums( min) .. " | " .. math.ceil( min / max * 100) .. "%"
			end			
		end
    end        
	
    f.healthBar.healthText:SetText( thText)
	f.healthBar:SetMinMaxValues( 0, UnitHealthMax( unit))     

	if not UnitIsConnected(unit) then
		f.healthBar:SetValue( UnitHealthMax( unit))
	else
		f.healthBar:SetValue( UnitHealth( unit))
	end
end

function rmark_update( f, unit)
		local index = GetRaidTargetIndex( f.unit)
		if( index) then
			SetRaidTargetIconTexture( f.rMark, index)
			f.rMark:Show()
		else
			f.rMark:Hide()
		end
end

function pw_update( f, unit)  
	local uPP, uPText
	local pmin, pmax = UnitPower( unit), UnitPowerMax( unit)
	
	if pmin >= 1 then
        uPP = math.floor( pmin / pmax * 100)
    else
        uPP = 0
    end
	
    if UnitIsDead( unit) or unit == "targettarget" or unit == "focus" or unit == "pet" or not UnitIsConnected( unit) or UnitIsGhost( unit) then
        uPText = ""
	elseif f.isboss then
		uPText = uPP .. "%"
    else
    	if pmin == pmax then
    		uPText = nums( pmin)
    	else
    		uPText = nums( pmin) .. " | " .. uPP .. "%"
    	end		
    end    

	f.powerBar.powerText:SetText( uPText)	
	f.powerBar:SetMinMaxValues( 0, pmax)     
	f.powerBar:SetValue( pmin)
end

function initFrame( f)
	
	local unit = f.unit
	local cols = f.colors.disc

	if not UnitIsConnected( unit) then
		cols = f.colors.disc
	elseif UnitIsDead( unit) or UnitIsGhost( unit) then
		f.alive = UnitIsDeadOrGhost( unit)
		cols = f.colors.disc
	elseif UnitIsPlayer( unit) then
		cols = f.colors.class[select( 2,UnitClass( unit))]
	elseif UnitIsTapDenied( unit) then
		cols = f.colors.tapped
	elseif f.isboss then
		if UnitIsUnit( unit, "target") then 
			--f.shadow:SetBackdropColor( 1, 0, 0, .9)
			f.shadow:SetBackdropBorderColor( 1, 0, 0, 1)			
		else
			--f.shadow:SetBackdropColor( .08, .08, .08, .9)
			f.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
		cols = f.colors.reaction[UnitReaction( unit, "player")]
	elseif UnitReaction( unit, 'player') or UnitPlayerControlled( unit) then
		cols = f.colors.reaction[UnitReaction( unit, "player")]
	end    	
	
	f.colr, f.colg, f.colb = cols[1], cols[2], cols[3]	
		
	f.rText:SetTextColor( f.colr, f.colg, f.colb, 1)
	f.nameText:SetTextColor( f.colr, f.colg, f.colb, 1)

	--local powerType, powerToken, altR, altG, altB = UnitPowerType( unit)
	--info = PowerBarColor[powerType] or PowerBarColor["MANA"];
	--r, g, b = info.r, info.g, info.b;
	--f.powerBar:SetStatusBarColor( r, g, b, 1)
	--print( powerType, powerToken, r, g, b)
	--f.healthBar:SetStatusBarColor( f.colr, f.colg, f.colb, 1)
	--f.healthBar.bgHealth:SetVertexColor(0.3,0.3,0.3,0.9)
	f.powerBar:SetStatusBarColor( f.colr, f.colg, f.colb, 1)
	f.powerBar.powerText:SetTextColor( f.colr, f.colg, f.colb, 1)

	nm_update( f, unit)
	hp_update( f, unit)
	pw_update( f, unit)
	flag_update( f, unit)
	rmark_update( f, unit)
	unitPVP( f, unit)
end

----------------------------------------------------------------------------------
--		EVENTS
----------------------------------------------------------------------------------
local function OnEvent(f, event, ...)
	--print( "Event :", f:GetName(), event, ...)
	local unit = f.unit
	if event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" then
		if f.alive == true then
			initFrame( f)
			f.alive = false
		else
			hp_update( f, unit)
		end
	elseif event == "UNIT_POWER" or event == "UNIT_POWER_FREQUENT" then
		if UnitIsUnit( select( 1, ...), unit) then
			pw_update( f, unit)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		--print( "GROUP_ROSTER_UPDATE")
		--resetRaid()
		flag_update( f, unit)
	elseif event == "PLAYER_TARGET_CHANGED" then
		if UnitExists( unit) then
			initFrame(f)
		end		
	elseif event == "RAID_TARGET_UPDATE" then
		rmark_update( f, unit)
	elseif event == "PLAYER_REGEN_ENABLED" then
		f.rCombat:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" then
		f.rCombat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		f.rCombat:Show()
	elseif event == "PLAYER_UPDATE_RESTING"	or event == "ZONE_CHANGED_NEW_AREA" then
		if( IsResting() and unit == 'player') then 
			f.rCombat:SetTexCoord(0, .5, 0, .421875) 
			f.rCombat:Show()
		else
			f.rCombat:Hide()
		end
	elseif event == "PLAYER_FLAGS_CHANGED" then
		nm_update( f, unit)
	elseif event == "PLAYER_DEAD" or event == "PLAYER_ALIVE" or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" or event == "PLAYER_UNGHOST" or event == "UNIT_PET" or event == "PLAYER_FOCUS_CHANGED" then
		initFrame( f)
	elseif event == "INCOMING_RESURRECT_CHANGED" then
		--print( event, UnitHasIncomingResurrection( unit))
		if UnitHasIncomingResurrection( unit) then
			f.nameText:SetTextColor( 0, 1, 0, 1)
		else
			f.nameText:SetTextColor( f.colr, f.colg, f.colb, 1)
		end		
	elseif event == "PLAYER_ENTERING_WORLD" then
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		initFrame( f)				
	elseif event == "UNIT_FACTION" then
		unitPVP( f, unit)
	else
		print( "UnknownEvent: |cffff0000" .. event .. "|r from: " .. f:GetName())
	end	
end

local function OnUpdate(f, elapse)
	f.tick = f.tick + elapse
	if f.tick > 0.7 then
		f.tick = 0
		if f:IsShown() then
			initFrame( f) 
		end
	end
end

local function makeInspect( uf, unit, name)
	if not uf[name] then
		local f = CreateFrame("Button", nil, uf)
		f:SetAlpha( 1)
		f:SetSize( 15,15)
		f:SetFrameLevel( 4)
		f:SetPoint("CENTER", uf, "TOPRIGHT", 0, 0)
		f:SetBackdrop({ bgFile="Interface\\HELPFRAME\\HelpIcon-Bug", }) 

		f:SetScript("OnMouseUp", function( this, a1)
			if not UnitIsVisible("target") then return end
			if a1 == "LeftButton" then
				InspectUnit("target")
			elseif a1 == "RightButton" then 
				if not DressUpFrame:IsShown() then 
					ShowUIPanel(DressUpFrame) 
				end
				DressUpModel:SetUnit("target")
				SetPortraitTexture(DressUpFramePortrait, "target")
			end 
		end)

		f:SetScript("OnEnter", function(this)
			GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:SetText("Инфокнопочка", 1, 1, 1)
			GameTooltip:AddLine(" <Left-click> Инспектик\n<Right-click> Раздевалочка", 0, 1, 0)
			GameTooltip:Show()
		end)
		
		f:SetScript("OnLeave", GameTooltipOnLeave)
		uf[name] = f
	else
		f:Show()
	end
end

menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

function CreateUFrame( f, unit)
	f.healthBar = CreateFrame("StatusBar", "healthBar", f)
	f.healthBar:SetAllPoints()
	f.healthBar:SetFrameLevel(1)
	f.healthBar:SetStatusBarTexture( texture)
	--f.healthBar:SetStatusBarColor( 0.09, 0.09, 0.09, 1)
	f.healthBar:SetStatusBarColor( 0.15, 0.15, 0.15, 1)
	f.healthBar:GetStatusBarTexture():SetHorizTile(false)

	f.powerBar = CreateFrame("StatusBar" , "powerBar", f)
	f.powerBar:SetPoint("BOTTOM", f,"BOTTOM", 0, 4);
	f.powerBar:SetStatusBarTexture( texture)
	f.powerBar:SetHeight( 4)
	f.powerBar:SetWidth( f:GetWidth() - 10) 
	f.powerBar:SetFrameLevel( 4)
 
	f.nameText =  f:CreateFontString(nil ,"OVERLAY")
	f.nameText:SetFont( font, fontsize, "OUTLINE")
	f.nameText:SetPoint("BOTTOMLEFT", f.powerBar, "TOPLEFT", 0, 3)

	f.healthBar.healthText =  f:CreateFontString(nil ,"OVERLAY")
	f.healthBar.healthText:SetFont( font, fontsize -1, "OUTLINE")
	f.healthBar.healthText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)

	f.powerBar.powerText =  f:CreateFontString(nil ,"OVERLAY")
	f.powerBar.powerText:SetFont( font, fontsize -1, "OUTLINE")
	f.powerBar.powerText:SetPoint("TOPRIGHT", f.healthBar.healthText, "BOTTOMRIGHT", 0, -3)
	  
	f.healthBar.bgHealth = f:CreateTexture(nil, 'BACKGROUND')
	f.healthBar.bgHealth:SetAllPoints(f)
	f.healthBar.bgHealth:SetVertexColor(0.5,0.5,0.5,0.9)
	f.healthBar.bgHealth:SetTexture( texture)

	f.powerBar.bgPower = f:CreateTexture(nil, 'BACKGROUND')
	f.powerBar.bgPower:SetAllPoints(f.powerBar)
	f.powerBar.bgPower:SetVertexColor(0.5,0.5,0.5,0.9)
	f.powerBar.bgPower:SetTexture( texture)

	f.bgHlight = f:CreateTexture(nil, "OVERLAY")
	f.bgHlight:SetAllPoints(f)
	f.bgHlight:SetVertexColor(0.5,0.5,0.5,0.9)
	f.bgHlight:SetTexture( texhl)
	f.bgHlight:SetBlendMode("ADD")
	f.bgHlight:SetAlpha(0.1)
	f.bgHlight:Hide()

	f.rMark = f:CreateTexture(nil,'OVERLAY')
    f.rMark:SetPoint("CENTER", f, "TOP", 0, 2)
	f.rMark:SetTexture("Interface\\AddOns\\yoFrame\\Media\\raidicons")
    f.rMark:SetSize(16, 16)

	f.rText =  f:CreateFontString(nil ,"OVERLAY")
	f.rText:SetFont( yo.Media.fontpx, fontsize, "OUTLINE")
	f.rText:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 2, 0)
	
	f.rLeader = CreateFrame("Button", nil, f)
    f.rLeader:SetPoint("CENTER", f, "TOPLEFT", 15, 4)
	f.rLeader:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-LeaderIcon", }) 
    f.rLeader:SetSize(10, 10)
	enableRC( f.rLeader)
	
	f.rAssist = CreateFrame("Button", nil, f)
    f.rAssist:SetPoint("CENTER", f.rLeader, "CENTER", 0, 0)
	f.rAssist:SetBackdrop({ bgFile="Interface\\GroupFrame\\UI-Group-AssistantIcon"})
    f.rAssist:SetSize(10, 10)
	enableRC( f.rAssist)
	
	--f.rLoot = f:CreateTexture(nil,'OVERLAY')
 --   f.rLoot:SetPoint("LEFT", f.rLeader, "RIGHT", 0, 0)
	--f.rLoot:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
 --   f.rLoot:SetSize( 8, 8)
	
	if unit == "player" or unit == "target" then
		f.pvpIcon = f:CreateTexture(nil,'OVERLAY')
		f.pvpIcon:SetPoint("CENTER", f, "CENTER", 0, 0)
		f.pvpIcon:SetSize(20, 20)
		f.pvpIcon:Hide()		
	end


	if unit == "player" then
		f:RegisterEvent( "UNIT_FACTION")
		f:RegisterEvent("PLAYER_ENTERING_WORLD");
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		f:RegisterEvent("GROUP_ROSTER_UPDATE")
		f:RegisterUnitEvent("INCOMING_RESURRECT_CHANGED", unit)
		f:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		f:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit)
		f:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", unit)
		--f:RegisterUnitEvent("PLAYER_TARGET_CHANGED", unit)
		--f:RegisterEvent("UNIT_PET")
		
		f:RegisterEvent("PLAYER_UPDATE_RESTING")
		f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		
		f:RegisterEvent("PLAYER_DEAD")
		f:RegisterEvent("PLAYER_ALIVE")
		f:RegisterEvent("PLAYER_UNGHOST")
		
		--f:RegisterEvent("PLAYER_TOTEM_UPDATE")
		--f:RegisterEvent("UNIT_MAXHEALTH")
		--UNIT_THREAT_LIST_UPDATE
		--UNIT_THREAT_SITUATION_UPDATE
	
		f.rCombat = f:CreateTexture(nil, 'OVERLAY')
		f.rCombat:SetSize(19,19)
		f.rCombat:SetPoint( "CENTER", f, "LEFT", 0, 6)
		f.rCombat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon') 
		f.rCombat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		f.rCombat:Hide()
		if IsResting() then 
			f.rCombat:SetTexCoord(0, .5, 0, .421875) 
			f.rCombat:Show()
		else
			f.rCombat:Hide()
		end
		
	elseif unit == "target" then 
			
		f:RegisterEvent("PLAYER_ENTERING_WORLD");
	
		--f:RegisterEvent("PLAYER_ALIVE")
		--f:RegisterEvent("PLAYER_DEAD")
		--f:RegisterEvent("PLAYER_UNGHOST")
		f:RegisterEvent("GROUP_ROSTER_UPDATE")
		f:RegisterEvent("PLAYER_TARGET_CHANGED")
		
		f:RegisterUnitEvent("UNIT_HEALTH", unit)
		f:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit)
		f:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", unit)
		f:RegisterUnitEvent("INCOMING_RESURRECT_CHANGED", unit)
				
		makeInspect( f, unit, "inspect")
	elseif unit == "pet" then 
		f:RegisterEvent("UNIT_PET")
		f:RegisterUnitEvent("UNIT_HEALTH", unit)
		f:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit)
	elseif unit == "focus" then 
		f:RegisterEvent("GROUP_ROSTER_UPDATE")
		f:RegisterEvent("PLAYER_FOCUS_CHANGED")
		f:RegisterUnitEvent("UNIT_HEALTH", unit)
		f:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit)
		f:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", unit)
	elseif( unit:match'(boss)%d?$' == 'boss') then 
		f.isboss = "boss"
		f:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		f:RegisterEvent("PLAYER_TARGET_CHANGED")
		f:SetScript('OnShow', initFrame)
		f:RegisterUnitEvent("UNIT_HEALTH", unit)
		f:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit)
	elseif unit == "targettarget" then
		f.tick = 1
		f:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", unit)
		f:SetScript("OnUpdate", OnUpdate)
	end

	f:RegisterEvent("RAID_TARGET_UPDATE")
	--f:RegisterEvent("PARTY_MEMBER_ENABLE")
	--f:RegisterEvent("PARTY_MEMBER_DISABLE")
	
	f:RegisterForClicks("AnyDown")
	
	f:SetScript("OnEnter", OnEnter)
	f:SetScript("OnLeave", OnLeave)
	f:SetScript("OnEvent", OnEvent)
	
	f:SetAttribute("*type1", "target")
	f:SetAttribute("*type2", "menu")
	f:SetAttribute("unit", unit)
	RegisterUnitWatch( f)
	
	--f.rLoot:Hide()
	f.rAssist:Hide()
	f.rLeader:Hide()
	f:SetAlpha(1)
	GetColors( f)
	CreateStyle( f, 4)
	CreateStyle( f.powerBar, 4, 4, .3, .3)
	f.menu = menu
	DisableBlizzard( unit)
	initFrame( f)
end

--self:RegisterEvent('INCOMING_RESURRECT_CHANGED', Path, true)
--resurrect:SetTexture[[Interface\RaidFrame\Raid-Icon-Rez]] 
