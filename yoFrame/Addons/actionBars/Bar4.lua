local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = n["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ActionBars:CreateBar4()
	local MultiBarRight = MultiBarRight
	local Size = yo.ActionBar.buttonsSize
	local Spacing = yo.ActionBar.buttonSpace
	local ButtonsPerRow = 12
	local NumButtons = 12

	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	--if not C.ActionBars.RightBar then
	--	MultiBarRight:SetShown(false)

	--	return
	--end

	local ActionBar4 = CreateFrame("Frame", "yoActionBar4", n.PetHider, "SecureHandlerStateTemplate")
	ActionBar4:SetFrameStrata("LOW")
	ActionBar4:SetFrameLevel(10)
	ActionBar4:SetPoint("TOPLEFT", yoMoveABar4, "TOPLEFT", 0, 0)
	ActionBar4:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar4:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	MultiBarRight:SetShown(true)
	MultiBarRight:SetParent(ActionBar4)
	MultiBarRight.QuickKeybindGlow:SetParent(n.Hider)

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarRightButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarRightButton"..i]
		local PreviousButton = _G["MultiBarRightButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionButtonDesign( ActionBar4, Button, Size, Size)
		Button:SetAttribute("flyoutDirection", "")

		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar4, "TOPLEFT", Spacing, -Spacing)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarRightButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end

		ActionBar4["Button"..i] = Button
	end

	RegisterStateDriver(ActionBar4, "visibility", "[vehicleui] hide; show")

	self.Bars.Bar4 = ActionBar4
end
