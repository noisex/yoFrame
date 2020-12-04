local addonName, ns = ...
local L, yo, n = unpack( ns)

L_MISC_UI_OUTDATED = "Звиняйте, хлопці, но ваш |cff00ffffyoFrame|r безбожно устарел!!! Подумайте об этом на досуге..."

local tonumber, print, IsInGroup
	= tonumber, print, IsInGroup


local check = function(self, event, prefix, message, _, sender)

	if event == "CHAT_MSG_ADDON" then
		if prefix ~=  addonName or sender == yo.myName then return end
		if tonumber(message) ~= nil and tonumber(message) > tonumber(n.version) then
			print("|cffff0000"..L_MISC_UI_OUTDATED.."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end

	elseif event == "GUILD_ROSTER_UPDATE" then
		C_ChatInfo.SendAddonMessage( addonName, tonumber(n.version), "GUILD")

	else
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

----------------------------------------------------------------------------------------
--	Whisper UI version
----------------------------------------------------------------------------------------
--local whisp = CreateFrame("Frame")
--whisp:RegisterEvent("CHAT_MSG_WHISPER")
--whisp:RegisterEvent("CHAT_MSG_BN_WHISPER")
--whisp:SetScript("OnEvent", function(_, event, text, name, ...)
--	if text:lower():match("ui_version") or text:lower():match("уи_версия") then
--		if event == "CHAT_MSG_WHISPER" then
--			SendChatMessage("ShestakUI "..n.version, "WHISPER", nil, name)
--		elseif event == "CHAT_MSG_BN_WHISPER" then
--			BNSendWhisper(select(11, ...), "ShestakUI "..n.version)
--		end
--	end
--end)

--hooksecurefunc("SetItemRef", function(self, ...)
--	print("...")
--end)