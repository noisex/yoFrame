local addon, ns = ...

local L, yo, n = unpack( ns)
local oUF = ns.oUF

----------------------------------------------------------------------------------------
--	Tooltip replace
----------------------------------------------------------------------------------------
local function GameTooltipDefault(tooltip, parent)
	tooltip:SetOwner(parent, "ANCHOR_NONE")
	tooltip:ClearAllPoints()
	tooltip:SetPoint("BOTTOMRIGHT", yoMoveToolTip, "BOTTOMRIGHT", 0, 0)
	tooltip.default = 1
end
hooksecurefunc("GameTooltip_SetDefaultAnchor", GameTooltipDefault)

function GameTooltipOnLeave()
	GameTooltip:Hide()
end


if not yo.ToolTip.enable then return end

----------------------------------------------------------------------------------------
--	Show source of mount
----------------------------------------------------------------------------------------
local MountCache = {}
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
		MountCache[select(2, C_MountJournal.GetMountInfoByID(mountID))] = mountID
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
	if not UnitIsPlayer(...) or UnitIsUnit(..., "player") then return end
	local id = select(10, UnitAura(...))

	if id and MountCache[id] then
		local text = MOUNT_JOURNAL_NOT_COLLECTED
		local r, g, b = 1, 0, 0
		local collected = select(11, C_MountJournal.GetMountInfoByID(MountCache[id]))

		if collected then
			text = NPEV2_MOUNT_TUTORIAL_P2_NEW_MOUNT_ADDED
			r, g, b = 0, 1, 0
		end

		self:AddLine(" ")
		self:AddLine(text, r, g, b)

		local sourceText = select(3, C_MountJournal.GetMountInfoExtraByID(MountCache[id]))
		self:AddLine(sourceText, 1, 1, 1)
		self:AddLine(" ")
		self:Show()
	end
end)

----------------------------------------------------------------------------------------
--	Based on aTooltip(by ALZA)
----------------------------------------------------------------------------------------

-- Raid icon
local ricon = GameTooltip:CreateTexture("GameTooltipRaidIcon", "OVERLAY")
ricon:SetHeight(30)
ricon:SetWidth(30)
ricon:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 0, 15)

GameTooltip:HookScript("OnHide", function(self) ricon:SetTexture(nil) end)

----------------------------------------------------------------------------------------
--	Unit tooltip styling
----------------------------------------------------------------------------------------
function GameTooltip_UnitColor(unit)
	if not unit then return end
	local r, g, b

	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			r, g, b = color.r, color.g, color.b
		else
			r, g, b = 1, 1, 1
		end
	elseif UnitIsTapDenied(unit) or UnitIsDead(unit) then
		r, g, b = 0.6, 0.6, 0.6
	else
		local reaction = oUF.colors.reaction[UnitReaction(unit, "player")]
		if reaction then
			r, g, b = reaction[1], reaction[2], reaction[3]
		else
			r, g, b = 1, 1, 1
		end
	end

	return r, g, b
end

local function GetLFDRole(unit)
	local role = UnitGroupRolesAssigned(unit)

	if role == "NONE" then
		return "|cFFB5B5B5"..NO_ROLE.."|r"
	elseif role == "TANK" then
		return "|cFF0070DE"..TANK.."|r"
	elseif role == "HEALER" then
		return "|cFF00CC12"..HEALER.."|r"
	else
		return "|cFFFF3030"..DAMAGER.."|r"
	end
end

