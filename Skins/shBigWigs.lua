
----------------------------------------------------------------------------------------
--	BigWigs skin(by Affli)
----------------------------------------------------------------------------------------
-- Init some tables to store backgrounds
local freebg = {}

-- Styling functions
local createbg = function()
	local bg = CreateFrame("Frame")
	if not bg.shadow then
		CreateStyle( bg, 3)
		--bg:SetTemplate("Default")
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

	-- Replace dummies with original method functions
	bar.candyBarBar.SetPoint = bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame.SetWidth = bar.candyBarIconFrame.OldSetWidth
	bar.SetScale = bar.OldSetScale

	---- Reset Positions
	---- Icon
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	---- Status Bar
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	---- BG
	bar.candyBarBackground:SetAllPoints()

	---- Duration
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

	---- Name
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
end

local applystyle = function(bar)
	-- General bar settings

	--print("apply style")
	bar:SetHeight(20)
	bar:SetScale(1)
	bar.OldSetScale = bar.SetScale
	bar.SetScale = dummy

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

	-- Setup timer and bar name fonts and positions
	bar.candyBarLabel:SetFont( font, fontsize +1, "THINOUTLINE")
	--bar.candyBarLabel:SetShadowOffset(C.font.stylization_font_shadow and 1 or 0, C.font.stylization_font_shadow and -1 or 0)
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)

	bar.candyBarDuration:SetFont( font, fontsize +1, "THINOUTLINE")
	--bar.candyBarDuration:SetShadowOffset(C.font.stylization_font_shadow and 1 or 0, C.font.stylization_font_shadow and -1 or 0)
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", 1, 0)

	-- Setup bar positions and look
	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = dummy
	bar.candyBarBar:SetStatusBarTexture( texture)
	if not bar.data["bigwigs:emphasized"] == true then
		--bar.candyBarBar:SetStatusBarColor( 1, 1, 1, 1)
	end
	bar.candyBarBackground:ClearAllPoints()
	bar.candyBarBackground:SetAllPoints(bar)
	bar.candyBarBackground:SetTexture( texture)

	-- Setup icon positions and other things
	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("RIGHT", bar, "LEFT", -6, 0)
	bar.candyBarIconFrame:SetSize( bar:GetHeight(), bar:GetHeight())
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = dummy
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

local function registerStyle()
	if not BigWigs then return end
	local bars = BigWigs:GetPlugin("Bars", true)
	--local prox = BigWigs:GetPlugin("Proximity", true)
	if bars then
		bars:RegisterBarStyle("yoFrame", {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return 5 end,
			ApplyStyle = applystyle,
			BarStopped = freestyle,
			GetStyleName = function() return "yoFrame" end,
		})
		bars.defaultDB.barStyle = "yoFrame"
		bars:SetBarStyle("yoFrame", "yoFrame")
	end
	
	bars.defaultDB.barStyle = "yoFrame"
	if BigWigsLoader and bars.defaultDB.barStyle == "yoFrame" then
		BigWigsLoader.RegisterMessage("BigWigs_Plugins", "BigWigs_FrameCreated", function()
			--BigWigsProximityAnchor:SetTemplate("Transparent")
		end)
	end	
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "BigWigs_Plugins" then
			if not BigWigs3DB.namespaces.BigWigs_Plugins_Bars or BigWigs3DB.namespaces.BigWigs_Plugins_Bars.profiles.Default.InstalledBars ~= bottombars then
				StaticPopup_Show("BW_TEST")
			end
			registerStyle()
			f:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if not BigWigs then return end
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")

		local bars = BigWigs:GetPlugin("Bars", true)
		if bars then
			--bars.defaultDB.barStyle = "yoFrame"
			bars:SetBarStyle("yoFrame", "yoFrame")
			--bars.db.profile.barStyle = "yoFrame"
			bars.db.profile.font = font
		end
		local mess = BigWigs:GetPlugin("Messages")
		if mess then
			--print("we mess")
			mess.db.profile.font = font
			mess.db.profile.fontSize = 20
		end		
		local prox = BigWigs:GetPlugin("Super Emphasize")
		if prox then
			--print("we prox")
			prox.db.profile.font = font
			prox.db.profile.fontSize = 40
