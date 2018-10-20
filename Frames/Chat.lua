texture	=	yo.Media.texture
texhl 	=	yo.Media.texhl
texglow = 	yo.Media.texglow
font 	= 	yo.Media.font
fontpx	=	yo.Media.fontpx
--fontsize =	yo.Media.fontsize

fontsize = yo.Chat.fontsize

RGBToHex1 = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local origs = {}

local function Strip(info, name)
	return string.format("|Hplayer:%s|h[%s]|h", info, name:gsub("%-[^|]+", ""))
end

-------------------------------------------------------------------------------------------------------

-- Global strings
_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h[".."R".."]|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h[".."RL".."]|h %s:\32"
_G.CHAT_BN_WHISPER_GET = "Fr".." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:GUILD|h[".."G".."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[".."O".."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:PARTY|h[".."P".."]|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[".."PL".."]|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = CHAT_PARTY_LEADER_GET
_G.CHAT_RAID_GET = "|Hchannel:RAID|h[".."R".."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[".."RL".."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "[".."RW".."] %s:\32"
_G.CHAT_RAID_WARNING_SEND = "RW:".. "\32"
_G.CHAT_PET_BATTLE_COMBAT_LOG_GET = "|Hchannel:PET_BATTLE_COMBAT_LOG|h[".."PB".."]|h:\32"
_G.CHAT_PET_BATTLE_INFO_GET = "|Hchannel:PET_BATTLE_INFO|h[".."PB".."]|h:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = "Fr".." %s:\32"
_G.CHAT_WHISPER_INFORM_GET = "To".." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "|cffE7E716".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffFF0000".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".."has come |cff298F00online|r."
_G.ERR_FRIEND_OFFLINE_S = "[%s] ".."has gone |cffff0000offline|r."

local hyperlinkTypes = {
	['item'] = true,
	['spell'] = true,
	['unit'] = true,
	['quest'] = true,
	['enchant'] = true,
	['achievement'] = true,
	['instancelock'] = true,
	['talent'] = true,
	['glyph'] = true,
	["currency"] = true,
}
local hyperLinkEntered

function OnHyperlinkEnter(frame, refString)
	if InCombatLockdown() then return; end
	local linkToken = strmatch(refString, "^([^:]+)")
	if hyperlinkTypes[linkToken] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(refString)
		hyperLinkEntered = frame;
		GameTooltip:Show()
	end
end

function OnHyperlinkLeave(frame, refString)
	if hyperLinkEntered then
		HideUIPanel(GameTooltip)
		hyperLinkEntered = nil;
	end
end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = dummy
	object:Hide()
end
dummy = function() return end

if select(4, GetBuildInfo()) >= 70100 then
	--Kill(QuickJoinToastButton)
else
	Kill(FriendsMicroButton)
end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	
	local b = CreateFrame("Frame", nil, f)
	b:SetPoint("TOPLEFT", -2, 2)
	b:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(b, 2)
	
	f.backdrop = b
end

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				Kill(region)
			else
				region:SetTexture(nil)
			end
		end
	end
