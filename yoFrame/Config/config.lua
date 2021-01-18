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

local myName   = UnitName( "player")
local myRealm  = GetRealmName()

if yo_AllData 					== nil then yo_AllData = {} end
if yo_talkingHead 				== nil then yo_talkingHead = {} end
if yo_AllData[myRealm] 			== nil then yo_AllData[myRealm] = {} end
if yo_AllData.talkingHead 		== nil then yo_AllData.talkingHead = {} end
if yo_AllData[myRealm][myName] 	== nil then yo_AllData[myRealm][myName] = {} end

if yo_AllData.charData 				 == nil then yo_AllData.charData = {} end
if yo_AllData.charData[myRealm]		 == nil then yo_AllData.charData[myRealm] = CopyTable( yo_AllData[myRealm]) end
if not yo_AllData.charData[myRealm][myName] then yo_AllData.charData[myRealm][myName] = {} end

n.allData 		 = yo_AllData
n.allData.myData = yo_AllData.charData[myRealm][myName]

if yo.healBotka.enable then
	Clique = Clique or CreateFrame("Frame", "yo_Clique", UIParent)
	local header = Clique.header or CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate, SecureHandlerAttributeTemplate")
	Clique.header = header
	SecureHandlerSetFrameRef(header, 'clickcast_header', Clique.header)
end

--if yo_AllConfig 				== nil 	then yo_AllConfig = {} end
--if yo_AllData["configData"]			 			== nil	then yo_AllData["configData"] = {} end
--if yo_AllData["configData"][myRealm] 			== nil	then yo_AllData["configData"][myRealm] = {} end
--if yo_AllData["configData"][myRealm][myName]	== nil 	then yo_AllData["configData"][myRealm][myName] = {} end
--yo_PersonalConfig = yo_AllData["configData"][myRealm][myName]

--local yo_tCfg = {}
--n.allConfig = yo_AllConfig

--if yo_AllData[myRealm][myName].PersonalConfig then
--	yo_tCfg = yo_PersonalConfig
--else
--	yo_tCfg = yo_AllConfig
--end


--for group1, options1 in pairs( yo_tCfg) do
--	--print( group1, type( options1), ( yo[group1] or "BAD GROUP 1 lvl"))
--	if yo[group1] == nil then yo_tCfg[group1] = nil else

--		if type( options1) == "table" then
--			for group2, options2 in pairs( options1) do

--				if type( options2) == "table" then
--					--print( group2, type( options2), ( yo[group1][group2] or "BAD GROUP 2 lvl"))
--					if yo[group1][group2] == nil then yo_tCfg[group1][group2] = nil else

--						for group3, options3 in pairs( options2) do
--							--print( "-- ", group1, group2, group3, options3)  -- 3  plant data
--							if yo[group1][group2][group3] == options3 then
--								yo_tCfg[group1][group2][group3] = nil
--							else
--								yo[group1][group2][group3] = options3
--							end
--						end
--					end

--				else
--					--print( "- ", group1, group2, options2)  -- 2  plant data
--					if yo[group1][group2] == options2 then
--						yo_tCfg[group1][group2] = nil
--					else
--						yo[group1][group2] = options2
--					end
--				end
--			end
--		end
--	end
--end

--for group1, options1 in pairs( yo) do
--	--print( group1, type( options1), ( yo_AllConfig[group1] or "BAD GROUP 1 lvl"))
--	if yo_AllConfig[group1] 	 == nil then yo_AllConfig[group1] 	   = {} end
--	if yo_PersonalConfig[group1] == nil then yo_PersonalConfig[group1] = {} end

--	if type( options1) == "table" then

--		for group2, options2 in pairs( options1) do

--			if type( options2) == "table" then
--				--print( group2, type( options2), ( yo_AllConfig[group1][group2] or "BAD GROUP 2 lvl"))
--				if yo_AllConfig[group1][group2] 	 == nil then yo_AllConfig[group1][group2]      = {} end
--				if yo_PersonalConfig[group1][group2] == nil then yo_PersonalConfig[group1][group2] = {} end
--			end
--		end
--	end
--end


