local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.Chat.EnableChat then return end


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

function doEnote( enote, ...)
	local emote = {
		[13] = "LICK",
		[14] = "WAVE",
		[15] = "SPIT"
	}
	--print(self, enote:GetText(), enote:GetID())
	local ID = enote:GetID()
	if emote[ID] then
		DoEmote( enote:GetText()) --emote[ID]);
	end
	ChatMenu:Hide();
end
UIMenu_AddButton( ChatMenu, "LICK", nil, doEnote)
UIMenu_AddButton( ChatMenu, "WAVE", nil, doEnote)
UIMenu_AddButton( ChatMenu, "SPIT", nil, doEnote)

--UIMenu_AddButton( ChatMenu, EMOTE117_CMD1, nil, doEnote)
--UIMenu_AddButton( ChatMenu, EMOTE102_CMD1, nil, doEnote)


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

	local wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()
	if (wowtocversion > 90000) then Mixin( editbox, BackdropTemplateMixin) end

	editbox:ClearAllPoints();
	editbox:SetPoint("CENTER", LeftInfoPanel)
	editbox:SetWidth(440)
	editbox:SetHeight(15)
	editbox:SetFrameLevel(1)
	CreateStyle(editbox, 2, 1 , 1, 1)

	--hooksecurefunc("ChatEdit_UpdateHeader", function()
		--local type = editbox:GetAttribute("chatType")
		--if ( type == "CHANNEL" ) then
		--	print(type, editbox:GetAttribute("channelTarget"))
		--	local id = GetChannelName(editbox:GetAttribute("channelTarget"))
		--	if id == 0 then
		--		editbox:SetBackdropBorderColor(.15,.15,.15)
		--	else
		--		editbox:SetBackdropBorderColor(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
		--	end
		--elseif type then
		--	editbox:SetBackdropBorderColor(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		--end
	--end)


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
		chat:SetFont( yo.Chat.chatFont, fontsize, "OVERLAY")
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

	local wimButton = CreateFrame("Button", nil, LeftDataPanel)
	wimButton:SetPoint( "RIGHT",ChatFrame1.ScrollToBottomButton, "LEFT", -3, 0)
	wimButton:SetSize( 1, 1)
	if yo_WIM and yo.Chat.wim then
		wimButton:SetSize( 28, 28)
		wimButton:SetPoint( "RIGHT",ChatFrame1.ScrollToBottomButton, "LEFT", -3, 0)
		wimButton:SetNormalTexture("Interface\\HELPFRAME\\ReportLagIcon-Chat")
		wimButton:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		wimButton:SetScript("OnClick", function() yo_WIM:SetShown( not yo_WIM:IsShown()) yo_WIM:stopFlash( wimButton) end)
		yo_WIM.wimButton = wimButton
	end

	if yo.Chat.showVoice then
		ChatFrameMenuButton:SetSize( 35, 35)
		ChatFrameMenuButton:ClearAllPoints()
		ChatFrameMenuButton:SetNormalTexture( nil)
		ChatFrameMenuButton:SetPushedTexture(nil)
		ChatFrameMenuButton:SetHighlightTexture( "Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		if yo_WIM then
			ChatFrameMenuButton:SetPoint( "RIGHT", wimButton, "LEFT", 6, 0)
		else
			ChatFrameMenuButton:SetPoint( "RIGHT",ChatFrame1.ScrollToBottomButton, "LEFT", -3, 0)
		end
		ChatFrameMenuButton.Icon = ChatFrameMenuButton:CreateTexture(nil, "OVERLAY")
		ChatFrameMenuButton.Icon:SetPoint( "CENTER")
		ChatFrameMenuButton.Icon:SetTexture("Interface\\ChatFrame\\UI-ChatWhisperIcon.blp")
		ChatFrameMenuButton.Icon:SetVertexColor(1, 1, 0, 1)
		ChatFrameMenuButton.Icon:SetSize( 17, 17)

		ChatFrameChannelButton:SetNormalTexture(nil)
		ChatFrameChannelButton:SetPushedTexture(nil)
		ChatFrameChannelButton:ClearAllPoints()
		ChatFrameChannelButton:SetPoint( "RIGHT", ChatFrameMenuButton, "LEFT", 8, 0)

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
	ChatAlertFrame:SetPoint( "BOTTOMLEFT", LeftDataPanel, "TOPLEFT", 0, 35)
	--QuickJoinToastButton.FriendsButton:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Battlenet.blp")
	--QuickJoinToastButton.FriendsButton.SetTexture = dummy
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
--	Based on Fane(by Haste)
----------------------------------------------------------------------------------------
local Fane = CreateFrame("Frame")

local updateFS = function(self, inc, ...)
	local fstring = self:GetFontString()

	fstring:SetFont( yo.font, yo.fontsize, "OVERLAY")
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

function Fane:ADDON_LOADED(event, name)
	if name == "Blizzard_CombatLog" then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(0.4)
	end

	if addon == name then
		for i = 1, NUM_CHAT_WINDOWS do
			faneifyTab(_G["ChatFrame"..i.."Tab"])
		end

		hooksecurefunc("FCF_StartAlertFlash", function(frame)
			local tab = _G["ChatFrame"..frame:GetID().."Tab"]
			updateFS(tab, true, 1, 0, 0)
		end)

		hooksecurefunc("FCFTab_UpdateColors", faneifyTab)
	end
end
Fane:RegisterEvent("ADDON_LOADED")

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