local OnTooltipSetUnit = function(self)
	local lines = self:NumLines()
	local unit = (select(2, self:GetUnit())) or (GetMouseFocus() and GetMouseFocus():GetAttribute("unit")) or (UnitExists("mouseover") and "mouseover") or nil

	if not unit then return end

	local name, realm = UnitName(unit)
	local race, englishRace = UnitRace(unit)
	local level = UnitLevel(unit)
	local levelColor = GetQuestDifficultyColor(level)
	local classification = UnitClassification(unit)
	local creatureType = UnitCreatureType(unit)
	local _, faction = UnitFactionGroup(unit)
	local _, playerFaction = UnitFactionGroup("player")
	local relationship = UnitRealmRelationship(unit)
	local UnitPVPName = UnitPVPName

	if level and level == -1 then
		if classification == "worldboss" then
			level = "|cffff0000|r"..ENCOUNTER_JOURNAL_ENCOUNTER
		else
			level = "|cffff0000??|r"
		end
	end

	if classification == "rareelite" then classification = " R+"
	elseif classification == "rare" then classification = " R"
	elseif classification == "elite" then classification = "+"
	else classification = "" end

	 --if UnitPVPName(unit) then name = UnitPVPName(unit) end

	_G["GameTooltipTextLeft1"]:SetText(name)
	if realm and realm ~= "" then
		--self:AddLine(FRIENDS_LIST_REALM.."|cffffffff"..realm.."|r")
		self:AddDoubleLine(FRIENDS_LIST_REALM.. ":", realm, 1, 1, 0, 0, 1, 1)
	end

	if UnitIsPlayer(unit) then
		if UnitIsAFK(unit) then
			self:AppendText((" %s"):format("|cffE7E716".."AFK".."|r"))
		elseif UnitIsDND(unit) then
			self:AppendText((" %s"):format("|cffFF0000".."DND".."|r"))
		end

		if UnitIsPlayer(unit) and englishRace == "Pandaren" and faction ~= nil and faction ~= playerFaction then
			local hex = "cffff3333"
			if faction == "Alliance" then
				hex = "cff69ccf0"
			end
			self:AppendText((" [|%s%s|r]"):format(hex, faction:sub(1, 2)))
		end

		local guildName, guildRank = GetGuildInfo(unit)
		if guildName then
			_G["GameTooltipTextLeft2"]:SetFormattedText("\n|cffffff00" .. GUILD .. ": |r%s \n|cffffff00%s: |cffffffff%s\n\n", guildName, RANK, guildRank)
			if UnitIsInMyGuild(unit) then
				_G["GameTooltipTextLeft2"]:SetTextColor(1, 1, 0)
			else
				_G["GameTooltipTextLeft2"]:SetTextColor(0, 1, 1)
			end
			--self:AddDoubleLine(RANK..":", "|cffffffff" .. guildRank.."|r")
		end


		local n = guildName and 3 or 2
		-- thx TipTac for the fix above with color blind enabled
		if GetCVar("colorblindMode") == "1" then n = n + 1 end
		_G["GameTooltipTextLeft"..n]:SetFormattedText("|cff%02x%02x%02x%s|r %s", levelColor.r * 255, levelColor.g * 255, levelColor.b * 255, level, race or UNKNOWN)


		for i = 2, lines do
			local line = _G["GameTooltipTextLeft"..i]
			if not line or not line:GetText() then return end
			if line and line:GetText() and (line:GetText() == FACTION_HORDE or line:GetText() == FACTION_ALLIANCE) then
				line:SetText()
				break
			end
		end
	else
		for i = 2, lines do
			local line = _G["GameTooltipTextLeft"..i]
			if not line or not line:GetText() or UnitIsBattlePetCompanion(unit) then return end
			if (level and line:GetText():find("^"..LEVEL)) or (creatureType and line:GetText():find("^"..creatureType)) then
				local r, g, b = GameTooltip_UnitColor(unit)
				line:SetFormattedText("|cff%02x%02x%02x%s%s|r %s", levelColor.r * 255, levelColor.g * 255, levelColor.b * 255, level, classification, creatureType or "")
				break
			end
		end
	end

	if UnitExists(unit.."target") then
		local r, g, b = GameTooltip_UnitColor(unit.."target")
		local text = ""

		if UnitIsEnemy("player", unit.."target") then
			r, g, b = unpack(oUF.colors.reaction[1])
		elseif not UnitIsFriend("player", unit.."target") then
			r, g, b = unpack(oUF.colors.reaction[4])
		end

		if UnitName(unit.."target") == UnitName("player") then
			self:AddDoubleLine( STATUS_TEXT_TARGET..":", UNIT_YOU, 1, 1, 0, 1, 0, 0)
		else
			self:AddDoubleLine( STATUS_TEXT_TARGET..":", UnitName(unit.."target"), 1, 1, 0, r, g, b)
		end
	end

	local raidIndex = GetRaidTargetIndex(unit)
	if raidIndex then
		ricon:SetTexture( yo.Media.path .. "icons\\raidicons")
		SetRaidTargetIconTexture( ricon, raidIndex)
		ricon:Show()
	else
		ricon:Hide()
	end

	local _, instanceType = IsInInstance()
	if instanceType ~= "scenario" then
		if unit and UnitIsPlayer(unit) and ((UnitInParty(unit) or UnitInRaid(unit)) and GetNumGroupMembers() > 0) then
			GameTooltip:AddDoubleLine(ROLE..":", GetLFDRole(unit), 1, 1, 0)
		end
	end
	-----------------token = unit AddTargetedBy()
end

GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)


-----------------------------------------------------------------------
--	Your achievement status in tooltip(Enhanced Achievements by Syzgyn)
----------------------------------------------------------------------------------------
local colors = {
	["GREEN"] = {
		["r"] = 0.25,
		["g"] = 0.75,
		["b"] = 0.25,
	},
	["GRAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
	},
}

local function SetHyperlink(tooltip, refString)
	local output = {[0] = {}, [1] = {}}
	if select(3, string.find(refString, "(%a-):")) ~= "achievement" then return end

	local _, _, achievementID = string.find(refString, ":(%d+):")
	local numCriteria = GetAchievementNumCriteria(achievementID)
	local _, _, GUID = string.find(refString, ":%d+:(.-):")

	if GUID == UnitGUID("player") then
		tooltip:Show()
		return
	end

	tooltip:AddLine(" ")
	local _, name, _, completed, month, day, year, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

	if completed then
		if year < 10 then year = "0"..year end

		if client == "ruRU" then
			tooltip:AddLine(L["Y_STATUS_C"]..day.."/"..month.."/"..year, 0, 1, 0)
		else
			tooltip:AddLine(L["Y_STATUS_C"]..month.."/"..day.."/"..year, 0, 1, 0)
		end

		if earnedBy then
			if earnedBy ~= "" then
				tooltip:AddLine(format(ACHIEVEMENT_EARNED_BY, earnedBy))
			end
			if not wasEarnedByMe then
				tooltip:AddLine(format(ACHIEVEMENT_NOT_COMPLETED_BY, name))
			elseif name ~= earnedBy then
				tooltip:AddLine(format(ACHIEVEMENT_COMPLETED_BY, name))
			end
		end
	elseif numCriteria == 0 then
		tooltip:AddLine(L["Y_STATUS_DC"])
	else
		tooltip:AddLine(L["Y_STATUS"])
		for i = 1, numCriteria, 2 do
			for a = 0, 1 do
				output[a].text = nil
				output[a].color = nil
				if i + a <= numCriteria then
					local name, _, completed, quantity, reqQuantity = GetAchievementCriteriaInfo(achievementID, i + a)
					if completed then
						output[a].text = name
						output[a].color = "GREEN"
					else
						if quantity < reqQuantity and reqQuantity > 1 then
							output[a].text = name.." ("..quantity.."/"..reqQuantity..")"
							output[a].color = "GRAY"
						else
							output[a].text = name
							output[a].color = "GRAY"
						end
					end
				else
					output[a].text = nil
				end
			end
			if output[1].text == nil then
				tooltip:AddLine(output[0].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b)
			else
				tooltip:AddDoubleLine(output[0].text, output[1].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b, colors[output[1].color].r, colors[output[1].color].g, colors[output[1].color].b)
			end
			output = {[0] = {}, [1] = {}}
		end
	end
	tooltip:Show()
end

hooksecurefunc(GameTooltip, "SetHyperlink", SetHyperlink)
hooksecurefunc(ItemRefTooltip, "SetHyperlink", SetHyperlink)


