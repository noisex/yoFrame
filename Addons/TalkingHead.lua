local function RemoveAnchor()
	for i, alertSubSystem in pairs(AlertFrame.alertFrameSubSystems) do
		if alertSubSystem.anchorFrame == TalkingHeadFrame then
			tremove(AlertFrame.alertFrameSubSystems, i)
			return 
		end
	end
end

local function moveTH(self, event, name)
	--print(self, event, name)
	if name == "Blizzard_TalkingHeadUI" then
		TalkingHeadFrame.ignoreFramePositionManager = true
		TalkingHeadFrame:ClearAllPoints()
		TalkingHeadFrame:SetPoint("TOP", UIParent, "TOP", 0, -70)
		TalkingHeadFrame:SetScale( .75)

		RemoveAnchor()
		return true
	end
end

local logan = CreateFrame("Frame")
	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint( "CENTER", UIParent, "CENTER", 0, 200)

	logan:RegisterEvent("ADDON_LOADED")
	logan:SetScript("OnEvent", moveTH)