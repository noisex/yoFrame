
local function OnUpdate(f, elapsed)
	f.elapsed = (f.elapsed or 0) + elapsed
	if f.elapsed >= 0.1 then
		local stime = GetTime()
		local timeLeft = f.expirationTime - stime
		if f.reverse then timeLeft = abs((f.expirationTime - stime) - f.duration) end
		
		if not f.last or f.last < stime - 0.7  then
			f.last = stime    
			f.ch = not f.ch
		end
		
		-----------------------------------------------------------UnitIsUnit( unit, "target")
		if f.svistelka then
			if f.ch and timeLeft < 6 then
				f.outerGlow:Hide()
				f.icon:SetVertexColor( 1,1,1,1)
			elseif not f.ch and timeLeft < 6 then
				f.outerGlow:Show()
				f.icon:SetVertexColor( 1,0,0,1)
			elseif timeLeft > 6 then
				f.outerGlow:Hide()
				f.icon:SetVertexColor( 1,1,1,1)		
			end
		end
				
		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			f.tTimer:SetText(text)
			if timeLeft < 1 then
				f.tTimer:SetTextColor(1, 0.5, 0.5)
			else
				f.tTimer:SetTextColor(.7, .7, .7)
			end
		else
			f:SetScript("OnUpdate", nil)
			f.tTimer:Hide()
		end
		f.elapsed = 0
	end
end
		
local function AuraUpdate( f, lastID, filter)
	local unit = f.unit
	if not UnitExists( unit) then return end

	local count = f.count
	local isboss = f:GetParent().isboss
	local svistelka 
	--print( "AURA: ", GetTime(), unit, filter, f)
	
	if isboss and (string.find( filter, "PLAYER") ~= nil) then
		svistelka = true
	else
		svistelka = false
	end
	
	for i = 1, count +5 do   --v in ipairs( f) do
		if lastID >= ( count * 2) -1 then return end
		local name, icon, stack, _, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, _, _, _, _, nameplateShowAll = UnitAura( unit, i, filter)
		--if isBossDebuff then print ( "|cffff0000 isBossDebuff:|r " .. name .. " ( " .. spellId .. ")" ) end
		
		--if name and ( unit == "player" or unit == "target" or ( unit == "focus" and nameplateShowAll) or ( isboss and filter == "HELPFUL") or ( svistelka and nameplateShowPersonal and duration >= 10)) then
		if name and ( unit == "player" or unit == "target" or ( unit == "focus" and nameplateShowAll) or ( isboss and filter == "HELPFUL") or ( svistelka and DebuffWhiteList[name])) then
			f[lastID].icon:SetTexture( icon)
			f[lastID].filter = filter
			f[lastID].id = i
			f[lastID].icon:Show()
			f[lastID].svistelka = svistelka
			f[lastID].duration = duration
			--f[lastID].cd:SetCooldown( expirationTime - duration, duration)
			
			if stack and stack > 1 then
				f[lastID].tStack:SetText( stack)
			else 
				f[lastID].tStack:SetText( "")
			end
			
			if(unit == "target") then	
				if ( unitCaster == "player" or unitCaster == "vehicle") then
					f[lastID].icon:SetDesaturated(false)                 
				else --if( not UnitPlayerControlled(unit)) then
					f[lastID].icon:SetDesaturated(true)  
				end
			elseif( unit == "player") then	
				_G["DebuffButton" .. lastID .. "Border"]:SetTexture( nil)
				_G["DebuffButton" .. lastID .. "Border"]:Hide( )
			end
						
			if duration and (duration > 0) then
				f[lastID].expirationTime = expirationTime
				--f[lastID].nextUpdate = 0								----------------------???????????????
				f[lastID]:SetScript("OnUpdate", OnUpdate)
				f[lastID].tTimer:Show()
			else
				f[lastID]:SetScript("OnUpdate", nil)
				f[lastID].tTimer:Hide()
			end

			f[lastID]:Show()
			lastID = lastID + 1		
			f.lastID = lastID
		else
			f[lastID]:Hide()
			f[lastID].icon:SetVertexColor( 1,1,1,1)
		end
	end
end

function AuraPrepare(f, event)
	if f.unit == "player" then
		for i = 1, 2 do
			local bfname = f.bfname[i]
			local bflast = f.bflast[i]
			
			for idx = bflast, 30 do
				bf =  bfname .. idx 		
				if not _G[bf] then 
					break
				end
				if not _G[bf].shadow then
					f.bflast[i] = idx
					CreateStyle( _G[bf], 4)
					_G[bf.."Icon"]:SetTexCoord(0.07, 0.93, 0.07, 0.93)
					_G[bf.."Count"]:SetFont( fontpx, 16, "OUTLINE")
					_G[bf.."Count"]:ClearAllPoints()
					_G[bf.."Count"]:SetPoint( "CENTER", _G[bf], "TOPRIGHT", 0, 0)
					_G[bf.."Duration"]:ClearAllPoints()
					_G[bf.."Duration"]:SetPoint( "CENTER", _G[bf], "BOTTOM", 5, 0)
					_G[bf.."Duration"]:SetFont( fontpx, 12, "OUTLINE")
				end
			end
		end
	end

	if UnitExists( f.unit) then
		f.lastID = 1
		for i, filter in ipairs( f.filter) do
			if f.lastID == 1 then
				lastID = f.lastID
			else
				lastID = f.lastID + 1
			end
			AuraUpdate( f, lastID, filter)
		end
	
		for i = f.lastID, ( f.count * 2) do
			f[i]:Hide()
		end
	end
end

local function BuffOnEnter( f) 
	GameTooltip:SetOwner( f, "ANCHOR_BOTTOMRIGHT", 8, -16)
	GameTooltip:SetUnitAura( f:GetParent().unit, f.id, f.filter)
