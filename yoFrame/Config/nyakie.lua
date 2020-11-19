local addonName, ns = ...
local L, yo, N = unpack( ns)

N.statusBars 	= {}
N.strings		= {}
N.shadows		= {}
N.spellsBooks 	= {}

N.infoTexts  	= CreateFrame("Frame")
N.version 	  	= GetAddOnMetadata( addonName, "Version")
N.scanTooltip 	= CreateFrame('GameTooltip', 'yoFrame_STT', UIParent, 'GameTooltipTemplate')
N.menuFrame 	= CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")

N.slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}


N.conFunc = function( var, ...)
	if N.conFuncs[var] then
		local conFunc = N.conFuncs[var]
		conFunc( var, ...)
	end
end

N.noReboot = {
	"texture", "fontsize", "sysfontsize", "AutoScale", "ScaleRate", "scriptErrors",
	"countLeft", "countRight", "left1", "left2", "left3", "left4", "left5", "left6", "right1", "right2", "right3", "right4", "right5", "right6",
}

N.conFuncs = {
	--["texture"] =
}

-- БЛы в ПОтатосе
N.bls = {
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

N.tankDefs = {
	--[21562]	= true,
	--[6673]	= true,
	--[5697]	= true,
	--[238454]= true,
-- Death Knight / Blood
	[49028] = true, --  [Dancing Rune Weapon](https://www.wowhead.com/spell=49028)
	[48792] = true, --  [Icebound Fortitude](https://www.wowhead.com/spell=48792)
	[55233] = true, --  [Vampiric Blood](https://www.wowhead.com/spell=55233)
-- Demon Hunter / Vengeance
	[204021] = true, --  [Fiery Brand](https://www.wowhead.com/spell=204021)
	[187827] = true, --  [Metamorphosis](https://www.wowhead.com/spell=187827)
-- Druid / Guardian
	[22812] = true, --  [Barkskin](https://www.wowhead.com/spell=22812)
	[61336] = true, --  [Survival Instincts](https://www.wowhead.com/spell=61336)
	[22842] = true, --  -- Frenzied Regeneration
	[61336]	= true, -- Survival Instincts]
	[102342]= true, -- Ironbark
-- Monk / Brewmaster
	[115203] = true, --  [Fortifying Brew](https://www.wowhead.com/spell=115203)
    -- Note: The CD on this is approximated to 3 minutes, but could be much different in practice
	[115203] = true, --  [Zen Meditation](https://www.wowhead.com/spell=115203)
-- Paladin / Protection
	[31850] = true, --  [Ardent Defender](https://www.wowhead.com/spell=31850)
	[86659] = true, --  [Guardian of Ancient Kings](https://www.wowhead.com/spell=86659)
	[6940]	= true, --  Blessing of Sacrifice
-- Warrior / Protection
	[871] = true, --  [Shield Wall](https://www.wowhead.com/spell=871)
	[12975] = true, --  [Last Stand](https://www.wowhead.com/spell=12975)
-- warlock
	[104773] = true, -- Твердая решимость
}

N.classEquipMap = {
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

N.slotEquipType = {
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

N.questTypesIndex = {
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

N.pType = {
	MAGE 		= { powerID = 16,	powerType = 'ARCANE_CHARGES', 	spec = 1},
	WARLOCK 	= { powerID = 7, 	powerType = 'SOUL_SHARDS'		},
	PALADIN 	= { powerID = 9, 	powerType = 'HOLY_POWER'		}, --, 		spec = 3},
	ROGUE 		= { powerID = 4, 	powerType = 'COMBO_POINTS'		},
	DRUID 		= { powerID = 4, 	powerType = 'COMBO_POINTS', 	},	--spec = 2},
	DEATHKNIGHT = { powerID = 5, 	powerType = 'RUNES'				},
	MONK 		= { powerID = 12, 	powerType = 'CHI', 				spec = 3},
}


N.classSpecsCoords = {
  [577] = {128/512, 192/512, 256/512, 320/512}, --> havoc demon hunter
  [581] = {192/512, 256/512, 256/512, 320/512}, --> vengeance demon hunter

  [250] = {0, 64/512, 0, 64/512}, --> blood dk
  [251] = {64/512, 128/512, 0, 64/512}, --> frost dk
  [252] = {128/512, 192/512, 0, 64/512}, --> unholy dk

  [102] = {192/512, 256/512, 0, 64/512}, -->  druid balance
  [103] = {256/512, 320/512, 0, 64/512}, -->  druid feral
  [104] = {320/512, 384/512, 0, 64/512}, -->  druid guardian
  [105] = {384/512, 448/512, 0, 64/512}, -->  druid resto

  [253] = {448/512, 512/512, 0, 64/512}, -->  hunter bm
  [254] = {0, 64/512, 64/512, 128/512}, --> hunter marks
  [255] = {64/512, 128/512, 64/512, 128/512}, --> hunter survivor

  [62] = {(128/512) + 0.001953125, 192/512, 64/512, 128/512}, --> mage arcane
  [63] = {192/512, 256/512, 64/512, 128/512}, --> mage fire
  [64] = {256/512, 320/512, 64/512, 128/512}, --> mage frost

  [268] = {320/512, 384/512, 64/512, 128/512}, --> monk bm
  [269] = {448/512, 512/512, 64/512, 128/512}, --> monk ww
  [270] = {384/512, 448/512, 64/512, 128/512}, --> monk mw

  [65] = {0, 64/512, 128/512, 192/512}, --> paladin holy
  [66] = {64/512, 128/512, 128/512, 192/512}, --> paladin protect
  [70] = {(128/512) + 0.001953125, 192/512, 128/512, 192/512}, --> paladin ret

  [256] = {192/512, 256/512, 128/512, 192/512}, --> priest disc
  [257] = {256/512, 320/512, 128/512, 192/512}, --> priest holy
  [258] = {(320/512) + (0.001953125 * 4), 384/512, 128/512, 192/512}, --> priest shadow

  [259] = {384/512, 448/512, 128/512, 192/512}, --> rogue assassination
  [260] = {448/512, 512/512, 128/512, 192/512}, --> rogue combat
  [261] = {0, 64/512, 192/512, 256/512}, --> rogue sub

  [262] = {64/512, 128/512, 192/512, 256/512}, --> shaman elemental
  [263] = {128/512, 192/512, 192/512, 256/512}, --> shamel enhancement
  [264] = {192/512, 256/512, 192/512, 256/512}, --> shaman resto

  [265] = {256/512, 320/512, 192/512, 256/512}, --> warlock aff
  [266] = {320/512, 384/512, 192/512, 256/512}, --> warlock demo
  [267] = {384/512, 448/512, 192/512, 256/512}, --> warlock destro

  [71] = {448/512, 512/512, 192/512, 256/512}, --> warrior arms
  [72] = {0, 64/512, 256/512, 320/512}, --> warrior fury
  [73] = {64/512, 128/512, 256/512, 320/512}, --> warrior protect
}

-- List of spells to display ticks
N.channelTicks = {
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
N.interuptSpells = {
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