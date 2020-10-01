local L, yo = unpack( select( 2, ...))

local lib = LibStub("LibCooldown")
if not lib then error("CooldownFlash requires LibCooldown") return end

-- local CT = LibStub("LibCooldownTracker-1.0")

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
	},
}

local flash = CreateFrame("Frame", "yo_FlashIcon", UIParent)
flash:SetPoint("CENTER", yo_MoveFlashIcon)
flash:SetSize( yo_MoveFlashIcon:GetSize()) 
 
-- function flash:OnEnable( self)
	-- print( flash, self)
   -- CT.RegisterCallback(flash, "LCT_CooldownUsed")
   -- CT.RegisterCallback(flash, "LCT_CooldownsReset")
   -- CT:RegisterUnit("player")
-- end

-- function flash:OnDisable()
   -- CT:UnregisterUnit("player")
   -- CT.UnregisterAllCallbacks(self)
-- end

-- function flash:LCT_CooldownsReset(event, unit)
   -- print("Cooldowns reset for unit " .. unit)
-- end

-- function flash:LCT_CooldownUsed(event, unitid, spellid)
   -- print( GetTime(), unitid .. " used " .. GetSpellInfo(spellid))
   -- local tracked = CT:GetUnitCooldownInfo(unitid, spellid)
   -- if tracked then
      -- print( GetTime(), "cooldown starts:", tracked.cooldown_start) -- times are based on GetTime()
      -- print("cooldown ends:", tracked.cooldown_end)
      -- print("effect starts:", tracked.used_start)
      -- print("effect ends:", tracked.used_end)
      -- print(tracked.detected) -- use this to check if the unit has used this spell before (useful for detecting talents)
   -- end   
-- end

flash:RegisterEvent("PLAYER_ENTERING_WORLD")

flash:SetScript("OnEvent", function( self)
	if not yo["Addons"].FlashIconCooldown then flash:SetScript("OnEvent", nil) return end
	
	--print("EVENT ", self)
	--flash.OnEnable( self)
	
	flash.icon = flash:CreateTexture(nil, "OVERLAY")
	flash.icon:SetPoint("CENTER", flash)
	flash.icon:SetSize( yo_MoveFlashIcon:GetSize())
	flash.icon:SetTexCoord(.08, .92, .08, .92)	
	flash:Hide()
	
	flash:SetScript("OnUpdate", function(self, e)
		if not yo["Addons"].FlashIconCooldown then flash:SetScript("OnEvent", nil) return end
		flash.e = flash.e + e
		if flash.e > .75 then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
	
	CreateStyle(flash, 5)
	flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
	flash:SetScript("OnEvent", nil)
	
end)


lib:RegisterCallback("stop", function(id, class)
	if not yo.Addons.FlashIconCooldown then return end
	if filter[class]=="all" or filter[class][id] then return end
	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end)



