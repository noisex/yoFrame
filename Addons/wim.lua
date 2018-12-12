local addon, ns = ...
local L, yo, N = unpack( ns)
local oUF = ns.oUF

local minAlpha = 0.6

local function UpdateTabs( self)
	if not self.lastTab then return end

	local prevInd = 0
	for ind = self.minTab or 1, self.lastTab do
		local tab = self.tabs[ind]
		if tab then
			tab:SetWidth( (( self:GetWidth()- 2) - 5 * ( self.tabCount - 1)) / ( self.tabCount))

			if self.tabUpdate then
				tab:ClearAllPoints()

				--print(ind, tab:GetID(), prevInd, lastTab, tab)

				if prevInd == 0 then
					self.minTab = tab:GetID()
					tab:SetPoint("LEFT", self, "LEFT", 1, 0)
				else
					tab:SetPoint("LEFT", self.tabs[prevInd], "RIGHT", 5, 0)
				end
				prevInd = tab:GetID()
			end

			local r, g, b = 0.7, 0.7, 0.7
			if tab.class then
				r, g, b = unpack( oUF.colors.class[tab.class])
			elseif tab.bTag then
				r, g, b = 0, 0.4862745098039216, 0.6549019607843137
			end

			tab.text:SetTextColor(r, g, b)

			if self.checked == tab:GetID() then
				tab.shadow:SetBackdropColor(r, g, b, 0.6)
				tab.shadow:SetBackdropBorderColor( r, g, b, 1)
			else
				tab.shadow:SetBackdropColor(r, g, b, 0.15)
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
	text:SetFont( font, fontsize - 1, "OUTLINE")
	text:SetPoint("TOPLEFT", 0, -1)
	text:SetPoint("BOTTOMRIGHT", 0, 1)
	text:SetJustifyV("MIDDLE")
	text:SetJustifyH("CENTER")
	tab.text = text

	local tabNum = tab:CreateFontString(nil, "OVERLAY")
	tabNum:SetFont( fontpx, fontsize, "OUTLINE")
	tabNum:SetPoint("TOPLEFT", 0, 2)
	tab.tabNum = tabNum

	local hover = tab:CreateTexture(nil, "OVERLAY")
	hover:SetTexture( texture)
	hover:SetVertexColor( 0, 1, 0, 1)
	hover:SetPoint("TOPLEFT", -1, 1)
	hover:SetPoint("BOTTOMRIGHT", 1, -1)
	hover:SetAlpha( 0.3)
	tab.hover = hover
	tab:SetHighlightTexture( hover)

	tab:SetScript("OnClick", function( this, button)
		if button == "LeftButton" then
			self.checked = tab:GetID()
		else
			Kill( self.tabs[tab:GetID()])
			self.tabs[tab:GetID()] = nil
			self.tabCount = self.tabCount - 1
			self.tabUpdate = true
		end
		UpdateTabs( self)
	end)

	self.lastTab = ID
	CreateStyleSmall( tab, 1, 10)
	return tab
end

local function CheckTabForUnit(self, guid, unit, bTag)
	local findUnit, tabID
	if unit then
		for ind, tab in pairs( self.tabber.tabs) do
			if unit == tab.fullName then
				self:Show()
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

	if bTag then
		self.tabber.tabs[tabID].name 	= unit
		self.tabber.tabs[tabID].bTag 	= bTag
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
		self.tabber.tabs[tabID].class 	= select( 2, UnitClass( unit))
		self.tabber.tabs[tabID].guild 	= GetGuildInfo( unit)

		--print( name, realm, self.tabber.tabs[tabID].guild, self.tabber.tabs[tabID].class)
	end

	if self:IsShown() then
		--self.editBox:SetFocus()
	end

	self.tabber.checked = tabID
	UpdateTabs( self.tabber)
	self:Show()
	return tabID
end

