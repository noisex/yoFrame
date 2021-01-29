local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.ActionBar.enable then return end

local _G = _G
local pairs, unpack, SetCVar, hooksecurefunc, InCombatLockdown
	= pairs, unpack, SetCVar, hooksecurefunc, InCombatLockdown

n.ActionBars = CreateFrame("Frame")
n.Hider = CreateFrame("Frame", nil, UIParent)
n.Hider:Hide()
n.PetHider = CreateFrame("Frame", "yoPetHider", UIParent, "SecureHandlerStateTemplate")

local ActionBars = n["ActionBars"]
local format = format
local Replace = string.gsub
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS
local MainMenuBar, MainMenuBarArtFrame = MainMenuBar, MainMenuBarArtFrame
local ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight = ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight
local Noop = function() return end

local Frames = {
	MainMenuBar,
	MainMenuBarArtFrame,
	OverrideActionBar,
	PossessBarFrame,
	ShapeshiftBarLeft,
	ShapeshiftBarMiddle,
	ShapeshiftBarRight,
}

function ActionBars:DisableBlizzard()
	local Hider = n.Hider

	for _, frame in pairs(Frames) do
		frame:UnregisterAllEvents()
		frame:SetParent(Hider)
	end

	local Options = {
		InterfaceOptionsActionBarsPanelBottomLeft,
		InterfaceOptionsActionBarsPanelBottomRight,
		InterfaceOptionsActionBarsPanelRight,
		InterfaceOptionsActionBarsPanelRightTwo,
		InterfaceOptionsActionBarsPanelStackRightBars,
		InterfaceOptionsActionBarsPanelAlwaysShowActionBars,
	}

	ActionBarButtonEventsFrame:UnregisterEvent("ACTIONBAR_SHOWGRID")
	ActionBarButtonEventsFrame:UnregisterEvent("ACTIONBAR_HIDEGRID")

	for i, j in pairs(Options) do
		j:Hide()
		j:Disable()
		j:SetScale(0.001)
	end

	MultiActionBar_Update = Noop
	BeginActionBarTransition = Noop

	--if yo.ActionBar.HideHotKey then
	--	ActionButton_UpdateRangeIndicator = Noop
	--end

	if false then -- C.ActionBars.AutoAddNewSpell then
		IconIntroTracker:UnregisterAllEvents()

		RegisterStateDriver(IconIntroTracker, "visibility", "hide")
	end

	-- Micro Menu
	--MicroButtonAndBagsBar:ClearAllPoints()
	--MicroButtonAndBagsBar:SetScale(yo.ActionBar.MicroScale, yo.ActionBar.MicroScale)
	--MicroButtonAndBagsBar:SetPoint("TOPLEFT", yoMoveAMicro, "TOPLEFT", 0, 0)
end

function ActionBars:MovePetBar()
	--local PetBar = TukuiPetActionBar
	--local RightBar = TukuiActionBar5
	--local Data1 = TukuiData[T.MyRealm][T.MyName].Move.TukuiActionBar5
	--local Data2 = TukuiData[T.MyRealm][T.MyName].Move.TukuiPetActionBar

	---- Don't run if player moved bar 5 or pet bar
	--if Data1 or Data2 then
	--	return
	--end

	--if RightBar:IsShown() then
	--	PetBar:SetPoint("RIGHT", RightBar, "LEFT", -6, 0)
	--else
	--	PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -28, 8)
	--end
end

function ActionBars:UpdatePetBar()
	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local ButtonName = "PetActionButton" .. i
		local PetActionButton = _G[ButtonName]

		PetActionButton:SetNormalTexture("")
	end
end

function ActionBars:OnUpdatePetBarCooldownText(elapsed)
	--local Now = GetTime()
	--local Timer = Now - self.StartTimer
	--local Cooldown = self.DurationTimer - Timer

	--self.Elapsed = self.Elapsed - elapsed

	--if self.Elapsed < 0 then
	--	if Cooldown <= 0 then
	--		self.Text:SetText("")

	--		self:SetScript("OnUpdate", nil)
	--	else
	--		self.Text:SetTextColor(1, 0, 0)
	--		self.Text:SetText(T.FormatTime(Cooldown))
	--	end

	--	self.Elapsed = .1
	--end
