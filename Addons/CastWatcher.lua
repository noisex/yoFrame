local tauntSpell = { 
    [6795] = "Мишка",
    [56222] = "DK",
    [49576] = "DK",
    [62124] = "Pally",
    [355] = "War",
    [115546] = "Monkaz",
    [185245] = "VDH",
    [17735] = "Lock 1",
    [171014] = "Lock 2",
    [20736] = "Hunter"
}

local foodSpell = { 
    --[157757] = "valeriy",
    --[157898] = "igor",
    --[8690] = "vindikar",
    --[222695] = "dalaran",
    --[48438]	= "Буйный рост",
    [185709] = "Сахарок",
    [201352] = "Большую хавку",
    [188036] = "Духовный котелок",

    [276972] = "Таинственный котел"
}

local function CreateText( self)
	
	self:SetPoint( "CENTER", UIParent, "TOP", 0, -100)
	self:SetSize( 45, 45)
	self:Hide()
	CreateStyle( self, 5)
	
	self.icon = self:CreateTexture(nil, "BORDER")
	self.icon:SetAllPoints()
	self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.icon:SetVertexColor( 1,1,1,1)
	
	self.watchText = self:CreateFontString(nil, "OVERLAY")
	self.watchText:SetFont( font, 20, "OUTLINE")
	self.watchText:SetPoint("CENTER", self, "BOTTOM", 0, -10)
	self.watchText:SetTextColor( 1, 0.5, 0)
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function FadingOut( self, elapled)
	
	self.countDown = self.countDown - elapled
	if self.countDown > 0 then
		self:SetAlpha( math.min( self.countDown, 1.0))
	else
		self:SetScript('OnUpdate', nil)
		self:Hide()
	end
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		
		if not yo["Addons"].CastWatcher then return end	
		if not self.icon then
			CreateText( self)
		end
		
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		
		local _, sevent, _, _, sName, sourceFlags, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo ()
   		if sevent == "SPELL_CAST_SUCCESS"  then
			
			if foodSpell[spellID] then
				if --not UnitIsUnit( sName, "player") and 
						( UnitInParty( sName) or UnitInRaid( sName)) then
				        
					local spellName, _, icon = GetSpellInfo ( spellID)
					local uClass = select( 2, UnitClass( sName)) or "PRIEST"
					local sColor = " -=> |c" .. RAID_CLASS_COLORS[ uClass].colorStr .. strsplit( "-", sName) .. "|r"
			
					--print( sName, uClass, UnitClass( "Аллотрил"))
			
					self.icon:SetTexture( icon)
					self.watchText:SetText( spellName .. sColor)
					self.countDown = 5
					self:Show()
					self:SetScript('OnUpdate', FadingOut)
	
					PlaySoundFile( LSM:Fetch( "sound", yo["Addons"]["CastWatchSound"]))
				end
			elseif tauntSpell[spellID] then
				if not UnitIsUnit( sName, "player") and ( UnitInParty( sName) or UnitInRaid( sName))
					--and UnitGroupRolesAssigned( "player") == "TANK"
					then
										
					local spellName, _, icon = GetSpellInfo ( spellID)
					local uClass = select( 2, UnitClass( sName)) or "PRIEST"
					local sColor = " -=> |c" .. RAID_CLASS_COLORS[ uClass].colorStr .. strsplit( "-", sName) .. "|r"

					self.icon:SetTexture( icon)
					self.watchText:SetText( spellName .. sColor)
					self.countDown = 3
					self:Show()
					self:SetScript('OnUpdate', FadingOut)
				end
			end
		end
    end 
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", OnEvent)
