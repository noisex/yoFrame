
local L, yo = unpack( select( 2, ...))

local ACD
local needReload = false

LSM = LibStub:GetLibrary("LibSharedMedia-3.0");

LSM:Register("statusbar", "yo Plain Gray", "Interface\\AddOns\\yoFrame\\Media\\bar16")
LSM:Register("statusbar", "yo Plain White", "Interface\\AddOns\\yoFrame\\Media\\plain_white")
LSM:Register("statusbar", "yo StatusBar", "Interface\\AddOns\\yoFrame\\Media\\statusbar4")
LSM:Register("statusbar", "yo DGroung", "Interface\\AddOns\\yoFrame\\Media\\bar_dground")
LSM:Register("statusbar", "yo Striped", "Interface\\AddOns\\yoFrame\\Media\\striped")
LSM:Register("statusbar", "yo Smooth", "Interface\\AddOns\\yoFrame\\Media\\flatsmooth")
LSM:Register("statusbar", "yo Bar 04", "Interface\\AddOns\\yoFrame\\Media\\bar4")
LSM:Register("statusbar", "yo Bar 07", "Interface\\AddOns\\yoFrame\\Media\\bar7")
LSM:Register("statusbar", "yo Bar 08", "Interface\\AddOns\\yoFrame\\Media\\bar8")
LSM:Register("statusbar", "yo Bar 17", "Interface\\AddOns\\yoFrame\\Media\\bar17")
LSM:Register("statusbar", "yo Neal", "Interface\\AddOns\\yoFrame\\Media\\Neal")

LSM:Register("sound", "Tick 01", "Interface\\Addons\\yoFrame\\Media\\Bip.ogg")
LSM:Register("sound", "Tick 02", "Interface\\Addons\\yoFrame\\Media\\CSDroplet.ogg")
LSM:Register("sound", "Applause", "Interface\\Addons\\yoFrame\\Media\\Applause.ogg")
LSM:Register("sound", "Shotgun", "Interface\\Addons\\yoFrame\\Media\\Shotgun.ogg")
LSM:Register("sound", "Wisper", "Interface\\Addons\\yoFrame\\Media\\wisp.OGG")
LSM:Register("sound", "Murloc", "Interface\\Addons\\yoFrame\\Media\\BabyMurlocA.ogg")

LSM:Register("font", "yoMagistral", "Interface\\Addons\\yoFrame\\Media\\qFont.ttf", 130)
LSM:Register("font", "yoSansNarrow", "Interface\\Addons\\yoFrame\\Media\\qSans.ttf", 130)

function Setlers( path, val)
	local p1, p2, p3, p4 = strsplit("#", path)
		
	local pers = false
	if yo_AllData[myRealm][myName].PersonalConfig then
		pers = true
	end

	needReload = true
	--print( p1, p2, p3, p4, val, pers)

	if p4 then
		if pers then
			yo_PersonalConfig[p1][p2][p3][p4] = val 		
		else
			yo_AllConfig[p1][p2][p3][p4] = val 	
		end
		yo[p1][p2][p3][p4] = val 	
	elseif p3 then
		if pers then
			yo_PersonalConfig[p1][p2][p3] = val 
		else
			yo_AllConfig[p1][p2][p3] = val 	
		end
		yo[p1][p2][p3] = val 	
	elseif p2 then
		if pers then
			yo_PersonalConfig[p1][p2] = val 		
		else
			yo_AllConfig[p1][p2] = val 	
		end
		yo[p1][p2] = val
	else
		if pers then
			yo_PersonalConfig[p1] = val 		
		else
			yo_AllConfig[p1] = val 	
		end
		yo[p1] = val 	
	end
end

local function tr( path)	
	if not L[path] or L[path] == "" then
		print( "|cffff0000UNKNOWN LOCALE : |cff00ffff" .. path)
		L[path] = "|cffff0000UNKNOWN LOCALE: ".. path
	end	

	return L[path]
end