end

function ActionBars.UpdatePetBarCooldownText()
	--for i = 1, NUM_PET_ACTION_SLOTS, 1 do
	--	local Cooldown = _G["PetActionButton"..i.."Cooldown"]
	--	local Start, Duration, Enable = GetPetActionCooldown(i)

	--	if Enable and Enable ~= 0 and Start > 0 and Duration > 0 then
	--		if not Cooldown.Text then
	--			local Font = T.GetFont(C["Cooldowns"].Font)

	--			Font = _G[Font]:GetFont()

	--			Cooldown.Text = Cooldown:CreateFontString(nil, "OVERLAY")
	--			Cooldown.Text:SetPoint("CENTER", 1, 0)
	--			Cooldown.Text:SetFont(Font, 14, "THINOUTLINE")
	--		end

	--		Cooldown.StartTimer = Start
	--		Cooldown.DurationTimer = Duration
	--		Cooldown.Elapsed = .1
	--		Cooldown:SetScript("OnUpdate", ActionBars.OnUpdatePetBarCooldownText)
	--	end
	--end
end

function ActionBars:UpdateStanceBar()
	if InCombatLockdown() then
		return
	end

	local NumForms = GetNumShapeshiftForms()
	local Texture, Name, IsActive, IsCastable, Button, Icon, Cooldown, Start, Duration, Enable
	local PetSize = 30
	local Spacing = 2

	if NumForms == 0 then
		self.Bars.Stance:SetAlpha(0)
	else
		self.Bars.Stance:SetAlpha(1)
		self.Bars.Stance:SetSize((PetSize * NumForms) + (Spacing * (NumForms + 1)), PetSize + (Spacing * 2))

		if self.Bars.Stance.Backdrop then
			self.Bars.Stance.Backdrop:SetPoint("TOPLEFT", 0, 0)
		end

		for i = 1, NUM_STANCE_SLOTS do
			local ButtonName = "StanceButton"..i

			Button = _G[ButtonName]
			Icon = _G[ButtonName.."Icon"]

			Button:SetNormalTexture("")

			if i <= NumForms then
				Texture, IsActive, IsCastable = GetShapeshiftFormInfo(i)

				if not Icon then
					return
				end

				Icon:SetTexture(Texture)
				Cooldown = _G[ButtonName.."Cooldown"]

				if Texture then
					Cooldown:SetAlpha(1)
				else
					Cooldown:SetAlpha(0)
				end

				Start, Duration, Enable = GetShapeshiftFormCooldown(i)
				CooldownFrame_Set(Cooldown, Start, Duration, Enable)

				if IsActive then
					StanceBarFrame.lastSelected = Button:GetID()
					Button:SetChecked(true)

					if Button.Backdrop then
						Button.Backdrop:SetBorderColor(0, 1, 0)
					end
				else
					Button:SetChecked(false)

					--if Button.Backdrop then
						--Button.Backdrop:SetBorderColor(unpack(C.General.BorderColor))
					--end
				end

				if IsCastable then
					Icon:SetVertexColor(1.0, 1.0, 1.0)
				else
					Icon:SetVertexColor(0.4, 0.4, 0.4)
				end
			end
		end
	end
end

function ActionBars:RangeUpdate(hasrange, inrange)
	--local Icon = self.icon
	--local NormalTexture = self.NormalTexture
	--local ID = self.action

	--if not ID then
	--	return
	--end

	--local IsUsable, NotEnoughPower = IsUsableAction(ID)
	--local HasRange = hasrange
	--local InRange = inrange

	--if IsUsable then
	--	if (HasRange and InRange == false) then
	--		Icon:SetVertexColor(0.8, 0.1, 0.1)

	--		--NormalTexture:SetVertexColor(0.8, 0.1, 0.1)
	--	else
	--		Icon:SetVertexColor(1.0, 1.0, 1.0)

	--		--NormalTexture:SetVertexColor(1.0, 1.0, 1.0)
	--	end
	--elseif NotEnoughPower then
	--	Icon:SetVertexColor(0.1, 0.3, 1.0)

	--	--NormalTexture:SetVertexColor(0.1, 0.3, 1.0)
	--else
	--	Icon:SetVertexColor(0.3, 0.3, 0.3)

	--	--NormalTexture:SetVertexColor(0.3, 0.3, 0.3)
	--end
