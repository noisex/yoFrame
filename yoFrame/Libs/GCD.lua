local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.UF.showGCD then return end

----------------------------------------------------------------------------------------
--	Based on oUF_GCD(by ALZA)
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

local starttime, duration, usingspell
local GetTime = GetTime

local Enable = function(self)
	if not self.GCD then return end
	local bar = self.GCD
	local width = bar:GetWidth()
	bar:Hide()

	bar.spark = bar:CreateTexture(nil, "OVERLAY")
	bar.spark:SetTexture( [[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.spark:SetVertexColor( 1,1,1,1)
	bar.spark:SetHeight( 17)
	bar.spark:SetWidth( 8)
	bar.spark:SetBlendMode("ADD")

	local function OnUpdateSpark()
		bar.spark:ClearAllPoints()
		local elapsed = GetTime() - starttime
		local perc = elapsed / duration
		if perc > 1 then
			return bar:Hide()
		else
			bar.spark:SetPoint("CENTER", bar, "LEFT", width * perc, 0)
		end
	end

	local function OnHide()
		bar:SetScript("OnUpdate", nil)
		usingspell = nil
	end

	local function OnShow()
		bar:SetScript("OnUpdate", OnUpdateSpark)
	end

	local function UpdateGCD()
		local start, dur = GetSpellCooldown(61304)
		if dur and dur > 0 and dur <= 2 then
			usingspell = 1
			starttime = start
			duration = dur
			bar:Show()
			return
		elseif usingspell == 1 and dur == 0 then
			bar:Hide()
		end
	end

	bar:SetScript("OnShow", OnShow)
	bar:SetScript("OnHide", OnHide)

	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", UpdateGCD, true)
end

oUF:AddElement("GCD", UpdateGCD, Enable)