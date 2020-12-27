-- [spellID] = true / false ( buff / debuff)
local L, yo, n = unpack( select( 2, ...))

local _G = _G
local next, pairs, UnitGUID, strsplit, tonumber, GetInstanceInfo, GameTooltip, UnitFactionGroup, floor, print
	= next, pairs, UnitGUID, strsplit, tonumber, GetInstanceInfo, GameTooltip, UnitFactionGroup, floor, print

local npcVals
--local LOP = n.LIBS.LOP

local function HasTeeming( affixes)
	if (next(affixes) ~= nil) then
		for k, v in pairs(affixes) do
			if v == 5 then
				return true;
			end
		end
	end
	return false;
end

local function MouseoverUnitID()
	local guid = UnitGUID("mouseover");
	if (guid ~= nil) then
		local _, _, _, _, _, guidSplit = strsplit("-", guid);
		return tonumber(guidSplit);
	end
	return nil;
end
--https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/AddOns/Blizzard_APIDocumentation/ChallengeModeInfoDocumentation.lua

local function resolve_npc_progress_value(npc_id, is_teeming)
  	local value = nil

  	if npcVals and npcVals[npc_id] then
		for val, count in pairs( npcVals[npc_id]) do
			value = val
		end
  	end

  	return value
end

local function OnEvent( self, event, ...)

	if event == "UPDATE_MOUSEOVER_UNIT"
		--and C_Scenario.IsInScenario
		then
		local npcID = MouseoverUnitID();
		--local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
		--local mapID, _ = currentZoneID

		if npcID ~= nil then

  			local _, _, steps = C_Scenario.GetStepInfo()
  			if not steps or steps <= 0 then return end

			--local weight = LOP:GetNPCWeightByMap( mapID, npcID, isTeeming, isAlternate);
			local value = resolve_npc_progress_value( npcID)
			if (value ~= nil) then

				local absolute_number = " /|cff00ffff +" .. value .. "%|r"
				local name, _, _, _, final_value = C_Scenario.GetCriteriaInfo(steps)
  				local quantity_percent = (value / final_value) * 100
  				local mult = 10 ^ 2
  				quantity_percent = floor(quantity_percent * mult + 0.5) / mult
  				if (quantity_percent > 100) then
    				quantity_percent = 100
  				end

  				GameTooltip:AddDoubleLine( "yo " .. name .. ":", "|cffffff00+" .. quantity_percent .. "%|r" .. absolute_number, 1, 1, 0, 1, 1, 0)
				GameTooltip:Show()
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if _G.MythicPlusTimerDB then
			npcVals = _G.MythicPlusTimerDB.config.npc_progress
		end

		if not yo.Addons.mythicProcents then
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			self:SetScript("OnEvent", nil)
		end
	end
end

local Amarker = CreateFrame("Frame")
Amarker:RegisterEvent("PLAYER_ENTERING_WORLD")
Amarker:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
Amarker:SetScript("OnEvent", OnEvent)



--local a, b, steps, c = C_Scenario.GetStepInfo();
--local name, _, status, curValue = C_Scenario.GetCriteriaInfo( steps);
--if curValue then
--	local appendString = string.format("|cff00ff00%.2f%%|r / |cffff0000%.2f%%", value, curValue);
--	GameTooltip:AddDoubleLine( name, appendString)
--end