local L, yo, n = unpack( select( 2, ...))

local logon = CreateFrame("Button", "Butsu", UIParent, BackdropTemplateMixin and "BackdropTemplate")
local title = logon:CreateFontString(nil, "OVERLAY")

local UnitIsDead, UnitName, UnitIsFriend, GetNumLootItems, GameTooltip, GetLootSlotLink, GetCVar, GetLootSlotInfo, pairs, GetCursorPosition, CreateFrame, max, GetBuildInfo, CursorUpdate, ResetCursor
	= UnitIsDead, UnitName, UnitIsFriend, GetNumLootItems, GameTooltip, GetLootSlotLink, GetCVar, GetLootSlotInfo, pairs, GetCursorPosition, CreateFrame, math.max, GetBuildInfo, CursorUpdate, ResetCursor

local IsModifiedClick, IsAltKeyDown, HandleModifiedItemClick, LootSlot, CloseLoot, IsFishingLoot
	= IsModifiedClick, IsAltKeyDown, HandleModifiedItemClick, LootSlot, CloseLoot, IsFishingLoot

local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS

local iconSize = 30
local frameScale = 1

local sq, ss, sn

local OnEnter = function(self)
	local slot = self:GetID()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetLootItem(slot)
	CursorUpdate(self)

	self.drop:Show()
	self.drop:SetVertexColor( 0, 0, 0)
end

local OnLeave = function(self)
	if self.quality then
		if(self.quality > 1) then
			local color = ITEM_QUALITY_COLORS[self.quality]
			self.drop:SetVertexColor(color.r, color.g, color.b)
		else
			self.drop:Hide()
		end
	end

	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if not self:GetID() then return end

	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		ss = self:GetID()
		--sq = self.quality
		--sn = self.name:GetText()
		--st = self.icon:GetTexture()

		-- master looter
		--LootFrame.selectedLootButton = self:GetName()
		--LootFrame.selectedSlot = ss
		--LootFrame.selectedQuality = sq
		--LootFrame.selectedItemName = sn
		--LootFrame.selectedTexture = st

		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local media = {
	["backdrop1"] = texture,
	["backdrop"] =  texture,
	["checked"] = "Interface\\AddOns\\Aurora\\CheckButtonHilight",
	["glow"] = yo.Media.texglow
}

local CreateBD = function(f, a)
	local wowversion, wowbuild, wowdate, wowtocversion = GetBuildInfo()
	if (wowtocversion > 90000) then Mixin( f, BackdropTemplateMixin) end

	f:SetBackdrop({
		bgFile = media.backdrop,
		edgeFile = media.glow,
		edgeSize = 2,
	})
	f:SetBackdropColor(.05,.05,.05, a or 0.9)
	f:SetBackdropBorderColor(0, 0, 0)
end

local createSlot = function(id)
	local iconsize = iconSize
	local frame = CreateFrame("Button", 'ButsuSlot'..id, logon)
	frame:SetPoint("LEFT", 4, 0)
	frame:SetPoint("RIGHT", -4, 0)
	frame:SetHeight(30)
	frame:SetID(id)
	CreateBD(frame)

	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(30)
	iconFrame:SetWidth(30)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame)
	CreateBD(iconFrame)

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(1)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.icon = icon

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, -1, 2)
	count:SetFont( n.font, n.fontsize, "OUTLINE")
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:ClearAllPoints()
	name:SetPoint("LEFT", frame, 2, 0)
	name:SetPoint("RIGHT", icon, "LEFT")
	name:SetNonSpaceWrap(false)
	name:SetFont( n.font, n.fontsize, "OUTLINE")
	frame.name = name

	local drop = frame:CreateTexture(nil, "ARTWORK")
	drop:SetTexture"Interface\\QuestFrame\\UI-QuestLogTitleHighlight"

	drop:SetPoint("LEFT", icon, "RIGHT", 0, 0)
	drop:SetPoint("RIGHT", frame)
	drop:SetAllPoints(frame)
	drop:SetAlpha(.3)
	frame.drop = drop

	logon.slots[id] = frame
	return frame
end

