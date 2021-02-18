local addonName, ns = ...
local L, yo, n = unpack( ns)

n.Addons = {}
n.Addons.unitFrames = {}
n.Addons.actionBars = {}
n.Addons.raidFrames = {}
n.Addons.infoFrames = {}
n.Addons.filters 	= {}
n.Addons.moveFrames = {}
n.Addons.nameFrames = {}
n.Addons.elements 	= {}

n.Addons.elements.statusBars 	= {}
n.Addons.elements.strings		= {}
n.Addons.elements.shadows		= {}

n.talkingHead 	= yo_talkingHead

texture 		= 	yo.Media.texture
font 			= 	yo.Media.font

n.texture 		= 	yo.Media.texture
n.texhl 		=	yo.Media.texhl
n.texglow 		= 	yo.Media.texglow
n.font 			= 	yo.Media.font
n.fontChat		=	yo.Chat.chatFont
n.fontpx		=	yo.Media.fontpx
n.fontsize 		=	yo.Media.fontsize
n.fontstyle 	= 	"OUTLINE"
n.sysfontsize	=	yo.Media.sysfontsize

n.tCoord 		= {0.07, 0.93, 0.07, 0.93}
--n.tCoord 		= {0,1,0,1}
n.tCoordBig 	= {0.22, 0.78, 0.22, 0.78}
n.tCoordSmall 	= {0.07, 0.93, 0.07, 0.93}

n.myClass  		= select( 2, UnitClass( "player"))
n.mySpec    	= GetSpecialization()
--n.mySpecNum		= GetSpecializationInfo( n.mySpec)
n.myGUID   		= UnitGUID('player')
--mySpeClass  	= n.myClass .. n.mySpec
n.myColor  		= RAID_CLASS_COLORS[n.myClass]
n.myColorStr   	= "|c" .. RAID_CLASS_COLORS[n.myClass].colorStr
n.myName   		= UnitName( "player")
n.myRealm  		= GetRealmName()
n.myRealmShort	= select( 2, UnitFullName("player"))
n.myLogin  		= GetTime()
n.myClient   	= GetLocale()
n.myFaction  	= UnitFactionGroup("player")
n.myLevel  		= UnitLevel( "player")
n.myRace   		= select(2, UnitRace('player'))
n.mySex    		= UnitSex('player')

n.infoTexts  	= CreateFrame("Frame")
n.version 	  	= GetAddOnMetadata( addonName, "Version")
n.scanTooltip 	= CreateFrame('GameTooltip', 'yoFrame_STT', UIParent, 'GameTooltipTemplate')
n.menuFrame 	= CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")
n.Addons.infoFrames = n.infoTexts

n.slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}

n.conFuncs = {}
--n.conFuncs.Texture = func -- прописываем в модулях по строке

n.myDev = {
	["Нойзекс"] 	= true,
	["Дэмьер"] 		= true,
	["Ковальска"] 	= true,
	["Герсона"] 	= true,
	["Ыож"]			= true,
	--["Твитти"] 		= true,
}

n.dummy = function() return end
n.conFunc = function( var, ...)
	if n.conFuncs[var] then
		local conFunc = n.conFuncs[var]
		conFunc( var, ...)
	end
end

n.updateConfigData = function( db)

	print( db)
	n.yo = db
	_G[addonName][2] = db
end

n.IsSoloFree = function ( ... )

  local instanceType = select( 2, GetInstanceInfo())
  if instanceType ~= "none" then return false end

  if 	  UnitExists("party1") or UnitExists("raid1") then return false
  elseif  UnitInParty("player") then return false
  elseif  UnitInRaid("player")  then return false
  elseif  IsInInstance()      	then return false
    --and instanceType ~= "scenario" then return false
  else                 				 return true
  end
end

n.noReboot = {
	"texture", "fontsize", "sysfontsize", "AutoScale", "ScaleRate", "scriptErrors",
	"countLeft", "countRight", "left1", "left2", "left3", "left4", "left5", "left6", "right1", "right2", "right3", "right4", "right5", "right6",
	"fligerBuffCount", "fligerBuffSpell",
}

-- БЛы в ПОтатосе
n.bls = {
 	--[774] = true,     	-- "for esting..."   омоложение
    --[8936] = true,    	-- "for esting..." восстановление

    [80353] 	= true,     -- "Time Warp",
    [2825] 		= true,     -- "Bloodlust",
    [32182] 	= true,     -- "Heroism",
    [90355] 	= true,     -- "Ancient Hysteria",
    [160452] 	= true,    -- "Netherwinds",
    [178207] 	= true,    -- "Drums of Fury",
    [35475] 	= true,     -- "Drums of War",
    [230935] 	= true,   	-- "Drums of the Mountain"
    [264667]	= true, 	-- собачка ханта
}

