local addonName, ns = ...
local L = ns.L

----------------------------------------------------------------------------------------
--	Test Icons
----------------------------------------------------------------------------------------
--LibStub("LibButtonGlow-1.0").ShowOverlayGlow(f)

local tCount = CreateFrame("Frame")
tCount:RegisterEvent("ADDON_LOADED")
tCount:SetScript("OnEvent", function(_, _, name)
	--if name ~= "yoFrame" then return end
	tCount:UnregisterEvent("ADDON_LOADED")
	tCount:SetScript("OnEvent", nil)
	UIItemTooltip = UIItemTooltip or {count = true}
end)

function KeyPressed( self, key)
	if key == "LSHIFT"
		or key == "RSHIFT"
		or key == "LCTRL"
		or key == "RCTRL"
		or key == "LALT"
		or key == "RALT"
		or key == "UNKNOWN"
		--or key == "LeftButton"
	then return end
	local bingo = ""
	local alt 	= IsAltKeyDown() 		and "ALT-" or ""
	local ctrl 	= IsControlKeyDown()	and "CTRL-" or ""
	local shift = IsShiftKeyDown() 		and "SHIFT-" or ""
	local keyPress = alt .. ctrl .. shift .. key

	if keyPress == yo.healBotka.key1 then
		bingo = " KEY1 PRESSED"
	elseif keyPress == yo.healBotka.key2 then
		bingo = " KEY2 PRESSED"
	end

	print( keyPress, bingo, self.unit)
end

local function test_icon()
	f = CreateFrame( "Button", "yo_test", UIParent, "SecureUnitButtonTemplate") 
	f:SetWidth(50)
	f:SetHeight(50)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	
	f.icon = f:CreateTexture( nil, "OVERLAY")
	f.icon:SetAllPoints( f)
	f.icon:SetTexture( 511726)
	
	f.outerGlow = f:CreateTexture( "OuterGlow", "ARTWORK")
	f.outerGlow:SetPoint("CENTER", f)
	f.outerGlow:SetWidth( f:GetWidth() * 2)
	f.outerGlow:SetHeight( f:GetHeight() * 2)
	f.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	f.outerGlow:Hide()

	f:RegisterForClicks("AnyDown")
	f:EnableMouse( true)	
	f:EnableMouseWheel( true)
	f:EnableKeyboard( false)

	--f:SetScript("OnKeyDown", KeyPressed)
	
	--f:SetScript("OnMouseDown", KeyPressed)
	--f:SetScript("OnMouseWheel", function(self, delta) if delta>0 then KeyPressed( self, "MOUSEWHEELUP") else KeyPressed( self, "MOUSEWHEELDOWN") end end)

	--f:SetScript("OnLeave", function(self, ...)
	--	f:EnableKeyboard( false)
	--	f:SetScript("OnKeyDown", nil)
	--	print('OnLeave')
	--end)

	--f:SetScript("OnEnter", function(self, ...)		
	--	f:EnableKeyboard( true)
	--	f:SetScript("OnKeyDown", KeyPressed)
	--	print('OnEnter')
	--end)
	
	local aButtonId, aModiKey, anAction = 1, "", "Омоложение"

	f:SetAttribute("unit", "player")
	f:SetAttribute("type1", "spell");
	f:SetAttribute("spell1", "Омоложение");	

	f:SetAttribute( "type2", "spell");
	f:SetAttribute( "spell2", "Жизнецвет");	

	f:SetAttribute( "shift-type1", "spell");
	f:SetAttribute( "shift-spell1", "Восстановление");	

	--f:SetAttribute( "shift-type2", "spell");
	--f:SetAttribute( "shift-spell2", "Буйный рост");	

	f:SetAttribute( "type-w2", "macro");
	f:SetAttribute( "macrotext-w2", "/cast Буйный рост");	
	
	RegisterUnitWatch( f)
	f:Show()
end
--test_icon()

----------------------------------------------------------------------------------------
--	Test UnitFrames(by community)
----------------------------------------------------------------------------------------
local moving = false
SlashCmdList.TEST_YO = function(msg)
	if InCombatLockdown() then print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end
	unit = "target"
	if not moving then
		for i = 1, MAX_BOSS_FRAMES do
			_G["yo_Boss"..i].Hide = function() end
			_G["yo_Boss"..i].unit = unit
			_G["yo_Boss"..i]:Show()
			initFrame( _G["yo_Boss"..i], unit)
		end
		moving = true
	else
		for i = 1, MAX_BOSS_FRAMES do
			_G["yo_Boss"..i].Hide = nil
		end
		moving = false
	end
