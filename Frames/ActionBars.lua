local L, yo = unpack( select( 2, ...))

local A, L = ...

--TotemBar
--function rActionBar:CreateTotemBar(addonName,cfg)
--	cfg.blizzardBar = TotemFrame
--	cfg.frameName = addonName.."TotemBar"
--	cfg.frameParent = cfg.frameParent or UIParent
--	cfg.frameTemplate = "SecureHandlerStateTemplate"
--	cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
--	local buttonName = "TotemFrameTotem"
--	local numButtons = MAX_TOTEMS
--	local buttonList = L:GetButtonList(buttonName, numButtons)
--	local frame = L:CreateButtonFrame(cfg,buttonList)
--end

function ActionButtonDesign( frame, button, buttonWidth, buttonHeight )

	local name = button:GetName()	

		if 		name:match("MultiCast") then return 
		elseif 	name:match("VehicleExitBar") then return

--------------------------------------------------------------------------------------------
--		MicroMenu
--------------------------------------------------------------------------------------------
		elseif 	name:match("MicroButton") then 
			local m = button
			local pushed = m:GetPushedTexture()
			local normal = m:GetNormalTexture()
			local disabled = m:GetDisabledTexture()

			m:SetParent(frame)
			m.SetParent = dummy
			_G[name.."Flash"]:SetTexture("")
			m:SetHighlightTexture("")
			m.SetHighlightTexture = dummy

			local f = CreateFrame("Frame", nil, m)
			f:SetFrameLevel(1)
			f:SetFrameStrata("BACKGROUND")
			f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 0)
			f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -6)
			CreateStyle( f, 2)
			m.frame = f

			pushed:SetTexCoord(0.22, 0.81, 0.26, 0.82)
			pushed:ClearAllPoints()
			pushed:SetPoint("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
			pushed:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)

			normal:SetTexCoord(0.22, 0.81, 0.26, 0.82)
			normal:ClearAllPoints()
			normal:SetPoint("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
			normal:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)

			if disabled then
				disabled:SetTexCoord(0.22, 0.81, 0.26, 0.82)
				disabled:ClearAllPoints()
				disabled:SetPoint("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
				disabled:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
			end

			m.mouseover = false
			m:HookScript("OnEnter", function(self)
				self.frame.shadow:SetBackdropBorderColor( 1, 0, 0)
				self.mouseover = true
			end)
			m:HookScript("OnLeave", function(self)
				self.frame.shadow:SetBackdropBorderColor( 0, 0, 0)
				self.mouseover = false
			end)

--------------------------------------------------------------------------------------------
--		Extra Button
--------------------------------------------------------------------------------------------
		elseif 	name:match("ExtraActionButton") then 
			
			button:SetScale( 0.75)
			button:SetNormalTexture("")

			local oldicon = _G[name.."Icon"]
			oldicon:Hide()
			
			local panel = CreateFrame("Frame", name.."Panel", button)
			CreatePanel(panel, buttonWidth +10, buttonWidth +10, "CENTER", button, "CENTER", 0, 0)
			--panel:SetFrameStrata(button:GetFrameStrata())
			--panel:SetFrameLevel(button:GetFrameLevel() - 1)
			
			panel.icon = panel:CreateTexture(nil, "BORDER")
			panel.icon:SetTexCoord(.08, .92, .08, .92)
			panel.icon:SetAllPoints( panel)
			panel.icon:SetPoint("TOPLEFT", panel, 2, -2)
			panel.icon:SetPoint("BOTTOMRIGHT", panel, -2, 2)
			panel.icon:SetTexture( oldicon:GetTexture())
			
			CreateStyle(panel, 2)
			button:HookScript('OnShow',  function(self, ...)
				local name = self:GetName()	
				local oldicon = _G[name.."Icon"]
				oldicon:Hide()
				
				local panel = _G[name.."Panel"]
				panel.icon:SetTexture( oldicon:GetTexture())
			end)

--------------------------------------------------------------------------------------------
--		Pet Menu
--------------------------------------------------------------------------------------------			
		elseif name:match("PetAction") then 
			
			local Flash	 	= _G[name.."Flash"]
			local icon	 	= _G[name.."Icon"]
			local normal  	= _G[name.."NormalTexture2"]
			local Border  	= _G[name.."Border"]

			Flash:SetTexture("")
	
			if not _G[name.."Panel"] then
				button:SetWidth(buttonWidth)
				button:SetHeight(buttonWidth)
		
				local panel = CreateFrame("Frame", name.."Panel", button)
				CreatePanel(panel, buttonWidth, buttonWidth, "CENTER", button, "CENTER", 0, 0)
				panel:SetFrameStrata(button:GetFrameStrata())
				panel:SetFrameLevel(button:GetFrameLevel() - 1)
				CreateStyle(panel, 2)
				
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				if false then			
					if buttonWidth < 30 then
						local autocast = _G[name.."AutoCastable"]
						autocast:SetAlpha(0)
					end
					local shine = _G[name.."Shine"]
					shine:SetSize(buttonWidth, buttonWidth)
					shine:ClearAllPoints()
					shine:SetPoint("CENTER", button, 0, 0)
					icon:SetPoint("TOPLEFT", button, 2, -2)
					icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
				else
					icon:SetPoint("TOPLEFT", button, 2, -2)
					icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
				end
			end
	
			-- if Border then
				-- Border:Hide()
				-- Border = dummy
			-- end
			
			--button:SetNormalTexture( nil)
			button:SetNormalTexture( "")
			button:GetNormalTexture():SetSize( 1,1)
			
			
			--button:SetNormalTexture():ClearAllPoints()
			--button.SetNormalTexture = dummy
			
			-- if normal then
				-- normal:ClearAllPoints()
				-- normal:SetPoint("TOPLEFT")
				-- normal:SetPoint("BOTTOMRIGHT")
			-- end

--------------------------------------------------------------------------------------------
--		Totem Menu
--------------------------------------------------------------------------------------------			
		elseif name:match("TotemFrame") then 
			local Back = _G[name..'Background']
			local Icon = _G[name.."Icon"]
			local IconCD = _G[name.."IconCooldown"]
			local IconTXT = _G[name.."IconTexture"]
			local Dura = _G[name.."Duration"]
		
			f1, f2 = button:GetChildren()
			f2:Hide()
			
			Icon:SetSize( buttonWidth, buttonWidth)
			IconTXT:SetSize( buttonWidth, buttonWidth)
			IconTXT:SetTexCoord(.08, .92, .08, .92)
			IconTXT:SetPoint("TOPLEFT", button, 2, -2)
			IconTXT:SetPoint("BOTTOMRIGHT", button, -2, 2)
			Back:Hide()
			--Dura:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, 5)
			Dura:SetFont( fontpx, fontsize +1, "OUTLINE")
			CreateStyle( button, 2)

