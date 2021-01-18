local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID
	= time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID

local events = {
	SPELL_HEAL = true,
	SPELL_PERIODIC_HEAL = true,
	SPELL_ABSORBED = true,
	--SPELL_HEAL_ABSORBED = true,
}

function Stat:onEvent( event, ...)

	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local _, Event, _, sourceGUID, _, sourceMask, _, _, _, _, _, spellID, spellName, spellSchool, spellDMG, overHeal, school, arg18, arg19, arg20, arg21, arg22 = CombatLogGetCurrentEventInfo()

		if not self.inCombat then return end
		if not events[Event] then return end

		--if sourceMask == 4369 and not infoText.petBlacklist[sourceGUID] then infoText:checkPets( sourceGUID) end

		--local a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24 = CombatLogGetCurrentEventInfo()
		if Event == "SPELL_ABSORBED" then
			local cleuInfo 		= {CombatLogGetCurrentEventInfo()}
			--tprint(cleuInfo)
			if spellID == n.myGUID then 		-- arg12
				sourceGUID 		= spellID
				spellID 		= overHeal 	-- arg16
				spellSchool		= arg18
				spellDMG		= arg19
				overHeal 		= 0
				spellName		= school
			elseif spellDMG == n.myGUID then 	-- arg15
				sourceGUID 		= spellDMG
				spellID 		= arg19
				spellSchool		= arg21
				spellDMG 		= arg22
				overHeal 		= 0
				spellName 		= arg20
			else
				return
			end
		end

		--if sourceGUID == n.myGUID or infoText.pets[sourceGUID] then
		if sourceGUID == n.myGUID or sourceMask == 4369 or sourceMask == 8465 then
			infoText.checkNewSpell( self, n.myGUID, spellID, spellName, spellDMG, overHeal, spellSchool, arg18)
		end

	elseif event == 'UNIT_PET' then
		local petGUID = UnitGUID('pet')
		if petGUID then
			infoText.pets[petGUID] = true
			infoText.petBlacklist[petGUID] = true
		end
	elseif event == 'PLAYER_REGEN_DISABLED' or event == "ENCOUNTER_START" then infoText:start( self)
	elseif event == 'PLAYER_REGEN_ENABLED'  or event == "ENCOUNTER_END"   then infoText:stop( self)
	end
end

function Stat:onClick()
	infoText:reset( self)
	infoText:getDPS(self)
	GameTooltip:Hide()
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self.timeBegin 		= 0
	self.combatTime 	= 0
	self.amountTotal 	= 0
	self.spellInfo		= {}
	self.spellDamage 	= {}
	self.displayName 	= "hps"

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)
	self:RegisterEvent( 'COMBAT_LOG_EVENT_UNFILTERED')
	self:RegisterEvent( 'PLAYER_LEAVE_COMBAT')
	self:RegisterEvent( 'PLAYER_REGEN_DISABLED')
	self:RegisterEvent( "PLAYER_REGEN_ENABLED")
	self:RegisterEvent( "ENCOUNTER_END")
	self:RegisterEvent( "ENCOUNTER_START")
	self:RegisterEvent( "UNIT_PET")
	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", function( ) infoText:onEnter( self) end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onClick)
	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( n.font, n.fontsize, "OVERLAY")
	self.Text:SetFormattedText( infoText.displayString, self.displayName, 0, "") --,  SecondsToClocks(self.combatTime))
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	infoText:reset( self)
	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	self:UnregisterAllEvents()
	self:Hide()
end

infoText.infos.hps  		= Stat
infoText.infos.hps.name		= "Heal"

infoText.texts.hps = "HPS"
--Stat.index = 6
--Stat:Enable()