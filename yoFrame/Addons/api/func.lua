local addon, ns = ...
local L, yo, n = unpack( ns)

local tonumber, floor, ceil, abs, mod, modf, format, len, sub, pairs, type, select, unpack, tremove, max
	= tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, pairs, type, select, unpack, tremove, max
local texture, texglow = n.texture, n.texglow

local GetShapeshiftFormID, CreateFrame, print, time, strsplit, tinsert, BackdropTemplateMixin, GetPhysicalScreenSize
	= GetShapeshiftFormID, CreateFrame, print, time, strsplit, tinsert, BackdropTemplateMixin, GetPhysicalScreenSize

function isDruid( self)
	if n.myClass == "DRUID" and GetShapeshiftFormID() ~= 1 then
		--self:Hide()
		return false
	else
		--self:Show()
		return true
	end
end

local myDev = {
	["Нойзекс"] 	= true,
	["Дэмьер"] 		= true,
	["Ковальска"] 	= true,
	["Герсона"] 	= true,
	["Ыож"]			= true,
	--["Твитти"] 		= true,
}

dprint = function(...)
	if myDev[n.myName] then
		print( time(), "|cff33ff99yoDev:|cff999999", ... )
	end
end

local CreateStyleR = function( f, size, level, alpha, alphaborder)
	print(f, size, level, alpha, alphaborder)
end

function n:CopyTable(current, default)
	if type(current) ~= 'table' then
		current = {}
	end

	if type(default) == 'table' then
		for option, value in pairs(default) do
			current[option] = (type(value) == 'table' and n:CopyTable(current[option], value)) or value
		end
	end

	return current
end
-------------------------------------------------------------------------------------------
-- 						Where are my point
-------------------------------------------------------------------------------------------
function whereAreYouAre( self, vert, fullSelf)
	local cX, cY = self:GetCenter()
	local getscreenwidth, getscreenheight = GetPhysicalScreenSize()
	local shX = getscreenwidth /2 - cX
	local shY = getscreenheight /2 - cY

	if vert then
		if shY < 0 then
			if fullSelf then 	return -1, "TOPLEFT", self, "BOTTOMLEFT", "TOPRIGHT", self, "BOTTOMRIGHT"
			else				return -1, "TOP", self, "BOTTOM" end
		else
			if fullSelf then 	return 1, "BOTTOMLEFT", self, "TOPLEFT", "BOTTOMRIGHT", self, "TOPRIGHT"
			else 				return 1, "BOTTOM", self, "TOP" end
		end
	else
		if shX < 0 then
			if fullSelf then 	return -1, "TOPRIGHT", self, "TOPLEFT", "BOTTOMRIGHT", self, "BOTTOMLEFT"
			else 				return -1, "RIGHT", self, "LEFT" end
		else
			if fullSelf then 	return 1, "TOPLEFT", self, "TOPRIGHT", "BOTTOMLEFT", self, "BOTTOMRIGHT"
			else 				return 1, "LEFT", self, "RIGHT" end
		end
	end
end

-------------------------------------------------------------------------------------------
-- 						Delay from ElvUI
-------------------------------------------------------------------------------------------

local WaitTable = {}
local C_Timer_After = C_Timer.After
local WaitFrame = CreateFrame('Frame', 'yo_WaitFrame', UIParent)

WaitFrame:SetScript('OnUpdate', function( self, elapse)
	local i, el = 1, elapse
	while i <= #WaitTable do
		local data = WaitTable[i]
		if data[1] > elapse then
			data[1], i = data[1] - elapse, i + 1
		else
			tremove( WaitTable, i)
			data[2](unpack(data[3]))

			if #WaitTable == 0 then
				WaitFrame:Hide()
			end
		end
	end
end)

--Add time before calling a function
function yoDelay(delay, func, ...)
	if type(delay) ~= 'number' or type(func) ~= 'function' then
		return false
	end

	-- Restrict to the lowest time that the C_Timer API allows us
	if delay < 0.01 then delay = 0.01 end

	if select('#', ...) <= 0 then
		C_Timer_After(delay, func)
	else
		tinsert( WaitTable,{delay,func,{...}})
		WaitFrame:Show()
	end

	return true
