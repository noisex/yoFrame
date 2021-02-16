local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.stbEnable then return end

--local eventData = {CombatLogGetCurrentEventInfo()};
--	local logEvent = eventData[2];
--	local unitGUID = eventData[8];
local spam = {}
local icons = {}
local schools = {}
local RT = " |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d.blp:6:6|t"
local blankTga = "|T".. yo.Media.path .. "textures\\Blank.blp:11:11:0:0:44:44:4:40:4:40|t"

local spellSchoolColor= {
	[1] =	{"#FFFF00", 1, 1, 0}, 		--Physical
	[2] =	{"#FFE680", 1, 0.9, 0.5},	--Holy
	[4] =	{"#FF8000",  1, 0.5, 0},	--Fire
	[8] =	{"#4DFF4D",  0.3, 1, 0.3},	--Nature
	[16] =	{"#80FFFF", 0.5, 1, 1},		--Frost
	[32] =	{"#8080FF", 0.5, 0.5, 1},	--Shadow
	[64] =	{"#FF80FF", 1, 0.5, 1},		--Arcane
}

local function GetBitSchool( school)
	if 		school >= 64 then return spellSchoolColor[64]
	elseif	school >= 32 then return spellSchoolColor[32]
	elseif	school >= 16 then return spellSchoolColor[16]
	elseif	school >= 8  then return spellSchoolColor[8]
	elseif	school >= 4  then return spellSchoolColor[4]
	elseif	school >= 2  then return spellSchoolColor[2]
	else return spellSchoolColor[1]
	end
end

local function CheckRT( self)
	local index

	if UnitExists("target") then
		index = GetRaidTargetIndex( "target")

	elseif UnitExists("pettarget") then
		index = GetRaidTargetIndex( "pettarget")
	end

	self.rt = index and format( RT,index) or "    "
end

local function ClearSpam( spellID)
	if not spam[spellID] then
		spam[spellID] = {
			["crit"] 	= false,
			["amount"] 	= 0,
			["tick"] 	= 0,
			["school"]	= 0,
			--['id']		= 0,
			--['name']	= '',
		}
	end
end

local function CreateSBT( self)

	local sbtD = CreateFrame("ScrollingMessageFrame", nil, self)
	sbtD:SetAllPoints( yoMoveSBT)
	sbtD:SetInsertMode( "TOP")
	sbtD:SetMaxLines( 25)
	sbtD:SetFading( true)

	sbtD:SetFont( n.font, n.fontsize + 8, "OUTLINE")
	sbtD:SetShadowColor( 0.3, 0.3, 0.3, 1)
	sbtD:SetShadowOffset( 1, -1)
	sbtD:SetJustifyH("LEFT")

	local sbtH = CreateFrame("ScrollingMessageFrame", nil, self)
	sbtH:SetAllPoints( yoMoveSBT)
	sbtH:SetInsertMode( "TOP")
	sbtH:SetMaxLines( 25)
	sbtH:SetFading( true)

	sbtH:SetFont( n.font, n.fontsize + 8, "OUTLINE")
	sbtH:SetShadowColor( 0.3, 0.3, 0.3, 1)
	sbtH:SetShadowOffset( 1, -1)
	sbtH:SetJustifyH("RIGHT")
	--sbtD:SetTimeVisible(C.combattext.time_visible)
	--sbtD:SetSpacing( 4)
	--sbtD:EnableMouse(true)
	--sbtD:SetMovable(true)
	--sbtD:SetResizable(true)
	--sbtD:SetMinResize(128, 128)
	--sbtD:SetMaxResize(768, 768)
	--sbtD:SetClampedToScreen(true)

	--sbtD:RegisterForDrag("LeftButton")
	--sbtD:SetScript("OnDragStart", sbtD.StartMoving)
	--sbtD:SetScript("OnDragStop", sbtD.StopMovingOrSizing)
	--sbtD:SetScript("OnSizeChanged", function(self)
		--self:SetMaxLines(math.floor(self:GetHeight() / (C.combattext.icon_size * 1.5)))
		--self:Clear()
	--end)

	self.sbtD = sbtD
	self.sbtH = sbtH
end