end
SLASH_TEST_YO1 = "/yotest"
SLASH_TEST_YO2 = "/нщеуые"

---------------------------------------------------------------------------------------------------
--- Auto Repare and Gray Sell
---------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	if yo.Addons.AutoSellGrayTrash then
		--local empowering = select(1, GetSpellInfo(228111)) 
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l, ID = GetContainerItemLink(b, s), GetContainerItemID (b, s)
				if (l and ID) then
									
					local p = 0
					local Mult1, Mult2 = select(11, GetItemInfo(l)), select(2, GetContainerItemInfo(b, s))

					if (Mult1 and Mult2) then
						p = Mult1 * Mult2
					end

					if select(3, GetItemInfo(l))==0 and p>0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
	
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage(L["JUNKSOLD"] .." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
		end
	end
	
	if yo.Addons.AutoRepair then
		cost, possible = GetRepairAllCost()
		if cost>0 then
			if possible then
				if CanGuildBankRepair() then
					RepairAllItems( 1)
				else
					RepairAllItems()
				end
				local c = cost%100
				local s = math.floor((cost%10000)/100)
				local g = math.floor(cost/10000)
				DEFAULT_CHAT_FRAME:AddMessage(L["REMONT"] .." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
			else
				DEFAULT_CHAT_FRAME:AddMessage( L["NOMONEY"],255,0,0)
			end
		end
	end		
end)

f:RegisterEvent("MERCHANT_SHOW")
hooksecurefunc("MerchantItemButton_OnModifiedClick", function(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(self:GetID())
		if ( maxStack and maxStack > 1 ) then
			local numAvailable = select(5, GetMerchantItemInfo(self:GetID()))
			if numAvailable > -1 then
				BuyMerchantItem(self:GetID(), numAvailable)
			else
				BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	Misclicks for some popups
----------------------------------------------------------------------------------------
StaticPopupDialogs.RESURRECT.hideOnEscape = nil
StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
-- StaticPopupDialogs.PARTY_INVITE_XREALM.hideOnEscape = nil
StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
PetBattleQueueReadyFrame.hideOnEscape = nil
PVPReadyDialog.leaveButton:Hide()
PVPReadyDialog.enterButton:ClearAllPoints()
PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)

---------------------------------------------------------------------------------------------
-- Auto Screen
--------------------------------------------------------------------------------------------

local function TakeScreen(delay, func, ...)
local waitTable = {}
local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
	waitFrame:SetScript("onUpdate", function (self, elapse)
		local count = #waitTable
		local i = 1
		while (i <= count) do
			local waitRecord = tremove(waitTable, i)
			local d = tremove(waitRecord, 1)
			local f = tremove(waitRecord, 1)
			local p = tremove(waitRecord, 1)
			if (d > elapse) then
				tinsert(waitTable, i, {d-elapse, f, p})
				i = i + 1
			else
				count = count - 1
				f(unpack(p))
			end
		end
	end)
	tinsert(waitTable, {delay, func, {...} })
end
local function OnEvent(...)
	if not yo.Addons.AutoScreenOnLvlUpAndAchiv then return end
	TakeScreen(1, Screenshot)
end

local AchScreen = CreateFrame("Frame")
	AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
	AchScreen:RegisterEvent("PLAYER_LEVEL_UP")
	AchScreen:SetScript("OnEvent", OnEvent)

----------------------------------------------------------------------------------------
-- Auto greed on green items(by Tekkub)
----------------------------------------------------------------------------------------

--local agog = CreateFrame("Frame", nil, UIParent)
--agog:RegisterEvent("START_LOOT_ROLL")
--agog:SetScript("OnEvent", function(_, _, id)
--	if not yo.Addons.AutoGreedOnLoot then return end
--	if not id then return end 
--	local _, _, _, quality, bop, _, _, canDE = GetLootRollItemInfo(id)
--	if quality == 2 and not bop then RollOnLoot(id, canDE and 3 or 2) end
--end)

----------------------------------------------------------------------------------------
-- Disenchant confirmation(tekKrush by Tekkub)
----------------------------------------------------------------------------------------

--local acd = CreateFrame("Frame")
--acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
--acd:SetScript("OnEvent", function(self, event, id, rollType)

--	if not yo.Addons.AutoDisenchantGreenLoot then return end
--	for i=1,STATICPOPUP_NUMDIALOGS do
--		local frame = _G["StaticPopup"..i]
--		if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
--	end
--end)
	
--StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
--	if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then ConfirmLootSlot(slot) end
--end

----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, _, isHeader = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("["..level.."] "..title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------
--- Character Info Sheet
------------------------------------------------------------------------------------------------
local prefixColor = "|cffF9D700"
local detailColor = "|cffffffff"

hooksecurefunc("PaperDollFrame_SetItemLevel", function(self, unit)
	if unit ~= "player" then return end

	local total, equip = GetAverageItemLevel()
	if total > 0 then total = string.format("%.1f", total) end
	if equip > 0 then equip = string.format("%.1f", equip) end

	local ilvl = equip
	if equip ~= total then
		ilvl = equip.." / "..total
	end

	CharacterStatsPane.ItemLevelFrame.Value:SetText(ilvl)

	self.tooltip = detailColor..STAT_AVERAGE_ITEM_LEVEL.." "..ilvl
end)

----------------------------------------------------------------------------------------
--	Tells you who cast a buff or debuff in its tooltip(prButler by Renstrom)
----------------------------------------------------------------------------------------

local T = {}
T.class = select(2, UnitClass("player"))
T.color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.class]

local function addAuraSource(self, func, unit, index, filter)
	local srcUnit = select(7, func(unit, index, filter))
	--print(srcUnit, unit, index, filter)
	if srcUnit then
		local src = GetUnitName(srcUnit, true)
		if srcUnit == "pet" or srcUnit == "vehicle" then
			src = format("%s (|cff%02x%02x%02x%s|r)", src, T.color.r * 255, T.color.g * 255, T.color.b * 255, GetUnitName("player", true))
		else
			local partypet = srcUnit:match("^partypet(%d+)$")
			local raidpet = srcUnit:match("^raidpet(%d+)$")
			if partypet then
				src = format("%s (%s)", src, GetUnitName("party"..partypet, true))
			elseif raidpet then
				src = format("%s (%s)", src, GetUnitName("raid"..raidpet, true))
			end
		end
		if UnitIsPlayer(srcUnit) then
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(srcUnit))]
			if color then
				src = format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, src)
			end
		else
			local color = yo_Player.colors.reaction[UnitReaction(srcUnit, "player")]
			if color then
				src = format("|cff%02x%02x%02x%s|r", color[1] * 255, color[2] * 255, color[3] * 255, src)
			end
		end
		self:AddDoubleLine( "Caster:", src)
		self:Show()
	end