end

-------------------------------------------------------------------------------------------
local function updateStatusBars()
	for k, bar in pairs( n.Addons.elements.statusBars) do

		if bar and bar:GetStatusBarTexture() then
			bar:SetStatusBarTexture( yo.Media.texture)
		end
	end
end
n.conFuncs["texture"] = updateStatusBars

local function updateStrings( var, newVal, curVal)
	curVal = curVal or 0
	for k, string in pairs( n.Addons.elements.strings) do
		if string then
			local fn, fs, fc = string:GetFont()
			string:SetFont( fn, fs - curVal + newVal, fc)
		end
	end
end
n.conFuncs["fontsize"] = updateStrings

function UpdateShadows( r, g, b)
	for k, bar in pairs( n.Addons.elements.shadows) do
		bar:SetBackdropBorderColor(r, g, b, 0.9)
	end
end

function n:updateCharacterData( key, value)

end

function n:newCgaracterData( personalConfig)
	if not n.allData 									 then n.allData= {} end
	if not n.allData.charactersData 					 then n.allData.charactersData = {} end
	if not n.allData.charactersData[n.myRealm] 			 then n.allData.charactersData[n.myRealm] = {} end
	if not n.allData.charactersData[n.myRealm][n.myName] then n.allData.charactersData[n.myRealm][n.myName] = {} end

	local myData = n.allData.charactersData[n.myRealm][n.myName]

	myData["Money"] 			= GetMoney()
	myData["MoneyDay"] 			= date()
	myData["MoneyTime"]			= time()
	myData["Class"] 			= n.myClass
	myData["Race"]				= select(2, UnitRace('player'))
	myData["Sex"]				= UnitSex('player')
	myData["Color"] 			= { ["r"] = n.myColor.r, ["g"] = n.myColor.g, ["b"] = n.myColor.b, ["colorStr"] = n.myColor.colorStr}
	myData["ColorStr"] 			= n.myColorStr
	myData["WorldBoss"] 		=  nil 							--FlagActiveBosses() ~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!!
	--myData["PersonalConfig"] 	= myData.PersonalConfig or personalConfig
end
-----------------------------------------------------------------------------------------------

--function checkToClose(...)

--	if yoEF.wim 	and yoEF.wim:IsShown() 		then yoEF.wim:Hide() end
--	if yoEF.duLoot 	and yoEF.duLoot:IsShown()	then yoEF.duLoot:Hide() end
--	if yo_BBFrame	and yo_BBFrame.bag 			and  yo_BBFrame.bag:IsShown()	then yo_BBFrame.bag:Hide() end
--	if yo_Bags		and yo_Bags.bagFrame 		and  yo_Bags.bagFrame:IsShown() then yo_Bags.bagFrame:Hide() end
--end

--if not ContainerFrame14  then
--	ContainerFrame14 = CreateFrame("Frame", "ContainerFrame14", UIParent)
--	ContainerFrame14:SetPoint("CENTER")
--	--ContainerFrame14:SetID(0)
--	--n.bags:CreateFilterIcon( ContainerFrame14)
--end

--if (wowtocversion > 90000) then Mixin( f, BackdropTemplateMixin) end
----------------------------------------------------------------------------------------
--	Kill object function
----------------------------------------------------------------------------------------
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()
function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = n.dummy
	end
	object:Hide()
end

function makeUIButton(id, frame, text, w, h, x, y)
	local button = CreateFrame("Button", id, frame, "UIPanelButtonTemplate")
	button:SetWidth(w)
	button:SetHeight(h)
	button:SetPoint("CENTER", frame, "TOP", x, y)
	button:SetText(text)
	return button
end

