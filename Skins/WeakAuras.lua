local L, yo = unpack( select( 2, ...))

local aGlow = LibStub("LibCustomGlow-1.0", true)

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
				--region.border.glow:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\boder6px.blp")
				region.border.glow:SetSize( sizeH * 1.85, sizeW * 1.85)
				region.border.glow:SetVertexColor( 0.1, 0.1, 0.1, 0.9)

				region:EnableMouse(false)
				region.icon:ClearAllPoints()
				region.icon:SetAllPoints(region.border)
			end
		else
			region:SetHeight( region:GetHeight() * 0.83)
			region:SetWidth( region:GetWidth() * 0.83)

			CreateNewBorder( region)

			region:EnableMouse(false)
			region.icon:ClearAllPoints()
			region.icon:SetAllPoints(region)
		end

		region.SetGlow = function( region, showGlow)
			if not region.border then return end

			if (showGlow) then
				--aGlow.PixelGlow_Start( region, {0.95, 0.95, 0.32, 1}, 8, 0.25, 20, 2, 3, 3, false, 1 )
				aGlow.AutoCastGlow_Start( region, {0.95, 0.95, 0.32, 1}, 20, 0.1, 1.3, 3, 3, 1)
				--aGlow.ButtonGlow_Start( region, {0.95, 0.95, 0.32, 1}, 0.25)


  --    			if (not region.__WAGlowFrame) then
  --      			region.__WAGlowFrame = CreateFrame("Frame", nil, region);
  --      			--region.__WAGlowFrame:SetAllPoints();
		--			region.__WAGlowFrame:SetPoint( "CENTER")
  --      			region.__WAGlowFrame:SetSize(region.width + 2, region.height + 2);
  --    			end
      			--region.border.glow:SetVertexColor( 0.95, 0.95, 0.32, 1)
  --    			WeakAuras.ShowOverlayGlow(region.__WAGlowFrame);
    		else
    			--aGlow.PixelGlow_Stop( region, 1)
    			aGlow.AutoCastGlow_Stop( region, 1)
    			--aGlow.ButtonGlow_Stop( region)

  --    			if (region.__WAGlowFrame) then
  --    				WeakAuras.HideOverlayGlow(region.__WAGlowFrame);
      			--	region.border.glow:SetVertexColor( 0.1, 0.1, 0.1, 0.9)
  --    			end
    		end
    	end
	end


	region.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)	--(0.1, 0.9, 0.1, 0.9) --(unpack( yo.tCoord))
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
					if self.controlledRegions then
						checkDynamic( self)
					end
				end)

				regFrame:SetScript("OnShow", function(self, ...)
					--print("Show: ", self, regFrame)
					if self.controlledRegions then
						checkDynamic( self)
					end
				end)
			end
		end
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", registermacro)
