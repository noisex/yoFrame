local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = n["ActionBars"]

function ActionBars:CreateStanceBar()
	local PetSize = 30
	local Spacing = 1
	local Size 		= 30

	--if (not C.ActionBars.ShapeShift) then
	--	return
	--end

	local StanceBar = CreateFrame("Frame", "yoStanceBar", n.PetHider, "SecureHandlerStateTemplate")
	StanceBar:SetSize((PetSize * 10) + (Spacing * 11), PetSize + (Spacing * 2))
	StanceBar:SetPoint("BOTTOMRIGHT", n.Addons.moveFrames.yoMovePetBar, "BOTTOMRIGHT", 0, 0)
	StanceBar:SetFrameStrata("LOW")
	StanceBar:SetFrameLevel(10)

	--if C.ActionBars.ShowBackdrop then
	--	StanceBar:CreateBackdrop()
	--	StanceBar:CreateShadow()
	--end

	StanceBarFrame.ignoreFramePositionManager = true
	--StanceBarFrame:StripTextures()
	StanceBarFrame:SetParent(StanceBar)
	StanceBarFrame:ClearAllPoints()
	StanceBarFrame:SetPoint("TOPLEFT", StanceBar, "TOPLEFT", -7, 0)
	StanceBarFrame:EnableMouse(false)

	for i = 1, NUM_STANCE_SLOTS do
		local Button = _G["StanceButton"..i]

		ActionButtonDesign( StanceBar, Button, Size, Size)
		Button:Show()

		if (i ~= 1) then
			local Previous = _G["StanceButton"..i-1]

			Button:ClearAllPoints()
			Button:SetPoint("RIGHT", Previous, "LEFT", -Spacing, 0)
		else
			Button:ClearAllPoints()
			Button:SetPoint("TOPRIGHT", StanceBar, "TOPRIGHT", 0, 0)
		end
	end

	StanceBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
	StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
	StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	StanceBar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
	StanceBar:RegisterEvent("SPELLS_CHANGED")
	StanceBar:SetScript("OnEvent", function(self, event, ...)
		if (event == "UPDATE_SHAPESHIFT_FORMS") then

		elseif (event == "PLAYER_ENTERING_WORLD") then
			ActionBars:UpdateStanceBar()

			--ActionBars:SkinStanceButtons()
		else
			ActionBars:UpdateStanceBar()
		end
	end)

	self.Bars.Stance = StanceBar
end
