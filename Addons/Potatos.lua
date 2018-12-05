local L, yo = unpack( select( 2, ...))

local timerEnd, timerEst = GetTime(), 0
local hpInRaid, hpInParty, hpInSolo, howBig = 30, 50, 50, 20

local function DrawDefault( self)
    local start, itemCD = GetItemCooldown( self.itemID)
	local usableItem, _ = IsUsableItem( self.item)
	--IsConsumableItem()
	if usableItem then
		self.usableItem = true
		if itemCD == 0 then
			self.itemReady = true
			self.tName:SetText( "ready to use")
			self.icon:SetVertexColor( 1, 1, 1, 0.5)
		else
			self.itemReady = false
			self.tName:SetText( "waiting...")
			self.icon:SetVertexColor( 0, 1, 1, 0.5)
		end
	else
		self.usableItem = false
		self.itemReady = false
		self.tName:SetText( "wasted!")
		self.icon:SetVertexColor( 1, 0.5, 0, 0.5)
	end

	self.outerGlow:Hide()
	self.icon:SetAlpha( 0.5)
	self.icon:SetDesaturated( true)
	self.icon:SetTexture( self.iconPot)
	self.tName:SetTextColor( 1, 0.5, 0, 1)
end

local function initPotatos( self)
	local start, itemCD = GetItemCooldown( self.itemID)
	local usableItem, _ = IsUsableItem( self.item)

	if self.buyPots then
		self.tName:SetText( "купи потцов")
		self.tName:SetTextColor( 1,0,0,1)
		self.icon:SetVertexColor( 1, 0, 0, 0.5)
		self.IsNormal = false
	else
		self.IsNormal = true
	end

	if self.IsBL then
		self.icon:SetTexture( self.iconBL)
		self.blframe.outerGlow:Show()
		self.icon:SetDesaturated( false)

		local cname = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( self.casterBL))].colorStr
		self.blframe.blText = "|r|cffff0000" .. self.nameBL .. " завезли\n " .. cname .. strsplit("-", (UnitName( self.casterBL)))

		self.blframe.bltick = 1
		self.blframe.bltimerEnd = self.blEnd
		--print( "Start_bl")
		self.blframe:SetScript('OnUpdate', blUpdate)
		--self.IsNormal = false
	end

	if self.IsPool then
		self.icon:SetTexture( self.iconPul)
		self.icon:SetAlpha( 1)
		self.icon:SetDesaturated( false)
		self.icon:SetVertexColor( 1,1,1, 1)

		self.outerGlow:Show()
		self.tTimer:Show()
		self.tName:SetText( "pulling time")
		self.tName:SetTextColor( 1, 1, 0)
		self.IsNormal = false

	elseif self.IsBuffed then
		DrawDefault( self)
		self.tName:SetText( "жарим-с....")
		self.icon:SetVertexColor( 0, 1, 0, 0.5)
		if timerEst == 0 then
			self.tick = 1
			timerEnd = self.buffEnd
			self.tTimer:Show()
			--print( "Start_buff")
			self:SetScript('OnUpdate', pullUpdate)
		end
		self.IsNormal = false

	elseif self.itemReady and self.bigBoss then
		DrawDefault( self)
		self.tName:SetText( "finish him")
		self.icon:SetDesaturated( false)
		self.icon:SetAlpha( 1)
		self.outerGlow:Show()
		self.IsNormal = false

	elseif itemCD > 0 and usableItem == true then
		if timerEst == 0 then
			self.tick = 1
			timerEnd = itemCD + start
			self.tTimer:Show()
			--print( "Start_ready")
			self:SetScript('OnUpdate', pullUpdate)
		end
	else
		self.IsNormal = true
	end

	if self.IsNormal then
		DrawDefault( self)
	end
	--print( "EST:", start, itemCD ,  " PUL:",self.IsPool," BUF:", self.IsBuffed, " Rdy:", self.itemReady ," NRM:", self.IsNormal, " US:", self.usableItem, usableItem)
end


function pullUpdate( self, el)
	self.tick = self.tick + el
	if self.tick <= .1 then return 	end
	self.tick = 0
	timerEst = ( timerEnd or 0) - GetTime()

	self.tTimer:SetText( formatTime( timerEst))

	--print( timerEst, timerEnd, self.IsPool, self.IsBuffed)

	if timerEst <= 0 then
		timerEst = 0
		self:SetScript('OnUpdate', nil)
		self.cd:Clear()
		self.IsPool = false
		self.tTimer:Hide()
		--print( GetTime(), "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ")

		initPotatos( self)
	elseif timerEst < 2 then
		self.tTimer:SetTextColor(1, 0.1, 0.0)
	else
		self.tTimer:SetTextColor(.7, .7, .7)
	end
end

