local addonName, ns = ...
local L, yoCon, N, defConfig = unpack( ns)

N.alertOptions 	= N:NewModule( 'alertOptions')--,'AceHook-3.0','AceEvent-3.0')
local _G 		= _G
local AO 		= N:GetModule('alertOptions')
local LSM 		= _G.LibStub("LibSharedMedia-3.0")

local gmatch , pairs, tonumber, print, GetSpellInfo , format, CopyTable, tremove = string.gmatch, pairs, tonumber, print, GetSpellInfo, format, CopyTable, tremove

local db, cb, alertDB, alertOpt, alertsPool, profiles, copyProf
local errorName = "|cff00ffffAlert|cffff0000 '%s'|r уже кем-то придуман, попробуй еще раз...|r"

local eventValues = {
	auraApplaed = "Аура пришла",
	auraRemoved	= "Аура ушла",
	auraStack	= "Аура стаки",
	castStart	= "Каст начался",
	castSuccs	= "Каст закончился",
}

local destValues = {
	me 			= "me",
	any 		= "any",
	empty 		= "empty",
	currentTank = "currentTank",
	freeTank 	= "freeTank",
}

local alertValues = {
	me 			= "toMe",
	currentTank = "toCurrentTank",
	freeTank	= "toFreeTank",
	anotherTank	= "toAnotherTank",
	target		= "toTarget",
	raid 		= "toRaid",
}

local colorValues = {
	green 		= "green",
	red 		= "red",
	orange 		= "orange",
	blue		= "blue",
	white		= "white",
	black		= "black",
}

local roleValues = {}
local diffValues = {}

