local addon, ns = ...
local L, yo, n = unpack( ns)
local oUF = ns.oUF

local _G = _G
local yoEF = n.Addons.elements.elemFrames
local minAlpha 	= 1

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GameTooltip, setmetatable, getmetatable, CreateFrame, CreateStyle, UIParent, print, GetGuildInfo, IsReagentBankUnlocked, IsInGuild, CreateStyleSmall, type, time, date, IsControlKeyDown, IsShiftKeyDown
	= GameTooltip, setmetatable, getmetatable, CreateFrame, CreateStyle, UIParent, print, GetGuildInfo, IsReagentBankUnlocked, IsInGuild, CreateStyleSmall, type, time, date, IsControlKeyDown, IsShiftKeyDown

local PlaySound, SendChatMessage, UnitName, UnitIsSameServer, GetAutoCompleteResults, SetUpAnimGroup, Setlers, Kill, strlower, Ambiguate, GetPlayerInfoByGUID, InCombatLockdown, tremove
	= PlaySound, SendChatMessage, UnitName, UnitIsSameServer, GetAutoCompleteResults, SetUpAnimGroup, Setlers, Kill, strlower, Ambiguate, GetPlayerInfoByGUID, InCombatLockdown, tremove
--https://wowwiki.fandom.com/wiki/UI_escape_sequences

n.moveCreateAnchor("yoMoveWIM", 	"Move PM Chat", 370, 250, 10, 90, "BOTTOMLEFT", "TOPLEFT", n.infoTexts.LeftDataPanel)
--ContainerFrame3 = CreateFrame("Frame", "ContainerFrame3", UIParent)
--ContainerFrame3:SetPoint("CENTER")

--GLOBALS: _G.yo_WIMSTER
n.wimster = {}

local function UpdateTabs( self)
	if not self.lastTab then return end

	self:ResizeTabs()

	local prevInd = 0
	for ind = self.minTab or 1, self.lastTab do
		local tab = self.tabs[ind]
		if tab then

			if self.tabUpdate then
				tab:ClearAllPoints()

				if prevInd == 0 then
					self.minTab = tab:GetID()
					tab:SetPoint("LEFT", self, "LEFT", 0, 0)
				else
					tab:SetPoint("LEFT", self.tabs[prevInd], "RIGHT", 4, 0)
				end
				prevInd = tab:GetID()
			end

			local r, g, b = 0.7, 0.7, 0.7
			if tab.class then
				r, g, b = unpack( oUF.colors.class[tab.class])
			elseif tab.btag then
				r, g, b = 0, 0.4862745098039216, 0.6549019607843137
			end

			tab.header:SetTextColor(r, g, b)
			--tab.tabNum:SetTextColor(r, g, b)
			tab.shadow:SetBackdropColor( 0.07, 0.07, 0.07, 0.5)

			if self.checked == tab:GetID() then
				tab.textBox:Show()
				tab.editBox:Show()
				--tab.editBox:SetFocus()
				--tab.shadow:SetBackdropColor(r, g, b, 0.8)
				tab.shadow:SetBackdropBorderColor( r, g, b, 1)
			else
				tab.textBox:Hide()
				tab.editBox:Hide()
				tab.editBox:ClearFocus()
				--tab.shadow:SetBackdropColor(r, g, b, 0.15)
				tab.shadow:SetBackdropBorderColor( 0, 0, 0, 0.6)
			end

			--tab.tabNum:SetText( tab:GetID())
			tab.header:SetText( Ambiguate( tab.fullName, "none"))

			self.lastTab = tab:GetID()
			--yo.Chat.wimLastTab = tab:GetID()
			--print( yo.Chat.wimLastTab)
		end
	end
	self.tabUpdate 	= false
end

