local L, yo = unpack( select( 2, ...))

local Text1  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Text2  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Icon1  = RightInfoPanel:CreateTexture(nil, "OVERLAY")
local Icon2  = RightInfoPanel:CreateTexture(nil, "OVERLAY")
RightInfoPanel.specText = Text1
RightInfoPanel.lootText = Text2
RightInfoPanel.specIcon = Icon1
RightInfoPanel.lootIcon = Icon2
local ICON_FORMAT =  '|T%s:14:14:0:0:64:64:4:60:4:60|t  %s'

local menuFrame = CreateFrame("Frame", "SpecRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {{ text = _G.SPECIALIZATION, isTitle = true, notCheckable = true },}

local function specOnClick(self, button)
	GameTooltip:Hide()
	if IsShiftKeyDown() then ToggleTalentFrame() return end

	if #menuList == 1 then
		local numSpec = GetNumSpecializations()

		for index = 1, numSpec do
			local id, name, _, icon = GetSpecializationInfo(index)
			if id then
				menuList[index + 1] = { text = format( ICON_FORMAT, icon, name), checked = function() return GetSpecialization() == index end, func = function() SetSpecialization(index) end }
			end
		end

		menuList[numSpec+2] = { text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true }
		menuList[numSpec+3] = { text = format( "Текущий (%s)", self.specName), checked = function() return GetLootSpecialization() == 0 end, func = function() SetLootSpecialization( 0) end  }
		for index = 1, numSpec do
			local id, name, _, icon = GetSpecializationInfo(index)
			if id then
				menuList[index + numSpec + 3] = { text = format( ICON_FORMAT, icon, name), checked = function() return GetLootSpecialization() == id end, func = function() SetLootSpecialization(id) end }
			end
		end
	end

	if button == 'LeftButton' then
		EasyMenu(menuList, menuFrame, "cursor", -50, 100, "MENU", 2)
	else
		ToggleTalentFrame()
	end
end

local function OnEnter( self)
	--if not self.specLootName then return end

	local tecSpec = " "
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
	GameTooltip:ClearLines()

	GameTooltip:AddLine( _G.SPECIALIZATION)
	GameTooltip:AddLine( format( ICON_FORMAT, self.specIcon, self.specName ), 1, 1, 1)
	GameTooltip:AddLine(" ")

	GameTooltip:AddLine( SELECT_LOOT_SPECIALIZATION)

	local spec = GetLootSpecialization()
	if spec == 0 then tecSpec = "( Текущая)" end
	GameTooltip:AddLine( format( ICON_FORMAT, self.specLootIcon, ( self.specLootName or self.specName) .. tecSpec), 1, 1, 1)
	GameTooltip:AddLine(" ")

	GameTooltip:AddLine(TALENTS) --0.69, 0.31, 0.31)
	for i = 1, _G.MAX_TALENT_TIERS do
		for j = 1, 3 do
			local _, name, icon, selected = GetTalentInfo(i, j, 1)
			if selected then
				GameTooltip:AddLine( format( ICON_FORMAT, icon, name), 1, 1, 1)
			end
		end
	end
	GameTooltip:Show()
end

local function OnEvent(self, event)
	if not yo["Addons"].InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self:SetScript("OnEvent", nil)
		self:SetScript("OnUpdate", nil)
		Text1 = nil
		Text2 = nil
		Icon1 = nil
		Icon2 = nil
		self = nil
		RightInfoPanel.specText = nil
		RightInfoPanel.lootText = nil
		RightInfoPanel.specIcon = nil
		RightInfoPanel.lootIcon = nil
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		Text1:SetHeight( RightInfoPanel:GetHeight())
		Text1:SetPoint("LEFT", RightInfoPanel, "LEFT", 140, 0)
		Text1:SetFont( yo.font, yo.fontsize, "OVERLAY")
		Text1:SetText("Spec: ")

		Icon1:SetPoint( "LEFT", Text1, "RIGHT", 0, 0)
		Icon1:SetTexCoord(unpack( yo.tCoord))
		Icon1:SetHeight( RightInfoPanel:GetHeight())
		Icon1:SetWidth( RightInfoPanel:GetHeight())

		Text2:SetHeight( RightInfoPanel:GetHeight())
		Text2:SetPoint("LEFT", Icon1, "RIGHT", 5, 0)
		Text2:SetFont( yo.font, yo.fontsize, "OVERLAY")
		Text2:SetText("Loot: ")

		Icon2:SetPoint( "LEFT", Text2, "RIGHT", 0, 0)
		Icon2:SetTexCoord(unpack( yo.tCoord))
		Icon2:SetHeight( RightInfoPanel:GetHeight())
		Icon2:SetWidth( RightInfoPanel:GetHeight())

		self.Text1 = Text1
		self.Text2 = Text2
		self.Icon1 = Icon1
		self.Icon2 = Icon2

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	local id, name, _, icon = GetSpecializationInfo( GetSpecialization())
	self.specID 	= id
	self.specName 	= name
	self.specIcon 	= icon
	Icon1:SetTexture( icon)

	local specID = GetLootSpecialization()
	local id, name, _, looticon = GetSpecializationInfoByID( specID)
	self.specLootID 	= id
	self.specLootName 	= name

	if specID == 0 then
		Icon2:SetTexture( icon)
		self.specLootIcon = icon
	else
		Icon2:SetTexture( looticon)
		self.specLootIcon = looticon
	end

	self:SetPoint("LEFT", Text1, "LEFT")
	self:SetSize( 70, 19)
end

local Stat = CreateFrame("Frame", nil)
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Stat:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")

	Stat:SetScript("OnMouseDown", specOnClick) --function() ToggleTalentFrame() end)
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnEnter", OnEnter)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
