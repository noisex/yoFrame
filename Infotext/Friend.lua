local addonName, ns = ...
local L = ns.L

StaticPopupDialogs.SET_BN_BROADCAST = {
	text = BN_BROADCAST_TOOLTIP,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	editBoxWidth = 350,
	maxLetters = 127,
	OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
	OnShow = function(self) self.editBox:SetText(select(4, BNGetInfo()) ) self.editBox:SetFocus() end,
	OnHide = ChatEdit_FocusActiveWindow,
	EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3
}

-- localized references for global functions (about 50% faster)
local join 			= string.join
local find			= string.find
local format		= string.format
local sort			= table.sort

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local Text  = LeftInfoPanel:CreateFontString(nil, "OVERLAY")
Text:SetFont( font, fontsize, "OVERLAY")
Text:SetHeight(LeftInfoPanel:GetHeight())
Text:SetPoint("RIGHT", LeftInfoPanel, "RIGHT", -30, 0)
Stat:SetParent(Text:GetParent())
LeftInfoPanel.friendText = Text

local menuFrame = CreateFrame("Frame", "FriendRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
	{ text = INVITE, hasArrow = true,notCheckable=true, },
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
	{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
		menuList = {
			{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
		},
	},
	{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() StaticPopup_Show("SET_BN_BROADCAST") end },
}

local function inviteClick(self, name)
	menuFrame:Hide()
	
	if type(name) ~= 'number' then
		InviteUnit(name)
	else
		BNInviteFriend(name);
	end
end

local function whisperClick(self, name, battleNet)
	menuFrame:Hide() 
	
	if battleNet then
		ChatFrame_SendSmartTell(name)
	else
		SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )		 
	end
end

local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
local clientLevelNameString = "%s |cff%02x%02x%02x(%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
local worldOfWarcraftString = WORLD_OF_WARCRAFT
local battleNetString = BATTLENET_OPTIONS_LABEL
local wowString, scString, d3String, wtcgString, appString, hotsString, owString, bsapString 	 = BNET_CLIENT_WOW, BNET_CLIENT_SC2, BNET_CLIENT_D3, BNET_CLIENT_WTCG, "App", BNET_CLIENT_HEROES, "Pro", "BSAp"  -- BNET_CLIENT_OVERWATCH
local otherGameInfoString = "%s (%s)"
local otherGameInfoString2 = "%s %s"
local totalOnlineString = FRIENDS_LIST_ONLINE .. ": %s/%s"
local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
local displayString = "%s: ".. myColorStr .. "%d|r"
local statusTable = { " |cff888888[AFK]|r ", " |cff888888[DND] |r", "" }
local gstatusTable = { " |cffFF0000[AFK]|r ", " |cff0000ff[DND] |r", "" }
local groupedTable = { "|cffaaaaaa*|r", "" } 
local friendTable, BNTable, BNTableWoW, BNTableD3, BNTableSC, BNTableWTCG, BNTableApp, BNTableHOTS, BNTableOW, BNTableBSAp = {}, {}, {}, {}, {}, {}, {}, {}, {} , {}
local tableList = {[wowString] = BNTableWoW, [d3String] = BNTableD3, [scString] = BNTableSC, [wtcgString] = BNTableWTCG, [appString] = BNTableApp, [hotsString] = BNTableHOTS, [owString] = BNTableOW, [bsapString] = BNTableBSAp}
local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","")
local dataValid = false
local totalOnline, BNTotalOnline = 0, 0


local function SortAlphabeticName(a, b)
	if a[1] and b[1] then
		return a[1] < b[1]
	end
end

local localizedMapNames = {}
local ZoneIDToContinentName = {
	[473] = "Outland",
	[477] = "Outland",
}
local MapIdLookupTable = {
	[466] = "Outland",
	[473] = "Shadowmoon Valley",
	[477] = "Nagrand",
}

local function LocalizeZoneNames()
	local localizedZoneName

	for mapID, englishName in pairs(MapIdLookupTable) do
		localizedZoneName = GetMapNameByID(mapID)
		if localizedZoneName then
			-- Add combination of English and localized name to lookup table
			if not localizedMapNames[englishName] then
				localizedMapNames[englishName] = localizedZoneName
			end
		end
	end
end
--BFA
--LocalizeZoneNames()

--Add " (Outland)" to the end of zone name for Nagrand and Shadowmoon Valley, if mapID matches Outland continent.
--We can then use this function when we need to compare the players own zone against return values from stuff like GetFriendInfo and GetGuildRosterInfo,
--which adds the " (Outland)" part unlike the GetRealZoneText() API.


