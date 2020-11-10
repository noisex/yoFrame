local L, yo, N = unpack( select( 2, ...))

-- if not yo.InfoTexts.enable then return end

N.InfoTexts["infos"] = {}

--------------------------------------------------------------------
-- System Stats
--------------------------------------------------------------------
local infoText = N.InfoTexts
local Stat = CreateFrame("Frame", nil, UIParent)

local colorme = string.format("%02x%02x%02x", 1*255, 1*255, 1*255)
local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory

function Stat:formatMem(memory, color)
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

function Stat:RefreshMem()
	Memory = {}
	UpdateAddOnMemoryUsage()
	Total = 0
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end

	MEMORY_TEXT = self:formatMem(Total, true)
	table.sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)
	--self:SetAllPoints(self.Text)
end

function Stat:update(t)

	self.int = self.int - t
	self.int2 = self.int2 - t

	if self.int < 0 then
		self:RefreshMem()
		self.int = 10
	end
	if self.int2 < 0 then
		local fpscolor
		local latencycolor

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
		self.Text:SetText(fpscolor..floor(GetFramerate()).."|r".."fps "..latencycolor..select(3, GetNetStats()).."|r".."ms")
		self.int2 = 1
	end
end

function Stat:onEnter()
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6);
	GameTooltip:ClearLines()
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
	GameTooltip:AddLine(myColorStr..latency)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Total Memory Usage:", Stat:formatMem(Total), 0, 0.6, 1, 1, 1, 1)
	GameTooltip:AddLine(" ")
	for i = 1, #Memory do
		if Memory[i][3] then
			local red = Memory[i][2]/Total*2
			local green = 1 - red
			GameTooltip:AddDoubleLine(Memory[i][1], Stat:formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)
		end
	end
	GameTooltip:Show()
end

function Stat:Enable()
	if not self.index or ( self.index and self.index <= 0) then self:Disable() return end

	self.int = 0
	self.int2 = 0
	self:SetFrameStrata("BACKGROUND")
	self:SetFrameLevel(3)
	self:EnableMouse(true)
	self:SetSize( 1, 15)
	self:ClearAllPoints()
	self:SetPoint("LEFT", LeftInfoPanel, "LEFT", LeftInfoPanel:GetWidth()/infoText.parentCount*( self.index - 1) + infoText.shift, 0)
	self:SetScript("OnUpdate", self.update)
	self:SetScript("OnEnter", self.onEnter)
	self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self:SetScript("OnMouseDown", function () collectgarbage("collect") self:update( 20) end)

	self.Text  = self.Text or self:CreateFontString(nil, "OVERLAY")
	self.Text:SetFont( yo.font, yo.fontsize, "OVERLAY")
	self.Text:ClearAllPoints()
	self.Text:SetPoint("CENTER", self, "CENTER", 0, 0)
	self:SetWidth( self.parent:GetWidth() / self.parentCount)

	self:Show()
end

function Stat:Disable()
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseDown", nil)
	--self.Text:SetText( "")
	self:Hide()
end

infoText.infos.system 		= Stat
infoText.infos.system.name 	= "Система (FPS, Net Lag)"

infoText.texts.system = "System"
--Stat.index = 1
--Stat:Enable()
