local L, yo = unpack( select( 2, ...))

---------------------
-- Font
---------------------
local function mySetFont( fontObj, fontsSize )
	if fontObj then
		local ft, fs, fd = fontObj:GetFont()
		fontObj:SetFont( font, floor( max(( fontsSize or sysfontsize), fs-2)), fd)
	end
end

function ChangeSystemFonts( fontsSize)
	--local ind = 0
	--yo_fArray = {}
	for i,v in pairs( _G ) do
		if type( v) == "table" and  ( i:match( "Font") or i:match("Tooltip")) and ( not i:match("StoreTooltip")) then --and ( not i:match("SystemFont")) then

			local var = _G[i]

			if var.GetObjectType and var:GetObjectType() == "Font" then
				local ft, fs, fd = var:GetFont()
				if ft and fs then
	--				ind = ind +1
					--if ind >= 1 and ind < 135 then
						if fs > 120 then fs = 12 end
						--print( i, " fs:", fs, fd, " yfs:", floor( max(( fontsSize or sysfontsize), fs-2)))

						--_G[i]:SetFont( font, floor( max( fontsSize or sysfontsize), fs-2), fd)

						var:SetFont( font, fs, fd)

--						local ftN, fsN, fdN = var:GetFont()
						--yo_fArray[ind] = { i, ft, ftN, fs, fd}
--						if ftN == font then
							--_G[i]:SetFont( font, floor( max( fontsSize or sysfontsize), fsN-2), fdN)
