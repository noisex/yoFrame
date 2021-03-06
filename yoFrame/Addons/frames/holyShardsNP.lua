local L, yo, n = unpack( select( 2, ...))

if not yo.NamePlates.enable or not yo.NamePlates.showResourses then return end

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local C_NamePlate, UnitPower, isDruid, GetSpecialization, CreateFrame, UnitPowerMax, GetRuneCooldown, SetUpAnimGroup
	= C_NamePlate, UnitPower, isDruid, GetSpecialization, CreateFrame, UnitPowerMax, GetRuneCooldown, SetUpAnimGroup
-----------------------------------------------------------------------------------
--- COMBO POINTS
-----------------------------------------------------------------------------------

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

n.updateUnitPower = function ( self)

	if n.myClass == "DEATHKNIGHT" then
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

			local maxComboPoints = UnitPowerMax("player", self.powerID);

			for idx, frame in pairs(C_NamePlate.GetNamePlates()) do
        		n.createCPpoints( frame.unitFrame, maxComboPoints)
        	end
        end

	elseif event == "UNIT_DISPLAYPOWER" then
		for idx, frame in pairs(C_NamePlate.GetNamePlates()) do
        	self:SetShown( isDruid( self))
        	--isDruid( self)
        end

	elseif n.myClass == "DEATHKNIGHT" then
		UpdateRunes( self)
	else
		n.updateUnitPower( self)
	end
end

n.createCPpoints = function ( f, maxComboPoints)

	if not n.pType[n.myClass].powerID then return end
	if n.pType[n.myClass].spec and n.pType[n.myClass].spec ~= GetSpecialization() then return end

	if not f.classPower then
		f.classPower = f.classPower or CreateFrame("Frame", nil, f)
		f.classPower:SetPoint("CENTER", f.Health, "BOTTOM", 0, 0)
		f.classPower:SetSize(60, 13)
		f.classPower:SetFrameStrata("MEDIUM")
		f.classPower:SetFrameLevel(100)
		f.classPower.TurnOff 	= ClassPowerBar.TurnOff
		f.classPower.TurnOn 	= ClassPowerBar.TurnOn
		f.classPower.powerID 	= n.pType[n.myClass].powerID
		f.classPower.powerType	= n.pType[n.myClass].powerType

		f.classPower:SetScript("OnEvent", OnCPEvent)

		if n.myClass == "DEATHKNIGHT" then
			f.classPower:RegisterEvent("RUNE_POWER_UPDATE")
		else
			f.classPower:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			f.classPower:RegisterUnitEvent("UNIT_MAXPOWER", "player")
			f.classPower:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
			--f.classPower:RegisterEvent("PLAYER_TALENT_UPDATE");
			--f.classPower:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		end
	end

	local self = f.classPower

	local size = 8

	self.maxComboPoints = maxComboPoints or UnitPowerMax("player", self.powerID);

	self.cPoints = self.cPoints or CreateFrame("Frame", nil, self)
	self.cPoints:SetAllPoints()

	for i = 1, self.maxComboPoints do
		if not self.cPoints[i] then
			self.cPoints[i] = CreateFrame("Frame", nil, self) --, "ClassNameplateBarComboPointFrameYo")
			self.cPoints[i]:SetParent( self)
			self.cPoints[i]:SetSize( size, size)
			self.cPoints[i]:Show()

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
	end

	for i = self.maxComboPoints +1, #self.cPoints do self.cPoints[i]:Hide() end

	self:SetWidth( size * self.maxComboPoints)
	OnCPEvent( self)
end