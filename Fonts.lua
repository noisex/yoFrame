local L, yo = unpack( select( 2, ...))

---------------------
-- Font
---------------------
function ChangeSystemFonts( fontsSize)
	--local ind, rind = 0
	for i,v in pairs( _G ) do
		if type( v) == "table" and ( i:match( "Font") or i:match("Tooltip"))then
			local var = _G[i]
			if var.GetFont then
				local ft, fs, fd = var:GetFont()
				if ft and fs then
					--ind = ind +1
					--if ind > 88 and ind < 92 then
						if fs > 120 then fs = 12 end
						--print( i, ft, fs, fd)
						var:SetFont( font, max(( fontsSize or sysfontsize), fs-2) , fd)
					--end
				end
			end
		end
	end
	--print(ind, rind)

	_G["ChatBubbleFont"]:SetFont( font, 12, "OUTLINE")

	_G["ChatFontNormal"]:SetFont( font, fontsize)
	_G["ErrorFont"]:SetFont( font, 16)
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
