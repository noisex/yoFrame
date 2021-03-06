local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local _G = _G
local ActionBars = n.ActionBars
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

local ceil, CreateFrame, hooksecurefunc, RegisterStateDriver, PetActionBar_UpdateCooldowns, ActionButtonDesign
	= ceil, CreateFrame, hooksecurefunc, RegisterStateDriver, PetActionBar_UpdateCooldowns, ActionButtonDesign

function ActionBars:CreatePetBar()

	--if (not C.ActionBars.Pet) then
	--	return
	--end

	local PetSize = 30
	local Spacing = 2
	local Size = 30
	local PetActionBarFrame = _G.PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local ButtonsPerRow = 10
	local NumRow = ceil(10 / ButtonsPerRow)

	local Bar = CreateFrame("Frame", "yoPetActionBar", n.PetHider, "SecureHandlerStateTemplate")
	Bar:SetPoint("RIGHT", n.Addons.moveFrames.yoMovePetBar, "RIGHT")
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
	local NextRowButtonAnchor = _G["PetActionButton1"]

	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		local PreviousButton = _G["PetActionButton"..i-1]

		Button:SetParent(Bar)
		Button:ClearAllPoints()
		Button:SetSize(PetSize, PetSize)
		Button:SetNormalTexture("")
		ActionButtonDesign( Bar, Button, Size, Size)
		Button:Show()

		if (i == 1) then
			Button:SetPoint("TOPRIGHT", Bar, "TOPRIGHT", -Spacing, 0)
		elseif (i == NumPerRows + 1) then
			Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

			NumPerRows = NumPerRows + ButtonsPerRow
			NextRowButtonAnchor = _G["PetActionButton"..i]
		else
			Button:SetPoint("RIGHT", PreviousButton, "LEFT", Spacing, 0)
		end

		Bar:SetAttribute("addchild", Button)
		Bar["Button"..i] = Button
	end

	hooksecurefunc("PetActionBar_Update", ActionBars.UpdatePetBar)
	--hooksecurefunc("PetActionBar_UpdateCooldowns", ActionBars.UpdatePetBarCooldownText)

	--ActionBars:SkinPetButtons()

	RegisterStateDriver(Bar, "visibility", "[@pet,exists,nopossessbar] show; hide")

	self.Bars.Pet = Bar
end
