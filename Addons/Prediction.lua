local L, yo = unpack( select( 2, ...))

local function OnEvent( f)
	local uhpm = UnitHealthMax( "player")
	local hpbWidt = f:GetParent():GetWidth()
	local curXLeft = ( hpbWidt * UnitHealth( "player")) / uhpm
	local predic = ( hpbWidt * UnitGetIncomingHeals("player") / uhpm)

	if predic + curXLeft >= hpbWidt then
		predic = hpbWidt - curXLeft
	end

	if predic <= 3 then
		f.bg:Hide()
	else
	    f.bg:SetPoint("LEFT", f, "LEFT", curXLeft, 0)
		f.bg:SetSize( predic, f:GetParent():GetHeight())
		f.bg:Show()
	end
end

 local function CreatePred( f)
	local predic = CreateFrame( "Frame", nil, f)
	predic:SetPoint('LEFT', f, 'LEFT', 0, 0)
	predic:SetWidth( 2)
	predic:SetHeight( 2)
	predic:SetFrameLevel( 1)

	predic.bg = predic:CreateTexture(nil,'OVERLAY')
	predic.bg:SetVertexColor( 0, 1, 0, 0.5)
	predic.bg:SetTexture( texture)

	predic:RegisterUnitEvent("UNIT_HEAL_PREDICTION", "player")
	predic:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
	predic:SetScript("OnEvent", OnEvent)

	f.prediction = predic
	f.prediction.bg:Hide()
 end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	if not yo.Addons.Prediction then return end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.PredictionHealth then return end
	CreatePred( plFrame)
end)
