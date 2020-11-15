local L, yo, N = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = N.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID
	= time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID

--bit.band (flag, 0x2000) ~= 0)
--https://github.com/Gethe/wow-ui-source/blob/live/FrameXML/Constants.lua
--COMBATLOG_FILTER_ME
--COMBATLOG_FILTER_MINE
--COMBATLOG_FILTER_MY_PET	= bit.bor(
--	COMBATLOG_OBJECT_AFFILIATION_MINE,
--	COMBATLOG_OBJECT_REACTION_FRIENDLY,
--	COMBATLOG_OBJECT_CONTROL_PLAYER,
--	COMBATLOG_OBJECT_TYPE_GUARDIAN,
--	COMBATLOG_OBJECT_TYPE_PET
--);

local events = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true,
	SPELL_EXTRA_ATTACKS = true
}

function Stat:onEvent( event, ...)

	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local timestamp, Event, _, sourceGUID, name, sourceMask, _, _, _, _, _, spellID, _, _, spellDMG, over, school = CombatLogGetCurrentEventInfo()

		if not self.inCombat then return end
		if not events[Event] then return end
		--print(Event, sourceGUID, name, sourceMask)
		--8465 = guardian
		if ( sourceMask == 4369 or sourceMask == 8465) and not infoText.pet_blacklist[sourceGUID] then infoText:checkPets( sourceGUID)	end

		if sourceGUID == myGUID or infoText.pets[sourceGUID] then

			if Event == 'SWING_DAMAGE' then -- in SWING spellID = damage
				infoText.checkNewSpell( self, 6603, spellID, 0, 0)
			else
				infoText.checkNewSpell( self, spellID, spellDMG, over, school)
			end
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
	self:SetWidth( self.parent:GetWidth() / self.parentCount)
	self:RegisterEvent( 'COMBAT_LOG_EVENT_UNFILTERED')
	self:RegisterEvent( "UNIT_PET")
	self:RegisterEvent( 'PLAYER_LEAVE_COMBAT')
	self:RegisterEvent( 'PLAYER_REGEN_DISABLED')
	self:RegisterEvent( "PLAYER_REGEN_ENABLED")
	self:RegisterEvent( "ENCOUNTER_END")
	self:RegisterEvent( "ENCOUNTER_START")
	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", function( ) infoText:onEnter( self) end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onClick)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self.Text:SetFormattedText( infoText.displayString, "dps", 0, "") --,  SecondsToClocks( self.combatTime))
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)

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

infoText.infos.dps 		= Stat
infoText.infos.dps.name	= "DPS"

infoText.texts.dps 		= "DPS"
