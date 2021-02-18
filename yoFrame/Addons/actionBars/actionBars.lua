local L, yo, n = unpack( select( 2, ...))

if not yo.ActionBar.enable then return end

local _G = _G
-- GLOBALS: myButtonBorder

local IsUsableAction, CreateStyle, CreateFrame, UnitCanAttack, InCombatLockdown, unpack, CreatePanel, strsplit, GameTooltip, GetBindingKey
	= IsUsableAction, CreateStyle, CreateFrame, UnitCanAttack, InCombatLockdown, unpack, CreatePanel, strsplit, GameTooltip, GetBindingKey

local kbs = {
	-- This is the short display version you see on the Button
	["Alt"] = "A",
	["Ctrl"] = "C",
	["Shift"] = "S",
	["Command"] = "M", -- Blizzard uses 'm' for the command key (META key)
	["NumPad"] = "N",

	["Backspace"] = "BS",
	["Button1"] = "B1",
	["Button2"] = "B2",
	["Button3"] = "B3",
	["Button4"] = "B4",
	["Button5"] = "B5",
	["Button6"] = "B6",
	["Button7"] = "B7",
	["Button8"] = "B8",
	["Button9"] = "B9",
	["Button10"] = "B10",
	["Button11"] = "B11",
	["Button12"] = "B12",
	["Button13"] = "B13",
	["Button14"] = "B14",
	["Button15"] = "B15",
	["Button16"] = "B16",
	["Button17"] = "B17",
	["Button18"] = "B18",
	["Button19"] = "B19",
	["Button20"] = "B20",
	["Button21"] = "B21",
	["Button22"] = "B22",
	["Button23"] = "B23",
	["Button24"] = "B24",
	["Button25"] = "B25",
	["Button26"] = "B26",
	["Button27"] = "B27",
	["Button28"] = "B28",
	["Button29"] = "B29",
	["Button30"] = "B30",
	["Button31"] = "B31",
	["Capslock"] = "Cp",
	["Clear"] = "Cl",
	["Delete"] = "Del",
	["End"] = "En",
	["Home"] = "HM",
	["Insert"] = "Ins",
	["Mouse Wheel Down"] = "WD",
	["Mouse Wheel Up"] = "WU",
	["Num Lock"] = "NL",
	["Page Down"] = "PD",
	["Page Up"] = "PU",
	["Scroll Lock"] = "SL",
	["Spacebar"] = "Sp",
	["Tab"] = "Tb",

	["Down Arrow"] = "Dn",
	["Left Arrow"] = "Lf",
	["Right Arrow"] = "Rt",
	["Up Arrow"] = "Up",
}

local function keyShorBind( key)
	if key then
		key = key:upper()
		key = key:gsub(' ', '')
		key = key:gsub('ALT%-', kbs['Alt'])
		key = key:gsub('CTRL%-', kbs['Ctrl'])
		key = key:gsub('SHIFT%-', kbs['Shift'])
		key = key:gsub('META%-', kbs['Command'])
		key = key:gsub('NUMPAD', kbs['NumPad'])

		key = key:gsub('PLUS', '%+')
		key = key:gsub('MINUS', '%-')
		key = key:gsub('MULTIPLY', '%*')
		key = key:gsub('DIVIDE', '%/')

		key = key:gsub('BACKSPACE', kbs['Backspace'])

		for i = 1, 31 do
			key = key:gsub('BUTTON' .. i, kbs['Button' .. i])
		end

		key = key:gsub('CAPSLOCK', kbs['Capslock'])
		key = key:gsub('CLEAR', kbs['Clear'])
		key = key:gsub('DELETE', kbs['Delete'])
		key = key:gsub('END', kbs['End'])
		key = key:gsub('HOME', kbs['Home'])
		key = key:gsub('INSERT', kbs['Insert'])
		key = key:gsub('MOUSEWHEELDOWN', kbs['Mouse Wheel Down'])
		key = key:gsub('MOUSEWHEELUP', kbs['Mouse Wheel Up'])
		key = key:gsub('NUMLOCK', kbs['Num Lock'])
		key = key:gsub('PAGEDOWN', kbs['Page Down'])
		key = key:gsub('PAGEUP', kbs['Page Up'])
		key = key:gsub('SCROLLLOCK', kbs['Scroll Lock'])
		key = key:gsub('SPACEBAR', kbs['Spacebar'])
		key = key:gsub('SPACE', kbs['Spacebar'])
		key = key:gsub('TAB', kbs['Tab'])

		key = key:gsub('DOWNARROW', kbs['Down Arrow'])
		key = key:gsub('LEFTARROW', kbs['Left Arrow'])
		key = key:gsub('RIGHTARROW', kbs['Right Arrow'])
		key = key:gsub('UPARROW', kbs['Up Arrow'])

		return key
	end
