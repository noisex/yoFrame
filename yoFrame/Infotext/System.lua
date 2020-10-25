local L, yo = unpack( select( 2, ...))

--------------------------------------------------------------------
-- System Stats
--------------------------------------------------------------------

local Text  = LeftInfoPanel:CreateFontString(nil, "OVERLAY")
	Text:SetHeight( LeftInfoPanel:GetHeight())
	Text:SetPoint("LEFT", LeftInfoPanel, "LEFT", 5, 0)
LeftInfoPanel.systemText = Text

local colorme = string.format("%02x%02x%02x", 1*255, 1*255, 1*255)

local function formatMem(memory, color)
	if color then
		statColor = { "|cff"..colorme, "|r" }
	else
		statColor = { "", "" }
	end

	local mult = 10^1
	if memory > 999 then
		local mem = floor((memory/1024) * mult + 0.5) / mult
		if mem  %1 == 0 then
			return mem..string.format(".0 %sMb%s", unpack(statColor))
		else
			return mem..string.format(" %sMb%s", unpack(statColor))
		end
	else
		local mem = floor(memory * mult + 0.5) / mult
			if mem  %1 == 0 then
				return mem..string.format(".0 %sKb%s", unpack(statColor))
			else
				return mem..string.format(" %sKb%s", unpack(statColor))
			end
	end
end

local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory

local function RefreshMem(self)
	Memory = {}
	UpdateAddOnMemoryUsage()
	Total = 0
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end

	MEMORY_TEXT = formatMem(Total, true)
	table.sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)
	self:SetAllPoints(Text)
end

local int, int2 = 10, 1

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
		LeftInfoPanel.systemText = nil
		return
	end
	int = int - t
	int2 = int2 - t
	local fpscolor
	local latencycolor

	if int < 0 then
		RefreshMem(self)
		int = 10
	end
	if int2 < 0 then
		if select(3, GetNetStats()) < 300 then
			latencycolor = "|cff0CD809"
		elseif (select(3, GetNetStats()) > 300 and select(3, GetNetStats()) < 500) then
			latencycolor = "|cffE8DA0F"
		else
			latencycolor = "|cffD80909"
		end
		if floor(GetFramerate()) >= 30 then
			fpscolor = "|cff0CD809"
		elseif (floor(GetFramerate()) > 15 and floor(GetFramerate()) < 30) then
			fpscolor = "|cffE8DA0F"
		else
			fpscolor = "|cffD80909"
		end
		Text:SetText(fpscolor..floor(GetFramerate()).."|r".."fps "..latencycolor..select(3, GetNetStats()).."|r".."ms")
		int2 = 0.8
	end
end

local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)

	Stat:SetScript("OnMouseDown", function () collectgarbage("collect") Update(Stat, 20) end)
	Stat:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		GameTooltip:ClearLines()
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
		GameTooltip:AddLine(myColorStr..latency)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Total Memory Usage:",formatMem(Total), 0, 0.6, 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		for i = 1, #Memory do
			if Memory[i][3] then
				local red = Memory[i][2]/Total*2
				local green = 1 - red
				GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)
			end
		end
		GameTooltip:Show()
	end)

	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnEvent", function(self, ...)
		Text:SetFont( yo.font, ( yo.fontsize or 10), "OVERLAY")
		Stat:UnregisterEvent("PLAYER_ENTERING_WORLD")
		Stat:SetScript("OnUpdate", Update)
	end)

--Update(Stat, 20)