local function CreateTabs(self, ID)
	local tab = CreateFrame("CheckButton", nil, self)
	tab:SetHeight( self:GetHeight())
	tab:SetID( ID)
	tab:SetFrameLevel(10)
	tab:RegisterForClicks( "LeftButtonDown", "RightButtonUp")

	local header = tab:CreateFontString(nil, "OVERLAY")
	header:SetFont( n.font, n.fontsize)	--, "OUTLINE")
	header:SetShadowOffset(1, -1)
	header:SetShadowColor(0, 0, 0, 1)
	header:SetPoint("TOPLEFT", 0, -1)
	header:SetPoint("BOTTOMRIGHT", 0, 1)
	header:SetJustifyV("MIDDLE")
	header:SetJustifyH("CENTER")
	tab.header = header

	--local tabNum = tab:CreateFontString(nil, "OVERLAY")
	--tabNum:SetFont( fontpx, fontsize, "OUTLINE")
	--tabNum:SetPoint("TOPLEFT", 1, 1)
	--tab.tabNum = tabNum

	local hover = tab:CreateTexture(nil, "OVERLAY")
	hover:SetTexture( n.texture)
	hover:SetVertexColor( 0.5, 0.5, 0.5, 0.5)
	hover:SetPoint("TOPLEFT", 0, 0)
	hover:SetPoint("BOTTOMRIGHT", 0, 0)
	hover:SetAlpha( 0.3)
	tab.hover = hover
	tab:SetHighlightTexture( hover)

	--editBox.HighlightText = function(self, theStart, theEnd)
	--	if( self.focused) then
	--		WIM.EditBoxInFocus:HighlightText(theStart, theEnd);
	--	else
	--		self:wimHighlightText(theStart, theEnd);
	--	end
	--end
    --Hooked_ChatFrameEditBoxes[editBox:GetName()] = true;

	local editBox = CreateFrame('EditBox', nil, self)--, "InputBoxTemplate");
	editBox:SetFrameLevel( editBox:GetFrameLevel() + 2);
	editBox:SetHeight( 16)
	editBox:SetText("")
	editBox:SetAutoFocus(false)
	editBox:SetHistoryLines(32);
	editBox:SetFont( n.font, n.fontsize +1 )
	editBox:SetPoint('BOTTOMLEFT', self:GetParent(), 'BOTTOMLEFT', 6, 6);
	editBox:SetPoint('BOTTOMRIGHT', self:GetParent(), 'BOTTOMRIGHT', -23, 6);
	editBox:SetScript("OnLeave", 			function() self:SetAlpha( minAlpha) end)
	editBox:SetScript("OnEnter", 			function() self:SetAlpha(1) end)
	editBox:SetScript("OnEscapePressed", 	function() editBox:ClearFocus() end) --self:Hide()
	editBox:SetScript("OnEditFocusGained", 	function() self.focused = tab:GetID()  end) --self.HighlightText
	editBox:SetScript("OnEditFocusLost", 	function() if self.focused == tab:GetID() then self.focused = false editBox:ClearFocus() end end)
	--editBox:SetScript("OnEditFocusLost", 	function(self) self:ClearFocus() end)
	--editBox:SetScript("OnEditFocusGained", 	editBox.HighlightText)
	editBox:SetScript("OnEnterPressed", 	self:GetParent().editBoxOnterPressed)
	tab.editBox = editBox

	local textBox = CreateFrame("ScrollingMessageFrame", nil, self)
	textBox:SetFont( yo.Chat.chatFont, yo.Chat.chatFontsize)
	textBox:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", 6, -6)
	textBox:SetPoint("BOTTOMRIGHT", editBox, "TOPRIGHT", 0, 6)
	textBox:SetInsertMode( "BOTTOM")
	textBox:SetJustifyH("LEFT")
	textBox:SetMaxLines( 200)
	textBox:SetMouseMotionEnabled( true)
	textBox:SetHyperlinksEnabled(true)
	textBox:RegisterForDrag("LeftButton")
	textBox:SetFading( false)
	textBox:SetScript("OnEnter", 		function() self:GetParent():SetAlpha(1) end)
	textBox:SetScript("OnLeave", 		function() self:GetParent():SetAlpha( minAlpha) end)
	textBox:SetScript("OnMouseWheel", 	function(self, ...)
        if(select(1, ...) > 0) then
			if( IsControlKeyDown() ) then self:ScrollToTop();
		else 	if( IsShiftKeyDown() ) then self:PageUp() else self:ScrollUp() end end
	    	else 	if( IsControlKeyDown() ) then self:ScrollToBottom()
				else 	if( IsShiftKeyDown() ) then self:PageDown() else self:ScrollDown() end end
	    end
	end)
	textBox:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow)
	textBox:SetScript("OnHyperlinkEnter", OnHyperlinkEnter) 	-- from Chat.lua
	textBox:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

	textBox:SetScript("OnDragStart", function() yoEF.wim:StartMoving() end)
	textBox:SetScript("OnDragStop", function()
		yoEF.wim:StopMovingOrSizing()
		n.Addons.moveFrames.yoMoveWIM:ClearAllPoints()
		n.Addons.moveFrames.yoMoveWIM:SetPoint( self:GetPoint())
		n.setAnchPosition( n.Addons.moveFrames.yoMoveWIM, yoEF.wim)
	end)
	tab.textBox = textBox

	tab:SetScript("OnEnter", function() self:GetParent():SetAlpha(1) end)
	tab:SetScript("OnLeave", function() self:GetParent():SetAlpha( minAlpha) end)
	tab:SetScript("OnClick", function( this, button)
		self:GetParent().stopFlash( self, header)
		if button == "LeftButton" then
			self.checked = tab:GetID()
		else
			Kill( self.tabs[tab:GetID()].textBox)
			Kill( self.tabs[tab:GetID()].editBox)
			Kill( self.tabs[tab:GetID()].shadow)
			Kill( self.tabs[tab:GetID()])
			self.tabs[tab:GetID()] = nil
			self.tabCount = self.tabCount - 1
			self.tabUpdate = true
			self.checked = table.maxn( self.tabs)
		end
		UpdateTabs( self)
	end)

	self.lastTab = ID
	CreateStyleSmall( textBox, 1, nil, 0.7, 0.7)
	CreateStyleSmall( editBox, 1, nil, 0.9, 0.7)
	CreateStyleSmall( tab, 2, 10, 0.7)
	return tab
end

