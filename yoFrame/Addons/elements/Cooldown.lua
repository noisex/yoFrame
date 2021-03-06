local L, yo, n = unpack( select( 2, ...))

--if true then return end
local tonumber, unpack, pairs, CreateFrame, RGBToHex, UIParent, GetActionCooldown, GetActionCharges, format
	= tonumber, unpack, pairs, CreateFrame, RGBToHex, UIParent, GetActionCooldown, GetActionCharges, format

RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--OmniCC = true --hack to work around detection from other addons for OmniCC
local ICON_SIZE = 32 --the normal size for an icon (don't change this)
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times

local FONT_FACE = yo.Media.fontpx --what font to use
local FONT_SIZE = 22 --the base font size to use at a scale of 1
local MIN_SCALE = 0.2 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = 2 --the minimum duration to show cooldown text for
local EXPIRING_DURATION = 2 --the minimum number of seconds a cooldown must be to use to display in the expiring format

local EXPIRING_FORMAT = RGBToHex(1, 0.3, 0)..'%.1f|r' --format for timers that are soon to expire
local SECONDS_FORMAT = RGBToHex(1, 1, 0)..'%d|r' --format for timers that have seconds remaining
local MINUTES_FORMAT = RGBToHex(1, 1, 1)..'%dm|r' --format for timers that have minutes remaining
local HOURS_FORMAT = RGBToHex(0.4, 1, 1)..'%dh|r' --format for timers that have hours remaining
local DAYS_FORMAT = RGBToHex(0.4, 0.4, 1)..'%dh|r' --format for timers that have days remaining

local floor = math.floor
local min = math.min
local GetTime = GetTime

local Round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

local function getTimeText(s)
	--format text as seconds when below a minute
	if s < MINUTEISH then
		local seconds = s --tonumber(Round(s))
		if seconds > EXPIRING_DURATION then
			return SECONDS_FORMAT, seconds, s - (seconds)-- - 0.51)
		else
			return EXPIRING_FORMAT, s, 0 --0.051
		end
	--format text as minutes when below an hour
	elseif s < HOURISH then
		local minutes = tonumber(Round(s/MINUTE))
		return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	--format text as hours when below a day
	elseif s < DAYISH then
		local hours = tonumber(Round(s/HOUR))
		return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	--format text as days
	else
		local days = tonumber(Round(s/DAY))
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

local function Timer_Stop(self)
	self.enabled = nil
	self:Hide()
end

local function Timer_ForceUpdate(self)
	self.nextUpdate = 0
	self:Show()
end

local function Timer_OnSizeChanged(self, width, height)
	local fontScale = Round(width) / ICON_SIZE
	if fontScale == self.fontScale then
		return
	end

	self.fontScale = fontScale
	if fontScale < MIN_SCALE then
		--print("...")
		self:Hide()
	else
		self.text:SetFont(FONT_FACE, min( 20, fontScale * FONT_SIZE), 'OUTLINE')
		self.text:SetShadowColor(0, 0, 0, 0.5)
		self.text:SetShadowOffset(2, -2)

		if self.enabled then
			Timer_ForceUpdate(self)
		end
	end
end

local function Timer_OnUpdate(self, elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0 then --tonumber(Round(remain)) > 0 then
			if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
				self.text:SetText('')
				self.nextUpdate  = 1
			else
				local formatStr, time, nextUpdate = getTimeText(remain)
				self.text:SetFormattedText(formatStr, time)
				self.nextUpdate = nextUpdate
			end
		else
			Timer_Stop(self)
		end
	end
end

local function Timer_Create(self)

	if ( not pcall(self.GetCenter, self)) then
		print( "|cffff0000PIZDA: |r" , self:GetName(), self)
	end

	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame('Frame', nil, scaler);
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript('OnUpdate', Timer_OnUpdate)

	local text = timer:CreateFontString(nil, 'OVERLAY')

	if self.timerPos then
		text:SetPoint( unpack( self.timerPos))
	else
		text:SetPoint("CENTER", self, "CENTER", 0, 0)
		text:SetJustifyH("CENTER")
		--text:SetJustifyV("CENTER")
	end

	timer.text = text

	Timer_OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', function(self, ...) Timer_OnSizeChanged(timer, ...) end)

	self.timer = timer
	return timer
end

local function Timer_Start(self, start, duration)
	if self.noOCC then return end
	--start timer
	if start > 0 and duration > MIN_DURATION then
		local timer = self.timer or Timer_Create(self)

		--if not timer then return end

		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0
		if timer.fontScale >= MIN_SCALE then timer:Show() end
	--stop timer
	else
		local timer = self.timer
		if timer then
			Timer_Stop(timer)
		end
	end
end

hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, "SetCooldown", Timer_Start)

local active = {}
local hooked = {}

n.cd = {}
n.cd.active = active
n.cd.hooked = hooked

local function cooldown_OnShow(self)
	active[self] = true
	--print(self, self:GetName())
end

local function cooldown_OnHide(self)
	active[self] = nil
end

local function cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges)
	local timer = self.timer
	return not(timer and timer.start == start and timer.duration == duration and timer.charges == charges and timer.maxCharges == maxCharges)
end

local function cooldown_Update(self)
	local button = self:GetParent()
	local action = button.action
	local start, duration, enable = GetActionCooldown(action)
	local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(action)
--print(action)
	if cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges) then
		Timer_Start(self, start, duration)
	end
end

local EventWatcher = CreateFrame("Frame")
EventWatcher:Hide()
EventWatcher:SetScript("OnEvent", function(self, event)
	for cooldown in pairs(active) do
		cooldown_Update(cooldown)
	end
end)
EventWatcher:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", cooldown_OnShow)
		cooldown:HookScript("OnHide", cooldown_OnHide)
		hooked[cooldown] = true
	end
end

if _G["ActionBarButtonEventsFrame"].frames then
	for i, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
		actionButton_Register(frame)
	end
end

--hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", actionButton_Register)
hooksecurefunc( ActionBarButtonEventsFrameMixin, "RegisterFrame", actionButton_Register)
