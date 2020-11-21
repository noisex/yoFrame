local addon, ns = ...
local L, yo, N = unpack( ns)

local tonumber, floor, ceil, abs, mod, modf, format, len, sub = tonumber, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub
local texture, texglow = yo.texture, yo.texglow

local GetCurrentRegion, time, GetQuestResetTime, LASTONLINE_YEARS, LASTONLINE_MONTHS, LASTONLINE_DAYS, LASTONLINE_HOURS, LASTONLINE_MINUTES, INT_SPELL_DURATION_SEC, LESS_THAN_ONE_MINUTE, date
	= GetCurrentRegion, time, GetQuestResetTime, LASTONLINE_YEARS, LASTONLINE_MONTHS, LASTONLINE_DAYS, LASTONLINE_HOURS, LASTONLINE_MINUTES, INT_SPELL_DURATION_SEC, LESS_THAN_ONE_MINUTE, date

function timeLastWeeklyReset()
	local resetDays = { 2, 4, 3, 4, 4}
	local region = GetCurrentRegion()

	local weekDayReset = resetDays[region]
	local nextResetTime = time() + GetQuestResetTime()
	local nextResetTimeWeekDay = tonumber( date("%w", nextResetTime))

	local timeNextWeeklyReset = nextResetTime + mod( 7 + weekDayReset - nextResetTimeWeekDay, 7) * 86400
	local timeLastWeeklyReset = timeNextWeeklyReset - 7 * 86400
	return timeLastWeeklyReset, timeNextWeeklyReset
end

function formatTime( s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5))	--, s  %day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5))	--, s  %hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5))	--, s  %minute
	elseif s >= minute / 12 then
		return floor(s + 0.5) --, (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s) --, (s * 100 - floor(s * 100))/100
end

function formatTimeSec( s, noSec)
	local day, hour, minute = 86400, 3600, 60
	local sec = noSec and "" or "s"
	if s == -1 then
		return LESS_THAN_ONE_MINUTE, s
	elseif s >= day then
		return format("%dd", floor(s/day + 0.5)), s  %day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s  %hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s  %minute
	--elseif s >= minute / 12 then
	--	return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%d%s", s, sec), (s * 100 - floor(s * 100))/100
end

function SecondsToClocks(seconds, noSec, noMin)
  local seconds = tonumber(seconds)

  if seconds <= 0 then   --return "00:00:00";
    return " ";
  else
  	local mins 	= noMin and 0 or floor(mod(seconds,3600)/60)
  	local secs 	= noSec and 0 or floor(mod(seconds,60))

	mins 	= mins  == 0 and "" or ( format( "%dм", mins) .. " ")
	secs 	= secs  == 0 and "" or ( format( "%dс", secs))

    return "/" ..mins..secs
  end
end

function SecondsToClock(seconds, noSec, noMin)
  local seconds = tonumber(seconds)

  if seconds <= 0 then   --return "00:00:00";
    return LESS_THAN_ONE_MINUTE;
  else
  	local years	= floor(seconds/31556926)
  	local month	= floor(mod(seconds, 31556926)/ 2592000)
  	local days 	= floor(mod(seconds, 2592000)/ 86400)
  	local hours	= floor(mod(seconds, 86400)/3600)
  	local mins 	= noMin and 0 or floor(mod(seconds,3600)/60)
  	local secs 	= noSec and 0 or floor(mod(seconds,60))

  	years 	= years == 0 and "" or ( format( LASTONLINE_YEARS, years) .. " ")
  	month 	= month == 0 and "" or ( format( LASTONLINE_MONTHS, month) .. " ")
    days 	= days  == 0 and "" or ( format( LASTONLINE_DAYS, days) .. " ")
    hours 	= hours == 0 and "" or ( format( LASTONLINE_HOURS, hours) .. " ")
	mins 	= mins  == 0 and "" or ( format( LASTONLINE_MINUTES, mins) .. " ")
	secs 	= secs  == 0 and "" or ( format( INT_SPELL_DURATION_SEC, secs))

    return years..month..days..hours..mins..secs
  end
end

function timeFormat(seconds)
	local hours = floor(seconds / 3600)
	local minutes = floor((seconds / 60) - (hours * 60))
	seconds = seconds - hours * 3600 - minutes * 60

	if hours == 0 then
		return format("%d:%.2d", minutes, seconds)
	else
		return format("%d:%.2d:%.2d", hours, minutes, seconds)
	end
end

function timeFormatMS(timeAmount)
	local seconds = floor(timeAmount / 1000)
	local ms = timeAmount - seconds * 1000
	local hours = floor(seconds / 3600)
	local minutes = floor((seconds / 60) - (hours * 60))
	seconds = seconds - hours * 3600 - minutes * 60

	if hours == 0 then
		return format("%d:%.2d.%.3d", minutes, seconds, ms)
	else
		return format("%d:%.2d:%.2d.%.3d", hours, minutes, seconds, ms)
	end
end
