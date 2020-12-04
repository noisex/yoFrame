local addon, ns = ...
local L, yo, n = unpack( ns)

local deletedelay, t = 0.5, 0
local takingOnlyCash = false
local button2, waitForMail, openAll, openMail, lastopened, stopOpening, needsToWait, total_cash
--local _G = _G
local baseInboxFrame_OnClick

function openAll()
	takingOnlyCash = true
	if GetInboxNumItems() == 0 then return end
	button2:SetScript("OnClick", nil)
	baseInboxFrame_OnClick = InboxFrame_OnClick
	InboxFrame_OnClick = n.dummy
	openMail(GetInboxNumItems())
end

function openMail(index)
	if not InboxFrame:IsVisible() then return stopOpening("Need a mailbox.") end
	if index == 0 then return stopOpening("Reached the end.") end
	local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(index)

	if not takingOnlyCash then
		if money > 0 or (numItems and numItems > 0) and COD <= 0 then
			AutoLootMailItem(index)
			needsToWait = true
		end
	elseif money > 0 then

		TakeInboxMoney(index)
		needsToWait = true
		--if total_cash then total_cash = total_cash - money end
	end
	local items = GetInboxNumItems()
	if (numItems and numItems > 0) or (items > 1 and index <= items) then
		lastopened = index
		button2:SetScript("OnUpdate", waitForMail)
	else
		stopOpening( "All done. Received: " .. formatMoney( total_cash))
	end
end

function waitForMail(this, arg1)
	t = t + arg1
	if (not needsToWait) or (t > deletedelay) then
		if not InboxFrame:IsVisible() then return stopOpening("Need a mailbox.") end
		t = 0
		needsToWait = false
		button2:SetScript("OnUpdate", nil)

		local _, _, _, _, money, COD, _, numItems = GetInboxHeaderInfo(lastopened)
		if money > 0 or ((not takingOnlyCash) and COD <= 0 and numItems and (numItems > 0)) then
			--The lastopened index inbox item still contains stuff we want
			openMail(lastopened)
		else
			openMail(lastopened - 1)
		end
	end
end

function stopOpening(msg, ...)
	button2:SetScript("OnClick", openAll)
	if baseInboxFrame_OnClick then
		InboxFrame_OnClick = baseInboxFrame_OnClick
	end
	takingOnlyCash = false
	--total_cash = nil
	needsToWait = false
	if msg then DEFAULT_CHAT_FRAME:AddMessage("OpenAll: "..msg, ...) end
end

button2 = makeUIButton("yo_OpenAllButton2", InboxFrame, MONEY, 80, 25, 15, -398)

button2:SetScript("OnClick", openAll)
button2:SetScript("OnLeave", function() GameTooltip:Hide() end)
button2:SetScript("OnEnter", function()
	--if not total_cash then
	total_cash = 0
	for index=0, GetInboxNumItems() do
		total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
	end
	--end
	GameTooltip:SetOwner(button2, "ANCHOR_RIGHT")
	GameTooltip:AddLine( ENCLOSED_MONEY .. ": " .. formatMoney(total_cash), 1, 1, 1)
	GameTooltip:Show()
end)

--InboxFrame:HookScript("OnShow", function(self, ...)
--	total_cash = 0
--	for index=0, GetInboxNumItems() do
--		total_cash = total_cash + select(5, GetInboxHeaderInfo(index))
--	end
--	--print(total_cash)
--	if total_cash == 0 then
--		yo_OpenAllButton2:Disable()
--	else
--		yo_OpenAllButton2:Enable()
--	end
--end)

OpenAllMail:ClearAllPoints()
OpenAllMail:SetPoint("CENTER", InboxFrame, "TOP", -65, -398)
OpenAllMail:SetWidth( 80)
OpenAllMail:SetHeight( 25)
--Kill( OpenAllMail)
--OpenAllMail:Hide()