function GetZoneText(zoneAreaID)
	if not zoneAreaID then return end

	local zoneName = C_Map.GetMapInfo(zoneAreaID)
	local continent = ZoneIDToContinentName[zoneAreaID]

	if continent and continent == "Outland" then
		if zoneName == localizedMapNames["Nagrand"] or zoneName == "Nagrand"  then
			zoneName = localizedMapNames["Nagrand"].." ("..localizedMapNames["Outland"]..")"
		elseif zoneName == localizedMapNames["Shadowmoon Valley"] or zoneName == "Shadowmoon Valley"  then
			zoneName = localizedMapNames["Shadowmoon Valley"].." ("..localizedMapNames["Outland"]..")"
		end
	end
	--tprint( zoneName)
	return zoneName["name"]
end

local function BuildFriendTable(total)
	totalOnline = 0
	wipe(friendTable)
	local name, level, class, area, connected, status, note
	for i = 1, total do
		name, level, class, area, connected, status, note = GetFriendInfo(i)
		if status == "<"..AFK..">" then
			status = "|cffFFFFFF[|r|cffFF0000".. "AFK" .."|r|cffFFFFFF]|r"
		elseif status == "<"..DND..">" then
			status = "|cffFFFFFF[|r|cffFF0000".. "DND" .."|r|cffFFFFFF]|r"
		end

		if connected then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			friendTable[i] = { name, level, class, area, connected, status, note }
		end
	end
	sort(friendTable, SortAlphabeticName)
end

local function Sort(a, b)
	if a[2] and b[2] and a[3] and b[3] then
		if a[2] == b[2] then return a[3] < b[3] end
		return a[2] < b[2]
	end
end