--------------------------------------------------------------------------------------------
--		Actions Bars
--------------------------------------------------------------------------------------------
		else
			local action = button.action
			local Button = button
			local Icon = _G[name.."Icon"]
			local Count = _G[name.."Count"]
			local Flash	 = _G[name.."Flash"]
			local HotKey = _G[name.."HotKey"]
			local Border  = _G[name.."Border"]
			local Btname = _G[name.."Name"]
			local normal  = _G[name.."NormalTexture"]
			local BtnBG = _G[name..'FloatingBG']

			if button.SetHighlightTexture and not button.hover then
				local hover = button:CreateTexture("frame", nil, self)
				hover:SetTexture( texture)
				hover:SetVertexColor( 0, 1, 0, 1)
				hover:SetPoint("TOPLEFT", 2, -2)
				hover:SetPoint("BOTTOMRIGHT", -2, 2)
				hover:SetAlpha( 0.8)
				button.hover = hover
				button:SetHighlightTexture(hover)
			end

			if button.SetPushedTexture and not button.pushed then
				local pushed = button:CreateTexture("frame", nil, self)
				pushed:SetTexture( texture)
				pushed:SetVertexColor( 0, 1, 0, 1)
				pushed:SetPoint("TOPLEFT", 2, -2)
				pushed:SetPoint("BOTTOMRIGHT", -2, 2)
				pushed:SetAlpha( 0.7)
				button.pushed = pushed
				button:SetPushedTexture(pushed)
			end

			if button.SetCheckedTexture and not button.checked then
				local checked = button:CreateTexture("frame", nil, self)
				checked:SetTexture( texture)
				checked:SetVertexColor( 1, 1, 0, 1)
				checked:SetPoint("TOPLEFT", 2, -2)
				checked:SetPoint("BOTTOMRIGHT", -2, 2)
				checked:SetAlpha( 0.2)
				button.checked = checked
				button:SetCheckedTexture( checked)
			end

			Flash:SetTexture("Interface\\Buttons\\WHITE8x8")
			Button:SetNormalTexture("")
 
			if Border then
				Border:Hide()
				Border = dummy
			end
	
			if float then
				float:Hide()
				float = dummy
			end
			
			local countFrame = CreateFrame( "Frame", nil, button)
			countFrame:SetAllPoints( button)
			countFrame:SetFrameLevel( 500)
			
			Count:SetParent( countFrame)
			Count:ClearAllPoints()
			Count:SetPoint("BOTTOMRIGHT", 1, 0)
			Count:SetFont( fontpx, yo["ActionBar"].CountSize, "OUTLINE")
			Count:SetTextColor( 0, 215/255, 1)
			Count:SetShadowColor(0, 0, 0, 0.5)
			Count:SetShadowOffset(2, -2)
		
			if Btname then
				Btname:ClearAllPoints()
				Btname:SetPoint("BOTTOM", 0, 0)
				Btname:SetFont( fontpx, fontsize, "OUTLINE")
				Btname:SetWidth( buttonWidth)
			end
 
			if not _G[name.."Panel"] then
				if button:GetHeight() ~= buttonWidth and not InCombatLockdown() then --Taint fix for Flyout Buttons
					button:SetSize( buttonWidth, buttonHeight)
				end

				local panel = CreateFrame("Frame", name.."Panel", button)
				CreatePanel(panel, buttonWidth, buttonWidth, "CENTER", button, "CENTER", 0, 0)
				CreateStyle(panel, 2)
				--panel:SetFrameStrata(button:GetFrameStrata())
				--panel:SetFrameLevel(button:GetFrameLevel() - 1)
				panel:SetBackdropColor(.05,.05,.05, .6)

 
				Icon:SetTexCoord(.08, .92, .08, .92)
				Icon:SetPoint("TOPLEFT", Button, 2, -2)
				Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
			end

			HotKey:ClearAllPoints()
			HotKey:SetPoint("TOPRIGHT", 0, 0)
			HotKey:SetFont( fontpx, fontsize, "OUTLINE")
			HotKey.ClearAllPoints = dummy
			HotKey.SetPoint = dummy
 
			if yo["ActionBar"].HideHotKey then
				HotKey:SetText("")
				HotKey:Hide()
			end
 
 			if yo["ActionBar"].HideName then
				Btname:SetText("")
				Btname:Hide()
			end

			if normal then
				normal:ClearAllPoints()
				normal:SetPoint("TOPLEFT")
				normal:SetPoint("BOTTOMRIGHT")
			end
			
			--normal = nil
			--ActionButton_ShowGrid(button)
			
			if BtnBG then BtnBG:Hide() end 
		end

