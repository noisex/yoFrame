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

local function Setlers( path, val)
	p1, p2, p3, p4 = strsplit("#", path)
		
	local name = UnitName("player")
	local realm = GetRealmName()
	local pers = false
	if yo_AllData[realm][name].PersonalConfig then
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

StaticPopupDialogs["CONFIRM_PERSONAL"] = {
  	text = "Меняем тип настроек?\n(необходимо перегрузить интерфейс)",
  	button1 = "Yes",
  	button2 = "No",
  	OnAccept = function()
  		local name = UnitName("player")
		local realm = GetRealmName()
		yo_AllData[realm][name].PersonalConfig = not yo_AllData[realm][name].PersonalConfig 
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
		name = "yoFrames",
		handler = GottaGoFast,
		type = "group",
		args = {
			System = {
				name = "Системные настройки",
				type = "group",
				order = 10,
				args = {
					PersonalConfig = {
						order = 1, type = "toggle", name = "|cffff0000Персональные настройки (!)|r",	width = "full",
						desc = "|cffffff00(меняет настройки аддона для даннного персонажа с общих для всех на персональные)|r",	descStyle = "inline",
						get = function(info) local name = UnitName("player") local realm = GetRealmName() return yo_AllData[realm][name].PersonalConfig end ,
						set = function(info,val) StaticPopup_Show ("CONFIRM_PERSONAL") end,	},

			        ChangeSystemFonts = {
						order = 10, type = "toggle", name = "Изменить шрифты игры на нормальные",
						desc = "Изменить системные шрифты на нормальные.", width = "full",
						get = function(info) return yo["Addons"][info[#info]] end ,
						set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 	},	
			        sysfontsize = {
						order = 11,	type = "range", name = "Размер системных шрифтов игры",
						desc = "Попробовать изменить размер системного шрифта.\nНа свой страх и риск.\n\nПо-умолчанию: 10",
						min = 10, max = 14, step = 1, width = "full", 
						disabled = function() return not yo["Addons"].ChangeSystemFonts; end,
						get = function(info) return yo["Media"].sysfontsize end ,
						set = function(info,val) Setlers( "Media#sysfontsize", val) ChangeSystemFonts( val) end,},	
			        FontSize = {
						order = 15,	type = "range", name = "Размер шрифтов элементов аддона",
						desc = "Попробовать изменить размер шрифта.\nПо-умолчанию: 10",
						min = 10, max = 14, step = 1, width = "full",
						get = function(info) return yo["Media"].fontsize end ,
						set = function(info,val) Setlers( "Media#fontsize", val) end,},			
					fontsize = {
						order = 17,	type = "range", name = "Размер шрифта чата",
						desc = "По-умолчанию: 10",
						min = 10, max = 16, step = 1, width = "full",
						get = function(info) return yo["Chat"][info[#info]] end ,
						set = function(info,val) Setlers( "Chat#" .. info[#info], val) end, },
					scriptErrors= {
						order = 9, type = "toggle", name = "Показывать ошибки скриптов",
						get = function(info) return yo["General"][info[#info]] end , width = "full",
						set = function(info,val) Setlers( "General#" .. info[#info], val) end,	},
					texture = {
						order = 30,	type = "select",	width = "full",
						--dialogControl = "LSM30_Sound", --values = LSM:HashTable("sound"),
						dialogControl = "LSM30_Statusbar",	name = "Текстура элементов аддона",	values = LSM:HashTable("statusbar"),
						get = function(info) 
							for k, val in pairs( LSM:List("statusbar")) do
								if yo["Media"][info[#info]] == LSM:Fetch("statusbar", val) then return val end
							end	end ,
						set = function(info, val) Setlers( "Media#" .. info[#info], LSM:Fetch("statusbar", val))	end ,},
					
					AutoScale = {	
						order = 40, type = "select", 	name = "Тип скалирования",	
						values = {["none"] = "Без скалирования", ["auto"] = "Автоматическое", ["manual"] = "Ручное управление"},
						get = function(info) return yo.Media.AutoScale end ,
						set = function(info,val) Setlers( "Media#AutoScale", val) end,},
					ScaleRate = {
						order = 42,	type = "range", name = "Кофицент скалирования",
						desc = "По-умолчанию: 0.64", min = 0.6, max = 1.2, step = 0.01, 
						disabled = function() if yo.Media.AutoScale ~= "manual" then return true end end	,
						get = function(info) return yo["Media"][info[#info]] end ,
						set = function(info,val) Setlers( "Media#" .. info[#info], val) 
							SetCVar("useUiScale", 1)	SetCVar("uiScale", val) UIParent:SetScale( val)	end, },
			 	},
			},


			Addons = {
				order = 20,	name = "Дополнения", type = "group",				
				get = function(info) return yo["Addons"][info[#info]] end ,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 
				args = {	
					RaidUtilityPanel ={	order = 1, type = "toggle",	name = "Панель рэйдовых утилит",  width = "full",	desc = "Метки на цели, на полу, пул, готовность и прочее...",},
					Potatos = {			order = 1, type = "toggle",	name = "Потатос",  width = "full",	desc = "Включить модуль для отслеживания использования пота в бою.",},
					IDInToolTip = {		order = 2, type = "toggle", name = "ID предмата, спелла, бафа и прочего в тултипе",  		width = "full",	},
					mythicProcents = {	order = 4, type = "toggle", name = "Показывать проценты мобов в М+ при наведении курсора",  width = "full",	},
					InfoPanels	 = {	order = 5, type = "toggle", name = "Показывать информационные панели внизу экрана", 	 width = "full",	},
					BlackPanels	 = {	order = 6, type = "toggle", name = "Показывать черные панели справа и слева внизу экрана", 	 width = "full",	},
					FlashIconCooldown={ order = 7, type = "toggle", name = "Показывать икноку откатившегося спела в центра экрана",	 width = "full",	},
					ArtifactPowerbar={	order = 8, type = "toggle", name = "Показывать азеритовую палку и палку репутации/опыта",	 width = "full",	},
					unitFrames={		order = 9, type = "toggle", name = "Включить юнитфрймы, а зачем аддон без них?",			 width = "full",	},					
					-- lootbox
					-- cooldowns

					MiniMaps = {
						name = "Настройки миникарты",	type = "group",	order = 30,	inline = true,
						args = {	
							MiniMap = {			order = 1,  type = "toggle",	name = "Редизайн миникарты", 		width = "full"},
							MMColectIcons = {	order = 5,  type = "toggle",	name = "Собирать и убирать иконки с миникарты", width = "full"},
							MiniMapCoord = {	order = 10, type = "toggle",	name = "Координаты на миникарте", 	desc = "Отображать коорднаты игрока на миникате.",},
							MiniMapHideText = {	order = 15, type = "toggle",	name = "Прятать название локации", 	desc = "Показывать название текущейлокации только при наведении мышкой на миникарту.",},
							MMCoordColor = {	order = 20, type = "color",	name = "Цвет текста координат", 	desc = "Цвет текста коорднат игрока на миникате.",
								disabled = function() return not yo.Addons.MiniMapCoord; end,
								get = function(info, r, g, b)  return strsplit( ",", yo.Addons.MMCoordColor)	end,				
								set = function(info, r, g, b) Setlers( "Addons#MMCoordColor", strjoin(",", r, g, b)) end,},
							MMCoordSize = {		order = 25,	type = "range", name = "Размер шрифта", min = 5, max = 16, step = 1, desc = "Размер шрифта текста координат игрока. \nПо-умолчанию: 8",
								disabled = function() return not yo.Addons.MiniMapCoord; end,	},	
					},	},
					--CastWatcher = {
					--	name = "CastWatcher", type = "group", order = 40, inline = true,
					--	get = function(info) return yo["Addons"][info[#info]] end ,
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
				order = 25,	name = "Автоматизация", type = "group",				
				get = function(info) return yo["Addons"][info[#info]] end ,
				set = function(info,val) Setlers( "Addons#" .. info[#info], val) end, 
				args = {
					AutoRepair = { 				order = 1, type = "toggle", name = "Автопочинка у вендора, приоритет у гильдейского", width = "full", },
					AutoSellGrayTrash = {		order = 2, type = "toggle",	name = "Автопродажа мусора", 			desc = "За возможные последствия автор адона ответственность не несет!",},
					AutoScreenOnLvlUpAndAchiv ={order = 3, type = "toggle",	name = "Автоскриншот",					desc = "Включить снятие скриншота при получении нового уровня и ачивки.",},	
					AutoInvaitFromFriends = {	order = 4, type = "toggle",	name = "Принимать приглашение в группу",desc = "Автоматически принимать приглашение в группу от согильдийцев и друзей.",},								

					AutoQuesting = {
						order = 30,	name = "Автоквестинг", type = "group",	inline = true,
						args = {
							AutoQuest = {		order = 10, type = "toggle",	name = "Принимать квесты",	desc = "Автоматически принимать квест.\n\nНажать Shift при контакте с НПС для временного отключения.",},	
							AutoQuestComplete ={order = 11, type = "toggle",	name = "Сдавать квест",		desc = "Автоматически сдавать квест.\n\nНажать Shift при контакте с НПС для временного отключения.",},	
							AutoQuestComplete2Choice = {order = 12, type = "toggle",	name = "Автовыбор наилучшей вещи по iLVL",
								disabled = function() return not yo["Addons"].AutoQuestComplete; end,
								desc = "Автоматически выбирать лучшую вещь, если есть выбор, исходя из большей разницы с надетой на персонаже.\n\nКроме тринек, щитов и одноручного оружия.\n\nНажать Shift при контакте с НПС для временного отключения.",},	
							AutoQuestSkipScene = {order = 14, type = "toggle",	name = "Пропускать видюшки", 	disabled = function() return not yo["Addons"].AutoQuestComplete; end,},		
							ObjectiveHeight = {   order = 20, type = "range", 	name = "Высота списка квестов",	min = 250, max = 650, step = 1, width = "full",	desc = "Изменение высоты окна списка квестов. \nПо-умолчанию: 500",	}, 							
						},
					},
				},
			},

			CastBar = {
				order = 30,	name = "Кастбары", type = "group",				
				args = {	
					BCB = {
						order = 20,	name = "Большой Каст Бар", type = "group",	inline = true,
						get = function(info) return yo[info[1]][info[2]][info[#info]] end ,
						set = function(info,val) Setlers( info[1] .."#".. info[2] .."#".. info[#info], val)	end,
						disabled = function() return not yo["CastBar"]["BCB"].enable; end,
						args = {
							enable = {		order = 1, type = "toggle", 	name = "Включить Большой Кастбар", width = "full", disabled = false, },
							unit = {		order = 2, type = "select", 	name = "Чей касбар", width = "double",	values = {["player"] = "Игрок", ["target"] = "Таргет", ["boss1"] = "Босс (вне боя с босом показывать касты таргета)"},},
							width = {		order = 3,	type = "range", 	name = "Ширина БКБ", min = 150, max = 800, step = 10,},
							height = {		order = 4,	type = "range", 	name = "Высота БКБ",min = 10, max = 40, step = 1,},
							offsetY = {		order = 7,	type = "range", 	name = "Смещение БКБ Y", min = -500, max = 500, step = 1,},
							offsetX = {		order = 6,	type = "range", 	name = "Смещение БКБ X", min = -900, max = 900, step = 1,},
							icon = {		order = 10, type = "toggle",	name = "Иконка",},
							iconSize = {	order = 11,	type = "range", 	name = "Размер иконки",	min = 10, max = 60, step = 1,},
							iconoffsetX = {	order = 12,	type = "range", 	name = "Смещение иконки X",	min = -400, max = 400, step = 1,},
							iconoffsetY = {	order = 13,	type = "range", 	name = "Смещение иконки Y",	min = -70, 	max = 70, step = 1,},				
							iconincombat = {order = 14, type = "toggle",	name = "Показывать иконку в бою", width = "full",},
							classcolor = {	order = 15, type = "toggle",	name = "Кастбар в цвет класса",	desc = "Кастбар в цвет класса или в цвет возможности сбития каста",	width = "full",},
							treatborder = {	order = 16, type = "toggle",	name = "Сбивательный ободок",	desc = "Бордер кастаба в цвет возможности сбить каст",	width = "full",},
							castbarAlpha= {	order = 20,	type = "range", 	name = "Прозрачность кастбара", min = 0, max = 1, step = 0.01,},
						},
					},
					player = {
						order = 30,	name = "Каст Бар Игрока", type = "group",	inline = true,
						get = function(info) return yo[info[1]][info[2]][info[#info]] end ,
						set = function(info,val)    Setlers( info[1] .."#".. info[2] .."#".. info[#info], val) end,
						args = {
							enable = {		order = 1, type = "toggle", name = "Включить кастбар игрока",},
							iconincombat = {order = 14, type = "toggle",	name = "Показывать иконку в бою",	disabled = function() return not yo["CastBar"]["player"].enable; end,},
						},
					},
				},	
			},
		
			Bags = {
				order = 35,	name = "Сумки и банк", type = "group",				
				get = function(info) return yo["Bags"][info[#info]] end ,
				set = function(info,val) Setlers( "Bags#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {
					enable 			= { order = 1, type = "toggle",	name = "Включить модуль", desc = "Включить сумки и банк.", disabled = false, },
					buttonSize 		= { order = 5, type = "range", name = "Размер иконки", min = 20, max = 50, step = 1,	desc = "Размер иконок сумки и банка. \nПо-умолчанию: 32",},
					numMaxRow 		= {	order = 6, type = "range", name = "Количество строк", min = 5, max = 20, step = 1,	desc = "Максимальное количество строк в сумках и банке.\nПо-умолчанию: 16",},
					buttonSpacing 	= {	order = 7,	type = "range", name = "Растояние между иконками.", min = 1, max = 10, step = 1,desc = "Растояние между иконками. \nПо-умолчанию: 7",},
					containerWidth 	= {	order = 8, type = "range", name = "Ширина окна", min = 350, max = 800, step = 1,	desc = "Изменение ширины окна сумки. \nПо-умолчанию: 438",},
					newIconAnimation= { order = 2, type = "toggle",	name = "Анимация на новых предметах", 					desc = "Включить анимацию иконки на новых предметах в сумках.",},	
					},
			},

			Raid = {
				order = 40,	name = "Рэйдфрэймы",type = "group",				
				get = function(info) return yo["Raid"][info[#info]] end ,
				set = function(info,val) Setlers( "Raid#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {	
					enable 			= {	order = 1,  type = "toggle", name = "Включить рэйдфрэймы", width = "full", disabled = false,},					
					classcolor 		= {	order = 10, type = "select", name = "Раскрасить фрейм игрока в:",	values = {[1] = "Цвет класса", [2] = "Цвет здоровья (градиент)", [3] = "В темненькое"},},
					groupingOrder 	= {	order = 15, type = "select", name = "Сортировать:",	values = {["ID"] = "По ID игрока", ["GROUP"] = "По группам", ["TDH"] = "Танк Дамагер Хил", ["THD"] = "Танк Хил Дамагер"},},
					width 			= {	order = 20,	type = "range", name = "Ширина рэйдового",	min = 60, max = 150, step = 1,},
					height 			= {	order = 25,	type = "range", name = "Высота рейдового",	min = 20, max = 80, step = 1,},
					numgroups 		= {	order = 30,	type = "range", name = "Количество колонок (групп)", min = 4, 	max = 8, step = 1,},	
					spaicing 		= {	order = 35,	type = "range", name = "Растояние между фрэймами",	min = 0, 	max = 20, step = 1,},	
					partyScale 		= {	order = 40,	type = "range", name = "Фрейм группы больше в:",	min = 1, 	max = 3, step = .1,},		
					showHPValue 	= {	order = 45, type = "select", name = "Здоровье игрока:",	values = {["[DDG]"] = "Не показывать", ["[per]"] = "Только процент", ["[hp]"] = "ХП | Процент"},},
					--spaicer1 = {		order = 45, type = "description",	name = "",	},
					manacolorClass 	= {	order = 50, type = "toggle", name = "Манабар в цвет класса",},	
					manabar 		= {	order = 55, type = "select", name = "Показывать манабар:",	values = {[1] = "У всех", [2] = "Только у хилов", [3] = "Скрыть"},},		
					hpBarVertical 	= {	order = 60, type = "toggle", name = "Здоровье рисовать вертикально.", width = "full", },		
					hpBarRevers	 	= {	order = 65, type = "toggle", name = "Здоровье рисовать в обратном порядке", width = "full",},	
					showGroupNum 	= {	order = 70, type = "toggle", name = "Показывать номера групп в рейде", width = "full",},	
					showSolo 		= {	order = 75, type = "toggle", name = "Показывать без группы (соло фрейм игрока)", width = "full",},
					showLFD 		= {	order = 80, type = "toggle", name = "Показывать иконку роли игрока", width = "full",},
					noHealFrames 	= {	order = 85, type = "toggle", name = "Не загружать, если есть хиловскои аддоны ( VuhDo, Grid, HealBot...)", width = "full",},
					healPrediction	= {	order = 90, type = "toggle", name = "Показывать входящий хил и абсорб", width = "full",},
					aurasRaid		= {	order = 92, type = "toggle", name = "Показывать иконки дебафов в рейде", width = "full",},
					aurasParty		= {	order = 94, type = "toggle", name = "Показывать иконки дебафов в группе", width = "full",},
					debuffHight		= {	order = 96, type = "toggle", name = "Подсвечивать дебафы на рамках игроков", width = "full",},
					classBackground = {	order = 98, type = "toggle", name = "В темной схеме рисовать подложку в цвет класса", width = "full",},
					},
			},

			ActionBar = {
				order = 50,	name = "Панель кнопок", type = "group",
				get = function(info) return yo["ActionBar"][info[#info]] end ,
				set = function(info,val) Setlers( "ActionBar#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {

					enable = {		order = 1, 	type = "toggle",	name = "Вклюючить экшнбары", width = "full", disabled = false,},
					ShowGrid = {	order = 5, 	type = "toggle",	name = "Всегда показывать кнопки", },
					HideHotKey = {	order = 10,	type = "toggle", 	name = "Не показывать хоткей",	},	
					HideName = {	order = 10,	type = "toggle", 	name = "Не показывать макросы",},	
					CountSize = {	order = 5,	type = "range", 	name = "Размер шрифта стаков", min = 8, max = 16, step = 1,},
					MicroMenu = {	order = 20, type = "toggle", 	name = "Микроменю", },
					MicroScale = {	order = 21,	type = "range", 	name = "Масштаб микроменю", min = 0.5, max = 1.5, step = 0.05,},
				},	
			},		

			Chat = {
				order = 160,	name = "Чат", type = "group",
				get = function(info) return yo["Chat"][info[#info]] end ,
				set = function(info,val) Setlers( "Chat#" .. info[#info], val) end, 
				args = {	
					EnableChat = {		order = 1,  type = "toggle",	name = "Изуродовать чат", width = "full",},
					BarChat = {			order = 10, type = "toggle",	name = "Включить чатбар", width = "full",},
					linkOverMouse = {	order = 20, type = "toggle",	name = "Ссылка на ачив под мышкой", width = "full",},
					showVoice = {		order = 25,  type = "toggle",	name = "Показывать иконки голосового чата", width = "full",},
					showHistory = {		order = 30,  type = "toggle",	name = "Показывать историю чата гильдии и общих каналов", width = "full",},
					--fontsize = {order = 4,	type = "range", name = "Размер шрифта чата", desc = "По-умолчанию: 10",	min = 10, max = 16, step = 1,},
				},	
			},

			NamePlates = {
				order = 70,		name = "Нэймплэйты",	type = "group",				
				get = function(info) return yo[info[1]][info[#info]] end ,
				set = function(info,val) Setlers( info[1] .. "#" .. info[#info], val) end, 
				disabled = function( info) if #info > 1 then return not yo[info[1]].enable; end end,	
				args = {	

					enable = { width = "full",	order = 1, type = "toggle",	name = "Включить нэймплэйты", disabled = false, },
					
					width = { 		order = 20,	type = "range", name = "Ширина фрейма",			desc = "По-умолчанию: 175",	min = 130, max = 250, step = 1,},					
					height = {		order = 25,	type = "range", name = "Высота фрейма",			desc = "По-умолчанию: 14",	min = 10, max = 25, step = 1,},
					iconDSize = {	order = 30,	type = "range", name = "Размер дебафов от игрока",	desc = "Иконки в левой части нэймтлейтов, показывающие отрицательные дебафы, которые наложил игрок или контролящие дебафы на монстре.\n\nПо-умолчанию: 20",	min = 10, max = 45, step = 1,},	
					iconBSize = {	order = 31,	type = "range", name = "Размер правых иконок",	 desc = "Иконки в правой части нэймтлейтов, показывающие положительные бафы на монстре.\n\nПо-умолчанию: 20",	min = 10, max = 45, step = 1,},	
					iconDiSize = {	order = 35,	type = "range", name = "Размер центральных иконок",	 desc = "Иконки в центральной части нэймтлейтов, показывающие положительные бафы на монстре, которые можно сдиспелить.\n\nПо-умолчанию: 30",	min = 10, max = 45, step = 1,},	
					iconCastSize = {order = 37,	type = "range", name = "Размер иконки кастбара", desc = "По-умолчанию: 20", min = 10, max = 35, step = 1,},

					dissIcons = {	order = 40, type = "select", name = "Центральные иконки:",	values = { ["none"] = "Ничего", ["all"] = "Диспельные все", ["dispell"] = "Диспельные по классу",},},
					buffIcons = {	order = 45, type = "select", name = "Правые иконки:",		values = {["none"] = "Ничего", ["dispell"] = "Диспельные", ["all"] = "Все бафы", ["buff"] = "Все, кроме диспельных",},},

					showCastIcon = 	{ width = "full",	order = 50, type = "toggle",	name = "Показывать иконку кастбара", },
					showCastName = 	{ width = "full",	order = 52, type = "toggle",	name = "Показывать название каста", },
					showCastTarget ={ width = "full",	order = 55, type = "toggle",	name = "Показывать имя предполагаемого таргета каста", },
					showPercTreat = { width = "full",	order = 60, type = "toggle",	name = "Показывать проценты агро циферками", },
					showArrows = 	{ width = "full",	order = 65, type = "toggle",	name = "Показывать боковые стрелочки на таргете", },
					blueDebuff = 	{ width = "full",	order = 66, type = "toggle",	name = "Рисовать дебафы от игрока в цвет школы абилки", },
					classDispell = 	{ width = "full",	order = 33, type = "toggle",	name = "Диспельные, толко если твой класс может их сдиспелить ( для правых)",},

					showToolTip = {	order = 50, type = "select", name = "Показывать тултип на бафами:",	values = { ["none"] = "Нет", ["cursor"] = "Под курсором", ["yes"] = "Да, в углу",},},

					executePhaze ={ order = 70, type = "toggle",name = "Изменять цвет на экзекут фазе", width = "full"	},
					executeProc  ={ order = 75,	type = "range", name = "Фаза начинается с %",	min = 0, max = 100, step = 1,},	
					executeColor ={	order = 72, type = "color",	name = "Цвет экзекут фазы", 
						get = function(info, r, g, b)  return strsplit( ",", yo[info[1]][info[#info]])	end,				
						set = function(info, r, g, b) Setlers( info[1] .. "#" .. info[#info], strjoin(",", r, g, b)) end,},				
				},
			},	
				


			ResetConfig = {
           		order = 1, type = "execute", confirm  = true, width = 0.75,	name = "Вернуть как было",
           		desc = "Сброс конфига в дефолтое состояние.\n\nС перезагрузочкой... :)",
           		func = function() yo_PersonalConfig = nil yo_AllConfig = nil ReloadUI() end,},

			MovingFrames = {
           		order = 10,	type = "execute", width = 0.7,
           		name = function()  if t_unlock ~= true then  return "Двигать" else return "Не двигать" end end, 
           		func = function() if t_unlock ~= true then AnchorsUnlock() else AnchorsLock() end end,},

			ResetPosition = {
           		order = 20,	type = "execute", confirm  = true, width = 0.7,  		name = "Сброс позиции", 
           		desc = "Сброс сохраеных координат файмов и возврат к изначальному положению.\n\nС перезагрузочкой... :)",
           		func = function() AnchorsReset() end,},

			KeyBind = {
           		order = 30,	type = "execute", width = 0.7, name = "Key Binding", 
           		func = function() 	SlashCmdList.MOUSEOVERBIND() end,},

			ReloadConfig = {
           		order = -1, type = "execute", width = 0.7, name = "Спаси и сохрани", desc = "\nС перезагрузочкой... :)",
           		disabled = function() return not needReload end,           	
           		func = function() if needReload then ReloadUI() end	 end,},

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