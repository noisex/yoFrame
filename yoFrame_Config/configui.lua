local addonName, ns = ...
local L, yoCon, N, defConfig = unpack( ns)

N.Config = N:NewModule( 'Config')

local _G 	= _G
local AB 	= N:GetModule('Config')
local AO 	= N:GetModule('alertOptions')

local ADB 	= _G.LibStub("AceDB-3.0")
local ADBO 	= _G.LibStub("AceDBOptions-3.0")
local AC 	= _G.LibStub("AceConfig-3.0")
local LDS 	= _G.LibStub("LibDualSpec-1.0")
local LSM 	= _G.LibStub("LibSharedMedia-3.0")

local ACD
local needReload = false

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local strjoin, ReloadUI, PlaySound, print, UnitName, GetRealmName, HideUIPanel, CreateFrame, CopyTable, SetCVar, UnitClass, wipe
	= strjoin, ReloadUI, PlaySound, print, UnitName, GetRealmName, HideUIPanel, CreateFrame, CopyTable, SetCVar, UnitClass, wipe

local db, n ---, yo
local aConf = {}

-- GLOBALS: Setlers, yoFrameDB

LSM:Register("statusbar", "yo Plain Gray", 	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\bar16")
LSM:Register("statusbar", "yo Plain White", "Interface\\AddOns\\yoFrame\\Media\\statusbars\\plain_white")
LSM:Register("statusbar", "yo StatusBar", 	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\statusbar4")
LSM:Register("statusbar", "yo DGroung", 	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\bar_dground")
--LSM:Register("statusbar", "yo Striped", 	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\striped")
LSM:Register("statusbar", "yo Smooth", 		"Interface\\AddOns\\yoFrame\\Media\\statusbars\\flatsmooth")

LSM:Register("statusbar", "yo Smooth+", 	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\lightflatsmooth")
LSM:Register("statusbar", "yo Smooth++",	"Interface\\AddOns\\yoFrame\\Media\\statusbars\\verylightflatsmooth")

LSM:Register("statusbar", "yo Bar 07", 		"Interface\\AddOns\\yoFrame\\Media\\statusbars\\bar7")
LSM:Register("statusbar", "yo Bar 17", 		"Interface\\AddOns\\yoFrame\\Media\\statusbars\\bar17")
LSM:Register("statusbar", "yo Neal", 		"Interface\\AddOns\\yoFrame\\Media\\statusbars\\Neal")

LSM:Register("sound", "Tick 01", 			"Interface\\Addons\\yoFrame\\Media\\sound\\Bip.ogg")
LSM:Register("sound", "Tick 02", 			"Interface\\Addons\\yoFrame\\Media\\sound\\CSDroplet.ogg")
LSM:Register("sound", "Applause", 			"Interface\\Addons\\yoFrame\\Media\\sound\\Applause.ogg")
LSM:Register("sound", "Shotgun", 			"Interface\\Addons\\yoFrame\\Media\\sound\\Shotgun.ogg")
LSM:Register("sound", "Wisper", 			"Interface\\Addons\\yoFrame\\Media\\sound\\wisp.OGG")
LSM:Register("sound", "Murloc", 			"Interface\\Addons\\yoFrame\\Media\\sound\\BabyMurlocA.ogg")

LSM:Register("font", "yoMagistral", 		"Interface\\AddOns\\yoFrame\\Media\\fonts\\qFont.ttf", 130)
LSM:Register("font", "yoSansNarrow",		"Interface\\AddOns\\yoFrame\\Media\\fonts\\qSans.ttf", 130)
LSM:Register("font", "yoPixelFont", 		"Interface\\AddOns\\yoFrame\\Media\\fonts\\pxFont.ttf", 130)
LSM:Register("font", "yoCormac", 			"Interface\\AddOns\\yoFrame\\Media\\fonts\\cormac.ttf", 130)

local function checkToReboot( var, ...)
	local noReboot
	for k, v in pairs( n.noReboot) do
		if v == var then
			noReboot = true
			break
		end
	end

	if n.conFuncs[var] then
		n.conFunc( var, ...)
	end

	if not noReboot then needReload = true end
end

function Setlers( path, val, ...)
	--local aConf = {}
	local p1, p2, p3, p4 = strsplit("#", path)

	--if n.allData[N.myRealm][N.myName].PersonalConfig then 	aConf = _G["yo_PersonalConfig"]
	--else												aConf = _G["yo_AllConfig"]	end

	if p4 then
		--aConf[p1][p2][p3][p4] = val
		--if not yo[p1] then yo[p1]= {} end
		--if not yo[p1][p2] then yo[p1][p2] = {} end
		--if not yo[p1][p2][p3] then yo[p1][p2][p3] = {} end
		--if not yo[p1][p2][p3][p4] then yo[p1][p2][p3][p4] = {} end

		--yo[p1][p2][p3][p4] = val
		db[p1][p2][p3][p4] = val
		checkToReboot( p4, val, ...)
	elseif p3 then
		--aConf[p1][p2][p3] = val
		--if not yo[p1] then yo[p1]= {} end
		--if not yo[p1][p2] then yo[p1][p2] = {} end
		--if not yo[p1][p2][p3] then yo[p1][p2][p3] = {} end

		--yo[p1][p2][p3] = val
		db[p1][p2][p3] = val
		checkToReboot( p3, val, ...)
--		print(3, val)
	elseif p2 then
		--if not yo[p1] then yo[p1]= {} end
		--if not yo[p1][p2] then yo[p1][p2] = {} end

		--yo[p1][p2] = val
		db[p1][p2] = val
		checkToReboot( p2, val, ...)
--		print(2, p1, p2, db[p1][p2] )
	else
		--if not yo[p1] then yo[p1]= {} end

		--yo[p1] = val
		db[p1] = val
--		print(1, val)
		checkToReboot( val, ...)
	end
end

local function tr( path)
	if not L[path] or L[path] == "" then
		L[path] = "|cffff0000NO LOCALE: |r".. path
	end

	return L[path]
end

StaticPopupDialogs["CONFIRM_PERSONAL"] = {
  	text = L["CONFIRM_PERSONAL"],
  	button1 = "Yes",
  	button2 = "No",
  	OnAccept = function()
		--n.allData[N.myRealm][N.myName].PersonalConfig = not n.allData[N.myRealm][N.myName].PersonalConfig
		n.allData.personalProfiles = not n.allData.personalProfiles
     	ReloadUI()
  	end,
  	timeout = 0,
  	whileDead = true,
  	hideOnEscape = true,
  	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

N.tr = tr
N.Setlers = Setlers

local function InitOptions()

	local defaults = {
		profile = {},
	}

	local options = {
		name = function(i) return tr(i[#i]) end,
		type = "group",
		args = {
			System = {
				name = function(i) return tr(i[#i]) end,
				type = "group",
				order = 10,
				args = {
					PersonalConfig = {
						order = 1, type = "toggle", width = "full",	name = function(i) return tr(i[#i]) end,  desc = L["PERSONAL_DESC"],	descStyle = "inline",
						get = function(info) return n.allData.personalProfiles end,
						set = function(info,val) n.allData.personalProfiles = val checkToReboot( val) end,	},
					scriptErrors= {
						name = function(i) return tr(i[#i]) end, order = 9, type = "toggle",
						get = function(info) return db["General"][info[#info]] end, width = "full",
						set = function(info,val) Setlers( "General#" .. info[#info], val) end,	},
			        ChangeSystemFonts = {
						order = 10, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",
						get = function(info) return db["Addons"][info[#info]] end,
						set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 	},
			        sysfontsize = {
			        	order = 11,	type = "range", name = function(i) return tr(i[#i]) end, 	desc = L["SYSFONT_DESC"], min = 9, max = 16, step = 1, width = "full",
						disabled = function() return not db["Addons"].ChangeSystemFonts; end,
						get = function(info) return db["Media"].sysfontsize end,
						set = function(info,val) Setlers( "Media#sysfontsize", val) ChangeSystemFonts( val) end,},
			        fontsize = {
			   			name = L["fontSizeAddon"], order = 15,	type = "range", desc = L["DEFAULT"] .. 10, min = 9, max = 16, step = 1, width = "full",
						get = function(info) return db.Media.fontsize end,
						set = function(info,val) Setlers( "Media#fontsize", val, db.Media.fontsize) end,},
						--UpdateStrings( val, db.Media.fontsize)
					texture = {
						name = function(i) return tr(i[#i]) end, order = 30,	type = "select",	width = "full", dialogControl = "LSM30_Statusbar",	values = LSM:HashTable("statusbar"),
						get = function(info)
							for k, val in pairs( LSM:List("statusbar")) do
								if db["Media"][info[#info]] == LSM:Fetch("statusbar", val) then return val end
							end	end,
						set = function(info, val) Setlers( "Media#" .. info[#info], LSM:Fetch("statusbar", val)) end,},

					AutoScale = {
						name = function(i) return tr(i[#i]) end, 	order = 40, type = "select", values = {["none"] = L["SCALE_NONE"], ["auto"] = L["SCALE_AUTO"], ["manual"] = L["SCALE_MANUAL"]},
						get = function(info) return db.Media.AutoScale end,
						set = function(info,val) Setlers( "Media#AutoScale", val) end,},
					ScaleRate = {
						name = function(i) return tr(i[#i]) end, order = 42,	type = "range", desc = L["DEFAULT"] .. 0.64, min = 0.6, max = 1.2, step = 0.01, disabled = function() if db.Media.AutoScale ~= "manual" then return true end end	,
						get = function(info) return db["Media"][info[#info]] end,
						set = function(info,val) Setlers( "Media#" .. info[#info], val)
						--	SetCVar("useUiScale", 1)	SetCVar("uiScale", val) UIParent:SetScale( val)
						end, },

					--spell12	= { order =122, type = "select", 		name = "", width = 1.1, values = n.allData.configData[myRealm]},

					set00	= {	order = 50, type = "description", name = " ", width = "full"},
					--fontSizeMinus = { hidden = true,
     --      				order = 51,	type = "execute", width = 0.5, name = "Font -",
     --      				func = function() Setlers( "Media#fontsize", db.Media.fontsize - 1) UpdateStringScale( -1) end,},
     --      			fontSizePlus = { hidden = true,
     --      				order = 52,	type = "execute", width = 0.5, name = "Font +",
     --      				func = function() Setlers( "Media#fontsize", db.Media.fontsize + 1) UpdateStringScale( 1) end,},

           			--set01	= {	order = 60, type = "description", name = " ", width = "full",  hidden = true,},
           			--edgeSizeMinus = {  hidden = true,
           			--	order = 61,	type = "execute", width = 0.5, name = "Edge -", desc = "JUST FOR FUN",
           			--	func = function() --[[Setlers( "Media#edgeSize", max( -1, db.Media.edgeSize - 1))]] UpdateShadowEdge( -1) end,},
           			--edgeizePlus = {  hidden = true,
           			--	order = 62,	type = "execute", width = 0.5, name = "Edge +", desc = "JUST FOR FUN",
           			--	func = function() --[[Setlers( "Media#edgeSize", max( -1, db.Media.edgeSize + 1)) ]] UpdateShadowEdge( 1) end,},

           			--edgeSize = { order = 62, type = "range", name = "Shadow edgeSize", min = 1, max = 10, step = 1,
           			--	get = function(info) return db["Media"][info[#info]] end,
           			--	set = function(info,val) Setlers( "Media#" .. info[#info], val) UpdateShadowEdge() end,},

           			--set02	= {	order = 63, type = "description", name = " ", width = "full",  hidden = true},
           			shadowColor	= {
           				order = 70, type = "color",		name = "Shadow Border Color", desc = "JUST FOR FUN", width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db.Media.shadowColor)	end,
						set = function(info, r, g, b) --[[Setlers( "Media#shadowColor", strjoin(",", r, g, b))]] UpdateShadows(  r, g, b) end,},
					classBorder	= {	order = 74, type = "execute", name = "Shadow classColor", desc = "JUST FOR FUN",
           				func = function() UpdateShadows( N.myColor.r, N.myColor.g, N.myColor.b) end,},
           			borderReset	= {	order = 76, type = "execute", name = "Shadow Reset", desc = "JUST FOR FUN",
           				func = function() UpdateShadows( strsplit( ",", db.Media.shadowColor)) end,},
			 	},
			 },


			Addons = {
				order = 20,	name = L["Addons"], type = "group",
				get = function(info) return db["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end,
				args = {
					RaidUtilityPanel= {	order = 1, type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full",	desc = L["RUP_DESC"],},
					Potatos 		= {	order = 2, type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full",	desc = L["POT_DESC"], hidden = false,},
					mythicProcents 	= {	order = 4, type = "toggle", name = function(i) return tr(i[#i]) end,  width = "full",	},
					--InfoPanels	 	= {	order = 5, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					BlackPanels	 	= {	order = 6, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					FlashIconCooldown={ order = 7, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					ArtifactPowerbar= {	order = 8, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					afk				= {	order =10, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					stbEnable 		= {	order =12, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					MoveBlizzFrames = {	order =13, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					disenchanting 	= {	order =14, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},

					RaidCoolDowns	= {	order =16, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					covenantsCD		= {	order =17, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},

					movePersonal	= {	order =18, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},
					moveWidget		= {	order =19, type = "toggle", name = function(i) return tr(i[#i]) end, 	width = "full",	},

					addonFont 		= {	order = 20, type = "select", 	name = function(i) return tr(i[#i]) end, dialogControl = "LSM30_Font", values = LSM:HashTable("font"),
										get = function(info) for k, val in pairs( LSM:List("font")) do if db.Media.font == LSM:Fetch("font", val) then return val end end end,
										set = function(info, val) Setlers( "Media#font", LSM:Fetch("font", val))	end, },
					pixelFont 		= {	order = 25, type = "select", 	name = function(i) return tr(i[#i]) end, dialogControl = "LSM30_Font", values = LSM:HashTable("font"),
										get = function(info) for k, val in pairs( LSM:List("font")) do if db.Media.fontpx == LSM:Fetch("font", val) then return val end end	end,
										set = function(info, val) Setlers( "Media#fontpx", LSM:Fetch("font", val))	end, },
				},
			},

			Automatic = {
				order = 25,	name = L["Automatic"], type = "group",
				get = function(info) return db["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end,
				args = {
					AutoRepair 				= {	order = 1, type = "toggle", name = function(i) return tr(i[#i]) end,  width = "full", },
					RepairGuild 			= {	order = 3, type = "toggle", name = function(i) return tr(i[#i]) end,  width = "full", disabled = function( info) return not db.Addons.AutoRepair; end},
					AutoSellGrayTrash 		= {	order = 5, type = "toggle",	name = function(i) return tr(i[#i]) end, 	width = "full", desc = L["SALE_DESC"],},
					AutoScreenOnAndAchiv	= { order = 7, type = "toggle",	name = function(i) return tr(i[#i]) end, 	},
					AutoScreenOnLvlUp		= { order =13, type = "toggle",	name = function(i) return tr(i[#i]) end, 	},
					AutoInvaitFromFriends 	= {	order =14, type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full"},
					AutoInvite 				= {	order =15, type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full", desc = "инв inv byd штм 123"},
					AutoLeader 				= {	order =16, type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full"},
					equipNewItem			= {	order =17, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					equipNewItemLevel		= {	order =18, type = "range",	name = function(i) return tr(i[#i]) end, 	min = 0, max = 800, step = 1,},
					AutoQuestSkipScene 		= { order =20, type = "toggle",	name = function(i) return tr(i[#i]) end, 	width = "full"},
					AutoCovenantsMission	= { order =30, type = "toggle",	name = function(i) return tr(i[#i]) end, 	width = "full"},
				},
			},

			Quests = {
				order = 27,	name = QUESTS_LABEL, type = "group",
				get = function(info) return db["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end,
				--disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					ObjectiveTracker= {	order = 19, type = "toggle",name = function(i) return tr(i[#i]) end,  width = "full" },
					--ObjectiveShort	= {	order = 21, type = "toggle",name = function(i) return tr(i[#i]) end,  width = "full" },
					ObjectiveHeight = { order = 22, type = "range", name = function(i) return tr(i[#i]) end, 	min = 250, max = 650, step = 1, desc = L["OBJQ_DESC"],	},
					hideObjective	= {	order = 24, type = "toggle",name = function(i) return tr(i[#i]) end,   },
					showToday		= {	order = 26, type = "toggle",name = function(i) return tr(i[#i]) end,  width = "full" },

					AutoQuesting = {
						order = 30,	name = L["AutoQuesting"], type = "group",	inline = true,
						args = {
							AutoQuest = {		order = 10, type = "toggle",	name = function(i) return tr(i[#i]) end, 	desc = L["QUACP_DESC"],},
							AutoQuestComplete ={order = 11, type = "toggle",	name = function(i) return tr(i[#i]) end, 	desc = L["QUCOM_DESC"],},
							AutoQuestEnhance  ={order = 13, type = "toggle",	name = function(i) return tr(i[#i]) end, 	desc = L["QUCOM_ENCH"],},
							AutoQuestComplete2Choice = {order = 15, type = "toggle",	name = function(i) return tr(i[#i]) end,
								disabled = function() return not db["Addons"].AutoQuestComplete; end,		desc = L["QU2CH_DESC"],},
						},
					},
					TalkingHead = {
						order = 40,	name = L["TalkingHeadHead"], type = "group",	inline = true,
						args = {
							hideHead 		= {	order = 10, type = "toggle",  name = function(i) return tr(i[#i]) end, width = "full",},
							hideSound		= { order = 13, type = "toggle",  name = function(i) return tr(i[#i]) end, width = "full",},
							hideForAll 		= { order = 15, type = "toggle",  name = function(i) return tr(i[#i]) end, width = "full",},

							hideCopyData 	= { order = 20, type = "execute", name = function(i) return tr(i[#i]) end, width = 1, confirm  = true, func = function() n:CopyTable( n.allData.talkingHead, _G.yo_talkingHead) end,},
							hideCopyBack 	= { order = 21, type = "execute", name = function(i) return tr(i[#i]) end, width = 1, confirm  = true, func = function() n:CopyTable( _G.yo_talkingHead, n.allData.talkingHead) end,},

							hideClearData 	= { order = 25, type = "execute", name = function(info) return tr( info[#info]) .. " #" .. n.tCount( _G.yo_talkingHead) 	end, width = 1, confirm  = true, func = function() _G.yo_talkingHead = {} end,},
							hideClearAll 	= { order = 26, type = "execute", name = function(info) return tr( info[#info]) .. " #" .. n.tCount( n.allData.talkingHead) end, width = 1, confirm  = true, func = function() n.allData.talkingHead = {} end,},
						},
					},
				},
			},

			Minimaps = {
				order = 25,	name = MINIMAP_LABEL, type = "group",
				get = function(info) return db["Addons"][info[#info]] end,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end,
				args = {
					MiniMap 		= {	order = 1,  type = "toggle",	name = function(i) return tr(i[#i]) end, 	width = 1},
					MiniMapSize		= {	order = 2,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 100, max = 250, step = 10,},
					MMColectIcons 	= {	order = 5,  type = "toggle",	name = function(i) return tr(i[#i]) end,  width = "full"},
					MiniMapCoord 	= {	order = 10, type = "toggle",	name = function(i) return tr(i[#i]) end,  },
					MiniMapHideText = {	order = 15, type = "toggle",	name = function(i) return tr(i[#i]) end, 	desc = L["MMHIDE_DESC"],},
					MMCoordColor 	= {	order = 20, type = "color",		name = function(i) return tr(i[#i]) end,
						disabled = function() return not db.Addons.MiniMapCoord; end,
						get = function(info, r, g, b)  return strsplit( ",", db.Addons.MMCoordColor)	end,
						set = function(info, r, g, b) Setlers( "Addons#MMCoordColor", strjoin(",", r, g, b)) end,},
					MMCoordSize 	= {	order = 25,	type = "range", name = function(i) return tr(i[#i]) end,  min = 5, max = 16, step = 1, desc = L["DEFAULT"] .. 8,
						disabled = function() return not db.Addons.MiniMapCoord; end,	},
					minimapMove 	= {	order = 30, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full", },
				},
			},

			CastBar = {
				order = 30,	name = L["CastBar"], type = "group",
				args = {
					player = {
						order = 10,	name = L["PCB"], type = "group",	inline = true,
						get = function(info) return db[info[1]][info[2]][info[#info]] end,
						set = function(info,val)    Setlers( info[1] .."#".. info[2] .."#".. info[#info], val) end,
						args = {
							QueueWindow = {	order = 1,	type = "range", 	name = function(i) return tr(i[#i]) end,	min = 100, max = 1000, step = 10, width = "full", desc = L["DESC_QUEUE"],
								set = function(info,val) Setlers( info[1] .."#".. info[2] .."#".. info[#info], val, true) SetCVar("SpellQueueWindow", val) end, },
							bigBar 		= {	order = 10, type = "toggle", 	name = function(i) return tr(i[#i]) end},
							classcolor	= {	order = 14, type = "toggle", 	name = function(i) return tr(i[#i]) end},
							iconincombat= { order = 20, type = "toggle",	name = function(i) return tr(i[#i]) end,	disabled = function() return not db["CastBar"]["player"].enable; end,},
						},
					},
					BCB = {
						order = 20,	name = L["BCB"], type = "group",	inline = true,
						get = function(info) return db[info[1]][info[2]][info[#info]] end,
						set = function(info,val) Setlers( info[1] .."#".. info[2] .."#".. info[#info], val)	end,
						disabled = function() return not db.CastBar.BCB.enable; end,
						args = {
							enable 		= { order = 3,  type = "toggle", 	name = L["BCBenable"], width = "full",  disabled = false, },
							unit 		= { order = 4,  type = "select", 	name = L["BCDunit"],   width = 1,	values = {["player"] = L["player"], ["target"] = L["target"]},},
							castBoss	= {	order = 7,  type = "toggle",	name = function(i) return tr(i[#i]) end, desc = L["DESC_CASTBOSS"],},
							width 		= { order = 10,	type = "range", 	name = function(i) return tr(i[#i]) end, 	min = 150, max = 800, step = 10,},
							height 		= {	order = 14,	type = "range", 	name = function(i) return tr(i[#i]) end,	min = 10, max = 40, step = 1,},
							offsetY 	= {	order = 16,	type = "range", 	name = function(i) return tr(i[#i]) end, 	min = -500, max = 500, step = 1,},
							offsetX 	= {	order = 18,	type = "range", 	name = function(i) return tr(i[#i]) end, 	min = -900, max = 900, step = 1,},
							icon 		= {	order = 20, type = "toggle",	name = function(i) return tr(i[#i]) end,},
							iconSize 	= {	order = 21,	type = "range", 	name = function(i) return tr(i[#i]) end,	min = 10, max = 60, step = 1,},
							iconoffsetX = {	order = 22,	type = "range", 	name = function(i) return tr(i[#i]) end,	min = -400, max = 400, step = 1,},
							iconoffsetY = {	order = 23,	type = "range", 	name = function(i) return tr(i[#i]) end,	min = -70, 	max = 70, step = 1,},
							iconincombat= { order = 24, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
							classcolor 	= {	order = 25, type = "toggle",	name = L["CBclasscolor"],	desc = L["DESC_BCB_CC"],	width = "full",},
							treatborder = {	order = 26, type = "toggle",	name = function(i) return tr(i[#i]) end,	desc = L["DESC_BCB_TREAT"],	width = "full",},
							castbarAlpha= {	order = 40,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 0, max = 1, step = 0.01,},
						},
					},
				},
			},

			Bags = {
				order = 35,	name = L["Bags"], type = "group",
				get = function(info) return db["Bags"][info[#info]] end,
				set = function(info,val) Setlers( "Bags#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 			= { order = 1, type = "toggle",	name = L["BAGenable"], disabled = false, },
					buttonSize 		= { order = 5, type = "range", 	name = function(i) return tr(i[#i]) end, min = 20, max = 50, step = 1,	desc = L["DEFAULT"] .. 32,},
					numMaxRow 		= {	order = 6, type = "range", 	name = function(i) return tr(i[#i]) end, min = 5, max = 20, step = 1,	desc = L["DEFAULT"] .. 16,},
					buttonSpacing 	= {	order = 7,	type = "range", name = function(i) return tr(i[#i]) end, min = 1, max = 10, step = 1,desc = L["DEFAULT"] .. 7,},
					containerWidth 	= {	order = 8, type = "range", 	name = function(i) return tr(i[#i]) end, min = 350, max = 800, step = 1,	desc = L["DEFAULT"] .. 438,},
					newIconAnimation= { order = 10, type = "toggle",name = function(i) return tr(i[#i]) end, width = "full", },
					newAnimationLoop= { order = 12, type = "toggle",name = function(i) return tr(i[#i]) end, width = "full",},
					showAltBags		= {	order = 40, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
					countAltBags	= {	order = 42, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full", disabled = function( info) return not db[info[1]].enable or not db[info[1]].showAltBags end,},
					countGuildBank	= {	order = 43, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full", disabled = function( info) return not db[info[1]].enable or not db[info[1]].showAltBags end,},
					showGuilBank	= {	order = 41, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full", disabled = function( info) return not db[info[1]].enable or not db[info[1]].showAltBags end,},
					LeftToRight 	= {	order = 50, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
					ResetConfig 	= {	order = 99, type = "execute", confirm  = true, width = 1,	name = L["ResetBB"], desc = L["RESET_BB_DESC"], func = function() yo_BB = nil yo_BBCount = nil ReloadUI() end, },
				},
			},

			UF = {
				order = 37,	name = L["UF"], type = "group",
				get = function(info) return db["UF"][info[#info]] end,
				set = function(info,val) Setlers( "UF#" .. info[#info], val) end, --n.updateAllUF()
				disabled = function( info) if #info > 1 then return not db[info[1]].unitFrames; end end,
				args = {
					--enable 			= {	order = 1, 	type = "toggle",	name = L["UFenable"], width = "full", disabled = false,},
					unitFrames		= {	order = 1,  type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full", disabled = false,},
					colorUF 		= {	order = 10, type = "select", 	name = function(i) return tr(i[#i]) end, disabled = true, values = { [0]  = L["HBAR_TS"] ,[1] = L["HBAR_CC"], [2] = L["HBAR_CHP"], [3] = L["HBAR_DARK"],},},
					classBackground = {	order = 15, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full", disabled = true,},
					simpleUF 		= {	order = 20,	type = "toggle", 	name = function(i) return tr(i[#i]) end, },
					enableSPower	= {	order = 25,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = 1.2},
					showGCD 		= {	order = 30,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full",},
					showShards 		= {	order = 40,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full",},
					debuffHight		= {	order = 50, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full",},
					rightAbsorb		= {	order = 55, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full",},
					hideOldAbsorb	= {	order = 60, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full",},
					powerHeight		= {	order =	70,	type = "range",  	name = function(i) return tr(i[#i]) end, min = 1, max = 10, step = 1,},
				},
			},

			Raid = {
				order = 40,	name = L["Raid"],type = "group",
				get = function(info) return db["Raid"][info[#info]] end,
				set = function(info,val) Setlers( "Raid#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 			= {	order = 1,  type = "toggle", name = L["RAIDenable"], disabled = false,},
					--simpeRaid		= {	order = 2,  type = "toggle", name = function(i) return tr(i[#i]) end,},
					raidTemplate	= {	order = 02, type = "select", name = function(i) return tr(i[#i]) end,	values = {[1] = "Normal", [2] = "Simple", [3] = "HealBotka",},},
					classcolor 		= {	order = 10, type = "select", name = function(i) return tr(i[#i]) end,	values = {[1] = L["HBAR_CC"], [2] = L["HBAR_CHP"], [3] = L["HBAR_DARK"],},},
					groupingOrder 	= {	order = 15, type = "select", name = function(i) return tr(i[#i]) end,	values = {["ID"] = L["SRT_ID"], ["GROUP"] = L["SRT_GR"], ["TDH"] = L["SRT_TDH"], ["THD"] = L["SRT_THD"], ["LGBT"] = L["SRT_PIHORA"]},},
					width 			= {	order = 20,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 60, max = 150, step = 1,},
					height 			= {	order = 25,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 20, max = 80, step = 1,},
					numgroups 		= {	order = 30,	type = "range",  name = function(i) return tr(i[#i]) end, min = 4, max = 8, step = 1,},
					spaicing 		= {	order = 35,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 0, max = 20, step = 1,},
					partyScale 		= {	order = 40,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 1, max = 3, step = .1,},
					showHPValue 	= {	order = 45, type = "select", name = function(i) return tr(i[#i]) end,	values = {["[DDG]"] = L["HP_HIDE"], ["[per]"] = L["HP_PROC"], ["[hp]"] = L["HP_HPPROC"]},},
					--manacolorClass 	= {	order = 50, type = "toggle", name = function(i) return tr(i[#i]) end,},
					manabar 		= {	order = 55, type = "select", name = function(i) return tr(i[#i]) end,	values = {[1] = L["MB_ALL"], [2] = L["MB_HEAL"], [3] = L["MB_HIDE"]},},
					fadeColor		= {	order = 56,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 0.1, max = 1, step = .1,},
					darkAbsorb		= {	order = 58,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 0.1, max = 3, step = .1,},
					classBackground = {	order = 60, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					hpBarVertical 	= {	order = 62, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full", },
					hpBarRevers	 	= {	order = 65, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					showGroupNum 	= {	order = 70, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					showSolo 		= {	order = 75, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					showLFD 		= {	order = 80, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					noHealFrames 	= {	order = 85, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					healPrediction	= {	order = 90, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					--aurasRaid		= {	order = 92, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					aurasParty		= {	order = 94, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					debuffHight		= {	order = 96, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					filterHighLight	= {	order = 97, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					showMT 			= {	order =100, type = "toggle", name = function(i) return tr(i[#i]) end, width = 1,},
					showMTT 		= {	order =102, type = "toggle", name = function(i) return tr(i[#i]) end, width = 1,},
					showMTTT		= {	order =110, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					heightMT		= {	order =115,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 20, max = 60, step = 1,},
					widthMT			= {	order =120,	type = "range",  name = function(i) return tr(i[#i]) end,	min = 80, max = 220, step = 1,},
					showValueTreat	= {	order =125, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
					showPercTreat 	= { order =130, type = "select", name = function(i) return tr(i[#i]) end,	values = { ["none"] = L["NONE"], ["scaledPercent"] = L["scaledPercent"], ["rawPercent"] = L["rawPercent"],}, width = 1.5, disabled = function( info) return not db.Raid.showValueTreat; end,},

					},
			},

			ActionBar = {
				order = 50,	name = L["ActionBar"], type = "group",
				get = function(info) return db["ActionBar"][info[#info]] end,
				set = function(info,val) Setlers( "ActionBar#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {

					enable 			= {	order = 1, 	type = "toggle",	name = L["ABenable"], width = "full", disabled = false,},
					ShowGrid 		= {	order = 2, 	type = "toggle",	name = function(i) return tr(i[#i]) end, },
					CountSize 		= {	order = 5,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 8, max = 16, step = 1,},
					MicroMenu 		= {	order = 20, type = "toggle", 	name = function(i) return tr(i[#i]) end, },
					MicroScale 		= {	order = 21,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 0.5, max = 1.5, step = 0.05,},
					showBar3		= {	order = 25, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full", },
					showBar5		= {	order = 27, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full", },
					panel3Nums		= {	order = 34,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 1, max = 12, step = 1,},
					panel3Cols		= {	order = 36,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 1, max = 12, step = 1,},
					buttonsSize		= {	order = 30,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 25, max = 50, step = 1,},
					buttonSpace		= {	order = 32,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 1, max = 10, step = 1,},
					--hoverTexture	= {	order = 40, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full"},
					showNewGlow		= {	order = 40, type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full"},
					HideHotKey 		= {	order = 60,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full"},
					secondHot		= {	order = 61,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full", disabled = function( info) if #info > 1 then return ( not db[info[1]].enable or db.ActionBar.HideHotKey) end end,},
					HideName 		= {	order = 62,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full"},
					HotToolTip		= {	order = 63,	type = "toggle", 	name = function(i) return tr(i[#i]) end, width = "full"},
					HotKeySize		= {	order = 64,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 5, max = 20, step = 1,},
					HotKeyColor 	={	order = 66, type = "color",		name = function(i) return tr(i[#i]) end,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
				},
			},

			NamePlates = {
				order = 70,		name = L["NamePlates"], type = "group",
				get = function(info) return db[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {

					enable 		= { width = "full",	order = 1, type = "toggle",	name = L["NPenable"], disabled = false, },

					maxDispance= {	order =  2,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DEFAULT"] .. 40,	min = 30, max = 60, step = 1, width = "full"},

					width 		= {	order = 20,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DEFAULT"] .. 175,	min = 130, max = 250, step = 1,},
					height 		= {	order = 25,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DEFAULT"] .. 14,	min = 10, max = 25, step = 1,},
					iconDSize 	= {	order = 30,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DESC_iconD"],	min = 10, max = 45, step = 1,},
					iconBSize 	= {	order = 31,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DESC_iconB"],	min = 10, max = 45, step = 1,},
					iconDiSize 	= {	order = 35,	type = "range", name = function(i) return tr(i[#i]) end,	desc = L["DESC_iconC"],	min = 10, max = 45, step = 1,},
					iconCastSize= { order = 37,	type = "range", name = function(i) return tr(i[#i]) end, 	desc = L["DEFAULT"] .. 20, min = 10, max = 35, step = 1,},

					dissIcons 	= {	order = 40, type = "select", name = function(i) return tr(i[#i]) end,	values = { ["none"] = L["NONE"], ["all"] = L["DISS_ALL"], ["dispell"] = L["DISS_CLASS"],},},
					buffIcons 	= {	order = 45, type = "select", name = function(i) return tr(i[#i]) end,	values = {["none"] = L["NONE"], ["dispell"] = L["DISS"], ["all"] = L["ALL_BUFF"], ["buff"] = L["ALL_EX_DIS"],},},

					showCastIcon 	= { width = "full",	order = 50, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showCastName 	= { width = "full",	order = 52, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showCastTarget 	= { width = "full",	order = 55, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showPercTreat 	= { width = 1.5,	order = 60, type = "select", 	name = function(i) return tr(i[#i]) end,	values = { ["none"] = L["NONE"], ["scaledPercent"] = L["scaledPercent"], ["rawPercent"] = L["rawPercent"],},},
					showResourses	= { width = "full",	order = 63, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showArrows 		= { width = "full",	order = 65, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					moreDebuffIcons = { width = "full",	order = 66, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					blueDebuff 		= { width = "full",	order = 68, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					tankMode		= { width = "full",	order = 69, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showTauntDebuff = { width = "full",	order = 70, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					classDispell 	= { width = "full",	order = 33, type = "toggle",	name = function(i) return tr(i[#i]) end,},
					glowTarget		= { width = "full",	order =140, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					glowBadType		= {	order = 150, type = "select", name = function(info) return tr( info[#info])  end,	values = { ["none"] = "None", ["pixel"] = "Red Lines", ["button"] = "Button Glow", ["cast"] = "Auto Cast Dots",},},
					badCasts		= { width = "full",	order =150, type = "toggle",	name = function(i) return tr(i[#i]) end, },
					showToolTip 	= {	order = 51, type = "select", name = function(i) return tr(i[#i]) end,	values = { ["none"] =L["NONE"], ["cursor"] = L["UND_CURCOR"], ["yes"] = L["IN_CONNER"],},},

					executePhaze ={ order = 170, type = "toggle",name = function(i) return tr(i[#i]) end, width = "full"	},
					executeProc  ={ order = 180,	type = "range", name = function(i) return tr(i[#i]) end,	min = 0, max = 100, step = 1,},
					executeColor ={	order = 190, type = "color",	name = function(i) return tr(i[#i]) end,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

					desc01 = {	order = 200, type = "description", name = "\n " .. L["DESC_TCOL"] .. "\n ", width = "full",},

					c0 ={	order = 210, type = "color",	name = function(i) return tr(i[#i]) end, width = 1.5,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
					c0t ={	order = 220, type = "color",	name = function(i) return tr(i[#i]) end,	width = 0.5,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

					c1 ={	order = 230, type = "color",	name = function(i) return tr(i[#i]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
					c2 ={	order = 240, type = "color",	name = function(i) return tr(i[#i]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

					c3 ={	order = 250, type = "color",	name = function(i) return tr(i[#i]) end,width = 1.5,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
					c3t ={	order = 260, type = "color",	name = function(i) return tr(i[#i]) end,	width = 0.5,
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

					desc02 = {	order = 270, type = "description", name = "\n " .. L["DESC_ACOL"] .. "\n ", width = "full",},

					myPet ={	order = 280, type = "color",	name = function(i) return tr(i[#i]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
					tankOT ={	order = 290, type = "color",	name = function(i) return tr(i[#i]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
					badGood ={	order = 300, type = "color",	name = function(i) return tr(i[#i]) end,  width = "full",
						get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
				},
			},

			Chat = {
				order = 80,	name = L["Chat"], type = "group",
				get = function(info) return db["Chat"][info[#info]] end,
				set = function(info,val) Setlers( "Chat#" .. info[#info], val) end,
				args = {
					EnableChat 		= {	order = 1,  type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
					BarChat 		= {	order = 10, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
					linkOverMouse 	= {	order = 20, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
					showVoice 		= {	order = 25, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
					showHistory 	= {	order = 30, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},
					showHistoryAll 	= {	order = 32, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full", disabled = function( info) return not db.Chat.showHistory; end,},
					fadingEnable 	= {	order = 36, type = "toggle",	name = function(i) return tr(i[#i]) end,},
					fadingTimer 	= {	order = 38,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 5, max = 100, step = 1, disabled = function( info) return not db[info[1]].fadingEnable; end,},
					wisperSound		= {	order = 40, type = "select", 	name = function(i) return tr(i[#i]) end, dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					wisperInCombat	= {	order = 42, type = "toggle",	name = function(i) return tr(i[#i]) end,},

					chatFontsize = {
						name = function(i) return tr(i[#i]) end,
						order = 2,	type = "range", desc = L["DEFAULT"] .. 10,	min = 10, max = 16, step = 1,
						get = function(info) return db["Chat"][info[#info]] end,
						set = function(info,val) Setlers( "Chat#" .. info[#info], val) end, },

					chatFont 		= {	order = 4, type = "select", 	name = function(i) return tr(i[#i]) end, dialogControl = "LSM30_Font", values = LSM:HashTable("font"),
										get = function(info) for k, val in pairs( LSM:List("font")) do if db["Chat"][info[#info]] == LSM:Fetch("font", val) then return val end end	end,
										set = function(info, val) Setlers( "Chat#" .. info[#info], LSM:Fetch("font", val))	end, },
					wim 			= {	order = 50, type = "toggle",	name = function(i) return tr(i[#i]) end, width = "full",},

					chatBubble		= {	order = 51, type = "select", 	name = function(i) return tr(i[#i]) end, values = {["none"] = L["chBdontchange"], ["remove"] = L["chBremove"], ["skin"] = L["chBchangeS"], ["border"] = L["chBchangeB"]},},
					chatBubbleShadow= {	order = 52, type = "toggle",	name = function(i) return tr(i[#i]) end, disabled = function( info) if db[info[1]].chatBubble == "none" then return true end end,},
					chatBubbleFont	= {	order = 54,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 5, max = 15, step = 1, 	disabled = function( info) if db[info[1]].chatBubble == "none" then return true end end,},
					chatBubbleShift	= {	order = 56,	type = "range", 	name = function(i) return tr(i[#i]) end, min = 0, max = 15, step = 1, disabled = function( info) if db[info[1]].chatBubble == "none" then return true end end,},
				},
			},

			ToolTip = {
				order = 85,	name = L["ToolTip"], type = "group",
				get = function(info) return db["ToolTip"][info[#info]] end,
				set = function(info,val) Setlers( "ToolTip#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 			= {	order = 1, 	type = "toggle",	name = L["TTenable"], width = "full", disabled = false,},
					IDInToolTip 	= {	order = 5,  type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
					ladyMod			= {	order = 15, type = "toggle",name = function(i) return tr(i[#i]) end,width= 1.4},
					ladyModShift	= {	order = 20, type = "toggle",name = function(i) return tr(i[#i]) end, disabled = function( info) return not db[info[1]].enable or not db[info[1]].ladyMod end,},
					showSpells 		= {	order = 25, type = "toggle",name = function(i) return tr(i[#i]) end,width= 1.4},
					showSpellShift 	= {	order = 30, type = "toggle",name = function(i) return tr(i[#i]) end, disabled = function( info) return not db[info[1]].enable or not db[info[1]].showSpells end,},
					showSpellsVert 	= {	order = 35, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full", disabled = function( info) return not db[info[1]].enable or not db[info[1]].showSpells end,},
					showBorder 		= {	order = 40, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
					borderClass		= {	order = 45, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
				},
			},

			InfoTexts = {
				order = 87,	name = L["infoTexts"], type = "group",
				get = function(info) return db["InfoTexts"][info[#info]] end,
				set = function(info,val) Setlers( "InfoTexts#" .. info[#info], val) n.infoTexts:infoLauncher() end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 		= {	order = 01, type = "toggle", name = L["ITenable"], width = "full", disabled = false,},

					countLeft 	= {	order = 10, width = 0.7, type = "select", name = function(i) return tr(i[#i]) end,	values = { [0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6,},},
					set01		= {	order = 11, type = "description", name = " ", width = 1.5},
					left1 		= {	order = 22, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 1 or not db[info[1]].enable; end,},
					left2 		= {	order = 32, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 2 or not db[info[1]].enable; end,},
					left3 		= {	order = 42, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 3 or not db[info[1]].enable; end,},
					left4 		= {	order = 52, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 4 or not db[info[1]].enable; end,},
					left5 		= {	order = 62, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 5 or not db[info[1]].enable; end,},
					left6 		= {	order = 72, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "",	values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countLeft < 6 or not db[info[1]].enable; end,},

					set02		= {	order = 090, type = "description", name = " ", width = "full"},
					countRight 	= {	order = 110, width = 0.7, type = "select", name = function(i) return tr(i[#i]) end, values = { [0] = 0, [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6,},},
					set00		= {	order = 111, type = "description", name = " ", width = 1.5},
					right1		= {	order = 120, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 1 or not db[info[1]].enable; end,},
					right2		= {	order = 130, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 2 or not db[info[1]].enable; end,},
					right3		= {	order = 140, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 3 or not db[info[1]].enable; end,},
					right4		= {	order = 150, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 4 or not db[info[1]].enable; end,},
					right5		= {	order = 160, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 5 or not db[info[1]].enable; end,},
					right6		= {	order = 170, width = 0.7, sorting = n.infoTexts.infosSorted, type = "select", name = "", values = n.infoTexts.texts, disabled = function( info) return db.InfoTexts.countRight < 6 or not db[info[1]].enable; end,},
				},
			},

			fliger = {
				order = 90, name = L["fliger"], type = "group",
				get = function(info) return db[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) n.Addons.fliger:updateAllOption() end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 			= { width = "full",	order = 1, type = "toggle",	name = L["FLGenable"], disabled = false, },
					--desc01			= {	order = 2, type = "description", name = L["DESC_FILGER"], width = "full"},

					buffAnims = {
						order = 2,	name = L["buffAnims"], type = "group",	inline = true,
						args = {
							fligerBuffGlow	= {	order = 02, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
							fligerBuffAnim	= {	order = 03, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
							fligerBuffColr	= {	order = 04, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},
							--fligerShowHint	= {	order = 05, type = "toggle",name = function(i) return tr(i[#i]) end,width = "full",},

							fligerBuffCount	= { order = 06, type = "input", multiline = 7, name = function(i) return tr(i[#i]) end,width = 0.5, desc = L["DESC_ST"],},
							fligerBuffSpell = { order = 07, type = "input", multiline = 7, name = function(i) return tr(i[#i]) end,width = 1.7, desc = L["DESC_BSPELL"],},
							fligerSpell		= { order = 08, type = 'input', name = function(i) return tr(i[#i]) end, 	dialogControl = "Spell_EditBox", width = "full",
										set = function(info,val)
											local fligerBuffSpell = db.fliger.fligerBuffSpell
											local enka = #fligerBuffSpell >= 1 and "\n" or ""

											fligerBuffSpell = fligerBuffSpell .. enka .. val
											Setlers( "fliger#fligerBuffSpell", fligerBuffSpell)
										end, },
						},
					},
--n.Addons.fliger.checkAnimeSpells
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
				get = function(info) return db[info[1]][info[#info]] end,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end,
				disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					enable 	= { width = "full",	order = 1, type = "toggle",	name = L["CTAenable"], disabled = false, },

					set00	= {	order = 02, type = "description", name = " ", width = "full"},
					readRole= {	order = 03, type = "description", name = L["readRole"], width = "full"},
					nRole	= {	order = 09, type = "toggle",name = L["nRole"],	width = 0.85, desc = L["DESC_NROLE"],},
					tRole	= {	order = 10, type = "toggle",name = L["tank"],	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].nRole); end,},
					hRole 	= {	order = 12, type = "toggle",name = L["heal"],	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].nRole); end,},
					dRole	= {	order = 14, type = "toggle",name = L["dd"], 	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].nRole); end,},

					set01	= {	order = 20, type = "description", name = " ", width = "full"},
					setRole	= {	order = 21, type = "description", name = L["DESC_SETN"], width = "full"},
					setN	= {	order = 22, type = "toggle",name = L["setN"],	width = 0.85},
					setT	= {	order = 24, type = "toggle",name = L["tank"],	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].setN); end,},
					setH 	= {	order = 26, type = "toggle",name = L["heal"],	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].setN); end,},
					setD	= {	order = 28, type = "toggle",name = L["dd"], 	width = 0.5, disabled = function( info) return ( not db[info[1]].enable or db[info[1]].setN); end,},

					set02	= {	order = 29, type = "description", name = " ", width = "full"},
					--heroic	= {	order = 30, type = "toggle",name = L["heroic"], 	width = 1},
					lfdMode = {	order = 30, type = "select", name = function(i) return tr(i[#i]) end,	values = n.dungensTypes,},
					lfr		= {	order = 32, type = "toggle",name = L["lfr"], 	width = 1},


					timer	= {	order = 40,	type = "range", name = L["CTAtimer"],	min = 1, max = 600, step = 1, width = 1},
					sound	= {	order = 42, type = "select",name = L["CTAsound"], dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"),},
					expand	= {	order = 44, type = "toggle",name = L["expand"],},
					nosound	= {	order = 45, type = "toggle",name = L["CTAnosound"],},
					hideLast= {	order = 47, type = "toggle",name = L["hideLast"], width = "full"},

					launch 	= {	order = 99, type = "execute",name = L["CTAlaunch"], disabled = function( info) return ( not db[info[1]].enable or not db[info[1]].hide); end,
						func = function() db.CTA.hide = false resetCTAtimer() end,},
				},
			},

			healBotka = {
				type = 'group', name = L["healBotka"], childGroups = 'tab', order = 95,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end,
				get = function(info)  return db[info[1]][info[#info]] end,
				--dprint( "!!!!!!!!!", db[info[1]][info[#info]], n.spellsBooks[db[info[1]][info[#info]]])
				--disabled = function( info) if #info > 1 then return not db[info[1]].enable; end end,
				args = {
					funcEnable = {
           				order = 1, type = "execute", confirm  = true, width = 1.2,	name = L["funcEnable"], desc = L["DESC_HBOT_ENA"],
           				func = function() Setlers( "healBotka#enable", true) Setlers( "healBotka#hEnable", true) Setlers( "Raid#raidTemplate", 3) ReloadUI() end,},
					funcDisable = {
           				order = 2, type = "execute", confirm  = true, width = 1.2,	name = L["funcDisable"], desc = L["DESC_HBOT_DIS"],
           				func = function() Setlers( "healBotka#enable", false) Setlers( "healBotka#hEnable", false) Setlers( "Raid#raidTemplate", 1) ReloadUI() end,},

					keneral = {
						order = 1, type = 'group', name = L["keneral"],
						disabled = function( info) if info[3] ~= "enable" and info.type ~= "group" then return not db[info[1]].enable; end end,
						args = {
							enable 	= { width = "full",	order = 0, type = "toggle",	name = L["kEnable"], desc = L["DESC_HENA"], disabled = false, },

							set00	= {	order = 08, type = "description", 	name = L["healset00"], 	width = 1.2,},
							set01	= {	order = 09, type = "description", 	name = L["healset01"],  width = 1,},

							targ01	= {	order = 01, type = "keybinding",	name = L["healtarg01"], width = 0.8, desc = L["DESC_KEY"],},
							menu01	= {	order = 02, type = "keybinding",	name = L["healmenu01"], width = 0.8, desc = L["DESC_KEY"],},
							res01	= {	order = 03, type = "keybinding",	name = L["healres01"],  width = 0.8, desc = L["DESC_KEY"],},

							key1	= {	order = 10, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key2	= {	order = 20, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key3	= {	order = 30, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key4	= {	order = 40, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key5	= {	order = 50, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key6	= {	order = 60, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key7	= {	order = 70, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key8	= {	order = 80, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key9	= {	order = 90, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key10	= {	order =100, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key11	= {	order =110, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},
							key12	= {	order =120, type = "keybinding",	name = "", width = 0.9, desc = L["DESC_KEY"],},

							spell1 	= { order = 12, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell2 	= { order = 22, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell3 	= { order = 32, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell4 	= { order = 42, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell5 	= { order = 51, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell6 	= { order = 62, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell7 	= { order = 72, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell8 	= { order = 82, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell9	= { order = 92, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell10	= { order =102, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell11	= { order =112, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},
							spell12	= { order =122, name = "", dialogControl = "Spell_EditBox", type = 'input',width = 1.3,},

							bTrink1	= {	order = 14, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink2	= {	order = 24, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink3	= {	order = 34, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink4	= {	order = 44, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink5	= {	order = 54, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink6	= {	order = 64, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink7	= {	order = 74, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink8	= {	order = 84, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink9 = {	order = 94, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink10= {	order =104, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink11= {	order =114, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},
							bTrink12= {	order =124, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_TRINK"]},

							bStop1	= {	order = 16, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop2	= {	order = 26, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop3	= {	order = 36, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop4	= {	order = 46, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop5	= {	order = 56, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop6	= {	order = 66, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop7	= {	order = 76, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop8	= {	order = 86, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop9	= {	order = 96, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop10 = {	order =106, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop11 = {	order =116, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
							bStop12 = {	order =126, type = "toggle",	name = " ", width = 0.1, desc = L["DESC_STOP"]},
						},
					},
					heneral = {
						order = 2, type = 'group', name = L["heneral"],
						disabled = function( info) if info[3] ~= "hEnable" and info.type ~= "group" then return not db[info[1]].hEnable; end end,
						args = {
							hEnable= {	order = 1, type = "toggle",name = function(i) return tr(i[#i]) end, width = "full", desc = L["DESC_HENA"],},

							hSpell1	= { order = 10, name = L["hSpell1"], 	dialogControl = "Spell_EditBox", type = 'input',width = 1.7,},
							hSpell2	= { order = 20, name = L["hSpell2"], 	dialogControl = "Spell_EditBox", type = 'input',width = 1.7},
							hSpell3 = { order = 30, name = L["hSpell3"], 	dialogControl = "Spell_EditBox", type = 'input',width = 1.7,},
							hSpell4	= { order = 40, name = L["hSpell4"], 	dialogControl = "Spell_EditBox", type = 'input',width = 1.7,},
							hSpell5	= { order = 50, name = L["hSpell5"], 	dialogControl = "Spell_EditBox", type = 'input',width = 1.7,},

							hColEna1= {	order = 12, type = "toggle",name = L["hColEnable"],},
							hColEna2= {	order = 22, type = "toggle",name = L["hColEnable"],},
							hColEna3= {	order = 33, type = "toggle",name = L["hColEnable"],},
							hColEna4= {	order = 42, type = "toggle",name = L["hColEnable"],},
							hColEna5= {	order = 52, type = "toggle",name = L["hColEnable"],},

							hColor1 ={	order = 14, type = "color",	name =  "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							hColor2 ={	order = 24, type = "color",	name = "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							hColor3 ={	order = 34, type = "color",	name = "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							hColor4 ={	order = 44, type = "color",	name = "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							hColor5 ={	order = 54, type = "color",	name = "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

							hScale1	= {	order = 16,	type = "range", name = L["hScale"],	min = 0, max = 2, step = 0.1, width = 0.7},
							hScale2	= {	order = 26,	type = "range", name = L["hScale"],	min = 0, max = 2, step = 0.1, width = 0.7},
							hScale3	= {	order = 36,	type = "range", name = L["hScale"],	min = 0, max = 2, step = 0.1, width = 0.7},
							hScale4 = {	order = 46, type = "range", name = L["hScale"],	min = 0, max = 2, step = 0.1, width = 0.7},
							hScale5 = {	order = 56, type = "range", name = L["hScale"],	min = 0, max = 2, step = 0.1, width = 0.7},

							hTimEna1= {	order = 18, type = "toggle",name = L["hideTimer"],},
							hTimEna2= {	order = 28, type = "toggle",name = L["hideTimer"],},
							hTimEna3= {	order = 38, type = "toggle",name = L["hideTimer"],},
							hTimEna4= {	order = 48, type = "toggle",name = L["hideTimer"],},
							hTimEna5= {	order = 58, type = "toggle",name = L["hideTimer"],},
--hScale2
							hTimer1	= {	order = 19,	type = "range", name = "",	min = 0, max = 20, step = 0.1, width = 0.5},
							hTimer2	= {	order = 29,	type = "range", name = "",	min = 0, max = 20, step = 0.1, width = 0.5},
							hTimer3	= {	order = 39,	type = "range", name = "",	min = 0, max = 20, step = 0.1, width = 0.5},
							hTimer4	= {	order = 49, type = "range", name = "",	min = 0, max = 20, step = 0.1, width = 0.5},
							hTimer5 = {	order = 59, type = "range", name = "",	min = 0, max = 20, step = 0.1, width = 0.5},

							--AutoQuesting = {
							--	order = 30,	name = L["AutoQuesting"], type = "group",	inline = true,
							--	args = {
							--		AutoQuest = {		order = 10, type = "toggle",	name = function(i) return tr(i[#i]) end, 	desc = L["QUACP_DESC"],},
							--	},
							--},
						},
					},
				aeneral = {
						order = 3, type = 'group', name = L["aenaral"],
						args = {
							raidTemplate	= {	order = 02, type = "select", name = function(i) return tr(i[#i]) end,	values = {[1] = "Normal", [2] = "Simple", [3] = "HealBotka",},
								get = function(info) return db.Raid.raidTemplate end, set = function(info,val) Setlers( "Raid#" .. info[#info], val) end, desc = L["DESC_RTEMPL"],},
							set00	= {	order = 10,type = "description", name = " ", width = "full"},

							hSize 	= {	order = 05,type = "range", name = function(i) return tr(i[#i]) end,	min = 5,  max = 25,  step = 1, },
							hTempW	= {	order = 20,type = "range", name = function(i) return tr(i[#i]) end,	min = 50, max = 150, step = 1, },
							hTempH	= {	order = 22,type = "range", name = function(i) return tr(i[#i]) end,	min = 20, max = 100, step = 1, },

							hRedTime= {	order = 25,type = "range", name = function(i) return tr(i[#i]) end,	min = 0,  max = 10,  step = 0.1,},
							set01	= {	order = 26,type = "description", name = " ", width = "full"},

							hDefCol = {	order = 30,type = "color", name = function(i) return tr(i[#i]) end, 	--width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							hRedCol = {	order = 32,type = "color", name = function(i) return tr(i[#i]) end, 	--width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},

							hTimeSec= {	order = 35,type = "toggle", name = function(i) return tr(i[#i]) end, width = "full"},

							--bSpell 	= { order = 40, type = "select",name = function(i) return tr(i[#i]) end, width = 1.5, values = n.spellsBooks,},
							bSpell	= { order = 40, name = function(i) return tr(i[#i]) end, dialogControl = "Spell_EditBox", type = 'input',width = 2,},
							bColEna = {	order = 43, type = "toggle",name = function(i) return tr(i[#i]) end,},
							bColor	 ={	order = 45, type = "color",	name = "", width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							bShiftY = {	order = 47,type = "range", name = function(i) return tr(i[#i]) end,	min = -50,  max = 10,  step = 1,},

							borderC = {	order = 49,type = "color", name = function(i) return tr(i[#i]) end, 	--width = 0.2,
								get = function(info, r, g, b)  return strsplit( ",", db[info[1]][info[#info]])	end,
								set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},
							borderS = {	order = 50,type = "toggle", name = function(i) return tr(i[#i]) end,},

							hpBarVertical 	= {	order = 62, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
							hpBarRevers	 	= {	order = 65, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
							takeTarget 		= {	order = 69, type = "toggle", name = function(i) return tr(i[#i]) end, width = "full",},
						},
					},
				},
			--}
			},


			whatsN = {
				order = 999, name = "Whats нового", type = "group",
				args = {
					label14 = { order = 985, type = "description", name = "|cff00ff002021.02.18|r"
						.."\n - [|cffff8000Общее|r] жалкие попытки перевести это все на буржуинский язык, предполагается, что теперь это все уж точно поломается и вы перестанете этим пользоваться."
						.."\n - [|cffff8000Общее|r] для теста, если вы задрот или лакер и у вас есть маунт для утробы из коридоров, то можно создать МАКРОС типа: \n\n#showtooltip Скакун Всадника без головы \n/script yoFrame:mawMount( 344578)\n\n это типа, если вы утробе, то будет вызываться 'Корридорный ужас', а если нет, то тот маунт, spellID которого вы указали в скобочках '( 34458)'. В #showtooltip пишете название этого маунта ручками, попозже сделаю наверно настройки для этой беды. Можно скопировать и этот макрос, если вы не против Скакуна от безголового. хехе, глянул как это выглядит в игре и понял, что отседова нельзя скопировать текст... подстава :)"
						.."\n - [|cffff8000Акшнбары|r] Хоткеи показываются в укороченном, и как следствие, более понятном виде, и даже если их двое хоткеев... два хоткея... в общем все показываются хоткеи ( бля)."
						.."\n - [|cffff8000Акшнбары|r] В тултипе отображаются собсна эти все оба-два хоткея и название макроса, если в кнопку вставлен макрос. Давно хотел, но боялся это сделать, ога"
						.."\n - [|cffff8000Сумки|r] При наведении на предмет, также показывается наличие его и в гильдбаньке, если ваши жадные камрады это туда подложили, что, конечно же, сильно вряд ли... прям беда. Для более обьективной картины жлобства ваших сотоварищей, надо периодически просматривать все странички ГБ, что бы не пропустить и быть в курсе того, кто и что туда наложил."
						.."\n - [|cffff8000Рейдфреймы|r] Отдельно стоит отметить тот факт, что я героически подвинул иконки дебафов на танках на 2 ( ДВА) пикселя вверх!!! Вот не каждый сможет набраться такой смелости и сделать такое. Мамкин герой!"
						.."\n - [|cffff8000Аддон|r] Двигалка для центрально-верхнего виджета, который отображается в Утробе. Утром включить, а вечером - двигать.\n\n"
					},
					label13 = { order = 986, type = "description", name = "|cff00ff002021.02.07|r"
						.."\n - [|cffff8000ЛФГ|r] Добавилась фильтрация 'меньше или равно'"
						.."\n - [|cffff8000Аддон|r] Настройка хранения расположения элементов аддона персонально или в общем конфиге"
						.."\n - [|cffff8000Профили|r] Если вы по какому-то недоразумению используете профили, то скорее всего, при смене спека буду ошибки... работаем... да..."
						.."\n - [|cffff8000Аддон|r] КД-шки ковенантовские переехали в отдельный блок ( отключается в настройках Аддон). Все еще бесполезная шляпа...\n\n"
					},
					label12 = { order = 987, type = "description", name = "|cff00ff002021.01.29|r"
						.."\n - [|cffff8000ЛФГ|r] Добавилась фильтрация по активности в окне поиска рейдов/групп/заданий/торгастов"
						.."\n - [|cffff8000Автоквест|r] Автосдавание квеста  стало понимать, что ему впаривают валюту ( репутационные какие-то жетоны), а не вещь и не пытается ее больше забрать"
						.."\n - [|cffff8000Кулдауны|r] Временно к сбивалкам кастов прибавились ковенантовские абилки, пока для теста..."
						.."\n - [|cffff8000Персонаж|r] В окне персонажа - в 'райтклик по шмотке' добались вещи из рейдов ( галочка сверху-справа)\n\n"
					},
					label11 = { order = 988, type = "description", name = "|cff00ff002021.01.20|r"
						.."\n - [|cffff8000Инфотекст|r] Добавилась настройка звука\n\n"
					},
					label10 = { order = 989,  type = "description", name = "|cff00ff002021.01.15|r"
						.."\n - [|cffff8000Торгаст|r] Панелька для прикупленных у местных барыг юзабельных всяких шняжек, что бы не забывал их тыкать и было хорошооооо..."
						.."\n - [|cffff8000Торгаст|r] Из ДБМа ловко подрезал список опасных кастов торгаст-мобов и немедленно их добавил в сюда, заябись же?"
						.."\n - [|cffff8000Торгаст|r] Если ты мажор и купил себе сферу за 250, то теперь, словной твой Нео, можешь видеть какие пепеги получишь с мобов, если потыкаешь в них своей этой сферкой."
						.."\n - [|cffff8000Общее|r] В Близовском окошке 'Эпихальный ключ' ( кнопка I), центральная штука ( голубая дырка, ага) теперь тыкательная и открывает поглядеть элемент интерфейса 'Еженедельные награды для любимого мамкиного героя'"
						.."\n - [|cffff8000Общее|r] Для любителей получать ачивки и прочей приятной хрени есть команда /tach, оно хоть вначале и выдает ошибки, но все равно весело. Можно тыкать много раз и все равно не надоедает... главно не забывать прерываться на покушать."
						.."\n - [|cffff8000Общее|r] Для наших любителей поточнее, есть команда /align, хрен знает зачем она нужна на самом-то деле, но наверно можно ее совместить с /move... вай нот, кто я такой, что бы запрещать вам творить подобную дичь."
						.."\n - [|cffff8000Аддон|r] Для особо одаренных работяг, точнее, в данном случае, совсем не одаренных, добавил изменение пиксельного шрифта, ну и, что бы дважды не вставать, то и для основного тоже шрифта тоже... прогнулся :(\n\n",
					},
					label09 = { order = 990, type = "description", name = "|cff00ff002021.01.13|r"
						.."\n - [|cffff8000Задания|r] Говорящая голова обзавелась новыми настройками"
						.."\n - [|cffff8000Общее|r] В М+ в тултипе показываются проценты мобов"
						.."\n - [|cffff8000Филгер|r] Слегка допилена фигня с выделением бафов/дебафов, описание в подсказках к элементам\n\n",
					},
					label08 = { order = 991, type = "description", name = "|cff00ff002020.11.23|r"
						.."\n - [|cffff8000Общее|r] в настройках биндов клавиш добались комбинации для установки рейдовых меток не беря жертву в цель, а просто при наведении на нее курсора ( MouseOver)"
						.."\n - [|cffff8000Рейд|r] добавился метод сортировки рейда по цветовой гамме - \"Пихора эдишн\", пользы от него никакой ( как и от тебя, кстати), но зато красиво, особенно в 40 ппл рейде."
						.."\n - [|cffff8000Хилботка|r] свершилось, то, о чем так долго говорили большевики - накодилось! Встречаем ноавый рассадник багов, глюков и моей жопоболи... Состоит эта пепега из трех частей: бинды, хотасы и шаблон рейда."
						.."\n 1. Бинды надо что бы ты такой по кому-нить в рейде тыкаешь, сразу лечить этого бедолагу начиаешь. Не забываем, что, при включении всего этого ужаса, действия `Взять в цель` и `Показать меню` автоматически переползут на Ctrl+ЛКМ и Ctrl+ПКМ, что бы освободишь мышку под всякое другое, несомненно более полезное."
						.."\n 2. Хотасы, там вроде все понятно дожно быть, одно скажу, что , лично мне, удобней заменять иконки хоток на тупые и незамысловатые квадратики разного цвета, проям как в детсаду оказался, мне норм."
						.."\n 3. ХилБотка, это шаблон рейда, из которого убрано всякое лишнее и не нужно для реального хардкор-хила. Рост потенциальных больных идет по горизонтали, а не вертикально, это пока так, потом будем посмотреть как лучше."
						.."\n - [|cffff8000Хилботка|r] одельно хочу отметить пацана с именем `ХотаБар` ( не путать с Алахакбар, нет, это не про это), это палка, которая пытается изображать из себя хотку, лично я вешаю на нее Жизнецвет, видно сразу, удобно, понятно. Так же, я, при всей своей гениатности, не смог определиться, где лучше найти место под это, но зато тама можно ее подвигать вверх-вниз-вверх-вниз-вверх..., пока не станет приятно и хорошо ( настроил, покурил, оттвернулся, захрапел)"
						.."\n - [|cffff8000Хилботка|r] в соответствующем разделе вверху есть 2 кнопки, сцуть которых такая, что мы сначало все включаем, настраиваем под себя, а затем просто ими уже включаем/выключаем это шнягу целиком ( я про Хилботку) по мере нужды, большшойй или малой, само собой..."
						.."\n - [|cffff8000Хилботка|r] для Друидов и Паладосов есть маленький бонус: в верхем левом углу автоматически загорается иконка, что с цели можно снять Быстрое восстановление или на болезном есть уже заботливо наложенная частица Светы или Веры"
						.."\n - [|cffff8000Хилботка|r] в догонку плюнуть в спину: не обязательно всключать все, если оно не надо, например можно включить только Бинды, 'вернуть назад' на ПКМ-ЛКМ Таргет-Меню и забиндить какую-то свою ущербную абилку на кнопку мышки или клавы, не включая Хотки и Хилботку. Кто я такой, что бы вам запретить такое вытворять с этим убогим аддоном?"
						.."\n - [|cffff8000Хилботка|r] и да, самое же почти главное в этой пепеге - включить |cffff0000`Персональные настройки`|r. Вдудь мужиком - сделай это прям сейчас. А?А?А?А?А?А!!!\n\n",
					},
					label07 = { order = 992, type = "description", name = "|cff00ff002020.11.12|r"
						.."\n - [|cffff8000WIM|r] научился принимать линки на предметы, квесты и прочее, это победа ящитаю"
						.."\n - [|cffff8000Общее|r] коварно пролез в опции игры - Настройка клавиш, стало чутка удобней жить."
						.."\n - [|cffff8000Сумки|r] в меню сумок вернулся рюкзак/backpack и добавился пункт меню 'пропускать сортировку сумки'\n\n",
					},
					label06 = { order = 993, type = "description", name = "|cff00ff002020.11.07|r"
						.."\n - [|cffff8000Инфотексты|r] почти полностью почти всё почти переписал почти заново... местами стало даже лучше"
						.."\n - [|cffff8000Инфотексты|r] для особо упоротых написал инфотексты DPS und HPS ( Details MUST DIE!)"
						.."\n - [|cffff8000Инфотексты|r] они обзавелись персональным настройками, но там творится какая-то дикая дичь"
						.."\n - [|cffff8000Автоквесты|r] о, теперь при автопринятии квеста, если в чатике над ним мышкой поелозить, то показывается ихняя инфа о квесте\n\n",
					},
					label05 = { order = 994, type = "description", name = "|cff00ff002020.11.01|r"
						.."\n - [|cffff8000Ситема|r] Олдам, которые скучали по командам /move (+reset), /db и /cfg, починил их взад "
						.."\n - [|cffff8000Тултипсы|r] Царские рамочки, иконки спеков, таланты, море информации и прочие пепеги для тултипов в тематических настройках этого богом забытого аддона\n\n",
					},
					label04 = { order = 995, type = "description", name = "|cff00ff002020.10.29|r"
						.."\n - [|cffff8000Рейдфреймы|r] добавил МТТТ ( МэйнТанкТаргетТаргет), он не берется в цель, но зачем-то кому-то он может быть нужен ( отключаемо в настройках)"
						.."\n - [|cffff8000Рейдфреймы|r] танки наконец-то растут вверх... Просто заябись!"
						.."\n - [|cffff8000Рейдфреймы|r] на фрейме МТ показываются число набранного им аго и егойные проценты ( настройки присутствуют в Рейдфремах)\n\n",
					},
					label03 = { order = 996, type = "description", name = "|cff00ff002020.10.26|r"
						.."\n - [|cffff8000Юнитфреймы|r] разблокировалась настройка SimpleTemplate. Тестируем, ловим баги"
						.."\n - [|cffff8000Юнитфреймы|r] возможность не показывать шардо-холиповер-комбо бар на фрейме игрока"
						.."\n - [|cffff8000Система|r] проверка версии аддона на устаревание и бесполезность..."
						.."\n - [|cffff8000Кастосбивалка|r] при более 5 баров с КД-шками на касты показываются только 3 первых и 2 последних"
						.."\n - [|cffff8000LFG|r] настройки фильтра поиска групп по его членам и их размерам"
						.."\n - [|cffff8000LFG|r] в тултипе над группой показываются все ихние члены\n\n",
					},
					label02 = { order = 997, type = "description", name = "|cff00ff002020.10.22|r"
						.."\n - [|cffff8000Рейдфреймы|r] опция осветления/затемнения цвета абсорббара ( меньше 1 темнее, больше - светлее)"
						.."\n - [|cffff8000Рейдфреймы|r] убрал абсорббар, оставил только на танкофреймах, плеере и таргете"
						.."\n - [|cffff8000Юнитфреймы|r] показывать хайлайтом дебафы на юнитах\n\n",
					},
					label01 = { order = 998, type = "description",
						name = "|cff999999Просто попробовал придумать какую-то херню, куда можно зачем-то что-то писать, хотя это никому вообще нахер не нужно. Буду пытаться писать сюда об новом, добавленном функционале...\n|r"
						.."\n|cff00ff002020.10.19|r |cff999999( с этим мы пришли с ПТРа после 2х лет застоя)|r"
						.."\n - [|cffff8000Система|r] две осветленные версии текстурки Smooth ( ну вот нравится она мне)"
						.."\n - [|cffff8000Юнитфреймы|r] ГКДшка над фреймом игрока"
						.."\n - [|cffff8000Юнитфреймы|r] в тултипе таргета, при наведении на баф маунта, показывает информацию о его доступности у вас и способ его получения"
						.."\n - [|cffff8000Рейдфреймы|r] ползунок для затемнения/осветления классовых цветов на фреймах"
						.."\n - [|cffff8000Рейдфреймы|r] Средняя кнопка мыши по игроку = массрес/баттрес/просторес ( лок - налаживает свой камень)"
						.."\n - [|cffff8000Неймплайты|r] показывать таунты от других игроков"
						.."\n - [|cffff8000Неймплайты|r] тестируем заготовку под \"плохие касты\""
						.."\n - [|cffff8000Чат|r] сохранение истории введеных команд"
						.."\n - [|cffff8000Чат|r] сохранение истории гильд/пати/рейд чата и остальных каналов"
						.."\n - [|cffff8000Задания|r] показывать ежедневные квесты, которые выдаются при входе в игру"
						.."\n - [|cffff8000Автоматизация|r] галочка для `Скрина при получени нового уровня`"
						.."\n - [|cffff8000Сумки|r] галочка настройки сортировки и заполенния сумок ( сверху-вниз или наоборот)"
						.."\n - [|cffff8000Персонаж|r] в окне персонажа, правой кнопкой по надетой вещи показывает возможный лут из подземелий на текущий спек, в правом верхнем углу есть настройки фильтра шмота, если понять как оно работает, то очень полезная штука."
						.."\n - [|cffff8000Кастбары|r] |cff00ff00Время окна очереди заклинания.|r Промежуток времени в конце текущего каста, в течении которого, использованное заклинание встанет в очередь на выполнение, автоматически по окончании каста без задержки по времени. Отображается красной зоной на кастбаре игрока ( не путать с лагометром, которого больше нет! Нет, красное это не лагометр.). Рекомендуется значение 200-250, но если плохо с реакцией на прожание каста в этот период, то задайте больше времени, но не больше 500, это уже вообще какой-то зашквар получится.",
					},
					label00 = { order = 999, type = "description", name = "\n|cff999999ТуДушка:"
						.."\n - wim"
						.."\n - ошибка модификации..."
						.."\n - оповещалки всякого"
						.."\n - опасные касты"
						.."\n - потатос"
						.."\n - хилботка"
						.."\n - нужен еще один тпринт"
						.."\n - что там с СТА..."
					,},
				},
			},

			ResetConfig = {
           		order = 1, type = "execute", confirm  = true, width = 0.95,	name = L["ResetConfig"], desc = L["RESET_DESC"],
           		func = function() yo_PersonalConfig = {} yo_AllConfig = {} yo_BB = {}  yo_BBCount = {} yo_WIMSTER = {} yo_ChatHistory = {} n.allData = {} ReloadUI() end,},

			MovingFrames = {
           		order = 10,	type = "execute", width = 0.95, name = function()  if n.moveUnlockState ~= true then  return L["MOVE"] else return L["DONTMOVE"] end end,
           		func = function() if n.moveUnlockState ~= true then n.moveAnchorsUnlock() else n.moveAnchorsLock() end end,},

			ResetPosition = {
           		order = 20,	type = "execute", confirm  = true, width = 0.95,	name = L["ResetPosition"], desc = L["RESETUI_DESC"], func = function() n.moveAnchorsReset() end,},

			--KeyBind = {
   --        		order = 30,	type = "execute", width = 0.7, name = "Key Binding", disabled = true,
   --        		func = function() 	SlashCmdList.MOUSEOVERBIND() end,},

			ReloadConfig = {
           		order = -1, type = "execute", width = 0.95, name = L["ReloadConfig"], desc = L["RELOAD_DESC"], disabled = function() return not needReload end, func = function() if needReload then ReloadUI() end	 end,},

			NextOptions = {
				name = "Следующие настройки",
				type = "group",
				order = 20,
				hidden = true,
				args = {	},
			},
		};
	};

	options.args.profiles = ADBO:GetOptionsTable( AB.db)
	LDS:EnhanceOptions( options.args.profiles, AB.db)
	N.options = options

	if n.myDev[n.myName] then
		AO:alertOptions( options)
	end

	return options
end

function ns.InitOptions()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);

	if not ACD then
		AC:RegisterOptionsTable("yoFrame", InitOptions())

		ACD = _G.LibStub("AceConfigDialog-3.0")
		ACD:SetDefaultSize( "yoFrame", 700, 620)
		ACD:AddToBlizOptions( "yoFrame", "yoFrame")--, parent, ...)
		--conf.ACD = ACD
		--tprint(ACD)
	end

	if not ACD.OpenFrames.yoFrame then
		ACD:Open( "yoFrame")
	else
		ACD:Close( "yoFrame")
	end
end

function AB:OnInitialize()
	--print("INIT")
	if not yoFrameDB then
		yoFrameDB = {}
		yoFrameDB.profiles = {}
	end

	local defaults = {}
	defaults.profile = {}
	defaults.profile = CopyTable( defConfig.constants)

	for profName, profData in pairs( defConfig.profiles) do
		yoFrameDB.profiles[profName] = profData
	end

	--_G.yo_AllData.personalProfiles
	--ACD:AddToBlizOptions( addonName, addonName)
	self.db = ADB:New( "yoFrameDB", defaults, not _G.yo_AllData.personalProfiles)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self.db.defaultProfile = defaults.profile
	LDS:EnhanceDatabase( self.db, "yoFrameDB")

	db = self.db.profile

	ns[2] = db
	yoCon = ns[2]
	--yo = ns[2]

	--LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable( addonName, options)
	local GameMenuButton = CreateFrame("Button", "GameMenuButtonQulightUI", GameMenuFrame, "GameMenuButtonTemplate")
	GameMenuButton:SetText("|cff00ffffyoFrame|r")
	GameMenuButton:SetPoint("TOP", "GameMenuButtonAddons", "BOTTOM", 0, -1)

	GameMenuFrame:HookScript("OnShow", function()
		GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButton:GetHeight())
		GameMenuButtonLogout:SetPoint("TOP", GameMenuButton, "BOTTOM", 0, -16)
	end)

	GameMenuButton:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		ns.InitOptions()
	end)

	SlashCmdList["CFGSLASH"] = function() ns.InitOptions() end
	SLASH_CFGSLASH1 = "/cfg"
	SLASH_CFGSLASH2 = "/config"
end

function AB:OnEnable()
	--print("ENABLE")
	N.myName   	= UnitName( "player")
	N.myRealm  	= GetRealmName()
	N.myClass  	= select( 2, UnitClass( "player"))
	N.myColor  	= RAID_CLASS_COLORS[N.myClass]

	--yo = _G.yoFrame[2]  ----!!!!!
	n  = _G.yoFrame[3]
	-- копируем натсройки в текущий профиль
	if n.allData and n.allData.configData and n.allData.configData[N.myRealm] and n.allData.configData[N.myRealm][N.myName] then
		yoFrameDB.profiles[N.myName .. " ( старенький)"] = n.allData.configData[N.myRealm][N.myName]
	end
end

function AB:OnDisable()
	-- Remove all the pins
end

function AB:OnProfileChanged(event, database, newProfileKey)
	--print("CHANGE ", event, database, newProfileKey)

	if event == "OnProfileCopied" then
		--print("COPY")
		needReload = true
		--wipe( self.db.profile)
		--self.db.profile = n:CopyTable( self.db.profile, self.db.defaultProfile)
		--self.db.profile = n:CopyTable( self.db.profile, database.profiles[newProfileKey])

	elseif event == "OnProfileReset" then
		self.db.profile = defConfig.constants

	elseif event == "OnProfileChanged" then

	end

	db 				= self.db.profile
	yoCon 			= self.db.profile
	_G.yoFrame[2] 	= self.db.profile

	--wipe( yo) -- !!!
	--yo = n:CopyTable( yo, db) ---!!!!!


	--yoCon 	= n:CopyTable( self.db.defaultProfile, db)
	--yo 	  	= n:CopyTable( self.db.defaultProfile, db)
	--_G.yoFrame[2] = yo
	--print( event, " db ", db, " yFR ", _G.yoFrame[2], " yo ", yo, " yoCon ", yoCon)
	if event == "OnProfileChanged" then ReloadUI() end

	_G.LibStub("AceConfig-3.0"):RegisterOptionsTable("yoFrame", InitOptions())
end


--n:RegisterModule( AB:GetName())
--[[
	-- Shamelessly taken from AceDB-3.0 and stripped down by Simpy
	function E:CopyDefaults(dest, src)
		for k, v in pairs(src) do
			if type(v) == 'table' then
				if not rawget(dest, k) then rawset(dest, k, {}) end
				if type(dest[k]) == 'table' then E:CopyDefaults(dest[k], v) end
			elseif rawget(dest, k) == nil then
				rawset(dest, k, v)
			end
		end
	end

	function E:RemoveDefaults(db, defaults)
		setmetatable(db, nil)

		for k, v in pairs(defaults) do
			if type(v) == 'table' and type(db[k]) == 'table' then
				E:RemoveDefaults(db[k], v)
				if next(db[k]) == nil then db[k] = nil end
			elseif db[k] == defaults[k] then
				db[k] = nil
			end
		end
	end

	E.serverID = tonumber(serverID)
	]]