local addon, ns = ...
local L, yo, N = unpack( ns)
local oUF = ns.oUF

local wim = yo_WIM
if not wim then return end

local wimH = CreateFrame("Frame", nil, wim)
local userListCount

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			if kill and type(kill) == 'boolean' then
				region:Kill()
			elseif region:GetDrawLayer() == kill then
				region:SetTexture(nil)
			elseif kill and type(kill) == 'string' and region:GetTexture() ~= kill then
				region:SetTexture(nil)
			else
				region:SetTexture(nil)
			end
		end
	end
end

local function CreateUserListButton( self, ind)
	local button = CreateFrame("Button", nil, self);
	if ind > 1 then
		button:SetPoint("TOPLEFT", self.buttons[ind-1], "BOTTOMLEFT");
		button:SetPoint("TOPRIGHT", self.buttons[ind-1], "BOTTOMRIGHT");
	else
		button:SetPoint("TOPLEFT", self);
		button:SetPoint("TOPRIGHT", self);
	end
	button:SetHeight(20);
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight" , "ADD");
	button:GetHighlightTexture():SetVertexColor(.196, .388, .5);

	button.text = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
	button.text:SetPoint("TOPLEFT");
	button.text:SetPoint("BOTTOMRIGHT", -18, 0);
	button.text:SetJustifyH("LEFT");

	button.delete = CreateFrame("Button", nil, button);
	button.delete:SetNormalTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
	button.delete:SetSize(16, 16)
	button.delete:SetAlpha(.2);
	button.delete:SetPoint("RIGHT");
	button.delete:SetScript("OnEnter", function( self) self:SetAlpha( 0.7) end)
	button.delete:SetScript("OnLeave", function( self) self:SetAlpha( 0.2) end)
	button.delete:SetScript("OnClick", function( this)
		StaticPopupDialogs["WIM_DELETE_HISTORY"] = {
			preferredIndex = STATICPOPUP_NUMDIALOGS,
			text = _G.format( "Delete all history saved for %s on %s?", "|cff69ccf0".. this:GetParent().targetName.."|r", "|cff69ccf0".. this:GetParent().userName.."|r" ),
			button1 = YES, button2 = CANCEL,
			OnAccept = function()
				yo_WIMSTER[this:GetParent().realmName][this:GetParent().userName][this:GetParent().targetName] = nil
				self.updateUserListButtons()
				self.buttons[1]:Click()
			end,
			timeout = 0, whileDead = 1, hideOnEscape = 1 }
		StaticPopup_Show("WIM_DELETE_HISTORY");
	end);

	button:SetScript("OnClick", function( self)
		local textBox = self:GetParent():GetParent().textBox
		local logArray = yo_WIMSTER[self.realmName][self.userName][self.targetName]
		self:GetParent().checked = self.fullName
		textBox:Clear()
		textBox:Show()
		self:GetParent():GetParent().scrollArea:Hide()

		if #logArray > 0 then
			local oldDate
			for ind, info in ipairs( logArray) do
				local col 		= yo_WIM.cols[info.event]
				local newDate 	= date("%d.%m.%Y", info.time)
				local time 		= date("%H:%M", info.time)

				if newDate ~= oldDate then
					textBox:AddMessage( " ")
					textBox:AddMessage( "|cffffcc00 " .. newDate .. " " .. _G["WEEKDAY_" .. string.upper(date("%A", info.time))] )
					oldDate = newDate
				end
				textBox:AddMessage( "|cffffcc00" .. time .. info.msg, col.r, col.g, col.b, 1)
			end
		end
		self:GetParent():GetParent().userList.updateUserListButtons()
	end)

	return button
end

