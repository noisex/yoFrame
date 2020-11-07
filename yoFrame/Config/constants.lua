local addonName, ns = ...
local L, yo, N = unpack( ns)

-- название школы по индексу  _G.CombatLog_String_SchoolString(key))

myClass 	= select( 2, UnitClass( "player"))
mySpec 		= GetSpecialization()
myGUID		= UnitGUID('player')
--mySpeClass	= myClass .. mySpec
myColor 	= RAID_CLASS_COLORS[myClass]
myColorStr 	= "|c" .. RAID_CLASS_COLORS[myClass].colorStr
myName		= UnitName( "player")
myRealm 	= GetRealmName()
myRealmShort= select( 2, UnitFullName("player"))
myLogin 	= GetTime()
myClient 	= GetLocale()
myFaction 	= UnitFactionGroup("player")
myLevel 	= UnitLevel( "player")
myRace		= select(2, UnitRace('player'))
mySex		= UnitSex('player')

myDev = {
	["Нойзекс"] 	= true,
	["Дэмьер"] 		= true,
	["Ковальска"] 	= true,
	["Герсона"] 	= true,
	--["Твитти"] 		= true,
}

dummy = function() return end

dprint = function(...)
	if myDev[myName] then
		print("|cff33ff99yoDev: |cff999999" .. ... )
	end
end

N["statusBars"] 	= {}
N["strings"]		= {}
N["shadows"]		= {}
N["spellsBooks"] 	= {}

N.version 	  	= GetAddOnMetadata( addonName, "Version")
N.ScanTooltip 	= CreateFrame('GameTooltip', 'yoFrame_ScanTooltip', UIParent, 'GameTooltipTemplate')
N.menuFrame 	= CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")

N.slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
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

