local addonName, ns = ...
local L, yo, n = unpack( ns)

local aGlow = n.LIBS.ButtonGlow

local CreateFrame, Round, pairs, CreateNewBorder, CreateVirtualFrame, hooksecurefunc
	= CreateFrame, Round, pairs, CreateNewBorder, CreateVirtualFrame, hooksecurefunc

local proxyGroup = {
	["---Подземелья Shadowlands"] = true,
}

local proxyBars = {}

local function createAurabar( self, index)
	if proxyBars[index] then return proxyBars[index] end

	local aBar = CreateFrame("Frame", nil, UIParent)
	aBar:SetSize(500, 30)

	local bar = CreateFrame("StatusBar", nil, aBar)
	bar:SetAllPoints( aBar)
	bar:SetMinMaxValues(0, 1)
	bar:SetStatusBarTexture( n.texture)
	bar:SetStatusBarColor(1, 0, 0, 1)

	local barBack = bar:CreateTexture(nil, "BACKGROUND")
	barBack:SetAllPoints( bar)
	barBack:SetTexture( n.texture)
	barBack:SetVertexColor(0.09, 0.09, 0.09, 1)

	local spark = bar:CreateTexture(nil, "OVERLAY")
	spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	spark:SetBlendMode('ADD')
	spark:SetWidth( 20)
	spark:SetHeight( aBar:GetHeight() *2.2)
	spark:SetPoint("CENTER", bar:GetStatusBarTexture(), 'RIGHT', 0, -0)
	--spark:Hide()

	local text = bar:CreateFontString(nil, "OVERLAY", 2)
	text:SetPoint("LEFT", bar, "LEFT", 10, 0)
	text:SetFont( n.font, n.fontsize +6, "OUTLINE")
	text:SetTextColor(0.9, 0.9, 0, 1)

	local count = bar:CreateFontString(nil, "OVERLAY", 2)
	count:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
	count:SetFont( n.font, n.fontsize +6, "OUTLINE")
	count:SetTextColor(0.9, 0.9, 0, 1)

	local icon = bar:CreateTexture(nil, "OVERLAY", 2)
	icon:SetSize( aBar:GetHeight(), aBar:GetHeight())
	icon:SetPoint("RIGHT", bar, "LEFT", -5, 0)
	icon:SetTexCoord( unpack( n.tCoord))

	if index == 1 then
		aBar:SetPoint("CENTER", UIParent, "TOP", 0, -50)
	else
		aBar:SetPoint("TOP", proxyBars[index-1], "BOTTOM", 0, -5)
	end

	aBar.bar 		= bar
	aBar.barBack 	= barBack
	aBar.text 		= text
	aBar.icon 		= icon
	aBar.count		= count
	aBar.spark 		= spark
	--aBar:Show()

	CreateStyle(aBar, 3)
	--CreateStyle(icon, 2)

	proxyBars[index] = aBar

	return proxyBars[index]
end

local WeakAuras = WeakAuras

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
				region.border.glow:SetSize( sizeH * 1.85, sizeW * 1.85)
				region.border.glow:SetVertexColor( 0.1, 0.1, 0.1, 0.9)

				region:EnableMouse(false)
				region.icon:ClearAllPoints()
				region.icon:SetAllPoints(region.border)
			end
		else
			region:SetHeight( region:GetHeight() * 0.8)
			region:SetWidth( region:GetWidth() * 0.8)
			region.SetWidth = n.dummy
			region.SetHeight= n.dummy
			region.SetSize 	= n.dummy

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

	region.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)	--(0.1, 0.9, 0.1, 0.9) --(unpack( n.tCoord))
	region.icon.SetTexCoord = n.dummy

	if region.bar then
		if not region.bar.bordertop then
			CreateVirtualFrame( region, region.bar)
		end

		region.bar.bg:SetTexture( n.texture)
		region.bar.fg:SetTexture( n.texture)
	end
end

local function styleText( regFrame)

	if regFrame.text then
		local t0, t1, t2 = regFrame.text:GetFont()
		if t0 then regFrame.text:SetFont( n.font, t1, t2) end
	end

	if regFrame.text2 then
		local t0, t1, t2 = regFrame.text2:GetFont()
		if t0 then regFrame.text2:SetFont( n.font, t1, t2) end
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

		if regFrame		 	then styleText( regFrame) end
		if regFrame.icon 	then styleIcon( regFrame) end
	end
end

local strAddFormat = "+++#%d#%s#%s#%d#%d#%d"