local function OnEvent( self, event, ...)
	-----																														CHAT_MSG_ADDON
	if event == "CHAT_MSG_ADDON" then
		--print( "Event: " , event, ...)

		local addon, text = ...
		if addon == "BigWigs" and string.find( text, "Pull") then
			pDur  = tonumber( string.match( text, "%d+"))
			timerEnd = GetTime() + pDur
			self.tick = 1
			self.IsPool = true
			self.cd:SetCooldown( timerEnd - pDur, pDur)

			self:SetScript('OnUpdate', pullUpdate)
			initPotatos( self)
		elseif addon == "D4" and string.find( text, "PT") then
			--pDur = tonumber( string.match( text, "\t(%d+)\t"))
			--timerEnd = GetTime() + pDur
		end
	-----																														BAG_UPDATE
	elseif event == "BAG_UPDATE" then
		itemCount = ( GetItemCount( self.itemID) or 0)
		self.tCount:SetText( itemCount)
		if itemCount <= 10 then
			self.buyPots = true
		else
			self.buyPots = false
		end
		initPotatos( self)

	elseif event == "PLAYER_REGEN_ENABLED" then
		self.bigBoss = nil
		self.bossFight = nil

		--DrawDefault( self)
		initPotatos( self)
		--local start, itemCD = GetItemCooldown( self.itemID)
		--local usableItem, _ = IsUsableItem( self.item)
		--print( "REGEN ENA", start, itemCD, GetTime() - 60, usableItem )

	elseif event == "ENCOUNTER_END" then
		self.bigBoss = nil
		self.bossFight = nil
		--print( "EEND")
		--DrawDefault( self)
		initPotatos( self)

	elseif event == "ENCOUNTER_START" then
		self.bossFight = true

	-----																														UNIT_HEALTH

	elseif event == "UNIT_HEALTH" or event == "PLAYER_TARGET_CHANGED" then

		local unit, real_unit

		if UnitInRaid( "player") then
			real_unit = ...
			unit = "boss1"
			if real_unit == "boss1" then
				hpChan = hpInRaid
			else
				return
			end

		elseif UnitInParty( "player") then
			unit = "boss1"
			real_unit = ...
			if real_unit == "boss1" then
				hpChan = hpInParty
			else
				return
			end

		else
			if event == "PLAYER_TARGET_CHANGED" then
				if not UnitExists( "target") then
					self.bigBoss = nil
					initPotatos( self)
					return
				end
			end

			if self.bossFight then
				unit = "boss1"
				real_unit = "boss1"
			else
				unit = "target"
				real_unit = "target"
			end
			hpChan = hpInSolo
		end

		if UnitExists( unit) and not UnitIsDead( unit) and  UnitCanAttack( "player", unit) and real_unit == unit then
			uHP = 100 / UnitHealthMax( unit)  * UnitHealth( unit)
			hpBig = UnitHealthMax( unit) / UnitHealthMax( "player")

			if uHP <= hpChan and hpBig >= howBig then
				self.bigBoss = true
			else
				self.bigBoss = false
			end
		else
			self.bigBoss = nil
		end
		initPotatos( self)
		--print( "Event: " , event, unit, real_unit, hpChan, uHP)
	-----																														UNIT_AURA
	elseif event == "UNIT_AURA" then
        self.item   = GetItemInfo( self.itemID)

		local buffName, _, _, _, buffdur, buffend = UnitBuff( "player", self.itemID)
		--local buffName, _, _, _, _, buffdur, buffend = UnitBuff( "player", "Омоложение")

		if buffName then
			--print( self.item, buffName, buffdur, buffend)
			self.IsBuffed = true
			self.buffEnd = buffend
			initPotatos( self)
		else
			if self.IsBuffed == true then
				--print( "NO BUFF")
				timerEnd = GetTime()
				self.IsBuffed = false
				initPotatos( self)
			end
			self.IsBuffed = false
		end

		for i = 1, 40, 1 do
			local name, icon, _, _, duration, expirationTime, unitCaster, _, _, spellID = UnitBuff( "player", i)
			if not name then break end

			if bls[spellID] == true then
				self.IsBL = true
				self.blEnd = expirationTime
				self.nameBL = name
				self.iconBL = icon
				self.casterBL = unitCaster
				initPotatos( self)
				return
			else
				if self.IsBL then
					self.IsBL = false
					self.blframe.bltimerEnd  = 0
					initPotatos( self)
				end
				self.IsBL = false
			end
		end
	end
end

local SetPosition = function(anch)
	local ap, _, rp, x, y = anch:GetPoint()
	local w, h = anch:GetSize()
	yo_Position["yo_MovePotatos"] = {ap, "UIParent", rp, x, y, w, h}
end

local OnDragStart = function(self)
	print("we are here")
	self:StartMoving()
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	SetPosition(self)
end

