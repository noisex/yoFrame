local addon, ns = ...
local L, yo, N = unpack( ns)

local locationToFilter = {
	["HeadSlot"]	= 0,
	["NeckSlot"]	= 1,
	["ShoulderSlot"]= 2,
	["BackSlot"]	= 3,
	["ChestSlot"]	= 4,
	["WristSlot"]	= 5,
	["MainHandSlot"]= 10,
	["SecondaryHandSlot"]= 11,
	["HandsSlot"]	= 6,
	["WaistSlot"]	= 7,
	["LegsSlot"]	= 8,
	["FeetSlot"]	= 9,
	["Finger0Slot"]	= 12,
	["Finger1Slot"]	= 12,
	["Trinket0Slot"]= 13,
	["Trinket1Slot"]= 13,
}
--													todo: SELECT STATSCER
local function afterClearIcons( index)
	local frame = yo_DuLoot.scrollChild
	for i = index, #frame do
		frame[i]:Hide()
		frame[i].icon:SetTexture(nil)
		frame[i].nameItem:SetText("")
		--frame[i].nameDung:SetText("")
		frame[i].stats:SetText("")
		frame[i].onuse:SetText("")
		frame[i].onEquip :SetText("")
		frame[i].equipSet:SetText("")
		frame[i].iconBack:Hide()
		frame[i].bg:Hide()
	--	frame[i] = nil
	end
end

local function OnEnter( self)
	self.shadow:SetBackdropColor( 0.09, 0.09, 0.09, 0.9)
	GameTooltip:SetOwner( self, "ANCHOR_RIGHT", 20, 0)
	GameTooltip:SetHyperlink( self.link)
	GameTooltip:Show()
end

local function OnLeave( self)
	self.shadow:SetBackdropColor( 0.09, 0.09, 0.09, 0.4)
	GameTooltip:Hide()
end


local function CreateIcon( index)
	local frame, size = yo_DuLoot.scrollChild, 40

	if frame[index] then return frame[index] end

	local button = CreateFrame("Frame", nil, frame)
	button:SetHeight( size)

	if index == 1 then
		button:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -7)
		button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -7)
	else
		button:SetPoint("TOPLEFT", frame[index -1].equipSet, "BOTTOMLEFT", -50, -7)
		button:SetPoint("TOPRIGHT", frame[index -1].equipSet, "BOTTOMRIGHT", -10, -7)
	end

	local iconBack = CreateFrame("Frame", nil, button)
	iconBack:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -5)
	iconBack:SetWidth( size)
	iconBack:SetHeight( size)
	CreateStyle( iconBack, 2)

	local icon = button:CreateTexture(nil, "OVERLAY")
	icon:SetTexCoord( unpack( yo.tCoord))
	icon:SetAllPoints( iconBack)

	local nameItem = button:CreateFontString( nil, "OVERLAY")
	nameItem:SetFont( font, 13, "THINOUTLINE")
	nameItem:SetJustifyH("LEFT")
	nameItem:SetPoint("TOPLEFT", button, "TOPLEFT", 50, 0)
	nameItem:SetPoint("TOPRIGHT", button, "TOPRIGHT", 10, 0)

	--local nameDung = button:CreateFontString( nil, "OVERLAY")
	--nameDung:SetFont( font, 13, "THINOUTLINE")
	--nameDung:SetJustifyH("LEFT")
	--nameDung:SetPoint("TOPLEFT", nameItem, "BOTTOMLEFT", 0, -0)
	--nameDung:SetPoint("TOPRIGHT", nameItem, "BOTTOMRIGHT", 0, -0)

	local stats = button:CreateFontString( nil, "OVERLAY")
	stats:SetFont( font, 11)--, "THINOUTLINE")
	stats:SetJustifyH("LEFT")
	stats:SetPoint("TOPLEFT", nameItem, "BOTTOMLEFT", 0, -0)
	stats:SetPoint("TOPRIGHT", nameItem, "BOTTOMRIGHT", 0, -0)

	local onuse = button:CreateFontString( nil, "OVERLAY")
	onuse:SetFont( font, 10)--, "THINOUTLINE")
	onuse:SetJustifyH("LEFT")
	onuse:SetPoint("TOPLEFT", stats, "BOTTOMLEFT", 0, -0)
	onuse:SetPoint("TOPRIGHT", stats, "BOTTOMRIGHT", 0, -0)

	local onEquip = button:CreateFontString( nil, "OVERLAY")
	onEquip:SetFont( font, 10)--, "THINOUTLINE")
	onEquip:SetJustifyH("LEFT")
	onEquip:SetPoint("TOPLEFT", onuse, "BOTTOMLEFT", 0, -0)
	onEquip:SetPoint("TOPRIGHT", onuse, "BOTTOMRIGHT", 0, -0)

	local equipSet = button:CreateFontString( nil, "OVERLAY")
	equipSet:SetFont( font, 10)--, "THINOUTLINE")
	equipSet:SetJustifyH("LEFT")
	equipSet:SetPoint("TOPLEFT", onEquip, "BOTTOMLEFT", 0, -0)
	equipSet:SetPoint("TOPRIGHT", onEquip, "BOTTOMRIGHT", 0, -0)

	local bg = CreateFrame("FRame", nil, frame)
	bg:SetPoint("TOPLEFT", button, "TOPLEFT", -5, 1)
	bg:SetPoint("BOTTOMRIGHT", equipSet, "BOTTOMRIGHT", -5, 0)
	bg:SetScript("OnEnter", OnEnter)
	bg:SetScript("OnLeave", OnLeave)
	CreateStyle( bg, 2, 0, 0.3)

	button.nameItem = nameItem
	--button.nameDung = nameDung
	button.icon 	= icon
	button.stats 	= stats
	button.onuse 	= onuse
	button.onEquip 	= onEquip
	button.equipSet = equipSet
	button.iconBack = iconBack
	button.bg 		= bg

	frame[index] 	= button
	frame[index]:Show()
  	frame:SetHeight(40)

	--print( index, link)
	return button
