local addon, ns = ...

local L, yo, n = unpack( ns)
local oUF = ns.oUF

if not yo.NamePlates.enable then return end

-----------------------------------------------------------------------------------------------
--	CASTBAR
-----------------------------------------------------------------------------------------------
local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch, tinsert
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch, tinsert

local _G = _G
local np = n.namePlates

local CreateStyle, UIParent, UnitExists, GetColors, CreateFrame, UnitClass, UnitReaction, UnitIsPlayer, utf8sub, GetTime, UnitChannelInfo, print, UnitCastingInfo, GetCVar, UnitSpellHaste, UnitControllingVehicle
	= CreateStyle, UIParent, UnitExists, GetColors, CreateFrame, UnitClass, UnitReaction, UnitIsPlayer, utf8sub, GetTime, UnitChannelInfo, print, UnitCastingInfo, GetCVar, UnitSpellHaste, UnitControllingVehicle

local UnitInRaid, UnitIsUnit, UnitName
	= UnitInRaid, UnitIsUnit, UnitName

function updateCastColor(f, unit)
	f.spellDelay = yo.General.spellDelay

	if f.notInterruptible then
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 0.8, 0.15, 0.25, 1)
		end
		f:SetStatusBarColor( 0.8, 0.15, 0.25, 1)
		f.spark:SetVertexColor( 0.8, 0.15, 0.25, 1)
	else
		if f.ibg then
			f.ibg.shadow:SetBackdropBorderColor( 0, 0, 0, 1)
		end
		if f.spellDelay then
			f:SetStatusBarColor( 0, 1, 1, 1)
			f.spark:SetVertexColor( 0, 1, 1, 1)
		else
			f:SetStatusBarColor( 0.5, 1, 0, 1)
			f.spark:SetVertexColor( 0.5, 1, 0, 1)
		end
	end
end

function updateCastBar(self, unit)

	if GetTime() - self.tick < 0.1 then return end
	self.tick = GetTime()

	--print(GetTime(), yo.General.spellDelay, self.spellDelay)

	if self.spellDelay ~= yo.General.spellDelay then self:updateCastColor( self)	end

	self.time:SetFormattedText("%.1f / %.2f", self.duration, self.max)
end

function startCastBar( f, unit)
	if f.texture then
		f.ibg:Show( )
	else
		f.ibg:Hide()
	end

	local text = ""
	if yo.NamePlates.showCastName then
		if yo.NamePlates.showCastTarget then
			if UnitExists( unit .. "target") then
				if yo.NamePlates.anonceCast and not UnitInRaid("player") then
					if UnitIsUnit("player", unit .. "target")
						--and ( myRole == "HEALER" or myRole == "DAMAGER" )
						then
							print( yo.myColorStr .. f.name .. " on me!")
					end
				end
				local uname = UnitName( unit .. "target")
				if uname then
					local cname = "|r|c" .. RAID_CLASS_COLORS[ select( 2, UnitClass( unit .. "target"))].colorStr
					text = " / " .. cname .. uname
				end
			end
		end
	end

	f.text:SetText( f.name  .. text)

	if yo.NamePlates.badCasts and n.badMobsCasts[f.spellID] then
		f.spark:Show()
		np.glowTargetStart( f.ibg, {0.95, 0.95, 0.32, 1}, 8, 0.5, 5, 2, 2, 2, false, 1, 11 )
	else
		f.spark:Hide()
		np.glowBadStop( f.ibg, 1)
	end

	f.tick = GetTime()
	f:updateCastColor( f, unit)
end

n.createCastBarNP = function( f)
	f.Castbar = CreateFrame("StatusBar", nil, f)
	f.Castbar:SetPoint("TOP", f, "BOTTOM", 0, -2)
	f.Castbar:SetSize( yo.NamePlates.width, 5)
	f.Castbar:SetStatusBarTexture( yo.texture)
	f.Castbar:SetStatusBarColor(1, 0.8, 0)
	tinsert( n.statusBars, f.Castbar)
	f.Castbar:SetFrameLevel( 12)

	f.Castbar.bg = f.Castbar:CreateTexture(nil, "BACKGROUND")
	f.Castbar.bg:SetAllPoints( f.Castbar)
	f.Castbar.bg:SetVertexColor( 0.3, 0.3, 0.3, 0.9)
	f.Castbar.bg:SetTexture( yo.texture)

	f.Castbar.time = f.Castbar:CreateFontString(nil, "ARTWORK")
	f.Castbar.time:SetPoint("RIGHT", f.Castbar, "RIGHT", -5, 0)
	f.Castbar.time:SetFont( yo.font, yo.fontsize - 1, "THINOUTLINE")
	f.Castbar.time:SetShadowOffset(1, -1)
	f.Castbar.time:SetTextColor(1, 1, 1)
	tinsert( n.strings, f.Castbar.time)

	f.Castbar.text = f.Castbar:CreateFontString(nil, "OVERLAY")
	f.Castbar.text:SetPoint("TOP", f.Castbar, "BOTTOM", 0, -1)
	f.Castbar.text:SetFont( yo.font, yo.fontsize, "THINOUTLINE")
	f.Castbar.text:SetTextColor(1, 1, 1)
	f.Castbar.text:SetJustifyH("CENTER")
	tinsert( n.strings, f.Castbar.text)

	f.Castbar.ibg = CreateFrame("Frame", nil, f.Castbar)
   	f.Castbar.ibg:SetPoint("BOTTOM", f.Health,"CENTER", 0, 0);
   	f.Castbar.ibg:SetSize( yo.NamePlates.iconCastSize, yo.NamePlates.iconCastSize)
	f.Castbar.ibg:SetFrameLevel( 10)
	CreateStyle( f.Castbar.ibg, 1, 6)

	f.Castbar.Icon = f.Castbar.ibg:CreateTexture(nil, "BORDER")
	f.Castbar.Icon:SetAllPoints( f.Castbar.ibg)
	f.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	f.Castbar.spark = f.Castbar:CreateTexture(nil, "OVERLAY")
	f.Castbar.spark:SetTexture([[Interface\Addons\yoFrame\Media\CastSparker.tga]])
	f.Castbar.spark:SetPoint("BOTTOM", f.Castbar:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, -19)
	f.Castbar.spark:SetHeight( 56)
	f.Castbar.spark:SetWidth(45)
	f.Castbar.spark:Hide()

	f.Castbar.updateCastColor	= updateCastColor
	f.Castbar.updateCastBar 	= updateCastBar
	f.Castbar.startCastBar		= startCastBar

	f.Castbar.PostCastStart 	= f.Castbar.startCastBar
	f.Castbar.PostCastUpdate	= f.Castbar.updateCastBar --PostCastUpdate
	--f.Castbar.Flash = f.Castbar:CreateTexture(nil, "OVERLAY")
	--f.Castbar.Flash:SetAllPoints()
	--f.Castbar.Flash:SetTexture("")
	--f.Castbar.Flash:SetBlendMode("ADD")
	CreateStyle( f.Castbar, 3)
end

-- oUF CastBar at 369
	--if(self.PostCastUpdate) then
	--	return self:PostCastUpdate(unit)
	--end