end

local funcs = {
	SetUnitAura = UnitAura,
	SetUnitBuff = UnitBuff,
	SetUnitDebuff = UnitDebuff,
}

for k, v in pairs(funcs) do
	hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
		addAuraSource(self, v, unit, index, filter)
	end)
end

-------------------------------------------------------------------------------------
----  AUTO PARTY_INVITE_REQUEST
--------------------------------------------------------------------------------------

local function IsFriend( name)
	for i = 1, GetNumFriends() do 
		if( GetFriendInfo( i) == name) then 
			return true 
		end 
	end
	if( IsInGuild()) then 
		for i = 1, GetNumGuildMembers() do 
			if( strsplit( "-", GetGuildRosterInfo( i) or "?") == name) then 
				return true 
			end 
		end 
	end
	local b, a = BNGetNumFriends() 
	for i = 1, a do 
		local bName = select( 5, BNGetFriendInfo( i)) 
		if bName == name then 
			return true 
		end 
	end
end

local function OnEvent( self, event, ...)
	--print( self, event, ...)
	
	if event == "PARTY_INVITE_REQUEST" then
		if not yo["Addons"].AutoInvaitFromFriends then return end
		
		local nameinv, _ = ... 
		nameinv = strsplit( "-", nameinv) -- and ExRT.F.delUnitNameServer(nameinv)
		if nameinv and (IsFriend( nameinv)) then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which=="PARTY_INVITE" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE")
					return
				elseif frame:IsVisible() and frame.which=="PARTY_INVITE_XREALM" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE_XREALM")
					return
				end
			end
		elseif event == "GROUP_INVITE_CONFIRMATION" then
		if not yo.Addons.AutoInvaitFromFriends then return end

			-- local firstInvite = GetNextPendingInviteConfirmation()
			-- if ( not firstInvite ) then
				-- return
			-- end
			-- local confirmationType, name = GetInviteConfirmationInfo(firstInvite)
			-- local suggesterGuid, suggesterName, relationship = GetInviteReferralInfo(firstInvite)
			-- if (suggesterName and IsFriend( strsplit( "-", suggesterName))) or (name and IsFriend( strsplit( "-", name))) then
				-- RespondToInviteConfirmation(firstInvite, true)
				-- for i = 1, 4 do
					-- local frame = _G["StaticPopup"..i]
					-- if frame:IsVisible() and frame.which=="GROUP_INVITE_CONFIRMATION" then
						-- StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
						-- UpdateInviteConfirmationDialogs()
						-- return
					-- end
				-- end
			-- end
		end
	end