end
-- Set chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	_G[chat]:SetFrameLevel(1)

	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen
	_G[chat]:SetClampedToScreen(false)

	-- Stop-start the chat chat from fading out
	if yo.Chat.fadingEnable then
		_G[chat]:SetFading( true)
		_G[chat]:SetTimeVisible( yo.Chat.fadingTimer)
		_G[chat]:SetFadeDuration( 10)
	else
		_G[chat]:SetFading( false)
	end
	
	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture
	Kill(_G[format("ChatFrame%sTabLeft", id)])
	Kill(_G[format("ChatFrame%sTabMiddle", id)])
	Kill(_G[format("ChatFrame%sTabRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	-- Killing off the new chat tab selected feature
	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	--Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	--Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	--Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	--Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	--Kill(_G[format("ChatFrame%sButtonFrame", id)])
	
	Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])
	
	-- Kills off the retarded new circle around the editbox
	Kill(_G[format("ChatFrame%sEditBoxLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxRight", id)])

	Kill(_G[format("ChatFrame%sTabGlow", id)])
	
	
	-- Kill bubble tex/glow
	if _G[chat.."Tab"].conversationIcon then Kill(_G[chat.."Tab"].conversationIcon) end

	-- Disable alt key usage
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	_G[chat.."EditBox"]:Hide()
	
		-- Script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G[chat.."EditBox"]:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)

	local editbox = _G["ChatFrame"..id.."EditBox"]
	local left, mid, right = select(6, editbox:GetRegions())
	Kill(left); Kill(mid); Kill(right)
	editbox:ClearAllPoints();
	editbox:SetPoint("CENTER", LeftInfoPanel)
	editbox:SetWidth(440)
	editbox:SetHeight(15)
	editbox:SetFrameLevel(1)
	CreateStyle(editbox, 2, 1 , 1, 1)

	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = editbox:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
			local id = GetChannelName(editbox:GetAttribute("channelTarget"))
			if id == 0 then
				editbox:SetBackdropBorderColor(.15,.15,.15)
			else
				editbox:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		elseif type then
			editbox:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)

	
	-- Rename combat log tab
	if _G[chat] == _G["ChatFrame2"] then
		StripTextures(CombatLogQuickButtonFrame_Custom)
		CreateBackdrop(CombatLogQuickButtonFrame_Custom)
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("TOPLEFT", 1, -4)
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetSize(12, 12)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetHitRectInsets (0, 0, 0, 0)
		CombatLogQuickButtonFrame_CustomProgressBar:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("TOPLEFT", CombatLogQuickButtonFrame_Custom.backdrop, 2, -2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("BOTTOMRIGHT", CombatLogQuickButtonFrame_Custom.backdrop, -2, 2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetStatusBarTexture( texture)
		CombatLogQuickButtonFrameButton1:SetPoint("BOTTOM", 0, 0)
	end

	frame.skinned = true
end


-- Setup chatframes 1 to 10 on login
local function SetupChat(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
	end

	-- Remember last channel
	local var
	if true then
		var = 1
	else
		var = 0
	end
	ChatTypeInfo.SAY.sticky = var
	ChatTypeInfo.PARTY.sticky = var
	ChatTypeInfo.PARTY_LEADER.sticky = var
	ChatTypeInfo.GUILD.sticky = var
	ChatTypeInfo.OFFICER.sticky = var
	ChatTypeInfo.RAID.sticky = var
	ChatTypeInfo.RAID_WARNING.sticky = var
	ChatTypeInfo.INSTANCE_CHAT.sticky = var
	ChatTypeInfo.INSTANCE_CHAT_LEADER.sticky = var
	ChatTypeInfo.WHISPER.sticky = var
	ChatTypeInfo.BN_WHISPER.sticky = var
	ChatTypeInfo.CHANNEL.sticky = var
end

local function SetupChatPosAndFont(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local fontsize =	yo.Chat.fontsize
		local _, fontSize = FCF_GetChatWindowInfo(id)

		-- Min. size for chat font
		if fontSize < 11 then
			FCF_SetChatWindowFontSize(nil, chat, 11)
		else
			FCF_SetChatWindowFontSize(nil, chat, fontSize)
		end

		-- ScrollBar
		chat.ScrollBar:ClearAllPoints()
		chat.ScrollBar.SetPoint = function() return end
		chat.ScrollBar.ClearAllPoints = function() return end
		--chat.ScrollBar:SetPoint( "TOPRIGHT", LeftDataPanel, "TOPRIGHT", 50, 0)
	
		chat.ScrollToBottomButton:ClearAllPoints()
		chat.ScrollToBottomButton:SetPoint( "TOPRIGHT", LeftDataPanel, "TOPRIGHT", 0, 0)
		chat.ScrollToBottomButton.SetPoint = function() return end
		chat.ScrollToBottomButton.ClearAllPoints = function() return end
		
		-- Font and font style for chat
		chat:SetFont( font, fontsize, "OVERLAY")
		chat:SetShadowOffset(1, -1)

		-- Force chat position
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetSize(435, 132)
			chat:SetPoint("BOTTOMLEFT", LeftDataPanel, "BOTTOMLEFT", 3, 20)
			
			FCF_SavePositionAndDimensions(chat)
		elseif i == 2 then
			if false then  												---Qulight["chatt"].combatlog ~= true then
				FCF_DockFrame(chat)
				ChatFrame2Tab:EnableMouse(false)
				ChatFrame2Tab:SetText("")
				ChatFrame2Tab.SetText = dummy
				ChatFrame2Tab:SetWidth(0.001)
				ChatFrame2Tab.SetWidth = dummy
			end
		end
	end

	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		--if (not self.hooks or not self.hooks[frame] or not self.hooks[frame].OnHyperlinkEnter) then
		frame:HookScript('OnHyperlinkEnter', OnHyperlinkEnter)
		frame:HookScript('OnHyperlinkLeave', OnHyperlinkLeave)
		--end
	end


	if yo.Chat.showVoice then
		ChatFrameMenuButton:SetSize( 18, 18)
		ChatFrameMenuButton:ClearAllPoints()
		ChatFrameMenuButton:SetNormalTexture( nil)
		ChatFrameMenuButton:SetPushedTexture(nil)
		ChatFrameMenuButton:SetPoint( "RIGHT",ChatFrame1.ScrollToBottomButton, "LEFT", -3, 0)
		ChatFrameMenuButton.Icon = ChatFrameMenuButton:CreateTexture(nil, "OVERLAY")
		ChatFrameMenuButton.Icon:SetAllPoints()
		ChatFrameMenuButton.Icon:SetTexture("Interface\\WORLDSTATEFRAME\\HordeFlagFlash") --Interface\\ChatFrame\\UI-ChatIcon-Chat-Up")
		--ChatFrameMenuButton.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

		ChatFrameChannelButton:SetNormalTexture(nil)
		ChatFrameChannelButton:SetPushedTexture(nil)
		ChatFrameChannelButton:ClearAllPoints()
		ChatFrameChannelButton:SetPoint( "RIGHT", ChatFrameMenuButton, "LEFT", 4, 0)

		ChatFrameToggleVoiceDeafenButton:SetNormalTexture(nil)
		ChatFrameToggleVoiceDeafenButton:SetPushedTexture(nil)
		ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
		ChatFrameToggleVoiceDeafenButton:SetPoint( "RIGHT", ChatFrameChannelButton, "LEFT", 6, 0)
	
		ChatFrameToggleVoiceMuteButton:SetNormalTexture(nil)
		ChatFrameToggleVoiceMuteButton:SetPushedTexture(nil)
		ChatFrameToggleVoiceMuteButton:ClearAllPoints()
		ChatFrameToggleVoiceMuteButton:SetPoint( "RIGHT", ChatFrameToggleVoiceDeafenButton, "LEFT", 6, 0)
		--ChatFrameMenuButton:GetNormalTexture():SetTexCoord( 0.1, 1, 0.1, 1)
	else
		ChatFrameMenuButton:ClearAllPoints()
		ChatFrameChannelButton:ClearAllPoints()
		ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
		ChatFrameToggleVoiceMuteButton:ClearAllPoints()
		
		ChatFrameMenuButton:SetParent(nil)
		ChatFrameChannelButton:SetParent(nil)
		ChatFrameToggleVoiceDeafenButton:SetParent(nil)
		ChatFrameToggleVoiceMuteButton:SetParent(nil)

		ChatFrameMenuButton:Hide()
		ChatFrameChannelButton:Hide()
		ChatFrameToggleVoiceDeafenButton:Hide()
		ChatFrameToggleVoiceMuteButton:Hide()
	end

	--ChatFrame1ButtonFrame:ClearAllPoints()
	ChatFrame1ButtonFrame:SetPoint( "TOPRIGHT", LeftDataPanel, "TOPRIGHT", 0, 0)

	FCF_SetLocked( ChatFrame1, true)
	
	-- Reposition battle.net popup over chat #1
	ChatAlertFrame:ClearAllPoints()
	ChatAlertFrame:SetPoint( "BOTTOMLEFT", LeftDataPanel, "TOPLEFT", 0, 50)
	-- BNToastFrame:ClearAllPoints()
	-- BNToastFrame:SetPoint("BOTTOMLEFT", LeftDataPanel, "TOPLEFT", 5, 5)

	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", LeftDataPanel, "TOPLEFT", 5, 15)
	end)
end

local UIChat = CreateFrame("Frame")
UIChat:RegisterEvent("ADDON_LOADED")
UIChat:RegisterEvent("PLAYER_ENTERING_WORLD")
UIChat:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			if not yo.Chat.EnableChat then return end
			--SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if not yo.Chat.EnableChat then return end
		SetupChat(self)
		SetupChatPosAndFont(self)		
	end
end)

-- Setup temp chat (BN, WHISPER) when needed
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	if frame.skinned then return end
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

-- Disable pet battle tab
local old = FCFManager_GetNumDedicatedFrames
function FCFManager_GetNumDedicatedFrames(...)
	return select(1, ...) ~= "PET_BATTLE_COMBAT_LOG" and old(...) or 1
end

realm = GetRealmName()

-- Remove player's realm name
local function RemoveRealmName(self, event, msg, author, ...)
	--print( "brrdfdsfsdf")
	local realm = string.gsub(realm, " ", "")
	if msg:find("-" .. realm) then
		return false, gsub(msg, "%-"..realm, ""), author, ...
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", RemoveRealmName)

----------------------------------------------------------------------------------------
--	Save slash command typo
----------------------------------------------------------------------------------------
-- local function TypoHistory_Posthook_AddMessage(chat, text)
	-- if strfind(text, HELP_TEXT_SIMPLE) then
		-- ChatEdit_AddHistory(chat.editBox)
	-- end
-- end

-- for i = 1, NUM_CHAT_WINDOWS do
	-- if i ~= 2 then
		-- hooksecurefunc(_G["ChatFrame"..i], "AddMessage", TypoHistory_Posthook_AddMessage)
	-- end
-- end


----------------------------------------------------------------------------------------
--	Based on Fane(by Haste)
----------------------------------------------------------------------------------------
local Fane = CreateFrame("Frame")

local updateFS = function(self, inc, ...)
	local fstring = self:GetFontString()

	fstring:SetFont(font, fontsize, "OVERLAY")
	fstring:SetShadowOffset(1, -1)

	if (...) then
		fstring:SetTextColor(...)
	end
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID().."TabFlash"]:IsShown()
	updateFS(self, emphasis, 1, 0, 0)
end

local OnLeave = function(self)
	local r, g, b
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id.."TabFlash"]:IsShown()

	if _G["ChatFrame"..id] == SELECTED_CHAT_FRAME then
		r, g, b = 1, 0, 0
	elseif emphasis then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 1
	end

	updateFS(self, emphasis, r, g, b)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if CombatLogQuickButtonFrame_Custom then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if CombatLogQuickButtonFrame_Custom then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if not frame.Fane then
		frame:HookScript("OnEnter", OnEnter)
		frame:HookScript("OnLeave", OnLeave)
		if true then
			frame:SetAlpha(1)

			if i ~= 2 then
				-- Might not be the best solution, but we avoid hooking into the UIFrameFade
				-- system this way.
				frame.SetAlpha = UIFrameFadeRemoveFrame
			else
				frame.SetAlpha = ChatFrame2_SetAlpha
				frame.GetAlpha = ChatFrame2_GetAlpha

				-- We do this here as people might be using AddonLoader together with Fane
				if CombatLogQuickButtonFrame_Custom then
					CombatLogQuickButtonFrame_Custom:SetAlpha(0.4)
				end
			end
		end

		frame.Fane = true
	end

	-- We can't trust sel
	if i == SELECTED_CHAT_FRAME:GetID() then
		updateFS(frame, nil, 1, 0, 0)
	else
		updateFS(frame, nil, 1, 1, 1)
	end
