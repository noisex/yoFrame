yo_CTA = {}
local tRole, hRole, dRole, heroic, lfr, timer

local function isRaidFinderDungeonDisplayable(id)
	local name, typeID, subtypeID, minLevel, maxLevel, _, _, _, expansionLevel = GetLFGDungeonInfo(id);
	local myLevel = UnitLevel("player");
	return myLevel >= minLevel and myLevel <= maxLevel and EXPANSION_LEVEL >= expansionLevel;
end

local function CreateLFRFrame( self)

	tRole 	= yo.CTA.tRole
	hRole		= yo.CTA.hRole
	dRole		= yo.CTA.dRole
	heroic	= yo.CTA.heroic
	lfr 		= yo.CTA.lfr
	timer 	= yo.CTA.timer

	local frame = CreateFrame("Frame", nil, self)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame:Hide()
	CreatePanel( frame, 220, 10, "CENTER", yo_MoveCTA, "CENTER", 0, 0, 0, 0)
	CreateStyle( frame, 3, 0, 0.4, 0.6)

	frame.title = frame:CreateFontString(nil, "OVERLAY", frame)
	frame.title:SetPoint("TOP")
	frame.title:SetFont( font, fontsize -1, "THINOUTLINE")
	frame.title:SetText( "Призыв к оружию")
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
			GameTooltip:SetText("Развернуть")
		else
			GameTooltip:SetText("Свернуть")
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
			frame.nosound:GetNormalTexture():SetVertexColor( 0.5, .5, .5, 1)
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
		GameTooltip:SetText("Звук")
		GameTooltip:AddLine("Отключить звук до следующего входа в игру или смены персонажа", 1, 1, 1, 1)
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
		GameTooltip:SetText("Закрыть")
		GameTooltip:AddLine("Закрыть СТА до следующего входа в игру или смены персонажа", 1, 1, 1, 1)
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
	button:SetWidth( parent:GetWidth() - 10)
	button:SetHeight( 20)
	button:EnableMouse(true)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint( "TOPLEFT", button, "TOPLEFT")
	button.icon:SetSize(35, 20)
	--button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.name = button:CreateFontString(nil, "OVERLAY")
	button.name:SetFont( font, fontsize, "THINOUTLINE")
	button.name:SetPoint("TOPLEFT", button.icon, "TOPRIGHT", 2, 2)
	button.name:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -50, 0)
	button.name:SetTextColor( .7, .7, .7, 1)

	button.tank = button:CreateTexture(nil, "OVERLAY")
	button.tank:SetPoint( "RIGHT", button, "RIGHT", -30, 0)
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
		self.name:SetTextColor( 1, .75, 0, 1)
	end)

	button:SetScript("OnLeave", function(self, ...)
		local cate = GetLFGCategoryForID( self.id);
		local mode, subMode = GetLFGMode( cate or self.mode, self.id)

		if ( mode == "queued" or mode == "listed" or mode == "rolecheck" or mode == "suspended" ) then
			self.name:SetTextColor(0, 1, 0, 1)
		else
			self.name:SetTextColor( .7, .7, .7, 1)
		end		
	end)

	if id == 1 then
		button:SetPoint( "TOPLEFT", parent, "TOPLEFT", 5, -15)
	else
		button:SetPoint( "TOPLEFT", parent[id-1], "BOTTOMLEFT", 0, -2)
	end

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


--yo_CTA[1671] = {}
--yo_CTA[1671]["name"] = "Хероический рендом в погоне за сумкой"
--yo_CTA[1671]["mode"] = LE_LFG_CATEGORY_LFD
--yo_CTA[1671]["tank"] = true
--yo_CTA[1671]["heal"] = false
--yo_CTA[1671]["dd"]   = true
--yo_CTA[1671]["icon"] = 252188


local function CheckLFR( self, ...)
	--if yo.CTA.hide == true then return end
	LFDQueueFrame_Update();
	LFRQueueFrame_Update();
	RequestLFDPlayerLockInfo();		

   	local newDate, update = false, false
   	local index = 0
   	local id = 1671

   	if heroic and not yo.CTA.hide and isRaidFinderDungeonDisplayable(id) then		
		local checkTank, checkHeal, checkDD	
		if not yo_CTA[id] then yo_CTA[id] = {} end
		yo_CTA[id]["name"] = "Хероический рендом"
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
			--print( floor(GetTime()),  " id = ",id, forTank, forHealer, forDamage, itemCount, " Heroic")
		end

		if checkTank and checkTank ~= yo_CTA[id]["tank"] then newDate = true end
		if checkHeal and checkHeal ~= yo_CTA[id]["heal"] then newDate = true end
		if checkDD   and checkDD   ~= yo_CTA[id]["dd"]   then newDate = true end
		yo_CTA[id]["tank"], yo_CTA[id]["heal"], yo_CTA[id]["dd"] = checkTank, checkHeal, checkDD
   	end

	if lfr and not yo.CTA.hide then
		for i = 1, GetNumRFDungeons() do
			local id, name,  _, _, level = GetRFDungeonInfo(i)
			if isRaidFinderDungeonDisplayable(id) then
				local checkTank, checkHeal, checkDD	
				if not yo_CTA[id] then yo_CTA[id] = {} end
				yo_CTA[id]["icon"] = select( 11, GetLFGDungeonInfo(id)) 
				yo_CTA[id]["name"] = name
				yo_CTA[id]["mode"] = LE_LFG_CATEGORY_LFR

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
					--print( floor(GetTime()),  " id = ",id, forTank, forHealer, forDamage, itemCount, " ", name)
				end	

				if checkTank and checkTank ~= yo_CTA[id]["tank"] then newDate = true end
				if checkHeal and checkHeal ~= yo_CTA[id]["heal"] then newDate = true end
				if checkDD   and checkDD   ~= yo_CTA[id]["dd"]   then newDate = true end
				yo_CTA[id]["tank"] = true and checkTank or false 
				yo_CTA[id]["heal"] = true and checkHeal or false 
				yo_CTA[id]["dd"]   = true and checkDD or false 
			end	
		end
	end
	--print("...........................")

	if index == 0 or UnitInParty("player") or UnitInRaid("player") or yo.CTA.hide then
		self.LFRFrame:Hide()
	else
		self.LFRFrame:Show()
	end

   if newDate and ( not UnitInParty("player") or not UnitInRaid("player")) and not yo.CTA.nosound then
		PlaySoundFile( LSM:Fetch( "sound", yo.CTA.sound))
	  --PlaySoundFile([[Sound\Creature\BabyMurloc\BabyMurlocA.ogg]],"Master");
   end

	--if update then 
		UpdateStrings( self)
	--end

	C_Timer.After( timer, function(self) CheckLFR( _G["yo_CTAFrame"]) end)
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not yo.CTA.enable then return end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		CreateLFRFrame( self)
		CheckLFR( self)      
	end
end

local cta = CreateFrame("Frame", "yo_CTAFrame", UIParent)
cta:RegisterEvent("PLAYER_ENTERING_WORLD")
cta:SetScript("OnEvent", OnEvent)