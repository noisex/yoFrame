local L, yo, n = unpack( select( 2, ...))


local infoText 	= n.infoTexts
local Stat 		= CreateFrame("Frame", nil, UIParent)


function Stat:onClick()
	GameTooltip:Hide()
end

function Stat:onEnter()

end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self.displayName 	= "sound"

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:SetScript("OnEnter", function( ) Stat:onEnter() end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onClick)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( n.font, n.fontsize, "OVERLAY")
	self.Text:SetFormattedText( infoText.displayString, self.displayName, 0, "") --,  SecondsToClocks( self.combatTime))
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)

	self:Show()
end

function Stat:Disable()
	self:Hide()
end

infoText.infos.sound 		= Stat
infoText.infos.sound.name	= "Sound"

infoText.texts.sound 		= "Sound"