----------------------------------------------------------------------------------------
--	Adds item icons to tooltips(Tipachu by Tuller)
----------------------------------------------------------------------------------------
local function setTooltipIcon(self, icon)
	local title = icon and _G[self:GetName().."TextLeft1"]
	if title then
		title:SetFormattedText("|T%s:22:22:0:0:64:64:5:59:5:59:%d|t %s", icon, 20, title:GetText())
	end
end

local function newTooltipHooker(method, func)
	return function(tooltip)
		local modified = false

		tooltip:HookScript("OnTooltipCleared", function(self, ...)
			modified = false
		end)

		tooltip:HookScript(method, function(self, ...)
			if not modified then
				modified = true
				func(self, ...)
			end
		end)
	end
end

local hookItem = newTooltipHooker("OnTooltipSetItem", function(self, ...)
	local _, link = self:GetItem()
	if link then
		setTooltipIcon(self, GetItemIcon(link))
	end
end)

local hookSpell = newTooltipHooker("OnTooltipSetSpell", function(self, ...)
	local _, _, id = self:GetSpell()
	if id then
		setTooltipIcon(self, select(3, GetSpellInfo(id)))
	end
end)

for _, tooltip in pairs{GameTooltip, ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, ShoppingTooltip1, ShoppingTooltip2} do
	hookItem(tooltip)
	hookSpell(tooltip)
end


----------------------------------------------------------------------------------------
--	Multi ItemRefTooltip
----------------------------------------------------------------------------------------
--local tips = {[1] = _G["ItemRefTooltip"]}
--local types = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true, currency = true}

--local CreateTip = function(link)
--	for k, v in ipairs(tips) do
--		for i, tip in ipairs(tips) do
--			if tip:IsShown() and tip.link == link then
--				tip.link = nil
--				HideUIPanel(tip)
--				return
--			end
--		end
--		if not v:IsShown() then
--			v.link = link
--			return v
--		end
--	end

--	local num = #tips + 1
--	local tip = CreateFrame("GameTooltip", "ItemRefTooltip"..num, UIParent, "GameTooltipTemplate")
--	--tip:SetTemplate("Transparent")
--	tip:SetPoint("BOTTOM", 0, 80)
--	tip:SetSize(128, 64)
--	tip:EnableMouse(true)
--	tip:SetMovable(true)
--	tip:SetClampedToScreen(true)
--	tip:RegisterForDrag("LeftButton")
--	tip:SetScript("OnDragStart", function(self) self:StartMoving() end)
--	tip:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
--	tip:HookScript("OnShow", function(self)
--		self:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
--		self:SetBackdropBorderColor( 1, 1, 1, 0.9)
--	end)

--	table.insert(UISpecialFrames, tip:GetName())

--	tip.link = link
--	tips[num] = tip

--	return tip
--end

--local ShowTip = function(tip, link)
--	ShowUIPanel(tip)
--	if not tip:IsShown() then
--		tip:SetOwner(UIParent, "ANCHOR_PRESERVE")
--	end
--	tip:SetHyperlink(link)
--end

--local _SetItemRef = SetItemRef
--function SetItemRef(...)
--	local link, text, button = ...
--	print("...")
--	local handled = strsplit(":", link)
--	if not IsModifiedClick() and handled and types[handled] then
--		local tip = CreateTip(link)
--		if tip then
--			ShowTip(tip, link)
--		end
--	else
--		return _SetItemRef(...)
--	end
--end





















----------------------------------------------------------------------------------------
--	Clean ruRU tooltip(snt_rufix by Don Kaban, edited by ALZA)
----------------------------------------------------------------------------------------
----ITEM_CREATED_BY = ""	-- No creator name
----ITEM_SOCKETABLE = ""	-- No gem info line
--EMPTY_SOCKET_RED = "|cffFF4040"..EMPTY_SOCKET_RED.."|r"
--EMPTY_SOCKET_YELLOW = "|cffffff40"..EMPTY_SOCKET_YELLOW.."|r"
--EMPTY_SOCKET_BLUE = "|cff6060ff"..EMPTY_SOCKET_BLUE.."|r"

----GUILD_ACHIEVEMENT = "Уведомл. для гильдии"

--local ttext
--local replace = {
--	["красного цвета"] = "|cffFF4040красного цвета|r",
--	["синего цвета"] = "|cff6060ffсинего цвета|r",
--	["желтого цвета"] = "|cffffff40желтого цвета|r",
--	["Требуется хотя бы"] = "Требуется",
--}

--local replaceclass = {
--	["Воин"] = "|cffC79C6EВоин|r",
--	["Друид"] = "|cffFF7D0AДруид|r",
--	["Жрец"] = "|cffFFFFFFЖрец|r",
--	["Маг"] = "|cff69CCF0Маг|r",
--	["Монах"] = "|cff00FF96Монах|r",
--	["Охотник"] = "|cffABD473Охотник|r",
--	["Охотник на демонов"] = "|cffA330C9Охотник на демонов|r",
--	["Паладин"] = "|cffF58CBAПаладин|r",
--	["Разбойник"] = "|cffFFF569Разбойник|r",
--	["Рыцарь смерти"] = "|cffC41F3BРыцарь смерти|r",
--	["Чернокнижник"] = "|cff9482C9Чернокнижник|r",
--	["Шаман"] = "|cff0070DEШаман|r",

--	["Warrior"] = "|cffC79C6EWarrior|r",
--	["Druid"] = "|cffFF7D0ADruid|r",
--	["Priest"] = "|cffFFFFFFPriest|r",
--	["Mage"] = "|cff69CCF0Mage|r",
--	["Monk"] = "|cff00FF96Monk|r",
--	["Hunter"] = "|cffABD473Hunter|r",
--	["Demon hunter"] = "|cffA330C9Demon hunter|r",
--	["Paladin"] = "|cffF58CBAPaladin|r",
--	["Rogue"] = "|cffFFF569Rogue|r",
--	["Death knight"] = "|cffC41F3BDeath knight|r",
--	["Warlock"] = "|cff9482C9Warlock|r",
--	["Shaman"] = "|cff0070DEShaman|r",
--}

