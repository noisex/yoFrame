local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]

function ActionBars:CreateMicroBar()
	local Size = yo.ActionBar.buttonsSize
	local Spacing = 0

	local MicroMenu = CreateFrame("Frame", "yoMicroMenuBar", N.PetHider, "SecureHandlerStateTemplate")
	MicroMenu:SetFrameStrata("LOW")
	MicroMenu:SetFrameLevel(10)
	MicroMenu:SetScale( yo.ActionBar.MicroScale)
	MicroMenu:SetPoint("BOTTOMLEFT", yoMoveAMicro, "BOTTOMLEFT", 0, 0)
	MicroMenu:SetSize( (28) * 12, 36)

	if not yo.ActionBar.MicroMenu then
		MicroMenu:SetShown(false)
		return
	end

	local PreviousButton
	local buttonList = {}

	table.remove( MICRO_BUTTONS, 11) --HelpMicroButton

	for i, buttonName in next, MICRO_BUTTONS do
    	local Button = _G[buttonName]
		Button:ClearAllPoints()

		if (i == 1) then
			Button:SetPoint("TOPLEFT", MicroMenu, "TOPLEFT", Spacing, 0)
		else
			Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
		end

		PreviousButton = Button
		MicroMenu["Button"..i] = Button
		table.insert(buttonList, Button)
		ActionButtonDesign( MicroMenu, Button, Size, Size)
	end

	local fader01 = {
  		fadeInAlpha 	= 1,
  		fadeInDuration 	= 0.3,
  		fadeInSmooth 	= "OUT",
  		fadeOutAlpha 	= 0.1,
  		fadeOutDuration = 0.9,
  		fadeOutSmooth 	= "OUT",
  		fadeOutDelay 	= 1,
	}

	rLib:CreateButtonFrameFader(MicroMenu, buttonList, fader01)
	self.Bars.Micro = MicroMenu
end
