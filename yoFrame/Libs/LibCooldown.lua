local L, yo, N = unpack( select( 2, ...))

local lib = LibStub:NewLibrary("LibCooldown", 1.0)
if not lib then return end

lib.startcalls = {}
lib.stopcalls = {}

function lib:RegisterCallback(event, func)
	assert(type(event)=="string" and type(func)=="function", "Usage: lib:RegisterCallback(event{string}, func{function})")
	if event=="start" then
		tinsert(lib.startcalls, func)
	elseif event=="stop" then
		tinsert(lib.stopcalls, func)
	else
		error("Argument 1 must be a string containing \"start\" or \"stop\"")
	end
end

local addon = CreateFrame("Frame")
local band = bit.band
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
--local spells = {}
local items = {}
local watched = {}
local nextupdate, lastupdate = 0, 0

local function stop(id, class)
	watched[id] = nil

	for _, func in next, lib.stopcalls do
		func(id, class, watched)
	end
end

local function update()
	for id, tab in next, watched do
		local duration = watched[id].dur - lastupdate
		if duration < 0 then
			stop(id, watched[id].class)
		else
			watched[id].dur = duration
			if nextupdate <= 0 or duration < nextupdate then
				nextupdate = duration
			end
		end
	end
	lastupdate = 0

	if nextupdate < 0 then addon:Hide() end
end

local function start(id, starttime, duration, class, rduration)
	update()

	watched[id] = {
		["start"] = starttime,
		["dur"] = duration,
		["class"] = class,
		["duration"] = rduration
	}
	addon:Show()

	for _, func in next, lib.startcalls do
		func(id, duration, class, watched)
	end

	update()
end

local numTabs, totalspellnum
local spells = {}
--local function compare(a,b)
--  return a[1] < b[1]
--end

local function parsespellbook(spellbook)
	N.spellsBooks = {}
	N.spellsBooksName = {}
	local numTabs = GetNumSpellTabs();

	for tabIndex = 1, 3 do
   		local _, _, offset, numSlots = GetSpellTabInfo(tabIndex);
   		for i = offset + 1, offset + numSlots do
      		local spellName, _, spellID = GetSpellBookItemName( i, "spell");
      		local isPassive = IsPassiveSpell( i, "spell");

   			if spellID and not isPassive and spellID ~= 125439 and spellID ~= 83958 then
   				local cd = GetSpellBaseCooldown( spellID)
   				N.spellsBooks[spellID] = spellName
   				N.spellsBooksName[spellName] = spellID
   				if cd > 5000 then
   					spells[spellID] = spellName
   				end
   	    		--print( i, spellID, spellName, floor( cd / 1000))
   			end
   		end
	end
	--table.sort( N.spellsBooks, compare)
end

-- events --
function addon:PLAYER_TALENT_UPDATE()
	parsespellbook(BOOKTYPE_SPELL)
end

function addon:LEARNED_SPELL_IN_TAB()
	parsespellbook(BOOKTYPE_SPELL)
end

function addon:SPELL_UPDATE_COOLDOWN()
	local now = GetTime()

	for id in next, spells do
		local enabled = 1
		local charge, maxCharge, starttime, duration = GetSpellCharges( id)

		if not charge or charge > 0 then -- or charge == maxCharge then --  then
			starttime, duration, enabled = GetSpellCooldown(id)
		end

		if starttime == nil then
			watched[id] = nil
		elseif starttime == 0 and watched[id] then
			stop(id, "spell")
		elseif starttime ~= 0 then
			local timeleft = starttime + duration - now

			if enabled == 1 and timeleft > 1.51 then --> 1.51 then
				if not watched[id] or watched[id].start ~= starttime then
					start(id, starttime, timeleft, "spell", duration)
				end
			elseif enabled == 1 and watched[id] and timeleft <= 0 then
				stop(id, "spell")
			end
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN( slot)
	for id  in next, items do
		--print("Bags: ", id, slot)
		local starttime, duration, enabled = GetItemCooldown(id)
		if enabled == 1 and duration > 10 then
			start(id, starttime, duration, "item", duration)
		elseif enabled == 1 and watched[id] and duration <= 0 then
			stop(id, "item")
		end
	end
end

function addon:PLAYER_ENTERING_WORLD()
	addon:UnregisterEvent("PLAYER_ENTERING_WORLD")

	addon:RegisterEvent("LEARNED_SPELL_IN_TAB")
	addon:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	addon:RegisterEvent("PLAYER_TALENT_UPDATE")

	addon:LEARNED_SPELL_IN_TAB()
	addon:SPELL_UPDATE_COOLDOWN()

	if yo.fliger.checkBags then
		addon:RegisterEvent("BAG_UPDATE_COOLDOWN")
		addon:BAG_UPDATE_COOLDOWN()
	end
end

hooksecurefunc("UseInventoryItem", function(slot)
	local link = GetInventoryItemLink("player", slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	id = tonumber( id)
	if id and not items[id] then
		items[id] = true
		--print("Invent: ", id)
	end
end)

hooksecurefunc("UseContainerItem", function(bag, slot)
	local link = GetContainerItemLink(bag, slot) or ""
	local id = string.match(link, ":(%w+).*|h%[(.+)%]|h")
	id = tonumber( id)
	if id and not items[id] then
		items[id] = true
		--print("Contain: ", id)
	end
end)

for slot=1, 120 do
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

function addon:ACTION_BAR_SLOT_CHANGED(slot)
	local action, id = GetActionInfo(slot)
	if action == "item" then
		items[id] = true
	end
end

local function onupdate(self, elapsed)
	nextupdate = nextupdate - elapsed
	lastupdate = lastupdate + elapsed
	if nextupdate > 0 then return end

	update(self)
end

addon:Hide()
addon:SetScript("OnUpdate", onupdate)
addon:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")