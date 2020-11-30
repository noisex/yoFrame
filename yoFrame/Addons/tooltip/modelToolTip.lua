local L, yo, n = unpack( select( 2, ...))
local _, addon = ...
--local oUF = addon.oUF

if not yo.ToolTip.enable then return end
if not yo.ToolTip.ladyMod then return end

yo_Model = CreateFrame("DressUpModel", nil, UIParent, "TooltipBorderedFrameTemplate")
yo_Model:Hide()
yo_Model:SetAlpha(1)
yo_Model:SetClampedToScreen(true);
yo_Model:SetFrameStrata("TOOLTIP");
yo_Model:SetSize(230, 300)
yo_Model:SetCustomCamera(1)
yo_Model:SetUnit("player")
--CreateStyle( yo_Model, 4, nil, 0.9)

local cashed

--local tooltip
--local function CheckTooltipFor(link, ...)
--    if not tooltip then
--        tooltip = CreateFrame("GameTooltip", "AppearanceTooltipScanningTooltip", nil, "GameTooltipTemplate")
--        tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
--    end
--    tooltip:ClearLines()

--    -- just showing tooltip for an itemid
--    -- uses rather innocent checking so that slot can be a link or an itemid
--    local link = tostring(link) -- so that ":match" is guaranteed to be okay
--    if not link:match("item:") then
--        link = "item:"..link
--    end
--    tooltip:SetHyperlink(link)

--    for i=2, tooltip:NumLines() do
--        local left = _G["AppearanceTooltipScanningTooltipTextLeft"..i]
--        --local right = _G["AppearanceTooltipScanningTooltipTextRight"..i]
--        if left and left:IsShown() then
--            local text = left:GetText()
--            for ii=1, select('#', ...) do
--                if string.match(text, (select(ii, ...))) then
--                    return text
--                end
--            end
--        end
--       --if right and right:IsShown() and string.match(right:GetText(), text) then return true end
--    end
--    return false
--end

--local function CanTransmogItem(itemLink)
--    local itemID = GetItemInfoInstant(itemLink)
--    if itemID then
--        local canBeChanged, noChangeReason, canBeSource, noSourceReason = C_Transmog.GetItemInfo(itemID)
--        return canBeSource, noSourceReason
--    end
--end

--local function PlayerHasAppearance(item)
--    if not CanTransmogItem(item) then
--        return false, false, true
--    end
--    local state = CheckTooltipFor(item, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN)
--    if state == TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN then
--        return
--    end
--    return true, state == TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN
--end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	if not yo.ToolTip.ladyMod or ( yo.ToolTip.ladyModShift and not IsShiftKeyDown()) then return end

	local _, itemLink = self:GetItem();
	if not itemLink then return end

	local itemID, _, _, slot = GetItemInfoInstant(itemLink);

	if ( slot and #slot > 5 and slot ~= "INVTYPE_FINGER" and slot ~= "INVTYPE_TRINKET" and slot ~= "INVTYPE_NECK" and slot ~= "INVTYPE_BAG") and itemLink ~= cashed then

		cashed = itemLink
		local x,y = self:GetCenter();
		local mogpoint, ownerpoint, shiftX

		if ( x  or  1)/ GetScreenWidth() > 0.5 then
			mogpoint = "RIGHT";
			ownerpoint = "LEFT";
			shiftX = -2
		else
			mogpoint = "LEFT";
			ownerpoint = "RIGHT";
			shiftX = 2
		end
		if ( y or 1) / GetScreenHeight() > 0.5 then
			mogpoint = "TOP"..mogpoint;
			ownerpoint = "TOP"..ownerpoint;
		else
			mogpoint = "BOTTOM"..mogpoint;
			ownerpoint = "BOTTOM"..ownerpoint;
		end

		--print( slot, mogpoint, ownerpoint)
		yo_Model:ClearAllPoints();
		yo_Model:SetPoint(mogpoint, GameTooltip, ownerpoint, shiftX, 0);

--myModel:SetCamera(0);     -- Selects facial camera
--myModel:SetCamera(1);     -- Selects front view full body camera
--myModel:SetCamera(2);     -- Selects camera at 0,0,0 (movable)

		yo_Model:Show()
		yo_Model:Undress()
		--yo_Model:SetItem(itemID)
		yo_Model:TryOn( itemLink)

		yo_Model:SetScript("OnUpdate",function(self,elapsed)
			yo_Model:SetFacing( yo_Model:GetFacing() + elapsed);
		end)
	end
end)

GameTooltip:HookScript( "OnHide", function(self)
	yo_Model:Hide()
	yo_Model:SetScript("OnUpdate",nil)
	cashed = nil
end)

        --if db.notifyKnown then
        --    local hasAppearance, appearanceFromOtherItem, notTransmoggable = ns.PlayerHasAppearance(link)

        --    local label
        --    if notTransmoggable then
        --        label = "|c00ffff00" .. TRANSMOGRIFY_INVALID_DESTINATION
        --    else
        --        if hasAppearance then
        --            if appearanceFromOtherItem then
        --                label = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t " .. (TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN):gsub(', ', ',\n')
        --            else
        --                label = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t " .. TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN
        --            end
        --        else
        --            label = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t |cffff0000" .. TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN
        --        end
        --        classwarning:SetShown(not appropriateItem)
        --    end
        --    known:SetText(label)
        --    known:Show()
        --end