local addonName, ns = ...
local L, yo, n = unpack( ns)

local tonumber, print, IsInGroup, IsInRaid, UnitGroupRolesAssigned
	= tonumber, print, IsInGroup, IsInRaid, UnitGroupRolesAssigned

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local check = function(self, event, prefix, message, _, sender)

	if event == "CHAT_MSG_ADDON" then
		if prefix ~=  addonName or sender == n.myName then return end
		if tonumber(message) ~= nil and tonumber(message) > tonumber(n.version) then
			print("|cffff0000"..L.UI_OUTDATED.."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end

	elseif event == "GUILD_ROSTER_UPDATE" then
		C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "GUILD")

	else
		n.myRole = UnitGroupRolesAssigned( "player")

		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "INSTANCE_CHAT")
		elseif IsInRaid(LE_PARTY_CATEGORY_HOME)  then C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "RAID")
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "PARTY")
		--elseif IsInGuild() then						  C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "GUILD")
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:SetScript("OnEvent", check)
C_ChatInfo.RegisterAddonMessagePrefix( addonName)
