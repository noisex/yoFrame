--------------------------------------------------------------------
 -- BAGS
--------------------------------------------------------------------

local Text  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
Text:SetPoint("RIGHT", RightInfoPanel, "RIGHT", -90, 0)
RightInfoPanel.bagText = Text

local function OnEvent(self, event)
	
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnUpdate", nil)
		Text = nil
		RightInfoPanel.bagText = nil
		return
	end
	
	Text:SetFont( font, fontsize, "OVERLAY")
	Text:SetHeight( RightInfoPanel:GetHeight())
	
	local free, total, used = 0, 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free
	
	if free <= 5 then
		Text:SetText( "|cffff0000Bags: ".. free .. "/" .. total)
	else
		Text:SetText("Bags: ".. myColorStr .. free .. "/" .. total)
	end
	
	self:SetAllPoints(Text)
	self:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine("Сумки авоськи")
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Всего:",total,0, 0.6, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Занято:",used,0, 0.6, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine("Свободно:",free,0, 0.6, 1, 1, 1, 1)
		GameTooltip:Show()
	end)

	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("BAG_UPDATE")

Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnMouseDown", function()
	isOpen = not isOpen
	if isOpen then
		OpenAllBags()
	else
		CloseAllBags()
	end
end)