end

hooksecurefunc("FCF_StartAlertFlash", function(frame)
	local tab = _G["ChatFrame"..frame:GetID().."Tab"]
	updateFS(tab, true, 1, 0, 0)
end)

hooksecurefunc("FCFTab_UpdateColors", faneifyTab)

for i = 1, NUM_CHAT_WINDOWS do
	faneifyTab(_G["ChatFrame"..i.."Tab"])
end

function Fane:ADDON_LOADED(event, addon)
	if addon == "Blizzard_CombatLog" then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(0.4)
	end
end
Fane:RegisterEvent("ADDON_LOADED")


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
	frame:SetHeight(370)
	frame:SetPoint("BOTTOM", LeftDataPanel, "TOP", 0, 7)
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, "CopyFrame")
	frame:Hide()

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(440)
	editBox:SetHeight(300)
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
	local text = ""
	for i = 1, cf:GetNumMessages() do
		text = text..cf:GetMessageInfo(i).."\n"
	end
	text = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}")
	text = text:gsub("|[Tt][^|]+|[Tt]", "")
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("ChatFrame%d", i)]
	local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
	button:SetPoint("TOPRIGHT", LeftDataPanel, "TOPRIGHT", -25, -25) -- -5, -5)
	button:SetSize(20, 20)
	button:SetAlpha(0)
	CreateStyle(button, 2)
	button:SetBackdropBorderColor(1, 1, 1)

	local buttontexture = button:CreateTexture(nil, "BORDER")
	buttontexture:SetPoint("CENTER")
	buttontexture:SetTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
	buttontexture:SetSize(16, 16)

	button:SetScript("OnMouseUp", function(self)
		Copy(cf)
	end)
	button:SetScript("OnEnter", function() 
		button:SetAlpha(1) 
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(0) end)

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

