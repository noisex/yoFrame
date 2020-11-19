local addon, ns = ...
local L, yo, N = unpack( ns)

function SetUpAnimGroup(object, type, ...)
	if not type then type = 'Flash' end

	if type == 'Flash' then
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha(0)
		object.anim.fadein:SetToAlpha(1)
		object.anim.fadein:SetOrder(2)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetFromAlpha(1)
		object.anim.fadeout:SetToAlpha(0)
		object.anim.fadeout:SetOrder(1)
	elseif type == 'FlashLoop' then
		local maxAlpha, minAlpha, delay = ...
		object.anim = object:CreateAnimationGroup("Flash")
		object.anim:SetLooping("REPEAT")
		object.anim.fadein = object.anim:CreateAnimation("ALPHA", "FadeIn")
		object.anim.fadein:SetFromAlpha( minAlpha or 0)
		object.anim.fadein:SetToAlpha( maxAlpha or 1)
		object.anim.fadein:SetOrder(1)

		object.anim.fadeout = object.anim:CreateAnimation("ALPHA", "FadeOut")
		object.anim.fadeout:SetStartDelay( delay or object.anim.fadein:GetDuration())
		object.anim.fadeout:SetFromAlpha( maxAlpha or 1)
		object.anim.fadeout:SetToAlpha( minAlpha or 0)
		object.anim.fadeout:SetOrder(1)

		--object.anim.scale = object.anim:CreateAnimation("SCALE", "Scale")
		--object.anim.scale:SetOrder(1)
		--object.anim.scale:SetDuration(0.75)
		--object.anim.scale:SetFromScale( 0.7, .7)
		--object.anim.scale:SetToScale( 1, 1)
		object.anim:SetScript("OnFinished", function(_, requested)
			object.plaing = false
			--print(time(), "...")
		end)
		object.anim:SetScript("OnPlay", function(_, requested)
			object.plaing = true
			--print(time(), "!!!!!!!!!!!")
		end)
	elseif type == 'Shake' then
		object.shake = object:CreateAnimationGroup("Shake")
		object.shake:SetLooping("REPEAT")
		object.shake.path = object.shake:CreateAnimation("Path")
		object.shake.path[1] = object.shake.path:CreateControlPoint()
		object.shake.path[2] = object.shake.path:CreateControlPoint()
		object.shake.path[3] = object.shake.path:CreateControlPoint()
		object.shake.path[4] = object.shake.path:CreateControlPoint()
		object.shake.path[5] = object.shake.path:CreateControlPoint()
		object.shake.path[6] = object.shake.path:CreateControlPoint()

		object.shake.path:SetDuration(0.7)
		object.shake.path[1]:SetOffset(random(-9, 7), random(-7, 12))
		object.shake.path[1]:SetOrder(1)
		object.shake.path[2]:SetOffset(random(-5, 9), random(-9, 5))
		object.shake.path[2]:SetOrder(2)
		object.shake.path[3]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[3]:SetOrder(3)
		object.shake.path[4]:SetOffset(random(-9, 9), random(-9, 9))
		object.shake.path[4]:SetOrder(4)
		object.shake.path[5]:SetOffset(random(-5, 7), random(-7, 5))
		object.shake.path[5]:SetOrder(5)
		object.shake.path[6]:SetOffset(random(-9, 7), random(-9, 5))
		object.shake.path[6]:SetOrder(6)
	elseif type == 'Shake_Horizontal' then
		object.shakeh = object:CreateAnimationGroup("ShakeH")
		object.shakeh:SetLooping("REPEAT")
		object.shakeh.path = object.shakeh:CreateAnimation("Path")
		object.shakeh.path[1] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[2] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[3] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[4] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[5] = object.shakeh.path:CreateControlPoint()
		object.shakeh.path[6] = object.shakeh.path:CreateControlPoint()

		object.shakeh.path:SetDuration(2)
		object.shakeh.path[1]:SetOffset(-5, 0)
		object.shakeh.path[1]:SetOrder(1)
		object.shakeh.path[2]:SetOffset(5, 0)
		object.shakeh.path[2]:SetOrder(2)
		object.shakeh.path[3]:SetOffset(-2, 0)
		object.shakeh.path[3]:SetOrder(3)
		object.shakeh.path[4]:SetOffset(5, 0)
		object.shakeh.path[4]:SetOrder(4)
		object.shakeh.path[5]:SetOffset(-2, 0)
		object.shakeh.path[5]:SetOrder(5)
		object.shakeh.path[6]:SetOffset(5, 0)
		object.shakeh.path[6]:SetOrder(6)

	elseif type == 'Fadein' then
		local minAlpha, maxAlpha, duration, finalAlpha, parent = ...
		object.Fadein = object:CreateAnimationGroup( "Fadein")
		object.Fadein:SetToFinalAlpha( finalAlpha)

		object.Fadein.AlphaAnim = object.Fadein:CreateAnimation("Alpha")
		object.Fadein.AlphaAnim:SetFromAlpha( minAlpha or 0)
		object.Fadein.AlphaAnim:SetToAlpha( maxAlpha or 1)
		object.Fadein.AlphaAnim:SetDuration( duration or 0.5)
		--object.Fadein.AlphaAnim:SetSmoothing("IN")
		object.Fadein.maxAlpha = maxAlpha or 1
  		if parent then object.Fadein.AlphaAnim:SetTarget( parent) end
  		--object.Fadein:SetScript("OnFinished", function() 	--	object.Fadein.AlphaAnim:GetTarget():SetAlpha( object.Fadein.maxAlpha) --end)

	elseif type == 'Fadeout' then
		local minAlpha, maxAlpha, duration, finalAlpha, parent = ...
		object.Fadeout = object:CreateAnimationGroup( "Fadeout")
		object.Fadeout:SetToFinalAlpha( finalAlpha)

		object.Fadeout.AlphaAnim = object.Fadeout:CreateAnimation("Alpha")
		object.Fadeout.AlphaAnim:SetFromAlpha( maxAlpha or 1)
		object.Fadeout.AlphaAnim:SetToAlpha( minAlpha or 0)
		object.Fadeout.AlphaAnim:SetDuration( duration or 0.5)
		--object.Fadeout.AlphaAnim:SetSmoothing("OUT")
		object.Fadeout.minAlpha = minAlpha or 0
		if parent then	object.Fadeout.AlphaAnim:SetTarget( parent)	end
		--object.Fadeout:SetScript("OnFinished", function()	--	object.Fadeout.AlphaAnim:GetTarget():SetAlpha( object.Fadeout.minAlpha) --end )
	else
		local x, y, duration, customName = ...
		if not customName then
			customName = 'anim'
		end
		object[customName] = object:CreateAnimationGroup("Move_In")
		object[customName].in1 = object[customName]:CreateAnimation("Translation")
		object[customName].in1:SetDuration(0)
		object[customName].in1:SetOrder(1)
		object[customName].in2 = object[customName]:CreateAnimation("Translation")
		object[customName].in2:SetDuration(duration)
		object[customName].in2:SetOrder(2)
		object[customName].in2:SetSmoothing("OUT")
		object[customName].out1 = object:CreateAnimationGroup("Move_Out")
		object[customName].out2 = object[customName].out1:CreateAnimation("Translation")
		object[customName].out2:SetDuration(duration)
		object[customName].out2:SetOrder(1)
		object[customName].out2:SetSmoothing("IN")
		object[customName].in1:SetOffset( (x), (y))
		object[customName].in2:SetOffset( (-x),(-y))
		object[customName].out2:SetOffset((x), (y))
		object[customName].out1:SetScript("OnFinished", function() object:Hide() end)
	end
end

function TurnOn(frame, texture, toAlpha)
	local alphaValue = texture:GetAlpha();
	frame.Fadein:Stop();
	frame.Fadeout:Stop();
	texture:SetAlpha(alphaValue);
	frame.on = true;
	if (alphaValue < toAlpha) then
		if (texture:IsVisible()) then
			frame.Fadein.AlphaAnim:SetFromAlpha(alphaValue);
			frame.Fadein:Play();
		else
			texture:SetAlpha(toAlpha);
		end
	end
end

function TurnOff(frame, texture, toAlpha)
	--print("...")
	local alphaValue = texture:GetAlpha();
	frame.Fadein:Stop();
	frame.Fadeout:Stop();
	texture:SetAlpha(alphaValue);
	frame.on = false;
	if (alphaValue > toAlpha) then
		if (texture:IsVisible()) then
			frame.Fadeout.AlphaAnim:SetFromAlpha(alphaValue);
			frame.Fadeout:Play();
		else
			texture:SetAlpha(toAlpha);
		end
	end
end
