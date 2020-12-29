local L, yo, n = unpack( select( 2, ...))

local hoocked

local function RemoveAnchor()
	for i, alertSubSystem in pairs(AlertFrame.alertFrameSubSystems) do
		if alertSubSystem.anchorFrame == TalkingHeadFrame then
			tremove(AlertFrame.alertFrameSubSystems, i)
			return
		end
	end
end

function TalkingHeadFrame_PlayCurrent_hoocked()
	--print( "TH Here")
	local _, _, vo = C_TalkingHead.GetCurrentLineInfo();

	if n.talkingHead[vo] then return
	else
		n.talkingHead[vo] = true
	end

	TalkingHeadFrame_PlayCurrent_Original()
end

local function moveTH(self, event, name)
	--print(self, event, name)
	if name == "Blizzard_TalkingHeadUI" then
		TalkingHeadFrame.ignoreFramePositionManager = true
		TalkingHeadFrame:ClearAllPoints()
		TalkingHeadFrame:SetPoint("TOP", UIParent, "TOP", 0, -70)
		TalkingHeadFrame:SetScale( .75)

		if not hoocked then
			TalkingHeadFrame_PlayCurrent_Original = TalkingHeadFrame_PlayCurrent
			TalkingHeadFrame_PlayCurrent = TalkingHeadFrame_PlayCurrent_hoocked
			hoocked = true
		end
		RemoveAnchor()
		return true
	end
end

local logan = CreateFrame("Frame")
	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint( "CENTER", UIParent, "CENTER", 0, 200)

	logan:RegisterEvent("ADDON_LOADED")
	logan:SetScript("OnEvent", moveTH)