--local function Translate(text)
--	if text then
--		for rus, replace in next, replace do
--			text = text:gsub(rus, replace)
--		end
--		return text
--	end
--end

--local function TranslateClass(text)
--	if text then
--		for rus, replaceclass in next, replaceclass do
--			text = text:gsub(rus, replaceclass)
--		end
--		return text
--	end
--end

--local function UpdateTooltip(self)
--	if not self:GetItem() then return end
--	local tname = self:GetName()
--	for i = 3, self:NumLines() do
--		ttext = _G[tname.."TextLeft"..i]
--		local class = ttext:GetText() and (string.find(ttext:GetText(), L["CLASS"]) or string.find(ttext:GetText(), "Требуется"))
--		if ttext then ttext:SetText(Translate(ttext:GetText())) end
--		if ttext and class then ttext:SetText(TranslateClass(ttext:GetText())) end
--		ttext = _G[tname.."TextRight"..i]
--		if ttext then ttext:SetText(Translate(ttext:GetText())) end
--	end
--	ttext = nil
--end

--GameTooltip:HookScript("OnTooltipSetItem", UpdateTooltip)
--ItemRefTooltip:HookScript("OnTooltipSetItem", UpdateTooltip)
--ShoppingTooltip1:HookScript("OnTooltipSetItem", UpdateTooltip)
--ShoppingTooltip2:HookScript("OnTooltipSetItem", UpdateTooltip)

----------------------------------------------------------------------------------------
--	Item count in tooltip(by Tukz)
----------------------------------------------------------------------------------------
--local UIItemTooltipCount
--local gender = { 'Female', 'Male' }
----GameTooltip:HookScript("OnTooltipCleared", function(self)
----	UIItemTooltipCount = nil
----	--print("WE EHEREEEEEE")
----end)

--local function attachItemTooltip( self)
--	local _, link = self:GetItem()
--	if true then --link ~= UIItemTooltipCount then
--		local numTotal = GetItemCount(link, true)

--		local oneDate
--		if yo.Bags.showAltBags and yo.Bags.countAltBags then
--			for name, player in pairs( yo_BBCount[n.myRealm]) do
--				local _, itemID = strsplit(":", link)
--				itemID = tonumber(itemID)
--				if name ~= n.myName and player[itemID] then
--					if not oneDate then
--						self:AddLine(" ")
--						oneDate = true
--					end
--					self:AddDoubleLine( name, player[itemID], 1, 1, 0, 1, 1, 1)
--				end
--			end
--		end

--		if numTotal > 1 then
--			local item_count, itemBank = "", ""
--			local numBag = GetItemCount(link, false)
--			local numBank = numTotal - numBag
--			local cY, cW = "|cffffff00", "|cffffffff"

--			if numBank and numBank > 0 then
--				itemBank = cW .. " ( " .. L["BAG"] .. ": " .. numBag .. ", " ..L["BANK"] .. ": " .. numBank .. ")"
--			end

--			--item_count = cY .. n.myName ..": ".. cW ..numTotal .. itemBank
--			if not oneDate then
--				self:AddLine(" ")
--				oneDate = true
--			end
--			self:AddDoubleLine( n.myName, numTotal .. itemBank, 1, 1, 0, 1, 1, 1)
--		end
--		self:AddLine(" ")
--		--UIItemTooltipCount = link
--	end
--end

--GameTooltip:HookScript("OnTooltipSetItem", function(self)

--end)

--GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
--ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
--ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
--ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
--ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
--ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)


