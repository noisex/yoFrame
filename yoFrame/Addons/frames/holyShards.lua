local L, yo, n = unpack( select( 2, ...))

if not yo.UF.unitFrames or not yo.UF.showShards	then return end

local yoUF = n.Addons.unitFrames

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

local GetShapeshiftFormID, UnitPower, GetSpecialization, UnitPowerMax, GetRuneCooldown, CreateFrame, isDruid, GetTime, CreateStyle, tinsert, SetUpAnimGroup
	= GetShapeshiftFormID, UnitPower, GetSpecialization, UnitPowerMax, GetRuneCooldown, CreateFrame, isDruid, GetTime, CreateStyle, tinsert, SetUpAnimGroup

local recolorShards = function(self, cols)
	self.cols = cols or self.cols
	for i = 1, self.idx do
		self[i]:SetStatusBarColor( cols[1], cols[2], cols[3], 1)
	end
end

local function pwUpdate( self, powerID)
	local unitPower = UnitPower( self.unit, powerID)
	local idx 		= UnitPowerMax( self.unit, powerID)

	if idx ~= self.idx then  CreateShards( self) end

	for i = 1, min( unitPower, #self) do
		if not self[i].on or self[i]:GetAlpha() < self.maxAlpha then
			self:TurnOn( self[i], self[i], self.maxAlpha)
		end
	end

	for i = unitPower + 1, self.idx do
		if self[i].on then
			self:TurnOff( self[i], self[i], self.minAlpha);
		end
	end

	if unitPower == self.idx and n.myClass ~= "DEATHKNIGHT" then
		if yo.Raid.classcolor < 3 then
			local f = 0.7
			self.shadow:SetBackdropBorderColor( self.cols[1] *f, self.cols[2] *f, self.cols[3] *f, 0.99)
		else
			self.shadow:SetBackdropBorderColor( self.cols[1], self.cols[2], self.cols[3], 0.6)
		end
	else
		self.shadow:SetBackdropBorderColor( 0.09, 0.09, 0.09, 0.6)
	end
end

 local function CreateShards( self)

	if not self.powerID or ( self.spec and self.spec ~= GetSpecialization()) then
		self:Hide()
		return
	else
		self:Show()
	end

	self.idx = UnitPowerMax( self.unit, self.powerID)
	self:SetWidth( self:GetParent():GetWidth() / 2)

	if not self.cols then
		self.cols = {}
		self.cols[1] = self:GetParent().colr
		self.cols[2] = self:GetParent().colg
		self.cols[3] = self:GetParent().colb
	end
	--print ( "IDX = ", self.idx, self, self.cols[1], self.cols[2], self.cols[3])
	for i = 1, self.idx do
		self[i] = self[i] or CreateFrame('StatusBar', nil, self)
		self[i]:SetStatusBarTexture( n.texture)
		self[i]:SetStatusBarColor( self.cols[1], self.cols[2], self.cols[3],  1)
		self[i]:SetHeight( self:GetHeight() -2)
		self[i]:SetWidth(self:GetWidth() / self.idx)
		self[i]:SetAlpha( self.minAlpha)
		self[i]:SetFrameLevel(10)
		self[i]:Show()
		self[i].cols = self.cols
		self[i].colr = self:GetParent().colr
		self[i].colg = self:GetParent().colg
		self[i].colb = self:GetParent().colb
		--tinsert( n.Addons.elements.statusBars, self[i])

		if i == 1 then
			self[i]:SetPoint('LEFT', self, 'LEFT', 1, 0)
		else
			self[i]:SetPoint('LEFT', self[i-1], 'RIGHT', 1, 0)
		end

		if not self[i].Fadein then
			SetUpAnimGroup( self[i], "Fadein", 0.2, 0.9, 0.4, true)
			SetUpAnimGroup( self[i], "Fadeout", 0.2, 0.9, 0.7, true)
		end
	end

	for i = self.idx +1, #self do self[i]:Hide() end

	self:SetWidth( self:GetWidth() + self.idx + 1)
	self.shadow:Show()

	self:SetShown( isDruid( self))
	pwUpdate( self, self.powerID)
end

local function OnEvent( self, event, unit, pToken, ...)
	--print( event, " ptoken: ", pToken, " Type: ", n.pType[n.myClass].powerID, unit)

	if event == "RUNE_POWER_UPDATE" then

		if unit <= self.idx then
			local i = unit
			local start, duration = GetRuneCooldown( i)

			if start then
				self[i]:SetAlpha( .4)
				self[i]:SetMinMaxValues( 0, duration)
				self[i].mini = GetTime() - start
				self[i].id = i
				self[i].start = start
				self[i].duration = duration

				self[i]:SetScript("OnUpdate", function(self, elapsed)
					self.mini = self.mini + elapsed
					self:SetValue( self.mini)
					if self.mini >= self.duration then
						self:SetAlpha(1)
						self:SetScript("OnUpdate", nil)
						self:SetValue( 10)
					end
				end)
			end
		end

	elseif event == "UNIT_MAXPOWER" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		n.mySpec 		= GetSpecialization()
		n.mySpecNum	= GetSpecializationInfo( n.mySpec)
		CreateShards( self)

	elseif event == "UNIT_DISPLAYPOWER" then
		self:SetShown( isDruid( self))
		CreateShards( self)
		--isDruid( self)

	elseif event == "UNIT_POWER_UPDATE" and self.powerType and self.powerType == pToken then
		pwUpdate( self, self.powerID, ...)

	elseif event == "UNIT_ENTERED_VEHICLE" then
		self:Hide()

	elseif event == "UNIT_EXITED_VEHICLE" or event == "ZONE_CHANGED_NEW_AREA" then
		--self:Show()
		CreateShards( self)
	end
 end

function n.createShardsBar( f)
	local holyShards = f.holyShards or CreateFrame( "Frame", nil, f)

	if yo.UF.simpleUF then
		holyShards:SetPoint('LEFT', f, 'LEFT', 3, 2)
	else
		holyShards:SetPoint('TOPLEFT', f, 'TOPLEFT', 7, -4)
	end

	holyShards:SetWidth( f:GetWidth() / 2)
	holyShards:SetHeight( yo.UF.powerHeight + 2)
	holyShards:SetFrameLevel(9)

	holyShards:RegisterUnitEvent("UNIT_POWER_UPDATE", f.unit)
	holyShards:RegisterUnitEvent("UNIT_DISPLAYPOWER", f.unit)
	holyShards:RegisterEvent("RUNE_POWER_UPDATE")
	holyShards:RegisterUnitEvent("UNIT_MAXPOWER", f.unit)
	holyShards:RegisterEvent("PLAYER_TARGET_CHANGED")
	holyShards:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	holyShards:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	holyShards:RegisterUnitEvent('UNIT_ENTERED_VEHICLE', "player")
	holyShards:RegisterUnitEvent('UNIT_EXITED_VEHICLE', "player")

	holyShards:SetScript("OnEvent", OnEvent)
	CreateStyle( holyShards, 2, 5, 0.6)

	holyShards.colr, holyShards.colg, holyShards.colb = f.colr, f.colg, f.colb
	holyShards.powerID 	= n.pType[n.myClass].powerID
	holyShards.powerType= n.pType[n.myClass].powerType
	holyShards.spec 	= n.pType[n.myClass].spec
	holyShards.minAlpha = 0.2
	holyShards.maxAlpha = 0.9
	holyShards.TurnOff 	= ClassPowerBar.TurnOff
	holyShards.TurnOn 	= ClassPowerBar.TurnOn
	holyShards.unit 	= f.unit
	holyShards.idx 		= 0
	holyShards.recolorShards	= recolorShards

	f.holyShards = holyShards
	CreateShards( f.holyShards)
end

--local logan = CreateFrame("Frame")
--logan:RegisterEvent("PLAYER_ENTERING_WORLD")

--logan:SetScript("OnEvent", function(self, event)
--	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	--if not yo.UF.simpleUF then return end

--end)