local L, yo, n = unpack( select( 2, ...))

local _G = _G
local SetCVar, GetCVar, tostring, GameTooltip, floor, CreateStyle
	= SetCVar, GetCVar, tostring, GameTooltip, floor, CreateStyle

local infoText 	= n.infoTexts
local Stat 		= CreateFrame("Frame", nil, UIParent)

local function getVolumeText(volume)
	return tostring(floor(100 * volume + 0.5)) .. "%"
end

function Stat:onEnter()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
	GameTooltip:ClearLines()

	GameTooltip:AddLine( VOLUME, 0, 1, 1)
	GameTooltip:AddLine( " ")
	GameTooltip:AddDoubleLine(	GENERAL, 			getVolumeText(GetCVar("Sound_MasterVolume")))
	GameTooltip:AddDoubleLine(	SOUND_VOLUME, 		getVolumeText(GetCVar("Sound_SFXVolume")))
	GameTooltip:AddDoubleLine(  MUSIC_VOLUME, 		getVolumeText(GetCVar("Sound_MusicVolume")))
	GameTooltip:AddDoubleLine(	AMBIENCE_VOLUME, 	getVolumeText(GetCVar("Sound_AmbienceVolume")))
	GameTooltip:AddDoubleLine(	DIALOG_VOLUME, 		getVolumeText(GetCVar("Sound_DialogVolume")))
	GameTooltip:AddLine(		L["VOLUME_TOOLTIP_HINT1"], 0.5, 0.5, 0.5)

	GameTooltip:Show()
end

function TPUnifiedVolumeControlSlider_OnMouseWheel(self, a1)
	local tempval = self:GetValue();
	if a1 == -1 then  self:SetValue(tempval + 0.02); end
	if a1 == 1 then  self:SetValue(tempval - 0.02); end
end

function TPOptionsSliderTemplate_OnLoad( self)
	self:SetBackdrop({
			bgFile="Interface\\Buttons\\UI-SliderBar-Background",
			edgeFile="Interface\\Buttons\\UI-SliderBar-Border",
			tile = true, tileSize = 8, edgeSize = 8,
			insets = { left = 6, right = 6, top = 3, bottom = 3, },
		})
end

function TPVolumeControlFrame_OnEnter( self) if self.timerOUT then self.timerOUT:Cancel() end end
function TPVolumeSlider_OnLeave(self) GameTooltip:Hide(); self:GetParent().onSlider = false end
function TPVolumeSlider_OnEnter(self)  self:GetParent().onSlider = true end

function TPVolumeControlFrame_OnLeave( self)
	self.timerOUT = C_Timer.NewTicker( 0.7, function()
		if not _G.TPVolumeControlFrame.onSlider then
			_G.TPVolumeControlFrame:Hide()
			_G.TPVolumeControlFrame.timerOUT:Cancel()
		end
	end)
end

function TPVolumeSlider_OnShow(self)
	_G[self:GetName().."Text"]:SetText( getVolumeText( GetCVar( self.var)))
	_G[self:GetName().."High"]:SetText( LOW);
	_G[self:GetName().."Low"]:SetText( HIGH);
	self:SetMinMaxValues(0, 1);
	self:SetValueStep(0.02);
	self:SetObeyStepOnDrag(true) -- since 5.4.2 (Mists of Pandaria)
	self:SetValue(1 - GetCVar( self.var));
end

function TPVolumeSlider_OnValueChanged(self, value)
	_G[self:GetName().."Text"]:SetText( getVolumeText(1 - self:GetValue())); SetCVar( self.var, 1 - self:GetValue());
	Stat.Text:SetFormattedText( infoText.displayString, Stat.displayName, getVolumeText(GetCVar("Sound_MasterVolume")), "")
end

function TPVolumeControlFrame_OnLoad(self)
	_G[self:GetName().."Title"]:SetText( VOLUME);
	_G[self:GetName().."MasterTitle"]:SetText( GENERAL);
	_G[self:GetName().."MusicTitle"]:SetText( MUSIC_VOLUME);
	_G[self:GetName().."SoundTitle"]:SetText( SOUND_VOLUME);
	_G[self:GetName().."AmbienceTitle"]:SetText( AMBIENCE_VOLUME);
	_G[self:GetName().."DialogTitle"]:SetText( DIALOG_VOLUME);

	_G.TPMasterVolumeControlSlider.var 		= "Sound_MasterVolume"
	_G.TPSoundVolumeControlSlider.var 		= "Sound_SFXVolume"
	_G.TPMusicVolumeControlSlider.var 		= "Sound_MusicVolume"
	_G.TPAmbienceVolumeControlSlider.var 	= "Sound_AmbienceVolume"
	_G.TPDialogVolumeControlSlider.var 		= "Sound_DialogVolume"
	CreateStyle( _G.TPVolumeControlFrame, 3)
end

function Stat:onClick()
	_G.TPVolumeControlFrame:ClearAllPoints()
	_G.TPVolumeControlFrame:SetPoint("BOTTOM", self, "TOP", 0, 10)
	_G.TPVolumeControlFrame:SetShown( not _G.TPVolumeControlFrame:IsVisible())
	GameTooltip:Hide()
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self.displayName 	= SOUND_VOLUME

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:SetScript("OnEnter", function( ) self:onEnter( self) end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", self.onClick)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( n.font, n.fontsize, "OVERLAY")
	self.Text:SetFormattedText( infoText.displayString, self.displayName, getVolumeText(GetCVar("Sound_MasterVolume")), "")
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