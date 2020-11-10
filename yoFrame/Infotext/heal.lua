local L, yo, N = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = N.InfoTexts
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
		local _, Event, _, sourceGUID, _, sourceMask, _, _, _, _, _, spellID, _, _, spellDMG, overHeal, school, arg18, arg19, _, arg21, arg22 = CombatLogGetCurrentEventInfo()

		if not self.inCombat then return end
		if not events[Event] then return end

		if sourceMask == 4369 and not infoText.pet_blacklist[sourceGUID] then
			infoText:checkPets( sourceGUID)
		end

		--local a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24 = CombatLogGetCurrentEventInfo()
		if Event == "SPELL_ABSORBED" then
			if spellID == myGUID then 		-- arg12
				sourceGUID 		= spellID
				spellID 		= overHeal 	-- arg16
				school 			= arg18
				spellDMG		= arg19
				overHeal 		= 0
			elseif spellDMG == myGUID then 	-- arg15
				sourceGUID 		= spellDMG
				spellID 		= arg19
				school 			= arg21
				spellDMG 		= arg22
				overHeal 		= 0
			else
				return
			end
		end

		if sourceGUID == myGUID or infoText.pets[sourceGUID] then
			infoText.checkNewSpell( self, spellID, spellDMG, overHeal, school)
		end

	elseif event == 'UNIT_PET' then
		local petGUID = UnitGUID('pet')
		if petGUID then
			infoText.pets[petGUID] = true
			infoText.pet_blacklist[petGUID] = true
		end
	elseif event == 'PLAYER_REGEN_DISABLED' or Event == "ENCOUNTER_START" then infoText:start( self)
	elseif event == 'PLAYER_REGEN_ENABLED'  or Event == "ENCOUNTER_END"   then infoText:stop( self)
	end
end

function Stat:onClick()
	infoText:reset( self)
	infoText:getDPS(self)
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self.timeBegin 		= 0
	self.combatTime 	= 0
	self.amountTotal 	= 0
	self.spellCount		= {}
	self.spellDamage 	= {}

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
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self.Text:SetFormattedText( infoText.displayString, "hps", 0, "") --,  SecondsToClocks(self.combatTime))
	self.Text:ClearAllPoints()
	self.Text:SetPoint("CENTER", self, "CENTER", 0, 0)
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