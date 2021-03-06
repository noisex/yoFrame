local AddOnName, Engine = ...
local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local CallbackHandler = _G.LibStub('CallbackHandler-1.0')

local addon = AceAddon:NewAddon( AddOnName, 'AceEvent-3.0')

addon.df = {profile = {}, global = {}}; addon.privateVars = {profile = {}} -- Defaults
addon.options = {type = 'group', args = {}, childGroups = 'ElvUI_HiddenTree'}
addon.callbacks = addon.callbacks or CallbackHandler:New(addon)

Engine[1] = {}
Engine[2] = {} --addon.DF.profile
Engine[3] = addon
Engine[4] = {} -- default config

-- addon.privateVars.profile
--Engine[5] = addon.DF.global

_G[AddOnName] = Engine

local locale = GetLocale()

local L = {
	__index = function(_, k)
		---print ( "L[\"" ..k  .. "\"] = \"\"")
		return format("[%s] %s", locale, tostring(k))
	end
}

function Engine:NewLocale()
	return setmetatable({}, L)
end

function Engine:IsSameLocale(name1, name2, name3)
	local l = GetLocale()
	return name1 == l or name2 == l or name3 == l
end