end

function ActionBars:StartHighlight()
	if not self.Animation then
		self.Animation = self:CreateAnimationGroup()
		self.Animation:SetLooping("BOUNCE")

		self.Animation.FadeOut = self.Animation:CreateAnimation("Alpha")
		self.Animation.FadeOut:SetFromAlpha(1)
		self.Animation.FadeOut:SetToAlpha(.3)
		self.Animation.FadeOut:SetDuration(.3)
		self.Animation.FadeOut:SetSmoothing("IN_OUT")
	end

	-- Hide Blizard Proc
	if self.overlay and self.overlay:GetParent() ~= n.Hider then
		self.overlay:SetParent( n.Hider)
	end

	if not self.Animation:IsPlaying() then
		self.Animation:Play()

		if self.shadow then
			self.shadow:SetBackdropBorderColor(1, 1, 0)
		end
	end
end

function ActionBars:StopHightlight()
	if self.Animation and self.Animation:IsPlaying() then
		self.Animation:Stop()

		if self.shadow then
			self.shadow:SetBackdropBorderColor(0.09, 0.09, 0.09, 1)
		end
	end
end

function ActionBars:BetterHotKeyText()
	local HotKey = self.HotKey
	local Text = HotKey:GetText()
	local Indicator = _G["RANGE_INDICATOR"]

	if (not Text) then
		return
	end

	Text = Replace(Text, "(s%-)", "S")
	Text = Replace(Text, "(a%-)", "A")
	Text = Replace(Text, "(c%-)", "C")
	Text = Replace(Text, KEY_MOUSEWHEELDOWN , "MDn")
	Text = Replace(Text, KEY_MOUSEWHEELUP , "MUp")
	Text = Replace(Text, KEY_BUTTON3, "M3")
	Text = Replace(Text, KEY_BUTTON4, "M4")
	Text = Replace(Text, KEY_BUTTON5, "M5")
	Text = Replace(Text, KEY_MOUSEWHEELUP, "MU")
	Text = Replace(Text, KEY_MOUSEWHEELDOWN, "MD")
	Text = Replace(Text, KEY_NUMPAD0, "N0")
	Text = Replace(Text, KEY_NUMPAD1, "N1")
	Text = Replace(Text, KEY_NUMPAD2, "N2")
	Text = Replace(Text, KEY_NUMPAD3, "N3")
	Text = Replace(Text, KEY_NUMPAD4, "N4")
	Text = Replace(Text, KEY_NUMPAD5, "N5")
	Text = Replace(Text, KEY_NUMPAD6, "N6")
	Text = Replace(Text, KEY_NUMPAD7, "N7")
	Text = Replace(Text, KEY_NUMPAD8, "N8")
	Text = Replace(Text, KEY_NUMPAD9, "N9")
	Text = Replace(Text, KEY_NUMPADDECIMAL, "N.")
	Text = Replace(Text, KEY_NUMPADDIVIDE, "N/")
	Text = Replace(Text, KEY_NUMPADMINUS, "N-")
	Text = Replace(Text, KEY_NUMPADMULTIPLY, "N*")
	Text = Replace(Text, KEY_NUMPADPLUS, "N+")
	Text = Replace(Text, KEY_PAGEUP, "PU")
	Text = Replace(Text, KEY_PAGEDOWN, "PD")
	Text = Replace(Text, KEY_SPACE, "SpB")
	Text = Replace(Text, KEY_INSERT, "Ins")
	Text = Replace(Text, KEY_HOME, "Hm")
	Text = Replace(Text, KEY_DELETE, "Del")
	Text = Replace(Text, KEY_BACKSPACE, "Bks")
	Text = Replace(Text, KEY_INSERT_MAC, "Hlp") -- mac

	if HotKey:GetText() == Indicator then
		HotKey:SetText("")
	else
		HotKey:SetText(Text)
	end
end