local function CheckTabForUnit(self, unit, guid, btag, force)

	local findUnit, tabID
	if unit then
		for ind, tab in pairs( self.tabber.tabs) do
			if strlower( Ambiguate( unit, "none")) == strlower( Ambiguate( tab.fullName, "none")) then
				findUnit = true
				tabID = ind
			end
		end
	end

	if not findUnit then
		tabID = self.tabber.lastTab+1
		self.tabber.tabs[tabID] 		= CreateTabs(self.tabber, tabID)
		self.tabber.tabUpdate 			= true
		self.tabber.tabCount 			= self.tabber.tabCount + 1
		self.tabber.tabs[tabID].preHistoric	= true
	end

	if btag then
		self.tabber.tabs[tabID].name 	= unit
		self.tabber.tabs[tabID].btag 	= btag
		self.tabber.tabs[tabID].fullName= unit

		local BNETAccInfo = C_BattleNet.GetAccountInfoByID( btag)
		self.tabber.tabs[tabID].fullTag	= BNETAccInfo.battleTag
		Setlers( "Chat#wimLastTab", format( "%s,,%s", unit, btag))
	elseif guid then
		local _, classId, _, raceId, gender = GetPlayerInfoByGUID( guid)
		local name, realm = strsplit("-", unit)

		self.tabber.tabs[tabID].guid 	= guid
		self.tabber.tabs[tabID].name 	= name
		self.tabber.tabs[tabID].realm 	= realm
		self.tabber.tabs[tabID].fullName= unit
		self.tabber.tabs[tabID].gender 	= gender
		self.tabber.tabs[tabID].race 	= raceId
		self.tabber.tabs[tabID].class 	= classId
		self.tabber.tabs[tabID].guild 	= GetGuildInfo( name)
		Setlers( "Chat#wimLastTab", format( "%s,%s", unit, guid))
	elseif unit then
		local name, realm = strsplit( "-", unit)
		self.tabber.tabs[tabID].fullName= unit
		self.tabber.tabs[tabID].name 	= name
		self.tabber.tabs[tabID].realm 	= realm
		Setlers( "Chat#wimLastTab", format( "%s", unit))
	end

	--print( self.tabber.tabs[tabID].preHistoric, self.tabber.tabs[tabID].fullName, unit )

	if self.tabber.tabs[tabID].preHistoric then
		local target = btag and self.tabber.tabs[tabID].fullTag or strlower( Ambiguate( unit, "none"))

		if not n.wimster then n.wimster = {} end
		if not n.wimster[n.myRealm] then n.wimster[n.myRealm] = {} end
		if not n.wimster[n.myRealm][n.myName] then n.wimster[n.myRealm][n.myName] = {} end

		if n.wimster[n.myRealm][n.myName][target] then
			local logArray 	= n.wimster[n.myRealm][n.myName][target]
			local longArray = #logArray

			if longArray > 0 then
				local oldDate
				local fromArray = longArray > self.wimPrehistoric and longArray - self.wimPrehistoric  + 1 or 1
				for ind = fromArray, longArray do
				--for ind, info in ipairs( logArray) do
					local info 		= logArray[ind]
					local col 		= self.cols[info.event]
					local newDate 	= date("%d.%m.%Y", info.time)
					local time 		= date("%H:%M", info.time)

					if newDate ~= oldDate then
						self.tabber.tabs[tabID].textBox:AddMessage( " ")
						self.tabber.tabs[tabID].textBox:AddMessage( "|cffffcc00 " .. newDate .. " " .. _G["WEEKDAY_" .. string.upper(date("%A", info.time))] )
						oldDate = newDate
					end
					self.tabber.tabs[tabID].textBox:AddMessage( "|cffffcc00" .. time .. info.msg, col.r, col.g, col.b, 1)
					--self.tabber.tabs[tabID].textBox:AddMessage( "|cffffcc00" .. time)
				end
				self.tabber.tabs[tabID].textBox:AddMessage( "|cffffcc00--------------------------------")
				self.tabber.tabs[tabID].textBox:AddMessage( " ")
				self.tabber.tabs[tabID].preHistoric = false
			end

			if self.wimMaxHistory and longArray > self.wimMaxHistory then
				for i = 1, longArray - self.wimMaxHistory do
					tremove( logArray, 1)
				end
			end
		else
			self.tabber.tabs[tabID].preHistoric = false
		end
	end

	if force then
		self.tabber.checked = tabID
		if self:IsShown() then
			self.tabber.tabs[tabID].editBox:SetFocus()
		end
	end

	UpdateTabs( self.tabber)

	if InCombatLockdown() then
		self.needShow = true
	else
		self.needShow = false
		self:Show()
	end

	if tabID ~= self.tabber.checked then 	self:startFlash( self.tabber.tabs[tabID].header, 0.75, true) end
	if not self:IsShown() then 				self:startFlash( self.wimButton, 0.75, true) end

	return tabID
end