end

local function checkDungeLoot( filterType)
	if not filterType then return end

	local index, instanceID, name, description, buttonImage, link  = 0, 0
	local class, _, classID = UnitClass('player')
	local frame = yo_DuLoot
	frame.filterType = filterType
	frame.headerKeeper.textHeader:SetText( class .. " / " .. frame.specLootName )

	EJ_SetLootFilter(classID, frame.specLootID )
	EJ_SetDifficulty( 23)
	--EJ_SetDifficulty( 23) -- 1, 2, 23 ( 8	Mythic Keystone	party	isHeroic, isChallengeMode)
	local indexLo = 1

	while instanceID do
		index = index + 1;
		instanceID, name, _, _, buttonImage, _, _, _, link = EJ_GetInstanceByIndex(index, false);
		C_EncounterJournal.ResetSlotFilter()
		C_EncounterJournal.SetSlotFilter( filterType);
		C_EncounterJournal.SetPreviewMythicPlusLevel( 15)

		if instanceID then
			EJ_SelectInstance( instanceID)
			if EJ_GetNumLoot() then
				for lootIndex = 1, EJ_GetNumLoot() do
					local temptext = ""
					local itemInfo = C_EncounterJournal.GetLootInfoByIndex( lootIndex)
					local loolButton = CreateIcon( indexLo, itemInfo.link, itemInfo.icon)
					loolButton.icon:SetTexture( itemInfo.icon)
					loolButton.nameItem:SetText( link .. " |r" .. itemInfo.link)
					--loolButton.nameDung:SetText( "")
					loolButton.bg.link = itemInfo.link
					loolButton.onuse:SetText("")
					loolButton.onEquip:SetText( "")
					loolButton.equipSet:SetText( "")
					loolButton.iconBack:Show()
					loolButton.bg:Show()

					--local item = Item:CreateFromItemLink( itemInfo.link)
					--print( indexLo, link, itemInfo.link)

					local stat = GetItemStats( itemInfo.link)
					for i, data in pairs(stat) do
						if i == "RESISTANCE0_NAME" then
						elseif i == "ITEM_MOD_STAMINA_SHORT" then
							temptext = temptext .. "|cff999999+" .. floor( data) .. " " .. _G[i] .. "\n|r"

						elseif i == "ITEM_MOD_INTELLECT_SHORT" or i == "ITEM_MOD_AGILITY_SHORT" or i == "ITEM_MOD_STRENGTH_SHOR	T" then
							temptext = temptext .. "|cff999999+" .. floor( data) .. " " .. _G[i] .. "\n|r"

						else
							temptext = temptext .. "|cff00ff00+" .. floor( data) .. " " .. _G[i] .. "\n|r"
							--statTable = GetItemStatDelta("item1Link", "item2Link" [, returnTable])
						end
					end
					loolButton.stats:SetText(temptext, 1, 1, 1, 0)

					local name, spellID = GetItemSpell( itemInfo.link)
					if name then
						local name, _, icon = GetSpellInfo(spellID)
						local cooldown = GetSpellBaseCooldown(spellID)
						local desc = GetSpellDescription(spellID)
					--	print( "|cff999999" .. ITEM_SPELL_TRIGGER_ONUSE .. " " .. desc, "Восстановление: " .. SecondsToClock(cooldown/1000)) -- ITEM_SPELL_TRIGGER_ONEQUIP = "Equip:"; ITEM_SPELL_TRIGGER_ONPROC = "Chance on hit:";
						temptext = "|cff999999" .. ITEM_SPELL_TRIGGER_ONUSE .. " " .. desc .. " Восстановление: " .. SecondsToClock(cooldown/1000)
						loolButton.onuse:SetText(temptext, 1, 1, 1, 0)
					end

					local tt = CreateFrame("GameTooltip", "yoFrame_ItemTooltip", UIParent, "GameTooltipTemplate")
					tt:SetOwner( UIParent, "ANCHOR_NONE")
					tt:SetHyperlink( itemInfo.link)
					tt:Show()

					for x = 5, tt:NumLines() do
						local line = _G['yoFrame_ItemTooltipTextLeft'..x]
						local lineText = line:GetText()
						if lineText then
							local lr, lg, lb = line:GetTextColor()
							if lineText:match( ITEM_SPELL_TRIGGER_ONEQUIP) then
								loolButton.onEquip:SetText( format( " %s%s ", hex( lr, lg, lb), lineText))

							elseif lineText:match( "Комплект ") then
								local itemSetID = select( 16, GetItemInfo( itemInfo.link))
								loolButton.equipSet:SetText( "|cffffff00" .. GetItemSetInfo( itemSetID) .. "\n|cff999999" .. lineText)
							end
						end
					end
					tt:Hide()

					loolButton:Show()
					indexLo = indexLo + 1
				end
			end
			yo_DuLoot:Show()
		end
	end
	afterClearIcons( indexLo)
