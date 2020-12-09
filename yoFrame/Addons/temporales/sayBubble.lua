local L, yo, n = unpack( select( 2, ...))

local function skinBubble( self)
	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			self.text = region
			region:SetFont( font, yo.Chat.chatBubbleFont, "OUTLINE")
			if yo.Chat.chatBubbleShadow then
				region:SetShadowOffset(1, -1)
			end
		end
	end

	local shift = yo.Chat.chatBubbleShift

	if yo.Chat.chatBubble == "remove" then
		self:SetBackdrop(nil)

	elseif yo.Chat.chatBubble == "border" then
		self:SetBackdrop({
			bgFile = texture,
			edgeFile = texture,
			tile = false, tileSize = 0, edgeSize = 1,
			insets = { left = shift, right = shift, top = shift -2, bottom = shift -2}
		})
		self:SetBackdropColor( 0.15, 0.15, 0.15, 0.5)
		self:SetBackdropBorderColor(0, 0, 0, 0)

	elseif yo.Chat.chatBubble == "skin" then
		self:SetBackdrop(nil)
		CreateStyle( self, -(shift-4), 0, 0.2, 0.4)
	end

	--self.skinned = true
	--self.run = 3
end

local function OnUpdate( self, elapsed)

	self.run = self.run + elapsed
	if self.run > 2 then
		self:SetScript("OnUpdate", nil)
	end

	local _, instanceType = IsInInstance()
	if instanceType == "party" or instanceType == "none" then
		for _, chatBubble in pairs(C_ChatBubbles.GetAllChatBubbles( )) do
			if chatBubble and not chatBubble.skinned then
				skinBubble( chatBubble)
			end
		end
	elseif instanceType == "party" then
		local numChilds = WorldFrame:GetNumChildren()
		for i, frame in pairs( {WorldFrame:GetChildren()}) do

			if frame:GetNumRegions() then
				print( i, frame:GetNumRegions())
			end
			--if frame:GetName() then return end
			--if not frame:GetRegions() then return end

		end
	end
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if yo.Chat.chatBubble == "none" then return end

		self:RegisterEvent("CHAT_MSG_SAY")
		self:RegisterEvent("CHAT_MSG_YELL")

		--self:RegisterEvent("CHAT_MSG_PARTY")
		--self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
		self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	elseif event:match( "CHAT_MSG") then
		print(event, ...)
		self.run = 0
		self.last = 0
		self:SetScript('OnUpdate', OnUpdate)
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", OnEvent)