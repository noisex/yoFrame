local L, yo, n = unpack( select( 2, ...))

if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local ICON_FORMAT =  '|T%s:14:14:0:0:64:64:4:60:4:60|t  %s'

local menuFrame = CreateFrame("Frame", "SpecRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {{ text = _G.SPECIALIZATION, isTitle = true, notCheckable = true },}

function Stat:specOnClick( button)
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
		EasyMenu(menuList, menuFrame, "cursor", -75, 150, "MENU", 2)
	else
		ToggleTalentFrame()
	end
end

function Stat:onEnter( )
	--if not self.specLootName then return end

	local tecSpec = " "
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);

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

function Stat:onEvent( event)
	if not GetSpecialization() then return end

	local id, name, _, icon = GetSpecializationInfo( GetSpecialization())
	self.specID 	= id
	self.specName 	= name
	self.specIcon 	= icon
	self.Icon1:SetTexture( icon)

	local specID = GetLootSpecialization()
	local id, name, _, looticon = GetSpecializationInfoByID( specID)
	self.specLootID 	= id
	self.specLootName 	= name

	if specID == 0 then
		self.Icon2:SetTexture( icon)
		self.specLootIcon = icon
	else
		self.Icon2:SetTexture( looticon)
		self.specLootIcon = looticon
	end
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 70, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")

	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", self.onEnter )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.specOnClick)

	self.Text1  = self.Text1 or self:CreateFontString(nil, "OVERLAY")
	self.Text2  = self.Text2 or self:CreateFontString(nil, "OVERLAY")
	self.Icon1  = self.Icon1 or self:CreateTexture(nil, "OVERLAY")
	self.Icon2  = self.Icon2 or self:CreateTexture(nil, "OVERLAY")

	self.Text1:SetHeight( RightInfoPanel:GetHeight())
	self.Text1:SetPoint("LEFT", self, "LEFT", 25, 0)
	self.Text1:SetFont( n.font, n.fontsize, "OVERLAY")
	self.Text1:SetText("S: ")

	self.Icon1:SetPoint( "LEFT", self.Text1, "RIGHT", 0, 0)
	self.Icon1:SetTexCoord(unpack( n.tCoord))
	self.Icon1:SetHeight( RightInfoPanel:GetHeight())
	self.Icon1:SetWidth( RightInfoPanel:GetHeight())

	self.Text2:SetHeight( RightInfoPanel:GetHeight())
	self.Text2:SetPoint("LEFT", self.Icon1, "RIGHT", 5, 0)
	self.Text2:SetFont( n.font, n.fontsize, "OVERLAY")
	self.Text2:SetText("L: ")

	self.Icon2:SetPoint( "LEFT", self.Text2, "RIGHT", 0, 0)
	self.Icon2:SetTexCoord(unpack( n.tCoord))
	self.Icon2:SetHeight( RightInfoPanel:GetHeight())
	self.Icon2:SetWidth( RightInfoPanel:GetHeight())

	--self.Text:SetPoint("CENTER", self, "CENTER", 0, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:onEvent( )
	--CreateStyle( self, 2)
	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	self:UnregisterAllEvents()
	self:Hide()
end

infoText.infos.spec 	= Stat
infoText.infos.spec.name= "Spec"

infoText.texts.spec 	= "Spec/Loot"