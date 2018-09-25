local LSM = LibStub("LibSharedMedia-3.0");

LSM:Register("sound", "Voice: Run Out", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Run-out.ogg")
LSM:Register("sound", "Voice: Soak it", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Soak-it.ogg")
LSM:Register("sound", "Voice: Spread out", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Spread-out.ogg")
LSM:Register("sound", "Voice: Stack in", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Stack-in.ogg")
LSM:Register("sound", "Voice: Switch target", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Switch-target.ogg")
LSM:Register("sound", "Voice: Take cover", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Take-Cover.ogg")

LSM:Register("sound", "Voice: Bip", "Interface\\Addons\\WeakAurasVoice\\Sounds\\Bip.ogg")
LSM:Register("sound", "Voice: CSDroplet", "Interface\\Addons\\WeakAurasVoice\\Sounds\\CSDroplet.ogg")

--[[
local function utf8sub(string, i, dots)
    i = math.floor( i)
    if not string then return end
    local bytes = string:len()
    if bytes <= i then
        return string
    else
        local len, pos = 0, 1
        while (pos <= bytes) do
            len = len + 1
            local c = string:byte(pos)
            if c > 0 and c <= 127 then
                pos = pos + 1
            elseif c >= 192 and c <= 223 then
                pos = pos + 2
            elseif c >= 224 and c <= 239 then
                pos = pos + 3
            elseif c >= 240 and c <= 247 then
                pos = pos + 4
            end
            if len == i then break end
        end
        if len == i and pos <= bytes then
            return string:sub(1, pos - 1)..(dots and "..." or "")
        else
            return string
        end
    end
end

local function nums(num)
	TRILLION=1000000000000
	BILLION=1000000000
	MILLION=1000000
	THOUSAND=1000

    if not num then return " " end
    if num == 0 then return "0" end
    if num < THOUSAND then
        return math.floor(num)
    elseif num >= TRILLION then
        return string.format('%.3ft', num/TRILLION)
    elseif num >= BILLION then
        return string.format('%.3fb', num/BILLION)
    elseif num >= MILLION then
        return string.format('%.2fm', num/MILLION)
    elseif num >= THOUSAND then
        return string.format('%.1fk', num/THOUSAND)
    end
end

font    = [=[Interface\AddOns\WeakAurasVoice\Media\qFont.ttf]=]
texture = "Interface\\AddOns\\WeakAurasVoice\\Media\\statusbar4"
texhl   = "Interface\\AddOns\\WeakAurasVoice\\Media\\raidbg"
texglow = "Interface\\AddOns\\WeakAurasVoice\\Media\\glowTex"
unit = "target"

local function MakeFrame( f, unit)
	f.healthBar = CreateFrame("StatusBar", "healthBar", f)
	f.healthBar:SetAllPoints()
	f.healthBar:SefLevel(1)
	f.healthBar:SetStatusBarTexture(texture)
	f.healthBar:SetStatusBarColor( 0.09, 0.09, 0.09, 1)
	f.healthBar:GetStatusBarTexture():SetHorizTile(false)

	f.powerBar = CreateFrame("StatusBar" , "powerBar", f)
	f.powerBar:SetPoint("BOTTOM", f,"BOTTOM", 0, 5);
	f.powerBar:SetStatusBarTexture( texture)
	f.powerBar:SetHeight( 4)
	f.powerBar:SetWidth( f:GetWidth() - 10) 
	f.powerBar:SefLevel( 4)

	f.nameText =  f:CreateFontString(nil ,"OVERLAY")
	f.nameText:SetFont( font, 10, "OUTLINE")
	f.nameText:SetPoint("BOTTOMLEFT", f.powerBar, "TOPLEFT", 0, 3)

	f.healthText =  f:CreateFontString(nil ,"OVERLAY")
	f.healthText:SetFont( font, 9, "OUTLINE")
	f.healthText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)

	f.powerText =  f:CreateFontString(nil ,"OVERLAY")
	f.powerText:SetFont( font, 9, "OUTLINE")
	f.powerText:SetPoint("TOPRIGHT", f.healthText, "BOTTOMRIGHT", 0, -3)
	  
	f.bgHealth = f:CreateTexture(nil, 'BACKGROUND')
	f.bgHealth:SetAllPoints(f)
	f.bgHealth:SetVertexColor(0.5,0.5,0.5,0.9)
	f.bgHealth:SetTexture( texture)

	f.bgPower = f:CreateTexture(nil, 'BACKGROUND')
	f.bgPower:SetAllPoints(f.powerBar)
	f.bgPower:SetVertexColor(0.5,0.5,0.5,0.9)
	f.bgPower:SetTexture( texture)

	f.bgHlight = f:CreateTexture(nil, "OVERLAY")
	f.bgHlight:SetAllPoints(f)
	f.bgHlight:SetVertexColor(0.5,0.5,0.5,0.9)
	f.bgHlight:SetTexture( texhl)
	f.bgHlight:SetBlendMode("ADD")
	f.bgHlight:SetAlpha(0.1)
	f.bgHlight:Hide()
	
	f.unit = "target"
	f.tar = f.unit.."target"
	f:SetAlpha(1)
end

function CreateStyle(f, size, level, alpha, alphaborder) 
    if f.shadow then return end

	local style = {
		bgFile =  texture,
		edgeFile = texglow, 
		edgeSize = 4,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
    local shadow = CreateFrame("Frame", nil, f)
    shadow:SefLevel(level or 0)
    shadow:SefStrata(f:GefStrata())
    shadow:SetPoint("TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop(style)
    shadow:SetBackdropColor(.08,.08,.08, alpha or .9)
    shadow:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
    f.shadow = shadow
    return shadow
end

local function OnEvent(f, event, ...)
	print( "Event :", f:GetName(), event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		if UnitExists( unit) then
		    if UnitIsDead( unit) then
				f.colors = RAID_CLASS_COLORS[ "PRIEST"]
			else
				f.colors = RAID_CLASS_COLORS[select(2,  UnitClass( unit) )]
			end    

			f.nameText:SetText( utf8sub( UnitName( unit), (f:GetWidth() / 10), true))
			f.nameText:SetTextColor( f.colors.r, f.colors.g, f.colors.b, 1)
			f.powerText:SetTextColor( f.colors.r, f.colors.g, f.colors.b, 1)
			f.powerBar:SetStatusBarColor( f.colors.r, f.colors.g, f.colors.b, 1)
			hp_update( f, unit)
			pw_update( f, unit)
			f:Show()		
		else
			f:Hide()
		end		
	elseif event == "PLAYER_ENTERING_WORLD" then
		MakeFrame( "tarFrame", "target")
		CreateStyle( f, 5)
		CreateStyle( f.powerBar, 3, 4)
		f:Hide()
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_REGEN_ENABLED" then
	elseif event == "PLAYER_REGEN_DISABLED" then
	elseif event == "UNIT_HEALTH" then
		hp_update( f, unit)
	elseif event == "UNIT_POWER" then
		if UnitIsUnit( select( 1, ...), unit) then
			pw_update( f, unit)
		end
	else
	end
end

function hp_update( f, unit)  
	if UnitIsDead( unit) then
        thText = "Трупик"
    else
        thText = nums( UnitHealth( unit)) .. " | " .. math.floor( UnitHealth( unit) / UnitHealthMax( unit) * 100) .. "%"
    end        
	
    f.healthText:SetText( thText)
	f.healthBar:SetMinMaxValues( 0, UnitHealthMax( unit))     
	f.healthBar:SetValue( UnitHealth( unit))
end

function pw_update( f, unit)  
	if UnitIsDead( unit) then
        thText = "Трупик"
    else
        thText = nums( UnitHealth( unit)) .. " | " .. math.floor( UnitHealth( unit) / UnitHealthMax( unit) * 100) .. "%"
    end        
	
	 if UnitPower( unit) >= 1 then
        uPP = math.floor( UnitPower( unit) / UnitPowerMax( unit) * 100)
    else
        uPP = 0
    end
	
    if UnitIsDead( unit) then
        uPText = ""
    else
        uPText = nums( UnitPower( unit)) .. " | " .. uPP .. "%"
    end    

	f.powerText:SetText( uPText)	
	f.powerBar:SetMinMaxValues( 0, UnitPowerMax( unit))     
	f.powerBar:SetValue( UnitPower( unit))

end

local function OnEnter(self, event)
	print( "Enter :", 	event, GameTooltip:GetPoint())
	tarFrame.bgHlight:Show()
	GameTooltip:SetOwner( self:GetParent(), "ANCHOR_NONE", 0, 0) --ANCHOR_CURSOR   :GetParent()
	--print( -(CONTAINER_OFFSET_X-13), CONTAINER_OFFSET_Y)
	--GameTooltip:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", (CONTAINER_OFFSET_X-13), CONTAINER_OFFSET_Y)
	GameTooltip:SetUnit( unit)
	GameTooltip:AddLine( "eqweqweqweqweqwe")
	GameTooltip:Show()
end

local function OnLeave(self, event)
	--print( "Leave :", self, event, unit)
	tarFrame.bgHlight:Hide()
	 if GameTooltip:IsShown() then
--		GameTooltip:SetAlpha(0)  --FadeOut(2)
	end
end

tarFrame = CreateFrame("Button", "yo_".. unit, UIParent)  --, "SecureUnitButtonTemplate") 
tarFrame:SetPoint( "CENTER", UIParent, "CENTER", 600 , 0)
tarFrame:SetSize( 230, 45)

tarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--tarFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
--tarFrame:RegisterEvent("PLAYER_REGEN_DISABLED")

tarFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
tarFrame:RegisterEvent("UNIT_HEALTH")
tarFrame:RegisterEvent("UNIT_POWER")
tarFrame:RegisterEvent("RAID_TARGET_UPDATE")

tarFrame:SetScript("OnEnter", OnEnter)
tarFrame:SetScript("OnLeave", OnLeave)
tarFrame:SetScript("OnEvent", OnEvent)
tarFrame:RegisterForClicks("AnyDown")
tarFrame:SetAttribute("*type1", "target")
tarFrame:SetAttribute("*type2", "menu")
tarFrame:SetScript('OnClick', function(self, button)
    if button == "RightButton" then
        ToggleDropDownMenu(1, nil,  _G["TargefDropDown"] , "cursor", 0, 0)
    end
end) 

--tarFrame:SetScript("OnUpdate", OnUpdate)
--tarFrame.healthBar:SetValue( 75 )

-- UPDATE_FACTION UNIT_HEALTH  UNIT_HEALTH_FREQUENT  RAID_TARGET_UPDATE
--	s.Smooth = true
--	fixStatusbar(s)

]]--