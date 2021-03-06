--local T, C, L, _ = unpack(select(2, ...))
--if C.skins.dbm ~= true then return end
local L, yo, n = unpack( select( 2, ...))

----------------------------------------------------------------------------------------
--	DBM skin(by Affli)
----------------------------------------------------------------------------------------
local C = {
	["actionbar"]	= {
		["bottombars"] = 1,
	}
}

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:RegisterEvent("ADDON_LOADED")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("DBM-Core") then
		local function SkinBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName().."Bar"]
						local spark = _G[frame:GetName().."BarSpark"]
						local ftexture = _G[frame:GetName().."BarTexture"]
						local icon1 = _G[frame:GetName().."BarIcon1"]
						local icon2 = _G[frame:GetName().."BarIcon2"]
						local name = _G[frame:GetName().."BarName"]
						local timer = _G[frame:GetName().."BarTimer"]

						if icon1.overlay then
							icon1.overlay = _G[icon1.overlay:GetName()]
						else
							icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
							icon1.overlay:SetWidth(22)
							icon1.overlay:SetHeight(22)
							icon1.overlay:SetFrameStrata("BACKGROUND")
							icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -3, -2)
							--icon1.overlay:SetTemplate("Transparent")
							CreateStyle( icon1.overlay, 2) --:SetTemplate("Transparent")
						end

						if icon2.overlay then
							icon2.overlay = _G[icon2.overlay:GetName()]
						else
							icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
							icon2.overlay:SetWidth(22)
							icon2.overlay:SetHeight(22)
							icon2.overlay:SetFrameStrata("BACKGROUND")
							icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 3, -2)
							--icon2.overlay:SetTemplate("Transparent")
							CreateStyle( icon2.overlay, 2)
						end

						--if bar.color then
						--	tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
						--	tbar:SetBackdrop(backdrop)
						--	tbar:SetBackdropColor(bar.color.r, bar.color.g, bar.color.b, 0.15)
						--else
						--	tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
						--	tbar:SetBackdrop(backdrop)
						--	tbar:SetBackdropColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB, 0.15)
						--end

						if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
						if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end

						if not frame.styled then
							frame:SetScale(1)
							frame:SetHeight( 22)
							CreateStyle( frame, 2)--:SetTemplate("Default")
							frame.styled = true
						end

						if not spark.killed then
							spark:SetAlpha(0)
							spark:SetTexture(nil)
							spark.killed = true
						end

						if not icon1.styled then
							icon1:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon1:ClearAllPoints()
							icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
							icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
							icon1.styled = true
						end

						if not icon2.styled then
							icon2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon2:ClearAllPoints()
							icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
							icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
							icon2.styled = true
						end

						if not ftexture.styled then
							ftexture:SetTexture( texture)
							ftexture.styled = true
						end

						if not tbar.styled then
							tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							tbar.styled = true
						end

						if not name.styled then
							name:ClearAllPoints()
							name:SetPoint("LEFT", frame, "LEFT", 4, 0)
							name:SetWidth(165)
							name:SetHeight(8)
							name:SetFont( n.font, n.fontsize, "OUTLINE")
							--name:SetShadowOffset( 1 , -1)
							--name:SetShadowColor(0.5, 0.5, 0.5, 0.9)
							name:SetJustifyH("LEFT")
							name.SetFont = n.dummy
							name.styled = true
						end

						if not timer.styled then
							timer:ClearAllPoints()
							timer:SetPoint("RIGHT", frame, "RIGHT", -1, 0)
							timer:SetFont( n.font, n.fontsize, "OUTLINE")
							--timer:SetShadowOffset( 1, -1)
							--timer:SetShadowColor(0.5, 0.7, 0.7)
							timer:SetJustifyH("RIGHT")
							timer.SetFont = n.dummy
							timer.styled = true
						end

						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						ftexture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
					--bar.ApplyPosition = function()
					--	if C.unitframe.enable ~= true or C.skins.dbm_movable == true then return end
					--	self.mainAnchor:ClearAllPoints()
					--	if C.unitframe.portrait_enable == true then
					--		if bar.owner.options.IconRight then
					--			self.mainAnchor:SetPoint("BOTTOMRIGHT", "oUF_Player", "BOTTOMLEFT", -(138 + C.unitframe.portrait_width), -69)
					--		else
					--			self.mainAnchor:SetPoint("BOTTOMRIGHT", "oUF_Player", "BOTTOMLEFT", -(110 + C.unitframe.portrait_width), -69)
					--		end
					--	else
					--		if bar.owner.options.IconRight then
					--			self.mainAnchor:SetPoint("BOTTOMRIGHT", "oUF_Player", "BOTTOMLEFT", -131, -69)
					--		else
					--			self.mainAnchor:SetPoint("BOTTOMRIGHT", "oUF_Player", "BOTTOMLEFT", -103, -69)
					--		end
					--	end
					--end
					--bar:ApplyPosition()
				end
			end
		end

		if DBM then
			hooksecurefunc(DBT, "CreateBar", SkinBars)

			hooksecurefunc(DBM.RangeCheck, "Show", function()
				if DBMRangeCheck then
					CreateStyle( DBMRangeCheck, 3, 0, 0) 	--:SetTemplate("Transparent")
				end
				if DBMRangeCheckRadar then
					CreateStyle( DBMRangeCheckRadar, 3, 0, 0)	--:SetTemplate("Transparent")
				end
			end)

			hooksecurefunc(DBM.InfoFrame, "Show", function()
				if DBMInfoFrame then
					CreateStyle( DBMInfoFrame, 3, 0, 0)	--:SetTemplate("Transparent")
				end
			end)
		end
		local replace = string.gsub
		local old = RaidNotice_AddMessage
		RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
			if textString:find(" |T") then
				textString = replace(textString, "(:12:12)", ":13:13:0:0:64:64:5:59:5:59")
			end
			return old(noticeFrame, textString, colorInfo)
		end
	end


	if IsAddOnLoaded("DBM-GUI!!!!!!!!!!!!!!!!") then
		tinsert(UISpecialFrames, "DBM_GUI_OptionsFrame")
		--CreateStyle( _G["DBM_GUI_OptionsFrame"], 3)	--:SetTemplate("Transparent")
		--CreateStyle( _G["DBM_GUI_OptionsFramePanelContainer"], 3) 	--:SetTemplate("Overlay")

		_G["DBM_GUI_OptionsFrameTab1"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab1"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameBossMods"], "TOPLEFT", 10, 27)
		_G["DBM_GUI_OptionsFrameTab2"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameTab2"]:SetPoint("TOPLEFT", _G["DBM_GUI_OptionsFrameTab1"], "TOPRIGHT", 6, 0)

		_G["DBM_GUI_OptionsFrameBossMods"]:HookScript("OnShow", function(self)
			CreateStyle( self, 3)	--:SetTemplate("Overlay")
		end)
		_G["DBM_GUI_OptionsFrameDBMOptions"]:HookScript("OnShow", function(self)
			CreateStyle(  self, 3)	--:SetTemplate("Overlay")
		end)
		_G["DBM_GUI_OptionsFrameHeader"]:SetTexture("")
		_G["DBM_GUI_OptionsFrameHeader"]:ClearAllPoints()
		_G["DBM_GUI_OptionsFrameHeader"]:SetPoint("TOP", DBM_GUI_OptionsFrame, 0, 7)

		local dbmbskins = {
			"DBM_GUI_OptionsFrameWebsiteButton",
			"DBM_GUI_OptionsFrameOkay",
			"DBM_GUI_OptionsFrameTab1",
			"DBM_GUI_OptionsFrameTab2"
		}

		for i = 1, getn(dbmbskins) do
			local buttons = _G[dbmbskins[i]]
			if buttons and not buttons.overlay then
				buttons:SkinButton(true)
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	DBM settings(by ALZA and help from Affli)
----------------------------------------------------------------------------------------
function UploadDBM()
	if IsAddOnLoaded("DBM-Core") then
		local T = {
			["color"] = {
				["b"] = 1,
				["g"] = 1,
				["b"] = 1}
		}

		DBM_UseDualProfile = false
		DBM_AllSavedOptions["Default"].Enabled = true
		DBM_AllSavedOptions["Default"].ShowMinimapButton = C.skins.minimap_buttons and true or false
		DBM_AllSavedOptions["Default"].WarningIconLeft = false
		DBM_AllSavedOptions["Default"].WarningIconRight = false
		DBM_AllSavedOptions["Default"].WarningColors = {
			{["b"] = T.color.b, ["g"] = T.color.g, ["r"] = T.color.r,},
			{["b"] = T.color.b, ["g"] = T.color.g, ["r"] = T.color.r,},
			{["b"] = T.color.b, ["g"] = T.color.g, ["r"] = T.color.r,},
			{["b"] = T.color.b, ["g"] = T.color.g, ["r"] = T.color.r,},
		}
		DBM_AllSavedOptions["Default"].RangeFrameX = 244
		DBM_AllSavedOptions["Default"].RangeFramePoint = "LEFT"
		DBM_AllSavedOptions["Default"].ShowSpecialWarnings = true
		DBM_AllSavedOptions["Default"].SpecialWarningFont = C.media.normal_font
		DBM_AllSavedOptions["Default"].SpecialWarningFontSize = 50
		DBM_AllSavedOptions["Default"].SpecialWarningX = 0
		DBM_AllSavedOptions["Default"].SpecialWarningY = 75

		DBT_AllPersistentOptions["Default"]["DBM"].StartColorR = T.color.r
		DBT_AllPersistentOptions["Default"]["DBM"].StartColorG = T.color.g
		DBT_AllPersistentOptions["Default"]["DBM"].StartColorB = T.color.b
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorR = T.color.r
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorG = T.color.g
		DBT_AllPersistentOptions["Default"]["DBM"].EndColorB = T.color.b
		DBT_AllPersistentOptions["Default"]["DBM"].Scale = 1
		DBT_AllPersistentOptions["Default"]["DBM"].HugeScale = 1
		DBT_AllPersistentOptions["Default"]["DBM"].BarXOffset = 0
		DBT_AllPersistentOptions["Default"]["DBM"].BarYOffset = 7
		DBT_AllPersistentOptions["Default"]["DBM"].Font = C.font.stylization_font
		DBT_AllPersistentOptions["Default"]["DBM"].FontSize = C.font.stylization_font_size
		DBT_AllPersistentOptions["Default"]["DBM"].Width = 189
		DBT_AllPersistentOptions["Default"]["DBM"].TimerX = 143
		DBT_AllPersistentOptions["Default"]["DBM"].TimerPoint = "BOTTOMLEFT"
		DBT_AllPersistentOptions["Default"]["DBM"].FillUpBars = true
		DBT_AllPersistentOptions["Default"]["DBM"].IconLeft = true
		DBT_AllPersistentOptions["Default"]["DBM"].ExpandUpwards = true
		DBT_AllPersistentOptions["Default"]["DBM"].Texture = C.media.texture
		DBT_AllPersistentOptions["Default"]["DBM"].IconRight = false
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarXOffset = 0
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarsEnabled = false
		DBT_AllPersistentOptions["Default"]["DBM"].HugeWidth = 189
		DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerX = 7
		DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerPoint = "CENTER"
		DBT_AllPersistentOptions["Default"]["DBM"].HugeBarYOffset = 7

		if C.actionbar.bottombars == 1 then
			DBM_AllSavedOptions["Default"].RangeFrameY = 101
			DBT_AllPersistentOptions["Default"]["DBM"].TimerY = 139
			DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerY = -136
		elseif C.actionbar.bottombars == 2 then
			DBM_AllSavedOptions["Default"].RangeFrameY = 129
			DBT_AllPersistentOptions["Default"]["DBM"].TimerY = 167
			DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerY = -108
		elseif C.actionbar.bottombars == 3 then
			DBM_AllSavedOptions["Default"].RangeFrameY = 157
			DBT_AllPersistentOptions["Default"]["DBM"].TimerY = 195
			DBT_AllPersistentOptions["Default"]["DBM"].HugeTimerY = -80
		end
		DBM_AllSavedOptions["Default"].InstalledBars = C.actionbar.bottombars
	end
end

StaticPopupDialogs.SETTINGS_DBM = {
	text = "L_POPUP_SETTINGS_DBM",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() UploadDBM() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 5,
}

----------------------------------------------------------------------------------------
--	On logon function
----------------------------------------------------------------------------------------
local OnLogon = CreateFrame("Frame")
OnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
OnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if IsAddOnLoaded("DBM-Core") then
		if DBM_AllSavedOptions["Default"].InstalledBars ~= C.actionbar.bottombars then
		--	StaticPopup_Show("SETTINGS_DBM")
		end
	end
end)