n.tankDefs = {
	--[21562]	= true,
	--[6673]	= true,
	--[5697]	= true,
	--[238454]= true,
-- Death Knight / Blood
	[49028] = true, --  [Dancing Rune Weapon](https://www.wowhead.com/spell=49028)
	[48792] = true, --  [Icebound Fortitude](https://www.wowhead.com/spell=48792)
	[55233] = true, --  [Vampiric Blood](https://www.wowhead.com/spell=55233)
-- Demon Hunter / Vengeance
	[204021] = true, -- [Fiery Brand](https://www.wowhead.com/spell=204021)
	[187827] = true, -- [Metamorphosis](https://www.wowhead.com/spell=187827)
-- Druid / Guardian
	[22812] = true, --  [Barkskin](https://www.wowhead.com/spell=22812)
	[61336] = true, --  [Survival Instincts](https://www.wowhead.com/spell=61336)
	[22842] = true, --  Frenzied Regeneration
	[61336]	= true, --  Survival Instincts]
	[102342]= true, --  Ironbark
-- Monk / Brewmaster
	[115203] = true, -- [Fortifying Brew](https://www.wowhead.com/spell=115203)
    -- Note: The CD on this is approximated to 3 minutes, but could be much different in practice
	[115203] = true, -- [Zen Meditation](https://www.wowhead.com/spell=115203)
-- Paladin / Protection
	[31850] = true, --  [Ardent Defender](https://www.wowhead.com/spell=31850)
	[86659] = true, --  [Guardian of Ancient Kings](https://www.wowhead.com/spell=86659)
	[6940]	= true, --  Blessing of Sacrifice
-- Warrior / Protection
	[871]   = true, --  [Shield Wall](https://www.wowhead.com/spell=871)
	[12975] = true, --  [Last Stand](https://www.wowhead.com/spell=12975)
-- warlock
	[104773] = true, -- Твердая решимость
}

n.classEquipMap = {
	["WARRIOR"] 	= 4,
	["PALADIN"] 	= 4,
	["HUNTER"] 		= 3,
	["ROGUE"]	 	= 2,
	["PRIEST"] 		= 1,
	["DEATHKNIGHT"] = 4,
	["SHAMAN"] 		= 3,
	["MAGE"] 		= 1,
	["WARLOCK"] 	= 1,
	["MONK"] 		= 2,
	["DRUID"] 		= 2,
	["DEMONHUNTER"] = 2,
};

n.slotEquipType = {
	["INVTYPE_HEAD"]	=	{1},
	["INVTYPE_NECK"]	=	{2},
	["INVTYPE_SHOULDER"]=	{3},
	--["INVTYPE_BODY"]	=	4,
	["INVTYPE_CHEST"]	=	{5},
	["INVTYPE_ROBE"]	=	{5},
	["INVTYPE_WAIST"]	=	{6},
	["INVTYPE_LEGS"]	=	{7},
	["INVTYPE_FEET"]	=	{8},
	["INVTYPE_WRIST"]	=	{9},
	["INVTYPE_HAND"]	=	{10},
	["INVTYPE_FINGER"]	= 	{11, 12},
	["INVTYPE_TRINKET"]	=	{13, 14},
	["INVTYPE_CLOAK"]	=	{15},
	["INVTYPE_WEAPON"]	=	{16, 17},
	["INVTYPE_SHIELD"]	=	{17},
	["INVTYPE_2HWEAPON"]=	{16},
	["INVTYPE_WEAPONMAINHAND"]	=	{16},
	["INVTYPE_WEAPONOFFHAND"]	=	{17},
	--["INVTYPE_HOLDABLE"]=	{17,},
	["INVTYPE_RANGED"]	=	{16},
	--["INVTYPE_THROWN"]	=	{18,},
	["INVTYPE_RANGEDRIGHT"]={16,},
	--["INVTYPE_RELIC"]	=	{18,},
}

n.slot2HWeapon = {
	["INVTYPE_2HWEAPON"]=	true,
	["INVTYPE_RANGED"]	=	true,
	["INVTYPE_RANGEDRIGHT"]=true,
}

n.questTypesIndex = {
	[0]  = "",           									--default
	[1]  = " |cff00ff00"..PARTY.."|r",						--Group
	[41] = " |cffff0000PvP|r",								--PvP
	[62] = " |cff00ff00"..LFG_TYPE_RAID.."|r",				--Raid
	[81] = " |cff0080ff" ..LFG_TYPE_DUNGEON.. "|r",
	[83] = " |cffff7000"..LOOT_JOURNAL_LEGENDARIES.."|r",	--Legendary
	[85] = " |cff8000ff"..ITEM_HEROIC.."|r",				--Heroic
	[98] = " |cffff8000"..TRACKER_HEADER_SCENARIO.."|r", 	--Scenario QUEST_TYPE_SCENARIO
	[102]= " |cff0080ffAccount|r", 							-- Account
	[226]= " |cff0080ffCombat|r", 							-- Combat Ally
}

n.pType = {
	MAGE 		= { powerID = 16,	powerType = 'ARCANE_CHARGES', 	spec = 1},
	WARLOCK 	= { powerID = 7, 	powerType = 'SOUL_SHARDS'		},
	PALADIN 	= { powerID = 9, 	powerType = 'HOLY_POWER'		}, --, 		spec = 3},
	ROGUE 		= { powerID = 4, 	powerType = 'COMBO_POINTS'		},
	DRUID 		= { powerID = 4, 	powerType = 'COMBO_POINTS', 	},	--spec = 2},
	DEATHKNIGHT = { powerID = 5, 	powerType = 'RUNES'				},
	MONK 		= { powerID = 12, 	powerType = 'CHI', 				spec = 3},
}

n.classSpecsCoords = {
  [577] = { tCoord 		= {128/512, 192/512, 256/512, 320/512},
			enchSlot 	= "FeetSlot",}, 							--> havoc demon hunter
  [581] = { tCoord 		= {192/512, 256/512, 256/512, 320/512},
			enchSlot 	= "FeetSlot",}, 							--> vengeance demon hunter

  [250] = { tCoord 		= {0, 64/512, 0, 64/512},
			enchSlot 	= "HandsSlot",}, 							--> blood dk
  [251] = { tCoord 		= {64/512, 128/512, 0, 64/512},
			enchSlot 	= "HandsSlot",}, 							--> frost dk
  [252] = { tCoord 		= {128/512, 192/512, 0, 64/512},
			enchSlot 	= "HandsSlot",}, 							--> unholy dk

  [102] = { tCoord 		= {192/512, 256/512, 0, 64/512},
			enchSlot 	= "WristSlot",}, 							-->  druid balance
  [103] = { tCoord 		= {256/512, 320/512, 0, 64/512},
			enchSlot 	= "FeetSlot",}, 							-->  druid feral
  [104] = { tCoord 		= {320/512, 384/512, 0, 64/512},
			enchSlot 	= "FeetSlot",}, 								-->  druid guardian
  [105] = { tCoord 		= {384/512, 448/512, 0, 64/512},
			enchSlot	= "WristSlot",}, 								-->  druid resto

  [253] = { tCoord 		= {448/512, 512/512, 0, 64/512},
			enchSlot 	= "FeetSlot",}, 								-->  hunter bm
  [254] = { tCoord 		= {0, 64/512, 64/512, 128/512},
			enchSlot 	= "FeetSlot",}, 								--> hunter marks
  [255] = { tCoord 		= {64/512, 128/512, 64/512, 128/512},
			enchSlot 	= "FeetSlot",}, 								--> hunter survivor

  [62] = { tCoord 		= {(128/512) + 0.001953125, 192/512, 64/512, 128/512},
			enchSlot 	= "WristSlot",}, 								--> mage arcane
  [63] = { tCoord 		= {192/512, 256/512, 64/512, 128/512},
			enchSlot 	= "WristSlot",}, 								--> mage fire
  [64] = { tCoord 		= {256/512, 320/512, 64/512, 128/512},
			enchSlot 	= "WristSlot",}, 								--> mage frost

  [268] = { tCoord 		= {320/512, 384/512, 64/512, 128/512},
			enchSlot 	= "FeetSlot",}, 								--> monk bm
  [269] = { tCoord 		= {448/512, 512/512, 64/512, 128/512},
			enchSlot 	= "FeetSlot",}, 								--> monk ww
  [270] = { tCoord 		= {384/512, 448/512, 64/512, 128/512},
			enchSlot 	= "FeetSlot",}, 								--> monk mw

  [65] = { 	tCoord 		= {0, 64/512, 128/512, 192/512},
			enchSlot 	= "WristSlot",}, 								--> paladin holy
  [66] = { 	tCoord 		= {64/512, 128/512, 128/512, 192/512},
			enchSlot 	= "HandsSlot",}, 								--> paladin protect
  [70] = { 	tCoord 		= {(128/512) + 0.001953125, 192/512, 128/512, 192/512},
			enchSlot 	= "HandsSlot",}, 								--> paladin ret

  [256] = { tCoord 		= {192/512, 256/512, 128/512, 192/512},
			enchSlot 	= "WristSlot",}, 								--> priest disc
  [257] = { tCoord 		= {256/512, 320/512, 128/512, 192/512},
			enchSlot 	= "WristSlot",}, 								--> priest holy
  [258] = { tCoord 		= {(320/512) + (0.001953125 * 4), 384/512, 128/512, 192/512},
			enchSlot 	= "WristSlot",}, 								--> priest shadow

  [259] = { tCoord 		= {384/512, 448/512, 128/512, 192/512},
			enchSlot 	= "FeetSlot",}, 								--> rogue assassination
  [260] = { tCoord 		= {448/512, 512/512, 128/512, 192/512},
			enchSlot 	= "FeetSlot",}, 								--> rogue combat
  [261] = { tCoord 		= {0, 64/512, 192/512, 256/512},
			enchSlot 	= "FeetSlot",}, 								--> rogue sub

  [262] = { tCoord 		= {64/512, 128/512, 192/512, 256/512},
			enchSlot 	= "WristSlot",}, 								--> shaman elemental
  [263] = { tCoord 		= {128/512, 192/512, 192/512, 256/512},
			enchSlot 	= "FeetSlot",}, 								--> shamel enhancement
  [264] = { tCoord 		= {192/512, 256/512, 192/512, 256/512},
			enchSlot 	= "WristSlot",}, 								--> shaman resto

  [265] = { tCoord 		= {256/512, 320/512, 192/512, 256/512},
			enchSlot 	= "WristSlot",}, 								--> warlock aff
  [266] = { tCoord 		= {320/512, 384/512, 192/512, 256/512},
			enchSlot 	= "WristSlot",}, 								--> warlock demo
  [267] = { tCoord 		= {384/512, 448/512, 192/512, 256/512},
			enchSlot 	= "WristSlot",}, 								--> warlock destro

  [71] = { 	tCoord 		= {448/512, 512/512, 192/512, 256/512},
			enchSlot 	= "HandsSlot",}, 								--> warrior arms
  [72] = { 	tCoord 		= {0, 64/512, 256/512, 320/512},
			enchSlot 	= "HandsSlot",}, 								--> warrior fury
  [73] = { 	tCoord 		= {64/512, 128/512, 256/512, 320/512},
			enchSlot 	= "HandsSlot",}, 								--> warrior protect
}

-- List of spells to display ticks
n.channelTicks = {
	-- Warlock
	[198590] = 5,	-- Drain Soul
	[755]    = 6,	-- Health Funnel
	[234153] = 6,	-- Drain Life
	-- Priest
	[64843]  = 4,	-- Divine Hymn
	[15407]  = 4,	-- Mind Flay
	[48045]  = 5,	-- Mind Sear
	[47757]  = 5,	-- Penance
	-- Mage
	[5143]   = 5,	-- Arcane Missiles
	[12051]  = 3,	-- Evocation
	[205021] = 10,	-- Ray of Frost
	-- Druid
	[740]    = 4,	-- Tranquility
}

--- в найплейты для синей полосы НАДО ЧТо-то ДЕАЛТЬ С ЭТИМ!!!
n.interuptSpells = {
	-- Speck Knock
	[47528]  = 15, --Mind Freeze
    [106839] = 15, --Skull Bash
    [78675]  = 60, --Solar Beam
    [183752] = 15, --Consume Magic
    [147362] = 24, --Counter Shot
    [187707] = 15, --Muzzle
    [2139]   = 24, --Counter Spell
    [116705] = 15, --Spear Hand Strike
    [96231]  = 15, --Rebuke
    [15487]  = 45, --Silence
    [1766]   = 15, --Kick
    [57994]  = 12, --Wind Shear
    [6552]   = 15, --Pummel
    [171140] = 24, --Shadow прист
	[171138] = 24, --Shadow прист if used from pet bar
	[119910] = 24, -- warloc new pet
	[19647]	 = 24, -- Запрет чар
}

n.dungensTypes = {
    [0]     = L["dungThank"],
    [258]   = "Dungeon Classic",
    [259]   = "Dungeon BC ",
    [260]   = "Heroic BC ",
    [261]   = "Dungeon Lich King",
    [262]   = "Heroic Lich King",
    [300]   = "Dungeon Cataclysm",
    [301]   = "Heroic Cataclysm",
    [462]   = "Heroic Pandaria",
    [463]   = "Dungeon Pandaria ",
    [788]   = "Dungeon WoD",
    [789]   = "Heroic WoD",
    [1045]  = "Dungeon Legion",
    [1046]  = "Heroic Legion",
    [1670]  = "Dungeon BfA",
    [1671]  = "Heroic BfA",
    [2086]  = "Dungeon Shadowlands",
    [2087]  = "Heroic Shadowlands",
}


--164926
--163086

--171581