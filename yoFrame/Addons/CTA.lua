
local L, yo = unpack( select( 2, ...))

local yo_CTA = {}
local tRole, hRole, dRole, timer

local function isRaidFinderDungeonDisplayable(id)

	local _, _, isKilled = GetLFGDungeonEncounterInfo( id, GetLFGDungeonNumEncounters( id))
	if yo.CTA.hideLast and isKilled then
		return false
	end

	local name, typeID, subtypeID, minLevel, maxLevel, _, _, _, expansionLevel = GetLFGDungeonInfo(id);
	local myLevel = UnitLevel("player");
	return myLevel >= minLevel and myLevel <= maxLevel and EXPANSION_LEVEL >= expansionLevel;
end

local function CheckLFGQueueMode( self, id, modeLFG)
	local id = id or self.id
	local modeLFG = modeFLFG or self.mode
	local cate = GetLFGCategoryForID( id);
	local mode, subMode = GetLFGMode( cate or modeLFG, id)

	if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" ) then
		self.name:SetTextColor(0, 1, 0, 1)
	else
		self.name:SetTextColor( .7, .7, .7, 1)
	end
	return mode, ( cate or modeLFG)
end

local function CreateLFRFrame( self)
	local frame = CreateFrame("Frame", nil, self)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame:Hide()
	CreatePanel( frame, 220, 10, "CENTER", yo_MoveCTA, "CENTER", 0, 0, 0, 0)
	CreateStyle( frame, 3, 0, 0.4, 0.6)

	frame.tank = frame:CreateTexture(nil, "OVERLAY")
	frame.tank:SetPoint( "TOPLEFT", frame, "TOPLEFT", 5, -2)
	frame.tank:SetSize(12, 12)
	frame.tank:SetTexture([[Interface\AddOns\yoFrame\Media\tank]])

	frame.heal = frame:CreateTexture(nil, "OVERLAY")
	frame.heal:SetPoint( "LEFT", frame.tank, "RIGHT", 0, 0)
	frame.heal:SetSize(12, 12)
	frame.heal:SetTexture([[Interface\AddOns\yoFrame\Media\healer]])

	frame.dd = frame:CreateTexture(nil, "OVERLAY")
	frame.dd:SetPoint( "LEFT", frame.heal, "RIGHT", 0, 0)
	frame.dd:SetSize(10, 10)
	frame.dd:SetTexture([[Interface\AddOns\yoFrame\Media\dps]])

	frame.title = frame:CreateFontString(nil, "OVERLAY", frame)
	frame.title:SetPoint("TOP")
	frame.title:SetFont( font, fontsize -1, "THINOUTLINE")
	frame.title:SetText( format( LFG_CALL_TO_ARMS, " "))
	frame.title:SetTextColor( 0.75, .5, 0)

	frame.close = CreateFrame("Button", nil, frame)
	frame.close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
	frame.close:SetFrameLevel(frame:GetFrameLevel() + 10)
	frame.close:SetWidth(  8)
	frame.close:SetHeight( 8)
	frame.close:SetNormalTexture("Interface\\Addons\\yoFrame\\Media\\close")
	frame.close:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
	frame.close:EnableMouse(true)

	frame.expand = CreateFrame("Button", nil, frame)
	frame.expand:SetPoint("RIGHT", frame.close, "LEFT", -5, 0)
	frame.expand:SetFrameLevel(frame:GetFrameLevel() + 10)
	frame.expand:SetWidth(  10)
	frame.expand:SetNormalTexture("Interface\\Addons\\yoFrame\\Media\\hot_flat_16_16")
	frame.expand:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
	if yo.CTA.expand then
		frame.expand:SetHeight( 10)
	else
		frame.expand:SetHeight( 5)
	end
	frame.expand:EnableMouse(true)

	frame.expand:SetScript("OnEnter", function(self, ...)
		self:GetNormalTexture():SetVertexColor( 1, 1, 0, 1)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 10)
		if yo.CTA.expand then
			GameTooltip:SetText( L["Expand"])
		else
			GameTooltip:SetText( L["Collapse"])
		end
		GameTooltip:Show()
	end)

	frame.expand:SetScript("OnLeave", function(self, ...)
		frame.expand:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
		GameTooltip:Hide()
	end)

	frame.expand:SetScript("OnClick", function(self, ...)
		yo.CTA.expand = not yo.CTA.expand
		if yo.CTA.expand then
			frame.expand:SetHeight( 10)
		else
			frame.expand:SetHeight( 5)
		end
		UpdateStrings( _G["yo_CTAFrame"])
	end)

	frame.nosound = CreateFrame("Button", nil, frame)
	frame.nosound:SetPoint("RIGHT", frame.expand, "LEFT", 3, 1)
	frame.nosound:SetFrameLevel(frame:GetFrameLevel() + 10)
	frame.nosound:SetWidth(  22)
	frame.nosound:SetHeight( 22)
	frame.nosound:SetNormalTexture("Interface\\Addons\\yoFrame\\Media\\ArrowRight")
	if yo.CTA.nosound then
		frame.nosound:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
	else
		frame.nosound:GetNormalTexture():SetVertexColor( 0, 1, 0, 1)
	end
	frame.nosound:EnableMouse(true)

	frame.nosound:SetScript("OnClick", function(self, ...)
		yo.CTA.nosound = not yo.CTA.nosound
		if yo.CTA.nosound then
			self:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
		else
			self:GetNormalTexture():SetVertexColor( 0, 1, 0, 1)
		end
	end)

	frame.nosound:SetScript("OnEnter", function(self, ...)
		self:GetNormalTexture():SetVertexColor( 1, 1, 0, 1)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 10)
		GameTooltip:SetText( SOUND)
		GameTooltip:AddLine( L["Sound_OFF"], 1, 1, 1, 1)
		GameTooltip:Show()
	end)

	frame.nosound:SetScript("OnLeave", function(self, ...)
		if yo.CTA.nosound then
			self:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
		else
			self:GetNormalTexture():SetVertexColor( 0, 1, 0, 1)
		end
		GameTooltip:Hide()
	end)


	frame.close:SetScript("OnClick", function(self, ...)
		self:GetNormalTexture():SetVertexColor( 1, 0, 0, 1)
		self:GetParent():Hide()
		yo.CTA.hide = true
		yo_CTA = {}
	end)

	frame.close:SetScript("OnEnter", function(self, ...)
		self:GetNormalTexture():SetVertexColor( 1, 0, 0, 1)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 10)
		GameTooltip:SetText( CLOSE)
		GameTooltip:AddLine( L["Close_OFF"], 1, 1, 1, 1)
		GameTooltip:Show()
	end)

	frame.close:SetScript("OnLeave", function(self, ...)
		self:GetNormalTexture():SetVertexColor( .5, .5, .5, 1)
		GameTooltip:Hide()
	end)

	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		yo_MoveCTA:ClearAllPoints()
		yo_MoveCTA:SetPoint( self:GetPoint())
		SetAnchPosition( yo_MoveCTA, self)
	end)
	self.LFRFrame = frame