end

local function buttonsUP( self)
	if not InCombatLockdown() then
		--print("Buttons UP!")
		SHOW_MULTI_ACTIONBAR_1 = 1
		SHOW_MULTI_ACTIONBAR_3 = 1
		ALWAYS_SHOW_MULTIBARS  = 1
		SetActionBarToggles(not not SHOW_MULTI_ACTIONBAR_1, not not SHOW_MULTI_ACTIONBAR_2, not not SHOW_MULTI_ACTIONBAR_3, not not SHOW_MULTI_ACTIONBAR_4, not not ALWAYS_SHOW_MULTIBARS);
		MultiBarBottomLeft:SetShown(true)
		MultiBarRight:SetShown(true)
		--MultiActionBar_ShowAllGrids(ACTION_BUTTON_SHOW_GRID_REASON_CVAR);
		--InterfaceOptions_UpdateMultiActionBars()
	else
		--self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function myButtonBorder( self, name, shift, alpha, cols)
	local shift = shift or 5
	local alpha = alpha or 1
	local cols  = cols 	or { 1, 1, 1}

	local texture = self:CreateTexture( nil, "BORDER")
	texture:SetTexture( yo.Media.borders)
	texture:SetVertexColor( cols[1], cols[2], cols[3], alpha)
	texture:SetPoint("TOPLEFT", -shift, shift)
	texture:SetPoint("BOTTOMRIGHT", shift, -shift)
	texture:SetAlpha( alpha)
	self[name] = texture
	return texture
end


function ActionButton_UpdateRangeIndicator(self, checksRange, InRange)
	if not self.action then return end

	local Icon 			= self.icon
	local IsUsable, NotEnoughMana = IsUsableAction( self.action)

	if UnitCanAttack("player", "target") and (checksRange and InRange == false) then -- Out of range
		Icon:SetVertexColor(0.8, 0.1, 0.1)
	else -- In range
		if IsUsable then -- Usable
			Icon:SetVertexColor(1.0, 1.0, 1.0)
		elseif NotEnoughMana then -- Not enough power
			Icon:SetVertexColor(0.1, 0.3, 1.0)
		else -- Not usable
			Icon:SetVertexColor(0.3, 0.3, 0.3)
		end
	end

	local isLevelLinkLocked = C_LevelLink.IsActionLocked(self.action);
	if not Icon:IsDesaturated() then
		Icon:SetDesaturated(isLevelLinkLocked);
	end

	if self.LevelLinkLockIcon then
		self.LevelLinkLockIcon:SetShown(isLevelLinkLocked);
	end

end

function ActionButtonDesign( frame, button, buttonWidth, buttonHeight )

	local name = button:GetName()

	if 	name:match("MultiCast") then return