--------------------------------------------------------------------------------------------
--		Fix MicroMenu
--------------------------------------------------------------------------------------------
		hooksecurefunc("UpdateMicroButtons", function()
			MicroButtonPortrait:ClearAllPoints()
			MicroButtonPortrait:SetPoint("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT", 2, -2)
			MicroButtonPortrait:SetPoint("BOTTOMRIGHT", CharacterMicroButton.frame, "BOTTOMRIGHT", -2, 2)

			--CharacterMicroButton:ClearAllPoints()
			--CharacterMicroButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -2, 0)

			--GuildMicroButtonTabard:ClearAllPoints()
			--GuildMicroButtonTabard:SetPoint("TOP", GuildMicroButton.frame, "TOP", 0, 25)

			MainMenuBarPerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)
		end)
		
end

local bars = CreateFrame("Frame")
bars:RegisterEvent("PLAYER_ENTERING_WORLD")
bars:SetScript("OnEvent", function(self, event)

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
	if yo["ActionBar"].enable == true then
		
		local fader01 = {
  			fadeInAlpha 	= 1,
  			fadeInDuration 	= 0.3,
  			fadeInSmooth 	= "OUT",
  			fadeOutAlpha 	= 0.1,
  			fadeOutDuration = 0.9,
  			fadeOutSmooth 	= "OUT",
  			fadeOutDelay 	= 1,
		}

		local fader00 = {
  			fadeInAlpha 	= 1,
  			fadeInDuration 	= 0.3,
  			fadeInSmooth 	= "OUT",
  			fadeOutAlpha 	= 0,
  			fadeOutDuration = 0.9,
  			fadeOutSmooth 	= "OUT",
  			fadeOutDelay 	= 1,
		}

		local cfg = {}
		local defaultcfg = {
			["frameScale"] 		= 1,
			["framePadding"] 	= 1,
			["frameParent"] 	= UIParent,
			["framePoint"] 		= { "CENTER", cfg.frameParent, "CENTER", 0, 0},
			["buttonWidth"] 	= 35,
			["buttonHeight"] 	= 35,
			["buttonMargin"] 	= 2,
			["numCols"] 		= 12,
			["startPoint"] 		= "TOPLEFT", --, TOPRIGHT, BOTTOMRIGHT, BOTTOMLEFT)
			["fader"] 			= nil, --type:TABLE, description: rLib faderConfig, check rLib API for definition
			--["frameVisibility"] = (OPTIONAL), type:STRING, description: visibility state handler. define your own or let rActionBar use the default one.
			--["actionPage"] = (OPTIONAL), type:STRING, description: onstate-page handler. define your own or let rActionBar use the default one. Actionbar1 only.
		} 

		cfg = defaultcfg

		cfg.framePoint	= { "CENTER", yo_MoveABar1, "CENTER", 0, 0}
		rActionBar:CreateActionBar1( "yoFrame", cfg)
		
		cfg.framePoint = { "CENTER", yo_MoveABar2, "CENTER", 0, 0}
		rActionBar:CreateActionBar2( "yoFrame", cfg)

		--cfg.fader = fader		
		cfg.numCols = 6
		cfg.framePoint = { "CENTER", yo_MoveABar3, "CENTER", 0, 0}
		rActionBar:CreateActionBar3( "yoFrame", cfg)

		cfg.numCols = 12
		cfg.framePoint = { "CENTER", yo_MoveABar4, "CENTER", 0, 0}
		rActionBar:CreateActionBar4( "yoFrame", cfg)
		
		cfg.numCols = 1
		cfg.framePoint = { "CENTER", yo_MoveABar5, "CENTER", 0, 0}
		cfg.fader = fader00
		rActionBar:CreateActionBar5( "yoFrame", cfg)

		cfg.fader = nill
		cfg.buttonWidth = 30
		cfg.buttonHeight = 30
		cfg.startPoint = "TOPRIGHT"
		cfg.numCols = 12
		cfg.framePoint = { "CENTER", yo_MovePetBar, "CENTER", 0, 0}
		rActionBar:CreateStanceBar( "yoFrame",cfg)
		rActionBar:CreatePetBar( "yoFrame",cfg)

		cfg.buttonWidth = 40
		cfg.buttonHeight = 40
		cfg.startPoint = "TOPLEFT"
		cfg.framePoint = { "CENTER", yo_MoveExtr, "CENTER", 0, 0}
		rActionBar:CreateExtraBar( "yoFrame",cfg)

		cfg.buttonWidth = 35
		cfg.buttonHeight = 35
		cfg.framePoint = { "CENTER", yo_MoveExtr, "CENTER", 0, -60}
		cfg.frameVisibility = "[canexitvehicle][target=vehicle,exists] show;hide"
		rActionBar:CreateVehicleExitBar( "yoFrame",cfg)
		
		cfg.buttonWidth = 40
		cfg.buttonHeight = 40
		cfg.framePoint = { "CENTER", yo_MoveExtr, "CENTER", 0, -50}
		cfg.frameVisibility = nil
		rActionBar:CreatePossessExitBar( "yoFrame",cfg)
	
		cfg.buttonWidth = 30
		cfg.buttonHeight = 30
		cfg.startPoint = "TOPRIGHT"
		cfg.numCols = 12
		cfg.framePoint = { "RIGHT", yo_MovePetBar, "RIGHT", 0, 0}
		rActionBar:CreateTotemBar( "yoFrame",cfg)
		
		if yo["ActionBar"].MicroMenu == true then
			cfg = defaultcfg
			cfg.buttonMargin = -4
			cfg.fader = fader01
  			cfg.startPoint = "BOTTOMLEFT"
  			cfg.frameScale =  yo["ActionBar"].MicroScale
  			cfg.framePoint = { "CENTER", yo_MoveAMicro, "CENTER", 0, 0}
			rActionBar:CreateMicroMenuBar( "yoFrame", cfg)	
		end
		
		PlayerPowerBarAlt:ClearAllPoints()
		PlayerPowerBarAlt:SetPoint('CENTER', yo_MoveAltPower, 'CENTER')
		PlayerPowerBarAlt:SetParent(yo_MoveAltPower)
		PlayerPowerBarAlt.ignoreFramePositionManager = true
	
		local function Position(self)
			self:SetPoint('CENTER', yo_MoveAltPower, 'CENTER')
		end
		hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", Position) 
	end	
	
	if yo["ActionBar"].ShowGrid == true then
		ActionButton_HideGrid = dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)
