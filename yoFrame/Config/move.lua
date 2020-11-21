local addon, ns = ...
local L, yo, N = unpack( ns)

yo_AnchorFrames = {}
yo_Position = {}

SetAnchPosition = function(anch, realAnch)

	local ap, _, rp, x, y = anch:GetPoint()

	if realAnch then
		ap, _, rp, x, y = realAnch:GetPoint()
	end

	local w, h = anch:GetSize()
	yo_Position[anch:GetName()] = {ap, "UIParent", rp, x, y, w, h}
end

local OnDragStart = function(self)
	self:StartMoving()
end

local OnDragStop = function(self)
	self:StopMovingOrSizing()
	SetAnchPosition(self)
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

function CreateAnchor(name, text, width, height, x, y, p1, p2, anchor)
	t1 = ( p1 or "CENTER")
	t2 = ( p2 or "CENTER")
	local anchorTo = anchor and anchor or UIParent

	f = CreateFrame("Frame", name, anchorTo)
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
	f.text:SetFont( [=[Interface\AddOns\yoFrame\Media\qFont.ttf]=], 10)
	f.text:SetJustifyH("LEFT")
	f.text:SetShadowColor(0, 0, 0)
	f.text:SetShadowOffset(1, -1)
	f.text:SetAlpha(0)
	f.text:SetPoint("CENTER")
	f.text:SetText(text)

	tinsert(yo_AnchorFrames, f:GetName())
end

function AnchorsUnlock()
	print("|cff00a2ffyoFrame:|r all frames unlocked")
	t_unlock = true
	for _, v in pairs(yo_AnchorFrames) do
		f = _G[v]
		f.dragtexture:SetAlpha(1)
		f.text:SetAlpha(1)
		f:EnableMouse(true)
		f:RegisterForDrag("LeftButton")
	end
end

function AnchorsLock()
	print("|cff00a2ffyoFrame:|r all frames locked")
	t_unlock = false
	for _, v in pairs(yo_AnchorFrames) do
		f = _G[v]
		f.dragtexture:SetAlpha(0)
		f.text:SetAlpha(0)
		f:EnableMouse(nil)
		f:SetUserPlaced(false)
		f:RegisterForDrag(nil)
	end
end

function AnchorsReset()
	if( yo_Position) then yo_Position = nil end
	ReloadUI()
end

ns.toggleMove = function ()
	if InCombatLockdown() then print("No, not in comabt only...") return end
	--PlaySound(SOUNDKIT.IG_MAINMENU_OPTION);

	if not t_unlock then
		AnchorsUnlock()
		isAligning = true
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
	elseif t_unlock == true then
		AnchorsLock()
		isAligning = false
		PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
	end
end

function ySlashCmd(cmd)
	if InCombatLockdown() then print("No, not in comabt only...") return end
	if (cmd:match"reset") then
		AnchorsReset()
	else
		if not t_unlock then
			AnchorsUnlock()
			isAligning = true
		elseif t_unlock == true then
			AnchorsLock()
			isAligning = false
		end
	end
end

local RestoreUI = function(self)
	if InCombatLockdown() then
		if not self.shedule then self.shedule = CreateFrame("Frame", nil, self) end
		self.shedule:RegisterEvent("PLAYER_REGEN_ENABLED")
		self.shedule:SetScript("OnEvent", function(self)
			RestoreUI(self:GetParent())
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:SetScript("OnEvent", nil)
		end)
		return
	end
	for frame_name, SetPoint in pairs( yo_Position) do
		if _G[frame_name] then
			_G[frame_name]:ClearAllPoints()
			_G[frame_name]:SetPoint(unpack(SetPoint))
		end
	end
end

local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		RestoreUI(self)
	end)

CreateAnchor("yoMoveplayer", 		"Move Player", 		200, 40, 500, 270, 	"BOTTOMLEFT", "BOTTOMLEFT")
CreateAnchor("yoMovetarget", 		"Move Target", 		200, 40, -500, 270, "BOTTOMRIGHT", "BOTTOMRIGHT")
CreateAnchor("yoMovefocus", 		"Move Focus", 		110, 25, 5, 0, 		"LEFT","LEFT")
CreateAnchor("yoMovefocustarget", 	"Move FocusTarget", 110, 25, 5, -1000)
CreateAnchor("yoMovetargettarget", 	"Move Tar-Tar", 	100, 25, 0, -1000)
CreateAnchor("yoMovepet", 			"Move Pet", 		100, 25, 00, -1000)
CreateAnchor("yoMoveboss", 			"Move Boss", 		180, 35, -370, -200, "TOPRIGHT", "TOPRIGHT")

--CreateAnchor("yoMoveLeftPanel", 	"Move Left DataPanel", 440, 175, 3, 3, "BOTTOMLEFT","BOTTOMLEFT")
CreateAnchor("yoMoveQuestFrame", 	"Move Quest Frame", 230, 500, -5, -175, "TOPRIGHT", "TOPRIGHT")
CreateAnchor("yoMoveExperience", 	"Move Experience", 7, 173, -452, 4, "BOTTOM", "BOTTOMRIGHT")
CreateAnchor("yoMovePlayerCastBar",	"Move Player CastBar", 436, 20, 0, 91, "CENTER", "BOTTOM")
CreateAnchor("yoMoveRUP", 			"Move Utility Panel", 226, 18, 0, -10, "TOP", "TOP")
CreateAnchor("yoMoveToolTip",		"Move ToolTips", 150, 100, -5, 230, "BOTTOMRIGHT", "BOTTOMRIGHT")
CreateAnchor("yoMoveLoot", 			"Move Loot", 250, 50, 10, -270, "TOPLEFT","TOPLEFT")

CreateAnchor("yoMoveAltPower", 		"Move Power Alt Bar", 250, 70, 0, -150, 	"CENTER", "TOP")