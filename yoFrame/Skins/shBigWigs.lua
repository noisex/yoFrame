local L, yo, n = unpack( select( 2, ...))

----------------------------------------------------------------------------------------
--	BigWigs skin(by Affli)
----------------------------------------------------------------------------------------
-- Init some tables to store backgrounds
local freebg = {i}
local registred

-- Styling functions
local createbg = function()
	local bg = CreateFrame("Frame")
	if not bg.shadow then
		CreateStyle( bg, 4)
	end

	return bg
end

local function freestyle(bar)
	--print("we free!!!")
	-- Reparent and hide bar background
	local bg = bar:Get("bigwigs:yoframe:bg")

	if bg then
		bg:ClearAllPoints()
		bg:SetParent(UIParent)
		bg:Hide()
		freebg[#freebg + 1] = bg
	end

	---- Reparent and hide icon background
	local ibg = bar:Get("bigwigs:yoframe:ibg")
	if ibg then
		ibg:ClearAllPoints()
		ibg:SetParent(UIParent)
		ibg:Hide()
		freebg[#freebg + 1] = ibg
	end
end

local applystyle = function(bar)
	-- General bar settings

	--print("apply style")
	bar:SetHeight(20)
	bar:SetScale(1)
	--bar.OldSetScale = bar.SetScale
	--bar.SetScale = n.dummy

	-- Create or reparent and use bar background
	local bg = nil
	if #freebg > 0 then
		bg = table.remove(freebg)
	else
		bg = createbg()
	end
	bg:SetParent(bar)
	bg:ClearAllPoints()
	--bg:SetAllPoints(bar)
	bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -0, 0)
	bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -0)
	bg:SetFrameStrata("BACKGROUND")
	bg:Show()
	bar:Set("bigwigs:yoframe:bg", bg)

	-- Create or reparent and use icon background
	local ibg = nil
	if bar.candyBarIconFrame:GetTexture() then
		if #freebg > 0 then
			ibg = table.remove(freebg)
		else
			ibg = createbg()
		end
		ibg:SetParent(bar)
		ibg:ClearAllPoints()
		ibg:SetAllPoints(bar.candyBarIconFrame)
		--ibg:SetPoint("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -2, 2)
		--ibg:SetPoint("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 2, -2)
		ibg:SetFrameStrata("BACKGROUND")
		ibg:Show()
		bar:Set("bigwigs:yoframe:ibg", ibg)
	end

	 --Setup timer and bar name fonts and positions
	bar.candyBarLabel:SetFont( n.font, n.fontsize +1, "THINOUTLINE")
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)

	bar.candyBarDuration:SetFont( n.font, n.fontsize +2, "THINOUTLINE")
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", 1, 0)
	bar.candyBarDuration:SetTextColor(1, 1, 0, 1)

	 --Setup bar positions and look
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = n.dummy
	bar.candyBarBar:SetStatusBarTexture( n.texture)
	if not bar.data["bigwigs:emphasized"] == true then
		--bar.candyBarBar:SetStatusBarColor( 1, 1, 1, 1)
	end
	bar.candyBarBackground:ClearAllPoints()
	bar.candyBarBackground:SetAllPoints(bar)
	bar.candyBarBackground:SetTexture( n.texture)

	 --Setup icon positions and other things
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("RIGHT", bar, "LEFT", -6, 0)
	bar.candyBarIconFrame:SetSize( bar:GetHeight(), bar:GetHeight())
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = n.dummy
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

local function registerBWStyle(...)

	BigWigsAPI:RegisterBarStyle("yoFrame", {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 5 end,
		ApplyStyle = applystyle, --function(bar) end,
		BarStopped = freestyle, --function(bar) end,
		GetStyleName = function() return "yoFrame" end,
	})
	registred = true
end

local f = CreateFrame("Frame")
--f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)

	if event == "ADDON_LOADED" then

	elseif event == "PLAYER_ENTERING_WORLD" then

		if BigWigsAPI and not registred then registerBWStyle() end

		--LoadAddOn("BigWigs_Plugins")
		--LoadAddOn("BigWigs_Options")
		if not BigWigs3DB then return end
		if not BigWigs3DB.namespaces then return end

		local settingBar = BigWigs3DB.namespaces.BigWigs_Plugins_Bars.profiles.Default
		if settingBar then
			settingBar.barStyle = "yoFrame"
			settingBar.fontName = "yoMagistral"
			settingBar.texture = n.texture
			settingBar.emphasizeGrowup = true
		end

		local settingMess = BigWigs3DB.namespaces.BigWigs_Plugins_Messages.profiles.Default
		if settingMess then
			settingMess.fontName = "yoMagistral"
			settingMess.fontSize = 22
		end

		local settingProx = BigWigs3DB.namespaces.BigWigs_Plugins_Proximity.profiles.Default
		if settingProx then
			settingProx.fontName = "yoMagistral"
			--settingProx.fontSize = 40
		end

		--print( BigWigs3DB.namespaces.BigWigs_Plugins_Messages.profiles.Default.fontName) -- yoFram
		--f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)

if BigWigsAPI and not registred then registerBWStyle() end

--[[
local function registerStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars", true)

	if bars then
		bars:RegisterBarStyle("yoFrame", {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return 5 end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return "yoFrame" end,
		})
		bars.defaultDB.font = font
		bars.defaultDB.fontName = "yoMagistral"
		bars.defaultDB.barStyle = "yoFrame"
		bars:SetBarStyle("yoFrame", "yoFrame")
	end

	local mess = BigWigs:GetPlugin("Messages")
	if mess then
		mess.defaultDB.font = font
		mess.defaultDB.fontName = "yoMagistral"
		mess.defaultDB.fontSize = 22
	end
	local prox = BigWigs:GetPlugin("Super Emphasize")
	if prox then
		prox.defaultDB.font = font
		prox.defaultDB.fontName = "yoMagistral"
		prox.defaultDB.fontSize = 40
	end

	bars.defaultDB.barStyle = "yoFrame"
	if BigWigsLoader and bars.defaultDB.barStyle == "yoFrame" then
		BigWigsLoader.RegisterMessage("BigWigs_Plugins", "BigWigs_FrameCreated", function()
			--BigWigsProximityAnchor:SetTemplate("Transparent")
		end)
	end
end

]]