function CreateVirtualFrame(frame, point, size, alpha, alphaback)
	if point == nil then point = frame end
	if point.backdrop then return end

	size = ( size or 3)
	alpha = ( alpha or 1)
	alphaback = ( alphaback or 0)

	frame.back = frame:CreateTexture(nil, "BORDER")
	frame.back:SetDrawLayer("BORDER", -8)
	frame.back:SetPoint("TOPLEFT", point, "TOPLEFT", -3, 3)
	frame.back:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", 3, -3)
	frame.back:SetColorTexture( 0.15, 0.15, 0.15, alphaback)

	frame.bordertop = frame:CreateTexture(nil, "BORDER")
	frame.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -size, size)
	frame.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, size)
	frame.bordertop:SetHeight( size)
	frame.bordertop:SetColorTexture( 0, 0, 0, alpha)
	frame.bordertop:SetDrawLayer("BORDER", -7)

	frame.borderbottom = frame:CreateTexture(nil, "BORDER")
	frame.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -size, -size)
	frame.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", size, -size)
	frame.borderbottom:SetHeight( size)
	frame.borderbottom:SetColorTexture( 0, 0, 0, alpha)
	frame.borderbottom:SetDrawLayer("BORDER", -7)

	frame.borderleft = frame:CreateTexture(nil, "BORDER")
	frame.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -size, 0)
	frame.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", size, 0)
	frame.borderleft:SetWidth( size)
	frame.borderleft:SetColorTexture( 0, 0, 0, alpha)
	frame.borderleft:SetDrawLayer("BORDER", -7)

	frame.borderright = frame:CreateTexture(nil, "BORDER")
	frame.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", size, 0)
	frame.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -size, 0)
	frame.borderright:SetWidth( size)
	frame.borderright:SetColorTexture( 0, 0, 0, alpha)
	frame.borderright:SetDrawLayer("BORDER", -7)
end

function SetVirtualBorder(frame, r, g, b)
	if not frame.bordertop then
		CreateVirtualFrame(frame)
	end

	frame.bordertop:SetColorTexture(r, g, b)
	frame.borderbottom:SetColorTexture(r, g, b)
	frame.borderleft:SetColorTexture(r, g, b)
	frame.borderright:SetColorTexture(r, g, b)
end

function CreateNewBorder( f)
	if f.border then return end

	f.border = CreateFrame( "Button", nil, f)
	f.border:SetAllPoints( f)
	--f.border:SetFrameLevel( level or 0)
	f.border:SetFrameStrata( f:GetFrameStrata())
	--f.border:SetFrameStrata( "BACKGROUND")

	f.border.glow = f.border:CreateTexture(nil, "BORDER")
	f.border.glow:SetPoint( "CENTER", f.border, "CENTER", 0, 0)
	f.border.glow:SetVertexColor( 0.15, 0.15, 0.15, 0.9)
	f.border.glow:SetTexture( "Interface\\Buttons\\UI-Quickslot2")
	f.border.glow:SetHeight( f:GetHeight() * 1.85)
	f.border.glow:SetWidth( f:GetWidth() * 1.85)
	--f.border.glow:SetVertexColor( 0.05, 0.05, 0.05, 0.9)
	--f.border.glow:SetHeight( f:GetHeight() * 1.3)
	--f.border.glow:SetWidth( f:GetWidth() * 1.3)
end