end

local autoinvite = CreateFrame("Frame", nil, UIParent)
autoinvite:RegisterEvent("PARTY_INVITE_REQUEST")
--autoinvite:RegisterEvent("GROUP_INVITE_CONFIRMATION")
autoinvite:SetScript("OnEvent", OnEvent)



local eventcount = 0
local Garbage = CreateFrame("Frame")
Garbage:RegisterAllEvents()
Garbage:SetScript("OnEvent", function(self, event)
	eventcount = eventcount + 1

	if (InCombatLockdown() and eventcount > 25000) or (not InCombatLockdown() and eventcount > 10000) or event == "PLAYER_ENTERING_WORLD" then
		collectgarbage("collect")
		eventcount = 0
	end
end)


-- rScreenSaver: core
-- zork, 2016

-----------------------------
-- Local Variables
-----------------------------

  local A, L = ...
  L.addonName = A

-----------------------------
-- Init
-----------------------------

--canvas frame
local f = CreateFrame("Frame",nil,UIParent)
f:SetFrameStrata("FULLSCREEN")
f:SetAllPoints()
f.h = f:GetHeight()
f:EnableMouse(true)
f:SetAlpha(0)
f:Hide()

--enable frame
function f:Enable()
  if self.isActive then return end
  self.isActive = true
  self:Show()
  self.fadeIn:Play()
end

--disable frame
function f:Disable()
  if not self.isActive then return end
  self.isActive = false
  self.fadeOut:Play()
end

--onevent handler
function f:OnEvent(event)
  if event == "PLAYER_LOGIN" then
    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-110))
    self.galaxy:SetDisplayInfo(67918)
    self.galaxy:SetCamDistanceScale(2.2)
    self.galaxy:SetRotation(math.rad(180))
    return
  end
  if UnitIsAFK("player") and yo.Addons.afk then    
    self:Enable()
  else
    self:Disable()
  end
end

--fade in anim
f.fadeIn = f:CreateAnimationGroup()
f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
f.fadeIn.anim:SetDuration(1)
f.fadeIn.anim:SetSmoothing("OUT")
f.fadeIn.anim:SetFromAlpha(0)
f.fadeIn.anim:SetToAlpha(1)
f.fadeIn:HookScript("OnFinished", function(self)
  self:GetParent():SetAlpha(1)
end)

--fade out anim
f.fadeOut = f:CreateAnimationGroup()
f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
f.fadeOut.anim:SetDuration(1)
f.fadeOut.anim:SetSmoothing("OUT")
f.fadeOut.anim:SetFromAlpha(1)
f.fadeOut.anim:SetToAlpha(0)
f.fadeOut:HookScript("OnFinished", function(self)
  self:GetParent():SetAlpha(0)
  self:GetParent():Hide()
end)

--black background
f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
f.bg:SetColorTexture(1,1,1)
f.bg:SetVertexColor(0,0,0,1)
f.bg:SetAllPoints()

--galaxy animation
f.galaxy = CreateFrame("PlayerModel",nil,f)
f.galaxy:SetAllPoints()

--player model
f.model = CreateFrame("PlayerModel",nil,f.galaxy)
f.model:SetSize(f.h,f.h*1.5)
f.model:SetPoint("BOTTOMRIGHT",f.h*0.25,-f.h*0.5)

--inner shadow gradients
f.gradient = f.model:CreateTexture(nil,"BACKGROUND",nil,-7)
f.gradient:SetColorTexture(1,1,1)
f.gradient:SetVertexColor(0,0,0,1)
f.gradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
f.gradient:SetPoint("BOTTOMLEFT",f)
f.gradient:SetPoint("BOTTOMRIGHT",f)
f.gradient:SetHeight(100)

--close button
local button = CreateFrame("Button", A.."Button", f.model, "UIPanelButtonTemplate")
button.text = _G[button:GetName().."Text"]
button.text:SetText("Close")
button:SetWidth(button.text:GetStringWidth()+20)
button:SetHeight(button.text:GetStringHeight()+12)
button:SetPoint("BOTTOMLEFT",f,10,10)
button:SetAlpha(0.5)
button:HookScript("OnClick", function(self)
  f:Disable()
end)

--onevent
f:SetScript("OnEvent",f.OnEvent)

--register events
f:RegisterEvent("PLAYER_FLAGS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")