end


local function CreateLFRStrings( parent, id)
	local button = CreateFrame("Button", nil, parent)
	button:SetFrameLevel(parent:GetFrameLevel() + 10)
	button:SetWidth( parent:GetWidth() - 4)
	button:SetHeight( 20)
	button:EnableMouse(true)
	button:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1}
	})
	button:SetBackdropBorderColor(.15,.15,.15, 0)
	button:SetBackdropColor(.15,.15,.15, 0)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint( "LEFT", button, "LEFT", 2, 0)
	button.icon:SetSize(35, 18)

	button.name = button:CreateFontString(nil, "OVERLAY")
	button.name:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	button.name:SetPoint("TOPLEFT", button.icon, "TOPRIGHT", 2, 2)
	button.name:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -50, 0)

	button.tank = button:CreateTexture(nil, "OVERLAY")
	button.tank:SetPoint( "RIGHT", button, "RIGHT", -32, 0)
	button.tank:SetSize(20, 20)
	button.tank:SetTexture([[Interface\AddOns\yoFrame\Media\tank]])

	button.heal = button:CreateTexture(nil, "OVERLAY")
	button.heal:SetPoint( "LEFT", button.tank, "RIGHT", 0, 0)
	button.heal:SetSize(20, 20)
	button.heal:SetTexture([[Interface\AddOns\yoFrame\Media\healer]])

	button.dd = button:CreateTexture(nil, "OVERLAY")
	button.dd:SetPoint( "LEFT", button.heal, "RIGHT", 0, 0)
	button.dd:SetSize(14, 14)
	button.dd:SetTexture([[Interface\AddOns\yoFrame\Media\dps]])

	if id == 1 then
		button:SetPoint( "TOPLEFT", parent, "TOPLEFT", 2, -15)
	else
		button:SetPoint( "TOPLEFT", parent[id-1], "BOTTOMLEFT", 0, -2)
	end

	button:SetScript("OnClick", function(self, ...)
		local cate = GetLFGCategoryForID( self.id);
		local mode, subMode = GetLFGMode( cate or self.mode, self.id)

		if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" ) then
			LeaveSingleLFG( cate or self.mode, self.id)
			self.name:SetTextColor( .7, .7, .7, 1)
		else
			ClearAllLFGDungeons(self.mode)
			if not yo.CTA.setN then
				SetLFGRoles( false, yo.CTA.setT, yo.CTA.setH, yo.CTA.setD)
			end
			SetLFGDungeon( self.mode, self.id)
			JoinLFG(self.mode)
			self.name:SetTextColor(0, 1, 0, 1)
		end
	end)

	button:SetScript("OnEnter", function(self, ...)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, self) --"ANCHOR_TOPLEFT", 0, 0)
		GameTooltip:SetText( GetLFGDungeonInfo(self.id))
		for index = 1,  GetLFGDungeonNumEncounters( self.id) do
				local bossName, _, isKilled = GetLFGDungeonEncounterInfo( self.id, index)
				GameTooltip:AddDoubleLine( " ", (isKilled and "|cffff0000" or "|cff00991a") .. bossName)
		end
		local _, tRealRole, hRealRole, dRealRole = GetLFGRoles()
		local realRoles = ( tRealRole and INLINE_TANK_ICON or "") .. ( hRealRole and INLINE_HEALER_ICON or "") .. ( dRealRole and INLINE_DAMAGER_ICON or "")
		GameTooltip:AddLine( " ")
		GameTooltip:AddDoubleLine( YOUR_ROLE, realRoles)

		local mode = CheckLFGQueueMode( self)
		if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" ) then

			for i=1, NUM_LE_LFG_CATEGORYS do
				local hasdata,  _, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, _, _, _, averageWait, tankWait, healerWait, damageWait, myWait, queuedTime, activeID = GetLFGQueueStats( i)
				if hasdata then

					tankNeeds 	= tankNeeds > 0 and 	( " |cff00ffff" .. INLINE_TANK_ICON ..": " .. tankNeeds) or ""
					healerNeeds = healerNeeds > 0 and 	( " |cff00ff00" .. INLINE_HEALER_ICON .. ": " .. healerNeeds) or ""
					dpsNeeds 	= dpsNeeds > 0 and 		( " |cffff1100" .. INLINE_DAMAGER_ICON .. ": " .. dpsNeeds) or ""

					GameTooltip:AddDoubleLine( FRIENDS_FRIENDS_WAITING, tankNeeds .. healerNeeds .. dpsNeeds)

					local timeWaite =  SecondsToClock( GetTime() - queuedTime)
					GameTooltip:AddLine( " ")
					GameTooltip:AddDoubleLine( QUEUED_STATUS_QUEUED, timeWaite)
					GameTooltip:AddDoubleLine( VOICE_CHAT_AWAITING_MEMBER_NAME,  SecondsToClock( myWait) .. " ( " ..  SecondsToClock( averageWait) .. ")")
				end
			end
		end

		GameTooltip:Show()
		--self.name:SetTextColor(myColor.r, myColor.g, myColor.b, .9)
		self:SetBackdropBorderColor(myColor.r, myColor.g, myColor.b, .9)
	end)

	button:SetScript("OnLeave", function(self, ...)
		self:SetBackdropBorderColor(.15,.15,.15, 0)

		CheckLFGQueueMode( self)
		GameTooltip:Hide()
	end)

	return button
