local L, yo = unpack( select( 2, ...))

local function DisbandRaidGroup()
	if InCombatLockdown() then return end -- Prevent user error in combat

	if UnitInRaid("player") then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= E.myname then
				UninviteUnit(name)
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if UnitExists("party"..i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end
--local PopupDialogs = {};

-- PopupDialogs["DISBAND_RAID"] = {
	-- text = "Are you sure you want to disband the group?",
	-- button1 = ACCEPT,
	-- button2 = CANCEL,
	-- OnAccept = function() DisbandRaidGroup() end,
	-- timeout = 0,
	-- whileDead = 1,
-- }	

local function doRUP()
	local iWidth = 110

	local RUPanel = CreateFrame("Frame", nil, UIParent)
	CreatePanel(RUPanel, 226, 126, "TOP", yo_MoveRUP, "TOP", 0, 0)
	RUPanel:SetBackdropColor(.05,.05,.05, 0.9)
	RUPanel:SetFrameLevel(0)
	RUPanel:SetFrameStrata("HIGH")
	RUPanel:ClearAllPoints()
	RUPanel:SetPoint( "TOP", yo_MoveRUP, "TOP", 3, 3)
	RUPanel:Hide()

 	--Change border when mouse is inside the button
	local function ButtonEnter(self)
		local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
		self:SetBackdropBorderColor(color.r, color.g, color.b)
	end
 
	--Change border back to normal when mouse leaves button
	local function ButtonLeave(self)
		self:SetBackdropBorderColor(.15,.15,.15, 0)
	end
	-------------------------------------------------------------------------------------------------------------
 
	local function BEnter(self)
		local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
		self:SetBackdropBorderColor(color.r, color.g, color.b)
	end
 
	local function BLeave(self)
		self:SetBackdropBorderColor(.15,.15,.15, 0)
	end

	local sB = CreateFrame("Frame", nil, RUPanel)
	for i = 1, 9 do
		sB[i] = CreateFrame("Button", nil, RUPanel, "SecureHandlerClickTemplate") -- "yo_Mark"..i
		sB[i]:SetWidth( 24)
		sB[i]:SetHeight(24)
		sB[i]:SetBackdrop({
			bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
			edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
			insets = {left = 1, right = 1, top = 1, bottom = 1} 
		})
		sB[i]:SetBackdropBorderColor(.15,.15,.15, 0)
		sB[i]:SetScript("OnEnter", BEnter)
		sB[i]:SetScript("OnLeave", BLeave)
		sB[i]:RegisterForClicks("AnyUp")
		sB[i]:SetBackdropColor(.05,.05,.05, 0.9)
		sB[i]:SetNormalTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	
		if i == 1 then -- Skull
			sB[i]:SetPoint("TOPLEFT", RUPanel, "TOPLEFT", 3 , -2)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 8) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
		elseif i == 2 then -- Cross
			sB[i]:SetPoint("LEFT", sB[i-1], "RIGHT", 2, 0)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 7) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
		elseif i == 3 then -- Square
			sB[i]:SetPoint("TOP", sB[1], "BOTTOM", 0, -2)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 6) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
		elseif i == 4 then -- Moon
			sB[i]:SetPoint("LEFT", sB[i-1], "RIGHT", 2, 0)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 5) end)
			sB[i]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
		elseif i == 5 then -- Triangle
			sB[i]:SetPoint("TOP", sB[3], "BOTTOM", 0, -2)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 4) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
		elseif i == 6 then -- Diamond
			sB[i]:SetPoint("LEFT", sB[i-1], "RIGHT", 2, 0)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 3) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
		elseif i == 7 then -- Circle
			sB[i]:SetPoint("TOP", sB[5], "BOTTOM", 0, -2)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 2) end)
			sB[i]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
		elseif i == 8 then -- Star
			sB[i]:SetPoint("LEFT", sB[i-1], "RIGHT", 2, 0)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 1) end)
			sB[i]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		elseif i == 9 then -- Clear
			sB[i]:SetPoint("TOPLEFT", sB[7], "BOTTOMLEFT", -2, -2)
			sB[i]:SetScript("OnMouseUp", function() SetRaidTarget("target", 0) end)
			--sB[i]:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-D3")
			sB[i]:SetNormalTexture( nil)
			sB[i]:SetWidth( 56)
			sB[i]:SetHeight(18)
			
			local txt = sB[i]:CreateFontString(nil,"OVERLAY", nil)
			txt:SetFont( font,fontsize,"OUTLINE")
			txt:SetText("Clear")
			txt:SetPoint("CENTER")
			txt:SetJustifyH("CENTER")
	
		end
	end

	for i = 11, 19 do
		sB[i] = CreateFrame("Button", nil, RUPanel, "SecureActionButtonTemplate")  -- name
		sB[i]:SetWidth(24)
		sB[i]:SetHeight(24)
		sB[i]:SetBackdrop({
			bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
			edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
			insets = {left = 1, right = 1, top = 1, bottom = 1} 
		})
		sB[i]:SetBackdropColor( 0, 0, 1)
		sB[i]:SetBackdropBorderColor(.15,.15,.15, 0)
		sB[i]:SetScript("OnEnter", BEnter)
		sB[i]:SetScript("OnLeave", BLeave)
		sB[i]:SetAttribute("type", "macro")

		if i == 11 then
			sB[i]:SetBackdropColor( 0, 0.76 ,1, 1)
			sB[i]:SetPoint("TOPRIGHT", RUPanel, "TOPRIGHT", -3, -3)
			sB[i]:SetAttribute("macrotext", [[/cwm 1
/wm 1]])
		elseif i == 12 then
			sB[i]:SetBackdropColor( 0.58, 0.86, 0.49,1)
			sB[i]:SetPoint( "RIGHT", sB[11], "LEFT", -2, 0)
			sB[i]:SetAttribute("macrotext", [[/cwm 2
/wm 2]])
		elseif i == 13 then
			sB[i]:SetBackdropColor( 0.6, 0.47, 0.85,1) 
			sB[i]:SetPoint( "TOP", sB[11], "BOTTOM", 0, -2)
			sB[i]:SetAttribute("macrotext", [[/cwm 3
/wm 3]])
		elseif i == 14 then
			sB[i]:SetBackdropColor( 0.77, 0.12 , 0.23, 1)  
			sB[i]:SetPoint( "TOP", sB[12], "BOTTOM", 0, -2)
			sB[i]:SetAttribute("macrotext", [[/cwm 4
/wm 4]])
		elseif i == 15 then
			sB[i]:SetPoint( "TOP", sB[13], "BOTTOM", 0, -2) 
			sB[i]:SetBackdropColor( 1, 0.91, 0.2, 1)
			sB[i]:SetAttribute("macrotext", [[/cwm 5
/wm 5]])
		elseif i == 16 then
			sB[i]:SetPoint( "TOP", sB[14], "BOTTOM", 0, -2) 
			sB[i]:SetBackdropColor(  1, 0.49, 0.04, 1)
			sB[i]:SetAttribute("macrotext", [[/cwm 6
/wm 6]])
		elseif i == 17 then
			sB[i]:SetPoint( "TOP", sB[15], "BOTTOM", 0, -2) 
			sB[i]:SetBackdropColor( 0.8, 0.87, 0.9, 1)
			sB[i]:SetAttribute("macrotext", [[/cwm 7
/wm 7]])
		elseif i == 18 then
			sB[i]:SetPoint( "TOP", sB[16], "BOTTOM", 0, -2)
			sB[i]:SetBackdropColor( 0.29, 0.29, 0.29, 1) 
			sB[i]:SetAttribute("macrotext", [[/cwm 8
/wm 8]])
		elseif i == 19 then
			sB[i]:SetPoint( "TOPRIGHT", sB[17], "BOTTOMRIGHT", 0, -2)
			sB[i]:SetWidth( 50)
			sB[i]:SetHeight(18)
			sB[i]:SetBackdropColor( 0, 0, 0, 0.9)
			sB[i]:SetAttribute("macrotext", [[
/cwm 1
/cwm 2
/cwm 3
/cwm 4
/cwm 5
/cwm 6
/cwm 7
/cwm 8
]])
			local txt = sB[i]:CreateFontString(nil,"OVERLAY", nil)
			txt:SetFont( font,fontsize,"OUTLINE")
			txt:SetText("Clear")
			txt:SetPoint("CENTER")
			txt:SetJustifyH("CENTER")
	
			-- local txt = sB[i]:CreateTexture(nil,"OVERLAY",nil)
			-- txt:SetSize( 18, 18)
			-- txt:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Overwatch")  --Interface\\CHATFRAME\\UI-ChatIcon-D3  --Interface\\ARCHEOLOGY\\Arch-Icon-Marker")   --Interface\\RAIDFRAME\\ReadyCheck-NotReady")
			-- txt:SetPoint("CENTER", sB[i], "CENTER", 0, 0)
		end
	end
 
	--Create button for when frame is hidden ----------------------------------------------------------------------
	local CloseButton = CreateFrame("Button", nil, UIParent, "SecureHandlerClickTemplate")
	CloseButton:SetHeight(16)
	CloseButton:SetWidth( iWidth)
	frame1px(CloseButton)
	CreateStyle(CloseButton, 2)

	CloseButton:SetPoint( "TOP", RUPanel, "TOP", 0, 0)
	CloseButton:SetScript("OnEnter", ButtonEnter)
	CloseButton:SetScript("OnLeave", ButtonLeave)
	CloseButton:RegisterForClicks("AnyUp")
	CloseButton:SetFrameRef('RUPanel', RUPanel)
	CloseButton:SetFrameRef('CloseButton', CloseButton)
	CloseButton:SetAttribute("_onclick", [=[
		self:GetFrameRef('RUPanel'):Show()
		self:GetFrameRef('CloseButton'):Hide()
	]=]); 

	local CloseButtonText = CloseButton:CreateFontString(nil,"OVERLAY",CloseButton)
	CloseButtonText:SetFont( font,fontsize,"OUTLINE")
	CloseButtonText:SetText("Raid Utility")
	CloseButtonText:SetPoint("CENTER")
	CloseButtonText:SetJustifyH("CENTER")
 
 
	--Create button for when frame is shown
	local ShownButton = CreateFrame("Button", nil, RUPanel, "SecureHandlerClickTemplate")
	ShownButton:SetHeight(16)
	ShownButton:SetWidth( iWidth)
	frame1px(ShownButton)
	CreateStyle(ShownButton, 2)
	ShownButton:SetPoint("TOP", RUPanel, "BOTTOM", 0, -3)
	ShownButton:SetScript("OnEnter", ButtonEnter)
	ShownButton:SetScript("OnLeave", ButtonLeave)
	ShownButton:RegisterForClicks("AnyUp")
	ShownButton:SetFrameRef('RUPanel', RUPanel)
	ShownButton:SetFrameRef('CloseButton', CloseButton)
	ShownButton:SetAttribute("_onclick", [=[
		self:GetFrameRef('RUPanel'):Hide()
		self:GetFrameRef('CloseButton'):Show()
	]=]); 

	local ShownButtonText = ShownButton:CreateFontString(nil,"OVERLAY",ShownButton)
	ShownButtonText:SetFont( font,fontsize,"OUTLINE")
	ShownButtonText:SetText("Close")
	ShownButtonText:SetPoint("CENTER")
	ShownButtonText:SetJustifyH("CENTER")

	--Cancel Pill Button
	local CancelButton = CreateFrame("Button", nil, RUPanel, "SecureActionButtonTemplate")
	CancelButton:SetHeight(16)
	CancelButton:SetWidth(iWidth)
	frame1px(CancelButton)
	CancelButton:SetPoint("TOP", RUPanel, "TOP", 0, 0)
	CancelButton:SetScript("OnEnter", ButtonEnter)
	CancelButton:SetScript("OnLeave", ButtonLeave)
	CancelButton:SetAttribute("type1","macro")
	CancelButton:SetAttribute("macrotext1", "/ert pull 0")
	CancelButton:RegisterForClicks("AnyDown")

	CancelButton:SetScript("OnMouseUp", function(self)
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local CancelButtonText = CancelButton:CreateFontString(nil,"OVERLAY",CancelButton)
	CancelButtonText:SetFont( font,fontsize,"OUTLINE")
	CancelButtonText:SetText("Cancel Pull")
	CancelButtonText:SetPoint("CENTER")
	CancelButtonText:SetJustifyH("CENTER")
 
	--PULL 5 button
	local Pull5Button = CreateFrame("Button", nil, RUPanel, "SecureActionButtonTemplate")
	Pull5Button:SetHeight(16)
	Pull5Button:SetWidth(iWidth)
	frame1px(Pull5Button)
	Pull5Button:SetPoint("TOPLEFT", CancelButton, "BOTTOMLEFT", 0, -5)
	Pull5Button:SetScript("OnEnter", ButtonEnter)
	Pull5Button:SetScript("OnLeave", ButtonLeave)
	Pull5Button:RegisterForClicks("AnyDown")

	Pull5Button:SetAttribute("type1","macro")
	Pull5Button:SetAttribute("macrotext1", "/ert pull 5")

	Pull5Button:SetScript("OnMouseUp", function(self)
--		SendAddonMessage("BigWigs", "P^Pull^5")
--		local _,_,_,_,_,_,_,mapID = GetInstanceInfo()
--		SendAddonMessage("D4", ("PT\t%d\t%d"):format( 5,mapID or -1))	
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local Pull5ButtonText = Pull5Button:CreateFontString(nil,"OVERLAY",Pull5Button)
	Pull5ButtonText:SetFont( font,fontsize,"OUTLINE")
	Pull5ButtonText:SetText("Pull 5")
	Pull5ButtonText:SetPoint("CENTER")
	Pull5ButtonText:SetJustifyH("CENTER")
 
	--PULL 10 button
	local Pull10Button = CreateFrame("Button", nil, RUPanel, "SecureActionButtonTemplate")
	Pull10Button:SetHeight(16)
	Pull10Button:SetWidth(iWidth)
	frame1px(Pull10Button)
	Pull10Button:SetPoint("TOP", Pull5Button, "BOTTOM", 0, -5)
	Pull10Button:SetScript("OnEnter", ButtonEnter)
	Pull10Button:SetScript("OnLeave", ButtonLeave)
	Pull10Button:SetAttribute("type1","macro")
	Pull10Button:SetAttribute("macrotext1", "/ert pull 10")
	Pull10Button:RegisterForClicks("AnyDown")

	Pull10Button:SetScript("OnMouseUp", function(self)
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local Pull10ButtonText = Pull10Button:CreateFontString(nil,"OVERLAY",Pull10Button)
	Pull10ButtonText:SetFont( font,fontsize,"OUTLINE")
	Pull10ButtonText:SetText("Pull 10")
	Pull10ButtonText:SetPoint("CENTER")
	Pull10ButtonText:SetJustifyH("CENTER")
 
	--Ready Check button
	local ReadyCheckButton = CreateFrame("Button", nil, RUPanel)
	ReadyCheckButton:SetHeight(16)
	ReadyCheckButton:SetWidth(iWidth)
	frame1px(ReadyCheckButton)
	ReadyCheckButton:SetPoint("TOPLEFT", Pull10Button, "BOTTOMLEFT", 0, -5)
	ReadyCheckButton:SetScript("OnEnter", ButtonEnter)
	ReadyCheckButton:SetScript("OnLeave", ButtonLeave)
	ReadyCheckButton:SetScript("OnMouseUp", function(self)
		DoReadyCheck()
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local ReadyCheckButtonText = ReadyCheckButton:CreateFontString(nil,"OVERLAY",ReadyCheckButton)
	ReadyCheckButtonText:SetFont( font,fontsize,"OUTLINE")
	ReadyCheckButtonText:SetText(READY_CHECK)
	ReadyCheckButtonText:SetPoint("CENTER")
	ReadyCheckButtonText:SetJustifyH("CENTER")

		--Leave group button
	local LeaveButton = CreateFrame("Button", nil, RUPanel)
	LeaveButton:SetHeight(16)
	LeaveButton:SetWidth(iWidth)
	frame1px( LeaveButton)
	LeaveButton:SetPoint("TOPLEFT", ReadyCheckButton, "BOTTOMLEFT", 0, -5)
	LeaveButton:SetScript("OnEnter", ButtonEnter)
	LeaveButton:SetScript("OnLeave", ButtonLeave)
	LeaveButton:SetScript("OnMouseUp", function(self)
		LeaveParty()
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local LeaveButtonText = LeaveButton:CreateFontString(nil,"OVERLAY",LeaveButton)
	LeaveButtonText:SetFont( font,fontsize,"OUTLINE")
	LeaveButtonText:SetText( PARTY_LEAVE)
	LeaveButtonText:SetPoint("CENTER")
	LeaveButtonText:SetJustifyH("CENTER")
	
	--DISBAND button
	local DisbandButton = CreateFrame("Button", nil, RUPanel)
	DisbandButton:SetHeight(16)
	DisbandButton:SetWidth(iWidth)
	frame1px( DisbandButton)
	DisbandButton:SetPoint("TOPLEFT", LeaveButton, "BOTTOMLEFT", 0, -5)
	DisbandButton:SetScript("OnEnter", ButtonEnter)
	DisbandButton:SetScript("OnLeave", ButtonLeave)
	DisbandButton:SetScript("OnMouseUp", function(self)
		--if CheckRaidStatus() then
			--StaticPopup_Show("DISBAND_RAID")
			DisbandRaidGroup()
			
			--PopupDialogs("DISBAND_RAID")
		--end
		RUPanel:Hide()
		CloseButton:Show()
	end)
 
	local DisbandButtonText = DisbandButton:CreateFontString(nil,"OVERLAY",DisbandButton)
	DisbandButtonText:SetFont( font,fontsize,"OUTLINE")
	DisbandButtonText:SetText( TEAM_DISBAND)
	DisbandButtonText:SetTextColor( 1, 0.5, 0)
	DisbandButtonText:SetPoint("CENTER")
	DisbandButtonText:SetJustifyH("CENTER")
	
	--World Marker button
	-- local WorldMarkerButton = CreateFrame("Button", nil, RUPanel)
	-- WorldMarkerButton:SetHeight(20)
	-- WorldMarkerButton:SetWidth( 20)
	-- frame1px(WorldMarkerButton)
	-- WorldMarkerButton:SetPoint("TOP", ReadyCheckButton, "BOTTOM", 0, -5)
	-- WorldMarkerButton:SetScript("OnEnter", ButtonEnter)
	-- WorldMarkerButton:SetScript("OnLeave", ButtonLeave)

	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAllPoints(WorldMarkerButton)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent(WorldMarkerButton)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetAlpha(0)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnEnter", function()
		-- local color = RAID_CLASS_COLORS[select(2,  UnitClass( "player") )]
		-- WorldMarkerButton:SetBackdropBorderColor(color.r, color.g, color.b)
	-- end)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:HookScript("OnLeave", function()
		-- WorldMarkerButton:SetBackdropBorderColor(.15,.15,.15, 0)
	-- end)

	-- --Put other stuff back
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)

	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:ClearAllPoints()
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPLEFT", 0, 1)
	-- CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT", 0, 1)
 
	-- local WorldMarkerButtonTexture = WorldMarkerButton:CreateTexture(nil,"OVERLAY",nil)
	-- WorldMarkerButtonTexture:SetSize( 20, 20)
	-- WorldMarkerButtonTexture:SetTexture("Interface\\RaidFrame\\Raid-WorldPing")
	-- WorldMarkerButtonTexture:SetPoint("CENTER", WorldMarkerButton, "CENTER", 0, 0)
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")
logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo["Addons"].RaidUtilityPanel then return end
	doRUP()
end)

