local addon, ns = ...
-- constants
--local L, yo = unpack( select( 2, ...))

--L_GUI_ANNOUNCEMENTS_FEASTS = "Сообщать, когда ставят пир/почту/ремонт"
--L_GUI_AUTOMATION_CURRENCY_CAP = "Напоминание, если достигнут лимит валюты (Доблесть/Честь)"

--L_GUI_COMBATTEXT_TRESHOLD = "Минимально отображаемое значение урона"
--L_GUI_CHAT_SKIN_BUBBLE = "Стилизация облачков чата"

--L_GUI_MAP_EXPLORE = "Отслеживать на карте 'Первооткрыватель' и 'Хранитель мудрости'"

myClass = select( 2, UnitClass( "player"))
myColor = RAID_CLASS_COLORS[myClass]
myColorStr = "|c" .. RAID_CLASS_COLORS[myClass].colorStr 
myName	= UnitName( "player")
myRealm = GetRealmName()
myLogin = GetTime()
myClient = GetLocale()
myFaction = UnitFactionGroup("player")
myLevel = UnitLevel( "player")
myRace	= select(2, UnitRace('player'))
mySex	= UnitSex('player')

dummy = function() return end	

local yo = {} 

yo["General"] = {
	["1st"] 	= true,
	["cFrame"] 	= 0,
	["cConfig"] = 0,
	["scriptErrors"]	= false, 
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
	["ladyMod"]				= true,
	["ladyModShift"]		= false,
	["showAltBags"]			= true,
	["showGuilBank"]		= false,
	["countAltBags"]		= true,
}			
yo["Addons"] = {
	["ChangeSystemFonts"] 			= true,			--	
	["FlashIconCooldown"] 			= true,				
	["RaidUtilityPanel"] 			= true,
	["ArtifactPowerbar"] 			= true,
	["PredictionHealth"] 			= true,
	["ReColorNamePlates"] 			= true,
	["AutoRepair"] 					= true,			--
	["AutoGreedOnLoot"] 			= true,
	["AutoSellGrayTrash"] 			= false,		--
	["AutoScreenOnLvlUpAndAchiv"] 	= true,			--
	["AutoDisenchantGreenLoot"] 	= true,
	["BarChat"] 					= true,
	["Potatos"] 					= false,			--
	["mythicProcents"] 				= true,
	["MiniMap"] 					= true,
	["MiniMapCoord"] 				= true,
	["MMColectIcons"]				= true,
	["unitFrames"]					= true,
	["MiniMapHideText"]				= false,
	["MiniMapSize"]					= 150,
	["MMFogOfWar"]					= true,
	["MMCoordColor"]				= "0.7,0.7,0.7",
	["MMCoordSize"] 				= 9,
	["InfoPanels"] 					= true,
	["BlackPanels"] 				= true,
	["IDInToolTip"] 				= false,		--
	["ActionsBars"] 				= true,
	["RaidCoolDowns"] 				= true,
	["RaidFrames"] 					= true,
	["AutoInvaitFromFriends"] 		= true,
	["CastWatcher"] 				= false,
	["CastWatchSound"] 				= "Applause",
	["TauntWatcher"] 				= true,
	["TauntWatchSound"] 			= "Tick 02",
	["AutoQuest"]					= true,
	["AutoQuestComplete"]			= true,
	["AutoQuestSkipScene"]			= true,
	["AutoQuestComplete2Choice"]	= true,
	["ObjectiveHeight"]				= 500,
	["hideObjective"]				= false,
	["cheloBuff"]					= false,
	["equipNewItem"]				= true,
	["equipNewItemLevel"]			= 350,
	["afk"]							= false,
	["stbEnable"]					= true,
	["MoveBlizzFrames"]				= true,
	["AutoInvite"]					= true,
	["AutoLeader"]					= false,
	["disenchanting"]				= true,
}
yo["ActionBar"] = {
	["enable"]		= true,
	["ShowGrid"]	= true,
	["HideHotKey"]	= true,
	["CountSize"]	= 14,  
	["HideName"]	= true,
	["MicroMenu"]	= true,
	["MicroScale"]	= 0.75,
	["panel3Cols"]	= 6,
	["panel3Nums"]	= 12,
	["buttonsSize"]	= 35,
	["buttonSpace"]	= 2,
	["hoverTexture"]= true,
}
yo["CastBar"] = {
	["player"] = {
		["enable"]		= true,
		["width"]		= 450,
		["height"]		= 20,
		["offsetX"]		= 0,
		["offsetY"]		= 0,
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
		["iconSize"]	= 32,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 29,
		["iconincombat"]= true,
		["classcolor"]	= false,
		["treatborder"]	= false,
	},
	["BCB"] = {
		["enable"]		= true,
		["width"]		= 370,
		["height"]		= 20,
		["offsetX"]		= 0,
		["offsetY"]		= -100,
		["unit"]		= "target",
		["icon"]		= true,
		["iconSize"]	= 35,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 36,
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
		["offsetY"]		= 0,
		["unit"]		= "boss",
		["icon"]		= true,
		["iconSize"]	= 25,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= -24,
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
	["iconCastSize"]	= 20,
	["showCastIcon"]	= true,
	["showCastName"]	= true,
	["showCastTarget"]	= true,
	["showPercTreat"] 	= "none",
	["showArrows"]		= true,
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
}
	
yo["Media"] = {
	--["texture"] 	= "Interface\\AddOns\\yoFrame\\Media\\statusbar4",
	["texture"] 	= "Interface\\AddOns\\yoFrame\\Media\\bar_dground",
	["dgtexture"]	= "Interface\\AddOns\\yoFrame\\Media\\bar_dground",
	["texhl"]   	= "Interface\\AddOns\\yoFrame\\Media\\raidbg",
	["texglow"] 	= "Interface\\AddOns\\yoFrame\\Media\\glowTex",
	["font"]     	= [=[Interface\AddOns\yoFrame\Media\qFont.ttf]=],
	["fontpx"]   	= [=[Interface\AddOns\yoFrame\Media\pxFont.ttf]=],
	["fontsize"] 	= 10,
	["sysfontsize"]	= 10,
	["AutoScale"] 	= "auto",
	["ScaleRate"] 	= 0.71,
}

yo["Raid"] = {
	["enable"] 			= true,
	["width"] 			= 90,
	["height"]   		= 28,
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
	["heightMT"]		= 32,
	["widthMT"]			= 120,
	["simpeRaid"]		= true,
}
yo["Chat"] = {
	["EnableChat"] 		= true,
	["fontsize"] 		= 10,
	["BarChat"]			= true,
	["linkOverMouse"]	= true,
	["showVoice"]		= false,
	["showHistory"]		= false,
	["chatBubble"]		= "border",
	["chatBubbleFont"]	= 8,
	["chatBubbleShadow"]= true,
	["chatBubbleShift"]	= 15,
	["fadingEnable"]	= true,
	["fadingTimer"]		= 30,
	["wisperSound"]		= "Wisper",
	["wisperInCombat"]	= true,
	["chatFont"]		= "Interface\\Addons\\yoFrame\\Media\\qFont.ttf",
}

yo["healBotka"] = {
	["enable"]			= false,
	["key1"]			= "key",
	["key2"]			= "key",
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
	["enable"]	= true,
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


local logan = CreateFrame("Frame")
logan:RegisterEvent("ADDON_LOADED")
--logan:RegisterEvent("PLAYER_LOGIN")

logan:SetScript("OnEvent", function(self, event, name)
	--print(name)

	if addon ~= name then return end
	
	if yo_AllData 		== nil then yo_AllData = {} end
	if yo_AllConfig 	== nil then yo_AllConfig = {} end
	if yo_PersonalConfig== nil then yo_PersonalConfig = {} end

	local yo_tCfg = {}
	
	if yo_AllData[myRealm] and yo_AllData[myRealm][myName] and yo_AllData[myRealm][myName].PersonalConfig then
		yo_tCfg = yo_PersonalConfig
	else
		yo_tCfg = yo_AllConfig
	end

	for group1, options1 in pairs( yo_tCfg) do
		--print( group1, type( options1), ( yo[group1] or "BAD GROUP 1 lvl"))
		if yo[group1] == nil then
			yo_tCfg[group1] = nil
		else
		
			if type( options1) == "table" then			
				for group2, options2 in pairs( options1) do
	
					if type( options2) == "table" then
						--print( group2, type( options2), ( yo[group1][group2] or "BAD GROUP 2 lvl"))
						if yo[group1][group2] == nil then
							yo_tCfg[group1][group2] = nil
						else
					
							for group3, options3 in pairs( options2) do
								--print( "-- ", group1, group2, group3, options3)  -- 3  plant data
								if yo[group1][group2][group3] == options3 then
									yo_tCfg[group1][group2][group3] = nil
								else
									yo[group1][group2][group3] = options3
								end
							end	
						end
	
					else
						--print( "- ", group1, group2, options2)  -- 2  plant data
						if yo[group1][group2] == options2 then
							yo_tCfg[group1][group2] = nil
						else
							yo[group1][group2] = options2
						end
					end
				end
			end
		end
	end

	for group1, options1 in pairs( yo) do
		--print( group1, type( options1), ( yo_AllConfig[group1] or "BAD GROUP 1 lvl"))
		if yo_AllConfig[group1] == nil then
			yo_AllConfig[group1] = {}
		end
			
		if yo_PersonalConfig[group1] == nil then
			yo_PersonalConfig[group1] = {}
		end
		if type( options1) == "table" then
			for group2, options2 in pairs( options1) do
				if type( options2) == "table" then
					--print( group2, type( options2), ( yo_AllConfig[group1][group2] or "BAD GROUP 2 lvl"))
					if yo_AllConfig[group1][group2] == nil then
						yo_AllConfig[group1][group2] = {}
					end
					if yo_PersonalConfig[group1][group2] == nil then
						yo_PersonalConfig[group1][group2] = {}
					end
				end
			end
		end
	end
	
	texture 	= 	yo.Media.texture
	texhl 		=	yo.Media.texhl
	texglow 	= 	yo.Media.texglow
	font 		= 	yo.Media.font
	fontChat	=	yo.Chat.chatFont
	fontpx		=	yo.Media.fontpx
	fontsize 	=	yo.Media.fontsize
	fontstyle 	= 	"OUTLINE"
	
	sysfontsize	=	yo.Media.sysfontsize

	ns[2] = yo
end)

ns[2] = yo
--yoFrame = ns