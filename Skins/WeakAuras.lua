local function CreateVirtualFrame(frame, point, size, alpha, alphaback)
	if point == nil then point = frame end
	if point.backdrop then return end

	size = ( size or 3)
	alpha = ( alpha or 1)
	alphaback = ( alphaback or 0)

	frame.back = frame:CreateTexture(nil, "BORDER")
	frame.back:SetDrawLayer("BORDER", -8)
	frame.back:SetPoint("TOPLEFT", point, "TOPLEFT", -3, 3)
	frame.back:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", 3, -3)
	frame.back:SetColorTexture( 0.15, 0.15, 0.15, alphaback) 

	frame.bordertop = frame:CreateTexture(nil, "BORDER")
	frame.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -size, size)
	frame.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, size)
	frame.bordertop:SetHeight( size)
	frame.bordertop:SetColorTexture( 0, 0, 0, alpha)
	frame.bordertop:SetDrawLayer("BORDER", -7)

	frame.borderbottom = frame:CreateTexture(nil, "BORDER")
	frame.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -size, -size)
	frame.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", size, -size)
	frame.borderbottom:SetHeight( size)
	frame.borderbottom:SetColorTexture( 0, 0, 0, alpha)
	frame.borderbottom:SetDrawLayer("BORDER", -7)

	frame.borderleft = frame:CreateTexture(nil, "BORDER")
	frame.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -size, 0)
	frame.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", size, 0)
	frame.borderleft:SetWidth( size)
	frame.borderleft:SetColorTexture( 0, 0, 0, alpha)
	frame.borderleft:SetDrawLayer("BORDER", -7)

	frame.borderright = frame:CreateTexture(nil, "BORDER")
	frame.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, 0)
	frame.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -size, 0)
	frame.borderright:SetWidth( size)
	frame.borderright:SetColorTexture( 0, 0, 0, alpha)
	frame.borderright:SetDrawLayer("BORDER", -7)
end

local function SetVirtualBorder(frame, r, g, b)
	frame.bordertop:SetColorTexture(r, g, b)
	frame.borderbottom:SetColorTexture(r, g, b)
	frame.borderleft:SetColorTexture(r, g, b)
	frame.borderright:SetColorTexture(r, g, b)
end

local function styleIcon( region)
	
	if not region.border then
		if region.bar then
			local a1, p, a2, x, y = region.icon:GetPoint()
			if a1 then
				local sizeH = region.icon:GetHeight() 
				local sizeW = region.icon:GetWidth()

				region.border = CreateFrame( "Button", nil, region)
				region.border:SetPoint( ( a1 or "TOPLEFT"), ( p or region), ( a2 or "TOPLEFT"), ( x or 0), ( y or 0))
				region.border:SetWidth(  sizeW)
				region.border:SetHeight( sizeH)

				region.border.glow = region.border:CreateTexture(nil, "BORDER")
				region.border.glow:SetPoint( "CENTER", region.border, "CENTER", 0, 0)
				region.border.glow:SetTexture( "Interface\\Buttons\\UI-Quickslot2")
				region.border.glow:SetSize( sizeH * 1.85, sizeW * 1.85)
				region.border.glow:SetVertexColor( 0.1, 0.1, 0.1, 0.9)

				region:EnableMouse(false)
				region.icon:ClearAllPoints()
				region.icon:SetAllPoints(region.border)
			end	
		else
			region:SetHeight( region:GetHeight() * 0.83)
			region:SetWidth( region:GetWidth() * 0.83)

			CreateBorder( region)

			region:EnableMouse(false)
			region.icon:ClearAllPoints()
			region.icon:SetAllPoints(region)
		end

		region.SetGlow = function( region, showGlow)
			if not region.border then return end

			if (showGlow) then
      			if (not region.__WAGlowFrame) then
        			region.__WAGlowFrame = CreateFrame("Frame", nil, region);
        			--region.__WAGlowFrame:SetAllPoints();
					region.__WAGlowFrame:SetPoint( "CENTER")
        			region.__WAGlowFrame:SetSize(region.width + 2, region.height + 2);
      			end
      			region.border.glow:SetVertexColor( 1, 1, 0.5, 0.5)
      			WeakAuras.ShowOverlayGlow(region.__WAGlowFrame);      			
    		else
      			if (region.__WAGlowFrame) then
      				WeakAuras.HideOverlayGlow(region.__WAGlowFrame);
      				region.border.glow:SetVertexColor( 0.1, 0.1, 0.1, 0.9)
      			end
    		end
    	end
	end

	
	region.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)	--(0.1, 0.9, 0.1, 0.9) --(0.07, 0.93, 0.07, 0.93)
	region.icon.SetTexCoord = dummy

	if region.bar then

		if not region.bar.bordertop then
			CreateVirtualFrame( region, region.bar)
		end

		if region.border then
			--region.bar:ClearAllPoints()
			--region.bar.ClearAllPoints = dummy
			--region.bar:SetPoint("TOPLEFT", region.border, "TOPRIGHT", 8, 0)
			--region.bar:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 0, 0)
		end

		region.bar.bg:SetTexture( texture)
		region.bar.fg:SetTexture( texture)
	end
end


local function checkDynamic( self)
	for k, children in pairs( self.controlledRegions) do
		local chiFrame = children.region
					
		if chiFrame.icon then
			chiFrame:SetScript("OnShow", function(self, ...)
				--print("Dynamic show: ", k)
				styleIcon( self)
			end)
			--chiFrame:SetScript("OnSizeChanged", function(self, ...)
			--	print("Dynamic hide: ", k)
			--	styleIcon( self)
			--end)
		end
	end
end

local function registermacro( self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if WeakAuras then
		for k, regions in pairs( WeakAuras.regions) do
			
			local regFrame = regions.region

			if regFrame.text then
				local t0, t1, t2 = regFrame.text:GetFont()
				if t0 then
					regFrame.text:SetFont( font, t1, t2)
				end
			end

			if regFrame.text2 then
				local t0, t1, t2 = regFrame.text2:GetFont()
				if t0 then
					regFrame.text2:SetFont( font, t1, t2)
				end
			end

			if regFrame.timer then
				local t0, t1, t2 = regFrame.timer:GetFont()
				if t0 then
					regFrame.timer:SetFont( font, t1, t2)
				end
			end

			if regFrame.stacks then
				local t0, t1, t2 = regFrame.stacks:GetFont()
				if t0 then
					regFrame.stacks:SetFont( font, t1, t2)
				end
			end
			
			if regFrame.icon then
				--regFrame:HookScript("On", function( self, ...)  -- PositionChildren DoControlChildren ResetPosition
				--	print("set SetPoint: ", k)
				--end)

				--hooksecurefunc( regFrame, "Show", function( self, ...) 
				--	print("set SetPoint: ", k)
				--end)

				--regFrame:SetScript("OnShow", function(self, ...)
				--	print("Static show: ", k)
				--	styleIcon( self)
				--end)
				styleIcon( regFrame)
			end

			if regions.regionType == "dynamicgroup" then
				regFrame:SetScript("OnSizeChanged", function(self, ...)
					checkDynamic( self)
				end)

				regFrame:SetScript("OnShow", function(self, ...)
					--print("Show: ", self, regFrame)
					checkDynamic( self)
				end)
			end
		end
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", registermacro)