--------------------------------------------------------------------------------------------
--		VENICHLE EXIT
--------------------------------------------------------------------------------------------
	elseif name:match("VehicleExitButton") then
		local Icon = _G[name.."Icon"]

		button:SetSize( buttonWidth, buttonWidth)
		Icon:SetTexCoord(unpack( n.tCoord))
		CreateStyle( button, 2)

		local shift, alpfa = 3, 0.9
		if button.SetHighlightTexture 	then button:SetHighlightTexture( 	myButtonBorder( button, "hover", shift, alpfa,   { 0, 1, 0})) end
		if button.SetPushedTexture 		then button:SetPushedTexture( 		myButtonBorder( button, "pushed", shift, alpfa,  { 1, 0, 0})) end
		if button.SetCheckedTexture 	then button:SetCheckedTexture( 		myButtonBorder( button, "checked", shift, alpfa, { 0, 0, 1})) end
		if button.SetNormalTexture 		then button:SetNormalTexture( 		myButtonBorder( button, "normal", shift, alpfa,  { 0.1, 0.1, 0.1})) end

--------------------------------------------------------------------------------------------
--		MicroMenu
--------------------------------------------------------------------------------------------
	elseif 	name:match("MicroButton") then
		local m = button
		local pushed = m:GetPushedTexture()
		local normal = m:GetNormalTexture()
		local disabled = m:GetDisabledTexture()

		m:SetParent(frame)
		m.SetParent = n.dummy
		_G[name.."Flash"]:SetTexture("")
		m:SetHighlightTexture("")
		m.SetHighlightTexture = n.dummy

		local f = CreateFrame("Frame", nil, m)
		f:SetFrameLevel(1)
		f:SetFrameStrata("BACKGROUND")
		f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 0)
		f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -6)
		CreateStyle( f, 2)
		m.frame = f

		pushed:SetTexCoord(unpack( n.tCoordBig))
		pushed:ClearAllPoints()
		pushed:SetPoint("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		pushed:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)

		normal:SetTexCoord(unpack( n.tCoordBig))
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		normal:SetPoint("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)

		if disabled then
			disabled:SetTexCoord(unpack( n.tCoordBig))
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

		button.style:Hide()
		button.style.Show = n.dummy

		button:SetScale( 0.9)
		button.Count:Hide()
		button.icon:SetTexCoord(unpack( n.tCoord))
		button.cooldown:ClearAllPoints()
		button.cooldown:SetAllPoints( button)

		local shift, alpfa = 7, 0.9

		if button.SetHighlightTexture 	then button:SetHighlightTexture( 	myButtonBorder( button, "hover", shift, alpfa,   { 1, 1, 0})) end
		if button.SetNormalTexture 		then button:SetNormalTexture( 		myButtonBorder( button, "normal", shift, alpfa,  { 0, 1, 0})) end
		if button.SetCheckedTexture 	then button:SetCheckedTexture( 		myButtonBorder( button, "checked", shift, alpfa, { 1, 0, 0})) end

--------------------------------------------------------------------------------------------
--		Pet Menu
--------------------------------------------------------------------------------------------
	elseif name:match("PetAction") or name:match("StanceButton") then

		local Flash	 	= _G[name.."Flash"]
		local icon	 	= _G[name.."Icon"]
		local normal  	= _G[name.."NormalTexture2"]
		local Border  	= _G[name.."Border"]
		local cd 		= button.cooldown

		local shift, alpfa = 3, 0.9

		if not _G[name.."Panel"] then
			button:SetWidth(buttonWidth)
			button:SetHeight(buttonWidth)

			local panel = CreateFrame("Frame", name.."Panel", button, BackdropTemplateMixin and "BackdropTemplate")
			CreatePanel(panel, buttonWidth, buttonWidth, "CENTER", button, "CENTER", 0, 0)
			panel:SetFrameStrata(button:GetFrameStrata())
			panel:SetFrameLevel(button:GetFrameLevel() - 1)
			CreateStyle(panel, 2)

			icon:SetTexCoord(unpack( n.tCoord))
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", button, 2, -2)
			icon:SetPoint("BOTTOMRIGHT", button, -2, 2)

			cd:ClearAllPoints()
			cd:SetPoint("TOPLEFT", button, 2, -2)
			cd:SetPoint("BOTTOMRIGHT", button, -2, 2)

			--if false then
			--	if buttonWidth < 10 then
			--		local autocast = _G[name.."AutoCastable"]
			--		autocast:SetAlpha(0)
			--	end
			--	local shine = _G[name.."Shine"]
			--	shine:SetSize(buttonWidth, buttonWidth)
			--	shine:ClearAllPoints()
			--	shine:SetPoint("CENTER", button, 0, 0)
			--end
		end

		button.HotKey:ClearAllPoints()
		button.HotKey:SetPoint("TOPRIGHT", 0, 0)
		button.HotKey:SetFont( n.fontpx, n.fontsize, "OUTLINE")
		button.HotKey.ClearAllPoints = n.dummy
		button.HotKey.SetPoint = n.dummy

		if yo.ActionBar.HideHotKey 		then button.HotKey:Hide() end
		if button.SetHighlightTexture 	then button:SetHighlightTexture( 	myButtonBorder( button, "hover", shift, alpfa, { 0, 1, 0})) end
		if button.SetPushedTexture 		then button:SetPushedTexture( 		myButtonBorder( button, "pushed", shift, alpfa, { 1, 0, 0})) 	end
		if button.SetCheckedTexture 	then button:SetCheckedTexture( 		myButtonBorder( button, "checked", shift, alpfa - 0.5, { 1, 1, 0})) end
		button:SetNormalTexture( "")
		button:GetNormalTexture():SetSize( 1,1)
		Flash:SetTexture("")

--------------------------------------------------------------------------------------------
--		Totem Menu
--------------------------------------------------------------------------------------------
	elseif name:match("TotemFrame") then
		local Back 		= _G[name..'Background']
		local Icon 		= _G[name.."Icon"]
		local IconCD 	= _G[name.."IconCooldown"]
		local IconTXT 	= _G[name.."IconTexture"]
		local Dura 		= _G[name.."Duration"]
		--local HotKey 	= _G[name.."HotKey"]

		local f1, f2 = button:GetChildren()
		f2:Hide()

		Icon:SetSize( buttonWidth, buttonWidth)
		IconTXT:SetSize( buttonWidth, buttonWidth)
		IconTXT:SetTexCoord(unpack( n.tCoord))
		IconTXT:SetPoint("TOPLEFT", button, 2, -2)
		IconTXT:SetPoint("BOTTOMRIGHT", button, -2, 2)
		Back:Hide()
		--Dura:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, 5)
		Dura:SetFont( n.fontpx, n.fontsize +1, "OUTLINE")
		CreateStyle( button, 2)

		local shift, alpfa = 3, 0.9
		--if yo.ActionBar.HideHotKey 		then button.HotKey:Hide() end
		if button.SetHighlightTexture 	then button:SetHighlightTexture( 	myButtonBorder( button, "hover", shift, alpfa, { 0, 1, 0})) end
		if button.SetPushedTexture 		then button:SetPushedTexture( 		myButtonBorder( button, "pushed", shift, alpfa, { 1, 0, 0})) 	end
		if button.SetCheckedTexture 	then button:SetCheckedTexture( 		myButtonBorder( button, "checked", shift, alpfa - 0.5, { 1, 1, 0})) end

--------------------------------------------------------------------------------------------
--		Actions Bars
--------------------------------------------------------------------------------------------
	elseif name:match("MultiBar") or name:match( "ActionButton") then

		local shift, alpfa 	= -2, .3
		local action 	= button.action
		local Icon 		= _G[name.."Icon"]
		local Count 	= _G[name.."Count"]
		local Flash	 	= _G[name.."Flash"]
		local HotKey 	= _G[name.."HotKey"]
		local Border  	= _G[name.."Border"]
		local CD 		= _G[name.."Cooldown"]
		local Btname 	= _G[name.."Name"]
		local normal  	= _G[name.."NormalTexture"]
		local BtnBG 	= _G[name..'FloatingBG']
		local texture 	= n.texture

		if yo.ActionBar.hoverTexture then
			texture = yo.Media.borders
			shift = 3
			alpfa = 0.9
		end

		if CD then
			CD:ClearAllPoints()
			CD:SetPoint("TOPLEFT", 2, -2)
			CD:SetPoint("BOTTOMRIGHT", -2, 2)
		end

		if button.SetHighlightTexture 	then button:SetHighlightTexture( 	myButtonBorder( button, "hover", shift, alpfa, { 0, 1, 0})) end
		if button.SetPushedTexture 		then button:SetPushedTexture( 		myButtonBorder( button, "pushed", shift, alpfa, { 1, 0, 0})) 	end
		if button.SetCheckedTexture 	then button:SetCheckedTexture( 		myButtonBorder( button, "checked", shift, alpfa - 0.3, { 1, 1, 0})) end

		Flash:SetTexture("Interface\\Buttons\\WHITE8x8")
		button:SetNormalTexture("")

		if Border then
			Border:Hide()
			Border = n.dummy
		end

		--if float then
		--	float:Hide()
		--	float = n.dummy
		--end

		local countFrame = CreateFrame( "Frame", nil, button)
		countFrame:SetAllPoints( button)
		countFrame:SetFrameLevel( 500)

		Count:SetParent( countFrame)
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 1, 0)
		Count:SetFont( n.fontpx, yo["ActionBar"].CountSize, "OUTLINE")
		Count:SetTextColor( 0, 215/255, 1)
		Count:SetShadowColor(0, 0, 0, 0.5)
		Count:SetShadowOffset(2, -2)

		if Btname then
			Btname:ClearAllPoints()
			Btname:SetPoint("BOTTOM", 0, 0)
			Btname:SetFont( n.fontpx, n.fontsize, "OUTLINE")
			Btname:SetWidth( buttonWidth)
		end

		if not _G[name.."Panel"] then
			if button:GetHeight() ~= buttonWidth and not InCombatLockdown() then --Taint fix for Flyout Buttons
				button:SetSize( buttonWidth, buttonHeight)
			end

			local panel = CreateFrame("Frame", name.."Panel", button, BackdropTemplateMixin and "BackdropTemplate")
			CreatePanel(panel, buttonWidth, buttonWidth, "CENTER", button, "CENTER", 0, 0)
			CreateStyle(panel, 2)
			--panel:SetFrameStrata(button:GetFrameStrata())
			--panel:SetFrameLevel(button:GetFrameLevel() - 1)
			panel:SetBackdropColor(.05,.05,.05, .6)

			Icon:SetTexCoord(unpack( n.tCoord))
			Icon:SetPoint("TOPLEFT", button, 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
		end

		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 0, 0)
		HotKey:SetFont( n.fontpx, yo.ActionBar.HotKeySize, "OUTLINE")
		local r, g, b = strsplit( ",", yo.ActionBar.HotKeyColor)
		HotKey:SetTextColor(  r, g, b, 1)
		HotKey.ClearAllPoints = n.dummy
		HotKey.SetPoint = n.dummy

		local key1, key2 = GetBindingKey( button.commandName)
		local skye1	= keyShorBind( key1)
		local skye2	= keyShorBind( key2)
		local sName = skye1 and skye1 or ""

		if yo.ActionBar.secondHot then
			sName 	= skye2 and sName .. " " .. skye2 or sName
		end

		if yo.ActionBar.HotToolTip then

			hooksecurefunc( _G[name], 'SetTooltip', function( self)
				local macros = button.Name:GetText()
				local key1, key2 = GetBindingKey( button.commandName)

				if macros or key1 or key2 then
					if macros 	then GameTooltip:AddDoubleLine( "Macros:", 	macros, nil, nil, nil, 1, 1, 1)	end
					if key1		then GameTooltip:AddDoubleLine( "HotKey:", 	key1, 	nil, nil, nil, 1, 1, 1)	end
					if key2 	then GameTooltip:AddDoubleLine( "HotKey2:", key2,	nil, nil, nil, 1, 1, 1)	end
					GameTooltip:Show()
				end
			end)
		end

		if yo.ActionBar.HideHotKey then
			HotKey:SetText("")
			HotKey:Hide()
		else
			HotKey:SetText( sName)
			HotKey:Show()
		end

 		if yo.ActionBar.HideName then
			Btname:SetText("")
			Btname:Hide()
		end

		--if normal then
		--	normal:ClearAllPoints()
		--	normal:SetPoint("TOPLEFT")
		--	normal:SetPoint("BOTTOMRIGHT")
		--end

		if BtnBG then BtnBG:Hide() end

		button.NormalTexture = nil
	end
