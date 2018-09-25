local menuFrame = CreateFrame("Frame", "ExampleMenuFrame", UIParent, "UIDropDownMenuTemplate")
local eText  = LeftInfoPanel:CreateFontString(nil, "OVERLAY")

local function TMenu( self)
	local name = {}
	local menu = {
		{ text = "Комплекты", isTitle = true},
	}
	
	for i = 1, C_EquipmentSet.GetNumEquipmentSets() do	
		name[i], icon, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo( i)

		if name then
			menu[i+1] = { icon = icon, text = name[i], checked = isEquipped, func = function() C_EquipmentSet.UseEquipmentSet( name[i]); end }
		end
	end
	--menuFrame:SetPoint("BOTTOM", self, "TOP")
	--EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
	EasyMenu(menu, menuFrame, self, 0 , 0, "MENU");
end

local function TSet( self, btn) 
	local total = C_EquipmentSet.GetNumEquipmentSets()
	local wear = self.id + btn

	if wear > total then wear = 1 
	elseif wear < 1 then wear = total end

	C_EquipmentSet.UseEquipmentSet( C_EquipmentSet.GetEquipmentSetInfo( wear))
end

local function OnEvent(self, event, ...)
	if not yo.Addons.InfoPanels then
		self:UnregisterAllEvents()
		self:SetScript("OnUpdate", nil)
		LeftInfoPanel.equipText = nil
		return
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
		self.wear = true
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")


		eText:SetFont( font, fontsize, "OVERLAY")
		eText:SetHeight(LeftInfoPanel:GetHeight())
		eText:SetPoint("LEFT", LeftInfoPanel, "RIGHT", -120, 0)
		LeftInfoPanel.equipText = eText
		
	elseif event == "EQUIPMENT_SWAP_FINISHED" then
		wear, set = ...
		self.wear = wear
	end		

	if self.wear == true then
		--print( C_EquipmentSet.GetNumEquipmentSets())
		for i = 1, C_EquipmentSet.GetNumEquipmentSets() do
			name, _, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo( i)
			if name and isEquipped then
				self.id = i
				eText:SetText("Equip: "..myColorStr..utf8sub( name, 12, false))
				break
			else
				eText:SetText("Equip: "..myColorStr.." no Set")
			end
		end
	end
	self:SetAllPoints(eText)
end

local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	Stat:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	Stat:RegisterEvent("WEAR_EQUIPMENT_SET")
	Stat:RegisterEvent("EQUIPMENT_SWAP_FINISHED")
	Stat:EnableMouse(true)
	Stat:SetScript("OnMouseWheel", function(self, btn) TSet( self, btn) end)
	Stat:SetScript("OnMouseDown",  function(self, btn) TMenu( self, btn) end)
	Stat:SetScript("OnEvent", OnEvent)