local addon, ns = ...
local L, yo, N = unpack( ns)

local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub
local texture, texglow = yo.texture, yo.texglow

function isDruid( self)
	if myClass == "DRUID" and GetShapeshiftFormID() ~= 1 then
		--self:Hide()
		return false
	else
		--self:Show()
		return true
	end
end

-------------------------------------------------------------------------------------------
local function updateStatusBars()
	for k, bar in pairs( N.statusBars) do

		if bar and bar:GetStatusBarTexture() then
			bar:SetStatusBarTexture( yo.Media.texture)
		end
	end
end
N.conFuncs["texture"] = updateStatusBars

local function updateStrings( var, newVal, curVal)
	for k, string in pairs( N.strings) do
		if string then
			local fn, fs, fc = string:GetFont()
			string:SetFont( fn, fs - curVal + newVal, fc)
		end
	end
end
N.conFuncs["fontsize"] = updateStrings

function UpdateShadows( r, g, b)
	for k, bar in pairs( N.shadows) do
		bar:SetBackdropBorderColor(r, g, b, 0.9)
	end
end


-----------------------------------------------------------------------------------------------

function checkToClose(...)

	if yo_WIM 			and yo_WIM:IsShown() 			then yo_WIM:Hide() end
	if yo_BBFrame.bag 	and yo_BBFrame.bag:IsShown()	then yo_BBFrame.bag:Hide() end
	if yo_DuLoot 		and yo_DuLoot:IsShown()			then yo_DuLoot:Hide()	end
	if yo_Bags.bagFrame and yo_Bags.bagFrame:IsShown()  then yo_Bags.bagFrame:Hide() end

end

if not ContainerFrame4  then
	ContainerFrame4 = CreateFrame("Frame", "ContainerFrame4", UIParent)
	ContainerFrame4:SetPoint("CENTER")
end

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
		object.Show = dummy
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
	f.border:SetFrameLevel( level or 0)
	f.border:SetFrameStrata( f:GetFrameStrata())
	--f.border:SetFrameStrata( "BACKGROUND")

	f.border.glow = f.border:CreateTexture(nil, "BORDER")
	f.border.glow:SetPoint( "CENTER", f.border, "CENTER", 0, 0)
	f.border.glow:SetVertexColor( 0.15, 0.15, 0.15, 0.9)
	f.border.glow:SetTexture( "Interface\\Buttons\\UI-Quickslot2")
	f.border.glow:SetHeight( f:GetHeight() * 1.85)
	f.border.glow:SetWidth( f:GetWidth() * 1.85)
	--f.border.glow:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\boder6px.blp")
	--f.border.glow:SetVertexColor( 0.05, 0.05, 0.05, 0.9)
	--f.border.glow:SetHeight( f:GetHeight() * 1.3)
	--f.border.glow:SetWidth( f:GetWidth() * 1.3)
end

function CreateStyle(f, size, level, alpha, alphaborder)
    if f.shadow then return end
    local size = size or 2
    size = max( 1, size + yo.Media.edgeSize)

	local style = {
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = texglow,
		--edgeFile = "Interface\\Buttons\\WHITE8x8",
		--edgeFile = [=[Interface\Addons\yoFrame\Media\blank.tga]=],

		edgeSize = size,
		--insets = { left = size, right = size, top = size, bottom = size }
		insets = { left = size, right = size, top = size, bottom = size }
	}

    local shadow = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate")
    shadow:SetFrameLevel( level or 0)
    shadow:SetFrameStrata( f:GetFrameStrata())
    shadow:SetPoint("TOPLEFT", f, "TOPLEFT", -size, size)
    shadow:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", size, -size)
    shadow:SetBackdrop( style)
    local r, g, b = strsplit( ",", yo.Media.shadowColor)

    shadow:SetBackdropColor(.075,.075,.086, alpha or 1)
	shadow:SetBackdropBorderColor( r, g, b, alphaborder or 1)	--(0, 0, 0, alphaborder or 1)
    f.shadow = shadow
    table.insert( N["shadows"], f.shadow)
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
    shadow:SetBackdropColor(.07,.07,.07, alpha or 0.9)
	shadow:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
	table.insert( N["shadows"], f.shadow)
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
	--if yo.Media.classBorder then r, g, b = myColor.r, myColor.g, myColor.b end
	f:SetBackdropBorderColor( r, g, b, alphaborder or 0)	--(.15,.15,.15, alphaborder  or 0)
	--table.insert( N["shadows"], f)
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
	--if yo.Media.classBorder then r, g, b = myColor.r, myColor.g, myColor.b end
	f:SetBackdropBorderColor( r, g, b, alphaborder or 0) --(0, 0, 0, alphaborder or 1)
	--table.insert( N["shadows"], f)
end