local function CreateWIM( self)
	yoMoveWIM:SetSize( yo.Chat.wimWidth, yo.Chat.winHeight)
	self:SetSize( yo.Chat.wimWidth, yo.Chat.winHeight)
	self:SetPoint("TOPLEFT", yoMoveWIM, "TOPLEFT", 0, 0)
	self:Hide()
	self:SetFrameStrata("HIGH")
	self:EnableMouse( true)
	self:SetMovable( true)
	self:SetResizable(true)
	self:SetMinResize( 300, 200)
	self:SetClampedToScreen(true)
	self:RegisterForDrag( "LeftButton")
	self:SetScript("OnEnter", 		function() self:SetAlpha(1) end)
	self:SetScript("OnLeave", 		function() self:SetAlpha( minAlpha) end)
	self:SetScript("OnShow", 		function() self:stopFlash( self.wimButton) if yo.Chat.wimLastTab then CheckTabForUnit( self, strsplit( ",", yo.Chat.wimLastTab)) end end)
	self:SetScript("OnDragStart", 	function() self:StartMoving() end)
	self:SetScript("OnDragStop", 	function() self:StopMovingOrSizing()
		n.Addons.moveFrames.yoMoveWIM:ClearAllPoints()
		n.Addons.moveFrames.yoMoveWIM:SetPoint( self:GetPoint())
		n.setAnchPosition( n.Addons.moveFrames.yoMoveWIM, yoEF.wim)
	end)
	--self:SetScript("OnEscapePressed", function(self) self:Hide() end)

	self.buttons = {}
	local hider = CreateFrame("Button", nil, self)
	hider:SetSize( 24, 24)
	hider:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, -2)
	hider:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up")
	hider:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Down")
	hider:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	hider:GetNormalTexture():SetVertexColor(1, 0.75, 0, 1)
	hider.text = HIDE
	hider:SetScript("OnClick", function() self:Hide() end)
	hider:SetScript("OnEnter", self.tooltipShow)
	hider:SetScript("OnLeave", self.tooltipHide)
	self.buttons.hider = hider

	local figter = CreateFrame("CheckButton", nil, self, "OptionsBaseCheckButtonTemplate")
	figter:SetSize( 26, 26)
	figter:SetPoint("TOP", hider, "BOTTOM", 0, 4)
	figter:SetScript("OnClick", function() Setlers( "Chat#wimFigter", figter:GetChecked()) self.onFigterEnter( figter) end)
	figter:SetScript("OnEnter", function() self.onFigterEnter( figter) end)
	figter:SetScript("OnLeave", self.tooltipHide)
	figter:SetChecked( yo.Chat.wimFigter)
	self.buttons.figter = figter

	local guild = CreateFrame("Button", nil, self)
	guild:SetSize( 24, 24)
	guild:SetPoint("TOP", figter, "BOTTOM", 0, -1)
	guild.text = GUILD_ROSTER
	guild:SetNormalTexture( 	"Interface\\Addons\\yoFrame\\Media\\Guild-UI-SquareButton-Up")
	guild:SetPushedTexture( 	"Interface\\Addons\\yoFrame\\Media\\Guild-UI-SquareButton-Down")
	guild:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	guild:SetScript("OnMouseDown", function(self, button) n.infoTexts.infos.guild:ShowGuild( button, guild) end)
	guild:SetScript("OnEnter", self.tooltipShow)
	guild:SetScript("OnLeave", self.tooltipHide)
	self.buttons.guild = guild

	local friends = CreateFrame("Button", nil, self)
	friends:SetSize( 24, 24)
	friends:SetPoint("TOP", guild, "BOTTOM", 0, 6)
	friends.text = FRIENDS_LIST
	friends:SetNormalTexture( 	"Interface\\Addons\\yoFrame\\Media\\Friedns-UI-SquareButton-Up")
	friends:SetPushedTexture( 	"Interface\\Addons\\yoFrame\\Media\\Friedns-UI-SquareButton-Down")
	friends:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	friends:SetScript("OnMouseDown", function( f, button)
		self.menuWIM = { { text = "Дружеский шептун", isTitle = true,notCheckable=true}, }
		n.infoTexts.infos.friend:onEnter( nil, "fomWIM")
		EasyMenu( self.menuWIM, n.menuFrame, f, 25, 50, "MENU", 2)
	end)
	--friends:SetScript("OnMouseDown", function(self, button) n.InfoFriend:ShowFiends( button)

	friends:SetScript("OnEnter", self.tooltipShow)
	friends:SetScript("OnLeave", self.tooltipHide)
	self.buttons.friends = friends

	local invite = CreateFrame("Button", nil, self)
	invite:SetSize( 24, 24)
	invite:SetPoint("TOP", friends, "BOTTOM", 0, -1)
	invite.text = INVITE
	invite:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Up")
	invite:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Down")
	invite:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	invite:SetScript("OnClick", self.inviteOnClick)
	invite:SetScript("OnEnter", self.inviteOnEnter)
	invite:SetScript("OnLeave", self.tooltipHide)
	self.buttons.invite = invite

	local info = CreateFrame("Button", nil, self)
	info:SetSize( 24, 24)
	info:SetPoint("TOP", invite, "BOTTOM", 0, 6)
	info.text = CHARACTER_INFO
	info.text2 = "don`t work"
	info:SetNormalTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Up")
	info:SetPushedTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Down")
	info:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	info:SetScript("OnEnter", self.tooltipShow)
	info:SetScript("OnLeave", self.tooltipHide)
	self.buttons.info = info

	local copier = CreateFrame("Button", nil, self)
	copier:SetSize( 24, 24)
	copier:SetPoint("TOP", info, "BOTTOM", 0, 6)
	copier.text = COPY_FILTER .. " " .. string.lower( LOCALE_TEXT_LABEL)
	copier:SetNormalTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Up")
	copier:SetPushedTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Maximize-Down")
	copier:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	copier:SetScript("OnClick", self.CopyTextBox)
	copier:SetScript("OnEnter", self.tooltipShow)
	copier:SetScript("OnLeave", self.tooltipHide)
	self.buttons.copier = copier

	local shower = false
	local history = CreateFrame("Button", nil, self)
	history:SetSize( 24, 24)
	history:SetPoint("TOP", copier, "BOTTOM", 0, 6)
	history.text = HISTORY
	history:SetNormalTexture( 		"Interface\\FriendsFrame\\UI-FriendsList-Large-Up") 	--"Interface\\TIMEMANAGER\\PauseButton")
	history:SetPushedTexture( 		"Interface\\FriendsFrame\\UI-FriendsList-Large-Down") 	--"Interface\\Buttons\\UI-SquareButton-Down")
	history:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	history:SetScript("OnClick", function() self.wimHistory:SetShown( not self.wimHistory:IsShown()) end)
	history:SetScript("OnEnter", self.tooltipShow)
	history:SetScript("OnLeave", self.tooltipHide)
	self.buttons.history = history

	local ignore = CreateFrame("CheckButton", nil, self)
	ignore:SetSize( 23, 23)
	ignore:SetPoint("TOP", history, "BOTTOM", 0, 1)
	ignore.text = IGNORE_QUEST
	ignore:SetPushedTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeUnhealthy")
	ignore:SetNormalTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeTired")
	ignore:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	ignore:SetScript("OnClick", self.ignoreOnClick)
	ignore:SetScript("OnEnter", self.ignoreOnEnter)
	ignore:SetScript("OnLeave", self.tooltipHide)
	self.buttons.ignore = ignore

	local grabber = CreateFrame("Button", nil, self)
	grabber:SetSize( 14, 14)
	grabber:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	grabber:SetNormalTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grabber:SetHighlightTexture( 	"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grabber:SetPushedTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grabber:RegisterForDrag("LeftButton")
	grabber:SetScript("OnDragStart", function() self:StartSizing() end)
	grabber:SetScript("OnDragStop", function()
		self:StopMovingOrSizing()
		Setlers( "Chat#wimWidth", self:GetWidth())
		Setlers( "Chat#winHeight", self:GetHeight())
	end)
	self.buttons.grabber = grabber

	self.tabber = CreateFrame("Frame", nil, self)
	self.tabber:SetHeight( 16)
	self.tabber:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4) --3
	self.tabber:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
	self.tabber:SetScript("OnSizeChanged", self.ResizeTabs)

	self.tabber.tabs = {}
	self.tabber.checked = 1
	self.tabber.tabCount = 0
	self.tabber.lastTab = 0
	self.tabber.tabUpdate = true
	self.tabber.ResizeTabs = self.ResizeTabs

	CreateStyle( self, 2, nil, 0.5)