end

local function CreateDuLoot( self)
	CreatePanel( self, 460, CharacterFrame:GetHeight(), "TOPLEFT", CharacterFrame, "TOPRIGHT", 10, 0, 0.6, 1)
	self:EnableMouse(true)
	self:SetClampedToScreen(true)
	self:SetMovable(true)
	self:SetResizable(true)
	self:SetUserPlaced(true)
	self:SetMinResize( 300, 420)
	self:RegisterForDrag( "LeftButton")
	self:SetScript("OnDragStart", 	function() self:StartMoving() end)
	self:SetScript("OnDragStop", 	function() self:StopMovingOrSizing() end)
	self:Hide()

	local headerKeeper = CreateFrame("Frame", nil, self)
	headerKeeper:SetPoint("TOPLEFT", self, "TOPLEFT", 3, -3)
	headerKeeper:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -5, -25)
	CreateStyle( headerKeeper, 2)

	local textHeader = headerKeeper:CreateFontString(nil, "OVERLAY")
	textHeader:SetFont( font, 13, "THINOUTLINE")
	textHeader:SetText("")
	textHeader:SetTextColor(1, 1, 0, 1)
	textHeader:SetPoint("TOP", headerKeeper, "TOP", 0, -2)

	local grabber = CreateFrame("Button", nil, headerKeeper)
	grabber:SetSize( 14, 14)
	grabber:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	grabber:SetNormalTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grabber:SetHighlightTexture( 	"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grabber:SetPushedTexture( 		"Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grabber:RegisterForDrag("LeftButton")
	grabber:SetScript("OnDragStart", function() self:StartSizing() end)
	grabber:SetScript("OnDragStop", function() 	self:StopMovingOrSizing() end)

	local close = CreateFrame("Button", nil, self, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", headerKeeper, "TOPRIGHT", 8, 7)

	headerKeeper.close 		= close
	headerKeeper.grabber 	= grabber
	headerKeeper.textHeader = textHeader

	scrollFrame = CreateFrame("ScrollFrame", nil, self, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -25)
	scrollFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -3, 3)

	local scrollBar = scrollFrame.ScrollBar --= _G[addon.."ScrollBar"]
	scrollBar:ClearAllPoints()
	scrollBar:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, -17)
	scrollBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 25, 17)

	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollChild:SetWidth( scrollFrame:GetWidth())

	scrollFrame:SetScrollChild(scrollChild)
	scrollFrame:SetResizable(true)
	scrollFrame:SetUserPlaced(true)
	scrollFrame:SetScript("OnSizeChanged", function(self) scrollChild:SetWidth(self:GetWidth()) end)

	self.headerKeeper	= headerKeeper
	self.scrollFrame 	= scrollFrame
	self.scrollChild 	= scrollChild