local function CreateWIM( self)
	self:SetSize( 350, 250)
	self:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
	self:Hide()
	self:EnableMouse( true)
	self:SetMovable( true)
	self:SetResizable(true)
	self:SetMinResize( 300, 200)
	self:SetClampedToScreen(true)
	self:RegisterForDrag( "LeftButton")
	self:SetScript("OnDragStart", function() self:StartMoving() end)
	self:SetScript("OnDragStop", function() self:StopMovingOrSizing() end)

	self:SetScript("OnEnter", function() self:SetAlpha(1) end)
	self:SetScript("OnLeave", function() self:SetAlpha( minAlpha) end)
	--self:SetScript("OnEscapePressed", function(self) self:Hide() end)

	local hider = CreateFrame("Button", nil, self)
	hider:SetSize( 22, 22)
	hider:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, -2)
	hider:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-ScrollEnd-Up")
	hider:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatIcon-ScrollEnd-Down")
	hider:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	hider.text = "Hide frame"
	hider:SetScript("OnClick", function() self:Hide() end)
	hider:SetScript("OnEnter", self.Tooltip_Show)
	hider:SetScript("OnLeave", self.Tooltip_Hide)
	self.hider = hider

	local guild = CreateFrame("Button", nil, self)
	guild:SetSize( 22, 22)
	guild:SetPoint("TOP", self.hider, "BOTTOM", 0, 3)
	guild.text = "Guild list"
	guild:SetNormalTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Large-Up")
	guild:SetPushedTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Large-Down")
	guild:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	guild:SetScript("OnMouseDown", function(self, button) N.InfoGuild:ShowGuild( button) end)
	guild:SetScript("OnEnter", self.Tooltip_Show)
	guild:SetScript("OnLeave", self.Tooltip_Hide)
	self.guild = guild

	local friends = CreateFrame("Button", nil, self)
	friends:SetSize( 22, 22)
	friends:SetPoint("TOP", self.guild, "BOTTOM", 0, 3)
	friends.text = "Friends list"
	friends:SetNormalTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Small-Up")
	friends:SetPushedTexture( 	"Interface\\FriendsFrame\\UI-FriendsList-Small-Down")
	friends:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	friends:SetScript("OnMouseDown", function(self, button) N.InfoFriend:ShowFiends( button) end)
	friends:SetScript("OnEnter", self.Tooltip_Show)
	friends:SetScript("OnLeave", self.Tooltip_Hide)
	self.friends = friends

	local invite = CreateFrame("Button", nil, self)
	invite:SetSize( 22, 22)
	invite:SetPoint("TOP", self.friends, "BOTTOM", 0, 3)
	invite.text = "Invite this"
	invite.text2 = "don`t work"
	invite:SetNormalTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Up")
	invite:SetPushedTexture( 	"Interface\\CHATFRAME\\UI-ChatRosterIcon-Down")
	invite:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--invite:SetScript("OnClick", function() self:Hide() end)
	invite:SetScript("OnEnter", self.Tooltip_Show)
	invite:SetScript("OnLeave", self.Tooltip_Hide)
	self.invite = invite

	local info = CreateFrame("Button", nil, self)
	info:SetSize( 22, 22)
	info:SetPoint("TOP", self.invite, "BOTTOM", 0, 3)
	info.text = "Info about this"
	info.text2 = "don`t work"
	info:SetNormalTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Up")
	info:SetPushedTexture( 		"Interface\\CHATFRAME\\UI-ChatIcon-Chat-Down")
	info:SetHighlightTexture( 	"Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--info:SetScript("OnClick", function() self:Hide() end)
	info:SetScript("OnEnter", self.Tooltip_Show)
	info:SetScript("OnLeave", self.Tooltip_Hide)
	self.info = info

	local ignore = CreateFrame("Button", nil, self)
	ignore:SetSize( 21, 21)
	ignore:SetPoint("TOP", self.info, "BOTTOM", 0, 2)
	ignore.text = "Ignore this"
	ignore.text2 = "don`t work"
	ignore:SetNormalTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeUnhealthy")
	ignore:SetPushedTexture( 	"Interface\\CHARACTERFRAME\\UI-Player-PlayTimeTired")
	ignore:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--ignore:SetScript("OnClick", function() self:Hide() end)
	ignore:SetScript("OnEnter", self.Tooltip_Show)
	ignore:SetScript("OnLeave", self.Tooltip_Hide)
	self.ignore = ignore

	local grabber = CreateFrame("Button", nil, self)
	grabber:SetSize( 14, 14)
	grabber:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	grabber:SetNormalTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grabber:SetHighlightTexture( 	"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grabber:SetPushedTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grabber:RegisterForDrag("LeftButton")
	grabber:SetScript("OnDragStart", function() self:StartSizing() self.resize = true end)
	grabber:SetScript("OnDragStop", function() self:StopMovingOrSizing() self.resize = false end)
	self.grabber = grabber

	--local adder = CreateFrame("Button", nil, self)
	--adder:SetSize(25, 30)
	--adder:SetPoint("LEFT", self, "RIGHT", 10, 0)
	--adder:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	--adder:SetScript("OnClick", function() CheckTabForUnit( self) end)
	--self.adder = adder

	local editBox = CreateFrame('EditBox', nil, self);
	editBox:SetFrameLevel( editBox:GetFrameLevel() + 2);
	editBox:SetHeight( 16)
	editBox:SetText("")
	editBox:SetAutoFocus(false)
	editBox:SetFont( font, fontsize)
	editBox:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 6, 6);
	editBox:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -20, 6);
	editBox:SetScript("OnEscapePressed", function() editBox:ClearFocus() self:Hide() end)
	editBox:SetScript("OnEditFocusLost", function(self) self:ClearFocus() end)
	editBox:SetScript("OnEditFocusGained", editBox.HighlightText);
	editBox:SetScript("OnEnterPressed", function()
		local tabID = self.tabber.checked
		local tab 	= self.tabber.tabs[tabID]
		if tab and tab.name then
			if tab.bTag then
				local text = editBox:GetText()
				local bTag = tab.bTag
				BNSendWhisper( bTag, text)
			else
				local unit = tab.name
				local text = editBox:GetText()
				SendChatMessage(text, "WHISPER", "Common", unit);
			end
		end
		editBox:SetText("")
		editBox:ClearFocus() end)

	editBox:SetScript("OnLeave", function()
		self:SetAlpha( minAlpha)
		editBox:ClearFocus() end)

	editBox:SetScript("OnEnter", function() self:SetAlpha(1) end)
	self.editBox = editBox

	self.tabber = CreateFrame("Frame", nil, self)
	self.tabber:SetHeight( 18)
	--self.tabber:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -4)
	--self.tabber:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -4)
	self.tabber:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
	self.tabber:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
	self.tabber:SetScript("OnSizeChanged", function() UpdateTabs( self.tabber) end)

	local textBox = CreateFrame("ScrollingMessageFrame", nil, self)
	textBox:SetFont( font, fontsize +1, "OUTLINE")
	textBox:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
	textBox:SetPoint("BOTTOMRIGHT", self.editBox, "TOPRIGHT", 0, 6)
	textBox:SetInsertMode( "BOTTOM")
	textBox:SetJustifyH("LEFT")
	textBox:SetMaxLines( 10)
	textBox:SetFading( false)
	self.textBox = textBox

	self.tabber.tabs = {}
	self.tabber.checked = 1
	self.tabber.tabCount = 0
	self.tabber.lastTab = 0
	self.tabber.tabUpdate = true

	CreateStyle( textBox, 2, nil, 0.7)
	CreateStyle( editBox, 2, nil, 0.7)
	CreateStyle( self, 2, nil, 0.6)
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		CreateWIM( self)

	elseif event == "CHAT_MSG_WHISPER" then
		self:Show()
		local time = date("%H:%M", time())
		local text, fullName, _, _, unit, _, _, _, _, _, _, guid = ...
		unit = 	Ambiguate( unit, "none")
		CheckTabForUnit( self, guid, unit)
		self.textBox:AddMessage( time .. " [".. unit .. "] > " .. text, 0.5607843137254902, 0.03137254901960784, 0.7607843137254902, 1)

	elseif event == "CHAT_MSG_WHISPER_INFORM" then
		local time = date("%H:%M", time())
		local text, fullName, _, _, unit, _, _, _, _, _, _, guid = ...
		unit = 	Ambiguate( unit, "none")
		CheckTabForUnit( self, guid, unit)
		self.textBox:AddMessage( time .. " [".. unit .. "] < " .. text,   1, 0.07843137254901961, 0.9882352941176471, 1)

	elseif event == "CHAT_MSG_BN_WHISPER_INFORM" then
		local time = date("%H:%M", time())
		local text, unit, _, _, _, _, _, _, _, _, _, _, bTag = ...
		CheckTabForUnit( self, nil, unit, bTag)
		self.textBox:AddMessage( time .. " [".. unit .. "] < " .. text, 0.1725490196078431, 0.6352941176470588, 1, 1)

	elseif event == "CHAT_MSG_BN_WHISPER" then
		local time = date("%H:%M", time())
		local text, unit, _, _, _, _, _, _, _, _, _, _, bTag = ...
		CheckTabForUnit( self, nil, unit, bTag)
		self.textBox:AddMessage( time .. " [".. unit .. "] > " .. text, 0, 0.4862745098039216, 0.6549019607843137, 1)

	elseif event == "PLAYER_REGEN_DISABLED" then
		if self:IsShown() and not self.editBox:HasFocus() then
			self.needShow = true
			self:Hide()
		else
			self.needShow = false
		end

	elseif event == "PLAYER_REGEN_ENABLED" then
		if self.needShow then
			self:Show( )
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