local FindURL = function(self, event, msg, ...)
	--print( "find url", event, msg, ...)
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

for i=1, NUM_CHAT_WINDOWS do
	local editbox = _G["ChatFrame"..i.."EditBox"]
	editbox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		if text:len() < 5 then
			if text:sub(1, 4) == "/tt " then
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
SlashCmdList.TELLTARGET = function(msg)
	SendChatMessage(msg, "WHISPER")
end

----------------------------------------------------------------------------------------
--	Chat History
----------------------------------------------------------------------------------------
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
		return format("%s|Hchannel:channel:%d|h[%d]|h", colorString, chanNum, chanNum), colorString --, gsub(channelName, "%s%-%s.*", ""));	--The gsub removes zone-specific markings (e.g. "General - Ironforge" to "General")
	elseif ( chatType == "WHISPER" ) then
		local info = ChatTypeInfo["WHISPER"];
		local colorString = format("|cff%02x%02x%02x", info.r * 255, info.g * 255, info.b * 255);
		--return format("%s[%s] |Hplayer:%3$s|h[%3$s]|h", colorString, _G[chatType], chatTarget), colorString
		return format("%s[%s] |Hplayer:%s|h", colorString, _G[chatType], chatTarget), colorString
	else
		local info = ChatTypeInfo[chatType];
		local colorString = format("|cff%02x%02x%02x", info.r * 255, info.g * 255, info.b * 255);
		return format("%s|Hchannel:%s|h[%s]|h", colorString, chatType, _G[chatType]), colorString;
	end