local function CreatePotatos( f)
	f.button = CreateFrame("Button", nil, f, "SecureActionButtonTemplate")
	f.button:SetAllPoints( f)
	--f.button:SetAttribute("unit", "player")
	f.button:SetAttribute("type", "item")
	f.button:SetAttribute("item", "Зелье длительной силы")

	f.icon = f:CreateTexture(nil, "BORDER")
	f.icon:SetAllPoints()
	f.icon:SetPoint( "CENTER", f)
	f.icon:SetTexCoord(unpack( yo.tCoord))

	f.outerGlow = f:CreateTexture( "OuterGlow", "BORDER")
	f.outerGlow:SetPoint("CENTER", f)
	f.outerGlow:SetAlpha(1)
	f.outerGlow:SetWidth( f:GetWidth() * 2)
	f.outerGlow:SetHeight( f:GetHeight() * 2)
	f.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	f.overlay = CreateFrame("Frame", nil, f)
	f.overlay:SetFrameLevel(3)

	f.tName = f.overlay:CreateFontString(nil, "OVERLAY")
	f.tName:SetFont( font, fontsize +4, "OUTLINE")
	f.tName:SetPoint("TOP", f, "BOTTOM", 0, -4)

	f.tTimer = f.overlay:CreateFontString(nil, "OVERLAY")
	f.tTimer:SetFont( fontpx, fontsize+15, "OUTLINE")
	f.tTimer:SetPoint("CENTER", f, "CENTER", 0, 0)

	f.tCount = f.overlay:CreateFontString(nil, "OVERLAY")
	f.tCount:SetFont( fontpx, fontsize, "OUTLINE")
	f.tCount:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -0, 0)
	f.tCount:SetText( ( GetItemCount( f.itemID) or 0))
	f.tCount:SetTextColor( 0, 0.5, 1, 0.7)

	f.cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	f.cd.noCooldownCount = true
	f.cd:SetDrawEdge( false)
	f.cd:SetDrawSwipe( true)
	f.cd:SetReverse(true)
	f.cd.noOCC = true

	f.blframe = CreateFrame("Frame", nil, f)
	f.blframe.tBl = f.blframe:CreateFontString(nil, "OVERLAY")
	f.blframe.tBl:SetFont( font, fontsize + 2, "OUTLINE")
	f.blframe.tBl:SetPoint("BOTTOM", f, "TOP", 0, 10)

	f.blframe.outerGlow = f.blframe:CreateTexture( "OuterGlow", "BORDER")
	f.blframe.outerGlow:SetPoint("CENTER", f)
	f.blframe.outerGlow:SetAlpha(1)
	f.blframe.outerGlow:SetWidth( f:GetWidth() * 2)
	f.blframe.outerGlow:SetHeight( f:GetHeight() * 2)
	f.blframe.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.blframe.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
	f.blframe.outerGlow:SetVertexColor( 0, 1, 0)
	f.blframe.outerGlow:SetAlpha( 0.3)
	f.blframe.outerGlow:Hide()
	--f.blframe:SetFrameLevel(3)

	CreateBorder( f)
	f.timerEst = 0
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("CHAT_MSG_ADDON")
	f:RegisterEvent("BAG_UPDATE")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterUnitEvent("UNIT_AURA", "player")
	f:RegisterUnitEvent("UNIT_HEALTH", "target", "boss1")
	f:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	f:RegisterEvent("ENCOUNTER_END")
	f:RegisterEvent("ENCOUNTER_START")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")



	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	--f:SetScript("OnClick", function(self) if IsControlKeyDown() then print( "boom") end end)
	f:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then
		print("wedsf sf s")
		self:StartMoving() end end)
	f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	f:EnableMouse(true)
	--f:RegisterForDrag("LeftButton")
	--f:SetScript("OnDragStart", OnDragStart)
	--f:SetScript("OnDragStop", OnDragStop)


	f:SetScript('OnEvent', OnEvent)
end

function blUpdate( self, el)
	self.bltick = self.bltick + el
	if self.bltick <= 0.2 then return 	end
	self.bltick = 0
	local bltimerEst = self.bltimerEnd - GetTime()
	self.tBl:SetText(  self.blText .. " ( " .. formatTime( bltimerEst) .. " )")

	if bltimerEst <= 0 then
		self:SetScript('OnUpdate', nil)
		self.tBl:SetText( "")
		self.outerGlow:Hide()
	end
end
---------------------------------------------------------------------------------------------------------------------------
local potatos = CreateFrame("Frame", "yo_Potatos", UIParent)
	potatos:SetAllPoints( "yo_MovePotatos")
	potatos:RegisterEvent("PLAYER_ENTERING_WORLD")

	potatos.itemID = 142117
    potatos.item   = GetItemInfo( potatos.itemID)
    potatos.iconPot = GetItemIcon( potatos.itemID)
	potatos.iconPul = 252188

	potatos:SetScript("OnEvent", function(self, event)
		if not yo["Addons"].Potatos or UnitLevel("player") < MAX_PLAYER_LEVEL then return end
		CreatePotatos( self)
		initPotatos( self)
	end)
