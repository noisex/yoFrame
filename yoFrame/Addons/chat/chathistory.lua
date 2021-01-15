local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.Chat.EnableChat then return end
if not yo.Chat.showHistory then return end
----------------------------------------------------------------------------------------
--	Chat History
----------------------------------------------------------------------------------------

if yo_ChatHistory then
	for i,v in ipairs( yo_ChatHistory ) do

		for ii, vv in pairs( v) do
			local channel, sender, text, chanColor, uclass, cols = vv[2], strsplit( "-",vv[3]), vv[1], vv[4], vv[6], vv[7]
			--print(channel, sender, text, chanColor, uclass) --, RAID_CLASS_COLORS[uclass].colorStr)

			sender = "|c" .. RAID_CLASS_COLORS[ ( uclass or "PRIEST")].colorStr .. sender .. "|r"
			cols = cols or ( { ["r"] = 1, ["g"] = 1,["b"] = 1})

			local string = format("%s[%s%s]: %s|r", channel, sender, ( chanColor or "|cffffffff" ), text)
			DEFAULT_CHAT_FRAME:AddMessage( string, cols.r, cols.g, cols.b)
		end
	end
end


local function CheckLine( array)
	local maxLine, index = 30

	for i,v in ipairs(array) do index = i end

	if index and index > maxLine then
		for i=1, index - maxLine do
			tremove(array, 1)
		end
	end
end

local function SaveLine( text, channel, sender, color, senderGUID, classFilename)
		local array = {}
		array = {
			[text]	= { text, channel, sender, color, senderGUID, classFilename}
			}
		CheckLine( yo_ChatHistory)
		tinsert(yo_ChatHistory, array)
end

local function Chat_GetColoredChatName(chatType, chatTarget)
	if ( chatType == "CHANNEL" ) then
		local info = ChatTypeInfo["CHANNEL"..chatTarget];
		local colorString = format("|cff%02x%02x%02x", info.r * 255, info.g * 255, info.b * 255);
		local chanNum, channelName = GetChannelName(chatTarget);
		--return format("%s|Hchannel:channel:%d|h[%d. %s]|h|r", colorString, chanNum, chanNum, gsub(channelName, "%s%-%s.*", ""));	--The gsub removes zone-specific markings (e.g. "General - Ironforge" to "General")
		return format("%s|Hchannel:channel:%d|h[%d]|h", colorString, chanNum, chanNum), colorString, info --, gsub(channelName, "%s%-%s.*", ""));	--The gsub removes zone-specific markings (e.g. "General - Ironforge" to "General")
	elseif ( chatType == "WHISPER" ) then
		local info = ChatTypeInfo["WHISPER"];
		local colorString = format("|cff%02x%02x%02x", info.r * 255, info.g * 255, info.b * 255);
		--return format("%s[%s] |Hplayer:%3$s|h[%3$s]|h", colorString, _G[chatType], chatTarget), colorString
		return format("%s[%s] |Hplayer:%s|h", colorString, _G[chatType], chatTarget), colorString, info
	else
		local info = ChatTypeInfo[chatType];
		local colorString = format("|cff%02x%02x%02x", info.r * 255, info.g * 255, info.b * 255);
		return format("%s|Hchannel:%s|h[%s]|h", colorString, chatType, _G[chatType]), colorString, info
	end
end

--local oldChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler

--function ChatFrame_MessageEventHandler(self, event, ...)
--	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
--		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
--		--arg4 = "QQQQ"
--		--arg9 = "WWWW"
--		--print( "qwww here")
--		oldChatFrame_MessageEventHandler( self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
--	end
--end


local function OnChatHistory( self, event, ...)
	if yo_ChatHistory == nil then
		yo_ChatHistory = {}
	end
	--print( ...)
	--local myMsg = ... --HandleShortChannels( ...)
	if event:match"CHAT_MSG" then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...
		local type = strsub(event, 10)

		local chatGroup = Chat_GetChatCategory(type)
		local chatTarget
		local englishClass = "PRIEST"

		if ( chatGroup == "CHANNEL" ) then
			chatTarget = tostring(arg8)
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			--print( arg2)
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strsplit( "-", arg2) --strupper(arg2);
			else
				chatTarget = arg2;
			end
		end
		local chanName, chanColor, cols = Chat_GetColoredChatName( chatGroup, chatTarget)
		--print( chatGroup, chatTarget)
		--local text, sender, _, channel, _, _, _, _, _, _, _, senderGUID = ...
		if arg12 then
			englishClass = select( 2, GetPlayerInfoByGUID( arg12))
		end

		--SaveLine( text, chanName, sender, chanColor, senderGUID, englishClass)
		SaveLine( arg1, chanName, arg2, chanColor, arg12, englishClass, cols)

		--local body = '|Hchannel:channel:'.. arg8 ..'|h['.. "qqq"..']|h '.. arg2 .. arg1 --ChatFrame_ResolvePrefixedChannelName(arg4)
		--DEFAULT_CHAT_FRAME:AddMessage( body, cols.r, cols.g, cols.b)
	end

	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.Chat.showHistory then return end

		self:RegisterEvent("CHAT_MSG_GUILD")
		self:RegisterEvent("CHAT_MSG_PARTY")
		self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
		self:RegisterEvent("CHAT_MSG_RAID")
		self:RegisterEvent("CHAT_MSG_RAID_LEADER")

		if yo.Chat.showHistoryAll then
			self:RegisterEvent("CHAT_MSG_CHANNEL")
			self:RegisterEvent("CHAT_MSG_SAY")
			self:RegisterEvent("CHAT_MSG_YELL")
		end

		CheckLine( yo_ChatHistory)

		--for i,v in ipairs( yo_ChatHistory ) do

		--	for ii,vv in pairs( v) do
		--		local channel, sender, text, chanColor, uclass, cols = vv[2], strsplit( "-",vv[3]), vv[1], vv[4], vv[6], vv[7]
		--		--print(channel, sender, text, chanColor, uclass) --, RAID_CLASS_COLORS[uclass].colorStr)

		--		sender = "|c" .. RAID_CLASS_COLORS[ ( uclass or "PRIEST")].colorStr .. sender .. "|r"
		--		cols = cols or ( { ["r"] = 1, ["g"] = 1,["b"] = 1})

		--		local string = format("%s[%s%s]: %s|r", channel, sender, ( chanColor or "|cffffffff" ), text)
		--		DEFAULT_CHAT_FRAME:AddMessage( string, cols.r, cols.g, cols.b)
		--	end
		--end
	end
end

local chatHistory = CreateFrame("Frame")
chatHistory:RegisterEvent("PLAYER_ENTERING_WORLD")
chatHistory:SetScript("OnEvent", OnChatHistory)