local function OnUpdate(self, elapled)

	self.tick = self.tick + elapled
	if self.tick < 1.4 then return end
	self.tick = 0

	for spellID, data in pairs( spam) do

		local crit = data.crit and "|cffff0000*|r" or "|cffff0000  |r"
		local text = crit .. commav( data.amount) .. crit
		local tick = data.tick <= 1 and "" or " |cff646464x" .. data.tick

		if not icons[spellID] then
			icons[spellID] = "|T".. select( 3, GetSpellInfo( data.id))..":11:11:0:0:44:44:4:40:4:40|t"
		end
		local icon = icons[spellID]

		if not schools[spellID] then
			schools[spellID] = GetBitSchool( data.school)
		end
		local cols = schools[spellID]

		spam[spellID] = nil

		if data.type == 1 then
			--self.sbtD:AddMessage( format( "%s %s %s %s %s", self.rt, icon, text,  blankTga, tick), cols[2], cols[3], cols[4])
			self.sbtD:AddMessage( format( "%s %s %s", self.rt, icon, text), cols[2], cols[3], cols[4])

			self.sbtH:AddMessage( format( "%s %s", blankTga, tick), cols[2], cols[3], cols[4])
		else
			--self.sbtH:AddMessage( format( "     %s %s %s %s", blankTga, text, icon, tick), cols[2], cols[3], cols[4])
			self.sbtH:AddMessage( format( "%s %s", text, icon), cols[2], cols[3], cols[4])

			self.sbtD:AddMessage( format( "|cffff0000    |r%s %s", tick, blankTga), cols[2], cols[3], cols[4])
		end
	end
end

local function CombatLogEvent( self, ...)
	local sourceName = select( 5, ...)

	if sourceName == n.myName or sourceName == myPet then
		local subEvent = select( 2, ...)

		if subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then

			local spellID = gsub( select( 13, ...), "%s%b()", "")

			ClearSpam( spellID)

			spam[spellID] = {
				["crit"] 	= spam[spellID].crit and spam[spellID].crit or select( 21, ...),
				["amount"] 	= spam[spellID].amount + select( 15, ...),
				["tick"] 	= spam[spellID].tick + 1,
				["school"]	= select( 14, ...),
				["type"]	= 1,
				["id"]		= select( 12, ...),
				--['name']	= name = GetSpellInfo(spellID),
			}
			--print( spellID, spam[spellID].amount, shortName, select( 24, ...))

		elseif subEvent == "SPELL_HEAL"
			or subEvent == "SPELL_PERIODIC_HEAL"
			then

			local spellID = select( 12, ...)
			ClearSpam( spellID)

			spam[spellID] = {
				["crit"] 	= spam[spellID].crit and spam[spellID].crit or select( 18, ...),
				["amount"] 	= spam[spellID].amount + select( 15, ...),
				["tick"] 	= spam[spellID].tick + 1,
				["school"]	= select( 14, ...),
				["type"]	= 2,
				["id"]		= select( 12, ...),
				--['name']	= name = GetSpellInfo(spellID),
			}
		end
	end
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.Addons.stbEnable then return end

		n.moveCreateAnchor("yoMoveSBT",			"Move Combat Text", 150, 205,	300, -100, 	"CENTER", "CENTER")
		CreateSBT( self)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("RAID_TARGET_UPDATE")
		self:RegisterEvent("UNIT_PET", "player")
		myPet = UnitExists("pet") and UnitName("pet") or nil
		CheckRT( self)

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		CombatLogEvent( self, CombatLogGetCurrentEventInfo())

	elseif event == "UNIT_PET" then
		myPet = UnitName("pet")

	elseif event == "PLAYER_REGEN_DISABLED" then
		spam = {}
		self.tick = 10
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnUpdate", OnUpdate)

	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SetScript("OnUpdate", nil)

	elseif event == "PLAYER_TARGET_CHANGED" or event == "RAID_TARGET_UPDATE" then
		CheckRT( self)
	end
end

local sbt = CreateFrame("Frame", "yo_sbtDname", UIParent)
sbt:RegisterEvent("PLAYER_ENTERING_WORLD")
sbt:SetScript("OnEvent", OnEvent)