end

function UpdateStrings(self)
	if not yo.CTA.expand then
		local id = 1
		for k,v in pairs( yo_CTA) do
		if v.tank or v.heal or v.dd then

			if not self.LFRFrame[id] then self.LFRFrame[id] = CreateLFRStrings( self.LFRFrame, id) end

				self.LFRFrame[id].id = k
				self.LFRFrame[id].mode = v.mode
				self.LFRFrame[id].name:SetText(v.name) -- .. " (" .. k .. ")")
				self.LFRFrame[id].icon:SetTexture(v.icon)

				self.LFRFrame[id].tank:SetShown( v.tank)
				self.LFRFrame[id].heal:SetShown( v.heal)
				self.LFRFrame[id].dd:SetShown( v.dd)

				CheckLFGQueueMode( self.LFRFrame[id])
				self.LFRFrame[id]:Show()
				id = id + 1
			end
		end
		self.LFRFrame:SetHeight( ( id - 1) * 23 + 14)
		for index = id, #self.LFRFrame do self.LFRFrame[index]:Hide() end
	else
		self.LFRFrame:SetHeight( 14)
		for index = 1, #self.LFRFrame do self.LFRFrame[index]:Hide() end
	end
end

local function CheckLFR( self, ...)
	RequestLFDPlayerLockInfo();

	local _, tRealRole, hRealRole, dRealRole = GetLFGRoles()
	if yo.CTA.nRole then
		tRole 	= tRealRole
		hRole	= hRealRole
		dRole	= dRealRole
	else
		tRole 	= yo.CTA.tRole
		hRole	= yo.CTA.hRole
		dRole	= yo.CTA.dRole
	end

	self.LFRFrame.tank:SetShown( tRole )
	self.LFRFrame.heal:SetShown( hRole)
	self.LFRFrame.dd:SetShown( dRole)

   	local newDate, update = false, false
   	local index = 0
   	local id = 1671 	-- 	Random Battle For Azeroth Heroic

   	if yo.CTA.heroic and not yo.CTA.hide and isRaidFinderDungeonDisplayable(id) then
		local checkTank, checkHeal, checkDD
		if not yo_CTA[id] then yo_CTA[id] = {} end
		yo_CTA[id]["name"] = CALENDAR_TYPE_HEROIC_DUNGEON
		yo_CTA[id]["mode"] = LE_LFG_CATEGORY_LFD
		yo_CTA[id]["icon"] = "Interface\\LFGFrame\\UI-LFG-BACKGROUND-HEROIC"	--252188

		for shortageIndex = 1, 1 do --LFG_ROLE_NUM_SHORTAGE_TYPES do
			local eligible, forTank, forHealer, forDamage, itemCount, money, xp = GetLFGRoleShortageRewards(id, shortageIndex)
			if eligible and itemCount > 0 then

				if tRole and forTank then
					checkTank = true
					index = index + 1
				end

				if hRole and forHealer then
					checkHeal = true
					index = index + 1
				end

				if dRole and forDamage then
					checkDD = true
					index = index + 1
				end
			end
		end

		if checkTank and checkTank ~= yo_CTA[id]["tank"] then newDate = true end
		if checkHeal and checkHeal ~= yo_CTA[id]["heal"] then newDate = true end
		if checkDD   and checkDD   ~= yo_CTA[id]["dd"]   then newDate = true end
		yo_CTA[id]["tank"], yo_CTA[id]["heal"], yo_CTA[id]["dd"] = checkTank, checkHeal, checkDD
   	end

	if yo.CTA.lfr and not yo.CTA.hide then
		for i = 1, GetNumRFDungeons() do
			local id, name,  _, _, level = GetRFDungeonInfo(i)
			if isRaidFinderDungeonDisplayable(id) then
				local checkTank, checkHeal, checkDD
				if not yo_CTA[id] then yo_CTA[id] = {} end
				yo_CTA[id]["icon"] = select( 11, GetLFGDungeonInfo(id))
				yo_CTA[id]["name"] = name
				yo_CTA[id]["mode"] = LE_LFG_CATEGORY_LFR

				--for shortageIndex = 1, 1 do --LFG_ROLE_NUM_SHORTAGE_TYPES do
				local eligible, forTank, forHealer, forDamage, itemCount, money, xp = GetLFGRoleShortageRewards(id, 1)
				if eligible and itemCount > 0 then
					if tRole and forTank then
						checkTank = true
						index = index + 1
					end

					if hRole and forHealer then
						checkHeal = true
						index = index + 1
					end

					if dRole and forDamage then
						checkDD = true
						index = index + 1
					end
				end
				--end

				if checkTank and checkTank ~= yo_CTA[id]["tank"] then newDate = true end
				if checkHeal and checkHeal ~= yo_CTA[id]["heal"] then newDate = true end
				if checkDD   and checkDD   ~= yo_CTA[id]["dd"]   then newDate = true end
				yo_CTA[id]["tank"] = true and checkTank or false
				yo_CTA[id]["heal"] = true and checkHeal or false
				yo_CTA[id]["dd"]   = true and checkDD or false
			end
		end
	end

	if index == 0 or UnitInParty("player") or UnitInRaid("player") or yo.CTA.hide then
		self.LFRFrame:Hide()
	else
		self.LFRFrame:Show()
	end

   if newDate and ( not UnitInParty("player") or not UnitInRaid("player")) and not yo.CTA.nosound then
		PlaySoundFile( LSM:Fetch( "sound", yo.CTA.sound))
   end

	--if update then
	UpdateStrings( self)
	--end

	timer = C_Timer.NewTimer( yo.CTA.timer, function(self) CheckLFR( _G["yo_CTAFrame"]) end)
