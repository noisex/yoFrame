--------------------------------
-- FreebAutoRez, by Freebaser
-- NDui MOD
--------------------------------
--local B, C, L, DB = unpack(select(2, ...))
local L, yo, n = unpack( select( 2, ...))

local _, ns = ...
local oUF = ns.oUF

local classList = {
	["DEATHKNIGHT"] = {
		combat = GetSpellInfo(61999),		-- 复活盟友
		oneres = GetSpellInfo(61999),		-- 复活盟友
	},
	["DRUID"] = {
		combat = GetSpellInfo(20484),		-- 复生
		oneres = GetSpellInfo(50769),		-- 起死回生
		allres = GetSpellInfo(212040),		-- 新生
	},
	["MONK"] = {
		oneres = GetSpellInfo(115178),		-- 轮回转世
		allres = GetSpellInfo(212051),		-- 死而复生
	},
	["PALADIN"] = {
		oneres = GetSpellInfo(7328),		-- 救赎
		allres = GetSpellInfo(212056),		-- 宽恕
	},
	["PRIEST"] = {
		oneres = GetSpellInfo(2006),		-- 复活术
		allres = GetSpellInfo(212036),		-- 群体复活
	},
	["SHAMAN"] = {
		oneres = GetSpellInfo(2008),		-- 先祖之魂
		allres = GetSpellInfo(212048),		-- 先祖视界
	},
	["HUNTER"] = {
		combat1 = GetSpellInfo(126393),		-- 永恒守护者
		combat2 = GetSpellInfo(159931),		-- 赤精之赐
		combat3 = GetSpellInfo(159956)
	},
	["WARLOCK"] = {
		combat = GetSpellInfo(20707),		-- 灵魂石
		oneres = GetSpellInfo(20707),		-- 灵魂石
	},
}

local body = ""
function n.macroAutoResurectBody(class)
	body = "/stopcasting\n"

	-- BFA
	if class == "GUNTER" then
		local combatSpell1 = classList[class].combat1
		local combatSpell2 = classList[class].combat2
		local combatSpell3 = classList[class].combat2
		body = body.."/cast [@mouseover,help,dead][help,dead] "..combatSpell1.."\n"
		body = body.."/cast [@mouseover,help,dead][help,dead] "..combatSpell2.."\n"
		body = body.."/cast [@mouseover,help,dead][help,dead] "..combatSpell3.."\n"

	elseif class == "WARLOCK" then
		local combatSpell = classList[class].combat
		local oneresSpell = classList[class].oneres
		local allresSpell = classList[class].allres

		if oneresSpell then body = body.."/cast [@mouseover] "..oneresSpell.."\n" end
		if combatSpell then body = body.."/cast [@mouseover] "..combatSpell.."\n" 		end

	else
		local combatSpell = classList[class].combat
		local oneresSpell = classList[class].oneres
		local allresSpell = classList[class].allres

		if allresSpell then body = body.."/cast [nocombat] "..allresSpell.."\n" end
		if oneresSpell then body = body.."/cast [nocombat,@mouseover,help,dead][nocombat,help,dead] "..oneresSpell.."\n" end
		if combatSpell then body = body.."/cast [combat,@mouseover,help,dead][combat,help,dead] "..combatSpell.."\n"	end

	end
	return body
end

local function setupAttribute(self)
	if InCombatLockdown() then return end

	if classList[n.myClass] then
		local macroAttr, macroButton = n.makeMacroButton( yo.healBotka.res01)
		self:SetAttribute( macroAttr, "macro")
		self:SetAttribute( macroButton, n.macroAutoResurectBody(n.myClass))
		--self:SetAttribute("*type3", "macro")
		--self:SetAttribute("macrotext3", n.macroAutoResurectBody(n.myClass))
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", setupAttribute, true)
	end
end

local Enable = function(self)

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", setupAttribute, true)
	else
		setupAttribute(self)
	end
end

local Disable = function(self)

	--self:SetAttribute("*type3", nil)
	--self:UnregisterEvent("PLAYER_REGEN_ENABLED", setupAttribute, true)
end

oUF:AddElement("AutoResurrect", nil, Enable, Disable)
