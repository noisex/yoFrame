local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.ChangeSystemFonts then return end

---------------------
-- Font
---------------------

local function mySetFont( fontObj, fontsSize )
	if fontObj then
		local ft, fs, fd = fontObj:GetFont()
		fontObj:SetFont( n.font, floor( max(( fontsSize or n.sysfontsize), fs-2)), fd)
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
						var:SetFont( n.font, fs, fd)
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
	mySetFont(_G.GameFontNormal, fontsSize)
	mySetFont(_G.GameFontDisable, fontsSize)
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
	_G["ErrorFont"]:SetFont( n.font, 22)
	_G["QuestFont"]:SetFont( n.font, 12)
	_G["QuestFontLeft"]:SetFont( n.font, 13)
	_G["QuestFontNormalSmall"]:SetFont( n.font, 13)
	_G["GameFontNormalLarge"]:SetFont( n.font, 14)
end

CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18}
ChangeSystemFonts()