end

local function OnChatHistory( self, event, ...)
	if yo_ChatHistory == nil then
		yo_ChatHistory = {}
	end

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
		local chanName, chanColor = Chat_GetColoredChatName( chatGroup, chatTarget)
		--print( chatGroup, chatTarget)
		--local text, sender, _, channel, _, _, _, _, _, _, _, senderGUID = ...
		if arg12 then
			englishClass = select( 2, GetPlayerInfoByGUID( arg12))
		end
		
		--SaveLine( text, chanName, sender, chanColor, senderGUID, englishClass)
		SaveLine( arg1, chanName, arg2, chanColor, arg12, englishClass)
	end

	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.Chat.showHistory then return end
		
		self:RegisterEvent("CHAT_MSG_GUILD")
		self:RegisterEvent("CHAT_MSG_PARTY")
		self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
		self:RegisterEvent("CHAT_MSG_RAID")
		self:RegisterEvent("CHAT_MSG_RAID_LEADER")
		--self:RegisterEvent("CHAT_MSG_CHANNEL")
		--self:RegisterEvent("CHAT_MSG_SAY")

		CheckLine( yo_ChatHistory)
		
		for i,v in ipairs( yo_ChatHistory ) do
			
			for ii,vv in pairs( v) do
				local channel, sender, text, chanColor, uclass = vv[2], strsplit( "-",vv[3]), vv[1], vv[4], vv[6]
				--print(channel, sender, text, chanColor, uclass) --, RAID_CLASS_COLORS[uclass].colorStr)

				sender = "|c" .. RAID_CLASS_COLORS[ ( uclass or "PRIEST")].colorStr .. sender .. "|r"

				local string = format("%s[%s%s]: %s|r", channel, sender, ( chanColor or "|cffffffff" ), text)
				print(string)
			end
		end
	end
end

local chatHistory = CreateFrame("Frame")
chatHistory:RegisterEvent("PLAYER_ENTERING_WORLD")
chatHistory:SetScript("OnEvent", OnChatHistory)

----------------------------------------------------------------------------------------
--	Wisper Sound
----------------------------------------------------------------------------------------

local SoundSys = CreateFrame("Frame")
SoundSys:RegisterEvent("PLAYER_ENTERING_WORLD")
SoundSys:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:RegisterEvent("CHAT_MSG_WHISPER")
		self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	else
		if InCombatLockdown() and not yo.Chat.wisperInCombat then return end

		PlaySoundFile( LSM:Fetch( "sound", yo.Chat.wisperSound), "Master")
	end
end)
