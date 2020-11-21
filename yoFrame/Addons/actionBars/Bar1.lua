local addon, ns = ...
local L, yo, N = unpack( ns)

local _G = _G

local ceil, CreateFrame, select, UnitClass
	= ceil, CreateFrame, select, UnitClass

if not yo.ActionBar.enable then return end

local ActionBars = N["ActionBars"]
local Num = NUM_ACTIONBAR_BUTTONS
local MainMenuBar_OnEvent = MainMenuBar_OnEvent

function ActionBars:CreateBar1()

	local Size = yo.ActionBar.buttonsSize
	local Spacing = yo.ActionBar.buttonSpace
	local Druid, Rogue, Warrior, Priest = "", "", "", ""
	local ButtonsPerRow = 12
	local NumRow = ceil(12 / ButtonsPerRow)

	local ActionBar1 = CreateFrame("Frame", "yoActionBar1", N.PetHider, "SecureHandlerStateTemplate")
	ActionBar1:SetPoint("TOPLEFT", yoMoveABar1, "TOPLEFT", 0, 0)
	ActionBar1:SetFrameStrata("LOW")
	ActionBar1:SetFrameLevel(10)
	ActionBar1:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar1:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	if true then --(C.ActionBars.SwitchBarOnStance) then
		Rogue = "[bonusbar:1] 7;"
		Druid = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
		Warrior = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;"
		Priest = "[bonusbar:1] 7;"
	end

	ActionBar1.Page = {
		["DRUID"] = Druid,
		["ROGUE"] = Rogue,
		["WARRIOR"] = Warrior,
		["PRIEST"] = Priest,
		["DEFAULT"] = "[bar:6] 6;[bar:5] 5;[bar:4] 4;[bar:3] 3;[bar:2] 2;[overridebar] 14;[shapeshift] 13;[vehicleui] 12;[possessbar] 12;",
		--"[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1",
	}
	function ActionBar1:GetBar()
		local Condition = ActionBar1.Page["DEFAULT"]
		local Class = select(2, UnitClass("player"))
		local Page = ActionBar1.Page[Class]

		if Page then
			Condition = Condition .. " " .. Page
		end

		Condition = Condition .. " [form] 1; 1"

		return Condition
	end

	for i = 1, Num do
		local Button = _G["ActionButton"..i]

		ActionBar1:SetFrameRef("ActionButton"..i, Button)
	end

	ActionBar1:Execute([[
		Button = table.new()
		for i = 1, 12 do
			table.insert(Button, self:GetFrameRef("ActionButton"..i))
		end
	]])

	ActionBar1:SetAttribute("_onstate-page", [[
		if HasTempShapeshiftActionBar() then
			newstate = GetTempShapeshiftBarIndex() or newstate
		end

		for i, Button in ipairs(Button) do
			Button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])

	RegisterStateDriver(ActionBar1, "page", ActionBar1.GetBar())

	ActionBar1:RegisterEvent("PLAYER_ENTERING_WORLD")
	ActionBar1:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
	ActionBar1:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
	ActionBar1:SetScript("OnEvent", function(self, event, unit, ...)
		if (event == "PLAYER_ENTERING_WORLD") then
			local NumPerRows = ButtonsPerRow
			local NextRowButtonAnchor = _G["ActionButton1"]

			for i = 1, Num do
				local Button = _G["ActionButton"..i]
				local PreviousButton = _G["ActionButton"..i-1]

				Button:SetSize(Size, Size)
				Button:ClearAllPoints()
				Button:SetParent(self)
				Button:SetAttribute("showgrid", 1)
				Button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

			ActionButtonDesign( ActionBar1, Button, Size, Size)
			Button:SetAttribute("flyoutDirection", "")
			--	ActionBars:SkinButton(Button)

				if (i == 1) then
					Button:SetPoint("TOPLEFT", ActionBar1, "TOPLEFT", Spacing, -Spacing)
				elseif (i == NumPerRows + 1) then
					Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

					NumPerRows = NumPerRows + ButtonsPerRow
					NextRowButtonAnchor = _G["ActionButton"..i]
				else
					Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
				end
			end
		elseif (event == "UPDATE_VEHICLE_ACTIONBAR") or (event == "UPDATE_OVERRIDE_ACTIONBAR") then
			for i = 1, 12 do
				local Button = _G["ActionButton"..i]
				local Action = Button.action
				local Icon = Button.icon

				if Action >= 120 then
					local Texture = GetActionTexture(Action)

					if (Texture) then
						Icon:SetTexture(Texture)
						Icon:Show()
					else
						if Icon:IsShown() then
							Icon:Hide()
						end
					end
				end
			end
		end
	end)

	for i = 1, Num do
		local Button = _G["ActionButton"..i]

		ActionBar1["Button"..i] = Button
	end

	self.Bars = {}
	self.Bars.Bar1 = ActionBar1
end