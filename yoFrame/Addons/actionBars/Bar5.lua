local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = n["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ActionBars:CreateBar5()
	local MultiBarLeft = MultiBarLeft
	local Size = yo.ActionBar.buttonsSize
	local Spacing = yo.ActionBar.buttonSpace
	local ButtonsPerRow = 1
	local NumButtons = 12

	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	if not yo.ActionBar.showBar5 then
		MultiBarLeft:SetShown(false)
		return
	end

	local ActionBar5 = CreateFrame("Frame", "TukuiActionBar5", n.PetHider, "SecureHandlerStateTemplate")
	ActionBar5:SetFrameStrata("LOW")
	ActionBar5:SetFrameLevel(10)
	ActionBar5:SetPoint("TOPLEFT", yoMoveABar5, "TOPLEFT", 0, 0)
	ActionBar5:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar5:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	--if C.ActionBars.ShowBackdrop then
	--	ActionBar5:CreateBackdrop()
	--	ActionBar5:CreateShadow()
	--end

	MultiBarLeft:SetShown(true)
	MultiBarLeft:SetParent(ActionBar5)
	MultiBarLeft.QuickKeybindGlow:SetParent( n.Hider)

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarLeftButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarLeftButton"..i]
		local PreviousButton = _G["MultiBarLeftButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionButtonDesign( ActionBar5, Button, Size, Size)
		Button:SetAttribute("flyoutDirection", "LEFT")
		--ActionBars:SkinButton(Button)

		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar5, "TOPLEFT", Spacing, -Spacing)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarLeftButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end

		ActionBar5["Button"..i] = Button
	end

	RegisterStateDriver(ActionBar5, "visibility", "[vehicleui] hide; show")

	local fader00 = {
  		fadeInAlpha 	= 1,
  		fadeInDuration 	= 0.3,
  		fadeInSmooth 	= "OUT",
  		fadeOutAlpha 	= 0,
  		fadeOutDuration = 0.9,
  		fadeOutSmooth 	= "OUT",
  		fadeOutDelay 	= 1,
	}

	local buttonName = "MultiBarLeftButton"
  	local numButtons = NUM_ACTIONBAR_BUTTONS
  	local buttonList = GetButtonList(buttonName, numButtons)
	rLib:CreateButtonFrameFader(ActionBar5, buttonList, fader00)

	self.Bars.Bar5 = ActionBar5
end
