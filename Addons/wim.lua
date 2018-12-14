local addon, ns = ...
local L, yo, N = unpack( ns)
local oUF = ns.oUF

local minAlpha = 1

local cols = {
	["CHAT_MSG_WHISPER"]			= {	r = 0.560, g = 0.031, b = 0.760, d = " > "},
	["CHAT_MSG_WHISPER_INFORM"]		= {	r = 1.000, g = 0.078, b = 0.988, d = " < "},
	["CHAT_MSG_BN_WHISPER"]			= { r = 0.000, g = 0.486, b = 0.654, d = " > "},
	["CHAT_MSG_BN_WHISPER_INFORM"]	= {	r = 0.172, g = 0.635, b = 1.000, d = " < "},
}

CreateAnchor("yo_MoveWIM", 	"Move PM Chat", 350, 250, 0, 0, "LEFT", "LEFT")

local function UpdateTabs( self)
	if not self.lastTab then return end

	local prevInd = 0
	for ind = self.minTab or 1, self.lastTab do
		local tab = self.tabs[ind]
		if tab then
			tab:SetWidth((( self:GetWidth() +0) - 3 * ( self.tabCount -1)) / ( self.tabCount ))
--self.resize
			if self.tabUpdate then
				tab:ClearAllPoints()

				if prevInd == 0 then
					self.minTab = tab:GetID()
					tab:SetPoint("LEFT", self, "LEFT", 0, 0)
				else
					tab:SetPoint("LEFT", self.tabs[prevInd], "RIGHT", 3, 0)
				end
				prevInd = tab:GetID()
			end

			local r, g, b = 0.7, 0.7, 0.7
			if tab.class then
				r, g, b = unpack( oUF.colors.class[tab.class])
			elseif tab.btag then
				r, g, b = 0, 0.4862745098039216, 0.6549019607843137
			end

			tab.text:SetTextColor(r, g, b)
			tab.shadow:SetBackdropColor( 0.2, 0.2, 0.1, 0.9)

			if self.checked == tab:GetID() then
				tab.textBox:Show()
				tab.editBox:Show()
				tab.editBox:SetFocus()
				--tab.shadow:SetBackdropColor(r, g, b, 0.8)
				tab.shadow:SetBackdropBorderColor( r, g, b, 1)
			else
				tab.textBox:Hide()
				tab.editBox:Hide()
				tab.editBox:ClearFocus()
				--tab.shadow:SetBackdropColor(r, g, b, 0.15)
				tab.shadow:SetBackdropBorderColor( 0, 0, 0, 0.7)
			end

			tab.tabNum:SetText( tab:GetID())
			tab.text:SetText( tab.name)

			self.lastTab = tab:GetID()
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

	local text = tab:CreateFontString(nil, "OVERLAY")
	text:SetFont( font, fontsize)	--, "OUTLINE")
	text:SetShadowOffset(1, -1)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetPoint("TOPLEFT", 0, -1)
	text:SetPoint("BOTTOMRIGHT", 0, 1)
	text:SetJustifyV("MIDDLE")
	text:SetJustifyH("CENTER")
	tab.text = text

	local tabNum = tab:CreateFontString(nil, "OVERLAY")
	tabNum:SetFont( fontpx, fontsize, "OUTLINE")
	tabNum:SetPoint("TOPLEFT", 1, 1)
	tab.tabNum = tabNum

	local hover = tab:CreateTexture(nil, "OVERLAY")
	hover:SetTexture( texture)
	hover:SetVertexColor( 0.5, 0.5, 0, 0.5)
	hover:SetPoint("TOPLEFT", -1, 1)
	hover:SetPoint("BOTTOMRIGHT", 1, -1)
	hover:SetAlpha( 0.3)
	tab.hover = hover
	tab:SetHighlightTexture( hover)

	local editBox = CreateFrame('EditBox', nil, self);
	editBox:SetFrameLevel( editBox:GetFrameLevel() + 2);
	editBox:SetHeight( 16)
	editBox:SetText("")
	editBox:SetAutoFocus(false)
	editBox:SetHistoryLines(32);
	--editBox:SetAltArrowKeyMode(true)
	editBox:SetFont( font, fontsize)
	editBox:SetPoint('BOTTOMLEFT', self:GetParent(), 'BOTTOMLEFT', 6, 6);
	editBox:SetPoint('BOTTOMRIGHT', self:GetParent(), 'BOTTOMRIGHT', -20, 6);
	editBox:SetScript("OnLeave", function() self:SetAlpha( minAlpha) editBox:ClearFocus() end)
	editBox:SetScript("OnEnter", function() self:SetAlpha(1) end)
	editBox:SetScript("OnEscapePressed", function() editBox:ClearFocus() self:Hide() end)
	editBox:SetScript("OnEditFocusLost", function(self) self:ClearFocus() end)
	editBox:SetScript("OnEditFocusGained", editBox.HighlightText)
	editBox:SetScript("OnEnterPressed", self:GetParent().editBoxOnterPressed)
	editBox:SetScript("OnEditFocusGained", function() self.focused = tab:GetID() end)
	editBox:SetScript("OnEditFocusLost", function() if self.focused == tab:GetID() then self.focused = false end end)
	tab.editBox = editBox

	local textBox = CreateFrame("ScrollingMessageFrame", nil, self)
	textBox:SetFont( yo.Chat.chatFont, yo.Chat.fontsize)
	textBox:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", 6, -6)
	textBox:SetPoint("BOTTOMRIGHT", editBox, "TOPRIGHT", 0, 6)
	textBox:SetInsertMode( "BOTTOM")
	textBox:SetJustifyH("LEFT")
	textBox:SetMaxLines( 200)
	textBox:SetMouseMotionEnabled( true)
	textBox:SetHyperlinksEnabled(true)
	textBox:SetFading( false)
	textBox:SetScript("OnEnter", function() self:GetParent():SetAlpha(1) end)
	textBox:SetScript("OnLeave", function() self:GetParent():SetAlpha( minAlpha) end)
	textBox:SetScript("OnMouseWheel", function(self, ...)
        if(select(1, ...) > 0) then
			if( IsControlKeyDown() ) then self:ScrollToTop();
		else 	if( IsShiftKeyDown() ) then self:PageUp() else self:ScrollUp() end end
	    	else 	if( IsControlKeyDown() ) then self:ScrollToBottom()
				else 	if( IsShiftKeyDown() ) then self:PageDown() else self:ScrollDown() end end
	    end
	end)
	--textBox:SetScript("OnDragStart", function() wim:StartMoving() end)
	--textBox:SetScript("OnDragStop", function()
	--	wim:StopMovingOrSizing()
	--	yo_MoveWIM:ClearAllPoints()
	--	yo_MoveWIM:SetPoint( self:GetPoint())
	--	SetAnchPosition( yo_MoveWIM, self)
	--end)
	tab.textBox = textBox

	tab:SetScript("OnEnter", function() self:GetParent():SetAlpha(1) end)
	tab:SetScript("OnLeave", function() self:GetParent():SetAlpha( minAlpha) end)
	tab:SetScript("OnClick", function( this, button)
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
	CreateStyleSmall( tab, 1, 10)
	return tab
end

local function CheckTabForUnit(self, unit, guid, btag)
	local findUnit, tabID
	if unit then

		for ind, tab in pairs( self.tabber.tabs) do
			if strlower( unit) == strlower( tab.fullName) then
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
	end

	if btag then
		self.tabber.tabs[tabID].name 	= unit
		self.tabber.tabs[tabID].btag 	= btag
		self.tabber.tabs[tabID].fullName= unit
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
	elseif unit then
		local name, realm = strsplit( "-", unit)
		self.tabber.tabs[tabID].fullName= unit
		self.tabber.tabs[tabID].name 	= name
		self.tabber.tabs[tabID].realm 	= realm
	end

	--if self:IsShown() then
		--self.editBox:SetFocus()
	--end

	self.tabber.checked = tabID
	UpdateTabs( self.tabber)

	if InCombatLockdown() then
		self.needShow = true
	else
		self.needShow = false
		self:Show()
	end

	return tabID
end

local function CreateWIM( self)
	self:SetSize( yo_MoveWIM:GetSize())
	self:SetPoint("TOPLEFT", yo_MoveWIM, "TOPLEFT", 0, 0)
	self:Hide()
	self:EnableMouse( true)
	self:SetMovable( true)
	self:SetResizable(true)
	self:SetMinResize( 300, 200)
	self:SetClampedToScreen(true)
	self:RegisterForDrag( "LeftButton")
	self:SetScript("OnDragStart", function() self:StartMoving() end)
	self:SetScript("OnDragStop", function()
		self:StopMovingOrSizing()
		yo_MoveWIM:ClearAllPoints()
		yo_MoveWIM:SetPoint( self:GetPoint())
		SetAnchPosition( yo_MoveWIM, self)
	end)

	self:SetScript("OnEnter", function() self:SetAlpha(1) end)
	self:SetScript("OnLeave", function() self:SetAlpha( minAlpha) end)
	--self:SetScript("OnEscapePressed", function(self) self:Hide() end)

	self.buttons = {}
	local hider = CreateFrame("Button", nil, self)
	hider:SetSize( 22, 22)
	hider:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, -3)
	hider:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-ScrollEnd-Up")
	hider:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-ScrollEnd-Down")
	hider:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	hider.text = "Hide frame"
	hider:SetScript("OnClick", function() self:Hide() end)
	hider:SetScript("OnEnter", self.tooltipShow)
	hider:SetScript("OnLeave", self.tooltipHide)
	self.buttons.hider = hider

	local guild = CreateFrame("Button", nil, self)
	guild:SetSize( 22, 22)
	guild:SetPoint("TOP", hider, "BOTTOM", 0, -20)
	guild.text = "Guild list"
	guild:SetNormalTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Large-Up")
	guild:SetPushedTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Large-Down")
	guild:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	guild:SetScript("OnMouseDown", function(self, button) N.InfoGuild:ShowGuild( button) end)
	guild:SetScript("OnEnter", self.tooltipShow)
	guild:SetScript("OnLeave", self.tooltipHide)
	self.buttons.guild = guild

	local friends = CreateFrame("Button", nil, self)
	friends:SetSize( 22, 22)
	friends:SetPoint("TOP", guild, "BOTTOM", 0, 3)
	friends.text = "Friends list"
	friends:SetNormalTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Small-Up")
	friends:SetPushedTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Small-Down")
	friends:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	friends:SetScript("OnMouseDown", function(self, button) N.InfoFriend:ShowFiends( button) end)
	friends:SetScript("OnEnter", self.tooltipShow)
	friends:SetScript("OnLeave", self.tooltipHide)
	self.buttons.friends = friends

	local invite = CreateFrame("Button", nil, self)
	invite:SetSize( 22, 22)
	invite:SetPoint("TOP", friends, "BOTTOM", 0, 3)
	invite.text = "Invite"
	invite:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Up")
	invite:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Down")
	invite:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	invite:SetScript("OnClick", self.inviteOnClick)
	invite:SetScript("OnEnter", self.inviteOnEnter)
	invite:SetScript("OnLeave", self.tooltipHide)
	self.buttons.invite = invite

	local info = CreateFrame("Button", nil, self)
	info:SetSize( 22, 22)
	info:SetPoint("TOP", invite, "BOTTOM", 0, 3)
	info.text = "Info about this"
	info.text2 = "don`t work"
	info:SetNormalTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Up")
	info:SetPushedTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Down")
	info:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--info:SetScript("OnClick", function() self:Hide() end)
	info:SetScript("OnEnter", self.tooltipShow)
	info:SetScript("OnLeave", self.tooltipHide)
	self.buttons.info = info

	local ignore = CreateFrame("Button", nil, self)
	ignore:SetSize( 21, 21)
	ignore:SetPoint("TOP", info, "BOTTOM", 0, 2)
	ignore.text = "Ignore this"
	ignore:SetNormalTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeUnhealthy")
	ignore:SetPushedTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeTired")
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
	grabber:SetScript("OnDragStart", function() self:StartSizing() self.resize = true end)
	grabber:SetScript("OnDragStop", function() self:StopMovingOrSizing() self.resize = false end)
	self.buttons.grabber = grabber

	--local editBox = CreateFrame('EditBox', nil, self);
	--editBox:SetFrameLevel( editBox:GetFrameLevel() + 2);
	--editBox:SetHeight( 16)
	--editBox:SetText("")
	--editBox:SetAutoFocus(false)
	--editBox:SetHistoryLines(32);
	----editBox:SetAltArrowKeyMode(true)
	--editBox:SetFont( font, fontsize)
	--editBox:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 6, 6);
	--editBox:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -20, 6);
	--editBox:SetScript("OnLeave", function() self:SetAlpha( minAlpha) editBox:ClearFocus() end)
	--editBox:SetScript("OnEnter", function() self:SetAlpha(1) end)
	--editBox:SetScript("OnEscapePressed", function() editBox:ClearFocus() self:Hide() end)
	--editBox:SetScript("OnEditFocusLost", function(self) self:ClearFocus() end)
	--editBox:SetScript("OnEditFocusGained", editBox.HighlightText)
	--editBox:SetScript("OnEnterPressed", self.editBoxOnterPressed)
	--self.editBox = editBox

	self.tabber = CreateFrame("Frame", nil, self)
	self.tabber:SetHeight( 20)
	--self.tabber:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -4)
	--self.tabber:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -4)
	self.tabber:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 3)
	self.tabber:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 1, 3)
	self.tabber:SetScript("OnSizeChanged", function() UpdateTabs( self.tabber) end)

	self.tabber.tabs = {}
	self.tabber.checked = 1
	self.tabber.tabCount = 0
	self.tabber.lastTab = 0
	self.tabber.tabUpdate = true

	--CreateStyleSmall( editBox, 1, nil, 0.9, 0.7)
	CreateStyle( self, 2, nil, 0.5)
