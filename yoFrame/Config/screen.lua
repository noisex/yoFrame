local addon, ns = ...
local L, yo, n = unpack( ns)

local resolution = ({GetScreenResolutions()})[GetCurrentResolution()] or GetCVar("gxWindowedResolution")
local getscreenwidth, getscreenheight = GetPhysicalScreenSize() --DecodeResolution(resolution)

local function updateScreenScale(...)
	if yo.Media.AutoScale == "manual" then
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", yo.Media.ScaleRate)
		UIParent:SetScale( yo.Media.ScaleRate)

	elseif yo.Media.AutoScale == "auto" then
		local autoScale = tonumber( string.sub( 768 / getscreenheight, 0, 4))

		if getscreenwidth < 1024 and GetCVar("gxMonitor") == "0" then
			SetCVar("useUiScale", 0)
			StaticPopup_Show("DISABLE_UI")

		elseif getscreenwidth == 1366 and getscreenheight == 768 then
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", 0.82)
			UIParent:SetScale( 0.82)

		else
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", autoScale)
			UIParent:SetScale( autoScale)

			-- Hack for 4K and WQHD Resolution
			--local customScale = min(2, max(0.32, 768 / string.match(resolution, "%d+x(%d+)")))
			--if customScale >= 0.64 then
			--	UIParent:SetScale(customScale)
			--elseif customScale < 0.64 then
			--	UIParent:SetScale( 0.64)
			--end
		end
	else
		SetCVar("useUiScale", 0)
	end
end
n.conFuncs.AutoScale = updateScreenScale
n.conFuncs.ScaleRate = updateScreenScale
updateScreenScale()

local function updateErrors()
	if yo.General.scriptErrors == true then
		SetCVar("scriptErrors", 1)
	else
		SetCVar("scriptErrors", 0)
	end
end
n.conFuncs["scriptErrors"] = updateErrors
updateErrors()

SetCVar("alwaysShowActionBars", 1)

SetCVar("buffDurations",1)

SetCVar("screenshotQuality", 10)
SetCVar("showTutorials", 0)
SetCVar("cameraSmoothStyle", 1)

SetCVar("cameraDistanceMaxZoomFactor", 2.6)

SetCVar("TargetNearestUseNew", 1)
SetCVar("TargetPriorityCombatLock", 0)
SetCVar("TargetPriorityCombatLockContextualRelaxation", 0)
SetCVar("countdownForCooldowns", 0)
SetCVar("showTargetOfTarget", 1)

SetCVar("autoLootDefault", 1)

SetCVar("SpellQueueWindow", yo.CastBar.BCB.QueueWindow)

if n.myDev[n.myName] then
	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatDamage", 0)
	SetCVar("doNotFlashLowHealthWarning", 1)
end