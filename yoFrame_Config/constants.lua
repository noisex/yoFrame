local addonName, ns = ...
local L, conf, n, defConfig = unpack( ns)

local yo = {}
local media = "Interface\\AddOns\\yoFrame\\Media\\"
defConfig.constants = yo

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
	["countGuildBank"]		= true,
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
	["AutoScreenOnLvlUp"] 			= true,			--
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
	["covenantsCD"]					= true,
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
	["showToday"]					= false,
	["ObjectiveTracker"]			= true,
	["ObjectiveHeight"]				= 500,
	["ObjectiveShort"]				= false,
	["hideObjective"]				= false,
	["cheloBuff"]					= false,
	["equipNewItem"]				= true,
	["equipNewItemLevel"]			= 200,
	["afk"]							= false,
	["stbEnable"]					= false,
	["MoveBlizzFrames"]				= true,
	["AutoInvite"]					= true,
	["AutoLeader"]					= false,
	["disenchanting"]				= true,
	["AutoCovenantsMission"]		= false,
	["hideHead"]					= true,
	["hideForAll"]					= false,
	["hideSound"]					= false,
	["minimapMove"]					= true,
	["alertEnable"]					= true,
	["movePersonal"]				= true,
	["moveWidget"]					= false,
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
	["switchBars"]	= true,
	["HotKeySize"]	= 10,
	["HotKeyColor"]	= "0.9,0.9,0.9",
	["secondHot"]	= true,
	["HotToolTip"]	= true,

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
	["badCasts"]		= true,
}

yo["Media"] = {
	--["texture"] 	= "Interface\\AddOns\\yoFrame\\Media\\statusbar4",
	["path"]		= "Interface\\AddOns\\yoFrame\\Media\\",
	["texture"] 	= media .."statusbars\\lightflatsmooth",
	["dgtexture"]	= media .. "statusbars\\bar_dground",
	["texhl"]   	= media .. "textures\\raidbg",
	["texglow"] 	= media .. "textures\\glowTex",
	["font"]     	= media .. "fonts\\qFont.ttf",
	["fontpx"]   	= media .. "fonts\\pxFont.ttf",
	["borders"]		= media .. "borders\\boder6px",
	["fontsize"] 	= 10,
	["sysfontsize"]	= 10,
	["AutoScale"] 	= "auto",
	["ScaleRate"] 	= 0.71,
	["fontScala"]	= 0,
	["shadowColor"]	= "0.09,0.09,0.09",
	["edgeSize"]	= 0,
	["classBorder"]	= false,
	["bdAlpha"]		= 0.9,
	["bdbAlpha"] 	= 0.9,
	["bdColor"]		= "0.075,0.075,0.086",
	["bdbColor"]	= "0.075,0.075,0.086",
	["bdbSize"]		= 3,
}

yo["UF"] 	= {
	["enable"] 			= true,
	["unitFrames"]		= true,
	["colorUF"]			= 0,
	["classBackground"]	= true,
	["simpleUF"]		= false,
	["showGCD"]			= true,
	["debuffHight"]		= true,
	["showShards"]		= true,
	["rightAbsorb"]		= true,
	["hideOldAbsorb"]	= true,
	["enableSPower"]	= false,
	["powerHeight"]		= 4,
	["player"] 			= {	width = 200, height = 40,},
	["target"] 			= {	width = 200, height = 40,},
	["focus"] 			= {	width = 110, height = 25,},
	["pet"] 			= {	width = 100, height = 25,},
	["boss"] 			= {	width = 180, height = 35,},
	["focustarget"]  	= {	width = 110, height = 25,},
	["targettarget"] 	= { width = 100, height = 25,},
	["arena"] 			= {	width = 160, height = 35,},
}

yo["Raid"] = {
	["enable"] 			= true,
	["width"] 			= 90,
	["height"]   		= 30,
	["classcolor"] 		= 3,
	["showSolo"] 		= false,
	["showGroupNum"]	= true,
	["numgroups"]  		= 5,
	["spaicing"]  		= 6,
	["manabar"] 		= 2,
	["manacolorClass"] 	= true,
	["partyScale"] 		= 1.2,
	["hpBarRevers"]		= false,
	["hpBarVertical"]	= false,
	["groupingOrder"] 	= "TDH", -- "THD" "TDH" "GROUP"
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
	["showVoice"]		= true,
	["showHistory"]		= false,
	["showHistoryAll"] 	= false,
	["chatBubble"]		= "skin",
	["chatBubbleFont"]	= 10,
	["chatBubbleShadow"]= true,
	["chatBubbleShift"]	= 15,
	["fadingEnable"]	= true,
	["fadingTimer"]		= 30,
	["wisperSound"]		= "Wisper",
	["wisperInCombat"]	= true,
	["chatFont"]		= media .. "fonts\\qFont.ttf",
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
	["hTempW"] 	= 100,
	["hTempH"]	= 45,
	["hRedTime"]= 3,
	["hDefCol"]	= "1,1,0",
	["hRedCol"]	= "1,0,0",
	["borderC"] = "1,0,0",
	["borderS"]	= false,
	["takeTarget"] = false,

	["bSpell"]	= "",
	["bColor"]	= "0,1,0",
	["bColEna"]	= true,
	["bShiftY"] = 0,

	["set00"]	= "",
	["set01"]	= "",
	["targ01"]	= "CTRL-BUTTON1",
	["menu01"]	= "CTRL-BUTTON2",
	["res01"]	= "BUTTON3",
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
	["bStop1"]	= false,
	["bStop2"]	= false,
	["bStop3"]	= false,
	["bStop4"]	= false,
	["bStop5"]	= false,
	["bStop6"]	= false,
	["bStop7"]	= false,
	["bStop8"]	= false,
	["bStop9"]	= false,
	["bStop10"]	= false,
	["bStop11"]	= false,
	["bStop12"]	= false,
	["bTrink1"] = false,
	["bTrink2"] = false,
	["bTrink3"] = false,
	["bTrink4"] = false,
	["bTrink5"] = false,
	["bTrink6"] = false,
	["bTrink7"] = false,
	["bTrink8"] = false,
	["bTrink9"] = false,
	["bTrink10"] = false,
	["bTrink11"] = false,
	["bTrink12"] = false,

	["hpBarVertical"] 	= false,
	["hpBarRevers"] 	= false,
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
	["fligerShowHint"]  = false,
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
	["hideLast"]= true,
	["lfdMode"]	= 0,
}

yo["alerts"] = {
	--enable 		= true,
	alertsPool 	= {
      	['*'] = {
			spellID		= "",
			event		= "auraApplaed",
			destUnit	= "any",
			alertUnit	= "me",
			message		= "$target ( $spell)",
			color		= "red",
			fromStack 	= false,
			toStack		= false,
			raidAlert	= false,
			sound		= "None",
			stage 		= false,
			lowHealth 	= false,
    	},
	},
}