--						end

					--end
				end
			end
		end
	end

	--print( ind)


	--mySetFont(_G.GameFontNormalLarge, fontsSize)
	mySetFont(_G.GameFontHighlightSmall, fontsSize)
	mySetFont(_G.GameFontHighlight, fontsSize)
	mySetFont(_G.ChatFontNormal, fontsSize)
	mySetFont(_G.GameTooltipText, fontsSize)
	mySetFont(_G.GameTooltipTextSmall, fontsSize)
	mySetFont(_G.GameTooltipHeader, fontsSize)
	mySetFont(_G.GameTooltipHeaderText, fontsSize)
	mySetFont(_G.GameFontNormalSmall, fontsSize)
	mySetFont(_G.AchievementFont_Small, fontsSize)
	mySetFont(_G.BossEmoteNormalHuge, fontsSize)
	mySetFont(_G.ChatBubbleFont, fontsSize)
	mySetFont(_G.CoreAbilityFont, fontsSize)
	mySetFont(_G.DestinyFontHuge, fontsSize)
	mySetFont(_G.DestinyFontMed, fontsSize)
	mySetFont(_G.Fancy12Font, fontsSize)
	mySetFont(_G.Fancy14Font, fontsSize)
	mySetFont(_G.Fancy22Font, fontsSize)
	mySetFont(_G.Fancy24Font, fontsSize)
	mySetFont(_G.FriendsFont_Large, fontsSize)
	mySetFont(_G.FriendsFont_Normal, fontsSize)
	mySetFont(_G.FriendsFont_Small, fontsSize)
	mySetFont(_G.FriendsFont_UserText, fontsSize)
	mySetFont(_G.Game12Font, fontsSize)
	mySetFont(_G.Game13FontShadow, fontsSize)
	mySetFont(_G.Game15Font_o1, fontsSize)
	mySetFont(_G.Game16Font, fontsSize)
	mySetFont(_G.Game18Font, fontsSize)
	mySetFont(_G.Game24Font, fontsSize)
	mySetFont(_G.Game30Font, fontsSize)
	mySetFont(_G.Game42Font, fontsSize)
	mySetFont(_G.Game46Font, fontsSize)
	mySetFont(_G.Game48Font, fontsSize)
	mySetFont(_G.Game48FontShadow, fontsSize)
	mySetFont(_G.Game60Font, fontsSize)
	mySetFont(_G.Game72Font, fontsSize)
	mySetFont(_G.Game120Font, fontsSize)
	mySetFont(_G.GameFont_Gigantic, fontsSize)
	mySetFont(_G.GameFontHighlightMedium, fontsSize)
	mySetFont(_G.GameFontHighlightSmall2, fontsSize)
	mySetFont(_G.GameFontNormalHuge2, fontsSize)
	mySetFont(_G.GameFontNormalLarge2, fontsSize)
	mySetFont(_G.GameFontNormalMed1, fontsSize)
	mySetFont(_G.GameFontNormalMed2, fontsSize)
	mySetFont(_G.GameFontNormalMed3, fontsSize)
	mySetFont(_G.GameFontNormalSmall2, fontsSize)
	mySetFont(_G.GameTooltipHeader, fontsSize)
	mySetFont(_G.InvoiceFont_Med, fontsSize)
	mySetFont(_G.InvoiceFont_Small, fontsSize)
	mySetFont(_G.MailFont_Large, fontsSize)
	mySetFont(_G.NumberFont_Outline_Huge, fontsSize)
	mySetFont(_G.NumberFont_Outline_Large, fontsSize)
	mySetFont(_G.NumberFont_Outline_Med, fontsSize)
	mySetFont(_G.NumberFont_OutlineThick_Mono_Small, fontsSize)
	mySetFont(_G.NumberFont_Shadow_Med, fontsSize)
	mySetFont(_G.NumberFont_Shadow_Small, fontsSize)
	mySetFont(_G.NumberFontNormalSmall, fontsSize)
	mySetFont(_G.Number11Font, fontsSize)
	mySetFont(_G.Number12Font, fontsSize)
	mySetFont(_G.Number15Font, fontsSize)
	mySetFont(_G.PriceFont, fontsSize)
	mySetFont(_G.PVPArenaTextString, fontsSize)
	mySetFont(_G.PVPInfoTextString, fontsSize)
	mySetFont(_G.ObjectiveFont, fontsSize)
	--mySetFont(_G.QuestFont, fontsSize)
	mySetFont(_G.QuestTitleFont, fontsSize)
	mySetFont(_G.QuestFont_Enormous, fontsSize)
	mySetFont(_G.QuestFont_Huge, fontsSize)
	mySetFont(_G.QuestFont_Large, fontsSize)
	mySetFont(_G.QuestFont_Shadow_Huge, fontsSize)
	mySetFont(_G.QuestFont_Shadow_Small, fontsSize)
	mySetFont(_G.QuestFont_Super_Huge, fontsSize)
	mySetFont(_G.ReputationDetailFont, fontsSize)
	mySetFont(_G.SubZoneTextFont, fontsSize)
	mySetFont(_G.SubZoneTextString, fontsSize)
	mySetFont(_G.SystemFont_Huge1, fontsSize)
	mySetFont(_G.SystemFont_Huge1_Outline, fontsSize)
	mySetFont(_G.SystemFont_Large, fontsSize)
	mySetFont(_G.SystemFont_Med1, fontsSize)
	mySetFont(_G.SystemFont_Med3, fontsSize)
	mySetFont(_G.SystemFont_Outline, fontsSize)
	mySetFont(_G.SystemFont_Outline_Small, fontsSize)
	mySetFont(_G.SystemFont_OutlineThick_Huge2, fontsSize)
	mySetFont(_G.SystemFont_OutlineThick_WTF, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Huge1, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Huge3, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Large, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Large2, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Large_Outline, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Med1, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Med2, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Med3, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Med3, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Outline_Huge2, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Small, fontsSize)
	mySetFont(_G.SystemFont_Small, fontsSize)
	mySetFont(_G.SystemFont_Tiny, fontsSize)
	mySetFont(_G.Tooltip_Med, fontsSize)
	mySetFont(_G.Tooltip_Small, fontsSize)
	mySetFont(_G.ZoneTextString, fontsSize)
	mySetFont(_G.Game10Font_o1, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Huge4, fontsSize)
	mySetFont(_G.SystemFont_Shadow_Outline_Huge4, fontsSize)
	mySetFont(_G.Number11Font, fontsSize)
	mySetFont(_G.Number12Font_o1, fontsSize)
	mySetFont(_G.Number13Font, fontsSize)
	mySetFont(_G.Number13FontGray, fontsSize)
	mySetFont(_G.Number13FontWhite, fontsSize)
	mySetFont(_G.Number13FontYellow, fontsSize)
	mySetFont(_G.Number14FontGray, fontsSize)
	mySetFont(_G.Number14FontWhite, fontsSize)
	mySetFont(_G.Number18Font, fontsSize)
	mySetFont(_G.Number18FontWhite, fontsSize)
	mySetFont(_G.FriendsFont_11, fontsSize)
	mySetFont(_G.SpellFont_Small, fontsSize)
	mySetFont(_G.SubSpellFont, fontsSize)
	--mySetFont(_G.QuestFontLeft, fontsSize)
	--mySetFont(_G.QuestFontNormalSmall, fontsSize)

