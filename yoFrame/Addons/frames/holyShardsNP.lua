local L, yo, N = unpack( select( 2, ...))

if not yo.NamePlates.enable or not yo.NamePlates.showResourses then return end

-----------------------------------------------------------------------------------
--- COMBO POINTS
-----------------------------------------------------------------------------------
local function ClearCPoints( self)
	if self.cPoints then
		for i = 1, #self.cPoints do
			Kill( self.cPoints[i])
		end
	end

	if myClass == "DEATHKNIGHT" then
		self:UnregisterEvent("RUNE_POWER_UPDATE")
	else
		self:UnregisterEvent("UNIT_POWER_UPDATE", "player")
		self:UnregisterEvent("UNIT_MAXPOWER", "player")
		--self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		self:UnregisterEvent("UNIT_DISPLAYPOWER", "player")
	end
end

local function UpdateRunes( self)
	for i = 1, 6 do
		local start, duration, runeReady = GetRuneCooldown( i)
		if not runeReady then
			self:TurnOff(self.cPoints[i], self.cPoints[i].Point, 0);
		else --if start then
			self:TurnOn( self.cPoints[i], self.cPoints[i].Point, 1);
		end
	end
end

function UpdateUnitPower( self)

	if myClass == "DEATHKNIGHT" then
		UpdateRunes( self)
		return
	end

	local charges = UnitPower("player", self.powerID);
	local showFX = charges == self.maxComboPoints and true or false

	for i = 1, self.maxComboPoints or 0 do
		if showFX then
			self.cPoints[i].BackFX:Show()
		else
			self.cPoints[i].BackFX:Hide()
		end

		if i <= charges then
			if (not self.cPoints[i].on) then
				self:TurnOn( self.cPoints[i], self.cPoints[i].Point, 1)
			end
		else
			if ( self.cPoints[i].on) then
				self:TurnOff( self.cPoints[i], self.cPoints[i].Point, 0);
			end
		end
	end

end

local function OnCPEvent( self, event, unit, powerType)

	if event == "UNIT_POWER_UPDATE" and self.powerType ~= powerType then
		return

	elseif event == "UNIT_MAXPOWER" then  --PLAYER_TALENT_UPDATE
		if powerType == self.powerType then
			for idx, frame in pairs(C_NamePlate.GetNamePlates()) do
        		CreateCPpoints( frame.UnitFrame)
        	end
        end

	elseif event == "UNIT_DISPLAYPOWER" then
		for idx, frame in pairs(C_NamePlate.GetNamePlates()) do
        	self:SetShown( isDruid( self))
        	--isDruid( self)
        end

	elseif myClass == "DEATHKNIGHT" then
		UpdateRunes( self)
	else
		UpdateUnitPower( self)
	end
end

function CreateCPpoints( f)
	if not N.pType[myClass].powerID then return end
	if N.pType[myClass].spec and N.pType[myClass].spec ~= GetSpecialization() then return end

	if not f.classPower then
		f.classPower = CreateFrame("Frame", nil, f)
		f.classPower:SetPoint("CENTER", f.healthBar, "BOTTOM", 0, 0)
		f.classPower:SetSize(60, 13)
		f.classPower:SetFrameStrata("MEDIUM")
		f.classPower:SetFrameLevel(100)
		f.classPower.TurnOff 	= ClassPowerBar.TurnOff
		f.classPower.TurnOn 	= ClassPowerBar.TurnOn
		f.classPower.powerID 	= N.pType[myClass].powerID
		f.classPower.powerType	= N.pType[myClass].powerType

		f.classPower:SetScript("OnEvent", OnCPEvent)
	end

	self = f.classPower

	local size = 8
	local maxComboPoints = UnitPowerMax("player", self.powerID);
	--print( maxComboPoints, self.powerID, UnitPowerMax("player", self.powerID))
	--if maxComboPoints == self.maxComboPoints then return end

	ClearCPoints( self)

	self.maxComboPoints = maxComboPoints or 0

	self.cPoints = CreateFrame("Frame", nil, self)
	self.cPoints:SetAllPoints()

	for i = 1, maxComboPoints do
		self.cPoints[i] = CreateFrame("Frame", nil, self) --, "ClassNameplateBarComboPointFrameYo")
		self.cPoints[i]:SetParent( self)
		self.cPoints[i]:SetSize( size, size)

		self.cPoints[i].Back = self.cPoints[i]:CreateTexture(nil, "BACKGROUND")
		self.cPoints[i].Back:SetPoint( "CENTER")
		self.cPoints[i].Back:SetSize(10, 10)
		self.cPoints[i].Back:SetAtlas( "ClassOverlay-ComboPoint-Off")
		self.cPoints[i].Back:SetAlpha( 1)

		self.cPoints[i].Point = self.cPoints[i]:CreateTexture(nil, "ARTWORK")
		self.cPoints[i].Point:SetPoint( "CENTER")
		self.cPoints[i].Point:SetSize(10, 10)
		self.cPoints[i].Point:SetAtlas( "ClassOverlay-ComboPoint")
		self.cPoints[i].Point:SetAlpha( 0)

		self.cPoints[i].BackFX = self.cPoints[i]:CreateTexture(nil, "OVERLAY")
		self.cPoints[i].BackFX:SetPoint( "CENTER")
		self.cPoints[i].BackFX:SetSize( 13, 13)
		self.cPoints[i].BackFX:SetAtlas( "ComboPoints-FX-Circle")
		self.cPoints[i].BackFX:SetAlpha( 0.8)
		self.cPoints[i].BackFX:Hide()

		SetUpAnimGroup( self.cPoints[i], "Fadein", 0, 1, 0.2, true, self.cPoints[i].Point)
		SetUpAnimGroup( self.cPoints[i], "Fadeout", 0, 1, 0.3, true, self.cPoints[i].Point)

		if i == 1 then
			self.cPoints[i]:SetPoint("LEFT", self, "LEFT", 0, 0)
		else
			self.cPoints[i]:SetPoint("LEFT", self.cPoints[i-1], "RIGHT", 1, 0)
		end
	end
	self:SetWidth( size * maxComboPoints)

	if myClass == "DEATHKNIGHT" then
		self:RegisterEvent("RUNE_POWER_UPDATE")
	else
		self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		self:RegisterUnitEvent("UNIT_MAXPOWER", "player")
		self:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
		--self:RegisterEvent("PLAYER_TALENT_UPDATE");
		--self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	end

	OnCPEvent( self)
end