local anchorSlots = function(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint("TOP", logon, 4, (-4 + iconsize) - (shownSlots * iconsize))
		end
	end

	self:SetHeight( max(shownSlots * iconsize + 8, 20))
end

title:SetFont( n.font, n.fontsize, "OUTLINE")
title:SetPoint("TOP", logon, "TOP", 0, 15)

logon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
logon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
logon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
logon:SetMovable(true)
logon:RegisterForClicks"anyup"

logon:SetParent( UIParent)
--logon:SetUserPlaced(true)
logon:SetPoint("TOP", yoMoveLoot, "TOP", 0, 0)
CreateStyle(logon, 2)

logon:SetWidth(200)
logon:SetHeight(60)
--logon:SetBackdropColor(.05,.05,.05,0)
--logon:Hide()

--logon:SetClampedToScreen(true)
--logon:SetClampRectInsets(0, 0, 14, 0)
--logon:SetHitRectInsets(0, 0, -14, 0)
logon:SetFrameStrata"HIGH"
logon:SetToplevel(true)

logon.slots = {}

logon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(L.loot_fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title:SetText(UnitName"target")
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1000") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint("TOP", yoMoveLoot, "TOP", 0, 0)
	end

	local m, w, t = 0, 0, title:GetStringWidth()
	if(items > 0) then
		for i=1, items do
			local slot = logon.slots[i] or createSlot(i)
			local texture, item, quantity, _, quality, locked = GetLootSlotInfo(i)

			if texture then
				local color = ITEM_QUALITY_COLORS[quality]

				local r, g, b = color.r, color.g, color.b

--				print( texture, item, quantity, quality, r, g, b, color)

				if(quantity > 1) then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				if quality > 1 then
					slot.drop:SetVertexColor( r, g, b)
					slot.drop:Show()
				else
					slot.drop:Hide()
				end

				slot.quality = quality
				m = max(m, quality)
				w = max(w, slot.name:GetStringWidth())

				slot.name:SetText(item)
				slot.name:SetTextColor( r, g, b)
				slot.icon:SetTexture(texture)

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = logon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText( "loot empty")
		slot.name:SetTextColor( 1, 1, 1)
		slot.icon:SetColorTexture( 0, 1, 1, 0.5)
		--slot.icon:SetColorTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1
		w = max(w, slot.name:GetStringWidth())

		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(self)

	w = w + 60
	t = t + 5

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	--self:SetWidth(math.max(w, t))
end

logon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) and logon.slots[slot] then return end

	logon.slots[slot]:Hide()
	anchorSlots(self)
end

logon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
end

logon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(nil, nil, GroupLootDropDown, logon.slots[ss], 0, 0)
end

logon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

logon.ADDON_LOADED = function(self, event, logon)
	if(logon == "Butsu") then
		--title:SetFont( n.font, n.fontsize, "OUTLINE")

		db = setmetatable({}, {__index = defaults})

		self:SetScale(frameScale)

		-- clean up.
		self[event] = nil
		self:UnregisterEvent(event)
	end
end

logon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

logon:RegisterEvent"LOOT_OPENED"
logon:RegisterEvent"LOOT_SLOT_CLEARED"
logon:RegisterEvent"LOOT_CLOSED"
logon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
logon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
logon:RegisterEvent"ADDON_LOADED"
logon:Hide()
-- Fuzz
LootFrame:UnregisterAllEvents()
--table.insert(UISpecialFrames, "Butsu")

--local hexColors = {}
--for k, v in pairs(RAID_CLASS_COLORS) do
--	hexColors[k] = "|c"..v.colorStr
--end
--hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6 * 255, 0.6 * 255, 0.6 * 255)

--if CUSTOM_CLASS_COLORS then
--	local function update()
--		for k, v in pairs(CUSTOM_CLASS_COLORS) do
--			hexColors[k] = "|c"..v.colorStr
--		end
--	end
--	CUSTOM_CLASS_COLORS:RegisterCallback(update)
--	update()
--end

--local playerName = UnitName("player")
--local classesInRaid = {}
--local players, player_indices = {}, {}
--local randoms = {}
--local wipe = table.wipe

--local function MasterLoot_RequestRoll(frame)
--	DoMasterLootRoll(frame.value)
--end

--local function MasterLoot_GiveLoot(frame)
--	MasterLooterFrame.slot = LootFrame.selectedSlot
--	MasterLooterFrame.candidateId = frame.value
--	if LootFrame.selectedQuality >= MASTER_LOOT_THREHOLD then
--		StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[LootFrame.selectedQuality].hex..LootFrame.selectedItemName..FONT_COLOR_CODE_CLOSE, frame:GetText() or UNKNOWN, "LootWindow")
--	else
--		GiveMasterLoot(LootFrame.selectedSlot, frame.value)
--	end
--	CloseDropDownMenus()
--end

