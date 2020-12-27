local L, yo, n = unpack( select( 2, ...))

if yo.Chat.chatBubble == "none" then return end

local shift = yo.Chat.chatBubbleShift
--Message caches
local messageToGUID = {}
local messageToSender = {}

local function UpdateBubbleBorder( frame)
	local holder = frame.holder

	local str = holder and holder.String
	if not str then return end

	--if holder.backdrop and E.private.general.chatBubbles == 'backdrop' then
	--	holder.backdrop:SetBackdropBorderColor(str:GetTextColor())
	--	holder.backdrop:SetFrameLevel(holder:GetFrameLevel())
	--end

	local name = frame.Name and frame.Name:GetText()
	if name then frame.Name:SetText() end

	local text = str:GetText()
	if not text then return end

	local sender = messageToSender[text]
	--print(sender)
	if not sender then return end

	--local color = PRIEST_COLOR
	--local data = guid and guid ~= '' and CH:GetPlayerInfoByGUID(guid)
	--if data and data.classColor then
	--	color = data.classColor
	--end

	frame.Name:SetText(sender)
	--holder.Name:SetFormattedText('|c%s%s|r', color.colorStr, name)
	--frame.Name:SetWidth( frame:GetWidth()-10)
end

local function SkinBubble(frame, holder)

	if holder.String then
		holder.String:SetFont( n.font, yo.Chat.chatBubbleFont, "OUTLINE")
		if yo.Chat.chatBubbleShadow then
			holder.String:SetShadowOffset(1, -1)
		end
	end

	CreateStyle( holder, -(shift-6), 0, 0.7, 0.9)
	holder.shadow:SetWidth( holder.shadow:GetWidth() - 10)

	if yo.Chat.chatBubble == "border" then

		n.CreateBorder( holder.shadow, 7)
		holder.shadow:SetBackdropColor( 0, 0, 0, 0)
		holder.shadow:SetBackdropBorderColor(0, 0, 0, 0)

	elseif yo.Chat.chatBubble == "skin" then
		holder.shadow:SetBackdropColor(0.09, 0.09, 0.09, 0.7)
		holder.shadow:SetBackdropBorderColor(0.09, 0.09, 0.09, 0.5)

	elseif yo.Chat.chatBubble == "remove" then
		holder.shadow:SetBackdropColor( 0, 0, 0, 0)
		holder.shadow:SetBackdropBorderColor( 0, 0, 0, 0)
	end

	if not frame.Name then
		local name = frame:CreateFontString(nil, 'BORDER')
		name:SetHeight(10)
		--name:SetPoint('BOTTOM', frame, "TOP")
		name:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', shift-4, -shift+6)
		name:SetTextColor(0.9, 0.8, 0.2)
		name:SetFont( n.font, n.fontsize -3, "OUTLINE")
		frame.Name = name
	end

	if not frame.holder then
		frame.holder = holder
		holder.Tail:Hide()
		holder:DisableDrawLayer('BORDER')

		if holder.Center then -- can remove later
			holder.Center:Hide()
		end

		frame:HookScript('OnShow', function(self, ...)
			UpdateBubbleBorder( frame)
		end)

		frame:SetFrameStrata('DIALOG') --Doesn't work currently in Legion due to a bug on Blizzards end
		frame:SetClampedToScreen(false)

		UpdateBubbleBorder(frame)
	end

	frame.isSkinned = true

	--for i = 1, self:GetNumRegions() do
	--	local region = select(i, self:GetRegions())
	--	if region:GetObjectType() == "Texture" then
	--		region:SetTexture(nil)
	--	elseif region:GetObjectType() == "FontString" then
	--		self.text = region
	--		region:SetFont( font, yo.Chat.chatBubbleFont, "OUTLINE")
	--		if yo.Chat.chatBubbleShadow then
	--			region:SetShadowOffset(1, -1)
	--		end
	--	end
	--end
end

local function OnUpdate( self, elapsed)

	self.tick = self.tick + elapsed
	if self.tick <= 0.2 then return end

	self.run = self.run + self.tick
	self.tick = 0

	--self.run = self.run + elapsed
	if self.run > 3 then
		self:SetScript("OnUpdate", nil)
	end

	local _, instanceType = IsInInstance()
	if instanceType == "none" then
		for _, frame in pairs( C_ChatBubbles.GetAllChatBubbles()) do
			local holder = frame:GetChildren()
			if holder and not holder:IsForbidden() and not frame.isSkinned then
				SkinBubble(frame, holder)
			end
		end
	end
end

local function OnEvent( self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)

	if event == "PLAYER_ENTERING_WORLD" then
		--self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		--local _, instanceType = IsInInstance()
		--if instanceType == "none" then
			self:RegisterEvent("CHAT_MSG_SAY")
			self:RegisterEvent("CHAT_MSG_YELL")
			self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
			self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
			self:RegisterEvent("CHAT_MSG_PARTY")
			self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
			--self:SetScript('OnUpdate', OnUpdate)
		--else
			--self:SetScript('OnUpdate', nil)
		--end

		wipe(messageToGUID)
		wipe(messageToSender)

	elseif event:match( "CHAT_MSG") then
		--print(event, yo.Chat.chatBubble, sender, msg)
		self.tick = 1
		self.run = 0
		--self.last = 0

		messageToGUID[msg] = guid
		messageToSender[msg] = Ambiguate(sender, 'none')

		self:SetScript('OnUpdate', OnUpdate)
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", OnEvent)


	--local shift = yo.Chat.chatBubbleShift

	--Mixin( self, BackdropTemplateMixin)
	--if yo.Chat.chatBubble == "remove" then
	--	self:SetBackdrop(nil)

	--elseif yo.Chat.chatBubble == "border" then
	--	self:SetBackdrop({
	--		bgFile = texture,
	--		edgeFile = texture,
	--		tile = false, tileSize = 0, edgeSize = 1,
	--		insets = { left = shift, right = shift, top = shift -2, bottom = shift -2}
	--	})
	--	self:SetBackdropColor( 0.15, 0.15, 0.15, 0.5)
	--	self:SetBackdropBorderColor(0, 0, 0, 0)

	--elseif yo.Chat.chatBubble == "skin" then
	--	self:SetBackdrop(nil)
	--	CreateStyle( self, -(shift-4), 0, 0.2, 0.4)
	--end

	----self.skinned = true
	--self.run = 3
	--elseif instanceType == "party" then
		--local numChilds = WorldFrame:GetNumChildren()
		--for i, frame in pairs( {WorldFrame:GetChildren()}) do

		--	if frame:GetNumRegions() then
		--		print( i, frame:GetNumRegions())
		--	end
		--	--if frame:GetName() then return end
		--	--if not frame:GetRegions() then return end

		--end
	--end