--[[
----------------------------------------------------------------------------------------
--	Equipped average item level(Cloudy Unit Info by Cloudyfa)
----------------------------------------------------------------------------------------
--- Variables
local currentUNIT, currentGUID
local GearDB, SpecDB, ItemDB = {}, {}, {}

local prefixColor = "|cffF9D700"
local detailColor = "|cffffffff"

local gearPrefix = STAT_AVERAGE_ITEM_LEVEL..": "

local furySpec = GetSpecializationNameForSpecID(72)

--- Create Frame
local f = CreateFrame("Frame", "CloudyUnitInfo")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")

--- Set Unit Info
local function SetUnitInfo(gear)
	if not gear then return end

	local _, unit = GameTooltip:GetUnit()
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	local gearLine
	for i = 2, GameTooltip:NumLines() do
		local line = _G["GameTooltipTextLeft" .. i]
		local text = line:GetText()

		if text and strfind(text, gearPrefix) then
			gearLine = line
		end
	end

	if gear then
		gear = prefixColor..gearPrefix..detailColor..gear

		if gearLine then
			gearLine:SetText(gear)
		else
			GameTooltip:AddLine(gear)
		end
	end

	GameTooltip:Show()
end

--- PVP Item Detect
local function IsPVPItem(link)
	local itemStats = GetItemStats(link)
	for stat in pairs(itemStats) do
		if stat == "ITEM_MOD_RESILIENCE_RATING_SHORT" or stat == "ITEM_MOD_PVP_POWER_SHORT" then
			return true
		end
	end

	return false
end

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local scantip = CreateFrame("GameTooltip", "iLvlScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

function _getRealItemLevel(slotId, unit, link, forced)
	if (not forced) and ItemDB[link] then return ItemDB[link] end

	local realItemLevel
	local hasItem = scantip:SetInventoryItem(unit, slotId)
	if not hasItem then return nil end -- With this we don't get ilvl for offhand if we equip 2h weapon

	for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
		local text = _G["iLvlScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			realItemLevel = realItemLevel or strmatch(text, S_ITEM_LEVEL)

			if realItemLevel then
				ItemDB[link] = tonumber(realItemLevel)
				return tonumber(realItemLevel)
			end
		end
	end

	return realItemLevel
end

--- Unit Gear Info
local function UnitGear(unit)
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	--local class = select(2, UnitClass(unit))

	local ilvl, boa, pvp, wear = 0, 0, 0, 0
	local total, delay = 0, nil
	local wlvl, wslot = 0, 0

	for i = 1, 17 do
		if i ~= 4 then
			--local id = GetInventoryItemID(unit, i)
			local itemLink = GetInventoryItemLink(unit, i)

			if itemLink then
				--local itemLink = GetInventoryItemLink(unit, i)

				if not itemLink then
					delay = true
				else
					local _, _, quality = GetItemInfo(itemLink)

					if (not quality) then
						delay = true
					else
						if quality == 7 then boa = boa + 1 end

						--local itemLocation = ItemLocation:CreateFromEquipmentSlot( i)
						--local item = Item:CreateFromItemLocation( itemLocation)
						local item = Item:CreateFromItemLink( itemLink)
						level = item:GetCurrentItemLevel() or 0

						wear = wear + 1
						total = total + level

						if i == 16 then wlvl = level end

						print( i .. " total: " .. total, " level: " .. level, unit, itemLink)
					end
				end
			elseif i == 17 and itemLink == nil then
				wear = wear + 1
				total = total + wlvl
			end
		end
	end

	if not delay then
		if unit == "!!!!player" and GetAverageItemLevel() > 0 then
			_, ilvl = GetAverageItemLevel()
		else
			ilvl = total / wear
		end

		if ilvl > 0 then ilvl = string.format("%.1f", ilvl) end
		if boa > 0 then ilvl = ilvl.."  |cffe6cc80"..boa.." "..HEIRLOOMS end
	else
		ilvl = nil
	end
	print( ilvl, total, wear, total / wear)

	return ilvl
end

--- Unit Specialization
local function UnitSpec(unit)
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	local specName
	if (unit == "player") then
		local specIndex = GetSpecialization()
		if specIndex then
			specName = select(2, GetSpecializationInfo(specIndex))
		end
	else
		local specID = GetInspectSpecialization(unit)
		if specID and (specID > 0) then
			specName = GetSpecializationNameForSpecID(specID)
		end
	end

	return specName
end

--- Scan Current Unit
local function ScanUnit(unit, forced)
	local cachedGear

	if UnitIsUnit(unit, "player") then
		cachedGear = UnitGear("player")

		SetUnitInfo(cachedGear or CONTINUED)
	else
		if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

		cachedGear = GearDB[currentGUID]

		-- cachedGear? ok...skip get gear
		if cachedGear and not forced then
			SetUnitInfo(cachedGear)
		end

		if not (IsShiftKeyDown() or forced) then
			if UnitAffectingCombat("player") then return end
		end

		if not UnitIsVisible(unit) then return end
		if UnitIsDeadOrGhost("player") or UnitOnTaxi("player") then return end
		if InspectFrame and InspectFrame:IsShown() then return end

		-- Press SHIFT to refresh
		if IsShiftKeyDown() then
			SetUnitInfo(CONTINUED, CONTINUED)
		else
			SetUnitInfo(cachedGear or CONTINUED)
		end

		local lastRequest = GetTime() - (f.lastUpdate or 0)
		if (lastRequest >= 1.5) then
			f.nextUpdate = 0
		else
			f.nextUpdate = 1.5 - lastRequest
		end
		f:Show()
	end
end

--- Character Info Sheet
MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = 1
hooksecurefunc("PaperDollFrame_SetItemLevel", function(self, unit)
	if unit ~= "player" then return end

	local total, equip = GetAverageItemLevel()
	if total > 0 then total = string.format("%.1f", total) end
	if equip > 0 then equip = string.format("%.1f", equip) end

	local ilvl = equip
	if equip ~= total then
		ilvl = equip.." / "..total
	end

	self.Value:SetText(ilvl)

	self.tooltip = detailColor..STAT_AVERAGE_ITEM_LEVEL.." "..ilvl
end)

--- Handle Events
f:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_INVENTORY_CHANGED" then
		local unit = ...
		if UnitGUID(unit) == currentGUID then
			ScanUnit(unit, true)
		end
	elseif event == "INSPECT_READY" then
		local guid = ...

		print ( "Event: ready " .. guid)

		if guid == currentGUID then
			local spec = UnitSpec(currentUNIT)
			SpecDB[guid] = spec

			local gear = UnitGear(currentUNIT)
			GearDB[guid] = gear

			if (not gear) or (not spec) then
				ScanUnit(currentUNIT, true)
			else
				SetUnitInfo(gear, spec)
			end
		end
		self:UnregisterEvent("INSPECT_READY")
	end
end)

f:SetScript("OnUpdate", function(self, elapsed)
	print( "OnUpdate")
	self.nextUpdate = (self.nextUpdate or 0) - elapsed
	if (self.nextUpdate > 0) then return end

	self:Hide()
	ClearInspectPlayer()

	if currentUNIT and (UnitGUID(currentUNIT) == currentGUID) then
		self.lastUpdate = GetTime()
		self:RegisterEvent("INSPECT_READY")
		NotifyInspect(currentUNIT)
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local _, unit = self:GetUnit()

	if (not unit) or (not CanInspect(unit)) then return end
	if (UnitLevel(unit) > 0) and (UnitLevel(unit) < 10) then return end

	currentUNIT, currentGUID = unit, UnitGUID(unit)
	print( "Start scan unit")
	ScanUnit(unit)
end)


----------------------------------------------------------------------------------------
--	Target Talents(TipTacTalents by Aezay)
----------------------------------------------------------------------------------------
-- Constants
local TALENTS_PREFIX = SPECIALIZATION..":|cffffffff "
local CACHE_SIZE = 25
local INSPECT_DELAY = 0.2
local INSPECT_FREQ = 2

-- Variables
local ttt = CreateFrame("Frame", "TipTacTalents")
local cache = {}
local current = {}

-- Time of the last inspect reuqest. Init this to zero, just to make sure. This is a global so other addons could use this variable as well
lastInspectRequest = 0

-- Allow these to be accessed through other addons
ttt.cache = cache
ttt.current = current
ttt:Hide()

----------------------------------------------------------------------------------------
--	Gather Talents
----------------------------------------------------------------------------------------
local function GatherTalents(mouseover)
	if mouseover == 1 then
		local id = GetInspectSpecialization("mouseover")
		local currentSpecName = id and select(2, GetSpecializationInfoByID(id)) or "Loading..."
		current.tree = currentSpecName
	else
		local currentSpec = GetSpecialization()
		local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "No Talents"
		current.tree = currentSpecName
	end

	-- Set the tips line output, for inspect, only update if the tip is still showing a unit
	if mouseover == 0 then
		GameTooltip:AddLine(TALENTS_PREFIX..current.tree)
	elseif GameTooltip:GetUnit() then
		for i = 2, GameTooltip:NumLines() do
			if (_G["GameTooltipTextLeft"..i]:GetText() or ""):match("^"..TALENTS_PREFIX) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("%s%s", TALENTS_PREFIX, current.tree)
				break
			end
		end
	end
	-- Organise Cache
	local cacheSize = CACHE_SIZE
	for i = #cache, 1, -1 do
		if current.name == cache[i].name then
			tremove(cache, i)
			break
		end
	end
	if #cache > cacheSize then
		tremove(cache, 1)
	end
	-- Cache the new entry
	if cacheSize > 0 then
		cache[#cache + 1] = CopyTable(current)
	end
end

----------------------------------------------------------------------------------------
--	Event Handling
----------------------------------------------------------------------------------------
-- OnEvent
ttt:SetScript("OnEvent", function(self, event, guid)
	self:UnregisterEvent(event)
	if guid == current.guid then
		GatherTalents(1)
	end
end)

-- OnUpdate
ttt:SetScript("OnUpdate", function(self, elapsed)
	self.nextUpdate = (self.nextUpdate - elapsed)
	if self.nextUpdate <= 0 then
		self:Hide()
		-- Make sure the mouseover unit is still our unit
		if UnitGUID("mouseover") == current.guid then
			lastInspectRequest = GetTime()
			self:RegisterEvent("INSPECT_READY")
			-- Az: Fix the blizzard inspect copypasta code (Blizzard_InspectUI\InspectPaperDollFrame.lua @ line 23)
			if InspectFrame then
				InspectFrame.unit = "player"
			end
			NotifyInspect(current.unit)
		end
	end
end)

-- HOOK: OnTooltipSetUnit
GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
	-- Abort any delayed inspect in progress
	ttt:Hide()
	-- Get the unit -- Check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
	local _, unit = self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		if mFocus and mFocus.unit then
			unit = mFocus.unit
		end
	end
	-- No Unit or not a Player
	if not unit or not UnitIsPlayer(unit) then
		return
	end
	-- Only bother for players over level 9
	local level = UnitLevel(unit)
	if level > 9 or level == -1 then
		-- Wipe Current Record
		wipe(current)
		current.unit = unit
		current.name = UnitName(unit)
		current.guid = UnitGUID(unit)
		-- No need for inspection on the player
		if UnitIsUnit(unit, "player") then
			GatherTalents(0)
			return
		end
		-- Show Cached Talents, If Available
		local isInspectOpen = (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown())
		local cacheLoaded = false
		for _, entry in ipairs(cache) do
			if current.name == entry.name and not isInspectOpen then
				self:AddLine(TALENTS_PREFIX..entry.tree)
				current.tree = entry.tree
				cacheLoaded = true
				break
			end
		end
		-- Queue an inspect request
		if CanInspect(unit) and not isInspectOpen then
			local lastInspectTime = GetTime() - lastInspectRequest
			ttt.nextUpdate = (lastInspectTime > INSPECT_FREQ) and INSPECT_DELAY or (INSPECT_FREQ - lastInspectTime + INSPECT_DELAY)
			ttt:Show()
			if not cacheLoaded then
				self:AddLine(TALENTS_PREFIX.."Loading...")
			end
		elseif isInspectOpen then
			self:AddLine(TALENTS_PREFIX.."Inspect Frame is open")
		end
	end
end)

]]

----------------------------------------------------------------------------------------
--	Adds guild rank to tooltips(GuildRank by Meurtcriss)
----------------------------------------------------------------------------------------
--if true then
--	GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
--		-- Get the unit
--		local _, unit = self:GetUnit()
--		if not unit then
--			local mFocus = GetMouseFocus()
--			if mFocus and mFocus.unit then
--				unit = mFocus.unit
--			end
--		end
--		-- Get and display guild rank
--		if UnitIsPlayer(unit) then
--			local guildName, guildRank = GetGuildInfo(unit)
--			if guildName then
--				self:AddDoubleLine(RANK..":", "|cffffffff" .. guildRank.."|r")
--			end
--		end
--	end)
--end