end

function resetCTAtimer( self)
	if timer then
		timer:Cancel()
	end
	CheckLFR( _G["yo_CTAFrame"])
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not yo.CTA.enable then return end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("LFG_ROLE_UPDATE");
		self:RegisterEvent("LFG_UPDATE");
		CreateLFRFrame( self)
		resetCTAtimer()
	elseif event == "LFG_ROLE_UPDATE" or event == "LFG_UPDATE" then
		resetCTAtimer()
	end
end

local cta = CreateFrame("Frame", "yo_CTAFrame", UIParent)
cta:RegisterEvent("PLAYER_ENTERING_WORLD")
cta:SetScript("OnEvent", OnEvent)

--local nextMaintenance
--local function GetNextMaintenance()
--	if not nextMaintenance then
--		local region = GetCVar('portal')
--		local maintenanceWeekDay = (region == 'us' and 3)
--			or (region == 'eu' and 4)
--			or (region == 'kr' and 5)
--			or (region == 'tw' and 6)
--			or 7
--		local dailyReset = time() + GetQuestResetTime()
--		local resetWeekday = tonumber(date('%w', dailyReset)) + 1
--		nextMaintenance = dailyReset + ((maintenanceWeekDay - resetWeekday)%7)*24*60*60
--		-- print('next weekly reset', date('%d.%m.%Y', nextMaintenance))
--	end
--	return nextMaintenance
--end
-- ...
--_, numDefeated = GetLFGDungeonNumEncounters(dungeonID)
--if numDefeated ~= 0 then
--	dungeonReset = GetNextMaintenance() - time()
--	dungeons[dungeonName.." (LFR)|"..dungeonID] = format("%s|%s|%s|%s", dungeonReset, time(), numDefeated, available)
--end
