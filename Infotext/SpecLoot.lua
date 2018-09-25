local Text1  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Text2  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Icon1  = RightInfoPanel:CreateTexture(nil, "OVERLAY")
local Icon2  = RightInfoPanel:CreateTexture(nil, "OVERLAY")
RightInfoPanel.specText = Text1
RightInfoPanel.lootText = Text2
RightInfoPanel.specIcon = Icon1
RightInfoPanel.lootIcon = Icon2

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
		Text1:SetFont( font, fontsize, "OVERLAY")
		Text1:SetText("Спек: ")
		
		Icon1:SetPoint( "LEFT", Text1, "RIGHT", 0, 0)
		Icon1:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		Icon1:SetHeight( RightInfoPanel:GetHeight())
		Icon1:SetWidth( RightInfoPanel:GetHeight())
		
		Text2:SetHeight( RightInfoPanel:GetHeight())
		Text2:SetPoint("LEFT", Icon1, "RIGHT", 5, 0)
		Text2:SetFont( font, fontsize, "OVERLAY")
		Text2:SetText("Лут: ")
		
		Icon2:SetPoint( "LEFT", Text2, "RIGHT", 0, 0)
		Icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		Icon2:SetHeight( RightInfoPanel:GetHeight())
		Icon2:SetWidth( RightInfoPanel:GetHeight())
	end

	local _, _, _, icon = GetSpecializationInfo( GetSpecialization())	
	Icon1:SetTexture( icon)

	local specID = GetLootSpecialization()
	local _, _, _, looticon = GetSpecializationInfoByID( specID)
	
	if specID == 0 then
		Icon2:SetTexture( icon)
	else
		Icon2:SetTexture( looticon)
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

	Stat:SetScript("OnMouseDown", function() ToggleTalentFrame() end)
	Stat:SetScript("OnEvent", OnEvent)
