local L, yo = unpack( select( 2, ...))

if not yo.ToolTip.enable then return end

local _G = _G

local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, tonumber, strfind, GetItemCount, GameTooltip, GetItemGem, ipairs
	= hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, tonumber, strfind, GetItemCount, GameTooltip, GetItemGem, ipairs

local cY, cW = "|cffffff00", "|cffffffff"

local types = {
	spell = "SpellID:",
	item    = "ItemID:",
	unit = "NPC ID:",
	quest = "QuestID:",
	talent = "TalentID:",
	achievement = "AchievementID:",
	criteria = "CriteriaID:",
	ability = "AbilityID:",
	currency = "CurrencyID:",
	artifactpower = "ArtifactPowerID:",
	enchant = "EnchantID:",
	bonus = "BonusID:",
	gem = "GemID:"
}

local function addLine(tooltip, id, type)
	if not yo.ToolTip.IDInToolTip then return end

	local found = false

	-- Check if we already added to this tooltip. Happens on the talent frame
	for i = 1, 15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local text

		if frame then text = frame:GetText() end
		if text and text == type then found = true break end
	end

	if not found then
		tooltip:AddDoubleLine(type, "|cffffffff" .. id)
		tooltip:Show()
	end
end

-- All types, primarily for detached tooltips
local function onSetHyperlink(self, link)
	local type, id = string.match(link,"^(%a+):(%d+)")
	if not type or not id then return end
	if type == "spell" or type == "enchant" or type == "trade" then
	addLine(self, id, types.spell)
	elseif type == "talent" then
	addLine(self, id, types.talent)
	elseif type == "quest" then
	addLine(self, id, types.quest)
	elseif type == "achievement" then
	addLine(self, id, types.achievement)
	elseif type == "item" then
	addLine(self, id, types.item)
	elseif type == "currency" then
	addLine(self, id, types.currency)
	end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spells
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
	local id = select(10, UnitBuff(...))
	if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(10, UnitDebuff(...))
	if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(10, UnitAura(...))
	if id then addLine(self, id, types.spell) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip, id, types.spell) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select( 2, self:GetSpell())
	if id then addLine(self, id, types.spell) end
end)

-- Artifact Powers
hooksecurefunc(GameTooltip, "SetArtifactPowerByID", function(self, powerID)
	local powerInfo = C_ArtifactUI.GetPowerInfo(powerID)
	local spellID = powerInfo.spellID
	if powerID then addLine(self, powerID, types.artifactpower) end
	if spellID then addLine(self, spellID, types.spell) end
end)

-- NPCs
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if C_PetBattles.IsInBattle() then return end
	local unit = select(2, self:GetUnit())
	if unit then
	local guid = UnitGUID(unit) or ""
	local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
	if id and guid:match("%a+") ~= "Player" then addLine(GameTooltip, id, types.unit) end
	end
end)