--------------------------------------------------------------------------------------
--	Fix compare tooltips(by Blizzard)(../FrameXML/GameTooltip.lua)
--------------------------------------------------------------------------------------
--hooksecurefunc("GameTooltip_ShowCompareItem", function(self, shift)
--	if not self then
--		self = GameTooltip
--	end

--	-- Find correct side
--	local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
--	local primaryItemShown, secondaryItemShown = shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
--	local side = "left"
--	local rightDist = 0
--	local leftPos = self:GetLeft()
--	local rightPos = self:GetRight()

--	if not rightPos then
--		rightPos = 0
--	end
--	if not leftPos then
--		leftPos = 0
--	end

--	rightDist = GetScreenWidth() - rightPos

--	if leftPos and (rightDist < leftPos) then
--		side = "left"
--	else
--		side = "right"
--	end

--	-- See if we should slide the tooltip
--	if self:GetAnchorType() and self:GetAnchorType() ~= "ANCHOR_PRESERVE" then
--		local totalWidth = 0
--		if primaryItemShown then
--			totalWidth = totalWidth + shoppingTooltip1:GetWidth()
--		end
--		if secondaryItemShown then
--			totalWidth = totalWidth + shoppingTooltip2:GetWidth()
--		end

--		if side == "left" and totalWidth > leftPos then
--			self:SetAnchorType(self:GetAnchorType(), totalWidth - leftPos, 0)
--		elseif side == "right" and (rightPos + totalWidth) > GetScreenWidth() then
--			self:SetAnchorType(self:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0)
--		end
--	end

--	-- Anchor the compare tooltips
--	if secondaryItemShown then
--		shoppingTooltip2:SetOwner(self, "ANCHOR_NONE")
--		shoppingTooltip2:ClearAllPoints()
--		if side and side == "left" then
--			shoppingTooltip2:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, -10)
--		else
--			shoppingTooltip2:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, -10)
--		end

