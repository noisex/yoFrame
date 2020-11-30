local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local ActionBars = n["ActionBars"]
local MAX_TOTEMS = MAX_TOTEMS

function ActionBars:CreateTotemBar()

	--if (not C.ActionBars.Pet) then
	--	return
	--end

	local PetSize = 30
	local Spacing = 2
	local Size = 30
	local PetActionBarFrame = PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local ButtonsPerRow = 10
	local NumRow = ceil(10 / ButtonsPerRow)

	local Bar = CreateFrame("Frame", "yoTotemBar", n.PetHider, "SecureHandlerStateTemplate")
	Bar:SetPoint("RIGHT", yoMovePetBar, "RIGHT")
	Bar:SetFrameStrata("LOW")
	Bar:SetFrameLevel(10)
	Bar:SetWidth((PetSize * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	Bar:SetHeight((PetSize * NumRow) + (Spacing * (NumRow + 1)))

	--if C.ActionBars.ShowBackdrop then
	--	Bar:CreateBackdrop()
	--	Bar:CreateShadow()
	--end

	PetActionBarFrame:EnableMouse(0)
	PetActionBarFrame:ClearAllPoints()
	PetActionBarFrame:SetParent( n.Hider)

	local NumPerRows = ButtonsPerRow
	local NextRowButtonAnchor = _G["TotemFrameTotem1"]

	for i = 1, MAX_TOTEMS do
		local Button = _G["TotemFrameTotem"..i]
		local PreviousButton = _G["TotemFrameTotem"..i-1]

		Button:SetParent(Bar)
		Button:ClearAllPoints()
		Button:SetSize(PetSize, PetSize)
		Button:SetNormalTexture("")
		ActionButtonDesign( Bar, Button, Size, Size)
		Button:Show()
		Button:SetAttribute("flyoutDirection", "")

		if (i == 1) then
			Button:SetPoint("TOPRIGHT", Bar, "TOPRIGHT", -Spacing, 0)
		elseif (i == NumPerRows + 1) then
			Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

			NumPerRows = NumPerRows + ButtonsPerRow
			NextRowButtonAnchor = _G["TotemFrameTotem"..i]
		else
			Button:SetPoint("RIGHT", PreviousButton, "LEFT", Spacing, 0)
		end

		Bar:SetAttribute("addchild", Button)
		Bar["Button"..i] = Button
	end

	--hooksecurefunc("PetActionBar_Update", ActionBars.UpdatePetBar)
	--hooksecurefunc("PetActionBar_UpdateCooldowns", ActionBars.UpdatePetBarCooldownText)

	--ActionBars:SkinPetButtons()

	RegisterStateDriver(Bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show") --[pet]

	self.Bars.Pet = Bar
end
