local addon, ns = ...
local L, yo, N = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]

function ActionBars:CreateExitButton()
	local Size = 35

	local frame = CreateFrame("Frame", "yo_VehicleExitBar", N.PetHider, "SecureHandlerStateTemplate")
  frame:SetPoint("CENTER", yoMoveExtr, "CENTER", 0, -60)
  frame:SetSize( Size, Size)
  frame.frameVisibility = "[canexitvehicle][target=vehicle,exists] show;hide"
   frame.frameVisibilityFunc = "exit"
   RegisterStateDriver(frame, frame.frameVisibilityFunc, frame.frameVisibility)

   frame:SetAttribute("_onstate-exit", [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
   if not CanExitVehicle() then frame:Hide() end

	local button = CreateFrame("CHECKBUTTON", "yoVehicleExitButton", frame, "ActionButtonTemplate, SecureHandlerClickTemplate")
  button.icon:SetTexture("interface\\addons\\yoFrame\\Media\\vehicleexit")
  button:RegisterForClicks("AnyUp")
 	button:ClearAllPoints()
 	button:SetPoint("CENTER", frame, "CENTER", 0, 0)
	button:SetSize( Size, Size)
	button:SetParent(frame)

  local function OnClick(self)
   	if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end self:SetChecked(false)
  end
  button:SetScript("OnClick", OnClick)

	ActionButtonDesign( button, button, Size, Size)
	--self.Bars.Exit = button
end
