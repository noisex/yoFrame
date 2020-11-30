local L, yo, n = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = n.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

--------------------------------------------------------------------
 -- BAGS
--------------------------------------------------------------------
local free, total, used = 0, 0, 0

function Stat:onEvent(event)
	free, total = 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end
	used = total - free

	if free <= 5 then
		self.Text:SetText( "|cffff0000Bags: ".. free .. "/" .. total)
	else
		self.Text:SetText( BAGSLOT .. ": ".. myColorStr .. free .. "/" .. total)
	end
	--self:SetWidth( self.Text:GetWidth())
end

function Stat:onEnter()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
	GameTooltip:AddDoubleLine(L["Bagzy and banksy"])
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine( L["TOTAL"],total,0, 0.6, 1, 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["Busy"],used,0, 0.6, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Free"],free,0, 0.6, 1, 1, 1, 1)
	GameTooltip:Show()
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("BAG_UPDATE")

	self:SetScript("OnEvent", self.onEvent)
	self:SetScript("OnEnter", function( ) self:onEnter( self) end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", function( btn)
		if yo_Bags.bagFrame then addon_Toggle()
		else 	isOpen = not isOpen
				if isOpen then OpenAllBags()
				else CloseAllBags()
				end
		end
	end)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self:SetWidth( self.Text:GetWidth())
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)
	self:onEvent()
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

infoText.infos.bags 	= Stat
infoText.infos.bags.name= "Bags"

infoText.texts.bags 	= "Bags"