end



--local bars = CreateFrame("Frame")
--bars:RegisterEvent("PLAYER_ENTERING_WORLD")
--bars:SetScript("OnEvent", function(self, event)

--	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

--	if yo.ActionBar.enable == true then

--		n.moveCreateAnchor("yoMoveABar1", 		"Move Action Bar #1", 445, 35, 0, 	2, 		"BOTTOM", "BOTTOM")
--		n.moveCreateAnchor("yoMoveABar2", 		"Move Action Bar #2", 445, 35, 0, 	40, 	"BOTTOM", "BOTTOM")
--		n.moveCreateAnchor("yoMoveABar3", 		"Move Action Bar #3", 40, 40, -300, 300, 	"TOPRIGHT", "BOTTOMRIGHT")
--		n.moveCreateAnchor("yoMoveABar4", 		"Move Action Bar #4", 445, 35, -1, 	182, 	"BOTTOMRIGHT", "BOTTOMRIGHT")
--		n.moveCreateAnchor("yoMoveABar5", 		"Move Action Bar #5", 35, 445, -5, 	-110, 	"RIGHT", "RIGHT")
--		n.moveCreateAnchor("yoMoveAMicro", 		"Move MicroMenu Bar", 220, 18, -470,7, 		"BOTTOMRIGHT", "BOTTOMRIGHT")
--		n.moveCreateAnchor("yoMovePetBar", 		"Move Pet Bar", 	  330, 30, 0, 	5, 		"BOTTOMRIGHT", "TOPRIGHT", yoMoveLeftPanel)
--		n.moveCreateAnchor("yoMoveExtr", 		"Move Extro Button",  130, 60, 0, 	150, 	"BOTTOM", "TOP", yoMoveplayer)

--		local fader01 = {
--  			fadeInAlpha 	= 1,
--  			fadeInDuration 	= 0.3,
--  			fadeInSmooth 	= "OUT",
--  			fadeOutAlpha 	= 0.1,
--  			fadeOutDuration = 0.9,
--  			fadeOutSmooth 	= "OUT",
--  			fadeOutDelay 	= 1,
--		}

--		local fader00 = {
--  			fadeInAlpha 	= 1,
--  			fadeInDuration 	= 0.3,
--  			fadeInSmooth 	= "OUT",
--  			fadeOutAlpha 	= 0,
--  			fadeOutDuration = 0.9,
--  			fadeOutSmooth 	= "OUT",
--  			fadeOutDelay 	= 1,
--		}

--		local cfg = {}
--		local defaultcfg = {
--			["frameScale"] 		= 1,
--			["framePadding"] 	= 1,
--			["frameParent"] 	= UIParent,
--			["framePoint"] 		= { "CENTER", cfg.frameParent, "CENTER", 0, 0},
--			["buttonWidth"] 	= yo.ActionBar.buttonsSize,
--			["buttonHeight"] 	= yo.ActionBar.buttonsSize,
--			["buttonMargin"] 	= yo.ActionBar.buttonSpace,
--			["numCols"] 		= 12,
--			["startPoint"] 		= "TOPLEFT", --, TOPRIGHT, BOTTOMRIGHT, BOTTOMLEFT)
--			["fader"] 			= nil, --type:TABLE, description: rLib faderConfig, check rLib API for definition
--			["frameVisibility"] = nil,
--			--["frameVisibility"] = (OPTIONAL), type:STRING, description: visibility state handler. define your own or let rActionBar use the default one.
--			--["actionPage"] = (OPTIONAL), type:STRING, description: onstate-page handler. define your own or let rActionBar use the default one. Actionbar1 only.
--		}

