local AddOnName, Engine = ...
local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
--local CallbackHandler = _G.LibStub('CallbackHandler-1.0')

local addon = AceAddon:NewAddon( AddOnName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')

addon.DF = {profile = {}, global = {}}; addon.privateVars = {profile = {}} -- Defaults
--addon.Options = {type = 'group', args = {}, childGroups = 'ElvUI_HiddenTree'}
--addon.callbacks = addon.callbacks or CallbackHandler:New(addon)

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
		return format("[%s] %s", locale, tostring(k))
	end
}

function addon:NewLocale()
	return setmetatable({}, L)
end

function addon:IsSameLocale(name1, name2, name3)
	local l = GetLocale()
	return name1 == l or name2 == l or name3 == l
end