--	_G["GameFontNormalMed2"]:SetFont( font, 12, "OUTLINE")
--	_G["ChatBubbleFont"]:SetFont( font, 12, "OUTLINE")

--	_G["ChatFontNormal"]:SetFont( font, fontsize)
	_G["ErrorFont"]:SetFont( font, 22)
	_G["QuestFont"]:SetFont( font, 12)
	_G["QuestFontLeft"]:SetFont( font, 13)
	_G["QuestFontNormalSmall"]:SetFont( font, 13)
	_G["GameFontNormalLarge"]:SetFont( font, 14)
end

local Fonts = CreateFrame("Frame", nil, UIParent)
Fonts:RegisterEvent("PLAYER_ENTERING_WORLD")
Fonts:SetScript("OnEvent", function(self, event, addon)

	if not yo.Addons.ChangeSystemFonts then return end

	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18}
	self:UnregisterAllEvents()

	ChangeSystemFonts()
end)


---------------------------------

--[[
local addon, ns = ...
local UIP = UIParent
local CF = CreateFrame
local _G = _G
local unpack = unpack
local wipe = wipe

print(addon.." loaded")

local width = 600
local height = 300

-- content data func

local function generateScrollChildData(scrollChild,maxx)
	local genv = getfenv(0)

	-- Collect the names of all possible globally defined fonts
	local fonts = {}
	for i,v in pairs( _G ) do
    	if type( v) == "table" and  ( i:match( "Font") or i:match("Tooltip")) and ( not i:match("StoreTooltip")) then --and ( not i:match("SystemFont")) then
      	local var = _G[i]

      	if var.GetObjectType and var:GetObjectType() == "Font" then
        	local ft, fs, fd = var:GetFont()
        	if ft and fs then
            	table.insert(fonts, i)
        	end
      	end
    end
end

-- Sort the list alphabetically
table.sort(fonts)

-- Create a table that will contain the font strings themselves
scrollChild.fstrings = scrollChild.fstrings or {}

-- This changes the padding between font strings vertically
local PADDING = 5

-- Store the max width and overall height of the scroll child
local height = 0
local width = 0

-- Iterate the list of fonts collected
for idx, fname in ipairs(fonts) do
   -- If the font string is not created, do so
   if not scrollChild.fstrings[idx] then
      --print(idx, fname)
      scrollChild.fstrings[idx] = scrollChild:CreateFontString("FPreviewFS" .. idx, "OVERLAY")
   end

   -- Set the font string to the correct font object, set the text to be the
   -- name of the font and set the height/width of the font string based on
   -- the size of the resulting 'string'.
   local fs = scrollChild.fstrings[idx]
   fs:SetFontObject(genv[fname])
   fs:SetText(fname)
   local fwidth = fs:GetStringWidth()
   local fheight = fs:GetStringHeight()
   --fs:SetSize(fwidth, fheight)
   fs:SetHeight(fheight)

   -- Place the font strings in rows starting at the top-left
   if idx == 1 then
      fs:SetPoint("TOPLEFT", 0, 0)
      height = height + fheight
   else
      fs:SetPoint("TOPLEFT", scrollChild.fstrings[idx - 1], "BOTTOMLEFT", 0, - PADDING)
      height = height + fheight + PADDING
   end

   -- Update the 'max' width of the frame
   width = (fwidth > width) and fwidth or width
end
  scrollChild:SetSize(300, 600)
  scrollChild:SetHeight( 600)
end

local function genData(scrollChild,maxx)
  if not maxx then maxx = 99 end
  scrollChild.data = scrollChild.data or {}
  local padding = 10
  local height = 0
  local width = 0
  for i=1, maxx  do
     scrollChild.data[i] = scrollChild.data[i] or scrollChild:CreateFontString(nil, nil, "GameFontBlackMedium")
     local fs = scrollChild.data[i]
     fs:SetText("String"..i)
     local fheight = fs:GetStringHeight()
     if i == 1 then
        fs:SetPoint("TOPLEFT", 0, 0)
     else
        fs:SetPoint("TOPLEFT", scrollChild.data[i - 1], "BOTTOMLEFT", 0, -padding)
     end
     height = height + fheight + padding
  end
  scrollChild:SetHeight(height)
end


-- // SCROLLFRAME TEMPLATES

--template = "UIPanelScrollFrameTemplate"
--template = "UIPanelScrollFrameTemplate2"
--template = "MinimalScrollFrameTemplate"
--template = "FauxScrollFrameTemplate"
--template = "FauxScrollFrameTemplateLight"
--template = "ListScrollFrameTemplate"

-- // SCROLLBAR TEMPLATES

--template = "UIPanelScrollBarTemplate"
--template = "UIPanelScrollBarTrimTemplate"
--template = "UIPanelScrollBarTemplateLightBorder"
--template = "MinimalScrollBarTemplate"

--scroll frame
local scrollFrame = CreateFrame("ScrollFrame", addon, UIP, "UIPanelScrollFrameTemplate")

scrollFrame:SetSize(width, height)
scrollFrame:SetPoint("CENTER", UIParent, 0, 0)

local scrollBar = _G[addon.."ScrollBar"]
print(scrollBar:GetWidth())

--debug texture
local tex = scrollFrame:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(1,1,0,0.3)
tex:SetAllPoints()

--hack for the UIPanelScrollBarTemplate template that UIPanelScrollFrameTemplate is using
--I want the cosmetic border, so we add it manually
local tex = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-6)
tex:SetPoint("TOP",scrollFrame)
tex:SetPoint("RIGHT",scrollBar,3.7,0)
tex:SetPoint("BOTTOM",scrollFrame)
tex:SetWidth(scrollBar:GetWidth()+10)
tex:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
tex:SetTexCoord(0,0.45,0.1640625,1)
--debug texture
local tex2 = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-8)
tex2:SetTexture(1,1,1)
tex2:SetVertexColor(1,0,1,0.3)
tex2:SetAllPoints(tex)

