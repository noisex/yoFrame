local addonName, ns = ...
local L, conf, n, defConfig = unpack( ns)

defConfig.profiles = {}
local profiles = defConfig.profiles


profiles.noisex = {
	["General"] = {
		["scriptErrors"] = true,
	},
	["Addons"] = {
		["AutoSellGrayTrash"] = true,
		["AutoLeader"] = true,
	},
	["ToolTip"] = {
		["IDInToolTip"] = true,
		["showSpells"] = false,
		["ladyMod"] = false,
	},
	["CastBar"] = {
		["BCB"] = {
			["castBoss"] = true,
		},
	},
	["fliger"] = {
		["fligerBuffColr"] = false,
		["fligerBuffAnim"] = false,
		["fligerBuffGlow"] = false,
	},
	["UF"] = {
		["simpleUF"] = true,
	},
	["Raid"] = {
		["showSolo"] = true,
		["groupingOrder"] = "TDH",
	},
	["Chat"] = {
		["wim"] = true,
		["showVoice"] = true,
	},
}


profiles.demayer = {
	["General"] = {
		["scriptErrors"] = true,
	},
	["Addons"] = {
		["AutoSellGrayTrash"] = true,
		["mythicProcents"] = false,
		["AutoLeader"] = true,
	},
	["CTA"] = {
		["setD"] = false,
		["setN"] = false,
		["setT"] = false,
		["lfdMode"] = 2087,
		["enable"] = true,
		["dRole"] = false,
		["tRole"] = false,
		["nRole"] = false,
		["hideLast"] = true,
	},
	["CastBar"] = {
		["BCB"] = {
			["castBoss"] = true,
		},
	},
	["ToolTip"] = {
		["IDInToolTip"] = true,
		["ladyMod"] = false,
		["showSpells"] = false,
	},
	["fliger"] = {
		["fligerBuffColr"] = false,
		["fligerBuffSpell"] = "331939\n331937\n16974\n338825\n157228",
		["gAzetit"] = true,
		["fligerBuffCount"] = "35\n0\n0\n9\n0\n",
	},
	["Raid"] = {
		["showSolo"] = true,
		["groupingOrder"] = "TDH",
		["raidTemplate"] = 3,
	},
	["healBotka"] = {
		["hSpell3"] = "Восстановление",
		["key7"] = "SHIFT-BUTTON1",
		["hTimer4"] = 5,
		["key8"] = "SHIFT-BUTTON2",
		["spell5"] = "Природный целитель",
		["hTimer5"] = 0,
		["hSpell4"] = "Омоложение",
		["spell1"] = "Буйный рост",
		["key4"] = "BUTTON2",
		["hTimEna3"] = true,
		["key5"] = "ALT-BUTTON1",
		["hRedCol"] = "0.50196078431373,1,0",
		["hTimer3"] = 0,
		["hTimeSec"] = true,
		["spell2"] = "Стремительный рывок",
		["hSize"] = 10,
		["key6"] = "ALT-BUTTON2",
		["hSpell5"] = "Спокойствие",
		["spell9"] = "Быстрое восстановление",
		["key1"] = "MOUSEWHEELDOWN",
		["key3"] = "BUTTON1",
		["hTimer2"] = 0,
		["hDefCol"] = "1,0,0",
		["hColor2"] = "0,1,0",
		["borderC"] = "1,1,0",
		["key9"] = "BUTTON4",
		["bTrink7"] = true,
		["hColEna2"] = true,
		["spell8"] = "Жизнецвет",
		["bStop2"] = true,
		["hColEna3"] = true,
		["spell3"] = "Восстановление",
		["hTimEna4"] = true,
		["spell10"] = "Озарение",
		["hTimEna2"] = true,
		["hpBarVertical"] = true,
		["hColEna5"] = true,
		["bSpell"] = "Жизнецвет",
		["hColor4"] = "0.63921568627451,0.18823529411765,0.78823529411765",
		["hSpell2"] = "Буйный рост",
		["spell6"] = "Железная кора",
		["hTimEna5"] = true,
		["hEnable"] = true,
		["enable"] = true,
		["key10"] = "CTRL-BUTTON4",
		["bStop7"] = true,
		["key2"] = "MOUSEWHEELUP",
		["hColor5"] = "1,0.50196078431373,0",
		["spell4"] = "Омоложение",
		["spell7"] = "Природная стремительность",
		["hColEna4"] = true,
		["hColor3"] = "0,0.43921568627451,0.87058823529412",
	},

	["Chat"] = {
		["wim"] = true,
		["wimFigter"] = false,
		["winHeight"] = 273.9999694824219,
		["wimWidth"] = 425.9997863769531,
		["showVoice"] = true,
	},
}

profiles.twister = {

	["ActionBar"] = {
		["showBar3"] = true,
		["showBar5"] = true,
	},
	["General"] = {
		["scriptErrors"] = true,
	},
	["Addons"] = {
		["AutoSellGrayTrash"] = true,
		["AutoQuestEnhance"] = true,
		["AutoRepair"] = false,
		["AutoQuestSkipScene"] = false,
	},
	["CTA"] = {
		["enable"] = true,
	},
	["Chat"] = {
		["chatFontsize"] = 12,
		["wim"] = true,
		["showVoice"] = true,
	},
	["healBotka"] = {
		["key2"] = "BUTTON2",
		["key1"] = "BUTTON1",
		["spell3"] = "Жертвенное благословение",
		["spell1"] = "Торжество",
		["spell2"] = "Благословенная свобода",
		["enable"] = true,
		["key3"] = "BUTTON3",
		["key4"] = "BUTTON5",
		["spell4"] = "Очищение от токсинов",
	},
	["Raid"] = {
		["showSolo"] = true,
	},
}

profiles.kisa = {

	["healBotka"] = {
		["hEnable"] = true,
		["key9"] = "ALT-BUTTON2",
		["key2"] = "CTRL-BUTTON1",
		["key1"] = "BUTTON1",
		["hSpell3"] = "Жертвенное благословение",
		["hSpell1"] = "Частица добродетели",
		["spell2"] = "Свет небес",
		["key7"] = "CTRL-BUTTON2",
		["hSpell2"] = "Благословение защиты",
		["key5"] = "BUTTON4",
		["takeTarget"] = true,
		["spell5"] = "Свет зари",
		["res01"] = "P",
		["key8"] = "ALT-BUTTON1",
		["hSpell4"] = "Владение аурами",
		["key3"] = "BUTTON2",
		["key6"] = "BUTTON5",
		["spell3"] = "Шок небес",
		["spell9"] = "Дарование веры",
		["enable"] = true,
		["spell1"] = "Вспышка Света",
		["spell4"] = "Очищение",
		["spell7"] = "Свет мученика",
		["spell6"] = "Частица добродетели",
		["spell8"] = "Торжество",
		["key4"] = "BUTTON3",
		["hColor1"] = "0,0,0",
	},
	["Media"] = {
		["fontsize"] = 13,
	},
	["Bags"] = {
		["autoReagent"] = false,
	},
	["Chat"] = {
		["chatFontsize"] = 13,
		["wim"] = true,
	},
	["Addons"] = {
		["AutoQuest"] = false,
		["AutoQuestComplete2Choice"] = false,
		["AutoQuestComplete"] = false,
	},
	["UF"] = {
		["enableSPower"] = true,
	},
	["Raid"] = {
		["groupingOrder"] = "THD",
		["raidTemplate"] = 3,
		["filterHighLight"] = true,
	},
	["ActionBar"] = {
		["showBar3"] = true,
		["showBar5"] = true,
	},
}