function ActionBars:AddHooks()
	hooksecurefunc("ActionButton_UpdateFlyout", self.StyleFlyout)
	hooksecurefunc("SpellButton_OnClick", self.StyleFlyout)
	--hooksecurefunc("ActionButton_UpdateRangeIndicator", ActionBars.RangeUpdate)

	if yo.ActionBar.HideHotKey then
		hooksecurefunc("PetActionButton_SetHotkeys", self.BetterHotKeyText)
	end

	if yo.ActionBar.showNewGlow then --C.ActionBars.ProcAnim then
		hooksecurefunc("ActionButton_ShowOverlayGlow", ActionBars.StartHighlight)
		hooksecurefunc("ActionButton_HideOverlayGlow", ActionBars.StopHightlight)
	end
end

function ActionBars:Enable( event, ...)
	if not yo.ActionBar.enable then return end

	SetCVar("alwaysShowActionBars", 1)

	if event == "PLAYER_LOGIN" then
		self:CreateBar1()
		self:AddHooks()
	else
		self:DisableBlizzard()
		self:CreateBar2()
		self:CreateBar3()
		self:CreateBar4()
		self:CreateBar5()
		self:CreatePetBar()
		self:CreateStanceBar()
		self:CreateMicroBar()
		self:SetupExtraButton()
		self:CreateExitButton()
		--self:CreateTotemBar()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

n.moveCreateAnchor("yoMoveABar1", 	"Move Action Bar #1", 445, 35, 0, 	2, 		"BOTTOM", "BOTTOM")
n.moveCreateAnchor("yoMoveABar2", 	"Move Action Bar #2", 445, 35, 0, 	40, 	"BOTTOM", "BOTTOM")
n.moveCreateAnchor("yoMoveABar3", 	"Move Action Bar #3", 40, 40, -300, 300, 	"TOPRIGHT", "BOTTOMRIGHT")
n.moveCreateAnchor("yoMoveABar4", 	"Move Action Bar #4", 445, 35, -1, 	182, 	"BOTTOMRIGHT", "BOTTOMRIGHT")
n.moveCreateAnchor("yoMoveABar5", 	"Move Action Bar #5", 35, 445, -5, 	-110, 	"RIGHT", "RIGHT")
n.moveCreateAnchor("yoMoveAMicro", 	"Move MicroMenu Bar", 220, 18, 350,5, 		"BOTTOM", "BOTTOM")
n.moveCreateAnchor("yoMovePetBar", 	"Move Pet Bar", 	  330, 30, 0, 	5, 		"BOTTOMRIGHT", "TOPRIGHT", n.infoTexts.LeftDataPanel)
n.moveCreateAnchor("yoMoveExtr", 	"Move Extro Button",  130, 60, 0, 	150, 	"BOTTOM", "TOP", n.Addons.moveFrames.yoMoveplayer)

PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint('CENTER', yoMoveAltPower, 'CENTER')
PlayerPowerBarAlt:SetParent(yoMoveAltPower)
PlayerPowerBarAlt:SetScale( 0.75, 0.75)
PlayerPowerBarAlt.ClearAllPoints = n.dummy
PlayerPowerBarAlt.SetPoint = n.dummy
--PlayerPowerBarAlt.ignoreFramePositionManager = true

ActionBars:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBars:RegisterEvent("PLAYER_LOGIN")
ActionBars:SetScript("OnEvent", function(self, ...)
	self:Enable(...)
end)

----------------------------------------------------------------------------------------------
------ 		update OverrideBar new buttons
----------------------------------------------------------------------------------------------
hooksecurefunc("ActionBarController_UpdateAll", function(self, ...)
	if ( HasBonusActionBar() or HasOverrideActionBar() or HasVehicleActionBar() or HasTempShapeshiftActionBar() ) then
		--print("ПОПАЛИ: ", CURRENT_ACTION_BAR_STATE, LE_ACTIONBAR_STATE_OVERRIDE, HasVehicleActionBar(), HasOverrideActionBar(), HasTempShapeshiftActionBar(), C_PetBattles.IsInBattle())
		for i = 1, 6 do
			if ActionBarButtonEventsFrame.frames[i] then ActionBarButtonEventsFrame.frames[i]:Update() end
		end
	end
end)