--		cfg = defaultcfg
--		cfg.framePoint	= { "CENTER", yoMoveABar1, "CENTER", 0, 0}
--		rActionBar:CreateActionBar1( "yoFrame", cfg)

--		cfg = defaultcfg
--		cfg.framePoint 	= { "CENTER", yoMoveABar2, "CENTER", 0, 0}
--		rActionBar:CreateActionBar2( "yoFrame", cfg)

--		--cfg.fader = fader
--		cfg.numCols 	= yo.ActionBar.panel3Cols
--		cfg.framePoint 	= { "TOPLEFT", yoMoveABar3, "TOPLEFT", 0, 0}
--		rActionBar:CreateActionBar3( "yoFrame", cfg)

--		cfg.numCols 	= 12
--		cfg.buttonWidth = 35
--		cfg.buttonHeight= 35
--		cfg.buttonMargin= 2
--		cfg.framePoint 	= { "CENTER", yoMoveABar4, "CENTER", 0, 0}
--		rActionBar:CreateActionBar4( "yoFrame", cfg)

--		cfg.numCols 	= 1
--		cfg.framePoint 	= { "CENTER", yoMoveABar5, "CENTER", 0, 0}
--		cfg.buttonWidth = 35
--		cfg.buttonHeight= 35
--		cfg.fader 		= fader00
--		cfg.direction 	= "LEFT"
--		rActionBar:CreateActionBar5( "yoFrame", cfg)