local function CreateHistoryFrame( self)
	if self.textBox then return end

	local userMenu = CreateFrame("Frame", nil, self, "UIDropDownMenuTemplate");
	userMenu:SetPoint("TOPLEFT", -15, 0);
	userMenu:SetScript("OnShow", function(self) UIDropDownMenu_Initialize( userMenu, userMenu.initialize); end)
	StripTextures( userMenu)

	DropDownList1Backdrop:ClearAllPoints()
	DropDownList1Backdrop:SetPoint("TOPLEFT", DropDownList1, "TOPLEFT", 10, 0)
	DropDownList1Backdrop:SetPoint("BOTTOMRIGHT", DropDownList1, "BOTTOMRIGHT", 0, 0)
	StripTextures( DropDownList1Backdrop)
	CreateStyleSmall( DropDownList1Backdrop, 1, nil, 1)

	userMenu.initialize = function()
		local aUserList = {}
		for realm, realmArray in pairs( yo_WIMSTER) do
			table.insert( aUserList, realm)
			if type( realmArray) == "table" then
				for name, nameArray in pairs( realmArray) do
					table.insert( aUserList, realm .. "/" .. name)
				end
			end
		end

		local info = UIDropDownMenu_CreateInfo();
		for i=1, #aUserList do
			info.text 	= aUserList[i];
			info.value 	= aUserList[i];
			info.checked= nil;
			info.func 	= function( this)
				UIDropDownMenu_SetSelectedValue( userMenu, this.value)
				self.userList.updateUserListButtons()
			end
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL)
		end
	end
	self.userMenu = userMenu

	local userList = CreateFrame("Frame", nil, self)
	userList:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -35)
	userList:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 10)
	userList:SetWidth( 150)
	userList.buttons = {};

	userList.createUserList = function( value)
		local realmName, unitName = strsplit( "/", value or userMenu.selectedValue)
		local array = unitName and yo_WIMSTER[realmName][unitName] or yo_WIMSTER[realmName]
		sUserList = {}
		for realm, realmArray in pairs( array) do
			if type( realmArray) == "table" and not unitName then
				for name, nameArray in pairs( realmArray) do
					table.insert( sUserList, realmName .. "/" .. realm .. "/" .. name)
				end
			else
				table.insert( sUserList, realmName .. "/" .. unitName .. "/" .. realm)
			end
		end
		userList.sUserList = sUserList
		return sUserList
	end

   	userList.updateUserListButtons = function()
   		userListCount = floor( userList:GetHeight() / 20 + 0.5)
		local array = userList.createUserList() -- userList.sUserList
		FauxScrollFrame_Update(self.userScroll, #array, userListCount, 20);
		local start = FauxScrollFrame_GetOffset( self.userScroll)

		for ind = 1, userListCount do
			local fullName = array[start + ind]
			self.userList.buttons[ind] = self.userList.buttons[ind] or CreateUserListButton( self.userList, ind)
			if fullName then
				local realmName, userName, targetName = strsplit( "/", fullName)
				local colorLine = yo_WIMSTER[realmName] and yo_WIMSTER[realmName] and yo_WIMSTER[realmName][userName] and yo_WIMSTER[realmName][userName][targetName].colorLine or ""
				self.userList.buttons[ind].fullName 	= fullName
				self.userList.buttons[ind].realmName 	= realmName
				self.userList.buttons[ind].userName 	= userName
				self.userList.buttons[ind].targetName	= targetName
				self.userList.buttons[ind].text:SetText( yo_AllData[realmName][userName].ColorStr .. userName .. "|r/" .. colorLine .. targetName)
				self.userList.buttons[ind]:Show()
				if self.userList.checked == fullName then
					self.userList.buttons[ind]:LockHighlight();
				else
					self.userList.buttons[ind]:UnlockHighlight();
				end
			else
				self.userList.buttons[ind]:Hide()
			end
		end

		for ind = userListCount +1, #self.userList.buttons do self.userList.buttons[ind]:Hide() end
	end
	CreateStyleSmall( userList, 1, nil, 0.7, 0.7)
	self.userList = userList

	local userScroll = CreateFrame("ScrollFrame", nil, userList, "FauxScrollFrameTemplate");
    userScroll:SetPoint("TOPLEFT", userList, "TOPLEFT", 0, 0)
    userScroll:SetPoint("BOTTOMRIGHT", userList, "BOTTOMRIGHT", 0, 0)
   	userScroll:SetScript("OnVerticalScroll", function(this, offset) FauxScrollFrame_OnVerticalScroll( this, offset, 20, self.userList.updateUserListButtons); end);
	self.userScroll = userScroll

	UIDropDownMenu_SetWidth( userMenu, 170)
	UIDropDownMenu_Initialize( userMenu, userMenu.initialize)
	if yo_WIMSTER[myRealm] and yo_WIMSTER[myRealm][myName] then
		UIDropDownMenu_SetSelectedValue( userMenu, myRealm .. "/" .. myName)
		userList.updateUserListButtons()
	elseif yo_WIMSTER[myRealm] then
		UIDropDownMenu_SetSelectedValue( userMenu, myRealm)
		userList.updateUserListButtons()
	end

	local textBox = CreateFrame("ScrollingMessageFrame", nil, self)
	textBox:SetFont( yo.Chat.chatFont, yo.Chat.fontsize)
	textBox:SetPoint("TOPLEFT", userList, "TOPRIGHT", 25, 0)
	textBox:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -10, 10)
	textBox:SetInsertMode( "BOTTOM")
	textBox:SetJustifyH("LEFT")
	textBox:SetMaxLines( 200)
	textBox:SetMouseMotionEnabled( true)
	textBox:SetHyperlinksEnabled(true)
	textBox:SetFading( false)
	textBox:SetScript("OnMouseWheel", function(self, ...)
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
	CreateStyleSmall( textBox, 1, nil, 0.7, 0.7)
	self.textBox = textBox

	local editBox = CreateFrame("EditBox", nil, self)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(199999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont( yo.Chat.chatFont, yo.Chat.fontsize)
	editBox:SetHeight(350)
	editBox:SetWidth(440)
	editBox:SetScript("OnEscapePressed", function( self) self:ClearFocus() end)
	self.editBox = editBox

	local scrollArea = CreateFrame("ScrollFrame", nil, self, "UIPanelScrollFrameTemplate")
	scrollArea:SetScript("OnShow", function() self.viewText.text:SetText("Chat") end)
	scrollArea:SetScript("OnHide", function() self.viewText.text:SetText("Text") end)
	scrollArea:SetPoint("TOPLEFT", userList, "TOPRIGHT", 25, 0)
	scrollArea:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -25, 10)
	scrollArea:SetScrollChild( editBox)
	CreateStyleSmall( scrollArea, 1, nil, 0.7, 0.7)
	scrollArea:Hide()
	self.scrollArea = scrollArea

	local grabber = CreateFrame("Button", nil, self)
	grabber:SetSize( 14, 14)
	grabber:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	grabber:SetNormalTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grabber:SetHighlightTexture( 	"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grabber:SetPushedTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grabber:RegisterForDrag("LeftButton")
	grabber:SetScript("OnDragStart", function() self:StartSizing() end)
	grabber:SetScript("OnDragStop",  function()	self:StopMovingOrSizing()
		Setlers( "Chat#wimHWidth", self:GetWidth())
		Setlers( "Chat#wimHHeight", self:GetHeight())
		self.userList.updateUserListButtons()
	end)
	self:SetScript("OnSizeChanged", function(self) self.userList.updateUserListButtons() end)
	self.grabber = grabber

	local hider = CreateFrame("Button", nil, self, "UIPanelCloseButton")
	hider:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -3)
	self.hider = hider

	local viewText = CreateFrame("Button", nil, self)
	viewText:SetScript("OnEnter", function(self) self:SetBackdropBorderColor( myColor.r, myColor.g, myColor.b) end)
    viewText:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(.15,.15,.15, 0) end)
    viewText:SetScript("OnClick", function(self) editBox:SetText("")
		if not scrollArea:IsShown() then
			for i = 1, textBox:GetNumMessages() do
				local text = textBox:GetMessageInfo(i).."\n"
				text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}")
				text = text:gsub("|[Tt][^|]+|[Tt]", "")
				--text = text:gsub( "|", "")
				editBox:Insert( text)
			end
			scrollArea:Show()
			textBox:Hide()
		else
			scrollArea:Hide()
			textBox:Show()
		end
    end)
    viewText:SetPoint("LEFT", userMenu, "RIGHT", 40, 0)
    viewText:SetSize(45, 15)
    frame1px( viewText)

    viewText.text = viewText:CreateFontString(nil, OVERLAY)
    viewText.text:SetFont( font, fontsize, "OUTLINE")
    viewText.text:SetTextColor( myColor.r, myColor.g, myColor.b)
    viewText.text:SetPoint("CENTER")
    viewText.text:SetText("Text")

    viewText.text2 = self:CreateFontString(ni, "OVERLAY")
	viewText.text2:SetFont( font, fontsize, "OUTLINE")
	viewText.text2:SetPoint("RIGHT", viewText, "LEFT", 0, 0)
	viewText.text2:SetTextColor( myColor.r, myColor.g, myColor.b)
	viewText.text2:SetText( "View as:")
    self.viewText = viewText
end

wimH:SetPoint("TOPLEFT", wim, "TOPRIGHT", 10, 0)
wimH:SetClampedToScreen(true);
wimH:SetFrameStrata("DIALOG");
wimH:SetMovable(true)
wimH:SetResizable(true)
wimH:SetToplevel(true)
wimH:EnableMouse(true)
wimH:RegisterForDrag("LeftButton");
wimH:SetMinResize( 370, 200);
wimH:SetScript("OnDragStart", 	function(self) self:StartMoving(); end);
wimH:SetScript("OnDragStop", 	function(self) self:StopMovingOrSizing(); end);
wimH:SetScript("OnShow", 		function(self) self:SetHeight( yo.Chat.wimHHeight) self:SetWidth(  yo.Chat.wimHWidth) CreateHistoryFrame( self) end)
wimH:Hide()
CreateStyle( wimH, 2, nil, 0.5)
wim.wimHistory = wimH