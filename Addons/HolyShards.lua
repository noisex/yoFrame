local L, yo = unpack( select( 2, ...))

-- sourced from FrameXML/Constants.lua
local SPEC_MAGE_ARCANE = SPEC_MAGE_ARCANE or 1
local SPEC_MONK_WINDWALKER = SPEC_MONK_WINDWALKER or 3
local SPEC_PALADIN_RETRIBUTION = SPEC_PALADIN_RETRIBUTION or 3
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION or 3
local SPELL_POWER_ENERGY = Enum.PowerType.Energy or 3
local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints or 4
local SPELL_POWER_RUNES = SPELL_POWER_RUNES or 5
local SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards or 7
local SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower or 9
local SPELL_POWER_CHI = Enum.PowerType.Chi or 12
local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges or 16


local ClassPowerID, ClassPowerType, holyShardsPoints
local holyShardBarWidth = 105

if(myClass == 'MONK') then
	ClassPowerID = SPELL_POWER_CHI
	ClassPowerType = 'CHI'
	RequireSpec = SPEC_MONK_WINDWALKER
elseif(myClass == 'PALADIN') then
	ClassPowerID = SPELL_POWER_HOLY_POWER
	ClassPowerType = 'HOLY_POWER'
	RequireSpec = SPEC_PALADIN_RETRIBUTION
elseif(myClass == 'WARLOCK') then
	ClassPowerID = SPELL_POWER_SOUL_SHARDS
	ClassPowerType = 'SOUL_SHARDS'
elseif(myClass == 'DEATHKNIGHT') then
	ClassPowerID = SPELL_POWER_RUNES
	ClassPowerType = 'RUNES'
elseif(myClass == 'ROGUE' or myClass == 'DRUID') then
	ClassPowerID = SPELL_POWER_COMBO_POINTS
	ClassPowerType = 'COMBO_POINTS'

	--if(myClass == 'DRUID') then
	--	RequirePower = SPELL_POWER_ENERGY
	--	RequireSpell = 5221 -- Shred
	--end
elseif(myClass == 'MAGE') then
	ClassPowerID = SPELL_POWER_ARCANE_CHARGES
	ClassPowerType = 'ARCANE_CHARGES'
	RequireSpec = SPEC_MAGE_ARCANE
end

local pType = {
	MAGE 		= 1,
	WARLOCK 	= 7,
	PALADIN 	= 9,
	ROGUE 		= 4,
	DRUID 		= 4,
	DEATHKNIGHT = 5,		
	MONK 		= 12, 			
}
local totClass = {
	DRUID	= 1
}

local function isDruid( self, myClass)
	if myClass == "DRUID" and GetShapeshiftFormID() ~= 1 then 
		self:Hide()
		return false
	else
		self:Show()
		return true
	end
end

local function pwUpdate( self, pToken)
	local up =  UnitPower( "player", pToken)
	
	for i = 1, self.idx do
		if(i <= up) then
			self[i]:SetAlpha( 1)
		else
			self[i]:SetAlpha( 0.2)
		end
	end
end
		
 local function CreateShards( self)

 	self:SetWidth( holyShardBarWidth)

	if self.idx then
		for i = 1, self.idx do
			self[i]:SetParent( nil)
			self[i]:ClearAllPoints()
			self[i] = nil
		end
	end

	if pType[myClass] then
		self.idx = UnitPowerMax( "player", ClassPowerID)
	else 
		return 
	end

	for i = 1, self.idx do
		if i == 1 then
			holyShardsPoints = {'LEFT', self, 'LEFT', 0, 0}
		else
			holyShardsPoints = {'LEFT', self[i-1], 'RIGHT', 1, 0}
		end
		
		self[i] = CreateFrame('StatusBar', nil, self)
		self[i]:SetStatusBarTexture( texture)
		self[i]:SetPoint( unpack(holyShardsPoints))
		self[i]:SetStatusBarColor( self:GetParent().colr, self:GetParent().colg, self:GetParent().colb, 1)
		self[i]:SetHeight( self:GetHeight())
		self[i]:SetWidth(self:GetWidth() / self.idx)
		self[i]:SetFrameLevel( 5)
		--if not self[i].shadow then CreateStyle( self[i], 2, 4) end
	end

	self:SetWidth( self:GetWidth() + self.idx - 1)
	
	isDruid( self, myClass)
	pwUpdate( self, ClassPowerID)
end

local function OnEvent( self, event, unit, pToken, ...)
	--print( event, " ptoken: ", pToken, " ID: ", ClassPowerID, " Type: ", ClassPowerType, ...)
	
	if event == "RUNE_POWER_UPDATE" then
		for i = 1, 6 do
			local start, duration, runeReady = GetRuneCooldown( i)
			--print( start, runeReady, i)
			if runeReady then
				self[i]:SetAlpha(1)
				self[i]:SetScript("OnUpdate", nil)
				self[i]:SetValue( 10)
			elseif start then
				self[i]:SetAlpha( .4)
				self[i]:SetMinMaxValues( 0, duration)
				self[i].mini = GetTime() - start
				self[i].id = i
				self[i].start = start
				self[i].duration = duration
		
				self[i]:SetScript("OnUpdate", function(self, elapsed)
					local value = self.mini + elapsed
					self:SetValue( value)
					self.mini = value
				end)
			end
		end
		
	elseif event == "UNIT_MAXPOWER" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		CreateShards( self)
		
	elseif event == "UNIT_DISPLAYPOWER" then
		isDruid( self, myClass) 
				
	elseif event == "PLAYER_TOTEM_UPDATE" then
		--print( "toto up", event, unit, pToken, ...)
		haveTotem, totemName, startTime, duration, icon = GetTotemInfo( "player")
		--print( haveTotem, totemName, startTime, duration, icon)
		
	elseif pType[myClass] and  ClassPowerType == pToken then
		pwUpdate( self, ClassPowerID, ...)
	end
    
 end

local function CreateShardsBar( f)
	local holyShards = f.holyShards or CreateFrame( "Frame", nil, f)
	holyShards:SetPoint('TOPLEFT', f, 'TOPLEFT', 4, -3)
	holyShards:SetWidth( holyShardBarWidth)
	holyShards:SetHeight( 5)
	--holyShards:SetFrameLevel(4)

	holyShards:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	holyShards:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
	holyShards:RegisterEvent("RUNE_POWER_UPDATE")
	holyShards:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	
	holyShards:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	--holyShards:RegisterEvent("PLAYER_TALENT_UPDATE")
	--holyShards:RegisterEvent("PLAYER_TOTEM_UPDATE");

	holyShards:SetScript("OnEvent", OnEvent)
	if not holyShards.shadow then CreateStyle( holyShards, 3, 4) end
	
	f.holyShards = holyShards
	CreateShards( f.holyShards)
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.unitFrames then return end
	
	if pType[myClass] then
		CreateShardsBar( plFrame)	
	end
end)
