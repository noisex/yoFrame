local lib = LibStub("LibCooldown")
if not lib then error("CooldownFlash requires LibCooldown") return end

local PlayerProcWhiteList = {}
local PlayerCDWhiteList = {}

local function UpdateAura( self, unit)
	local fligerTD, fligerTB, fligerPB, fligerPD, fligerProc = 1, 1, 1, 1, 1

	-- DEBUFFS
	local index = 1
	local filter = "HARMFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end
			
		if yo.fliger.tDebuffEnable then
			if unit == self.tDebuff.unit and caster == "player"	and DebuffWhiteList[name] then
				if not self.tDebuff[fligerTD] then self.tDebuff[fligerTD] = CreateAuraIcon( self.tDebuff, fligerTD, true, "BOTTOM")end
				UpdateAuraIcon( self.tDebuff[fligerTD], filter, icon, count, nil, duration, expirationTime, spellID, index)
				fligerTD = fligerTD + 1						
			end
		end
		
		if yo.fliger.pDebuffEnable then
			if unit == self.pDebuff.unit and not blackSpells[spellID] then
			--if unit == self.pDebuff.unit and RaidDebuffList[spellID] then
				if not self.pDebuff[fligerPD] then self.pDebuff[fligerPD] = CreateAuraIcon( self.pDebuff, fligerPD, false, "BOTTOM")end
				UpdateAuraIcon( self.pDebuff[fligerPD], filter, icon, count, nil, duration, expirationTime, spellID, index, unit)
				fligerPD = fligerPD + 1						
			end
		end

		index = index + 1
	end

	-- BUFFS
	local index = 1
	local filter = "HELPFUL"
	while true do
		local name, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura( unit, index, filter)
		if not name then break end
		
		if yo.fliger.tDebuffEnable then
			if unit == self.tDebuff.unit and caster == "player" and BuffWhiteList[name] then
				if not self.tDebuff[fligerTD] then self.tDebuff[fligerTD] = CreateAuraIcon( self.tDebuff, fligerTD, true, "BOTTOM")end
				UpdateAuraIcon( self.tDebuff[fligerTD], filter, icon, count, nil, duration, expirationTime, spellID, index)
				fligerTD = fligerTD + 1	
			end
		end
			
		if yo.fliger.pBuffEnable then
			if unit == self.pBuff.unit and PlayerBuffWhiteList[name] then
				if not self.pBuff[fligerPB] then self.pBuff[fligerPB] = CreateAuraIcon( self.pBuff, fligerPB, true, "BOTTOM")end
				UpdateAuraIcon( self.pBuff[fligerPB], filter, icon, count, nil, duration, expirationTime, spellID, index)
				fligerPB = fligerPB + 1
			end
		end

		if yo.fliger.pProcEnable then
			if unit == self.pProc.unit and PlayerProcWhiteList[name] then
				if not self.pProc[fligerProc] then self.pProc[fligerProc] = CreateAuraIcon( self.pProc, fligerProc, true, "BOTTOM")end
				UpdateAuraIcon( self.pProc[fligerProc], filter, icon, count, nil, duration, expirationTime, spellID, index)
				fligerProc = fligerProc + 1
			end
		end

		index = index + 1
	end	

	-- CLEARING
	if unit == "target" then
		for index = fligerTD,	#self.tDebuff	do self.tDebuff[index]:Hide()   end
	
	elseif unit == "player"	then
		for index = fligerPB,	#self.pBuff		do self.pBuff[index]:Hide()   end
		for index = fligerPD,	#self.pDebuff	do self.pDebuff[index]:Hide()   end
		for index = fligerProc,	#self.pProc		do self.pProc[index]:Hide()   end
	end	
end

local function UpdatePCD( watched)
	local frame = _G["yo_Fliger"]
	local fligerPCD = 1
	local icon
	
	--if watched then tprint(watched) end

	for id, val in pairs( watched) do
		local starttime = val.start
		local duration = val.duration
		local class = val.class
		local expirationTime = starttime + duration
		if class == "item" then
			icon = select( 10, GetItemInfo( id))
		else
			icon = select( 3, GetSpellInfo( id))
		end
		if starttime ~= 0 and duration  >= yo.fliger.pCDTimer then			
			--print(id, val.start, val.duration)
			if not frame.pCD[fligerPCD] then frame.pCD[fligerPCD] = CreateAuraIcon( frame.pCD, fligerPCD, true, "BOTTOM")end				
			UpdateAuraIcon( frame.pCD[fligerPCD], "HELPFUL", icon, 0, nil, duration, expirationTime, id, fligerPCD)
			fligerPCD = fligerPCD + 1
		end
	end

	for index = fligerPCD,	#frame.pCD	do frame.pCD[index]:Hide() end	
end

