--------------------------------------------------------------------
-- TIME
--------------------------------------------------------------------
local Text  = RightInfoPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont( font, ( fontsize or 10), "OVERLAY")
	Text:SetHeight( RightInfoPanel:GetHeight())
	Text:SetPoint("RIGHT", RightInfoPanel, "RIGHT", -5, 0)
	Text:SetShadowColor(0,0,0,1)
	Text:SetShadowOffset(0.5,-0.5)
RightInfoPanel.timeText = Text

local int = 0

local function Update(self, t)
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self:SetScript("OnEvent", nil)
		self:SetScript("OnUpdate", nil)
		Text = nil
		self = nil
		RightInfoPanel.timeText = nil
		return
	end
	
	int = int - t
	if int < 0 then
		int = 10
		Hr24 = tonumber(date("%H"))
		Min = tonumber(date("%M"))

		if Min < 10 then 
			Min = "0" .. Min 
		end
			
		-- BFA
		--local pendingCalendarInvites = CalendarGetNumPendingInvites()		
		if pendingCalendarInvites and pendingCalendarInvites > 0 then
			Text:SetText( "|cffFF0000"..Hr24..":"..Min)
		else
			Text:SetText( myColorStr..Hr24..":"..myColorStr..Min)
		end
		self:SetAllPoints(Text)
	end
end

local function OnEnter( self)
	OnLoad = function(self) RequestRaidInfo() end
		
	GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6)
	GameTooltip:ClearLines()
	GameTooltip:SetBackdropColor( 0, 0, 0, 1)
	GameTooltip:SetAlpha(1)

	GameTooltip:AddDoubleLine( TIME_PLAYED_MSG, SecondsToClock( GetTime() - myLogin))
	if yo_AllData[myRealm][myName].PlayedLvl < 86400 then
		GameTooltip:AddDoubleLine( format( TIME_PLAYED_LEVEL, ""), SecondsToClock(yo_AllData[myRealm][myName].PlayedLvl))
	else
		GameTooltip:AddDoubleLine( format( TIME_PLAYED_LEVEL, ""), SecondsToClock(yo_AllData[myRealm][myName].PlayedLvl, true, true))
	end
	
	GameTooltip:AddLine' '
	GameTooltip:AddLine( format( TIME_PLAYED_TOTAL, " "))

	local totalMoney = 0
	for k, v in pairs ( yo_AllData) do
		if type( v) == "table" then
			GameTooltip:AddDoubleLine( " ", k, 0.5, .5, .5, 0, 1, 1)  --- Realmane
			for kk, vv in pairs ( v) do
				if tonumber( vv["Played"]) then
					totalMoney = totalMoney + tonumber( vv["Played"])
					local cols = vv["Color"] and vv["Color"] or { 1, 0.75, 0}
					if vv["Played"] < 86400 then
						GameTooltip:AddDoubleLine( kk, SecondsToClock( vv["Played"]), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
					else
						GameTooltip:AddDoubleLine( kk, SecondsToClock( vv["Played"], true, true), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
					end
				end	
			end
			GameTooltip:AddLine' '
		end
	end		
	GameTooltip:AddDoubleLine( TOTAL, SecondsToClock( totalMoney, true, true), 1, 1, 0, 0, 1, 0)
	GameTooltip:AddLine' '

	local Hr, Min = GetGameTime()
	if Min<10 then Min = "0"..Min end
	GameTooltip:AddDoubleLine( TIMEMANAGER_TOOLTIP_REALMTIME, Hr .. ":" .. Min, 1, 1, 0, 1, 1, 1)

	Hr24 = tonumber(date("%H"))
	Min = tonumber(date("%M"))
	if Min<10 then Min = "0"..Min end	
	GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, Hr24 .. ":" .. Min, 1, 1, 0, 1, 1, 1)
	
	local oneraid
	for i = 1, GetNumSavedInstances() do
		local name,_,reset,difficulty,locked,extended,_,isRaid,maxPlayers = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			local tr,tg,tb,diff
			if not oneraid then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine( CALENDAR_FILTER_RAID_RESETS)
				oneraid = true
			end

			local function fmttime(sec,table)
			local table = table or {}
			local d,h,m,s = ChatFrame_TimeBreakDown(floor(sec))
			local string = gsub(gsub(format(" %dd %dh %dm "..((d==0 and h==0) and "%ds" or ""),d,h,m,s)," 0[dhms]"," "),"%s+"," ")
			local string = strtrim(gsub(string, "([dhms])", {d=table.days or "d",h=table.hours or "h",m=table.minutes or "m",s=table.seconds or "s"})," ")
			return strmatch(string,"^%s*$") and "0"..(table.seconds or L"s") or string
		end
		if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end
		if difficulty == 3 or difficulty == 4 then diff = "H" else diff = "N" end
		GameTooltip:AddDoubleLine(name,fmttime(reset),1,1,1,tr,tg,tb)
		end
	end
	GameTooltip:Show()
end

local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	--Stat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	--Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	--Stat:RegisterEvent("UPDATE_INSTANCE_INFO")

	Stat:SetScript("OnUpdate", Update)
	Stat:SetScript("OnEnter", OnEnter)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn == 'RightButton'  then
			ToggleTimeManager()
		else
			GameTimeFrame:Click()
		end
	end)

Update(Stat, 0)
