local L, yo, n = unpack( select( 2, ...))

if not yo.Addons.FlashIconCooldown then return end

local GetItemIcon, GetSpellInfo, select = GetItemIcon, GetSpellInfo, select

local lib = n.LIBS.LibCooldown

if not lib then error("CooldownFlash requires LibCooldown") return end

--print(n.LIBS.LibCooldown)

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
		--[12345] = true, -- ban this spell
	},
}

n.moveCreateAnchor("yoMoveFlashIcon", 	"Move flash icon", 70, 70, 0, 200)

local flash = CreateFrame("Frame", "yo_FlashIcon", UIParent)
flash:SetPoint("CENTER", yoMoveFlashIcon)
flash:SetSize( yoMoveFlashIcon:GetSize())
flash.e = 0

flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash.icon:SetPoint("CENTER", flash)
flash.icon:SetSize( yoMoveFlashIcon:GetSize())
flash.icon:SetTexCoord(.08, .92, .08, .92)
flash:Hide()

CreateStyle(flash, 5)

flash:SetScript("OnUpdate", function(self, e)
	flash.e = flash.e + e
	if flash.e > .75 then
		flash:Hide()
	elseif flash.e < .25 then
		flash:SetAlpha(flash.e*4)
	elseif flash.e > .5 then
		flash:SetAlpha(1-(flash.e%.5)*4)
	end
end)

lib:RegisterCallback("start", function(id, class)
	--print("start: ", id, class, n.interuptSpells[id])
	if n.interuptSpells[id] then yo.General.spellDelay = true end
	--print("started", yo.General.spellDelay)
end)

lib:RegisterCallback("stop", function(id, class)
	--print( "stop: ", id, class)
	if n.interuptSpells[id] then yo.General.spellDelay = false end
	--print("stoped", n.interuptSpells[id], yo.General.spellDelay)

	if filter[class]=="all" or filter[class][id] then return end
	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end)