N.QuestTypesIndex = {
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

N.conFunc = function( var, ...)
	if N.conFuncs[var] then
		local conFunc = N.conFuncs[var]
		conFunc( var, ...)
	end
end

N.noReboot = {
	"texture", "fontsize", "sysfontsize", "AutoScale", "ScaleRate", "scriptErrors"
}

N.conFuncs = {
	--["texture"] =
}

yo["InfoTexts"] = {
	["enable"] 			= true,
	["countLeft"] 		= 4,
	["countRight"]		= 4,
	["left1"]			= "system",
	["left2"]			= "dura",
	["left3"]			= "guild",
	["left4"]			= "friend",
	["left5"]			= "",
	["left6"]			= "",
	["right1"]			= "gold",
	["right2"]			= "spec",
	["right3"]			= "bags",
	["right4"]			= "time",
	["right5"]			= "",
	["right6"]			= "",
}

yo["General"] = {
	["1st"] 			= true,
	["cFrame"] 			= 0,
	["cConfig"] 		= 0,
	["scriptErrors"]	= false,
	["spellDelay"]		= false
}

yo["ToolTip"] = {
	["enable"]			= true,
	["IDInToolTip"]		= false,
	["ladyMod"]			= true,
	["ladyModShift"]	= false,
	["showSpells"]		= true,
	["showSpellShift"] 	= false,
	["showSpellsVert"]	= false,
	["showBorder"]		= true,
	["borderClass"]= true,
}

yo["Bags"] = {
	["enable"] 				= true,
	["numContainerColumns"] = 11,
	["buttonSize"] 			= 32,
	["buttonSpacing"] 		= 7,
	["numMaxRow"]			= 16,
	["containerWidth"] 		= 438,
	["newIconAnimation"]	= true,
	["autoReagent"]			= true,
	["newAnimationLoop"]	= true,
	["showAltBags"]			= true,
	["showGuilBank"]		= true,
	["countAltBags"]		= true,
	["LeftToRight"]			= false,
}

yo["Addons"] = {
	["ChangeSystemFonts"] 			= true,			--
	["FlashIconCooldown"] 			= true,
	["RaidUtilityPanel"] 			= true,
	["ArtifactPowerbar"] 			= true,
	["PredictionHealth"] 			= true,
	["ReColorNamePlates"] 			= true,
	["AutoRepair"] 					= true,			--
	["RepairGuild"]					= true,
	["AutoGreedOnLoot"] 			= true,
	["AutoSellGrayTrash"] 			= false,		--
	["AutoScreenOnLvlUp"] 	= true,			--
	["AutoScreenOnAndAchiv"]		= true,
	["AutoDisenchantGreenLoot"] 	= true,
	["BarChat"] 					= true,
	["Potatos"] 					= false,			--
	["mythicProcents"] 				= true,
	["MiniMap"] 					= true,
	["MiniMapCoord"] 				= true,
	["MMColectIcons"]				= true,
	["MiniMapHideText"]				= false,
	["MiniMapSize"]					= 150,
	["MMFogOfWar"]					= true,
	["MMCoordColor"]				= "0.7,0.7,0.7",
	["MMCoordSize"] 				= 9,
	["InfoPanels"] 					= true,
	["BlackPanels"] 				= true,
	["ActionsBars"] 				= true,
	["RaidCoolDowns"] 				= true,
	["RaidFrames"] 					= true,
	["AutoInvaitFromFriends"] 		= true,
	["CastWatcher"] 				= false,
	["CastWatchSound"] 				= "Applause",
	["TauntWatcher"] 				= true,
	["TauntWatchSound"] 			= "Tick 02",
	["AutoQuest"]					= true,
	["AutoQuestEnhance"]			= false,
	["AutoQuestComplete"]			= true,
	["AutoQuestSkipScene"]			= true,
	["AutoQuestComplete2Choice"]	= true,
	["showToday"]					= true,
	["ObjectiveTracker"]			= true,
	["ObjectiveHeight"]				= 500,
	["ObjectiveShort"]				= false,
	["hideObjective"]				= false,
	["cheloBuff"]					= false,
	["equipNewItem"]				= true,
	["equipNewItemLevel"]			= 170,
	["afk"]							= false,
	["stbEnable"]					= false,
	["MoveBlizzFrames"]				= true,
	["AutoInvite"]					= true,
	["AutoLeader"]					= false,
	["disenchanting"]				= true,
}

yo["ActionBar"] = {
	["enable"]		= true,
	["ShowGrid"]	= true,
	["HideHotKey"]	= true,
	["CountSize"]	= 13,
	["HideName"]	= true,
	["MicroMenu"]	= true,
	["MicroScale"]	= 0.75,
	["panel3Cols"]	= 6,
	["panel3Nums"]	= 12,
	["buttonsSize"]	= 35,
	["buttonSpace"]	= 2,
	["hoverTexture"]= true,
	["showBar3"]	= false,
	["showBar5"]	= false,
	["showNewGlow"]	= false,

}

yo["CastBar"] = {
	["player"] = {
		["enable"]		= true,
		["bigBar"]		= true,
		["width"]		= 450,
		["height"]		= 20,
		["offsetX"]		= 0,
		["offsetY"]		= -2,
		["unit"]		= "player",
		["icon"]		= true,
		["iconSize"]	= 35,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 35,
		["iconincombat"]= false,
		["classcolor"]	= true,
		["treatborder"]	= false,
	},
	["target"] = {
		["enable"]		= true,
		["width"]		= 450,
		["height"]		= 14,
		["offsetX"]		= 0,
		["offsetY"]		= 0,
		["unit"]		= "target",
		["icon"]		= false,
		["iconSize"]	= 22,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 24,
		["iconincombat"]= true,
		["classcolor"]	= false,
		["treatborder"]	= false,
	},
	["BCB"] = {
		["enable"]		= true,
		["QueueWindow"]	= 250,
		["width"]		= 450,
		["height"]		= 27,
		["offsetX"]		= 0,
		["offsetY"]		= -100,
		["unit"]		= "target",
		["castBoss"]	= false,
		["icon"]		= true,
		["iconSize"]	= 35,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 40,
		["iconincombat"]= true,
		["classcolor"]	= false,
		["treatborder"]	= false,
		["castbarAlpha"]= 0.75,
	},
	["focus"] = {
		["enable"]		= true,
		["width"]		= 450,
		["height"]		= 9,
		["offsetX"]		= 0,
		["offsetY"]		= 0,
		["unit"]		= "focus",
		["icon"]		= false,
		["iconSize"]	= 20,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 29,
		["iconincombat"]= true,
		["classcolor"]	= true,
		["treatborder"]	= false,
	},
	["boss"] = {
		["enable"]		= true,
		["width"]		= 450,
		["height"]		= 10,
		["offsetX"]		= 0,
		["offsetY"]		= 7,
		["unit"]		= "boss",
		["icon"]		= true,
		["iconSize"]	= 22,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= -22,
		["iconincombat"]= true,
		["classcolor"]	= true,
		["treatborder"]	= false,
	},
}

yo["NamePlates"] = {
	["enable"]			= true,
	["width"]			= 175,
	["height"]			= 14,
	["iconDSize"]		= 20,
	["iconBSize"]		= 20,
	["iconDiSize"]		= 30,
	["iconCastSize"]	= 24,
	["showCastIcon"]	= true,
	["showCastName"]	= true,
	["showCastTarget"]	= true,
	["showPercTreat"] 	= "none",
	["showArrows"]		= false,
	["executePhaze"]	= true,
	["executeProc"]		= 35,
	["executeColor"]	= "1,0.75,0",
	["blueDebuff"]		= true,
	["dissIcons"]		= "dispell",	-- false, dispell
	["buffIcons"]		= "buff",	-- false, all, dispell, buff
	["classDispell"]	= true,
	["showToolTip"]		= "cursor",
	["anonceCast"]		= false,
	["showOnFrames"]	= false,
	["c0"]				= "0.753,0.212,0.212",
	["c0t"]				= "0,1,1",
	["c1"]				= "1,1,0.5",
	["c2"]				= "1,0.5,0",
	["c3"]				= "0,1,1",
	["c3t"]				= "0.753,0.212,0.212",
	["myPet"]			= "1,0,0.5",
	["tankOT"]			= "0,0.5,1",
	["badGood"]			= "1,0.5,0.5",
	["glowTarget"]		= true,
	["glowBadType"]		= "pixel", 	-- button, cast, false
	["maxDispance"]		= 40,
	["showResourses"]	= true,
	["tankMode"]		= false,
	["moreDebuffIcons"]	= false,
	["showTauntDebuff"] = false,
	["badCasts"]		= false,
}

yo["Media"] = {
	--["texture"] 	= "Interface\\AddOns\\yoFrame\\Media\\statusbar4",
	["texture"] 	= "Interface\\AddOns\\yoFrame\\Media\\lightflatsmooth",
	["dgtexture"]	= "Interface\\AddOns\\yoFrame\\Media\\bar_dground",
	["texhl"]   	= "Interface\\AddOns\\yoFrame\\Media\\raidbg",
	["texglow"] 	= "Interface\\AddOns\\yoFrame\\Media\\glowTex",
	["font"]     	= [=[Interface\AddOns\yoFrame\Media\qFont.ttf]=],
	["fontpx"]   	= [=[Interface\AddOns\yoFrame\Media\pxFont.ttf]=],
	["fontsize"] 	= 10,
	["sysfontsize"]	= 10,
	["AutoScale"] 	= "auto",
	["ScaleRate"] 	= 0.71,
	["fontScala"]	= 0,
	["shadowColor"]	= "0.09,0.09,0.09",
	["edgeSize"]	= 2,
	["classBorder"]	= false,
}

yo["UF"] 	= {
	["enable"] 			= true,
	["unitFrames"]		= true,
	["colorUF"]			= 0,
	["classBackground"]	= true,
	["simpleUF"]			= false,
	["showGCD"]			= true,
	["debuffHight"]		= true,
	["showShards"]		= true,
	["rightAbsorb"]		= true,
	["hideOldAbsorb"]	= true,
}

yo["Raid"] = {
	["enable"] 			= true,
	["width"] 			= 80,
	["height"]   		= 25,
	["classcolor"] 		= 3,
	["showSolo"] 		= false,
	["showGroupNum"]	= true,
	["numgroups"]  		= 5,
	["spaicing"]  		= 6,
	["manabar"] 		= 2,
	["manacolorClass"] 	= true,
	["partyScale"] 		= 1.3,
	["hpBarRevers"]		= false,
	["hpBarVertical"]	= false,
	["groupingOrder"] 	= "ID", -- "THD" "TDH" "GROUP"
	["showLFD"]			= true,
	["showHPValue"]		= "[DDG]",
	["noHealFrames"]	= false,
	["healPrediction"]	= true,
	["aurasRaid"]		= true,
	["aurasParty"]		= true,
	["debuffHight"]		= true,
	["classBackground"]	= true,
	["filterHighLight"]	= false,
	["showMT"]			= true,
	["showMTT"]			= true,
	["showMTTT"]		= true,
	["heightMT"]		= 30,
	["widthMT"]			= 110,
	["simpeRaid"]		= false,
	["fadeColor"]		= 0.8,
	["darkAbsorb"]		= 0.6,
	["showPercTreat"] 	= "none",
	["showValueTreat"] 	= true,
}

yo["Chat"] = {
	["EnableChat"] 		= true,
	["fontsize"] 		= 10,
	["BarChat"]			= true,
	["linkOverMouse"]	= true,
	["showVoice"]		= false,
	["showHistory"]		= false,
	["showHistoryAll"] 	= false,
	["chatBubble"]		= "border",
	["chatBubbleFont"]	= 8,
	["chatBubbleShadow"]= true,
	["chatBubbleShift"]	= 15,
	["fadingEnable"]	= true,
	["fadingTimer"]		= 30,
	["wisperSound"]		= "Wisper",
	["wisperInCombat"]	= true,
	["chatFont"]		= "Interface\\Addons\\yoFrame\\Media\\qFont.ttf",
	["wim"]				= false,
	["winHeight"]		= 250,
	["wimWidth"]		= 350,
	["wimHHeight"]		= 300,
	["wimHWidth"]		= 450,
	["wimFigter"]		= true,
	["wimMaxHistory"]	= 200,
	["wimPrehistoric"]	= 15,
}

yo["healBotka"] = {
	["enable"]			= false,
	["key1"]			= "",
	["spell1"]			= "",
}

yo["fliger"] = {
	["enable"]			= true,
	["tDebuffEnable"]	= true,
	["pCDEnable"]		= true,
	["pBuffEnable"]		= true,
	["pDebuffEnable"]	= true,
	["pProcEnable"]		= true,
	["tDebuffSize"]		= 35,
	["pCDSize"]			= 25,
	["pProcSize"]		= 30,
	["pBuffSize"]		= 40,
	["pDebuffSize"]		= 50,
	["tDebuffDirect"]	= "RIGHT",
	["pCDDirect"]		= "RIGHT",
	["pProcDirect"]		= "LEFT",
	["pBuffDirect"]		= "LEFT",
	["pDebuffDirect"]	= "LEFT",
	["pCDTimer"]		= 15,
	["checkBags"]		= false,
	["gAzerit"]			= true,
}

yo["CTA"] = {
	["enable"]	= false,
	["tRole"]	= true,
	["hRole"]	= true,
	["dRole"]	= true,
	["nRole"]	= true,
	["heroic"]	= true,
	["lfr"]		= true,
	["timer"]	= 20,
	["setN"]	= true,
	["setT"]	= true,
	["setH"]	= true,
	["setD"]	= true,
	["hide"]	= false,
	["nosound"]	= false,
	["expand"]	= false,
	["sound"]	= "Murloc",
	["hideLast"]= false,
}