local function chackRegion( self)
	for k, regions in pairs( WeakAuras.regions) do
		local regFrame = regions.region

		if regFrame 		then styleText( regFrame) end
		if regFrame.icon 	then styleIcon( regFrame) end

		if regions.regionType == "dynamicgroup" then
			regFrame:SetScript("OnSizeChanged", function(self, ...)
				if self.sortedChildren then checkDynamic( self) end
			end)

			--if proxyGroup[k] then
			--	hooksecurefunc( regFrame, "DeactivateChild", function(self, ...)
			--		local sortedChaldren= regFrame.sortedChildren
			--		for i = #sortedChaldren + 1, #proxyBars do proxyBars[i]:Hide() end
			--		--print("HIDE IT", #sortedChaldren)--, chRegion.timer:GetText(), _G.WeakAuras:IsOptionsOpen())
			--	end)

			--	hooksecurefunc( regFrame, "ActivateChild", function(self, ...)
			--		local name, arg = ...
			--		if arg ~= nil then
			--			local sortedChaldren= regFrame.sortedChildren
			--			for index, chRegion in pairs( sortedChaldren) do
			--				local type 		= chRegion.region.regionType
			--				local icon 		= chRegion.region.state.icon
			--				local timer 	= chRegion.region.timer:GetText()
			--				local duration 	= chRegion.region.state.duration
			--				local expiration= chRegion.region.state.expirationTime  - GetTime()

			--				local retString 	= format( strAddFormat, index, type, timer, icon, duration, expiration)

			--				if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			--					C_ChatInfo.SendAddonMessage( addonName, retString, "PARTY")
			--			end
			--				--C_ChatInfo.SendAddonMessage( addonName, retString, "WHISPER", "Дэмьер")
			--			end
			--			--updateBars( regFrame)
			--		end
			--	end)
			--end
		end
	end
end

local function updateBarTimer( regFrame, bar, elapled)

	bar.est = bar.est - elapled
	bar.bar:SetValue( bar.est)
	bar.count:SetText( formatTime( bar.est))

	if bar.est <= 0 then
		bar.est = nil
		bar:SetScript("OnUpdate", nil)
		bar:Hide()
		--C_ChatInfo.SendAddonMessage( addonName, "---", "WHISPER", "Дэмьер")
		--updateBars( regFrame)
	end
end

local function updateStringBars( self, data)
	local add, index, type, timer, icon, duration, expiration = strsplit("#", data)

	if type == "aurabar" then
		local bar 		= createAurabar( self, tonumber(index))
		bar.duration 	= duration
		bar.est 		= expiration

		bar.bar:SetMinMaxValues( 0, duration)
		bar.bar:SetValue( duration)
		bar.icon:SetTexture( icon)
		bar.text:SetText( timer)
		bar:Show()

		bar:SetScript("OnUpdate", function(self, ...) updateBarTimer( regFrame, bar, ...) end)
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
	elseif event == "CHAT_MSG_ADDON" then
		local aName, chatString, unit, sender = ...
		--print( aName, chatString, unit, sender)
		if aName == addonName and chatString:find( "+++") and Ambiguate( sender, "none") ~= n.myName then
			updateStringBars( self, chatString)
		end
	end
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:RegisterEvent("ADDON_LOADED")
--logan:RegisterEvent("CHAT_MSG_ADDON")
logan:SetScript("OnEvent", registermacro)

C_ChatInfo.RegisterAddonMessagePrefix( addonName)


--function updateBars( regFrame)
--	local sortedChaldren= regFrame.sortedChildren

--	for index, chRegion in pairs( sortedChaldren) do

--		local icon 		= chRegion.region.state.icon
--		local timer 	= chRegion.region.timer:GetText()

--		local bar 		= createAurabar( self, index)
--		bar.duration 	= chRegion.region.state.duration
--		bar.expiration 	= chRegion.region.state.expirationTime

--		bar.bar:SetMinMaxValues( 0, bar.duration)
--		bar.bar:SetValue( bar.duration)
--		bar.icon:SetTexture( icon)
--		bar.text:SetText( timer)
--		bar:Show()
--		--print(duration, expirationTime, icon, timer)
--		bar:SetScript("OnUpdate", function(self, ...) updateBarTimer( regFrame, bar, ...) end)

--		--local string = "+++#" .. timer .. "#" .. icon .. "#" .. chRegion.region.state.duration .. "#" .. chRegion.region.state.expirationTime

--		--C_ChatInfo.SendAddonMessage( addonName, string, "WHISPER", "Дэмьер")
--		--print(k,v)
--	end
--	--print("SEE IT ", #sortedChaldren)--, chRegion.timer:GetText(), _G.WeakAuras:IsOptionsOpen())
--end