end

local function SaveLines( self, msg, event, tabID, target, bnet, colorLine)
	--print(self, target, bnet)
	target = bnet and self.tabber.tabs[tabID].fullTag or strlower( Ambiguate( target, "none"))

	if not n.wimster then n.wimster = {} end
	if not n.wimster[n.myRealm] then n.wimster[n.myRealm] = {} end
	if not n.wimster[n.myRealm][n.myName] then n.wimster[n.myRealm][n.myName] = {} end
	if not n.wimster[n.myRealm][n.myName][target] then n.wimster[n.myRealm][n.myName][target] = {} end
	local logArray = n.wimster[n.myRealm][n.myName][target]
	--print( strfind( msg, "|K%a+%d+|k"), self.tabber.tabs[tabID].name)

	local array = { msg = msg, time = time(), event = event}

	--CheckLine( yo_ChatHistory)
	logArray.colorLine = colorLine
	tinsert( logArray, array)
end

local function OutString(self, event, text, unit, guid, btag)
	local colStr 	= " |r["
	local ender 	= "] "
	local time 		= date("%H:%M", time())
	local tabID 	= CheckTabForUnit( self, unit, guid, btag)
	local tab 		= self.tabber.tabs[tabID]
	local target 	= unit
	local colorLine



	if tab.class then
		local r, g, b = unpack( oUF.colors.class[tab.class])
		colorLine = hex( r, g, b)
		colStr 	= colStr .. colorLine
		ender 	= "|r] "
	end

	if strfind( event, "INFORM") then
		colStr 	= " |r[" .. n.myColorStr
		unit 	= n.myName
		ender 	= "|r] "
	elseif btag then
		unit = unit:gsub( "|K%a+%d+|k", strsplit( "#", self.tabber.tabs[tabID].fullTag))
	else
		unit = Ambiguate( unit, "short")
	end

	if btag then colorLine = hex( self.cols[event].r, self.cols[event].g, self.cols[event].b) end

	local msg = colStr .. unit .. ender .. text

	SaveLines( self, msg, event, tabID, target, btag, colorLine)
	tab.textBox:AddMessage( "|cffffcc00" .. time .. msg, self.cols[event].r, self.cols[event].g, self.cols[event].b, 1)
end

