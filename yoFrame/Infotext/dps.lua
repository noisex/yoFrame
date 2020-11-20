local L, yo, N = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end


local infoText 	= N.infoTexts
local Stat 		= CreateFrame("Frame", nil, UIParent)
local aaName 	= GetSpellInfo( 6603)

local time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID, myGUID, GameTooltip, type
	= time, max, strjoin, CombatLogGetCurrentEventInfo, UnitGUID, myGUID, GameTooltip, type

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

--- 					spellID, 		spellName, 		spellDMG, 		over, 		spellSchool
--local defaultArgs = { ["arg1"] = 12, ["arg2"] = 13, ["arg3"] = 15, ["arg4"] = 16, ["arg5"] = 14}
local function spellDamage( cleuInfo)
	--print( cleuInfo[12], cleuInfo[13], cleuInfo[15], cleuInfo[16] or 0, cleuInfo[14])

	return	cleuInfo[12], cleuInfo[13], cleuInfo[15], cleuInfo[16] or 0, cleuInfo[14]
end

local events = {
	SWING_DAMAGE = { ["val1"] = 6603, ["val2"] = aaName, ["arg3"] = 12, ["val4"] = 0, ["val5"] = 0,},
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true, 	--spellDamage,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true,
	SPELL_EXTRA_ATTACKS = true
}

function Stat:onEvent( event, ...)

	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local cleuInfo 		= {CombatLogGetCurrentEventInfo()}
		local Event 		= cleuInfo[2]
		local sourceGUID 	= cleuInfo[4]
		local sourceMask 	= cleuInfo[6]

		if not self.inCombat then return end
		if not events[Event] then return end
		--print(Event, sourceGUID, name, sourceMask)
		--8465 = guardian

		if ( sourceMask == 4369 or sourceMask == 8465) and not infoText.petBlacklist[sourceGUID] then infoText:checkPets( sourceGUID)	end

		if sourceGUID == myGUID or infoText.pets[sourceGUID] then

			local spellID 		= cleuInfo[12]
			local spellName 	= cleuInfo[13]
			local spellDMG 		= cleuInfo[15]
			local spellOver 	= cleuInfo[16] or 0
			local spellSchool 	= cleuInfo[14]
			local spellCrit		= cleuInfo[21]

			if type( events[Event]) == "table" then
				spellID 	= cleuInfo[ events[Event].arg1] or events[Event].val1
				spellName 	= cleuInfo[ events[Event].arg2] or events[Event].val2
				spellDMG 	= cleuInfo[ events[Event].arg3] or events[Event].val3
				spellOver	= cleuInfo[ events[Event].arg4] or events[Event].val4 or 0
				spellSchool = cleuInfo[ events[Event].arg5] or events[Event].val5

			elseif type( events[Event]) == "function" then
				spellID, spellName, spellDMG, spellOver, spellSchool = events[Event]( cleuInfo)
			end

			--spellID 	= events[Event] == true and cleuInfo[ defaultArgs.arg1 ] or cleuInfo[ events[Event].arg1] or events[Event].val1
			--spellName 	= events[Event] == true and cleuInfo[ defaultArgs.arg2 ] or cleuInfo[ events[Event].arg2] or events[Event].val2
			--spellDMG 	= events[Event] == true and cleuInfo[ defaultArgs.arg3 ] or cleuInfo[ events[Event].arg3] or events[Event].val3
			--over 		= events[Event] == true and cleuInfo[ defaultArgs.arg4 ] or cleuInfo[ events[Event].arg4] or events[Event].val4 or 0
			--spellSchool = events[Event] == true and cleuInfo[ defaultArgs.arg5 ] or cleuInfo[ events[Event].arg5] or events[Event].val5

			infoText.checkNewSpell( self, myGUID, spellID, spellName, spellDMG, spellOver, spellSchool, spellCrit)
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