--		cfg.fader 		= nill
--		cfg.buttonWidth = 30
--		cfg.buttonHeight= 30
--		cfg.startPoint 	= "TOPRIGHT"
--		cfg.numCols 	= 12
--		cfg.framePoint 	= { "CENTER", yoMovePetBar, "CENTER", 0, 0}
--		rActionBar:CreateStanceBar( "yoFrame",cfg)
--		rActionBar:CreatePetBar( "yoFrame",cfg)

--		cfg.buttonWidth = 40
--		cfg.buttonHeight= 40
--		cfg.startPoint 	= "TOPLEFT"
--		cfg.framePoint 	= { "CENTER", yoMoveExtr, "CENTER", 0, 0}
--		rActionBar:CreateExtraBar( "yoFrame",cfg)

--		cfg.buttonWidth = 35
--		cfg.buttonHeight= 35
--		cfg.framePoint 	= { "CENTER", yoMoveExtr, "CENTER", 0, -60}
--		cfg.frameVisibility = "[canexitvehicle][target=vehicle,exists] show;hide"
--		rActionBar:CreateVehicleExitBar( "yoFrame",cfg)

--		cfg.buttonWidth = 40
--		cfg.buttonHeight = 40
--		cfg.framePoint = { "CENTER", yoMoveExtr, "CENTER", 0, -50}
--		cfg.frameVisibility = nil
--		rActionBar:CreatePossessExitBar( "yoFrame",cfg)

