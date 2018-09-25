local myPlayerRealm = GetRealmName()
local myPlayerName  = UnitName("player")

local function makeConfig()
	MyAddon = {};
	MyAddon.panel = CreateFrame( "Frame", "yo_ConfigPanel", UIParent );
	MyAddon.panel.name = "yoFrame";
--	MyAddon.panel.okay = function (self) ReloadUI(); end;
	InterfaceOptions_AddCategory(MyAddon.panel);
	
----MAIN PANEL-----------------------------------------------------------------------------------------------------------------------------------------
	local GeneralMessageHeader =  MyAddon.panel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
	GeneralMessageHeader:SetPoint("TOPLEFT", 10, -10);
	GeneralMessageHeader:SetText("Учимся лепить конфиг...");
	
	local NeedReboot =  MyAddon.panel:CreateFontString(nil, "ARTWORK","ChatFontNormal");
	NeedReboot:SetPoint("TOPLEFT", 10, -550);
	NeedReboot:SetText("(*) Требуется перезагрузка интрефйса");
	
	--local checkboxes_order = { "silverGoldTimer", "deathTracker", "autoGossip", "progressTooltip", "completionMessage", "hideTalkingHead", "resetPopup" }

	local function CheckBox_OnClick(self)
		local key = self.configKey
		yo["Addons"][key] = self:GetChecked()
		yo_Config = yo
		print( self:GetChecked(), key, yo["Addons"][key])
	end

	idx = 1
	checkboxes = {}
	for i,key in pairs( yo["Addons"]) do
			checkboxes[idx] = CreateFrame("CheckButton", nil, MyAddon.panel, "InterfaceOptionsCheckButtonTemplate")
			checkboxes[idx]:SetScript("OnClick", CheckBox_OnClick)
			checkboxes[idx].configKey = i
			checkboxes[idx]:SetChecked( key)
			checkboxes[idx].Text:SetText( i )
			if idx == 1 then
				checkboxes[idx]:SetPoint("TOPLEFT", MyAddon.panel, "TOPLEFT", 10, -35)
			else
				checkboxes[idx]:SetPoint("TOPLEFT", checkboxes[idx-1], "BOTTOMLEFT", 0, 2)
			end
			idx = idx + 1
		end
	
	local function CharConfigCheckBox_OnClick( self, ...)
		--print( ..., self:GetChecked())
		yo["Addons"].Potatos = self:GetChecked()
	end

	
----CASTBAR PANEL--------------------------------------------------------------------------------------------------------------------------------------
	MyAddon.childpanel = CreateFrame( "Frame", "yo_CastBarPanel", MyAddon.panel);
	MyAddon.childpanel.name = "Castbar";
	MyAddon.childpanel.parent = MyAddon.panel.name;
	InterfaceOptions_AddCategory(MyAddon.childpanel);

	local IntroMessageHeader =  MyAddon.childpanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
	IntroMessageHeader:SetPoint("TOPLEFT", 10, -10);
	IntroMessageHeader:SetText("Еще больше корявого кода ( временно не арбайтн");
	
	local EnabledButton = CreateFrame("CheckButton", "yo_CastBarEnabledIcon", MyAddon.childpanel, "OptionsCheckButtonTemplate");
	EnabledButton:SetPoint("TOPLEFT", 10, -35)
	EnabledButton:SetChecked( yo["CasrBarPlayer"].icon)
	_G["yo_CastBarEnabledIcon".."Text"]:SetText("Включить иконку");
	EnabledButton:SetScript("OnClick", function(self)
		yo["CasrBarPlayer"].icon = self:GetChecked()
	end)
	
	local editbox = CreateFrame("EditBox", nil, MyAddon.childpanel)
	editbox:SetAutoFocus(false)
	editbox:SetMultiLine(false)
	editbox:SetWidth(150)
	editbox:SetHeight(18)
	editbox:SetMaxLetters(255)
	editbox:SetTextInsets(3,0,0,0)
	editbox:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8", 
		tiled = false,
	})
	editbox:SetBackdropColor( 1,0,0,1)
	editbox:SetBackdropBorderColor(1,0,0,1)
	editbox:SetFontObject(GameFontHighlight)
	editbox:SetPoint("TOPLEFT", 100, -100)
	editbox:SetText(1234)
	
	local CastBarIcoSize = CreateFrame("EditBox", "yo_CastBarIconSize", MyAddon.childpanel, "InputBoxTemplate")  --InputBoxTemplate
		CastBarIcoSize:SetPoint("TOPLEFT", 20, -70)
		CastBarIcoSize:SetJustifyH("LEFT")
		CastBarIcoSize:SetFontObject(ChatFontNormal)
		CastBarIcoSize:SetHeight(20)
		CastBarIcoSize:SetMaxLetters(12)
		CastBarIcoSize:SetWidth(60)
		--CastBarIcoSize:SetNumeric(true)
		CastBarIcoSize:SetAutoFocus(false)
		CastBarIcoSize:SetTextInsets(10, 10, 10, 10)
		CastBarIcoSize:SetText( yo["CasrBarPlayer"].iconSize)
		
		CastBarIcoSize:SetScript("OnEnterPressed", function(self) 
			yo["CasrBarPlayer"].iconSize = CastBarIcoSize:GetText()
			print( CastBarIcoSize:GetText(), yo["CasrBarPlayer"].iconSize)
			self:ClearFocus() 
			end)
		
	local CastBarIcoSizeText =  CastBarIcoSize:CreateFontString(nil, "ARTWORK", "GameFontNormal");
		CastBarIcoSizeText:SetPoint("LEFT", CastBarIcoSize, "RIGHT", 10, 0);
		CastBarIcoSizeText:SetText("Размер иконки");
		
end

	-- When the player clicks okay, run this function.
	--self.okay = function (self) print("MyAddOnSettings: Okay clicked") end

	-- When the player clicks cancel, run this function.
	--self.cancel = function (self) print("MyAddOnSettings: Cancel clicked.") end
	--panel.default is the function that will happen when you click default.

	--["iconSie"] 	= 40,
	--["iconX"]		= 0,
	--["iconY"]		= 37,

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	makeConfig()
end)
