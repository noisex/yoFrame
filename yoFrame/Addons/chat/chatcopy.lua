local addon, ns = ...
local L, yo, N = unpack( ns)

-----------------------------------------------------------------------------
-- Copy Chat (by Shestak)
-----------------------------------------------------------------------------
local function FadeIn(f)
	UIFrameFadeIn(f, 0.4, f:GetAlpha(), 1)
end

local function FadeOut(f)
	UIFrameFadeOut(f, 0.8, f:GetAlpha(), 0)
end

local lines = {}
local frame = nil
local editBox = nil
local isf = nil
local sizes = {
	":14:14",
	":15:15",
	":16:16",
	":12:20",
	":14"
}

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	CreateStyle(frame, 2)
	frame:SetWidth(440)
	frame:SetHeight(400)
	frame:SetPoint("BOTTOM", LeftDataPanel, "TOP", 0, 38)
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, "CopyFrame")
	frame:Hide()

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(199999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(440)
	editBox:SetHeight(350)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	editBox:SetScript("OnTextSet", function(self)
		local text = self:GetText()

		for _, size in pairs(sizes) do
			if string.find(text, size) and not string.find(text, size.."]") then
				self:SetText(string.gsub(text, size, ":12:12"))
			end
		end
	end)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -27, 8)
	isf = true
end

local scrollDown = function()
	CopyScroll:SetVerticalScroll((CopyScroll:GetVerticalScrollRange()) or 0)
end

local function Copy(cf)
	if not isf then CreatCopyFrame() end
	editBox:SetText("")

	for i = 1, cf:GetNumMessages() do
		local text = cf:GetMessageInfo(i) .. "\n"
		text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}")
		text = text:gsub("|[Tt][^|]+|[Tt]", "")
		editBox:Insert( text)
	end

	if frame:IsShown() then frame:Hide() return end
	frame:Show()
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("ChatFrame%d", i)]
	local button = CreateFrame("Button", format("ButtonCF%d", i), cf, BackdropTemplateMixin and "BackdropTemplate")
	button:SetPoint("TOPRIGHT", LeftDataPanel, "TOPRIGHT", -21, -27)
	button:SetSize( 30, 30)
	button:SetAlpha(0.1)
	CreateStyle(button, 2)
	button:SetBackdropBorderColor(1, 1, 1)

	local buttontexture = button:CreateTexture(nil, "BORDER")
	buttontexture:SetPoint("CENTER")
	buttontexture:SetTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
	buttontexture:SetSize(24, 24)

	button:SetScript("OnMouseUp", function(self)
		Copy(cf)
	end)
	button:SetScript("OnEnter", function()
		button:SetAlpha(1)
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(0.1) end)

	SlashCmdList.COPY_CHAT = function()
		Copy(_G["ChatFrame1"])
	end
end

local gsub = gsub
local color = "16FF5D"
local usebracket = false
local usecolor = true

local function PrintURL(url)
	if (usecolor) then
		if (usebracket) then
			url = "|cff"..color.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = "|cff"..color.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (usebracket) then
			url = "|Hurl:"..url.."|h["..url.."]|h "
		else
			url = "|Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end

local FindURL = function(self, event, msg, ...) --arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
	--print( "find url", event, ...)
	--msg =  HandleShortChannels(msg)
	--print( arg9, arg4)
	--arg4 = "" --arg4 .. "rrr"
	---arg9 = arg9 .. "www"

	--return false, msg,  arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17

	local newMsg, found = gsub(msg, "(%a+)://(%S+)%s?", PrintURL("%1://%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", PrintURL("www.%1.%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", PrintURL("%1@%2%3%4"))
	if found > 0 then return false, newMsg, ... end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FindURL)
--ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", FindURL)
--ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", FindURL)
--ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", FindURL)

local currentLink = nil
local ChatFrame_OnHyperlinkShow_Original = ChatFrame_OnHyperlinkShow
ChatFrame_OnHyperlinkShow = function(self, link, ...)
	if (link):sub(1, 3) == "url" then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		currentLink = nil
		return
	end
	ChatFrame_OnHyperlinkShow_Original(self, link, ...)
end