local addon, ns = ...
local L, yo, n = unpack( ns)

----------------------------------------------------------------------------------------
--	Auto invite by whisper(by Tukz)
----------------------------------------------------------------------------------------

local inviteOK = {
	["инв"] = true,
	["inv"] = true,
	["byd"] = true,
	["штм"] = true,
	["123"] = true,
	   = true,
	["+"]	= true,
}

local leaderOK = {
	["!leader"] = true,
	["!lider"] 	= true,
	["!лидер"] 	= true,
	["!лидера"]	= true,
	["!дай"] 	= true,
	["!отдай"] 	= true,
	["!дшвук"] 	= true,
	["!kblth"] 	= true,
}

local function IsFriend( name)
	for i = 1, C_FriendList.GetNumFriends() do
		if( C_FriendList.GetFriendInfoByIndex( i).name == name) then
			return true
		end
	end
	if( IsInGuild()) then
		for i = 1, GetNumGuildMembers() do
			if( strsplit( "-", GetGuildRosterInfo( i) or "?") == name) then
				return true
			end
		end
	end
	local b, a = BNGetNumFriends()
	for i = 1, a do
		local bN = C_BattleNet.GetFriendAccountInfo(i) --select( 5, BNGetFriendInfo( i))
		local bName = bN.isBattleTagFriend
		if bName == name then
			return true
		end
	end
end

local function OnEvent( self, event, arg1, arg2, ...)

	if event == "PARTY_INVITE_REQUEST" then
		if not yo.Addons.AutoInvaitFromFriends then return end

		local nameinv, _ = arg1
		nameinv = strsplit( "-", nameinv) -- and ExRT.F.delUnitNameServer(nameinv)
		if nameinv and (IsFriend( nameinv)) and not QueueStatusMinimapButton:IsShown() then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which=="PARTY_INVITE" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE")
					return
				elseif frame:IsVisible() and frame.which=="PARTY_INVITE_XREALM" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE_XREALM")
					return
				end
			end
		end
	end

	if yo.Addons.AutoInvite then
		if ( not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and
			not QueueStatusMinimapButton:IsShown() and inviteOK[arg1:lower()] then  ---
			--for match in string.gmatch( " инв inv byd штм 123 ", " " .. arg1:lower() .. " ") do
			if event == "CHAT_MSG_WHISPER" then
				C_PartyInfo.InviteUnit(arg2)
			elseif event == "CHAT_MSG_BN_WHISPER" then
				local bnetIDAccount = select(11, ...)
				local bnetIDGameAccount = select(6, BNGetFriendInfoByID(bnetIDAccount))
				BNInviteFriend(bnetIDGameAccount)
			end
		end
	end

	if yo.Addons.AutoLeader then
		if ( UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))
			and ( UnitInParty( strsplit( "-", arg2)) or UnitInRaid( strsplit( "-", arg2)))
			and UnitIsInMyGuild( strsplit( "-", arg2))
			and leaderOK[arg1:lower()]
				then

			if event == "CHAT_MSG_WHISPER" then
				PromoteToLeader(strsplit( "-", arg2))

			elseif event == "CHAT_MSG_BN_WHISPER" then
				local bnetIDAccount = select(11, ...)
				local bnetIDGameAccount = select(6, BNGetFriendInfoByID(bnetIDAccount))
				PromoteToLeader(bnetIDGameAccount)
			end
		end
	end
end

local autoinvite = CreateFrame("Frame")
	if yo.Addons.AutoInvite or yo.Addons.AutoLeader then
		autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
		autoinvite:RegisterEvent("CHAT_MSG_BN_WHISPER")
	end
	autoinvite:RegisterEvent("PARTY_INVITE_REQUEST")
	autoinvite:SetScript("OnEvent", OnEvent)
