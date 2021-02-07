local addon, ns = ...
local L, yo, n = unpack( ns)

local _G = _G

local CreateFrame, unpack, pairs, InCombatLockdown, isAligning, print, PlaySound, ReloadUI
	= CreateFrame, unpack, pairs, InCombatLockdown, isAligning, print, PlaySound, ReloadUI

yo_Position 		= {}
n.Addons.moveFrames = {}

n.Addons.snapBars 	= {}
n.Addons.snapBars[#n.Addons.snapBars + 1] = UIParent
n.Addons.snapBars[#n.Addons.snapBars + 1] = n.infoTexts.LeftDataPanel
n.Addons.snapBars[#n.Addons.snapBars + 1] = n.infoTexts.RightDataPanel

local mf 		= n.Addons.moveFrames
local sticky 	= n.LIBS.Sticky
local moveArray

if yo.Addons.movePersonal then
	moveArray = yo_Position
else
	if not n.allData.moveArray then n.allData.moveArray = {} end
	moveArray = n.allData.moveArray
end

--GLOBALS: yo_Position
----------------------------------------------------------------------------------------
--	Grid on screen
----------------------------------------------------------------------------------------

n.grid = function( show)

	if show then
		if not n.gridFrame then
			n.gridFrame = CreateFrame("Frame", nil, UIParent)
			n.gridFrame:SetFrameStrata("BACKGROUND")
			n.gridFrame:SetAllPoints(UIParent)
			local width = GetScreenWidth() / 128
			local height = GetScreenHeight() / 72
			for i = 0, 128 do
				local texture = n.gridFrame:CreateTexture(nil, "BACKGROUND")
				if i == 64 then
					texture:SetColorTexture(1, 0, 0, 0.8)
				else
					texture:SetColorTexture(0, 0, 0, 0.8)
				end
				texture:SetPoint("TOPLEFT", n.gridFrame, "TOPLEFT", i * width - 1, 0)
				texture:SetPoint("BOTTOMRIGHT", n.gridFrame, "BOTTOMLEFT", i * width, 0)
			end
			for i = 0, 72 do
				local texture = n.gridFrame:CreateTexture(nil, "BACKGROUND")
				if i == 36 then
					texture:SetColorTexture(1, 0, 0, 0.8)
				else
					texture:SetColorTexture(0, 0, 0, 0.8)
				end
				texture:SetPoint("TOPLEFT", n.gridFrame, "TOPLEFT", 0, -i * height)
				texture:SetPoint("BOTTOMRIGHT", n.gridFrame, "TOPRIGHT", 0, -i * height - 1)
			end
		end
		n.gridFrame:Show()
	else
		if n.gridFrame then
			n.gridFrame:Hide()
		end
	end
end

n.setAnchPosition = function(anch, realAnch)
	local ap, _, rp, x, y = anch:GetPoint()

	if realAnch then
		ap, _, rp, x, y = realAnch:GetPoint()
	end

	local w, h = anch:GetSize()
	moveArray[anch:GetName()] = {ap, "UIParent", rp, x, y, w, h}
end

local OnDragStart = function(self)

	if sticky and not IsShiftKeyDown() then
		self.stick = true
		sticky:StartMoving( self, n.Addons.snapBars, self.snapOffset, self.snapOffset, self.snapOffset, self.snapOffset)
	else
		self.stick = false
		self:StartMoving()
	end
end

local OnDragStop = function(self)

	if sticky and self.stick then
		sticky:StopMoving(self)
	else
		self:StopMovingOrSizing()
	end
	n.setAnchPosition(self)
end

local function framemove(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
		insets = {left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(.05,.05,.05,0.5)
	f:SetBackdropBorderColor(.23,.45,.13, 1)
end

function n.moveCreateAnchor(name, text, width, height, x, y, p1, p2, anchor)
	--print(name, text, width, height, x, y, p1, p2, anchor)
	local t1 = ( p1 or "CENTER")
	local t2 = ( p2 or "CENTER")
	local anchorTo = anchor and anchor or UIParent

	local f = CreateFrame("Frame", name, anchorTo)
	f:SetPoint( t1, anchorTo, t2, x, y)
	f:SetScale(1)
	f:SetFrameLevel( 10)
	f:SetClampedToScreen(true)
	f:SetFrameStrata("TOOLTIP")
	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetWidth(width)
	f:SetHeight(height)

	local h = CreateFrame("Frame", nil)
	h:SetFrameLevel(30)
	h:SetAllPoints(f)
	f.dragtexture = h

	local v = CreateFrame("Frame", nil, h, BackdropTemplateMixin and "BackdropTemplate")
	v:SetPoint("TOPLEFT",0,0)
	v:SetPoint("BOTTOMRIGHT",0,0)
	framemove(v)

	f:SetMovable(true)
	f.dragtexture:SetAlpha(0)
	f:EnableMouse(nil)
	f:RegisterForDrag(nil)

	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetFont( n.font, n.fontsize)
	f.text:SetJustifyH("LEFT")
	f.text:SetShadowColor(0, 0, 0)
	f.text:SetShadowOffset(1, -1)
	f.text:SetAlpha(0)
	f.text:SetPoint("CENTER")
	f.text:SetText(text)

	f.snapOffset = -3
	n.Addons.moveFrames[f:GetName()] = f
	n.Addons.snapBars[#n.Addons.snapBars +1] = f
end

function n.moveAnchorsUnlock()
	print("|cff00a2ffyoFrame:|r all frames unlocked")
	n.moveUnlockState = true
	n.grid( true)

	for _, f in pairs(n.Addons.moveFrames) do
		--f = v --_G[v]
		f.dragtexture:SetAlpha(1)
		f.text:SetAlpha(1)
		f:EnableMouse(true)
		f:RegisterForDrag("LeftButton")
	end
end

function n.moveAnchorsLock()
	print("|cff00a2ffyoFrame:|r all frames locked")
	n.moveUnlockState = false
	n.grid( false)
	for _, f in pairs(n.Addons.moveFrames) do
		--f = _G[v]
		f.dragtexture:SetAlpha(0)
		f.text:SetAlpha(0)
		f:EnableMouse(nil)
		f:SetUserPlaced(false)
		f:RegisterForDrag(nil)
	end
end

function n.moveAnchorsReset()
	if( moveArray) then moveArray = nil end
	ReloadUI()
end

ns.toggleMove = function ()
	if InCombatLockdown() then print("No, not in comabt only...") return end
	--PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);
	if not n.moveUnlockState then
		n.moveAnchorsUnlock()
		isAligning = true
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
	elseif n.moveUnlockState == true then
		n.moveAnchorsLock()
		isAligning = false
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
	end
end

function n.moveSlashCmd(cmd)
	if InCombatLockdown() then print("No, not in comabt only...") return end
	if (cmd:match"reset") then
		n.moveAnchorsReset()
	else
		if not n.moveUnlockState then
			n.moveAnchorsUnlock()
			isAligning = true
		elseif n.moveUnlockState == true then
			n.moveAnchorsLock()
			isAligning = false
		end
	end
end

n.moveRestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			n.moveRestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end

	for frame_name, SetPoint in pairs( moveArray) do
		local frame = n.Addons.moveFrames[frame_name]

		if frame then
			local p1 = SetPoint[1] or "CENTER"
			local an = SetPoint[2] or UIParent
			local p2 = SetPoint[3] or "CENTER"
			local x =  SetPoint[4] or 0
			local y =  SetPoint[5] or 0
			--print( "mf = ", frame_name, n.Addons.moveFrames[frame_name], " ]]]", p1, an, p2, x, y)

			frame:ClearAllPoints()
			frame:SetPoint( p1, an, p2, x, y)
		end
		--if _G[frame_name] then
		--	print(frame_name, _G[frame_name])
		--	_G[frame_name]:ClearAllPoints()
		--	_G[frame_name]:SetPoint(unpack(SetPoint))
		--end
	end
end

local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		n.moveRestoreUI(self)
	end)

n.moveCreateAnchor("yoMoveplayer", 		"Move Player", 		200, 40, 500, 270, 	"BOTTOMLEFT", "BOTTOMLEFT")
n.moveCreateAnchor("yoMovetarget", 		"Move Target", 		200, 40, -500, 270, "BOTTOMRIGHT", "BOTTOMRIGHT")
n.moveCreateAnchor("yoMovefocus", 		"Move Focus", 		110, 25, 0, 320, 	"TOPLEFT", "BOTTOMLEFT")
n.moveCreateAnchor("yoMovefocustarget", "Move FocusTarget", 110, 25, 5, -1000)
n.moveCreateAnchor("yoMovetargettarget","Move Tar-Tar", 	100, 25, 0, -1000)
n.moveCreateAnchor("yoMovepet", 		"Move Pet", 		100, 25, 00, -1000)
n.moveCreateAnchor("yoMoveboss", 		"Move Boss", 		180, 35, -370, -200, "TOPRIGHT", "TOPRIGHT")

--n.moveCreateAnchor("yoMoveLeftPanel", 	"Move Left DataPanel", 440, 175, 3, 3, "BOTTOMLEFT","BOTTOMLEFT")
n.moveCreateAnchor("yoMoveQuestFrame", 	"Move Quest Frame", 230, 500, -5, -175, "TOPRIGHT", "TOPRIGHT")
n.moveCreateAnchor("yoMoveExperience", 	"Move Experience", 	7, 173, -452, 4, 	"BOTTOM", "BOTTOMRIGHT")
n.moveCreateAnchor("yoMovePlayerCastBar","Move Player CastBar", 436, 20, 0, 91, "CENTER", "BOTTOM")
n.moveCreateAnchor("yoMoveRUP", 		"Move Utility Panel", 226, 18, 0, -10, 	"TOP", "TOP")
n.moveCreateAnchor("yoMoveToolTip",		"Move ToolTips", 	150, 100, -5, 230, 	"BOTTOMRIGHT", "BOTTOMRIGHT")
n.moveCreateAnchor("yoMoveLoot", 		"Move Loot", 		250, 50, 10, -270, 	"TOPLEFT","TOPLEFT")

n.moveCreateAnchor("yoMoveAltPower", 	"Move Power Alt Bar", 180, 36, 0, -100, "CENTER", "TOP")

if yo.Addons.minimapMove then
	local x = yo.Addons.MiniMapSize + 10
	n.moveCreateAnchor("yoMoveMap", 		"Move MiniMap",		x, x, -0, -0, 		"TOPRIGHT", "TOPRIGHT")
	n.moveCreateAnchor("yoMoveBuff", 		"Move Buffs", 		400, 40, -(x+5), -5, "TOPRIGHT", "TOPRIGHT")
	--n.moveCreateAnchor("yoMoveDebuff", 		"Move Debuff", 		400, 40, -(x+5), -115, "TOPRIGHT", "TOPRIGHT")
end