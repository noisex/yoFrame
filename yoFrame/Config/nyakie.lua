local addonName, ns = ...
local L, yo, n = unpack( ns)

n.statusBars 	= {}
n.strings		= {}
n.shadows		= {}
n.unitFrames 	= {}
n.elemFrames	= {}
--n.spellsBooks 	= {}

n.infoTexts  	= CreateFrame("Frame")
n.version 	  	= GetAddOnMetadata( addonName, "Version")
n.scanTooltip 	= CreateFrame('GameTooltip', 'yoFrame_STT', UIParent, 'GameTooltipTemplate')
n.menuFrame 	= CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")

n.slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}


n.conFunc = function( var, ...)
	if n.conFuncs[var] then
		local conFunc = n.conFuncs[var]
		conFunc( var, ...)
	end
end

n.noReboot = {
	"texture", "fontsize", "sysfontsize", "AutoScale", "ScaleRate", "scriptErrors",
	"countLeft", "countRight", "left1", "left2", "left3", "left4", "left5", "left6", "right1", "right2", "right3", "right4", "right5", "right6",
}

n.conFuncs = {
	--["texture"] =
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
    [0] = "Нет, спасибо, не надо",
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

n.badMobsCasts = {
    --[258153] = true,
    --[258313] = true,
    --[274569] = true,
    --[278020] = true,
    --[261635] = true,
    --[272700] = true,
    --[268030] = true,
    --[265368] = true,
    --[264520] = true,
    --[265407] = true,
    --[278567] = true,
    --[278602] = true,
    --[258128] = true,
    --[257791] = true,
    --[258938] = true,
    --[265089] = true,
    --[272183] = true,
    --[256060] = true,
    --[257397] = true,
    --[269972] = true,
    --[270901] = true,
    --[270492] = true,
    --[263215] = true,
    --[268797] = true,
    --[262554] = true,
    --[253517] = true,
    --[255041] = true,
    --[252781] = true,
    --[250368] = true,
    --[258777] = true,
    --[278504] = true,
    --[266106] = true,
    --[257732] = true,
    --[268309] = true,
    --[269302] = true,
    --[263202] = true,
    --[257784] = true,
    --[278755] = true,
    --[272180] = true,
    --[263066] = true,
    --[267273] = true,
    --[265912] = true,
    --[274438] = true,
    --[268317] = true,
    --[268375] = true,
    --[276767] = true,
    --[264105] = true,
    --[265876] = true,
    --[270464] = true,
    --[278961] = true,
    --[265468] = true,
    --[256897] = true,
    --[280604] = true,
    --[268702] = true,
    --[255824] = true,
    --[253583] = true,
    --[250096] = true,
    --[278456] = true,
    --[262092] = true,
    --[257270] = true,
    --[267818] = true,
    --[265091] = true,
    --[262540] = true,
    --[263318] = true,
    --[263959] = true,
    --[257069] = true,
    --[256849] = true,
    --[267459] = true,
    --[253544] = true,
    --[268008] = true,
    --[267981] = true,
    --[272659] = true,
    --[264396] = true,
    --[257736] = true,
    --[264390] = true,
    --[255952] = true,
    --[257426] = true,
    --[274400] = true,
    --[272609] = true,
    --[269843] = true,
    --[269029] = true,
    --[272827] = true,
    --[269266] = true,
    --[263912] = true,
    --[264923] = true,
    --[258864] = true,
    --[256955] = true,
    --[265540] = true,
    --[260793] = true,
    --[270003] = true,
    --[270507] = true,
    --[257337] = true,
    --[268415] = true,
    --[275907] = true,
    --[268865] = true,
    --[260669] = true,
    --[260280] = true,
    --[253239] = true,
    --[265541] = true,
    --[250258] = true,
    --[256709] = true,
    --[277596] = true,
    --[276268] = true,
    --[265372] = true,
    --[263905] = true,
    --[265781] = true,
    --[257170] = true,
    --[268846] = true,
    --[270514] = true,
    --[258622] = true,
    --[256627] = true,
    --[257870] = true,
    --[258917] = true,
    --[263891] = true,
    --[268348] = true,
    --[272711] = true,
    --[271174] = true,
    --[268260] = true,
    --[269399] = true,
    --[268239] = true,
    --[264574] = true,
    --[261563] = true,
    --[257288] = true,
    --[257757] = true,
    --[267899] = true,
    --[255741] = true,
    --[260894] = true,
    --[263365] = true,
    --[260292] = true,
    --[263583] = true,
    --[272874] = true,
    --[264101] = true,
    --[264407] = true,
    --[271456] = true,
    --[262515] = true,
    --[275192] = true,
    --[256405] = true,
    --[270084] = true,
    --[257785] = true,
    --[267237] = true,
    --[266951] = true,
    --[267433] = true,
    --[255577] = true,
    --[255371] = true,
    --[270891] = true,
    --[267357] = true,
    --[258338] = true,
    --[257169] = true,
    --[270927] = true,
    --[260926] = true,
    --[264027] = true,
    --[267257] = true,
    --[253721] = true,
    --[265019] = true,
    --[260924] = true,
    --[263309] = true,
    --[266206] = true,
    --[260067] = true,
    --[274507] = true,
    --[276068] = true,
    --[263278] = true,
    --[258317] = true,
    --[256594] = true,
    --[268391] = true,
    --[268230] = true,
    --[260852] = true,
    --[267763] = true,
    --[268706] = true,
    --[264734] = true,
    --[270590] = true,
    --[290787] = true,
    --[275922] = true,
    --[269282] = true,
    --[274389] = true,
    --[258054] = true,
    --[259165] = true,
    --[269090] = true,
    --[277805] = true,
    --[282699] = true,
    --[278711] = true,
    --[268184] = true,
    --[268212] = true,
    --[257741] = true,
    --[266209] = true,
    --[270289] = true,
    --[267639] = true,
    --[268278] = true,
    --[258628] = true,
    --[266512] = true,
    --[260773] = true,
    --[269926] = true,
    --[268203] = true,
    --[256044] = true,
    --[257458] = true,
    --[300650] = true,
    --[300777] = true,
    --[300171] = true,
    --[299588] = true,
    --[299475] = true,
    --[299164] = true,
    --[298669] = true,
    --[300436] = true,
    --[297254] = true,
    --[301629] = true,
    --[284219] = true,
    --[285020] = true,
    --[283421] = true,
    --[294290] = true,
    --[291946] = true,
    --[291973] = true,
    --[297128] = true,
    --[293986] = true,
    --[295169] = true,
    --[293729] = true,
    --[298940] = true,
    --[296331] = true,
    --[298718] = true,
    --[295299] = true,
    --[300188] = true,
    --[265001] = true,
    --[294890] = true,
    --[314411] = true,
    --[314406] = true,
    --[298033] = true,
    --[305378] = true,
    --[320759] = true,
    --[300426] = true,
    --[297746] = true,
    --[315980] = true,
    --[304251] = true,
    --[308575] = true,
    --[309671] = true,
    --[308366] = true,
    --[306930] = true,
    --[309648] = true,
    --[309373] = true,
    --[301088] = true,
    --[297315] = true,
    --[306199] = true,
    --[256079] = true,
    --[311400] = true,
    --[311456] = true,
    --[308375] = true,
    --[308508] = true,
    --[305892] = true,
    --[303589] = true,
    --[306646] = true,
    --[306726] = true,
    --[296674] = true,
    --[299111] = true,
    --[302718] = true,
}