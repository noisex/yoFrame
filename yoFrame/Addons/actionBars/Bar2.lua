local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ActionBars:CreateBar2()
	local MultiBarBottomLeft = MultiBarBottomLeft
	local Size = yo.ActionBar.buttonsSize
	local Spacing = yo.ActionBar.buttonSpace
	local ButtonsPerRow = 12
	local NumButtons = 12

	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	--if not C.ActionBars.BottomLeftBar then
	--	MultiBarBottomLeft:SetShown(false)

	--	return
	--end

	local ActionBar2 = CreateFrame("Frame", "TukuiActionBar2", N.PetHider, "SecureHandlerStateTemplate")
	ActionBar2:SetPoint("TOPLEFT", yoMoveABar2, "TOPLEFT", 0, 0)
	ActionBar2:SetFrameStrata("LOW")
	ActionBar2:SetFrameLevel(10)
	ActionBar2:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar2:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	MultiBarBottomLeft:SetShown(true)
	MultiBarBottomLeft:SetParent(ActionBar2)
	MultiBarBottomLeft.QuickKeybindGlow:SetParent(N.Hider)

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarBottomLeftButton1"]

	for i = 1, 12 do
		local Button = _G["MultiBarBottomLeftButton"..i]
		local PreviousButton = _G["MultiBarBottomLeftButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionButtonDesign( ActionBar2, Button, Size, Size)
		Button:SetAttribute("flyoutDirection", "")

		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar2, "TOPLEFT", Spacing, -Spacing)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarBottomLeftButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end

		ActionBar2["Button"..i] = Button
	end

	for i = 7, 12 do
		local Button = _G["MultiBarBottomLeftButton"..i]
		local Button1 = _G["MultiBarBottomLeftButton1"]

		Button:SetFrameLevel(Button1:GetFrameLevel() - 2)
	end

	RegisterStateDriver(ActionBar2, "visibility", '[vehicleui] hide; [overridebar] hide; [petbattle] hide; show') --"[vehicleui] hide; show")

	self.Bars.Bar2 = ActionBar2
end