local function BuildBNTable(total)
	wipe(BNTable)
	wipe(BNTableWoW)
	wipe(BNTableD3)
	wipe(BNTableSC)
	wipe(BNTableWTCG)
	wipe(BNTableApp)
	wipe(BNTableHOTS)
	wipe(BNTableOW)
	wipe(BNTableBSAp)

	local _, bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText
	local hasFocus, realmName, realmID, faction, race, class, guild, zoneName, level, gameText
	for i = 1, total do
		bnetIDAccount, accountName, battleTag, _, characterName, bnetIDGameAccount, client, isOnline, _, isAFK, isDND, _, noteText = BNGetFriendInfo(i)
		hasFocus, charName, gclient , realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, toonID, bnetIDAccount, isGameAFK, isGameBusy = BNGetGameAccountInfo(bnetIDGameAccount or bnetIDAccount);
		
		--print( bnetIDAccount, accountName, battleTag,  characterName, bnetIDGameAccount, "Client:" , client, isOnline, "AFK: ", isAFK, isDND, noteText)
		--print( hasFocus, charName, gclient, realmName, realmID, faction, race, class, guild, zoneName, level, "Game: ", gameText, broadcastText, broadcastTime, canSoR, toonID, bnetIDAccount, "AFK: ", isGameAFK, isAFK, isGameBusy)
		--print( "----")
		
		if isOnline then
			characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client) or "";
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			BNTable[i] = { bnetIDAccount, accountName, battleTag, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-SC2", "StarCraft", isGameAFK, isGameBusy }

			if client == scString then
				BNTableSC[#BNTableSC + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-SC2", "StarCraft", isGameAFK, isGameBusy }
			elseif client == d3String then
				BNTableD3[#BNTableD3 + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-D3", "Diablo 3", isGameAFK, isGameBusy }
			elseif client == wtcgString then
				BNTableWTCG[#BNTableWTCG + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-WTCG", "Hearstone", isGameAFK, isGameBusy }
			elseif client == hotsString then
				BNTableHOTS[#BNTableHOTS + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-HotS", "Heroes of Storm", isGameAFK, isGameBusy }
			elseif client == owString then
				BNTableOW[#BNTableOW + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-Overwatch", "Ovirva4zzz", isGameAFK, isGameBusy }
			elseif client == bsapString then
				BNTableBSAp[#BNTableBSAp + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isGameAFK, isGameBusy, noteText, realmName, faction, race, class, zoneName, level, "", "Interface\\CHATFRAME\\UI-ChatIcon-Battlenet", "In MobilApps", isAFK, isDND}
			elseif client == appString then
				BNTableApp[#BNTableApp + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isGameAFK, isGameBusy, noteText, realmName, faction, race, class, zoneName, level, "", "Interface\\CHATFRAME\\UI-ChatIcon-Battlenet", "In Apps", isAFK, isDND }
			else
				BNTableWoW[#BNTableWoW + 1] = { bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, isAFK,  isDND, noteText, realmName, faction, race, class, zoneName, level, gameText, "Interface\\CHATFRAME\\UI-ChatIcon-WoW", "World of Warcraft", isGameAFK, isGameBusy }
			end
			
			--print ( bnetIDAccount, accountName, characterName, bnetIDGameAccount, client, isOnline, "AFK: ", isAFK,  isDND, zoneName, level, isGameAFK, isGameBusy)
		end
	end

	sort(BNTable, Sort)
	sort(BNTableWoW, Sort)
	sort(BNTableSC, Sort)
	sort(BNTableD3, Sort)
	sort(BNTableWTCG, Sort)
	sort(BNTableApp, Sort)
	sort(BNTableHOTS, Sort)
	sort(BNTableOW, Sort)
	sort(BNTableBSAp, Sort)
end

local function Update(self, event, ...)
	if not yo["Addons"].InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self:SetScript("OnEvent", nil)
		self:SetScript("OnUpdate", nil)
		Text = nil
		LeftInfoPanel.friendText = nil
		return
	end
	
	local _, onlineFriends = GetNumFriends()
	local _, numBNetOnline = BNGetNumFriends()

	-- special handler to detect friend coming online or going offline
	-- when this is the case, we invalidate our buffered table and update the
	-- datatext information
	
	if event == "CHAT_MSG_SYSTEM" then
	--	local message = select(1, ...)
	--	if not (find(message, friendOnline) or find(message, friendOffline)) then return end
	end

	-- force update when showing tooltip
	dataValid = false

	Text:SetFormattedText(displayString, "Friends", onlineFriends + numBNetOnline)
	self:SetAllPoints(Text)
end

Stat:SetScript("OnMouseDown", function(self, btn)
	GameTooltip:Hide()

	if btn == "RightButton" then
		local menuCountWhispers = 0
		local menuCountInvites = 0
		local classc, levelc, info

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		if #friendTable > 0 then
			for i = 1, #friendTable do
				info = friendTable[i]
				if (info[5]) then
					menuCountInvites = menuCountInvites + 1
					menuCountWhispers = menuCountWhispers + 1

					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])
					classc = classc or GetQuestDifficultyColor(info[2]);

					menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
					menuList[3].menuList[menuCountWhispers] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
				end
			end
		end
		if #BNTable > 0 then
			local realID, grouped
			for i = 1, #BNTable do
				info = BNTable[i]
				if (info[5]) then
					realID = info[2]
					menuCountWhispers = menuCountWhispers + 1
					menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID, arg2 = true, notCheckable=true, func = whisperClick}

					if info[6] == wowString and UnitFactionGroup("player") == info[12] then
						classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[14]], GetQuestDifficultyColor(info[16])
						classc = classc or GetQuestDifficultyColor(info[16])

						if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
						menuCountInvites = menuCountInvites + 1

						menuList[2].menuList[menuCountInvites] = {text = format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[5], notCheckable=true, func = inviteClick}
					end
				end
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		ToggleFriendsFrame()
	end
end)


Stat:SetScript("OnEnter", function(self)

	local numberOfFriends, onlineFriends = GetNumFriends()
	local totalBNet, numBNetOnline = BNGetNumFriends()

	local totalonline = onlineFriends + numBNetOnline

	-- no friends online, quick exit
  	if totalonline == 0 then return end

	if not dataValid then
		-- only retrieve information for all on-line members when we actually view the tooltip
		if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
		if totalBNet > 0 then BuildBNTable(totalBNet) end
		dataValid = true
	end

	local totalfriends = numberOfFriends + totalBNet
	local zonec, classc, levelc, realmc, info, grouped
	GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(L["Friends"], format(totalOnlineString, totalonline, totalfriends),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)
	if onlineFriends > 0 then
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(worldOfWarcraftString)
		for i = 1, #friendTable do
			info = friendTable[i]
			if info[5] then
				
				--local mapID = C_Map.GetBestMapForUnit("player")
				--local zoneText = mapID and GetZoneText( mapID)
				--print( info[4], zoneText)
				
				if GetZoneText( C_Map.GetBestMapForUnit("player")) == info[4] then zonec = activezone else zonec = inactivezone end
				classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[3]], GetQuestDifficultyColor(info[2])

				classc = classc or GetQuestDifficultyColor(info[2])

				if UnitInParty(info[1]) or UnitInRaid(info[1]) then grouped = 1 else grouped = 2 end
				GameTooltip:AddDoubleLine(format(levelNameClassString,levelc.r*255,levelc.g*255,levelc.b*255,info[2],info[1],groupedTable[grouped]," "..info[6]),info[4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
			end
		end
	end

	if numBNetOnline > 0 then
		local status = 0
		for client, BNTable in pairs(tableList) do
			if #BNTable > 0 then
				GameTooltip:AddLine(' ')
				--GameTooltip:AddLine(battleNetString..' ('.. BNTable[1][16] ..')') --('..client..')')

				GameTooltip:AddDoubleLine( "|T" .. BNTable[1][17] .. ":0|t", BNTable[1][18])   -- 16
				--GameTooltip:AddLine( BNTable[1][16])
				for i = 1, #BNTable do
					info = BNTable[i]
					
		--			tprint( BNTable)
					
					if info[6] then
						if info[5] == wowString then
							if (info[7] == true) then status = 1 elseif (info[8] == true) then status = 2 else status = 3 end
							if (info[19] == true) then gstatus = 1 elseif (info[20] == true) then gstatus = 2 else gstatus = 3 end
					
							if (info[19] == true) then gstatus = 1 elseif (info[20] == true) then gstatus = 2 else gstatus = 3 end
							classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[info[13]]
							if info[15] ~= '' then
								levelc = GetQuestDifficultyColor(info[15])
							else
								levelc = RAID_CLASS_COLORS["PRIEST"]
								classc = RAID_CLASS_COLORS["PRIEST"]
							end

							if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
							GameTooltip:AddDoubleLine(format(levelNameString,levelc.r*255,levelc.g*255,levelc.b*255,info[15],classc.r*255,classc.g*255,classc.b*255,info[3] .. gstatusTable[gstatus], groupedTable[grouped], 255, 0, 0), statusTable[status] .. info[2],238,238,238,238,238,238)
							if IsShiftKeyDown() then
								if GetZoneText( C_Map.GetBestMapForUnit("player")) == info[14] then zonec = activezone else zonec = inactivezone end
								if GetRealmName() == info[10] then realmc = activezone else realmc = inactivezone end
								GameTooltip:AddDoubleLine(info[14], info[10], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
							end
						else
							if (info[7] == true) then status = 1 elseif (info[8] == true) then status = 2 else status = 3 end
							if (info[19] == true) then gstatus = 1 elseif (info[20] == true) then gstatus = 2 else gstatus = 3 end
							
							GameTooltip:AddDoubleLine(info[3] .. gstatusTable[gstatus], statusTable[status] .. info[2], .9, .9, .9, .9, .9, .9)
							if IsShiftKeyDown() then
								if GetZoneText( C_Map.GetBestMapForUnit("player")) == info[14] then zonec = activezone else zonec = inactivezone end
								if GetRealmName() == info[10] then realmc = activezone else realmc = inactivezone end
								GameTooltip:AddDoubleLine(info[16], info[10], .7, .7, .7, .7, .7, .7)
							end
						end
					end
				end
			end
		end
	end

	GameTooltip:Show()
end)

Stat:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
Stat:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
--Stat:RegisterEvent("BN_FRIEND_TOON_ONLINE")
--Stat:RegisterEvent("BN_FRIEND_TOON_OFFLINE")
--Stat:RegisterEvent("BN_TOON_NAME_UPDATED")
Stat:RegisterEvent("FRIENDLIST_UPDATE")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
--Stat:RegisterEvent("FRIENDLIST_SHOW")
Stat:RegisterEvent("IGNORELIST_UPDATE")
Stat:RegisterEvent("MUTELIST_UPDATE")
Stat:RegisterEvent("PLAYER_FLAGS_CHANGED")
Stat:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
Stat:RegisterEvent("BN_FRIEND_INFO_CHANGED")
Stat:RegisterEvent("BN_FRIEND_INVITE_LIST_INITIALIZED")
Stat:RegisterEvent("BN_FRIEND_INVITE_ADDED")
Stat:RegisterEvent("BN_FRIEND_INVITE_REMOVED")
--Stat:RegisterEvent("BN_SELF_ONLINE")
Stat:RegisterEvent("BN_BLOCK_LIST_UPDATED")
Stat:RegisterEvent("BN_CONNECTED")
Stat:RegisterEvent("BN_DISCONNECTED")
Stat:RegisterEvent("BN_INFO_CHANGED")
Stat:RegisterEvent("BATTLETAG_INVITE_SHOW")
Stat:RegisterEvent("PARTY_REFER_A_FRIEND_UPDATED")
Stat:RegisterEvent("CHAT_MSG_SYSTEM")


Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
Stat:SetScript("OnEvent", Update)
--end
