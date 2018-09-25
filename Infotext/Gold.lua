local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
local Profit	= 0
local Spent		= 0
local OldMoney	= 0

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%s".."|cffffd700г|r".." %d".."|cffc7c7cfс|r".." %d".."|cffeda55fз|r", commav( floor( gold)), silver, copper)		
	return cash
end	

local function newConfigData()

	local newname = UnitName("player")
	local realm = GetRealmName()

	if yo_AllData == nil then
		yo_AllData = {}
	end
	
	if yo_AllData[realm] == nil then
		yo_AllData[realm] = {}
	end

	if yo_AllData[realm][newname] == nil then
		yo_AllData[realm][newname] = {}
	end

	yo_AllData[realm][newname]["Money"] = GetMoney()
	yo_AllData[realm][newname]["MoneyDay"] = date()
	yo_AllData[realm][newname]["MoneyTime"] = time()

end

local function OnEvent(self, event)
	if not yo["Addons"].InfoPanels then
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

	local myPlayerRealm = GetRealmName()
	local myPlayerName  = UnitName("player")
	local keystone = ""
			
	self:SetScript("OnEnter", function()
			local totalMoney = 0

			self.hovered = true 
			GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
			GameTooltip:ClearLines()
			GameTooltip:AddLine("За игру: ")
			GameTooltip:AddDoubleLine("Получено:", formatMoney(Profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine("Потрачено:", formatMoney(Spent), 1, 1, 1, 1, 1, 1)
			if Profit < Spent then
				GameTooltip:AddDoubleLine("Убыль:", formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
			elseif (Profit-Spent)>0 then
				GameTooltip:AddDoubleLine("Прибыль:", formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
			end				
			GameTooltip:AddLine' '								
			
			GameTooltip:AddLine("Общая информация: ")
			--GameTooltip:AddDoubleLine( UnitName("player"), FormatTooltipMoney( NewMoney), 1, 1, 1, 1, 1, 1)
			
			for k, v in pairs ( yo_AllData) do
				if type( v) == "table" then
					GameTooltip:AddDoubleLine( "  ", k, 0.5, .5, .5, 0, 1, 1)  --- Realmane
					for kk, vv in pairs ( v) do
						if vv["KeyStone"] ~= nil then
							keystone = " " .. vv["KeyStone"]
						else
							keystone = ""
						end
						if tonumber( vv["Money"]) and tonumber( vv["Money"]) > 100000 then
							totalMoney = totalMoney + tonumber( vv["Money"])
							GameTooltip:AddDoubleLine( kk .. keystone, FormatTooltipMoney( vv["Money"]), 1, 1, 0, 1, 1, 1)
						end
						
					end
				end
			end
			GameTooltip:AddLine' '	
			GameTooltip:AddDoubleLine( "Всего:", FormatTooltipMoney( totalMoney), 1, 1, 0, 0, 1, 0)
			
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
Stat:SetScript("OnMouseDown", function( self) 
	isOpen = not isOpen
	if IsShiftKeyDown() then
		yo_AllData = nil
		newConfigData()
		print("|cffff0000Все данные сброшены.|r")
	else
		if isOpen then
			OpenAllBags()		
		else
			CloseAllBags()
		end 
	end
end)

Stat:SetScript("OnEvent", OnEvent)

	-- reset gold data
local function RESETGOLD()
	local myPlayerRealm = GetCVar("realmName");
	local myPlayerName  = UnitName("player");
	
	Data.gold = {}
	Data.gold[myPlayerRealm]={}
	Data.gold[myPlayerRealm][myPlayerName] = GetMoney();
end
SLASH_RESETGOLD1 = "/resetgold"
SlashCmdList["RESETGOLD"] = RESETGOLD