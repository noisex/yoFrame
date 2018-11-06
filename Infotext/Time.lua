local L, yo = unpack( select( 2, ...))

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
		local pendingCalendarInvites = C_Calendar.GetNumPendingInvites()		
		if pendingCalendarInvites and pendingCalendarInvites > 0 then
			Text:SetText( "|cffFF0000NEW "..Hr24..":"..Min)
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

	if yo_AllData[myRealm][myName].PlayedLvl then		
		if yo_AllData[myRealm][myName].PlayedLvl < 86400 then
			GameTooltip:AddDoubleLine( format( TIME_PLAYED_LEVEL, ""), SecondsToClock(yo_AllData[myRealm][myName].PlayedLvl))
		else
			GameTooltip:AddDoubleLine( format( TIME_PLAYED_LEVEL, ""), SecondsToClock(yo_AllData[myRealm][myName].PlayedLvl, true, true))
		end
	
		GameTooltip:AddLine' '
		GameTooltip:AddLine( format( TIME_PLAYED_TOTAL, " "))

		local totalPlayed, oneDate = 0
		for k, v in pairs ( yo_AllData) do
			if type( v) == "table" then
				oneDate = false
				for kk, vv in pairs ( v) do	
					if tonumber( vv["Played"]) then
						if not oneDate then
							GameTooltip:AddDoubleLine( " ", k, 0.5, .5, .5, 0, 1, 1)  --- Realmane
							oneDate = true
						end	
						totalPlayed = totalPlayed + tonumber( vv["Played"])
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
		GameTooltip:AddDoubleLine( TOTAL, SecondsToClock( totalPlayed, true, true), 1, 1, 0, 0, 1, 0)		
	end

	GameTooltip:AddLine' '
	local Hr, Min = GetGameTime()
	if Min<10 then Min = "0"..Min end
	GameTooltip:AddDoubleLine( TIMEMANAGER_TOOLTIP_REALMTIME, Hr .. ":" .. Min, 1, 1, 0, 1, 1, 1)

	Hr24 = tonumber(date("%H"))
	Min = tonumber(date("%M"))
	if Min<10 then Min = "0"..Min end	
	GameTooltip:AddDoubleLine(TIMEMANAGER_TOOLTIP_LOCALTIME, Hr24 .. ":" .. Min, 1, 1, 0, 1, 1, 1)
	
	oneDate = false
	for i = 1, GetNumSavedInstances() do
		local name, id, reset, difficulty, locked, extended, _, isRaid, _, diff, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			local tr,tg,tb
			if not oneDate then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine( CALENDAR_FILTER_RAID_RESETS, SecondsToClock(reset, true, false))
				oneDate = true
			end

			if extended then tr,tg,tb = 0.3,1,0.3 else tr,tg,tb = 1,1,1 end

			if difficulty == 14 then
				diff = "|cffffff00"..diff..": |r"
			elseif difficulty == 15 then 
				diff = "|cff00ffff"..diff..": |r"
			elseif difficulty == 16 then 
				diff = "|cffff0000"..diff..": |r"
			elseif difficulty == 17 then 
				diff = "|cff00ff00"..diff..": |r"
			else
				diff = ""
			end	
			GameTooltip:AddDoubleLine( diff .. name, encounterProgress .. "/" .. numEncounters,1,1,1,tr,tg,tb)
		end
	end

	--GameTooltip:AddDoubleLine("ResetTime", SecondsToClock( GetQuestResetTime(), true))
	--GameTooltip:AddDoubleLine("Time", SecondsToClock( GetTime()))

	local questID = myFaction == "Horde" and 53435 or 53436
	
	if myLevel == MAX_PLAYER_LEVEL and not IsQuestFlaggedCompleted( questID) then
		GameTooltip:AddLine( " ")
		GameTooltip:AddLine( L["EXPEDIT_COMPLETE"],1,0,0)
	end
	GameTooltip:Show()
end

local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	--Stat:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	--Stat:SetScript("OnEvent", OnEvent)
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
