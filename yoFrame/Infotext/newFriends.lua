local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

-- собрать таблицу бнет, выловить ключи вмелто флист, сорт и по ней вывод. вов в топ
local yoEF = n.elemFrames
local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local displayString = "%s: ".. yo.myColorStr .. "%d|r"
local appTitle 	= "|T%s:24:24:0:0:64:64:10:54:10:54|t"	-- иконка приложения
local gold 		= "|cffffff00"
local grey 		= "|cff888888"
local green 	= "|cff00ff00"
local blue 		= "|cff00ffff"
local akfIcon 	= " |TInterface\\FriendsFrame\\StatusIcon-Away:13:13:0:0:64:64:10:54:10:54|t"
local dndIcon 	= " |TInterface\\FriendsFrame\\StatusIcon-DnD:13:13:0:0:64:64:10:54:10:54|t"
local onIcon  	= " |TInterface\\FriendsFrame\\StatusIcon-Online:13:13:0:0:64:64:10:54:10:54|t"
--local statusIcon = " |TInterface\\FriendsFrame\\StatusIcon-%s:13:13:0:0:64:64:10:54:10:54|t"
local starIcon 	= "|TInterface\\FriendsFrame\\FriendsListFavorite:18:18:4:-5:64:64:10:54:10:54|t"
local anyIcon 	= "Interface\\friendsframe\\battlenet-portrait"
local anyName 	= "Some Game"

local fdList, foList = {}, {}
local fList = {
	["sort"] = {  	BNET_CLIENT_WOW, BNET_CLIENT_SC, BNET_CLIENT_SC2, BNET_CLIENT_D3, BNET_CLIENT_WTCG, BNET_CLIENT_HEROES, BNET_CLIENT_OVERWATCH, BNET_CLIENT_WC3, BNET_CLIENT_COD, BNET_CLIENT_COD_MW, BNET_CLIENT_COD_MW2, BNET_CLIENT_COD_BOCW, BNET_CLIENT_APP, "BSAp",
	},
	["games"]	= {
		[BNET_CLIENT_WOW] 		= {"Interface\\FriendsFrame\\Battlenet-WoWicon", 				"World of Warcraft"},
		[BNET_CLIENT_SC] 		= {"Interface\\FriendsFrame\\Battlenet-Scicon",					"StarCraft"},
		[BNET_CLIENT_SC2]		= {"Interface\\FriendsFrame\\Battlenet-Sc2icon",				"StarCraft 2"},
		[BNET_CLIENT_D3]		= {"Interface\\FriendsFrame\\Battlenet-D3icon",					"Diablo 3"},
		[BNET_CLIENT_WTCG]		= {"Interface\\FriendsFrame\\Battlenet-WTCGicon",				"Hearstone"},
		[BNET_CLIENT_HEROES]	= {"Interface\\FriendsFrame\\Battlenet-HotSicon",				"Heroes of Storm"},
		[BNET_CLIENT_OVERWATCH]	= {"Interface\\FriendsFrame\\Battlenet-Overwatchicon",			"Overwatch"},
		[BNET_CLIENT_WC3]		= {"Interface\\FriendsFrame\\Battlenet-Warcraft3Reforged",		"Warcraft III: Reforged"},
		[BNET_CLIENT_COD]		= {"Interface\\FriendsFrame\\Battlenet-CallOfDutyBlackOps4icon","CoD: Black Ops"},
		[BNET_CLIENT_COD_MW]	= {"Interface\\FriendsFrame\\Battlenet-CallOfDutyMWicon",		"CoD: Modern Warfare"},
		[BNET_CLIENT_COD_MW2]	= {"Interface\\FriendsFrame\\Battlenet-CallOfDutyMW2icon",		"CoD: Modern Warfare 2"},
		[BNET_CLIENT_COD_BOCW]	= {"Interface\\FriendsFrame\\Battlenet-CallOfDutyBlackOps4icon","CoD: Black Ops Cold War"},
		["BSAp"]				= {"Interface\\FriendsFrame\\Battlenet-Battleneticon",			L["In MobilApps"]},
		[BNET_CLIENT_APP]		= {"Interface\\friendsframe\\battlenet-portrait",				L["In Apps"]},
	}
}

local function SortAlphabeticName(a, b)
	if a[1] and b[1] then
		return a[1] < b[1]
	end
