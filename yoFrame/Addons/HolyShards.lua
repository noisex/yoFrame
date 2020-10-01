local L, yo, N = unpack( select( 2, ...))

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GetShapeshiftFormID, UnitPower, GetSpecialization, UnitPowerMax, GetRuneCooldown
	= GetShapeshiftFormID, UnitPower, GetSpecialization, UnitPowerMax, GetRuneCooldown

local recolorShards = function(self, cols)
	for i = 1, self.idx do
		self[i]:SetStatusBarColor( cols[1], cols[2], cols[3], 1)
	end

	--if yo.Raid.classcolor == 1 then
	--	self.shadow:SetBackdropBorderColor( 0.3, 0.3, 0.3, 0.9)
	--else
	--	self.shadow:SetBackdropBorderColor( cols[1], cols[2], cols[3], 0.6)
	--end
end

local function pwUpdate( self, powerID)
	local unitPower = UnitPower( self.unit, powerID)	--, true)

	for i = 1, min( unitPower, #self) do
		if not self[i].on then
			self:TurnOn( self[i], self[i], self.maxAlpha)
		end
	end
	for i = unitPower + 1, #self do
		if self[i].on then
			self:TurnOff( self[i], self[i], self.minAlpha);
		end
	end

	if unitPower == self.idx and myClass ~= "DEATHKNIGHT" then
		if yo.Raid.classcolor == 1 then
			self.shadow:SetBackdropBorderColor( 0.3, 0.3, 0.3, 0.9)
		else
			self.shadow:SetBackdropBorderColor( self:GetParent().colr, self:GetParent().colg, self:GetParent().colb, 0.6)
		end
	else
		self.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 0.7)
	end
end

 local function CreateShards( self)

	if #self then
		for i = 1, #self do
			Kill( self[i])
		end
	end
	self.shadow:Hide()

	if not self.powerID or ( self.spec and self.spec ~= GetSpecialization()) then return end

	self.idx = UnitPowerMax( self.unit, self.powerID)
	self:SetWidth( plFrame:GetWidth() / 2)
	--self.colr, self.colg, self.colb = self:GetParent().colr, self:GetParent().colg, self:GetParent().colb

	for i = 1, self.idx do
		self[i] = CreateFrame('StatusBar', nil, self)
		self[i]:SetStatusBarTexture( yo.texture)
		--self[i]:SetStatusBarColor( self.colr, self.colg, self.colb, 1)
		self[i]:SetHeight( self:GetHeight())
		self[i]:SetWidth(self:GetWidth() / self.idx)
		self[i]:SetAlpha( self.minAlpha)
		self[i]:SetFrameLevel(10)
		table.insert( N.statusBars, self[i])

		if i == 1 then
			self[i]:SetPoint('LEFT', self, 'LEFT', 1, 0)
		else
			self[i]:SetPoint('LEFT', self[i-1], 'RIGHT', 1, 0)
		end

		SetUpAnimGroup( self[i], "Fadein", 0.2, 0.8, 0.4, true)
		SetUpAnimGroup( self[i], "Fadeout", 0.2, 0.8, 0.7, true)
	end

	self:SetWidth( self:GetWidth() + self.idx + 1)
	self.shadow:Show()

	self:SetShown( isDruid( self))
	pwUpdate( self, self.powerID)
end

local function OnEvent( self, event, unit, pToken, ...)
	--print( event, " ptoken: ", pToken, " Type: ", yo.pType[myClass].powerID, unit)

	if event == "RUNE_POWER_UPDATE" then

		for i = 1, self.idx do
			local start, duration, runeReady = GetRuneCooldown( i)
			--print( start, runeReady, i)
			if runeReady then
				self[i]:SetAlpha(1)
				self[i]:SetScript("OnUpdate", nil)
				self[i]:SetValue( 10)
			elseif start then
				self[i]:SetAlpha( .4)
				self[i]:SetMinMaxValues( 0, duration)
				self[i].mini = GetTime() - start
				self[i].id = i
				self[i].start = start
				self[i].duration = duration

				self[i]:SetScript("OnUpdate", function(self, elapsed)
					local value = self.mini + elapsed
					self:SetValue( value)
					self.mini = value
				end)
			end

			--self.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end

	elseif event == "UNIT_MAXPOWER" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		mySpec = GetSpecialization()
		CreateShards( self)

	elseif event == "UNIT_DISPLAYPOWER" then
		self:SetShown( isDruid( self))
		--isDruid( self)

	elseif self.powerType and self.powerType == pToken then
		pwUpdate( self, self.powerID, ...)

	elseif event == "UNIT_ENTERED_VEHICLE" then
		self:Hide()

	elseif event == "UNIT_EXITED_VEHICLE" then
		CreateShards( self)

	end

 end

