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


yo["InfoTexts"] = {
	["enable"] 			= true,
	["countLeft"] 		= 5,
	["countRight"]		= 4,
	["left1"]			= "system",
	["left2"]			= "dura",
	["left3"]			= "guild",
	["left4"]			= "friend",
	["left5"]			= "dps",
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
	["enableSPower"]	= false,
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
	["raidTemplate"]	= 1,
}

yo["Chat"] = {
	["EnableChat"] 		= true,
	["chatFontsize"] 	= 10,
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
	["wimLastTab"]		= false,
}

yo["healBotka"] = {
	["enable"]	= false,
	["hEnable"]	= false,
	["hSize"]	= 12,
	["hTimeSec"]= false,
	["hTempW"] 	= 90,
	["hTempH"]	= 40,
	["hRedTime"]= 3,
	["hDefCol"]	= "1,1,0",
	["hRedCol"]	= "1,0,0",

	["bSpell"]	= "",
	["bColor"]	= "0,1,0",
	["bColEna"]	= true,
	["bShiftY"] = 1,

	["set00"]	= "",
	["set01"]	= "",
	["targ01"]	= "CTRL-BUTTON1",
	["menu01"]	= "CTRL-BUTTON2",
	["key1"]	= "",
	["spell1"]	= "",
	["key2"]	= "",
	["spell2"]	= "",
	["key3"]	= "",
	["spell3"]	= "",
	["key4"]	= "",
	["spell4"]	= "",
	["key5"]	= "",
	["spell5"]	= "",
	["key6"]	= "",
	["spell6"]	= "",
	["key7"]	= "",
	["spell7"]	= "",
	["key8"]	= "",
	["spell8"]	= "",
	["key9"]	= "",
	["spell9"]	= "",
	["key10"]	= "",
	["spell10"]	= "",
	["key11"]	= "",
	["spell11"]	= "",
	["key12"]	= "",
	["spell12"]	= "",
	["hSpell1"]	= "",
	["hSpell2"]	= "",
	["hSpell3"] = "",
	["hSpell4"] = "",
	["hSpell5"] = "",
	["hColor1"] = "",
	["hColor2"] = "",
	["hColor3"] = "",
	["hColor4"] = "",
	["hColor5"] = "",
	["hColEna1"]= false,
	["hColEna2"]= false,
	["hColEna3"]= false,
	["hColEna4"]= false,
	["hColEna5"]= false,
	["hTimEna1"]= false,
	["hTimEna2"]= false,
	["hTimEna3"]= false,
	["hTimEna4"]= false,
	["hTimEna5"]= false,
	["hTimer1"] = 10,
	["hTimer2"] = 10,
	["hTimer3"] = 10,
	["hTimer4"] = 10,
	["hTimer5"] = 10,
	["hScale1"] = 1,
	["hScale2"] = 1,
	["hScale3"] = 1,
	["hScale4"] = 1,
	["hScale5"] = 1,

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
	["fligerBuffSpell"] = "",
	["fligerBuffCount"] = "",
	["fligerBuffGlow"]	= true,
	["fligerBuffAnim"]  = true,
	["fligerBuffColr"]	= true,
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