StaticPopupDialogs["CONFIRM_PERSONAL"] = {
  	text = L["CONFIRM_PERSONAL"],
  	button1 = "Yes",
  	button2 = "No",
  	OnAccept = function()
		yo_AllData[myRealm][myName].PersonalConfig = not yo_AllData[myRealm][myName].PersonalConfig 
     	ReloadUI()
  	end,
  	timeout = 0,
  	whileDead = true,
  	hideOnEscape = true,
  	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


function InitOptions()
	
	local defaults = {
		profile = {},
	}


	local options = {
		name = function(info) return tr( info[#info]) end, 
		handler = GottaGoFast,
		type = "group",
		args = {
			System = {
				name = function(info) return tr( info[#info]) end, 
				type = "group",
				order = 10,
				args = {
					PersonalConfig = {
						order = 1, type = "toggle", width = "full",	name = function(info) return tr( info[#info]) end, 
						desc = L["PERSONAL_DESC"],	descStyle = "inline",
						get = function(info) return yo_AllData[myRealm][myName].PersonalConfig end,
						set = function(info,val) StaticPopup_Show ("CONFIRM_PERSONAL") end,	},

			        ChangeSystemFonts = {
						order = 10, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",
						get = function(info) return yo["Addons"][info[#info]] end,
						set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 	},	
			        sysfontsize = {
			        	order = 11,	type = "range", name = function(info) return tr( info[#info]) end, 
						desc = L["SYSFONT_DESC"], min = 10, max = 14, step = 1, width = "full", 
						disabled = function() return not yo["Addons"].ChangeSystemFonts; end,
						get = function(info) return yo["Media"].sysfontsize end,
						set = function(info,val) Setlers( "Media#sysfontsize", val) ChangeSystemFonts( val) end,},	
			        FontSize = {
			   			name = function(info) return tr( info[#info]) end, 
						order = 15,	type = "range",
						desc = L["DEFAULT"] .. 10,
						min = 10, max = 14, step = 1, width = "full",
						get = function(info) return yo["Media"].fontsize end,
						set = function(info,val) Setlers( "Media#fontsize", val) end,},			
					scriptErrors= {
						name = function(info) return tr( info[#info]) end, 
						order = 9, type = "toggle",
						get = function(info) return yo["General"][info[#info]] end, width = "full",
						set = function(info,val) Setlers( "General#" .. info[#info], val) end,	},
					texture = {
						name = function(info) return tr( info[#info]) end, 
						order = 30,	type = "select",	width = "full",
						--dialogControl = "LSM30_Sound", --values = LSM:HashTable("sound"),
						dialogControl = "LSM30_Statusbar",	values = LSM:HashTable("statusbar"),
						get = function(info) 
							for k, val in pairs( LSM:List("statusbar")) do
								if yo["Media"][info[#info]] == LSM:Fetch("statusbar", val) then return val end
							end	end,
						set = function(info, val) Setlers( "Media#" .. info[#info], LSM:Fetch("statusbar", val))	end,},
					
					AutoScale = {	
						name = function(info) return tr( info[#info]) end, 	order = 40, type = "select", 
						values = {["none"] = L["SCALE_NONE"], ["auto"] = L["SCALE_AUTO"], ["manual"] = L["SCALE_MANUAL"]},
						get = function(info) return yo.Media.AutoScale end,
						set = function(info,val) Setlers( "Media#AutoScale", val) end,},
					ScaleRate = {
						name = function(info) return tr( info[#info]) end, order = 42,	type = "range",
						desc = L["DEFAULT"] .. 0.64, min = 0.6, max = 1.2, step = 0.01, 
						disabled = function() if yo.Media.AutoScale ~= "manual" then return true end end	,
						get = function(info) return yo["Media"][info[#info]] end,
						set = function(info,val) Setlers( "Media#" .. info[#info], val) 
							SetCVar("useUiScale", 1)	SetCVar("uiScale", val) UIParent:SetScale( val)	end, },
			 	},
			},


			Addons = {
				order = 20,	name = L["Addons"].. L["NEW"], type = "group",				
				get = function(info) return yo["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 
				args = {	
					RaidUtilityPanel= {	order = 1, type = "toggle",	name = function(info) return tr( info[#info]) end,  width = "full",	desc = L["RUP_DESC"],},
					Potatos 		= {	order = 2, type = "toggle",	name = function(info) return tr( info[#info]) end,  width = "full",	desc = L["POT_DESC"], hidden = true,},
					IDInToolTip 	= {	order = 3, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					mythicProcents 	= {	order = 4, type = "toggle", name = function(info) return tr( info[#info]) end,  width = "full",	},
					InfoPanels	 	= {	order = 5, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					BlackPanels	 	= {	order = 6, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					FlashIconCooldown={ order = 7, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					ArtifactPowerbar= {	order = 8, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					unitFrames		= {	order = 9, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					afk				= {	order =10, type = "toggle", name = function(info) return tr( info[#info]) end, 	width = "full",	},
					stbEnable 		= {	order =12, type = "toggle", name = function(info) return tr( info[#info])  end, 	width = "full",	},
					MoveBlizzFrames = {	order =13, type = "toggle", name = function(info) return tr( info[#info])  end, 	width = "full",	},	
					disenchanting 	= {	order =14, type = "toggle", name = function(info) return tr( info[#info])  end, 	width = "full",	},	
					-- lootbox
					-- cooldowns
					ObjectiveHeight = { order = 20, type = "range", name = function(info) return tr( info[#info]) end, 	min = 250, max = 650, step = 1, desc = L["OBJQ_DESC"],	}, 
					hideObjective	= {	order = 24, type = "toggle",name = function(info) return tr( info[#info]) end,   },

					MiniMaps = {
						name = L["MiniMaps"],	type = "group",	order = 30,	inline = true,
						args = {	
							MiniMap 		= {	order = 1,  type = "toggle",	name = function(info) return tr( info[#info]) end, 	width = 1},
							MiniMapSize		= {	order = 2,	type = "range", 	name = function(info) return tr( info[#info]).. L["NEW"] end, min = 100, max = 250, step = 10,},
							MMColectIcons 	= {	order = 5,  type = "toggle",	name = function(info) return tr( info[#info]) end,  width = "full"},
							MiniMapCoord 	= {	order = 10, type = "toggle",	name = function(info) return tr( info[#info]) end,  },
							MiniMapHideText = {	order = 15, type = "toggle",	name = function(info) return tr( info[#info]) end, 	desc = L["MMHIDE_DESC"],},
							MMCoordColor 	= {	order = 20, type = "color",		name = function(info) return tr( info[#info]) end, 
								disabled = function() return not yo.Addons.MiniMapCoord; end,
								get = function(info, r, g, b)  return strsplit( ",", yo.Addons.MMCoordColor)	end,				
								set = function(info, r, g, b) Setlers( "Addons#MMCoordColor", strjoin(",", r, g, b)) end,},
							MMCoordSize 	= {	order = 25,	type = "range", name = function(info) return tr( info[#info]) end,  min = 5, max = 16, step = 1, desc = L["DEFAULT"] .. 8,
								disabled = function() return not yo.Addons.MiniMapCoord; end,	},									
					},	},
					--CastWatcher = {
					--	name = "CastWatcher", type = "group", order = 40, inline = true,
					--	get = function(info) return yo["Addons"][info[#info]] end,
					--	set = function(info,val) Setlers( "Addons#" .. info[#info], val) end,	
					--	args = {	
					--		CastWatcher = {		order = 20, type = "toggle", name = "Cлежение за установкой еды, котлов, таунт танков.",
					--			desc = "Установка хавки. \nТаунт других членов рейда. Пока не работает.",	width   = "full",},
					--		CastWatchSound = {	order = 22, type = "select", name = "Звук еды, котлов",	dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					--		TauntWatchSound = {	order = 26, type = "select", name = "Звук таунта", 	dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					--	},	
					--},
					--cheloBuff={			order =100, type = "toggle", name = "cheloBuff",			 width = "full",	},					
				},
			},
					

			Automatic = {
				order = 25,	name = L["Automatic"], type = "group",				
				get = function(info) return yo["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 
				args = {
					AutoRepair 				= {	order = 1, type = "toggle", name = function(info) return tr( info[#info]) end,  width = "full", },
					AutoSellGrayTrash 		= {	order = 2, type = "toggle",	name = function(info) return tr( info[#info]) end, 	desc = L["SALE_DESC"],},
					AutoScreenOnLvlUpAndAchiv={ order = 3, type = "toggle",	name = function(info) return tr( info[#info]) end, 	},	
					AutoInvaitFromFriends 	= {	order = 4, type = "toggle",	name = function(info) return tr( info[#info]) end,  width = "full"},	
					AutoInvite 				= {	order = 5, type = "toggle",	name = function(info) return tr( info[#info]) ..L["NEW"] end,  width = "full", desc = "инв inv byd штм 123"},
					AutoLeader 				= {	order = 6, type = "toggle",	name = function(info) return tr( info[#info]) ..L["NEW"] end,  width = "full"},	
					equipNewItem			= {	order = 7, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					equipNewItemLevel		= {	order = 8, type = "range",	name = function(info) return tr( info[#info]) end, 	min = 0, max = 800, step = 1,},

					AutoQuesting = {
						order = 30,	name = L["AutoQuesting"], type = "group",	inline = true,
						args = {
							AutoQuest = {		order = 10, type = "toggle",	name = function(info) return tr( info[#info]) end, 	desc = L["QUACP_DESC"],},	
							AutoQuestComplete ={order = 11, type = "toggle",	name = function(info) return tr( info[#info]) end, 	desc = L["QUCOM_DESC"],},	
							AutoQuestComplete2Choice = {order = 12, type = "toggle",	name = function(info) return tr( info[#info]) end, 
								disabled = function() return not yo["Addons"].AutoQuestComplete; end,		desc = L["QU2CH_DESC"],},	
							AutoQuestSkipScene = {order = 14, type = "toggle",	name = function(info) return tr( info[#info]) end, 	disabled = function() return not yo.Addons.AutoQuestComplete; end,},									
						},
					},
				},
			},

			CastBar = {
				order = 30,	name = L["CastBar"], type = "group",				
				args = {	
					BCB = {
						order = 20,	name = L["BCB"], type = "group",	inline = true,
						get = function(info) return yo[info[1]][info[2]][info[#info]] end,
						set = function(info,val) Setlers( info[1] .."#".. info[2] .."#".. info[#info], val)	end,
						disabled = function() return not yo.CastBar.BCB.enable; end,
						args = {
							enable 		= { order = 1, type = "toggle", 	name = L["BCBenable"], width = "full", disabled = false, },
							unit 		= { order = 2, type = "select", 	name = L["BCDunit"], width = "double",	values = {["player"] = L["player"], ["target"] = L["target"], ["boss1"] = L["BCBBoss"]},},
							width 		= { order = 3,	type = "range", 	name = function(info) return tr( info[#info]) end, 		min = 150, max = 800, step = 10,},
							height 		= {	order = 4,	type = "range", 	name = function(info) return tr( info[#info]) end,		min = 10, max = 40, step = 1,},
							offsetY 	= {	order = 7,	type = "range", 	name = function(info) return tr( info[#info]) end, 	min = -500, max = 500, step = 1,},
							offsetX 	= {	order = 6,	type = "range", 	name = function(info) return tr( info[#info]) end, 	min = -900, max = 900, step = 1,},
							icon 		= {	order = 10, type = "toggle",	name = function(info) return tr( info[#info]) end,},
							iconSize 	= {	order = 11,	type = "range", 	name = function(info) return tr( info[#info]) end,		min = 10, max = 60, step = 1,},
							iconoffsetX = {	order = 12,	type = "range", 	name = function(info) return tr( info[#info]) end,	min = -400, max = 400, step = 1,},
							iconoffsetY = {	order = 13,	type = "range", 	name = function(info) return tr( info[#info]) end,	min = -70, 	max = 70, step = 1,},				
							iconincombat= { order = 14, type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},
							classcolor 	= {	order = 15, type = "toggle",	name = L["CBclasscolor"],	desc = L["DESC_BCB_CC"],	width = "full",},
							treatborder = {	order = 16, type = "toggle",	name = function(info) return tr( info[#info]) end,	desc = L["DESC_BCB_TREAT"],	width = "full",},
							castbarAlpha= {	order = 20,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 0, max = 1, step = 0.01,},
						},
					},
					player = {
						order = 30,	name = L["PCB"], type = "group",	inline = true,
						get = function(info) return yo[info[1]][info[2]][info[#info]] end,
						set = function(info,val)    Setlers( info[1] .."#".. info[2] .."#".. info[#info], val) end,
						args = {
							enable 		= {	order = 1, type = "toggle", name = L["PCBenable"],},
							iconincombat= { order = 14, type = "toggle",	name = function(info) return tr( info[#info]) end,	disabled = function() return not yo["CastBar"]["player"].enable; end,},
						},
					},
				},	
			},
		
			Bags = {
				order = 35,	name = L["Bags"], type = "group",				
				get = function(info) return yo["Bags"][info[#info]] end,
				set = function(info,val) Setlers( "Bags#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {
					enable 			= { order = 1, type = "toggle",	name = L["BAGenable"], disabled = false, },
					buttonSize 		= { order = 5, type = "range", 	name = function(info) return tr( info[#info]) end, min = 20, max = 50, step = 1,	desc = L["DEFAULT"] .. 32,},
					numMaxRow 		= {	order = 6, type = "range", 	name = function(info) return tr( info[#info]) end, min = 5, max = 20, step = 1,	desc = L["DEFAULT"] .. 16,},
					buttonSpacing 	= {	order = 7,	type = "range", name = function(info) return tr( info[#info]) end, min = 1, max = 10, step = 1,desc = L["DEFAULT"] .. 7,},
					containerWidth 	= {	order = 8, type = "range", 	name = function(info) return tr( info[#info]) end, min = 350, max = 800, step = 1,	desc = L["DEFAULT"] .. 438,},
					newIconAnimation= { order = 10, type = "toggle",name = function(info) return tr( info[#info]) end, width = "full", },
					newAnimationLoop= { order = 12, type = "toggle",name = function(info) return tr( info[#info])  end, width = "full",},
					ladyMod			= {	order = 32, type = "toggle",name = function(info) return tr( info[#info])  end,width = "full",},
					ladyModShift	= {	order = 34, type = "toggle",name = function(info) return tr( info[#info])  end,width = "full",	disabled = function( info) return not yo[info[1]].ladyMod end,},
					},
			},

			Raid = {
				order = 40,	name = L["Raid"] .. L["NEW"],type = "group",				
				get = function(info) return yo["Raid"][info[#info]] end,
				set = function(info,val) Setlers( "Raid#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {	
					enable 			= {	order = 1,  type = "toggle", name = L["RAIDenable"], disabled = false,},
					simpeRaid		= {	order = 2,  type = "toggle", name = function(info) return tr( info[#info]) end,},		
					classcolor 		= {	order = 10, type = "select", name = function(info) return tr( info[#info]) end,	values = {[1] = L["HBAR_CC"], [2] = L["HBAR_CHP"], [3] = L["HBAR_DARK"],},},
					groupingOrder 	= {	order = 15, type = "select", name = function(info) return tr( info[#info]) end,	values = {["ID"] = L["SRT_ID"], ["GROUP"] = L["SRT_GR"], ["TDH"] = L["SRT_TDH"], ["THD"] = L["SRT_THD"]},},
					width 			= {	order = 20,	type = "range",  name = function(info) return tr( info[#info]) end,	min = 60, max = 150, step = 1,},
					height 			= {	order = 25,	type = "range",  name = function(info) return tr( info[#info]) end,	min = 20, max = 80, step = 1,},
					numgroups 		= {	order = 30,	type = "range",  name = function(info) return tr( info[#info]) end, min = 4, max = 8, step = 1,},	
					spaicing 		= {	order = 35,	type = "range",  name = function(info) return tr( info[#info]) end,	min = 0, max = 20, step = 1,},	
					partyScale 		= {	order = 40,	type = "range",  name = function(info) return tr( info[#info]) end,	min = 1, max = 3, step = .1,},		
					showHPValue 	= {	order = 45, type = "select", name = function(info) return tr( info[#info]) end,	values = {["[DDG]"] = L["HP_HIDE"], ["[per]"] = L["HP_PROC"], ["[hp]"] = L["HP_HPPROC"]},},
					manacolorClass 	= {	order = 50, type = "toggle", name = function(info) return tr( info[#info]) end,},	
					manabar 		= {	order = 55, type = "select", name = function(info) return tr( info[#info]) end,	values = {[1] = L["MB_ALL"], [2] = L["MB_HEAL"], [3] = L["MB_HIDE"]},},		
					hpBarVertical 	= {	order = 60, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full", },		
					hpBarRevers	 	= {	order = 65, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},	
					showGroupNum 	= {	order = 70, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},	
					showSolo 		= {	order = 75, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					showLFD 		= {	order = 80, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					noHealFrames 	= {	order = 85, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					healPrediction	= {	order = 90, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					--aurasRaid		= {	order = 92, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					aurasParty		= {	order = 94, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					debuffHight		= {	order = 96, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					filterHighLight	= {	order = 97, type = "toggle", name = function(info) return tr( info[#info]) .. L["NEW"] end, width = "full",},
					classBackground = {	order = 98, type = "toggle", name = function(info) return tr( info[#info]) end, width = "full",},
					showMT 			= {	order =100, type = "toggle", name = function(info) return tr( info[#info]) .. L["NEW"] end, width = 1,},
					showMTT 		= {	order =102, type = "toggle", name = function(info) return tr( info[#info]) .. L["NEW"] end, width = 1,},
					heightMT		= {	order =104,	type = "range",  name = function(info) return tr( info[#info]) .. L["NEW"] end,	min = 20, max = 60, step = 1,},
					widthMT			= {	order =106,	type = "range",  name = function(info) return tr( info[#info]) .. L["NEW"] end,	min = 80, max = 220, step = 1,},
					},
			},

			ActionBar = {
				order = 50,	name = L["ActionBar"], type = "group",
				get = function(info) return yo["ActionBar"][info[#info]] end,
				set = function(info,val) Setlers( "ActionBar#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {

					enable 			= {	order = 1, 	type = "toggle",	name = L["ABenable"], width = "full", disabled = false,},
					ShowGrid 		= {	order = 5, 	type = "toggle",	name = function(info) return tr( info[#info]) end, },
					HideHotKey 		= {	order = 10,	type = "toggle", 	name = function(info) return tr( info[#info]) end,	},	
					HideName 		= {	order = 10,	type = "toggle", 	name = function(info) return tr( info[#info]) end,},	
					CountSize 		= {	order = 5,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 8, max = 16, step = 1,},
					MicroMenu 		= {	order = 20, type = "toggle", 	name = function(info) return tr( info[#info]) end, },
					MicroScale 		= {	order = 21,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 0.5, max = 1.5, step = 0.05,},
					panel3Nums		= {	order = 34,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 1, max = 12, step = 1,},
					panel3Cols		= {	order = 36,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 1, max = 12, step = 1,},
					buttonsSize		= {	order = 30,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 25, max = 50, step = 1,},
					buttonSpace		= {	order = 32,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 1, max = 10, step = 1,},
					hoverTexture	= {	order = 40, type = "toggle", 	name = function(info) return tr( info[#info]) end, width = "full"},
				},	
			},		

			NamePlates = {
				order = 70,		name = L["NamePlates"],	type = "group",				
				get = function(info) return yo[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {	

					enable 		= { width = "full",	order = 1, type = "toggle",	name = L["NPenable"], disabled = false, },
					
					maxDispance= {	order =  2,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DEFAULT"] .. 40,	min = 30, max = 60, step = 1, width = "full"},

					width 		= {	order = 20,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DEFAULT"] .. 175,	min = 130, max = 250, step = 1,},
					height 		= {	order = 25,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DEFAULT"] .. 14,	min = 10, max = 25, step = 1,},
					iconDSize 	= {	order = 30,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DESC_iconD"],	min = 10, max = 45, step = 1,},	
					iconBSize 	= {	order = 31,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DESC_iconB"],	min = 10, max = 45, step = 1,},	
					iconDiSize 	= {	order = 35,	type = "range", name = function(info) return tr( info[#info]) end,	desc = L["DESC_iconC"],	min = 10, max = 45, step = 1,},	
					iconCastSize= { order = 37,	type = "range", name = function(info) return tr( info[#info]) end, 	desc = L["DEFAULT"] .. 20, min = 10, max = 35, step = 1,},

					dissIcons 	= {	order = 40, type = "select", name = function(info) return tr( info[#info]) end,	values = { ["none"] = L["NONE"], ["all"] = L["DISS_ALL"], ["dispell"] = L["DISS_CLASS"],},},
					buffIcons 	= {	order = 45, type = "select", name = function(info) return tr( info[#info]) end,	values = {["none"] = L["NONE"], ["dispell"] = L["DISS"], ["all"] = L["ALL_BUFF"], ["buff"] = L["ALL_EX_DIS"],},},

					showCastIcon 	= { width = "full",	order = 50, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					showCastName 	= { width = "full",	order = 52, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					showCastTarget 	= { width = "full",	order = 55, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					showPercTreat 	= { width = 1.5,		order = 60, type = "select", 	name = function(info) return tr( info[#info]) end,	values = { ["none"] = L["NONE"], ["scaledPercent"] = L["scaledPercent"], ["rawPercent"] = L["rawPercent"],},},
					showArrows 		= { width = "full",	order = 65, type = "toggle",	name = function(info) return tr( info[#info]) end, },					
					blueDebuff 		= { width = "full",	order = 67, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					classDispell 	= { width = "full",	order = 33, type = "toggle",	name = function(info) return tr( info[#info]) end,},
					glowTarget		= { width = "full",	order = 68, type = "toggle",	name = function(info) return tr( info[#info]) end, },
					glowBadType		= {	order = 69, type = "select", name = function(info) return tr( info[#info])  end,	values = { ["none"] = "None", ["pixel"] = "Red Lines", ["button"] = "Button Glow", ["cast"] = "Auto Cast Dots",},},
					
					showToolTip = {	order = 50, type = "select", name = function(info) return tr( info[#info]) end,	values = { ["none"] =L["NONE"], ["cursor"] = L["UND_CURCOR"], ["yes"] = L["IN_CONNER"],},},

					executePhaze ={ order = 70, type = "toggle",name = function(info) return tr( info[#info]) end, width = "full"	},
					executeProc  ={ order = 75,	type = "range", name = function(info) return tr( info[#info]) end,	min = 0, max = 100, step = 1,},	
					executeColor ={	order = 72, type = "color",	name = function(info) return tr( info[#info]) end, 
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	

					desc01 = {	order = 79, type = "description", name = L["DESC_TCOL"], width = "full",},

					c0 ={	order = 80, type = "color",	name = function(info) return tr( info[#info]) end, width = 1.5,
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					c0t ={	order = 81, type = "color",	name = function(info) return tr( info[#info]) end,	width = 0.5,
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					
					c1 ={	order = 82, type = "color",	name = function(info) return tr( info[#info]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					c2 ={	order = 84, type = "color",	name = function(info) return tr( info[#info]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					
					c3 ={	order = 86, type = "color",	name = function(info) return tr( info[#info]) end,width = 1.5,
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					c3t ={	order = 87, type = "color",	name = function(info) return tr( info[#info]) end,	width = 0.5,
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					
					desc02 = {	order = 87, type = "description", name = L["DESC_ACOL"], width = "full",},

					myPet ={	order = 88, type = "color",	name = function(info) return tr( info[#info]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					tankOT ={	order = 90, type = "color",	name = function(info) return tr( info[#info]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
					badGood ={	order = 92, type = "color",	name = function(info) return tr( info[#info]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},	
				},
			},	

			Chat = {
				order = 80,	name = L["Chat"] .. L["NEW"], type = "group",
				get = function(info) return yo["Chat"][info[#info]] end,
				set = function(info,val) Setlers( "Chat#" .. info[#info], val) end, 
				args = {	
					EnableChat 		= {	order = 1,  type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},
					BarChat 		= {	order = 10, type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},
					linkOverMouse 	= {	order = 20, type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},
					showVoice 		= {	order = 25, type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},
					showHistory 	= {	order = 30, type = "toggle",	name = function(info) return tr( info[#info]) end, width = "full",},					
					fadingEnable 	= {	order = 36, type = "toggle",	name = function(info) return tr( info[#info]) end,},
					fadingTimer 	= {	order = 38,	type = "range", 	name = function(info) return tr( info[#info]) end, min = 5, max = 100, step = 1, disabled = function( info) return not yo[info[1]].fadingEnable; end,},
					wisperSound		= {	order = 40, type = "select", 	name = function(info) return tr( info[#info]) end, dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					wisperInCombat	= {	order = 42, type = "toggle",	name = function(info) return tr( info[#info]) end,},

					fontsize = {
						name = function(info) return tr( info[#info]) end,  
						order = 2,	type = "range", desc = L["DEFAULT"] .. 10,	min = 10, max = 16, step = 1, 
						get = function(info) return yo["Chat"][info[#info]] end,
						set = function(info,val) Setlers( "Chat#" .. info[#info], val) end, },

					chatFont 		= {	order = 4, type = "select", 	name = function(info) return tr( info[#info]) .. L["NEW"] end, dialogControl = "LSM30_Font", values = LSM:HashTable("font"),
						get = function(info) 
							for k, val in pairs( LSM:List("font")) do
								--print( k, val, yo["Chat"][info[#info]], LSM:Fetch("font", val))
								if yo["Chat"][info[#info]] == LSM:Fetch("font", val) then return val end
							end	end,
						set = function(info, val) Setlers( "Chat#" .. info[#info], LSM:Fetch("font", val))	end,
					},

					--fontsize = {order = 4,	type = "range", name = "Размер шрифта чата", desc = "По-умолчанию: 10",	min = 10, max = 16, step = 1,},
					--chatBubble		= {	order = 40, type = "select", 	name = "Чат-бабл:",	values = {["none"] = "Не изменять", ["remove"] = "Убрать рамку", ["skin"] = "Изменить рамку (skin)", ["border"] = "Изменить рамку (border)"},},
					--chatBubbleFont	= {	order = 44,	type = "range", 	name = "Размер шрифта", min = 5, max = 15, step = 1, 	disabled = function( info) if yo[info[1]].chatBubble == "none" then return true end end,},
					--chatBubbleShift	= {	order = 46,	type = "range", 	name = "Уменьшить размер", min = 0, max = 15, step = 1, disabled = function( info) if yo[info[1]].chatBubble == "none" then return true end end,},
					--chatBubbleShadow= {	order = 42,  type = "toggle",	name = "Добавить тень у шрифта чат-бабла", 				disabled = function( info) if yo[info[1]].chatBubble == "none" then return true end end,},

				},	
			},

			fliger = {
				order = 90, name = L["fliger"], type = "group",
				get = function(info) return yo[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,
				args = {	
					enable 			= { width = "full",	order = 1, type = "toggle",	name = L["FLGenable"], disabled = false, },
					--desc01			= {	order = 2, type = "description", name = L["DESC_FILGER"], width = "full"},
					
					tDebuffEnable	= {	order = 10, type = "toggle",name = "Target Buff/Debuff",width = 0.75},
					pCDEnable 		= {	order = 20, type = "toggle",name = "Player Cooldowns",	width = 0.75},
					pBuffEnable		= {	order = 30, type = "toggle",name = "Player Buff", 		width = 0.75},
					pDebuffEnable	= {	order = 40, type = "toggle",name = "Player Debuff", 	width = 0.75},
					pProcEnable		= {	order = 50, type = "toggle",name = "Player Procs", 		width = 0.75},
					
					tDebuffSize		= {	order = 12,	type = "range", name = L["iconsize"],	min = 10, max = 70, step = 1, width = 0.75},
					pCDSize 		= {	order = 22,	type = "range", name = L["iconsize"],	min = 10, max = 70, step = 1, width = 0.75},
					pBuffSize 		= {	order = 32,	type = "range", name = L["iconsize"],	min = 10, max = 70, step = 1, width = 0.75},
					pDebuffSize		= {	order = 42,	type = "range", name = L["iconsize"],	min = 10, max = 70, step = 1, width = 0.75},
					pProcSize		= {	order = 52,	type = "range", name = L["iconsize"],	min = 10, max = 70, step = 1, width = 0.75},
					
					tDebuffDirect	= {	order = 14, type = "select",name = L["grow"], values = {["RIGHT"] = L["right"], ["LEFT"] = L["left"], ["UP"] = L["up"], ["DOWN"] = L["down"]}, width = 0.7},
					pCDDirect		= {	order = 24, type = "select",name = L["grow"], values = {["RIGHT"] = L["right"], ["LEFT"] = L["left"], ["UP"] = L["up"], ["DOWN"] = L["down"]}, width = 0.7},
					pBuffDirect		= {	order = 34, type = "select",name = L["grow"], values = {["RIGHT"] = L["right"], ["LEFT"] = L["left"], ["UP"] = L["up"], ["DOWN"] = L["down"]}, width = 0.7},
					pDebuffDirect	= {	order = 44, type = "select",name = L["grow"], values = {["RIGHT"] = L["right"], ["LEFT"] = L["left"], ["UP"] = L["up"], ["DOWN"] = L["down"]}, width = 0.7},
					pProcDirect		= {	order = 54, type = "select",name = L["grow"], values = {["RIGHT"] = L["right"], ["LEFT"] = L["left"], ["UP"] = L["up"], ["DOWN"] = L["down"]}, width = 0.7},

					checkBags		= {	order = 55, type = "toggle",name = L["checkBags"], width = "full"},
					gAzetit 		= {	order = 57, type = "toggle",name = L["gAzerit"], width = "full"},	
					
					pCDTimer		= {	order = 99,	type = "range", name = L["pCDTimer"],	min = 0, max = 50, step = 1, width = 1, desc = L["DESC_PCD"]},
				},	
			},

			CTA = {
				order = 90, name = L["CTA"], type = "group",
				get = function(info) return yo[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,
				args = {
					enable 	= { width = "full",	order = 1, type = "toggle",	name = L["CTAenable"], disabled = false, },

					set00	= {	order = 02, type = "description", name = " ", width = "full"},
					readRole= {	order = 03, type = "description", name = L["readRole"], width = "full"},
					nRole	= {	order = 09, type = "toggle",name = L["nRole"],	width = 0.85, desc = L["DESC_NROLE"],},
					tRole	= {	order = 10, type = "toggle",name = L["tank"],	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].nRole); end,},
					hRole 	= {	order = 12, type = "toggle",name = L["heal"],	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].nRole); end,},
					dRole	= {	order = 14, type = "toggle",name = L["dd"], 	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].nRole); end,},
					
					set01	= {	order = 20, type = "description", name = " ", width = "full"},
					setRole	= {	order = 21, type = "description", name = L["DESC_SETN"], width = "full"},
					setN	= {	order = 22, type = "toggle",name = L["setN"],	width = 0.85},
					setT	= {	order = 24, type = "toggle",name = L["tank"],	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].setN); end,},
					setH 	= {	order = 26, type = "toggle",name = L["heal"],	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].setN); end,},
					setD	= {	order = 28, type = "toggle",name = L["dd"], 	width = 0.5, disabled = function( info) return ( not yo[info[1]].enable or yo[info[1]].setN); end,},

					set02	= {	order = 29, type = "description", name = " ", width = "full"},
					heroic	= {	order = 30, type = "toggle",name = L["heroic"], 	width = 1},
					lfr		= {	order = 32, type = "toggle",name = L["lfr"], 	width = 1},
					
					timer	= {	order = 40,	type = "range", name = L["CTAtimer"],	min = 1, max = 600, step = 1, width = 1},
					sound	= {	order = 42, type = "select",name = L["CTAsound"], dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					expand	= {	order = 44, type = "toggle",name = L["expand"],},
					nosound	= {	order = 45, type = "toggle",name = L["CTAnosound"],},	
					hideLast= {	order = 47, type = "toggle",name = L["hideLast"], width = "full"},	
					
					launch 	= {	order = 99, type = "execute",name = L["CTAlaunch"], disabled = function( info) return ( not yo[info[1]].enable or not yo[info[1]].hide); end,
						func = function() yo.CTA.hide = false resetCTAtimer() end,},	
				},
			},

			ResetConfig = {
           		order = 1, type = "execute", confirm  = true, width = 0.75,	name = L["ResetConfig"],
           		desc = L["RESET_DESC"],
           		func = function() yo_PersonalConfig = nil yo_AllConfig = nil ReloadUI() end,},

			MovingFrames = {
           		order = 10,	type = "execute", width = 0.7,
           		name = function()  if t_unlock ~= true then  return L["MOVE"] else return L["DONTMOVE"] end end, 
           		func = function() if t_unlock ~= true then AnchorsUnlock() else AnchorsLock() end end,},

			ResetPosition = {
           		order = 20,	type = "execute", confirm  = true, width = 0.7,  		name = L["ResetPosition"], 
           		desc = L["RESETUI_DESC"],
           		func = function() AnchorsReset() end,},

			KeyBind = {
           		order = 30,	type = "execute", width = 0.7, name = "Key Binding", 
           		func = function() 	SlashCmdList.MOUSEOVERBIND() end,},

			ReloadConfig = {
           		order = -1, type = "execute", width = 0.7, name = L["ReloadConfig"], desc = L["RELOAD_DESC"],
           		disabled = function() return not needReload end,           	
           		func = function() if needReload then ReloadUI() end	 end,},


			healBotka = {
				name = "Хилботка",
				type = "group",
				order = 200,
				hidden = function() return not yo.healBotka.enable end,	

				args = {	
					key1	= {	order = 20, type = "keybinding",	name = "Показывать иконки 1",
						get = function(info) return yo[info[1]][info[#info]] end,
						set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, },
						
					key2	= {	order = 22, type = "keybinding",	name = "Показывать иконки 2",
						get = function(info) return yo[info[1]][info[#info]] end,
						set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, },
				},	
			},

			NextOptions = {
				name = "Следующие настройки",
				type = "group",
				order = 20,
				hidden = true,
				args = {	},	
			},
		};
	};
 	
	if ACD == nil then 
		--db = LibStub("AceDB-3.0"):New("GottaGoFastDB", defaults, true);
		LibStub("AceConfig-3.0"):RegisterOptionsTable("yoFrame", options)

		ACD = LibStub("AceConfigDialog-3.0")
		ACD:SetDefaultSize( "yoFrame", 650, 500)

		--yo_optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions( "yoFrame", "yore Frames");
  		--yo_optionsFrame.okay = function (self) ReloadUI(); end;
  		--yo_optionsFrame.close = function (self) ReloadUI(); end;

 		--yo_ACD.CloseAll = function (self) ReloadUI(); end;
 		--yo_ACD.Close = function (self) ReloadUI(); end;

	end
	ACD:Open( "yoFrame")
end

SlashCmdList["CFGSLASH"] = function() InitOptions() end
SLASH_CFGSLASH1 = "/cfg"
SLASH_CFGSLASH2 = "/config"


local GameMenuButton = CreateFrame("Button", "GameMenuButtonQulightUI", GameMenuFrame, "GameMenuButtonTemplate")
GameMenuButton:SetText("|cff00ffffyoFrame|r")
GameMenuButton:SetPoint("TOP", "GameMenuButtonAddons", "BOTTOM", 0, -1)

GameMenuFrame:HookScript("OnShow", function()
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButton:GetHeight())
	GameMenuButtonLogout:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -16)
end)

GameMenuButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	HideUIPanel(GameMenuFrame)
	InitOptions()
end) 
