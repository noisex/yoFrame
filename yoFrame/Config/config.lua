local addon, ns = ...
local L, yo, N = unpack( ns)

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

if yo_AllData 			== nil			then yo_AllData = {} end
if yo_AllConfig 		== nil			then yo_AllConfig = {} end
if yo_PersonalConfig	== nil			then yo_PersonalConfig = {} end
if yo_AllData[myRealm] 	== nil 			then yo_AllData[myRealm] = {} end
if yo_AllData[myRealm][myName] == nil 	then yo_AllData[myRealm][myName] = {} end

if yo_AllData[myRealm][myName].PersonalConfig then
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


texture 		= 	yo.Media.texture
texhl 			=	yo.Media.texhl
texglow 		= 	yo.Media.texglow
font 			= 	yo.Media.font
fontChat		=	yo.Chat.chatFont
fontpx			=	yo.Media.fontpx
fontsize 		=	yo.Media.fontsize
fontstyle 		= 	"OUTLINE"
sysfontsize		=	yo.Media.sysfontsize

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

---- Apply or remove saved settings as needed
--for group, options in pairs(yo_tCfg) do
--	if yo[group] then
--		for option, value in pairs(options) do
--			if yo[group][option] == nil or yo[group][option] == value then
--				-- remove saved vars if they do not exist in lua config anymore, or are the same as the lua config
--				yo_tCfg[group][option] = nil
--			else
--				yo[group][option] = value
--			end
--		end
--	else
--		yo_tCfg[group] = nil
--	end
--end