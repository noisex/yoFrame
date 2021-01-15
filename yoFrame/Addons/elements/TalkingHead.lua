local L, yo, n = unpack( select( 2, ...))

local _G = _G
local hoocked
local TalkingHeadFrame_PlayCurrent_Original
local pairs, tremove
	= pairs, tremove


local function RemoveAnchor()
	for i, alertSubSystem in pairs( _G.AlertFrame.alertFrameSubSystems) do
		if alertSubSystem.anchorFrame == _G.TalkingHeadFrame then
			tremove( _G.AlertFrame.alertFrameSubSystems, i)
			return
		end
	end
end

local function TalkingHeadFrame_PlayCurrent_hoocked()

	local _, _, vo = C_TalkingHead.GetCurrentLineInfo();

	local frame = TalkingHeadFrame;

	if( frame.finishTimer ) then
	frame.finishTimer:Cancel();
		frame.finishTimer = nil;
	end
	if ( frame.voHandle ) then
		StopSound(frame.voHandle);
		frame.voHandle = nil;
	end

	if n.talkingHead[vo] then
		if not yo.Addons.hideSound then
			local success, voHandle = PlaySound(vo, "Talking Head", true, true);
			if success then frame.voHandle = voHandle end
		end
		return
	else
		n.talkingHead[vo] = true
	end

	TalkingHeadFrame_PlayCurrent_Original()
end

local function moveTH(self, event, name)
	--print(self, event, name)
	if name == "Blizzard_TalkingHeadUI" then

		_G.TalkingHeadFrame.ignoreFramePositionManager = true
		_G.TalkingHeadFrame:ClearAllPoints()
		_G.TalkingHeadFrame:SetPoint("TOP", UIParent, "TOP", 0, -70)
		_G.TalkingHeadFrame:SetScale( .75)

		RemoveAnchor()

		if yo.Addons.hideHead then
			if not hoocked then
				n.talkingHead = yo.Addons.hideForAll and _G.yo_talkingHead or n.allData.talkingHead

				TalkingHeadFrame_PlayCurrent_Original = TalkingHeadFrame_PlayCurrent
				TalkingHeadFrame_PlayCurrent = TalkingHeadFrame_PlayCurrent_hoocked
				hoocked = true
			end
		end

		return true
	end
end

local logan = CreateFrame("Frame")
	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint( "CENTER", UIParent, "CENTER", 0, 200)

	logan:RegisterEvent("ADDON_LOADED")
	logan:SetScript("OnEvent", moveTH)