-----------------------------------------------------------------------------------
--		EVENTS
-----------------------------------------------------------------------------------
local function OnEvent( self, event, ...)
	--print(event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if not yo.Chat.wim then return end

		self:RegisterEvent("CHAT_MSG_WHISPER")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER")
		self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")

		self.wimHMaxistory	= yo.Chat.wimMaxHistory
		self.wimPrehistoric	= yo.Chat.wimPrehistoric

		n.wimster = _G.yo_WIMSTER
		CreateWIM( self)
		hooksecurefunc("ChatEdit_ExtractTellTarget", CF_ExtractTellTarget);
		hooksecurefunc("ChatFrame_SendBNetTell", ChatFrame_SendBNet)

		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", myChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", myChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)

		local ChatEdit_GetActiveWindow_orig = ChatEdit_GetActiveWindow;
		function ChatEdit_GetActiveWindow()
			local edID, editBox = self.tabber.focused
			if edID then
				editBox = self.tabber.tabs[edID].editBox
			end
    		return editBox or ChatEdit_GetActiveWindow_orig()
		end

	elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
		local text, fullName, _, _, unit, _, _, _, _, _, _, guid = ...
		OutString( self, event, text, unit, guid, nil)

	elseif event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
		local text, unit, _, _, _, _, _, _, _, _, _, _, btag = ...
		OutString( self, event, text, unit, nil, btag)

	elseif event == "PLAYER_REGEN_DISABLED" then
		if not yo.Chat.wimFigter then return end
		if self:IsShown() and not self.tabber.focused then
			self.needShow = true
			self:Hide()
		else
			self.needShow = false
		end

	elseif event == "PLAYER_REGEN_ENABLED" then
		if not yo.Chat.wimFigter then return end
		if self.needShow then
			self:Show()
			self.needShow = false
		end
	end
end

local wim = CreateFrame("Frame", "yo_WIM", UIParent)
wim:RegisterEvent("PLAYER_ENTERING_WORLD")
wim:SetScript("OnEvent", OnEvent)
yoEF.wim = wim

tinsert( UISpecialFrames, "yo_WIM")
-----------------------------------------------------------------------------------
--		local functions
-----------------------------------------------------------------------------------

wim.cols = {
	["CHAT_MSG_WHISPER"]			= {	r = 0.560, g = 0.031, b = 0.760, d = " > "},
	["CHAT_MSG_WHISPER_INFORM"]		= {	r = 1.000, g = 0.078, b = 0.988, d = " < "},
	["CHAT_MSG_BN_WHISPER"]			= { r = 0.000, g = 0.486, b = 0.654, d = " > "},
	["CHAT_MSG_BN_WHISPER_INFORM"]	= {	r = 0.172, g = 0.635, b = 1.000, d = " < "},
}

wim.ResizeTabs = function( self)
	if not self.lastTab then return end

	for ind = self.minTab or 1, self.lastTab do
		local tab = self.tabs[ind]
		if tab then
			tab:SetWidth((( self:GetWidth() +0) - 4 * ( self.tabCount -1)) / ( self.tabCount ))
		end
	end
end

local splitMessage, splitMessageLinks = {}, {};

function SendSplitMessage( theMsg, to, btag)
	-- parse out links as to not split them incorrectly.
	theMsg, results = string.gsub(theMsg, "(|H[^|]+|h[^|]+|h)", function(theLink)
		table.insert(splitMessageLinks, theLink);
		return "\001\002"..paddString(#splitMessageLinks, "0", string.len(theLink)-4).."\003\004";
	end)

	-- split up each word.
	SplitToTable(theMsg, "%s", splitMessage);

	--reconstruct message into chunks of no more than 255 characters.
	local chunk = "";
	for i=1, #splitMessage + 1 do
		if(splitMessage[i] and string.len(chunk) + string.len(splitMessage[i]) <= 254) then
			chunk = chunk..splitMessage[i].." ";
		else
			-- reinsert links of necessary
			chunk = string.gsub(chunk, "\001\002%d+\003\004", function(link)
				local index = tonumber(string.match(link, "(%d+)"));
				return splitMessageLinks[index] or link;
			end);

			chunk = string.gsub( chunk, '%s+$', '')  -- remove spaces end end

			if btag then
				BNSendWhisper( btag, chunk)
			else
				SendChatMessage( chunk, "WHISPER", "Common", to);
            end
			chunk = (splitMessage[i] or "").." ";
		end
	end

	-- clean up
	for k, _ in pairs(splitMessage) do
		splitMessage[k] = nil;
	end
	for k, _ in pairs(splitMessageLinks) do
		splitMessageLinks[k] = nil;
	end
end

function wim:editBoxOnterPressed()
	local text 	= self:GetText()
	if #text < 1 then self:ClearFocus() return end

	if strsub(text, 0, 1) == "/" then
		ChatFrame1EditBox:SetText( text)
		ChatEdit_SendText( ChatFrame1EditBox, true)
		self:AddHistoryLine( text)
		self:SetText( "")
		return
	end

	local tabID = wim.tabber.checked
	local tab 	= wim.tabber.tabs[tabID]

	if tab and tab.name then
		if tab.btag then
           	SendSplitMessage( text, nil, tab.btag)
		else
           	SendSplitMessage( text, tab.fullName)
		end
	end
	self:AddHistoryLine(text)
	self:SetText("")
	--self:ClearFocus()
end

function wim:ignoreOnEnter()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].name

		if C_FriendList.IsIgnored( name) then
			self.text = UNIGNORE_QUEST
		else
			self.text = IGNORE_QUEST
		end

		self.text2 = name
	else
		self.text2 = nil -- "i cant do this"
	end
	wim.tooltipShow( self)