function wim:Tooltip_Show()
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

function wim:Tooltip_Hide()	GameTooltip:Hide() end

local tellTargetExtractionAutoComplete = _G.AUTOCOMPLETE_LIST.ALL;
local BNet_GetPresenceID = _G.BNet_GetBNetIDAccount or _G.BNet_GetPresenceID
function CF_ExtractTellTarget(editBox, msg)

	local target = string.match(msg, "%s*(.*)");
	local bNetID;
	--_G.DEFAULT_CHAT_FRAME:AddMessage("Raw: "..msg:gsub("|", ":")); -- debugging
	if (target:find("^|K")) then
		target, msg = BNTokenFindName(target);
		bNetID = BNet_GetPresenceID(target);
		--_G.DEFAULT_CHAT_FRAME:AddMessage("Raw: '".. target .. "' " .. bNetID)
		--return false;
	else
		--If we haven't even finished one word, we aren't done.
		if (not target or not string.find(target, "%s") or (string.sub(target, 1, 1) == "|")) then
			return false;
		end

		while (string.find(target, "%s")) do
			--Pull off everything after the last space.
			target = string.match(target, "(.+)%s+[^%s]*");
			target = Ambiguate(target, "none")
			if (_G.GetAutoCompleteResults(target, 1, 0, tellTargetExtractionAutoComplete.include, tellTargetExtractionAutoComplete.exclude, 1, nil, true)) then
				break;
			end
		end
	end

	--_G.DEFAULT_CHAT_FRAME:AddMessage("Raw: '".. target .. "'")

	_G.ChatEdit_OnEscapePressed(editBox);

	CheckTabForUnit( wim, nil, target, bNetID)
end

hooksecurefunc("ChatEdit_ExtractTellTarget", CF_ExtractTellTarget);