end

local function OutString(self, event, text, unit, guid, btag)
	local colStr 	= " |r["
	local ender 	= "] "
	local time 		= date("%H:%M", time())
	unit = 	Ambiguate( unit, "none")

	local tabID = CheckTabForUnit( self, unit, guid, btag)
	local tab 	= self.tabber.tabs[tabID]

	if tab.class then
		local r, g, b = unpack( oUF.colors.class[tab.class])
		colStr 	= colStr .. hex( r, g, b)
		ender 	= "|r] "
	end

	if strfind( event, "INFORM") then
		colStr 	= " |r[" .. myColorStr
		unit 	= myName
		ender 	= "|r] "
	end
	tab.textBox:AddMessage( "|cffffcc00" .. time .. colStr .. unit .. ender .. text, cols[event].r, cols[event].g, cols[event].b, 1)
end

-----------------------------------------------------------------------------------
--		EVENTS
-----------------------------------------------------------------------------------
local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		CreateWIM( self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	elseif event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" then
		local text, fullName, _, _, unit, _, _, _, _, _, _, guid = ...
		OutString( self, event, text, unit, guid, nil)

	elseif event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM" then
		local text, unit, _, _, _, _, _, _, _, _, _, _, btag = ...
		OutString( self, event, text, unit, nil, btag)

	elseif event == "PLAYER_REGEN_DISABLED" then
		if self:IsShown() and not self.editBox:HasFocus() then
			self.needShow = true
			self:Hide()
		else
			self.needShow = false
		end

	elseif event == "PLAYER_REGEN_ENABLED" then
		if self.needShow then
			self:Show()
			self.needShow = false
		end
	end
end

local wim = CreateFrame("Frame", "yo_WIM", UIParent)
wim:RegisterEvent("PLAYER_ENTERING_WORLD")
wim:RegisterEvent("CHAT_MSG_WHISPER")
wim:RegisterEvent("CHAT_MSG_BN_WHISPER")
wim:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
wim:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
wim:RegisterEvent("PLAYER_REGEN_ENABLED")
wim:RegisterEvent("PLAYER_REGEN_DISABLED")
wim:SetScript("OnEvent", OnEvent)

-----------------------------------------------------------------------------------
--		local functions
-----------------------------------------------------------------------------------
function wim:editBoxOnterPressed()
	print(self)
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
			local btag = tab.btag
			BNSendWhisper( btag, text)
		else
			local unit = tab.name
			SendChatMessage(text, "WHISPER", "Common", unit);
		end
	end
	self:AddHistoryLine(text)
	self:SetText("")
	--self:ClearFocus()
end

function wim:ignoreOnEnter()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].fullName
		self.text2 = name
	else
		self.text2 = "i cant do this"
	end
	wim.tooltipShow( self)