--scroll child
local scrollChild = CreateFrame("Frame", "$parentScrollChild1")
scrollChild:SetWidth(scrollFrame:GetWidth())

local tex = scrollChild:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(0,1,1,0.3)
tex:SetAllPoints()

--LOAD SOME DATA and set the framesize
generateScrollChildData(scrollChild,20)
--genData(scrollChild,20)

scrollFrame:SetScrollChild(scrollChild)

scrollFrame:EnableMouse(true)

--make sure you cannot move the panel out of the screen
scrollFrame:SetClampedToScreen(true)


scrollFrame:SetMovable(true)

scrollFrame:SetResizable(true)

scrollFrame:SetUserPlaced(true)

scrollFrame:SetScript("OnSizeChanged", function(self) scrollChild:SetWidth(self:GetWidth()) end)

local frame = CF("Frame", "$parentResize", scrollFrame)
frame:SetSize(26,26)
frame:SetPoint("BOTTOMRIGHT",30,-30)

local texture = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
texture:SetAllPoints()
texture:SetTexture(1,1,1)
texture:SetVertexColor(0,1,1,0.6) --bugfix

frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
  if InCombatLockdown() then return end
  self:GetParent():StartSizing()
end)
frame:SetScript("OnDragStop", function(self)
  if InCombatLockdown() then return end
  self:GetParent():StopMovingOrSizing()
end)
frame:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(addon, 0, 1, 0.5, 1, 1, 1)
  GameTooltip:AddLine("Resize me!", 1, 1, 1, 1, 1, 1)
  GameTooltip:Show()
end)
frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

]]--