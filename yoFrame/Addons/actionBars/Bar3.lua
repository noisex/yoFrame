local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function ActionBars:CreateBar3()
	local MultiBarBottomRight = MultiBarBottomRight
	local Size 			= yo.ActionBar.buttonsSize
	local Spacing 		= yo.ActionBar.buttonSpace
	local ButtonsPerRow = yo.ActionBar.panel3Cols
	local NumButtons 	= yo.ActionBar.panel3Nums

	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	if not yo.ActionBar.showBar3 then
		MultiBarBottomRight:SetShown(false)
		return
	end

	local ActionBar3 = CreateFrame("Frame", "yoActionBar3", N.PetHider, "SecureHandlerStateTemplate")
	ActionBar3:SetPoint("TOPLEFT", yoMoveABar3, "TOPLEFT", 0, 0)
	ActionBar3:SetFrameStrata("LOW")
	ActionBar3:SetFrameLevel(10)
	ActionBar3:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar3:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	MultiBarBottomRight:SetShown(true)
	MultiBarBottomRight:SetParent(ActionBar3)
	MultiBarBottomRight.QuickKeybindGlow:SetParent(N.Hider)

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["MultiBarBottomRightButton1"]

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarBottomRightButton"..i]
		local PreviousButton = _G["MultiBarBottomRightButton"..i-1]

		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)
		Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

		ActionButtonDesign( ActionBar3, Button, Size, Size)
		Button:SetAttribute("flyoutDirection", "")

		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar3, "TOPLEFT", Spacing, -Spacing)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["MultiBarBottomRightButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end

		ActionBar3["Button"..i] = Button
		Button:Show()
	end

	RegisterStateDriver(ActionBar3, "visibility", '[vehicleui] hide; [overridebar] hide; [petbattle] hide; show')--"[vehicleui] hide; show")

	self.Bars.Bar3 = ActionBar3
end