end

function wim:ignoreOnClick()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].fullName
		if IsIgnored( name) then
			DelIgnore( name)
			print( "|cffffff00Вы успокоились и больше не игнорите " .. name)
		else
			AddIgnore( name)
		end
	end
end

function wim:inviteOnClick()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].fullName
		InviteUnit( name)
	end
end

function wim:inviteOnEnter()
	local tabID = wim.tabber.checked
	if tabID and wim.tabber.tabs[tabID] and not wim.tabber.tabs[tabID].btag then
		local name 	= wim.tabber.tabs[tabID].fullName
		self.text2 = name
	else
		self.text2 = "i cant do this"
	end
	wim.tooltipShow( self)
end

function wim:tooltipShow()
	GameTooltip:SetOwner(self);
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
function wim:tooltipHide()	GameTooltip:Hide() end

-----------------------------------------------------------------------------------
-- 	/tt Hooks
-----------------------------------------------------------------------------------
local tellTargetExtractionAutoComplete = AUTOCOMPLETE_LIST.WHISPER_EXTRACT
local function CF_ExtractTellTarget(editBox, msg)
	--_G.DEFAULT_CHAT_FRAME:AddMessage("Raw: ".. "msg") -- debugging
	local target = string.match(msg, "%s*(.*)");

	if (not target or not string.find(target, "%s") or (string.sub(target, 1, 1) == "|")) then return false; end

	if ( #GetAutoCompleteResults(target, 1, 0, true, tellTargetExtractionAutoComplete.include, tellTargetExtractionAutoComplete.exclude) > 0 ) then	return false;  	end

  	 while ( strfind(target, "%s") ) do
    	target = strmatch(target, "(.+)%s+[^%s]*");
    	if ( #GetAutoCompleteResults(target, 1, 0, true, tellTargetExtractionAutoComplete.include, tellTargetExtractionAutoComplete.exclude) > 0 ) then	break; end
  	end

	ChatEdit_OnEscapePressed(editBox);
	wim:Show()
	if wim.tabber.tabs[wim.tabber.checked] then
		wim.tabber.tabs[wim.tabber.checked].editBox:SetFocus()
	end
	CheckTabForUnit( wim, target)
end
hooksecurefunc("ChatEdit_ExtractTellTarget", CF_ExtractTellTarget);

local function ChatFrame_SendBNet( token)
	local editBox 	= ChatEdit_ChooseBoxForSend();
	local btag		= GetAutoCompletePresenceID( token)

	ChatEdit_OnEscapePressed( editBox);
	wim:Show()
	if wim.tabber.tabs[wim.tabber.checked] then
		wim.tabber.tabs[wim.tabber.checked].editBox:SetFocus()
	end
	CheckTabForUnit( wim, token, nil, btag)
end
hooksecurefunc("ChatFrame_SendBNetTell", ChatFrame_SendBNet)