function CreateStyle(f, size, level, alpha, alphaborder)
    if f.shadow then return end
    local size = size or 0
    --size = max( 3, size + yo.Media.edgeSize)
    --print(yo)
    --print( yo.Media.edgeSize)
    size = size + yo.Media.edgeSize

    local sSize = yo.Media.bdbSize
	local style = {
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = n.texglow,
		edgeSize = sSize,
		insets = { left = sSize, right = sSize, top = sSize, bottom = sSize }
	}

    local shadow = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate")
    shadow:SetFrameLevel( level or 0) --f:GetFrameLevel())-- - (level or 1))
    shadow:SetFrameStrata( f:GetFrameStrata())
    shadow:SetPoint("TOPLEFT", f, "TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop( style)

    local r, g, b = strsplit( ",", yo.Media.bdColor)
    shadow:SetBackdropColor( r, g, b, alpha or yo.Media.bdAlpha)

    local r, g, b = strsplit( ",", yo.Media.bdbColor)
	shadow:SetBackdropBorderColor( r, g, b, alphaborder or yo.Media.bdbAlpha)
    f.shadow = shadow
    tinsert( n.Addons.elements.shadows, f.shadow)
    return shadow
end


function CreateStyleSmall(f, size, level, alpha, alphaborder)
    if f.shadow then return end

    local size = size or 1
	local style = {
	--bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
	--edgeFile = "Interface\\TUTORIALFRAME\\UI-TutorialFrame-CalloutGlow.blp",
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	edgeSize = size,
	insets = { left = size, right = size, top = size, bottom = size}};

    local shadow = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate")
    shadow:SetFrameLevel(level or 0)
    shadow:SetFrameStrata(f:GetFrameStrata())
    shadow:SetPoint("TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop(style)

    local r, g, b = strsplit( ",", yo.Media.bdColor)
    shadow:SetBackdropColor( r, g, b, alpha or yo.Media.bdAlpha)

    local r, g, b = strsplit( ",", yo.Media.bdbColor)
	shadow:SetBackdropBorderColor( r, g, b, alphaborder or yo.Media.bdbAlpha)

	tinsert( n.Addons.elements.shadows, f.shadow)
    f.shadow = shadow
    return shadow
end


function CreatePanel(f, w, h, a1, p, a2, x, y, alpha, alphaborder)
	Mixin( f, BackdropTemplateMixin)
	f:SetFrameLevel( 1)
	f:SetHeight( h)
	f:SetWidth( w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
      edgeFile = "Interface\\Buttons\\WHITE8x8",
	  tile = false, tileSize = 0, edgeSize = 1,
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(.07,.07,.07, alpha or .9)
	local r, g, b = strsplit( ",", yo.Media.shadowColor)
	--if yo.Media.classBorder then r, g, b = n.myColor.r, n.myColor.g, n.myColor.b end
	f:SetBackdropBorderColor( r, g, b, alphaborder or 0)	--(.15,.15,.15, alphaborder  or 0)
	--table.insert( n["shadows"], f)
	return f
end


function frame1px(f)
	Mixin( f, BackdropTemplateMixin)

	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
		insets = {left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(.07,.07,.07, .9)
	f:SetBackdropBorderColor(.15,.15,.15, 0)
end


function SimpleBackground(f, w, h, a1, p, a2, x, y, alpha, alphaborder)
	--local _, class = UnitClass("player")
	--local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	f:SetFrameLevel(1)
	f:SetHeight(h)
	f:SetWidth(w)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = texture,
		edgeFile = texglow,
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	})
	f:SetBackdropColor(.07,.07,.07, alpha or 0.9)
	local r, g, b = strsplit( ",", yo.Media.shadowColor)
	--if yo.Media.classBorder then r, g, b = n.myColor.r, n.myColor.g, n.myColor.b end
	f:SetBackdropBorderColor( r, g, b, alphaborder or 0) --(0, 0, 0, alphaborder or 1)
	--table.insert( n["shadows"], f)
end

-------------------------------------------------------------------------------------------
-- 						ADD API
-------------------------------------------------------------------------------------------
local function addAPI(object)
	local mt = getmetatable(object).__index
	if not object.createStyle 		then mt.createStyle 		= CreateStyle end
	if not object.frame1px 			then mt.frame1px 			= frame1px end
	if not object.createStyleSmall 	then mt.createStyleSmall 	= CreateStyleSmall end
	if not object.kill 				then mt.kill 				= Kill end
	--if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	--if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	--if not object.CreateBackdrop then mt.CreateBackdrop = CreateBackdrop end
	--if not object.StripTextures then mt.StripTextures = StripTextures end
	--if not object.StyleButton then mt.StyleButton = StyleButton end
	--if not object.SkinButton then mt.SkinButton = SkinButton end
	--if not object.SkinIcon then mt.SkinIcon = SkinIcon end
	--if not object.FontString then mt.FontString = FontString end
	--if not object.FadeIn then mt.FadeIn = FadeIn end
	--if not object.FadeOut then mt.FadeOut = FadeOut end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addAPI(object)
addAPI(object:CreateTexture())
addAPI(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addAPI(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

-- Hacky fix for issue on 7.1 PTR where scroll frames no longer seem to inherit the methods from the "Frame" widget
local scrollFrame = CreateFrame("ScrollFrame")
addAPI(scrollFrame)