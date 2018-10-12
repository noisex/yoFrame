yo = {} 
yo_AllConfig = {}
yo_AllData = {}
yo_PersonalConfig = {}

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
	["MMFogOfWar"]					= true,
	["MMCoordColor"]				= "1,1,1",
	["MMCoordSize"] 				= 6,
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
}
yo["ActionBar"] = {
	["enable"]		= true,
	["ShowGrid"]	= true,
	["HideHotKey"]	= true,
	["CountSize"]	= 14,  
	["HideName"]	= true,
	["MicroMenu"]	= true,
	["MicroScale"]	= 0.75,
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
		["offsetY"]		= 400,
		["unit"]		= "target",
		["icon"]		= true,
		["iconSize"]	= 35,
		["iconoffsetX"]	= 0,
		["iconoffsetY"]	= 36,
		["iconincombat"]= true,
		["classcolor"]	= false,
		["treatborder"]	= false,
		["castbarAlpha"]= 0.5,
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
	["executePhaze"]	= false,
	["executeProc"]		= 35,
	["executeColor"]	= "1,1,1",
	["blueDebuff"]		= true,
	["dissIcons"]		= "none",	-- false, dispell
	["buffIcons"]		= "none",	-- false, all, dispell, buff
	["classDispell"]	= true,
	["showToolTip"]		= "none",
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
	["width"] 			= 95,
	["height"]   		= 30,
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
}

yo["healBotka"] = {
	["enable"]			= false,
	["key1"]			= "key",
	["key2"]			= "key",
}

yo["fliger"] = {
	["enable"]			= false,
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
}

yo["CTA"] = {
	["enable"]	= true,
	["tRole"]	= true,
	["hRole"]	= true,
	["dRole"]	= true,
	["heroic"]	= true,
	["lfr"]		= true,
	["timer"]	= 20,
	["setN"]	= true,
	["setT"]	= true,
	["setH"]	= true,
	["setD"]	= true,
	["hide"]	= false,
	["nosound"]	= false,
	["sound"]	= "Murloc"
}

local logan = CreateFrame("Frame")
--logan:RegisterEvent("ADDON_LOADED")
logan:RegisterEvent("PLAYER_LOGIN")

logan:SetScript("OnEvent", function(self, event)

	local name = UnitName("player")
	local realm = GetRealmName()
	local yo_tCfg = {}

	if yo_AllData[realm][name].PersonalConfig then
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
	dgtexture= 	yo.Media.dgtexture
	texture = 	yo.Media.texture
	texhl 	=	yo.Media.texhl
	texglow = 	yo.Media.texglow
	font = 		yo.Media.font
	fontpx	=	yo.Media.fontpx
	fontsize =	yo.Media.fontsize
	fontstyle = "OUTLINE"
	sysfontsize=yo.Media.sysfontsize

	--myClass = select( 2, UnitClass( "player"))
	--myColor = RAID_CLASS_COLORS[myClass]
	--myColorStr = "|c" .. RAID_CLASS_COLORS[myClass].colorStr 
	--print(myColorStr .. myClass)
end)