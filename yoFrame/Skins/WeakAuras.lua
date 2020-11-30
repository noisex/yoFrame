local L, yo = unpack( select( 2, ...))

local aGlow = LibStub("LibCustomGlow-1.0", true)
--local dynamicRegions = {}

local function styleIcon( region)

	if not region.border then

		if region.bar then
			local a1, p, a2, x, y = region.icon:GetPoint()
			if a1 then
				local sizeH = region.icon:GetHeight()
				local sizeW = region.icon:GetWidth()

				region.border = region.border or CreateFrame( "Button", nil, region)
				region.border:ClearAllPoints()
				region.border:SetPoint( ( a1 or "TOPLEFT"), ( p or region), ( a2 or "TOPLEFT"), ( x or 0), ( y or 0))
				region.border:SetWidth(  sizeW)
				region.border:SetHeight( sizeH)

				region.border.glow = region.border.glow or region.border:CreateTexture(nil, "BORDER")
				region.border.glow:ClearAllPoints()
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
			region:SetHeight( region:GetHeight() * 0.8)
			region:SetWidth( region:GetWidth() * 0.8)
			region.SetWidth = dummy
			region.SetHeight = dummy
			region.SetSize = dummy

			CreateNewBorder( region)

			region:EnableMouse(false)
			region.icon:ClearAllPoints()
			region.icon:SetAllPoints(region)
		end

		region.SetGlow = function( region, showGlow)
			if not region.border then return end

			if (showGlow) then
				local height 	= region:GetHeight() / 12
				local leight 	= region:GetHeight() / 5
				local count 	= Round( region:GetHeight() / 6)
				aGlow.PixelGlow_Start( region, {0.95, 0.95, 0.32, 1}, count, 0.25, leight, height, 2, 2, false, 1 )
				--aGlow.AutoCastGlow_Start( region, {0.95, 0.95, 0.32, 1}, 20, 0.1, 1.3, 3, 3, 1)
				--aGlow.ButtonGlow_Start( region, {0.95, 0.95, 0.32, 1}, 20, 0.2, 4, 2, 0, 0, false, 1, 3)
    		else
    			aGlow.PixelGlow_Stop( region, 1)
    			--aGlow.AutoCastGlow_Stop( region, 1)
    			--aGlow.ButtonGlow_Stop( region)
    		end
    	end
	end

	region.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)	--(0.1, 0.9, 0.1, 0.9) --(unpack( yo.tCoord))
	--region.icon.SetTexCoord = dummy

	if region.bar then
		if not region.bar.bordertop then
			CreateVirtualFrame( region, region.bar)
		end

		region.bar.bg:SetTexture( texture)
		region.bar.fg:SetTexture( texture)
	end
end

local function styleText( regFrame)

	if regFrame.text then
		local t0, t1, t2 = regFrame.text:GetFont()
		if t0 then regFrame.text:SetFont( font, t1, t2) end
	end

	if regFrame.text2 then
		local t0, t1, t2 = regFrame.text2:GetFont()
		if t0 then regFrame.text2:SetFont( font, t1, t2) end
	end

	if regFrame.timer then
		local t0, t1, t2 = regFrame.timer:GetFont()
		if t0 then regFrame.timer:SetFont( yo.Media.fontpx, t1, t2) end
	end

	if regFrame.stacks then
		local t0, t1, t2 = regFrame.stacks:GetFont()
		if t0 then regFrame.stacks:SetFont( yo.Media.fontpx, t1, t2) end
	end
end


local function checkDynamic( self)
	for k, children in pairs( self.sortedChildren) do
		local regFrame = children.region

		--if not dynamicRegions[regFrame] then
		if regFrame		 	then styleText( regFrame) end
		if regFrame.icon 	then styleIcon( regFrame) end
			--dynamicRegions[regFrame] = false

			--tprint( dynamicRegions)
			--print("---------------")
		--end
	end
end

local function chackRegion( self)
	for k, regions in pairs( WeakAuras.regions) do
		local regFrame = regions.region

		if regFrame 		then styleText( regFrame) end
		if regFrame.icon 	then styleIcon( regFrame) end

		if regions.regionType == "dynamicgroup" then
			regFrame:SetScript("OnSizeChanged", function(self, ...)
				--print("Size: ", self, regFrame, self.sortedChildren)
				if self.sortedChildren then checkDynamic( self) end
			end)

			--regFrame:SetScript("OnShow", function(self, ...)
				--print("Show: ", self, regFrame, self.sortedChildren)
				--if self.sortedChildren then checkDynamic( self) end
			--end)
		end
	end
end

local function registermacro( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if WeakAuras then
			chackRegion( self)
		end

	elseif event =="ADDON_LOADED" then
		if ... == "WeakAurasOptions" then
			hooksecurefunc( WeakAuras, "HideOptions", function(self, ...) 	chackRegion( self) 	end)
		end
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:RegisterEvent("ADDON_LOADED")
logan:SetScript("OnEvent", registermacro)