--			prox.db.profile.objects.ability = false
		end
	end
end)





--StaticPopupDialogs.BW_TEST = {
--	text = "L_POPUP_SETTINGS_BW",
--	button1 = ACCEPT,
--	button2 = CANCEL,
--	OnAccept = function()
--		local bars = BigWigs and BigWigs:GetPlugin("Bars")
--		if bars then
--			bars.db.profile.barStyle = "yoFrame"
--			bars.db.profile.font = font
--			bars.db.profile.BigWigsAnchor_width = 185
--			bars.db.profile.BigWigsAnchor_x = 38
--			bars.db.profile.BigWigsEmphasizeAnchor_width = 185
--			bars.db.profile.BigWigsEmphasizeAnchor_x = 420
--			bars.db.profile.BigWigsEmphasizeAnchor_y = 248
--			bars.db.profile.emphasizeGrowup = true
--			--bars.db.profile.InstalledBars = C.actionbar.bottombars
--			--if C.actionbar.bottombars == 1 then
--			--	bars.db.profile.BigWigsAnchor_y = 116
--			--elseif C.actionbar.bottombars == 2 then
--			--	bars.db.profile.BigWigsAnchor_y = 138
--			--elseif C.actionbar.bottombars == 3 then
--			--	bars.db.profile.BigWigsAnchor_y = 159
--			--end
--		end
--		local mess = BigWigs and BigWigs:GetPlugin("Messages")
--		if mess then
--			mess.db.profile.font = "Calibri"
--			mess.db.profile.fontSize = 20
--			mess.db.profile.BWMessageAnchor_x = 415
--			mess.db.profile.BWMessageAnchor_y = 320
--			mess.db.profile.BWEmphasizeMessageAnchor_x = 415
--			mess.db.profile.BWEmphasizeMessageAnchor_y = 335
--			mess.db.profile.BWEmphasizeCountdownMessageAnchor_x = 465
--			mess.db.profile.BWEmphasizeCountdownMessageAnchor_y = 370
--		end
--		local prox = BigWigs and BigWigs:GetPlugin("Proximity")
--		if prox then
--			prox.db.profile.font = "Calibri"
--			prox.db.profile.objects.ability = false
--		end
--		--BigWigs3IconDB.hide = true
--		BigWigs:GetPlugin("Super Emphasize").db.profile.font = "Calibri"
--		BigWigs:GetPlugin("Alt Power").db.profile.font = "Calibri"
--		if InCombatLockdown() then
--			print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r")
--			print("|cffffff00Reload your UI to apply skin.|r")
--		else
--			ReloadUI()
--		end
--	end,
--	timeout = 0,
--	whileDead = 1,
--	hideOnEscape = true,
--	preferredIndex = 5,
--}

SlashCmdList.BWTEST = function(msg)
	if msg == "apply" then
		SlashCmdList["BigWigs"]()
		HideUIPanel(InterfaceOptionsFrame)
		StaticPopup_Show("BW_TEST")
	elseif msg == "test" then
		SlashCmdList["BigWigs"]()
		BigWigs:GetPlugin("Proximity").Test(BigWigs:GetPlugin("Proximity"))
		HideUIPanel(InterfaceOptionsFrame)
		BigWigs:Test()
		BigWigs:Test()
		BigWigs:Test()
		BigWigs:Test()
		BigWigs:Test()
		BigWigs:Test()
	else
		print("|cffffff00Type /bwtest apply to apply BigWigs settings.|r")
		print("|cffffff00Type /bwtest test to launch BigWigs testmode.|r")
	end
end
SLASH_BWTEST1 = "/bwtest"
SLASH_BWTEST2 = "/ицеуые"