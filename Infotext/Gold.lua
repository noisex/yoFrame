
local L, yo = unpack( select( 2, ...))

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Profit	= 0
local Spent		= 0
local OldMoney	= 0

local function newConfigData( personalConfig)

	if yo_AllData == nil then
		yo_AllData = {}
	end
	
	if yo_AllData[myRealm] == nil then
		yo_AllData[myRealm] = {}
	end

	if yo_AllData[myRealm][myName] == nil then
		yo_AllData[myRealm][myName] = {}
	end

	yo_AllData[myRealm][myName]["Money"] = GetMoney()
	yo_AllData[myRealm][myName]["MoneyDay"] = date()
	yo_AllData[myRealm][myName]["MoneyTime"] = time()
	yo_AllData[myRealm][myName]["Class"] = myClass
	yo_AllData[myRealm][myName]["Color"] = { ["r"] = myColor.r, ["g"] = myColor.g, ["b"] = myColor.b, ["colorStr"] = myColor.colorStr}
	yo_AllData[myRealm][myName]["ColorStr"] = myColorStr
	yo_AllData[myRealm][myName]["PersonalConfig"] = yo_AllData[myRealm][myName].PersonalConfig or personalConfig
end

local function OnEvent(self, event, ...)
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self:SetScript("OnEvent", nil)
		self:SetScript("OnUpdate", nil)
		Text = nil
		self = nil
		RightInfoPanel.goldText = nil
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		Text:SetFont( font, fontsize, "OVERLAY")
		Text:SetHeight(RightInfoPanel:GetHeight())
		Text:SetPoint("LEFT", RightInfoPanel, "LEFT", 10, 0)	
		RightInfoPanel.goldText = Text
		OldMoney = GetMoney()

		local ofunc = ChatFrame_DisplayTimePlayed
		function ChatFrame_DisplayTimePlayed() ChatFrame_DisplayTimePlayed = ofunc end
		RequestTimePlayed()

	elseif event == "TIME_PLAYED_MSG" then
		local playedtotal, playedlevel = ...
		yo_AllData[myRealm][myName]["Played"] = playedtotal
		yo_AllData[myRealm][myName]["PlayedLvl"] = playedlevel
	end
		
	local NewMoney	= GetMoney()
	local Change = NewMoney-OldMoney -- Positive if we gain money
		
	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end
		
	Text:SetText( formatMoney(NewMoney))
	
	newConfigData()

	self:SetAllPoints( Text)
	self:SetScript("OnEnter", function()
		local totalMoney = 0

		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()

		if Change ~= 0 then
			GameTooltip:AddLine(L["For the game"])
			if Profit > 0 then
				GameTooltip:AddDoubleLine(L["Received"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)	
			end
			
			if Spent > 0 then
				GameTooltip:AddDoubleLine(L["Spent"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)	
			end
			
			if Profit < Spent then
				GameTooltip:AddDoubleLine(L["Loss"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine(L["Profit"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end				
			GameTooltip:AddLine' '	
		end
				
		GameTooltip:AddLine(L["General information"])
			
		local oneDate
		for k, v in pairs ( yo_AllData) do
			if type( v) == "table" then		
				oneDate = false	
				for kk, vv in pairs ( v) do					
					local keystone = vv["KeyStone"] and " " .. vv["KeyStone"] or ""

					if tonumber( vv["Money"]) and tonumber( vv["Money"]) > 100000 then
						if not oneDate then
							GameTooltip:AddDoubleLine( "  ", k, 0.5, .5, .5, 0, 1, 1)  --- Realmane
							oneDate = true
						end	
						totalMoney = totalMoney + tonumber( vv["Money"])
						local cols = vv["Color"] and vv["Color"] or { 1, 0.75, 0}
							GameTooltip:AddDoubleLine( kk .. keystone, formatMoney( vv["Money"]), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
					end
					
				end
			end
		end
		GameTooltip:AddLine' '	
		GameTooltip:AddDoubleLine( L["TOTAL"], formatMoney( totalMoney), 1, 1, 0, 0, 1, 0)
			
		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(CURRENCY .. ":")
			end
			local r, g, b = 1,1,1
			if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
			if name and count then GameTooltip:AddDoubleLine(name, commav( count), r, g, b, 1, 1, 1) end
		end
		GameTooltip:Show()		
	end)

	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		
	OldMoney = NewMoney
end

Stat:RegisterEvent("PLAYER_MONEY")
Stat:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
Stat:RegisterEvent("SEND_MAIL_COD_CHANGED")
Stat:RegisterEvent("PLAYER_TRADE_MONEY")
Stat:RegisterEvent("TRADE_MONEY_CHANGED")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:RegisterEvent("TIME_PLAYED_MSG")

Stat:SetScript("OnMouseDown", function( self) 
	isOpen = not isOpen
	if IsShiftKeyDown() then
		local myPersonalConfig
		if yo_AllData[myRealm][myName] and yo_AllData[myRealm][myName].PersonalConfig then
			myPersonalConfig = true
		end
		yo_AllData = nil
		newConfigData( myPersonalConfig)
		print("|cffff0000All data reset.|r")
	else
		if isOpen then
			OpenAllBags()		
		else
			CloseAllBags()
		end 
	end
end)

Stat:SetScript("OnEvent", OnEvent)