end

function wim:ignoreOnClick()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].name
		if C_FriendList.IsIgnored( name) then
			C_FriendList.DelIgnore( name)
			print( "|cffffff00Вы успокоились и больше не игнорите " .. name)
		else
			C_FriendList.AddIgnore( name)
		end
	end
end

function wim:inviteOnClick()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].fullName
		C_PartyInfo.InviteUnit( name)
	else
		if wim.tabber.tabs[tabID] and wim.tabber.tabs[tabID].btag then
			local btag = wim.tabber.tabs[tabID].btag
			local bAcc = C_BattleNet.GetFriendAccountInfo( btag)
			local client = bAcc.gameAccountInfo.clientProgram
			local toonID = bAcc.gameAccountInfo.gameAccountID

			--local toonID, client = select( 6, BNGetFriendInfoByID( btag))
			if client == "WoW" then
				BNInviteFriend( toonID)
			end
		end
	end
end

function wim:inviteOnEnter()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= Ambiguate( wim.tabber.tabs[tabID].fullName, "none")
		self.text2 = name
	else
		if wim.tabber.tabs[tabID] and wim.tabber.tabs[tabID].btag then
			local btag = wim.tabber.tabs[tabID].btag
			local bAcc = C_BattleNet.GetFriendAccountInfo( btag)
			local client = bAcc.gameAccountInfo.clientProgram

			if client == "WoW" then
				local class = bAcc.gameAccountInfo.className

				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				local classCol 	= (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
				local levelCol 	= hex( GetQuestDifficultyColor( bAcc.gameAccountInfo.characterLevel))
				self.text2 =  levelCol .. bAcc.gameAccountInfo.characterLevel .. "|r |c" .. classCol .. bAcc.gameAccountInfo.characterName .. " |cff999999(" .. bAcc.gameAccountInfo.realmName .. ")"
			else
				self.text2 = nil  --"i cant do this"
			end
		else
			self.text2 = nil 	--"i cant do this"
		end
	end
	wim.tooltipShow( self)
end

function wim:onFigterEnter()
	self.text = yo.Chat.wimFigter and "Hider" or "Don`t hider"
	self.text2 = yo.Chat.wimFigter and "Hide the window in combat and show after" or "Do nothing ( like you all your life)"
	wim.tooltipShow( self)
end

function wim:tooltipHide()	GameTooltip:Hide() end
function wim:tooltipShow()	GameTooltip:SetOwner(self);
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.text)
	if self.text2 then
		if self.text2desc then
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(self.text2, self.text2desc, 1, 1, 1)
		else
			GameTooltip:AddLine(self.text2, 1, 1, 1)
		end
	end
	GameTooltip:Show()
end

function wim:startFlash(object, duration, loop)
	if object.GetNormalTexture then
		object:GetNormalTexture():SetVertexColor( 0, 1, 0, 1)
	end
	if not object.anim then
		SetUpAnimGroup(object, loop and "FlashLoop" or 'Flash', 1, 0.2)
	end

	if not object.anim.playing then
		object.anim.fadein:SetDuration(duration * .2)
		object.anim.fadeout:SetDuration(duration)
		object.anim:Play()
		object.anim.playing = true
	end
end

function wim:stopFlash(object)
	if object.GetNormalTexture then
		object:GetNormalTexture():SetVertexColor( 1, 1, 1, 1)
	end
	if object.anim and object.anim.playing then
		object.anim:Stop()
		object.anim.playing = nil;
	end
end

function myChatFilter(self, event, msg, author, ...)
	return wim:IsShown()
end

-----------------------------------------------------------------------------------
-- 	copy button
-----------------------------------------------------------------------------------
local sizes = {
	":14:14",
	":15:15",
	":16:16",
	":12:20",
	":14"
}