--		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
--		shoppingTooltip1:ClearAllPoints()

--		if side and side == "left" then
--			shoppingTooltip1:SetPoint("TOPRIGHT", shoppingTooltip2, "TOPLEFT", -3, 0)
--		else
--			shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip2, "TOPRIGHT", 3, 0)
--		end
--	else
--		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
--		shoppingTooltip1:ClearAllPoints()

--		if side and side == "left" then
--			shoppingTooltip1:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, -10)
--		else
--			shoppingTooltip1:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, -10)
--		end

--		shoppingTooltip2:Hide()
--	end

--	shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
--	shoppingTooltip1:Show()
--end)



--local StoryTooltip = QuestScrollFrame.StoryTooltip
--StoryTooltip:SetFrameLevel(4)

--local tooltips = {
--	GameTooltip,
--	ItemRefTooltip,
--	ShoppingTooltip1,
--	ShoppingTooltip2,
--	WorldMapTooltip,
--	WorldMapCompareTooltip1,
--	WorldMapCompareTooltip2,
--	FriendsTooltip,
--	ItemRefShoppingTooltip1,
--	ItemRefShoppingTooltip2,
--	AtlasLootTooltip,
--	QuestHelperTooltip,
--	QuestGuru_QuestWatchTooltip,
--	StoryTooltip
--}

--local backdrop = {
--	bgFile = blank, edgeFile = blank, edgeSize = 1,
--	insets = {left = -1, right = -1, top = -1, bottom = -1}
--}

--local style = {
--	bgFile =  texture,
--	edgeFile = glow,
--	edgeSize = 4,
--	insets = { left = 3, right = 3, top = 3, bottom = 3 }
--}

--function CreateStyleTT(f, size, level, alpha, alphaborder)
--	if f.shadow then return end
--	local shadow = CreateFrame("Frame", nil, f)
--	shadow:SetFrameLevel(level or 0)
--	shadow:SetFrameStrata(f:GetFrameStrata())
--	shadow:SetPoint("TOPLEFT", -2, 2)
--	shadow:SetPoint("BOTTOMRIGHT", 2, -9)
--	shadow:SetBackdrop(style)
--	shadow:SetBackdropColor(.08,.08,.08, alpha or .9)
--	shadow:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
--	f.shadow = shadow
--	return shadow
--end

--for _, tt in pairs(tooltips) do
--	if IsAddOnLoaded("Aurora") then
--		tt:SetBackdrop(nil)
--		if tt.BackdropFrame then
--			tt.BackdropFrame:SetBackdrop(nil)
--		end
--		local bg = CreateFrame("Frame", nil, tt)
--		bg:SetPoint("TOPLEFT")
--		bg:SetPoint("BOTTOMRIGHT")
--		bg:SetFrameLevel(tt:GetFrameLevel() - 1)

--		CreateStyleTT(bg, 1)


--		tt.GetBackdrop = function() return backdrop end
--		tt.GetBackdropColor = function() return 0, 0, 0, 0.7 end
--		tt.GetBackdropBorderColor = function() return 0.37, 0.3, 0.3, 1 end
--	end
--end



---- Hide PVP text
--PVP_ENABLED = ""

---- Statusbar
--local healthBar = GameTooltipStatusBar
--healthBar:ClearAllPoints()
--healthBar:SetHeight(6)
--healthBar:SetPoint("TOPLEFT", healthBar:GetParent(), "BOTTOMLEFT", 5, 5)
--healthBar:SetPoint("TOPRIGHT", healthBar:GetParent(), "BOTTOMRIGHT", -5, 5)
--healthBar:SetStatusBarTexture( texture)

-- Add "Targeted By" line
--local targetedList = {}
--local ClassColors = {}
--local token

--for class, color in next, RAID_CLASS_COLORS do
--	ClassColors[class] = ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
--end

