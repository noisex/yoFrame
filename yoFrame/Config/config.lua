local addon, ns = ...
local L, yo, n = unpack( ns)

if not IsAddOnLoaded("yoFrame_Config") then

	StaticPopupDialogs["NEED_CONFIG"] = {
  		text = "Теперпь для корректной работы необходимо включить дополнение |cff00ffff\"yoFrame_Config\"|r!",
  		button1 = "Включить его",
  		--button2 = "No",
  		OnAccept = function()
     		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
			HideUIPanel(GameMenuFrame);
			ShowUIPanel(AddonList);
  		end,
  		timeout = 0,
  		whileDead = true,
  		hideOnEscape = true,
  		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}

	StaticPopup_Show ("NEED_CONFIG")
	return
end

local yo_tCfg = {}
local myName   = UnitName( "player")
local myRealm  = GetRealmName()

if yo_AllData 					== nil	then yo_AllData = {} end
if yo_AllConfig 				== nil 	then yo_AllConfig = {} end
if yo_AllData[myRealm] 			== nil	then yo_AllData[myRealm] = {} end
if yo_AllData[myRealm][myName] 	== nil 	then yo_AllData[myRealm][myName] = {} end

if yo_AllData["configData"]			 			== nil	then yo_AllData["configData"] = {} end
if yo_AllData["configData"][myRealm] 			== nil	then yo_AllData["configData"][myRealm] = {} end
if yo_AllData["configData"][myRealm][myName]	== nil 	then yo_AllData["configData"][myRealm][myName] = {} end

yo_PersonalConfig = yo_AllData["configData"][myRealm][myName]

n.allData = yo_AllData
n.allConfig = yo_AllConfig

if yo_AllData[myRealm][myName].PersonalConfig then
	yo_tCfg = yo_PersonalConfig
else
	yo_tCfg = yo_AllConfig
end


for group1, options1 in pairs( yo_tCfg) do
	--print( group1, type( options1), ( yo[group1] or "BAD GROUP 1 lvl"))
	if yo[group1] == nil then yo_tCfg[group1] = nil else

		if type( options1) == "table" then
			for group2, options2 in pairs( options1) do

				if type( options2) == "table" then
					--print( group2, type( options2), ( yo[group1][group2] or "BAD GROUP 2 lvl"))
					if yo[group1][group2] == nil then yo_tCfg[group1][group2] = nil else

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
	if yo_AllConfig[group1] 	 == nil then yo_AllConfig[group1] 	   = {} end
	if yo_PersonalConfig[group1] == nil then yo_PersonalConfig[group1] = {} end

	if type( options1) == "table" then

		for group2, options2 in pairs( options1) do

			if type( options2) == "table" then
				--print( group2, type( options2), ( yo_AllConfig[group1][group2] or "BAD GROUP 2 lvl"))
				if yo_AllConfig[group1][group2] 	 == nil then yo_AllConfig[group1][group2]      = {} end
				if yo_PersonalConfig[group1][group2] == nil then yo_PersonalConfig[group1][group2] = {} end
			end
		end
	end
end


texture 		= 	yo.Media.texture
font 			= 	yo.Media.font

yo.texture 		= 	yo.Media.texture
yo.texhl 		=	yo.Media.texhl
yo.texglow 		= 	yo.Media.texglow
yo.font 		= 	yo.Media.font
yo.fontChat		=	yo.Chat.chatFont
yo.fontpx		=	yo.Media.fontpx
yo.fontsize 	=	yo.Media.fontsize
yo.fontstyle 	= 	"OUTLINE"
yo.sysfontsize	=	yo.Media.sysfontsize

yo.tCoord 		= {0.07, 0.93, 0.07, 0.93}
--yo.tCoord 		= {0,1,0,1}
yo.tCoordBig 	= {0.22, 0.78, 0.22, 0.78}
yo.tCoordSmall 	= {0.07, 0.93, 0.07, 0.93}

yo.myClass  	= select( 2, UnitClass( "player"))
yo.mySpec    	= GetSpecialization()
yo.myGUID   	= UnitGUID('player')
--mySpeClass  = yo.myClass .. yo.mySpec
yo.myColor  	= RAID_CLASS_COLORS[yo.myClass]
yo.myColorStr   = "|c" .. RAID_CLASS_COLORS[yo.myClass].colorStr
yo.myName   	= UnitName( "player")
yo.myRealm  	= GetRealmName()
yo.myRealmShort	= select( 2, UnitFullName("player"))
yo.myLogin  	= GetTime()
yo.myClient   	= GetLocale()
yo.myFaction  	= UnitFactionGroup("player")
yo.myLevel  	= UnitLevel( "player")
yo.myRace   	= select(2, UnitRace('player'))
yo.mySex    	= UnitSex('player')

if yo.healBotka.enable then
	Clique = Clique or CreateFrame("Frame", "yo_Clique", UIParent)
	local header = Clique.header or CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate, SecureHandlerAttributeTemplate")
	Clique.header = header
	SecureHandlerSetFrameRef(header, 'clickcast_header', Clique.header)
end