local function CreatCopyFrame()
	local copyFrame = CreateFrame("Frame", nil, UIParent)
	CreateStyle(copyFrame, 2, nil, 0.7)
	--copyFrame:SetPoint("TOPLEFT", wim, "BOTTOMLEFT", 0, -10)
	--copyFrame:SetPoint("TOPRIGHT", wim, "BOTTOMRIGHT", 0, -10)
	copyFrame:SetFrameStrata("DIALOG")
	copyFrame:Hide()
	wim.copyFrame = copyFrame

	local editBox = CreateFrame("EditBox", nil, copyFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(199999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont( yo.Chat.chatFont, yo.Chat.chatFontsize +1 )
	editBox:SetHeight(350)
	editBox:SetScript("OnEscapePressed", function() copyFrame:Hide() end)
	editBox:SetScript("OnTextSet", function(self)
		local text = self:GetText()

		for _, size in pairs(sizes) do
			if string.find(text, size) and not string.find(text, size.."]") then
				self:SetText(string.gsub(text, size, ":12:12"))
			end
		end
	end)
	copyFrame.editBox = editBox

	local scrollArea = CreateFrame("ScrollFrame", nil, copyFrame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", copyFrame, "TOPLEFT", 6, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", copyFrame, "BOTTOMRIGHT", -30, 6)
	scrollArea:SetScrollChild(editBox)
	copyFrame.scrollArea = scrollArea

	copyFrame.close = CreateFrame("Button", nil, copyFrame, "UIPanelCloseButton")
	copyFrame.close:SetPoint("TOPRIGHT", copyFrame, "TOPRIGHT", 0, 0)
end

function wim:CopyTextBox()
	local tabID = wim.tabber.checked
	if not tabID or not wim.tabber.tabs[tabID] then return end

	if not wim.copyFrame then CreatCopyFrame() end

	local textBox = wim.tabber.tabs[tabID].textBox
	local editBox = wim.copyFrame.editBox

	editBox:SetText("")

	for i = 1, textBox:GetNumMessages() do
		--text = text.. textBox:GetMessageInfo(i).."\n"
		local text = textBox:GetMessageInfo(i).."\n"
		text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}")
		text = text:gsub("|[Tt][^|]+|[Tt]", "")
		--text = text:gsub( "|", "")
		editBox:Insert( text)
	end
	--text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}")
	--text = text:gsub("|[Tt][^|]+|[Tt]", "")
	--print(text)
	local sh, a1, p1, a2, a3, p2, a4 = whereAreYouAre( wim, true, true)

	wim.copyFrame:ClearAllPoints()
	wim.copyFrame:SetPoint( a1, p1, a2, 0, 10 * sh)
	wim.copyFrame:SetPoint( a3, p2, a4, 0, 10 * sh)

	wim.copyFrame:SetWidth( wim:GetWidth())
	wim.copyFrame:SetHeight(wim:GetHeight() * 0.75)
	wim.copyFrame.editBox:SetWidth( wim:GetWidth() -30)

	--wim.copyFrame.editBox:SetText( text)
	wim.copyFrame:SetShown( not wim.copyFrame:IsShown())
end

-----------------------------------------------------------------------------------
-- 	tellTarget Hooks
-----------------------------------------------------------------------------------
local tellTargetExtractionAutoComplete = AUTOCOMPLETE_LIST.WHISPER_EXTRACT
function CF_ExtractTellTarget(editBox, msg)
	--DEFAULT_CHAT_FRAME:AddMessage("Raw: ".. "msg") -- debugging
	local target = string.match(msg, "%s*(.*)");

	if (not target or not string.find(target, "%s") or (string.sub(target, 1, 1) == "|")) then return false; end

	if ( #GetAutoCompleteResults(target, 1, 0, true, tellTargetExtractionAutoComplete.include, tellTargetExtractionAutoComplete.exclude) > 0 ) then	return false;  	end

  	 while ( strfind(target, "%s") ) do
    	target = strmatch(target, "(.+)%s+[^%s]*");
    	if ( #GetAutoCompleteResults(target, 1, 0, true, tellTargetExtractionAutoComplete.include, tellTargetExtractionAutoComplete.exclude) > 0 ) then	break; end
  	end

  	--target = Ambiguate( target, "none")
	ChatEdit_OnEscapePressed(editBox);
	wim:Show()
	CheckTabForUnit( wim, target, nil, nil, true)
end

function ChatFrame_SendBNet( token)
	local editBox 	= ChatEdit_ChooseBoxForSend();
	local btag		= GetAutoCompletePresenceID( token)

	ChatEdit_OnEscapePressed( editBox);
	wim:Show()
	CheckTabForUnit( wim, token, nil, btag, true)
end

-----------------------------------------------------------------------------
--		/tt /ee
-----------------------------------------------------------------------------
for i=1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		if text:len() < 7 then
			if text:sub(1, 4) == "/tt " or text:sub(1, 6) == "/ее " then
				local unitname, realm = UnitName("target")
				if unitname then
					if unitname then unitname = gsub(unitname, " ", "") end
					if unitname and not UnitIsSameServer("player", "target") then
						unitname = unitname .. "-" .. gsub(realm, " ", "")
					end

					ChatFrame_SendTell((unitname), ChatFrame1)
				end
			end
		end
	end)
end

SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/ее"
SlashCmdList.TELLTARGET = function(msg)
	SendChatMessage(msg, "WHISPER")
end

ns.wimToggle = function(...)
	if not yoEF.wim:IsShown() then
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
	else
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
	end

	yoEF.wim:SetShown( not yoEF.wim:IsShown())
end


--wim.insertLink = function( link)
--	if link then
--		local edID = wim.tabber.focused
--		if edID then
--			local text = wim.tabber.tabs[edID].editBox:GetText() .. link .. " "
--			wim.tabber.tabs[edID].editBox:SetText( text)
--		end
--	end
--	return orig_ChatEdit_InsertLink( link)
--end
--orig_ChatEdit_InsertLink = ChatEdit_InsertLink;
--ChatEdit_InsertLink = self.insertLink

--hooksecurefunc("SetItemRef", tester)
--RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnHyperlinkClick", function(self, link, text, button) SetItemRef(link, text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""), button, self); end);