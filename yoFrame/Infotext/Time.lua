local L, yo, N = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

local infoText = N.infoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

--------------------------------------------------------------------
-- TIME
--------------------------------------------------------------------
local int = 0

function Stat:update(t)
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
			self.Text:SetText( "|cffFF0000NEW "..Hr24..":"..Min)
		else
			self.Text:SetText( myColorStr..Hr24..":"..myColorStr..Min)
		end
		--self:SetWidth( self.Text:GetWidth())
	end
end

function Stat:onEnter()
	--OnLoad = function(self) RequestRaidInfo() end

	GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6)
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
		for realmName, realm in pairs ( yo_AllData) do
			if type( realm) == "table"  and realmName ~= "editHistory" then

				local tkeys = {}
      			for k, v in pairs( realm) do
         			table.insert(tkeys, { pleed = v.Played, name = k})
      			end

      			local function tableSortCat (a,b) return a.pleed < b.pleed end
       			table.sort( tkeys, tableSortCat)

				oneDate = false
				for _, v in pairs(tkeys) do
					value = realm[v.name]
					if value.WorldBoss and timeLastWeeklyReset() < value.MoneyTime then
						v.name = v.name .. value.WorldBoss
					end
					if tonumber( value["Played"]) then
						if not oneDate then
							GameTooltip:AddDoubleLine( " ", realmName, 0.5, .5, .5, 0, 1, 1)  --- Realmane
							oneDate = true
						end
						totalPlayed = totalPlayed + tonumber( value.Played)
						local cols = value.Color and value.Color or { 1, 0.75, 0}
						if value.Played < 86400 then
							GameTooltip:AddDoubleLine( v.name, SecondsToClock( value.Played), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
						else
							GameTooltip:AddDoubleLine( v.name, SecondsToClock( value.Played, true, true), cols.r, cols.g, cols.b, cols.r, cols.g, cols.b)
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

	--local questID = myFaction == "Horde" and 53435 or 53436

	--if myLevel == MAX_PLAYER_LEVEL and not IsQuestFlaggedCompleted( questID) then
	--	GameTooltip:AddLine( " ")
	--	GameTooltip:AddLine( L["EXPEDIT_COMPLETE"],1,0,0)
	--end

	--FlagActiveBosses()

	GameTooltip:Show()
end


function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	--print( self.parent, self.parentCount, self.parent:GetWidth(), self.index, self.shift)

	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self.parent, "LEFT", self.parent:GetWidth()/self.parentCount*( self.index - 1) + self.shift, 0)
	self:RegisterEvent( 'PLAYER_ENTERING_WORLD')

	self:SetScript("OnEnter", function( ) self:onEnter( self) end )
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnUpdate", self.update)
	self:SetScript("OnMouseDown", function( f, btn)
		if btn == 'RightButton'  then ToggleTimeManager()
		else GameTimeFrame:Click() end
	end)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:ClearAllPoints()
	self.Text:SetPoint( self.textSide, self, self.textSide, self.textShift, 0)
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	--CreateStyle( self, 2)
	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	self:UnregisterAllEvents()
	self:Hide()
end

infoText.infos.time 	= Stat
infoText.infos.time.name= "Time"

infoText.texts.time 	= "Time"
