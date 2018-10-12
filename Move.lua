--local t_unlock = false
yo_AnchorFrames = {}
yo_Position = {}

SetAnchPosition = function(anch, realAnch)

	local ap, _, rp, x, y = anch:GetPoint()

	if realAnch then
		ap, _, rp, x, y = realAnch:GetPoint()	
		--print(ap, f, rp, x, y)
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

function CreateAnchor(name, text, width, height, x, y, p1, p2)
	t1 = ( p1 or "CENTER")
	t2 = ( p2 or "CENTER")
	f = CreateFrame("Frame", name, UIParent)
	f:SetPoint( t1, UIParent, t2, x, y)
	f:SetScale(1)
	f:SetFrameLevel( 10)
	f:SetFrameStrata("TOOLTIP")
	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetWidth(width)
	f:SetHeight(height)
	
	local h = CreateFrame("Frame", nil)
	h:SetFrameLevel(30)
	h:SetAllPoints(f)
	f.dragtexture = h
	
	local v = CreateFrame("Frame", nil, h)
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

function ySlashCmd(cmd)
	if InCombatLockdown() then print("Неее, только не в бою, неа...") return end
	if (cmd:match"reset") then
		AnchorsReset()
	else
		if t_unlock == false then
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

CreateAnchor("yo_MovePlayer", "Move Player", 200, 40, 470, 270, "BOTTOMLEFT", "BOTTOMLEFT")
CreateAnchor("yo_MoveTarget", "Move Target", 200, 40, -470, 270, "BOTTOMRIGHT", "BOTTOMRIGHT")

CreateAnchor("yo_MoveFocus", "Move Focus", 150, 25, 10, -50, "LEFT","LEFT")
CreateAnchor("yo_MoveToT", "Move Tar-Tar", 200, 30, 00, -1000)
CreateAnchor("yo_MoveBoss", "Move Boss", 170, 35, -370, -200, "TOPRIGHT", "TOPRIGHT")
CreateAnchor("yo_MoveQuestFrame", "Move Quest Frame", 230, 500, -5, -175, "TOPRIGHT", "TOPRIGHT")
CreateAnchor("yo_MoveFlashIcon", "Move flash icon", 70, 70, 0, 100)
CreateAnchor("yo_MoveArtifact", "Move Artifact", 10, 173, 452, 4, "BOTTOM", "BOTTOMLEFT")
CreateAnchor("yo_MoveExperience", "Move Experience", 10, 173, -452, 4, "BOTTOM", "BOTTOMRIGHT")
CreateAnchor("yo_MovePlayerCastBar", "Move Player CastBar", 436, 20, 0, 91, "CENTER", "BOTTOM")
CreateAnchor("yo_MoveRUP", "Move Utility Panel", 226, 18, 0, -10, "TOP", "TOP")
CreateAnchor("yo_MovePotatos", "Move Potatos", 40, 40, 250, 270, "BOTTOMLEFT", "BOTTOMLEFT")
CreateAnchor("yo_MoveToolTip", "Move ToolTips", 150, 100, -5, 230, "BOTTOMRIGHT", "BOTTOMRIGHT")
CreateAnchor("yo_MoveLoot", "Move Loot", 250, 50, 10, -270, "TOPLEFT","TOPLEFT")

CreateAnchor("yo_MoveABar1", "Move Action Bar #1", 445, 35, 0, 2, "BOTTOM", "BOTTOM")
CreateAnchor("yo_MoveABar2", "Move Action Bar #2", 445, 35, 0, 40, "BOTTOM", "BOTTOM")
CreateAnchor("yo_MoveABar3", "Move Action Bar #3", 445, 35, -1, 240, "BOTTOMRIGHT", "BOTTOMRIGHT")
CreateAnchor("yo_MoveABar4", "Move Action Bar #4", 445, 35, -1, 182, "BOTTOMRIGHT", "BOTTOMRIGHT")
CreateAnchor("yo_MoveABar5", "Move Action Bar #5", 35, 445, -5, -110, "RIGHT", "RIGHT")

CreateAnchor("yo_MoveAMicro", "Move MicroMenu Bar", 220, 18, -470, 2, "BOTTOMRIGHT", "BOTTOMRIGHT")

CreateAnchor("yo_MovePetBar", "Move Pet Bar", 330, 30, 449, 197, "RIGHT", "BOTTOMLEFT")
CreateAnchor("yo_MoveExtr", "Move Extro Button", 130, 60, 250, -200, "LEFT", "LEFT")

CreateAnchor("yo_MoveRaid", "Move Raid Party Frame", 520, 170, 10, -10, "TOPLEFT", "TOPLEFT")
CreateAnchor("yo_MoveAltPower", "Move Power Alt Bar", 250, 70, 0, -150, "CENTER", "TOP")

CreateAnchor("P_DEBUFF",	"Player Debuff",	40,	40,-400, 150, 	"CENTER", "CENTER")
CreateAnchor("P_BUFF", 		"Player Buff", 		40, 40,	-400, 100, 	"CENTER", "CENTER")
CreateAnchor("P_PROC", 		"Player Trinket and Azerit Procs", 	40, 40,	-400, 50, 	"CENTER", "CENTER")

CreateAnchor("P_CD", 		"Players Cooldowns",40,	40,	465, 178, "TOPLEFT", "BOTTOMLEFT")

CreateAnchor("T_DEBUFF",	"Target Debuff/Buff from player", 40, 40,	400, 100, 	"CENTER", "CENTER")

CreateAnchor("yo_MoveCTA",	"Move CTA погоня за сумкой", 220, 25,	-255, -175, 	"TOPRIGHT", "TOPRIGHT")
 --[[

Anchortank = CreateFrame("Frame","Move_tank",UIParent)
CreateAnchor(Anchortank, "Move tank", 80, 18)

	frame:Size(700, 200)
	frame:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 3)
	frame:Hide()
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetResizable(true)
	frame:SetMinResize(350, 100)
	frame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving();
			self.isMoving = true;
		elseif button == "RightButton" and not self.isSizing then
			self:StartSizing();
			self.isSizing = true;
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing();
			self.isMoving = false;
		elseif button == "RightButton" and self.isSizing then
			self:StopMovingOrSizing();
			self.isSizing = false;
		end
	end)
	frame:SetScript("OnHide", function(self)
		if ( self.isMoving or self.isSizing) then
			self:StopMovingOrSizing();
			self.isMoving = false;
			self.isSizing = false;
		end
	end)
	frame:SetFrameStrata("DIALOG") 
]]--