local function CreateShardsBar( f)
	local holyShards = f.holyShards or CreateFrame( "Frame", nil, f)
	holyShards:SetPoint('TOPLEFT', f, 'TOPLEFT', 7, -5)
	holyShards:SetWidth( f:GetWidth() / 2)
	holyShards:SetHeight( 5)
	holyShards:SetFrameLevel(9)

	holyShards:RegisterUnitEvent("UNIT_POWER_UPDATE", f.unit)
	holyShards:RegisterUnitEvent("UNIT_DISPLAYPOWER", f.unit)
	holyShards:RegisterEvent("RUNE_POWER_UPDATE")
	holyShards:RegisterUnitEvent("UNIT_MAXPOWER", f.unit)
	holyShards:RegisterEvent("PLAYER_TARGET_CHANGED")
	holyShards:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	holyShards:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', "player")
	holyShards:RegisterUnitEvent('UNIT_EXITED_VEHICLE', "player")

	holyShards:SetScript("OnEvent", OnEvent)
	CreateStyle( holyShards, 1, 5)

	holyShards.colr, holyShards.colg, holyShards.colb = f.colr, f.colg, f.colb
	holyShards.powerID 	= yo.pType[myClass].powerID
	holyShards.powerType= yo.pType[myClass].powerType
	holyShards.spec 	= yo.pType[myClass].spec
	holyShards.minAlpha = 0.2
	holyShards.maxAlpha = 0.9
	holyShards.TurnOff 	= ClassPowerBar.TurnOff
	holyShards.TurnOn 	= ClassPowerBar.TurnOn
	holyShards.unit 	= f.unit
	holyShards.recolorShards	= recolorShards

	f.holyShards = holyShards
	CreateShards( f.holyShards)
end

local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.unitFrames then return end
	if yo.pType[myClass] and yo.pType[myClass].powerID then
		CreateShardsBar( plFrame)
		--CreateShardsBar( tarFrame)
	end
end)


	--for i = 1, self.idx do
	--	if i <= unitPower then
	--		if not self[i].on then
	--			local alphaValue = self[i]:GetAlpha();
	--			self[i].fadein:Stop();
	--			self[i].fadeout:Stop();
	--			self[i].on = true
	--			if alphaValue < self.maxAlpha then
	--				self[i].fadein.anim:SetFromAlpha( alphaValue);
	--				self[i].fadein:Play()
	--			end
	--		end
	--	else
	--		if self[i].on then
	--			local alphaValue = self[i]:GetAlpha();
	--			self[i].fadein:Stop();
	--			self[i].fadeout:Stop();
	--			self[i].on = false
	--			if alphaValue > self.minAlpha then
	--				self[i].fadeout.anim:SetFromAlpha( alphaValue);
	--				self[i].fadeout:Play()
	--			end
	--		end
	--	end
	--end

	--for i = 1, min( charges, self.maxComboPoints) do
	--	if (not self.cPoints[i].on) then
	--		self:TurnOn( self.cPoints[i], self.cPoints[i].Point, 1)
	--	end
	--end
	--for i = charges + 1, self.maxComboPoints do
	--	if ( self.cPoints[i].on) then
	--		self:TurnOff( self.cPoints[i], self.cPoints[i].Point, 0);
	--	end
	--end

	--if charges == self.maxComboPoints then
	--	for i = 1, self.maxComboPoints do
	--		local alpga = self.cPoints[i].BackFX:GetAlpha()
	--		self.cPoints[i].BackFX:SetAlpha(0.8)
	--		print( "ONN: :", i, alpga, self.cPoints[i].BackFX:GetAlpha())
	--	end
	--else
	--	for i = 1, self.maxComboPoints do
	--		local alpga = self.cPoints[i].BackFX:GetAlpha()
	--		self.cPoints[i].BackFX:SetAlpha( 0)
	--		print( "OFF: ", i, alpga, self.cPoints[i].BackFX:GetAlpha())
	--	end
	--end