--		cfg.buttonWidth = 30
--		cfg.buttonHeight = 35
--		cfg.startPoint = "TOPRIGHT"
--		cfg.numCols = 12
--		cfg.framePoint = { "RIGHT", yoMovePetBar, "RIGHT", 0, 0}
--		rActionBar:CreateTotemBar( "yoFrame",cfg)

--		if yo.ActionBar.MicroMenu == true then
--			cfg = defaultcfg
--			cfg.buttonMargin = -4
--			cfg.fader = fader01
--  			cfg.startPoint = "BOTTOMLEFT"
--  			cfg.frameScale =  yo["ActionBar"].MicroScale
--  			cfg.framePoint = { "CENTER", yoMoveAMicro, "CENTER", 0, 0}
--			rActionBar:CreateMicroMenuBar( "yoFrame", cfg)
--		end

--		PlayerPowerBarAlt:ClearAllPoints()
--		PlayerPowerBarAlt:SetPoint('CENTER', yoMoveAltPower, 'CENTER')
--		PlayerPowerBarAlt:SetParent(yoMoveAltPower)
--		PlayerPowerBarAlt.ignoreFramePositionManager = true

--		local function Position(self)
--			self:SetPoint('CENTER', yoMoveAltPower, 'CENTER')
--		end
--		hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", Position)
--	end