end

local function OnEvent( self, event, ...)
	local id, name, _, icon = GetSpecializationInfo( GetSpecialization())
	self.specID 	= id
	self.specName 	= name
	self.specIcon 	= icon

	local lootID = GetLootSpecialization()
	local lootid, lootname, _, looticon = GetSpecializationInfoByID( lootID)

	if lootID == 0 then
		self.specLootID 	= id
		self.specLootIcon	= icon
		self.specLootName 	= name
	else
		self.specLootID 	= lootid
		self.specLootIcon 	= looticon
		self.specLootName 	= lootname
	end

	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		CreateDuLoot( self)
	else
		checkDungeLoot( self.filterType)
	end
end

local duLoot = CreateFrame("Frame", "yo_DuLoot", UIParent)
duLoot:RegisterEvent("PLAYER_ENTERING_WORLD")
duLoot:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
duLoot:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
duLoot:SetScript("OnEvent", OnEvent)

for _, slot in pairs(N.slots) do
	local button = _G["Character"..slot]
	button.filterType = locationToFilter[slot]
	button:HookScript( "OnClick", function(self, but)
		if but == "RightButton" then checkDungeLoot( self.filterType) end
	end)
end























					--local tt = CreateFrame("GameTooltip", "yoFrame_ItemTooltip", UIParent, "GameTooltipTemplate")
					--tt:SetOwner( UIParent, "ANCHOR_NONE")
					--tt:SetBagItem(bagID, slotID)
					--tt:Show()

					--for x = 1, tt:NumLines() do
					--	local lineR = _G['yoFrame_ItemTooltipTextRight'..x]
					--	local lineTextR = lineR:GetText()
					--	if lineTextR then
					--		local lr, lg, lb = lineR:GetTextColor()
					--		if lg > 0.5 then
					--			--print( L["weared"] .. clink)
					--			equipItem( bagID, slotID, clink, iLvl)
					--		end
					--	end
					--end
					--tt:Hide()

--local function GetLFGLockList()
--	local lockInfo = C_LFGInfo.GetLFDLockStates();
--	local lockMap = {};
--	for _, lock in ipairs(lockInfo) do
--		lockMap[lock.lfgID] = lock;
--	end
--	return lockMap;
--end

----local raidList = GetLFRChoiceOrder();
--	--tprint( raidList)
--LFDDungeonList1 = {}
--LFGLockList1 = GetLFGLockList();
----tprint( LFGLockList)
--local dungeonList = GetLFDChoiceOrder();

--for _, dungeonID in ipairs(dungeonList) do
--	if tonumber( dungeonID) > 0 and not LFGLockList1[dungeonID] then --or not LFGLockList1[dungeonID].hideEntry then
--		table.insert(LFDDungeonList1, dungeonID);
--		--print( dungeonID, LFGLockList1[dungeonID])--, LFGLockList1[dungeonID].hideEntry)
--		local name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel = GetLFGDungeonInfo(dungeonID)
--		--print( dungeonID, name, typeID, subtypeID, expansionLevel, difficulty, isHoliday, bonusRepAmount, isTimeWalker)
--	end
--end


--tprint( dungeonList)

	--local mapID = C_Map.GetBestMapForUnit("player");
	--local instanceID = mapID and EJ_GetInstanceForMap(1594) or 0;

	--local hasLoot = C_EncounterJournal.InstanceHasLoot( 1012)
	--local difficultyID = EJ_GetDifficulty();
	----print( mapID, instanceID, hasLoot, EJ_GetNumLoot(), difficultyID) --EJ_GetInstanceInfo())

	--local mapID = C_Map.GetBestMapForUnit("player");
	--local instanceID = mapID and EJ_GetInstanceForMap(mapID) or 0;
	----print(mapID, instanceID)

	------C_EncounterJournal.InstanceHasLoot([instanceID])
	------name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers, isTimeWalker, name2, minGearLevel = GetLFGDungeonInfo(dungeonID)