local alertArgs = {
	label01		= { order = 01, type = "description",  imageWidth = 20, imageHeight = 20, imageCoords = {0.1,0.9,0.1,0.9}, fontSize = "large",
						name 	= function(info) local name 		= GetSpellInfo( db.alerts.alertsPool[info[2]].spellID) return name end,
						image 	= function(info) local _, _, icon  	= GetSpellInfo( db.alerts.alertsPool[info[2]].spellID) return icon end,},
	spellID		= { order = 10, type = "input",	 name = "spellID", 	width = 1, pattern = "^%d%d+$", usage  = "2-6 didgits please",
						set  = function(info,val) db.alerts.alertsPool[info[2]][info[#info]] = val local name, _, icon  = GetSpellInfo( val)
							if name then alertsPool[info[2]].args.label01.name( info) alertsPool[info[2]].args.label01.image( info) end end,},
	event		= {	order = 20, type = "select", name = "Событие", 	width = 1, values = eventValues},
	destUnit	= {	order = 30, type = "select", name = "С кем приключилось",	width = 1, values = destValues},
	alertUnit	= {	order = 40, type = "select", name = "Кому алертим",width = 1, values = alertValues},

	difficult 	= {	order = 44, type = "select", name = "Сложность",	width = 1,	values = diffValues, disabled = true,},
	myrole 		= {	order = 48, type = "select", name = "Моя роль",	width = 1, 		values = roleValues, disabled = true,},

	message		= { order = 50, type = "input",	 name = "Сообщение", 	width = 1.6, },
	color		= {	order = 60, type = "select", name = "Цвет",	width = 0.75, values = colorValues},

	stage		= { order = 70, type = "input",	 name = "Фаза боя", 	width = 0.6, },
	fromStack 	= { order = 80, type = "input",	 name = "fromStack",width = 0.6, },
	toStack		= { order = 90, type = "input",	 name = "toStack", 	width = 0.6, },

	raidAlert	= {	order = 140, type = "toggle", name = "Продублировать в 'Рэйд алерт'", width = "full", disabled = true,},
	lowHealth	= {	order = 150, type = "toggle", name = "Моргание краями экрана", width = "full", disabled = true,},

	sound		= {	order = 160, type = "select", name = L["CTAsound"], dialogControl = "LSM30_Sound", values = LSM:HashTable("sound"), width = 1.5},

	rename 		= { order = 990,type = "input",	 name = "Сменить фамилию", 	width = "full", get = function(info) return info[2] end, set = function(info, val)  AO:alertRename( val, info[2]) end},
	delete 		= { order = 999,type = "execute", width = "full",	name = "pleeeease, kill me! ( delete this shit)", func = function( info) AO:alertDel( info[2]) end, },
}

function AO:alertRename( newKey, key)

	if alertsPool[newKey] or newKey == key then print( format( errorName, newKey)) return end

	local apl = CopyTable( alertsPool[key])
	local adb = CopyTable( alertDB[key])

	alertsPool[key] 	= nil
	alertDB[key] 		= nil

	apl.name 			= newKey

	alertsPool[newKey] 	= apl
	alertDB[newKey] 	= adb

	if cb then cb:spellsPrepare() end
end

function AO:alertAdd( key)

	if not alertsPool[key] then
		local alertMax = 1
		for k,v in pairs( alertDB) do alertMax = alertMax + 1 end

		alertsPool[key] = {	order = alertMax * 10,	name = key, type = "group",	args = alertArgs,}
	else
		print( format( errorName, key))
	end

end

function AO:alertDel( key)
	alertsPool[key] = nil
	alertDB[key] = nil
end

function AO:alertCopy( copyProf)
	if not copyProf then return end

	local alertMax 	 = 0
	local name 		 = profiles[copyProf]
	for w in gmatch(  name, "(%P+) #") do name = w end

	local profilesDB = N.Config.db.profiles[name].alerts.alertsPool

	for k,v in pairs( alertDB) do alertMax = alertMax + 1 end

	for ind, data in pairs( profilesDB) do
		--print(ind, data)
		if not alertsPool[ind] then
			alertMax 		= alertMax + 1
			alertDB[ind] 	= data
			alertsPool[ind] = { order = alertMax * 10,	name = ind, type = "group",	args = alertArgs, }
		end
	end
end

function AO:alertOptions( options)
	local args 		= options.args
	local alertMax 	= 0

	args.alerts = {
		order = 500,	name = "Alerts", type = "group",
		get 	 = function(info) return db.alerts.alertsPool[info[2]][info[#info]] end,
		set 	 = function(info,val)    db.alerts.alertsPool[info[2]][info[#info]] = val if cb then cb:spellPrepare( info[2]) end end,
		disabled = function(info) if #info > 1 then return not db.Addons.alertEnable; end end,
		args = {
			alertEnable = {	order = 10, type = "toggle", name = "enable", 		width = 1, 		get = function(info) return db.Addons.alertEnable end, set  = function(info,val) N.Setlers( "Addons#alertEnable", val) end, disabled = false} ,
			alertNew	= { order = 20, type = "input",  name = "add new alert",width = "full", get = function(info) return "new alert" end, set = function(info,val) AO:alertAdd( val) end, },
			alertProf 	= {	order = 30, type = "select", name = "copy alerts from profile",	width = 1.5, 	values = profiles, 	get = function(info) return copyProf end, set = function(info,val) copyProf = val end,},
			alertCopy   = { order = 40,	type = "execute",name = "copy alerts", 	width = 1, 		func = function( info) AO:alertCopy( copyProf) end, },
		},
	}

	alertsPool 	= args.alerts.args

	for ind, data in pairs( alertDB) do
		alertMax 		= alertMax + 1
		alertsPool[ind] = { order = alertMax * 10,	name = ind, type = "group",	args = alertArgs, }
	end
end

function AO:OnInitialize() end

function AO:OnEnable()
	local n = _G.yoFrame[3]

	cb 		= n.Addons.cheloBuff
	db 		= N.Config.db.profile
	profiles= N.Config.db:GetProfiles()
	alertDB	= N.Config.db.profile.alerts.alertsPool

	for ind = #profiles, 1, -1 do
		local name = profiles[ind]
		local profilesDB = N.Config.db.profiles[name]

		if profilesDB.alerts and profilesDB.alerts.alertsPool then
			local iMax = 0
			for _ in pairs( profilesDB.alerts.alertsPool) do
				iMax = iMax + 1
			end
			profiles[ind] = name .. " #" .. iMax .. " alerts"

		else
			tremove(profiles, ind)
		end
	end
end

--[[
	["alerts"] = {
				["alertsPool"] = {
					["Изобретатель в центр"] = {
						["message"] = "Выносим 1й портал в центр ( $stage)",
						["event"] = "castStart",
						["toStack"] = "",
						["sound"] = "BigWigs: [DBM] Разрушение (Кил'джеден)",
						["color"] = "orange",
						["fromStack"] = "",
						["stage"] = "3",
						["spellID"] = "328437",
					},
					["Грязешмяк колонна"] = {
						["message"] = "Отойди от колонны! Скоро дамажить ( 6 сек)",
						["color"] = "blue",
						["stage"] = "1",
						["sound"] = "BigWigs: [DBM] Беги, малышка, беги (Злой и страшный серый волк)",
						["spellID"] = "331209",
					},
					["Глязешмяк ты чист"] = {
						["message"] = "$target, ты чист!",
						["alertUnit"] = "target",
						["color"] = "green",
						["event"] = "auraRemoved",
						["sound"] = "Big Kiss",
						["spellID"] = "331209",
					},
					["Визгунья каст 2"] = {
						["message"] = "За колону - $spell $count",
						["event"] = "castStart",
						["sound"] = "BigWigs: [DBM] Беги, малышка, беги (Злой и страшный серый волк)",
						["spellID"] = "345936",
					},
					["Визгунья аура чист"] = {
						["message"] = "$target чист ( $spell)",
						["color"] = "green",
						["alertUnit"] = "target",
						["event"] = "auraRemoved",
						["spellID"] = "328897",
					},
					["Визгунья каст 1"] = {
						["message"] = "За колону - $spell $count",
						["event"] = "castStart",
						["sound"] = "BigWigs: [DBM] Беги, малышка, беги (Злой и страшный серый волк)",
						["spellID"] = "330711",
					},
					["Изобретатель 1я аура"] = {
						["color"] = "green",
						["message"] = "$target ( $spell) 1я аура ( $count)",
						["spellID"] = "328448",
					},
				},
			},
]]--