local function MakeFligerFrame( self)
	local pdebuffSize 	= yo.fliger.pDebuffSize
	local tdebuffSize 	= yo.fliger.tDebuffSize
	local pbuffSize 	= yo.fliger.pBuffSize
	local pProcSize		= yo.fliger.pProcSize
	local cdSize		= yo.fliger.pCDSize
	
	_G["P_DEBUFF"]:SetSize( pdebuffSize,pdebuffSize)
	_G["T_DEBUFF"]:SetSize(	tdebuffSize,tdebuffSize)
	_G["P_BUFF"]:SetSize(	pbuffSize, 	pbuffSize)
	_G["P_PROC"]:SetSize(	pProcSize, 	pProcSize)
	_G["P_CD"]:SetSize(		cdSize,		cdSize)
	--CreateAnchor("T_BUFF", 		"Target Buff", 	buffSize, 	buffSize,	400, 150, 	"CENTER", "CENTER")

	if yo.fliger.tDebuffEnable then
		local tDebuff = CreateFrame("Frame", nil, self)
		tDebuff:SetPoint("CENTER", T_DEBUFF, "CENTER",  0, 0)
		tDebuff:SetWidth( tdebuffSize)
		tDebuff:SetHeight( tdebuffSize)
		tDebuff.direction 	= yo.fliger.tDebuffDirect
		tDebuff.unit 		= "target"
		self.tDebuff 		= tDebuff
	end

	--local tBuff = CreateFrame("Frame", nil, self)
	--tBuff:SetPoint("TOPLEFT", T_BUFF, "TOPLEFT",  0, 0)
	--tBuff:SetWidth( buffSize * 10)
	--tBuff:SetHeight( buffSize)
	--tBuff.direction = "RIGHT"
	--tBuff.unit 		= "target"
	--tBuff.filter 	= "HELPFUL"
	--self.tBuff 		= tBuff	

	if yo.fliger.pProcEnable then
		local pProc = CreateFrame("Frame", nil, self)
		pProc:SetPoint("CENTER", P_PROC, "CENTER",  0, 0)
		pProc:SetWidth( pProcSize)
		pProc:SetHeight( pProcSize)
		pProc.direction = yo.fliger.pProcDirect
		pProc.unit 		= "player"
		self.pProc 		= pProc	
	end

	if yo.fliger.pBuffEnable then
		local pBuff = CreateFrame("Frame", nil, self)
		pBuff:SetPoint("CENTER", P_BUFF, "CENTER",  0, 0)
		pBuff:SetWidth( pbuffSize)
		pBuff:SetHeight( pbuffSize)
		pBuff.direction = yo.fliger.pBuffDirect
		pBuff.unit 		= "player"
		self.pBuff 		= pBuff	
	end

	if yo.fliger.pDebuffEnable then
		local pDebuff = CreateFrame("Frame", nil, self)
		pDebuff:SetPoint("CENTER", P_DEBUFF, "CENTER",  0, 0)
		pDebuff:SetWidth( pdebuffSize)
		pDebuff:SetHeight( pdebuffSize)
		pDebuff.direction 	= yo.fliger.pBuffDirect
		pDebuff.unit 		= "player"
		self.pDebuff 		= pDebuff
	end

	if yo.fliger.pCDEnable then
		local pCD = CreateFrame("Frame", nil, self)
		pCD:SetPoint("CENTER", P_CD, "CENTER",  0, 0)
		pCD:SetWidth( cdSize)
		pCD:SetHeight( cdSize)
		pCD.direction 	= yo.fliger.pCDDirect
		pCD.unit 		= "player"
		self.pCD 		= pCD		
	end
end

local function CheckTemplates( myClass, mySpec)
	for i,v in pairs( templates.class[myClass][mySpec][1]["args"]) do
		PlayerBuffWhiteList[GetSpellInfo( v.spell)] = true
	end

	for i,v in pairs( templates.class[myClass][mySpec][5]["args"]) do
		PlayerBuffWhiteList[GetSpellInfo( v.spell)] = true
	end

	for i,v in pairs( PlayerBuffWhiteListAll) do
		PlayerBuffWhiteList[GetSpellInfo( i)] = v
	end

	--PlayerCDWhiteList = {}
	--for i,v in pairs( templates.class[myClass][mySpec][3]["args"]) do
	--	local starttime, duration = GetSpellCooldown( GetSpellInfo( v.spell))
	--	if starttime then
	--		PlayerCDWhiteList[GetSpellInfo( v.spell)] = v.icon
	--	end		
	--end

	for i,v in pairs( templates.items[2]["args"]) do
		PlayerProcWhiteList[GetSpellInfo( v.spell)] = true
	end

	for i,v in pairs( templates.items[3]["args"]) do
		PlayerProcWhiteList[v.title] = true
	end

	for i,v in pairs( templates.items[4]["args"]) do
		PlayerProcWhiteList[v.title] = true
	end

	if yo.fliger.gAzetit then
		for i,v in pairs( generalAzeriteTraits) do
			PlayerProcWhiteList[GetSpellInfo( v.spell)] = true
		end
	end	
end

local function OnEvent( self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		if not yo.fliger.enable then return end
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterUnitEvent("UNIT_AURA", "player", "target")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

		if yo.fliger.pCDEnable then
			lib:RegisterCallback("start", function( id, duration, class, watched) UpdatePCD( watched) end)
			lib:RegisterCallback("stop", function(id, class, watched) UpdatePCD( watched) end)
		end				
		
		MakeFligerFrame( self)
		CheckTemplates( myClass, GetSpecialization())

	elseif event == "UNIT_AURA" then
		UpdateAura( self, ...)
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdateAura( self, "target")
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		CheckTemplates( myClass, GetSpecialization())
	end
end

local Fliger = CreateFrame("Frame", "yo_Fliger", UIParent)
Fliger:RegisterEvent("PLAYER_ENTERING_WORLD")
Fliger:SetScript("OnEvent", OnEvent)

--CreateAnchor("SPECIAL_P_BUFF_ICON_Anchor", "SPECIAL_P_BUFF",	C["filger"].buffs_size, C["filger"].buffs_size,			-300, -50, "CENTER", "CENTER")