end

function CreateBuff( uf, name, iSize, count, from, to, shiftx, shifty, direct, plusx)
	local f = uf[name]
	if not f then
		f = CreateFrame("Frame", nil, uf)
		f:SetSize(2, 2)
		local unit = uf.unit
		f.unit = unit
		
		uf[name] = f
		uf[name].lastID = 1
		uf[name].count = count

		for j = 1, 2 do
			for i = 1, count do
				local idx = i + count * (j - 1)
				local icon = f[idx]
				if not icon then
					icon = CreateFrame("Button",  nil, f)
					icon:SetPoint( from, uf, to, direct * ( iSize*(i-1) + ( shiftx *( i-1) + plusx)),                          -iSize *( j-1) - ( shifty * j))
				
					icon.icon = icon:CreateTexture(nil, "BORDER")
					icon.icon:SetAllPoints()
					icon.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
					icon.icon:SetVertexColor( 1,1,1,1)
				
					icon.overlay = CreateFrame("Frame", nil, icon)
					icon.overlay:SetFrameLevel(4)
				
					icon.tStack = icon.overlay:CreateFontString(nil, "OVERLAY")
					icon.tStack:SetFont( fontpx, iSize / 1.7, "OUTLINE")
					icon.tStack:SetPoint("CENTER", icon, "TOPRIGHT", 0, 0)
					icon.tStack:SetTextColor( 1, 1, 0)
				
					icon.tTimer = icon.overlay:CreateFontString(nil, "OVERLAY")
					icon.tTimer:SetFont( fontpx, iSize / 1.9, "OUTLINE")
					icon.tTimer:SetPoint("CENTER", icon, "BOTTOM", 0, 0)
				
--[[				icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
					icon.cd.noCooldownCount = true
					icon.cd:SetDrawEdge( false)
					icon.cd:SetDrawSwipe( false)
					icon.cd:SetReverse(true)
					icon.cd.noOCC = true
]]--				
					icon.id = idx
					icon:SetScript("OnEnter", BuffOnEnter)
					icon:SetScript("OnLeave", GameTooltipOnLeave)
								
					icon:SetSize( iSize, iSize)
				
					icon:RegisterForClicks("AnyUp")
					icon:SetScript('OnMouseUp', function(icon, mouseButton)
					if mouseButton == 'RightButton' then				
						CancelUnitBuff('player', idx)
					end end)
					
					if uf.isboss then
						icon.outerGlow = icon:CreateTexture( "OuterGlow", "ARTWORK")
						icon.outerGlow:SetPoint("CENTER", icon)
						icon.outerGlow:SetAlpha(1)
						icon.outerGlow:SetWidth( icon:GetWidth() * 2)
						icon.outerGlow:SetHeight( icon:GetHeight() * 2)
						icon.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
						icon.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)
						icon.outerGlow:Hide()
					end
					
					f[idx] = icon
					CreateStyle( f[idx], 4)
					f[idx]:Hide()
				end	
			end
		end
		
		if unit == "player" then
			f.filter = {"HARMFUL"}
			f:RegisterEvent("PLAYER_ENTERING_WORLD") 
			f:RegisterUnitEvent("UNIT_AURA", unit)
			f.bfname = { "BuffButton", "DebuffButton"}
			f.bflast = { 1, 1}
		elseif uf.isboss then 				
			if name == "aurabar" then
				f.filter = {"HELPFUL"}			
			else
				f.filter = {"HARMFUL PLAYER", "HELPFUL PLAYER"} 
			end
			f:RegisterUnitEvent("UNIT_AURA", unit)
			--f:RegisterUnitEvent( "INSTANCE_ENCOUNTER_ENGAGE_UNIT", unit)
		elseif unit == "target" or unit == "focus" then
			f.filter = {"HELPFUL" , "HARMFUL"}
			f:RegisterUnitEvent("UNIT_AURA", unit)
			f:RegisterEvent("PLAYER_FOCUS_CHANGED")
		end
			
		f:RegisterEvent("PLAYER_TARGET_CHANGED")  ------------------------------?????????????????????
		f:SetScript("OnEvent", AuraPrepare)
	end
end


local logan = CreateFrame("Frame")
logan:RegisterEvent("PLAYER_ENTERING_WORLD")

logan:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if not yo.Addons.unitFrames then return end

	CreateBuff( plFrame,  "aurabar", 27, 7, "TOPLEFT", "BOTTOMLEFT", 5, 6, 1, 0) 
	CreateBuff( tarFrame, "aurabar", 21, 8, "TOPLEFT", "BOTTOMLEFT", 5, 6, 1, 0)
	CreateBuff( fcFrame, "aurabar", 20, 5, "TOPLEFT", "BOTTOMLEFT", 5, 6, 1, 0)
	
	for i = 1, MAX_BOSS_FRAMES do
		local bFrame = _G["yo_Boss"..i]
		CreateBuff(    bFrame, "aurabar",  bFrame:GetHeight(), 10, "LEFT", "RIGHT", 6, 0, 1, 7)
		CreateBuff(    bFrame, "aurabuff", bFrame:GetHeight(), 10, "RIGHT", "LEFT", 7, 0, -1, 8)
	end
--	if unit ~= "targettarget" then
--		f:RegisterUnitEvent("UNIT_AURA", unit)
--	end
end)

--
--	local stealable = button:CreateTexture(nil, 'OVERLAY')
--	stealable:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Stealable]]
--	stealable:SetPoint('TOPLEFT', -3, 3)
--	stealable:SetPoint('BOTTOMRIGHT', 3, -3)
--	stealable:SetBlendMode'ADD'
--	button.stealable = stealable 
	