--	if yo.ActionBar.ShowGrid == true then
--		ActionButton_HideGrid = n.dummy
--		for i = 1, 12 do
--			local button = _G[format("ActionButton%d", i)]
--			button:SetAttribute("showgrid", 1)
--			button:ShowGrid( ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

--			button = _G[format("MultiBarRightButton%d", i)]
--			button:SetAttribute("showgrid", 1)
--			button:ShowGrid( ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

--			button = _G[format("MultiBarBottomRightButton%d", i)]
--			button:SetAttribute("showgrid", 1)
--			button:ShowGrid( ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

--			button = _G[format("MultiBarLeftButton%d", i)]
--			button:SetAttribute("showgrid", 1)
--			button:ShowGrid( ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

--			button = _G[format("MultiBarBottomLeftButton%d", i)]
--			button:SetAttribute("showgrid", 1)
--			button:ShowGrid( ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
--		end
--	end

--	ZoneAbilityFrame:SetParent(UIParent)
--	ZoneAbilityFrame:SetScale( 0.6)
--	ZoneAbilityFrame:ClearAllPoints()
--	ZoneAbilityFrame:SetPoint('LEFT', n.infoTexts.LeftDataPanel, 'RIGHT', 170, 20)
--	--DraenorZoneAbilityFrame:SetScript("OnShow", DraenorZoneAbilityFrame.Hide)
--	ZoneAbilityFrame.ignoreFramePositionManager = true

--	--buttonsUP( self)
--	C_Timer.After( 2, function() buttonsUP(self) end )
--end)


----------------------------------------------------------------------------------------------
------ 		update OverrideBar new buttons
----------------------------------------------------------------------------------------------
--hooksecurefunc("ActionBarController_UpdateAll", function(self, ...)
--	if ( HasBonusActionBar() or HasOverrideActionBar() or HasVehicleActionBar() or HasTempShapeshiftActionBar() ) then
--		--print("ПОПАЛИ: ", CURRENT_ACTION_BAR_STATE, LE_ACTIONBAR_STATE_OVERRIDE, HasVehicleActionBar(), HasOverrideActionBar(), HasTempShapeshiftActionBar(), C_PetBattles.IsInBattle())
--		for i = 1, 6 do
--			if ActionBarButtonEventsFrame.frames[i] then ActionBarButtonEventsFrame.frames[i]:Update() end
--		end
--	end
--end)

--------------------------------------------------------------------------------------------
--		Fix MicroMenu
--------------------------------------------------------------------------------------------
	--hooksecurefunc("UpdateMicroButtons", function()
		--MicroButtonPortrait:ClearAllPoints()
		--MicroButtonPortrait:SetPoint("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT", 2, -2)
		--MicroButtonPortrait:SetPoint("BOTTOMRIGHT", CharacterMicroButton.frame, "BOTTOMRIGHT", -2, 2)

		--CharacterMicroButton:ClearAllPoints()
		--CharacterMicroButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -2, 0)
		--GuildMicroButtonTabard:ClearAllPoints()
		--GuildMicroButtonTabard:SetPoint("TOP", GuildMicroButton.frame, "TOP", 0, 25)

		--MainMenuBarPerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)
	--end)