--local function AddTargetedBy()
--	local numParty, numRaid = GetNumSubgroupMembers(), GetNumGroupMembers()
--	if numParty > 0 or numRaid > 0 then
--		for i = 1, (numRaid > 0 and numRaid or numParty) do
--			local unit = (numRaid > 0 and "raid"..i or "party"..i)
--			if UnitIsUnit(unit.."target", token) and not UnitIsUnit(unit, "player") then
--				local _, class = UnitClass(unit)
--				targetedList[#targetedList + 1] = ClassColors[class]
--				targetedList[#targetedList + 1] = UnitName(unit)
--				targetedList[#targetedList + 1] = "|r, "
--			end
--		end
--		if #targetedList > 0 then
--			targetedList[#targetedList] = nil
--			GameTooltip:AddLine(" ", nil, nil, nil, 1)
--			local line = _G["GameTooltipTextLeft"..GameTooltip:NumLines()]
--			if not line then return end
--			line:SetFormattedText("Targeted By".." (|cffffffff%d|r): %s", (#targetedList + 1) / 3, table.concat(targetedList))
--			wipe(targetedList)
--		end
--	end
--end

----------------------------------------------------------------------------------------
--	Your instance lock status in tooltip(Instance Lock Compare by Dridzt)
	------------------------------------------------------------------------------------------
	--local myTip = CreateFrame("GameTooltip", "InstanceLockTooltip", nil, "GameTooltipTemplate")

	--local function ILockCompare(frame, link, ...)
	--	if not frame or not link then return end

	--	local linkType = string.match(link, "(instancelock):")
	--	if linkType == "instancelock" then
	--		local mylink, templink
	--		local myguid = UnitGUID("player")
	--		local guid = string.match(link, "instancelock:([^:]+)")

	--		if guid ~= myguid then
	--			local instanceguid = string.match(link, "instancelock:[^:]+:(%d+):")
	--			local numsaved = GetNumSavedInstances()
	--			if numsaved > 0 then
	--				for i = 1, numsaved do
	--					local locked, extended = select(5, GetSavedInstanceInfo(i))
	--					if extended or locked then
	--						templink = GetSavedInstanceChatLink(i)
	--						local myinstanceguid = string.match(templink, "instancelock:[^:]+:(%d+):")
	--						if myinstanceguid == instanceguid then
	--							mylink = string.match(templink, "(instancelock:[^:]+:%d+:%d+:%d+)")
	--							break
	--						end
	--					end
	--				end
	--				mylink = mylink or string.gsub(link, "(instancelock:)([^:]+)(:%d+:%d+:)(%d+)", function(a, g, b, k) g = myguid; k = "0"; return a..g..b..k end)
	--			else
	--				mylink = string.gsub(link, "(instancelock:)([^:]+)(:%d+:%d+:)(%d+)", function(a, g, b, k) g = myguid; k = "0"; return a..g..b..k end)
	--			end
	--		end

	--		if mylink then
	--			if not myTip:IsVisible() and frame:IsVisible() then
	--				myTip:SetParent(frame)
	--				myTip:SetOwner(frame, "ANCHOR_NONE")
	--				CreateStyle(myTip, 2)

	--				local side = "left"
	--				local rightDist = 0
	--				local leftPos = frame:GetLeft()
	--				local rightPos = frame:GetRight()
	--				if not rightPos then
	--					rightPos = 0
	--				end
	--				if not leftPos then
	--					leftPos = 0
	--				end
	--				rightDist = GetScreenWidth() - rightPos
	--				if leftPos and (rightDist < leftPos) then
	--					side = "left"
	--				else
	--					side = "right"
	--				end
	--				myTip:ClearAllPoints()
	--				if side == "left" then
	--					myTip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -3, -10)
	--				elseif side == "right" then
	--					myTip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 3, -10)
	--				end
	--				myTip:SetHyperlink(mylink)
	--				myTip:Show()
	--			end
	--		end
	--	end
	--end

	--ItemRefTooltip:HookScript("OnDragStop", function(self, button)
	--	if myTip:IsVisible() and (myTip:GetParent():GetName() == self:GetName()) then
	--		local side = "left"
	--		local rightDist = 0
	--		local leftPos = self:GetLeft()
	--		local rightPos = self:GetRight()
	--		if not rightPos then
	--			rightPos = 0
	--		end
	--		if not leftPos then
	--			leftPos = 0
	--		end
	--		rightDist = GetScreenWidth() - rightPos
	--		if leftPos and (rightDist < leftPos) then
	--			side = "left"
	--		else
	--			side = "right"
	--		end
	--		myTip:ClearAllPoints()
	--		if side == "left" then
	--			myTip:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, -10)
	--		elseif side == "right" then
	--			myTip:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, -10)
	--		end
	--	end
	--end)

	--hooksecurefunc(GameTooltip, "SetHyperlink", ILockCompare)
	--hooksecurefunc(ItemRefTooltip,"SetHyperlink", ILockCompare)


----------------------------------------------------------------------------------------
--	Based on tekKompare(by Tekkub)
----------------------------------------------------------------------------------------
--local orig1, orig2, GameTooltip = {}, {}, GameTooltip
--local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true, currency = true}

--local function OnHyperlinkEnter(frame, link, ...)
--	local linktype = link:match("^([^:]+)")
--	if linktype and linktype == "battlepet" then
--		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", -3, 50)
--		GameTooltip:Show()
--		local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", link)
--		BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed))
--	elseif linktype and linktypes[linktype] then
--		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", -3, 50)
--		GameTooltip:SetHyperlink(link)
--		GameTooltip:Show()
--	end

--	if orig1[frame] then return orig1[frame](frame, link, ...) end
--end

--GameTooltip:HookScript("OnTooltipSetUnit", function(self, ...)
--	local _, instanceType = IsInInstance()
--	if instanceType == "scenario" then return end
--	local _, unit = GameTooltip:GetUnit()
--	if unit and UnitIsPlayer(unit) and ((UnitInParty(unit) or UnitInRaid(unit)) and GetNumGroupMembers() > 0) then
--		GameTooltip:AddDoubleLine(ROLE..":", GetLFDRole(unit), 1, 1, 0)
--	end
--end)


----------------------------------------------------------------------------------------
--	Fix GameTooltipMoneyFrame font size
----------------------------------------------------------------------------------------
--local function FixFont(self)
--	for i = 1, 2 do
--		if _G["GameTooltipMoneyFrame"..i] then
--			_G["GameTooltipMoneyFrame"..i.."PrefixText"]:SetFontObject("GameTooltipText")
--			_G["GameTooltipMoneyFrame"..i.."SuffixText"]:SetFontObject("GameTooltipText")
--			_G["GameTooltipMoneyFrame"..i.."GoldButton"]:SetNormalFontObject("GameTooltipText")
--			_G["GameTooltipMoneyFrame"..i.."SilverButton"]:SetNormalFontObject("GameTooltipText")
--			_G["GameTooltipMoneyFrame"..i.."CopperButton"]:SetNormalFontObject("GameTooltipText")
--		end
--	end
--	for i = 1, 2 do
--		if _G["ItemRefTooltipMoneyFrame"..i] then
--			_G["ItemRefTooltipMoneyFrame"..i.."PrefixText"]:SetFontObject("GameTooltipText")
--			_G["ItemRefTooltipMoneyFrame"..i.."SuffixText"]:SetFontObject("GameTooltipText")
--			_G["ItemRefTooltipMoneyFrame"..i.."GoldButton"]:SetNormalFontObject("GameTooltipText")
--			_G["ItemRefTooltipMoneyFrame"..i.."SilverButton"]:SetNormalFontObject("GameTooltipText")
--			_G["ItemRefTooltipMoneyFrame"..i.."CopperButton"]:SetNormalFontObject("GameTooltipText")
--		end
--	end
--end

--GameTooltip:HookScript("OnTooltipSetItem", FixFont)
--ItemRefTooltip:HookScript("OnTooltipSetItem", FixFont)