-- Items
local function attachItemTooltip(self)
	local link = select(2, self:GetItem())
	if not link then return end

	local itemString = string.match(link, "item:([%-?%d:]+)")
	if not itemString then return end

	local enchantid = ""
	local bonusid = ""
	local gemid = ""
	local bonuses = {}
	local itemSplit = {}

	for v in string.gmatch(itemString, "(%d*:?)") do
	if v == ":" then
		itemSplit[#itemSplit + 1] = 0
	else
		itemSplit[#itemSplit + 1] = string.gsub(v, ':', '')
	end
	end

	for index = 1, tonumber(itemSplit[13]) do
	bonuses[#bonuses + 1] = itemSplit[13 + index]
	end

	local gems = {}
	for i=1, 4 do
	local _,gemLink = GetItemGem(link, i)
	if gemLink then
		local gemDetail = string.match(gemLink, "item[%-?%d:]+")
		gems[#gems + 1] = string.match(gemDetail, "item:(%d+):")
	elseif flags == 256 then
		gems[#gems + 1] = "0"
	end
	end

	local id = string.match(link, "item:(%d*)")

	if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
	local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
	for i = 1, 8 do
		if GetMouseFocus().reagentIndex == i then
		id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d*)") or nil
		break
		end
	end
	end

	if id and id ~= "" then

	----------------------------------------------------------------
	---     ITEM COUNT
	----------------------------------------------------------------
	local numTotal = GetItemCount(id, true)
	local oneDate

	if id ~= "6948" then
		if yo.Bags.showAltBags and yo.Bags.countAltBags then
			for name, player in pairs( yo_BBCount[yo.myRealm]) do
			id = tonumber(id)
			if name ~= yo.myName and player[id] then
				if not oneDate then
					self:AddLine(" ")
					oneDate = true
				end
				self:AddDoubleLine( name, player[id], 1, 1, 0, 1, 1, 1)
			end
		end
	end

	end

	if numTotal > 1 then
		local item_count, itemBank = "", ""
		local numBag = GetItemCount(id, false)
		local numBank = numTotal - numBag

		if numBank and numBank > 0 then
		itemBank = cW .. " ( " .. L["BAG"] .. ": " .. numBag .. ", " ..L["BANK"] .. ": " .. numBank .. ")"
		end

		if not oneDate then
		self:AddLine(" ")
		oneDate = true
		end
		self:AddDoubleLine( yo.myName, numTotal .. itemBank, 1, 1, 0, 1, 1, 1)
	end
	self:AddLine(" ")

	----------------------------------------------------------------
	---     ITEM COUNT ( END)
	----------------------------------------------------------------

	addLine(self, id, types.item)
	if itemSplit[2] ~=0 then
		enchantid = itemSplit[2]
		addLine(self, enchantid, types.enchant)
	end
	if #bonuses > 0 then
		bonusid = table.concat(bonuses, '/')
		addLine(self, bonusid, types.bonus)
	end
	if #gems > 0 then
		gemid = table.concat(gems, '/')
		addLine(self, gemid, types.gem)
	end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)


-- Achievement Frame Tooltips
local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, what)
	if what == "Blizzard_AchievementUI" then
	for i,button in ipairs(AchievementFrameAchievementsContainer.buttons) do
		button:HookScript("OnEnter", function()
		GameTooltip:SetOwner(button, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
		addLine(GameTooltip, button.id, types.achievement)
		GameTooltip:Show()
		end)
		button:HookScript("OnLeave", function()
		GameTooltip:Hide()
		end)

		local hooked = {}
		hooksecurefunc("AchievementButton_GetCriteria", function(index, renderOffScreen)
		local frame = _G["AchievementFrameCriteria" .. (renderOffScreen and "OffScreen" or "") .. index]
		if frame and not hooked[frame] then
			frame:HookScript("OnEnter", function(self)
			local button = self:GetParent() and self:GetParent():GetParent()
			if not button or not button.id then return end
			local criteriaid = select(10, GetAchievementCriteriaInfo(button.id, index))
			if criteriaid then
				GameTooltip:SetOwner(button:GetParent(), "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
				addLine(GameTooltip, button.id, types.achievement)
				addLine(GameTooltip, criteriaid, types.criteria)
				GameTooltip:Show()
			end
			end)
			frame:HookScript("OnLeave", function()
			GameTooltip:Hide()
			end)
			hooked[frame] = true
		end
		end)
	end
	end
end)

-- Pet battle buttons
hooksecurefunc("PetBattleAbilityButton_OnEnter", function(self)
	local petIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
	if ( self:GetEffectiveAlpha() > 0 ) then
	local id = select(1, C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, petIndex, self:GetID()))
	if id then
		local oldText = PetBattlePrimaryAbilityTooltip.Description:GetText(id)
		PetBattlePrimaryAbilityTooltip.Description:SetText(oldText .. "\r\r" .. types.ability .. "|cffffffff " .. id .. "|r")
	end
	end
end)

-- Pet battle auras
hooksecurefunc("PetBattleAura_OnEnter", function(self)
	local parent = self:GetParent()
	local id = select(1, C_PetBattles.GetAuraInfo(parent.petOwner, parent.petIndex, self.auraIndex))
	if id then
	local oldText = PetBattlePrimaryAbilityTooltip.Description:GetText(id)
	PetBattlePrimaryAbilityTooltip.Description:SetText(oldText .. "\r\r" .. types.ability .. "|cffffffff " .. id .. "|r")
	end
end)

-- Currencies
hooksecurefunc(GameTooltip, "SetCurrencyToken", function(self, index)
	local id = tonumber(string.match( C_CurrencyInfo.GetCurrencyListLink(index),"currency:(%d+)"))
	if id then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyByID", function(self, id)
	 if id then addLine(self, id, types.currency) end
end)

hooksecurefunc(GameTooltip, "SetCurrencyTokenByID", function(self, id)
	 if id then addLine(self, id, types.currency) end
end)

-- Quests
do
	local function questhook(self)
	if self.questID then addLine(GameTooltip, self.questID, types.quest) end
	end
	local titlebuttonshooked = {}
	--BFA
	-- hooksecurefunc("QuestLogQuests_GetTitleButton", function(index)
	-- local titles = QuestMapFrame.QuestsFrame.Contents.Titles;
	-- if titles[index] and not titlebuttonshooked[index] then
		-- titles[index]:HookScript("OnEnter", questhook)
		-- titlebuttonshooked[index] = true
	-- end
	-- end)
end

hooksecurefunc("TaskPOI_OnEnter", function(self) if self and self.questID then addLine(GameTooltip, self.questID, types.quest) end end)

--GameTooltip:HookScript("SetHyperlink", function(self, ...)

--hooksecurefunc(GameTooltip, "Show", function(self, ...)
--	print("-- ", GameTooltip:GetOwner(), GameTooltip:GetAnchorType())
--    	if not InCombatLockdown() then
--		if not GameTooltip:IsClampedToScreen() then
--	    	--GameTooltip:SetClampedToScreen( true)
--	    	print("|cffff0000DEV: |cffbbbbbbGameToolTip over screen! But we are returned him back...|r")
--		end
--    	end
--end)