end

local menuList = {
	{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
	{ text = INVITE, hasArrow = true,notCheckable=true, },
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
	{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
		menuList = {
			{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() 	then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffE7E716"..DND.."|r", 		notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffFF0000"..AFK.."|r", 		notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
		},
	},
}

--info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
--info.icon = [TEXTURE] -- An icon for the button.
local function whisperClick(self, name, battleNet)
	if battleNet then
		ChatFrame_SendBNetTell( name)
	else
		SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )
	end
end

local function inviteClick(self, name)
	if type(name) ~= 'number' then
		C_PartyInfo.InviteUnit(name)
	else
		BNInviteFriend(name);
	end
end

local function makeWOWName( accTable, fdTable)
	local wowID, invFunc, myRealmID, realmID, realmName, richPres, gInfo, uName, uLevel, areaName, className = " ", "", GetRealmID()

	if not fdTable then
		gInfo 		= accTable.gameAccountInfo
		uName 		= gInfo.characterName
		uLevel 		= gInfo.characterLevel
		areaName	= gInfo.areaName
		className	= gInfo.className
		wowID 		= gInfo.wowProjectID == 2 and gold .. "(c) " or " "
		realmID 	= gInfo.realmID
		realmName 	= gInfo.realmDisplayName
		richPres 	= gold .. gInfo.richPresence
		invFunc 	= " |cff2ba1ff(" .. accTable.accountName .. ")|r"
	else
		uName 		= fdTable.name
		uLevel 		= fdTable.level
		areaName	= fdTable.area
		className	= fdTable.className
		accTable 	= fdTable
	end

	local inZone 	= areaName == C_Map.GetMapInfo( C_Map.GetBestMapForUnit("player")).name and green .. "*" or ""
	local inParty 	= (UnitInParty( uName) or UnitInRaid( uName)) and gold .. "+" or ""

	for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE)   do if className == v then className = k end end
	for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if className == v then className = k end end

	--accTable.classID 	= className
	accTable.classColor = "|c" .. RAID_CLASS_COLORS[className].colorStr
	accTable.diffColor  = GetQuestDifficultyColor(uLevel)
	accTable.diffColorH = hex( accTable.diffColor)
	accTable.areaStr  	= #inZone > 1 and green .. areaName or areaName
	accTable.realmStr 	= myRealmID == realmID and blue .. realmName or realmName or richPres or ""

	local retSrt = inParty .. accTable.diffColorH .. uLevel .. wowID.. accTable.classColor .. uName .. inZone

	if #inParty <= 3 then
		menuList[2].menuList[#menuList[2].menuList + 1] = {text = retSrt .. invFunc, arg1 = uName, notCheckable=true, func = inviteClick} end
	if myRealmID == realmID or fdTable then
		menuList[3].menuList[#menuList[3].menuList + 1] = {text = retSrt, arg1 = uName, notCheckable=true, func = whisperClick}
		if yoEF.wim and yoEF.wim.menuWIM then
			yoEF.wim.menuWIM[#yoEF.wim.menuWIM+1] = {text = retSrt, arg1 = uName, notCheckable=true, func = whisperClick}
		end
	end

	return retSrt
end

function Stat:onMouseDown( btn)
	GameTooltip:Hide()
	if btn == "RightButton" then
		EasyMenu(menuList, n.menuFrame, "cursor", -50, 110, "MENU", 2)
	else
		ToggleFriendsFrame()
	end
end

function Stat:onEnter( arg, fromWIM)
	wipe(foList)
	wipe(fdList)
	menuList[2].menuList = {}
	menuList[3].menuList = {}

	for i = 1, self.onlineFriends do
		local friendInfo = C_FriendList.GetFriendInfoByIndex(i)
		table.insert( fdList, friendInfo)
	end
	sort(fdList, SortAlphabeticName)

	for i = 1, self.numBNetOnline do
		 local bAccountInfo = C_BattleNet.GetFriendAccountInfo(i)
		 local client 		= bAccountInfo.gameAccountInfo.clientProgram

		 if  #client > 1 then
		 	if not foList[client] then foList[client] = {} end
 		 	foList[client][bAccountInfo.accountName] = bAccountInfo
		 end
	end

	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 10)
	GameTooltip:AddDoubleLine(FRIENDS, FRIENDS_LIST_ONLINE .. ": " .. self.totalOnline .. "/" .. self.total, 0.4, .8, 1, 0.4, .8, 1)

	for i, fdData in ipairs(fdList) do
		if i == 1 then GameTooltip:AddDoubleLine(' ', " ", 0.6, 0.6, 0.6, 0.8, 0.8, 0.8) end

		local uName = makeWOWName( nil, fdData)
		GameTooltip:AddDoubleLine( uName, fdData.areaStr, 1, 1, 1, 0, 0.48, 0.654)
	end

	for k,clientName in pairs(fList.sort) do
		if foList[clientName] then
			local ind = 1
			local accTable = foList[clientName]
			for uName, accData in pairs( accTable) do
				if ind == 1 then
					GameTooltip:AddDoubleLine(' ', " ", 0.6, 0.6, 0.6, 0.8, 0.8, 0.8)
					GameTooltip:AddDoubleLine( format( appTitle, fList.games[clientName][1] or anyIcon), fList.games[clientName][2] or anyName) end

				local status = ""
				local star = accData.isFavorite and starIcon or ""

				if clientName ~= "BSAp" then
					status = ( accData.isDND and dndIcon) or ( accData.isAFK and akfIcon) or (accData.gameAccountInfo.isGameAFK and akfIcon) or onIcon
				elseif accData.isDND or accData.isAFK or accData.gameAccountInfo.isGameAFK then
					uName = akfIcon .. " " .. grey .. FriendsFrame_GetLastOnline(accData.lastOnlineTime)
				end

				menuList[3].menuList[#menuList[3].menuList + 1] = {text = status .. accData.accountName .. star, arg1 = accData.accountName, arg2 = true, notCheckable=true, func = whisperClick}
				if yo_WIM and yo_WIM.menuWIM then
					yo_WIM.menuWIM[#yo_WIM.menuWIM+1] = {text = status .. accData.accountName .. star, arg1 = accData.accountName, arg2 = true, notCheckable=true, func = whisperClick}
				end

				if clientName == BNET_CLIENT_WOW then uName = makeWOWName( accData) end
				GameTooltip:AddDoubleLine( uName, star .. accData.accountName .. status, 1, 1, 1, 0, 0.48, 0.654)

				if IsShiftKeyDown() and clientName ~= "BSAp" then
					if accData.isDND or accData.isAFK or accData.gameAccountInfo.isGameAFK then
							GameTooltip:AddDoubleLine( "отсутвствует:", FriendsFrame_GetLastOnline(accData.lastOnlineTime), .8, .8, .8, .8, .8, 0.8) end
					if accData.realmStr  then
							GameTooltip:AddDoubleLine( accData.areaStr, accData.realmStr, 0.6, 0.6, 0.6, 0.8, 0.8, 0.8)
					elseif #accData.gameAccountInfo.richPresence > 1 and clientName ~= BNET_CLIENT_APP then
							GameTooltip:AddLine(accData.gameAccountInfo.richPresence)			end
					if #accData.customMessage > 1 then
							GameTooltip:AddLine( accData.customMessage, _, _, _, true)	end
					if #accData.note > 1 then
							GameTooltip:AddDoubleLine( "ноте:", accData.note, _, _, _, 1, 1, 1) end
				end
				ind = ind + 1
			end
		end
	end
	if not fromWIM then GameTooltip:Show() end
end

function Stat:onEvent(event, ...)

	self.onlineFriends 	= C_FriendList.GetNumOnlineFriends() or 0
	self.numberOfFriends= C_FriendList.GetNumFriends() or 0
	self.totalBNet, self.numBNetOnline = BNGetNumFriends()

	self.total 			= self.totalBNet + self.numberOfFriends
	self.totalOnline 	= self.onlineFriends + self.numBNetOnline

	self.Text:SetFormattedText(displayString, FRIENDS, self.totalOnline)
	--self:SetWidth( self.Text:GetWidth())
end

function Stat:Enable()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)
	self:SetHeight( 15)
	self:EnableMouse(true)
	self:SetFrameStrata("MEDIUM")
	self:SetFrameLevel(3)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	self:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	self:RegisterEvent("FRIENDLIST_UPDATE")
	self:RegisterEvent("IGNORELIST_UPDATE")
	self:RegisterEvent("MUTELIST_UPDATE")
	self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	self:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	self:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	self:RegisterEvent("BN_FRIEND_INVITE_LIST_INITIALIZED")
	self:RegisterEvent("BN_FRIEND_INVITE_ADDED")
	self:RegisterEvent("BN_FRIEND_INVITE_REMOVED")
	self:RegisterEvent("BN_BLOCK_LIST_UPDATED")
	self:RegisterEvent("BN_CONNECTED")
	self:RegisterEvent("BN_DISCONNECTED")
	self:RegisterEvent("BN_INFO_CHANGED")
	self:RegisterEvent("BATTLETAG_INVITE_SHOW")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnEnter", self.onEnter)
	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnMouseDown", self.onMouseDown)

	self.Text = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( font, fontsize, "OVERLAY")
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:onEvent()
	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	self:UnregisterAllEvents()
	self:Hide()
end

infoText.infos.friend 		= Stat
infoText.infos.friend.name = FRIENDS

infoText.texts.friend = "Friends"
--Stat.index = 4
--Stat:Enable()

--[[
friendInfo ={
	{ Name = "connected", Type = "bool", Nilable = false },
	{ Name = "name", Type = "string", Nilable = false },
	{ Name = "className", Type = "string", Nilable = true },
	{ Name = "area", Type = "string", Nilable = true },
	{ Name = "notes", Type = "string", Nilable = true },
	{ Name = "guid", Type = "string", Nilable = false },
	{ Name = "level", Type = "number", Nilable = false },
	{ Name = "dnd", Type = "bool", Nilable = false },
	{ Name = "afk", Type = "bool", Nilable = false },
	{ Name = "rafLinkType", Type = "RafLinkType", Nilable = false },
	{ Name = "mobile", Type = "bool", Nilable = false },
}

bAccountInfo ={
	{ Name = "bnetAccountID", Type = "number", Nilable = false },
	{ Name = "accountName", Type = "string", Nilable = false },
	{ Name = "battleTag", Type = "string", Nilable = false },
	{ Name = "isFriend", Type = "bool", Nilable = false },
	{ Name = "isBattleTagFriend", Type = "bool", Nilable = false },
	{ Name = "lastOnlineTime", Type = "number", Nilable = false },
	{ Name = "isAFK", Type = "bool", Nilable = false },
	{ Name = "isDND", Type = "bool", Nilable = false },
	{ Name = "isFavorite", Type = "bool", Nilable = false },
	{ Name = "appearOffline", Type = "bool", Nilable = false },
	{ Name = "customMessage", Type = "string", Nilable = false },
	{ Name = "customMessageTime", Type = "number", Nilable = false },
	{ Name = "note", Type = "string", Nilable = false },
	{ Name = "rafLinkType", Type = "RafLinkType", Nilable = false },
	{ Name = "gameAccountInfo", Type = "BNetGameAccountInfo", Nilable = false },
}

BNetGameAccountInfo = {
	{ Name = "gameAccountID", Type = "number", Nilable = true },
	{ Name = "clientProgram", Type = "string", Nilable = false },
	{ Name = "isOnline", Type = "bool", Nilable = false },
	{ Name = "isGameBusy", Type = "bool", Nilable = false },
	{ Name = "isGameAFK", Type = "bool", Nilable = false },
	{ Name = "wowProjectID", Type = "number", Nilable = true },
	{ Name = "characterName", Type = "string", Nilable = true },
	{ Name = "realmName", Type = "string", Nilable = true },
	{ Name = "realmDisplayName", Type = "string", Nilable = true },
	{ Name = "realmID", Type = "number", Nilable = true },
	{ Name = "factionName", Type = "string", Nilable = true },
	{ Name = "raceName", Type = "string", Nilable = true },
	{ Name = "className", Type = "string", Nilable = true },
	{ Name = "areaName", Type = "string", Nilable = true },
	{ Name = "characterLevel", Type = "number", Nilable = true },
	{ Name = "richPresence", Type = "string", Nilable = true },
	{ Name = "playerGuid", Type = "string", Nilable = true },
	{ Name = "isWowMobile", Type = "bool", Nilable = false },
	{ Name = "canSummon", Type = "bool", Nilable = false },
	{ Name = "hasFocus", Type = "bool", Nilable = false },
}
]]