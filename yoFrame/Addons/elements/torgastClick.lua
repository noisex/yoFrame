local _, ns 	= ...
local L, yo, n 	= unpack( ns)

local _G = _G

local pairs, GetItemInfo, GetItemIcon, GetItemCount, GameTooltip, unpack, CreateFrame, GetItemCooldown, wipe, ObjectiveTracker_Update
	= pairs, GetItemInfo, GetItemIcon, GetItemCount, GameTooltip, unpack, CreateFrame, GetItemCooldown, wipe, ObjectiveTracker_Update

local tc = CreateFrame("Frame", nil, UIParent)
n.Addons.torgastClicks = tc

local size = 40
local maw = n.Addons.maw

tc.usedIcons = {}
tc.poolIcons = {}
tc.cellsData = {
	--["ravenous"] 	= { id = 181468}, -- 170540},
	--["plundered"] 	= { id = 172041}, -- 168207},
	--["essence"]		= { id = 142117}, --176331},
	--["smoke"]		= { id = 184652}, --176408},
	--["siphoned"]	= { id = 159}, 	--176409},

	["ravenous"] 	= { id = 170540},
	["plundered"] 	= { id = 168207},
	["essence"]		= { id = 176331},
	["smoke"]		= { id = 176408},
	["siphoned"]	= { id = 176409},
	["frenzy"]		= { id = 176443},
	["cells150"]	= { id = 184662},
}

local CELLS = 170540

local function OnEnter( self)
	GameTooltip:SetOwner( self, "ANCHOR_TOPLEFT", 15, 5)
	GameTooltip:SetHyperlink( "item:" .. self.id)
	GameTooltip:Show()
end

local function OnLeave( self) GameTooltip:Hide() end

function tc:createPoolIcons(self, ...)

	for name, item in pairs( tc.cellsData) do
		local button = CreateFrame("Button", nil, tc, "SecureActionButtonTemplate")
		button:SetSize( size, size)

		button.icon = button:CreateTexture(nil, "OVERLAY")
		button.icon:SetAllPoints(button)
		button.icon:SetTexCoord( unpack( n.tCoord))
		button.icon:SetTexture( tc.cellsData[name].icon)

		button.count = button:CreateFontString(nil, "OVERLAY")
		button.count:SetFont( n.fontpx, n.fontsize + 7, "OUTLINE")
		button.count:SetTextColor(1, 1, 0, 1)
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -1)
		button.count:SetText( tc.cellsData[name].count)

		button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
		button.cd:SetAllPoints()
		button.cd:SetDrawEdge( false)
		button.cd:SetDrawSwipe( true)
		button.cd:SetReverse(true)

		button:EnableMouse( true)
		button:SetScript("OnEnter", OnEnter)
		button:SetScript("OnLeave", OnLeave)

		button.id = tc.cellsData[name].id

		--button:SetAttribute("unit", "target")
		button:SetAttribute("item", tc.cellsData[name].name)
		button:SetAttribute("type", "item")

		n.CreateBorder( button, size / 3)
		n.SetBorderColor( button, 0.9, 0.5, 0.019, 0.9)
    	--CreateStyle(button, 3)

    	tc.poolIcons[name] = button
	end
end

function tc:cellsDataCreate()
	for name, item in pairs( tc.cellsData) do
		tc.cellsData[name].name  	= GetItemInfo( item.id)
    	tc.cellsData[name].icon 	= GetItemIcon( item.id)
    	tc.cellsData[name].count  	= GetItemCount(item.id) or 0
	end

	tc:createPoolIcons()
end

function tc:cleanIcons()
	if tc.usedIcons then
		for name, button in pairs( tc.usedIcons) do
			button:Hide()
		end
		wipe( tc.usedIcons)
	end

	tc:Hide()
end

function tc:updateIcons()
	local index = 0
	wipe( tc.usedIcons) --= {}  ---wipe need

	for _, button in pairs( tc.poolIcons) do button:Hide() end

	for name, item in pairs( tc.cellsData) do
		local count = tc.cellsData[name].count
		if count >= 1 then
			index = index + 1

			local button = tc.poolIcons[name]
			button:ClearAllPoints()

			if index == 1 then  button:SetPoint("LEFT", tc, "LEFT", 0, 0)
			else 				button:SetPoint("LEFT", tc.usedIcons[index-1], "RIGHT", 10, 0)
			end

			button.count:SetText( tc.cellsData[name].count)

			button:Show()
			tc.usedIcons[index] = button
		end
	end
end

function tc:cellsCDUpdate()
	--dprint("UPDATE CD")
	if not tc.usedIcons then return end

	for name, button in pairs( tc.usedIcons) do
		local startTime, duration, enable = GetItemCooldown( button.id)
		if enable == 1 and duration > 0 then
			button.cd:SetCooldown( startTime, duration)
		end
	end
end

function tc:cellsDataUpdate()
	--print("BAG_UPDATE")
	for name, item in pairs( tc.cellsData) do
    	tc.cellsData[name].count  	= GetItemCount(item.id) or 0
	end

	n.namePlates.CELLS = GetItemCount( CELLS)
	tc:updateIcons()
end

local function outTorghast()

	for i = 4, 6 do
		local module = _G.ObjectiveTrackerFrame.MODULES[i]
		local collapsed = module.collapsed
		if collapsed then
			module:SetCollapsed( false)
			ObjectiveTracker_Update(0, nil, module);
		end
	end
	--print("outTorghast")
	tc:UnregisterEvent("BAG_UPDATE")
	tc:UnregisterEvent("BAG_UPDATE_COOLDOWN")
	tc:cleanIcons()
	tc.inTorghast = false
end

local function inTorghast()

	for i = 4, 6 do
		local module = _G.ObjectiveTrackerFrame.MODULES[i]
		local collapsed = module.collapsed
		if not collapsed then
			module:SetCollapsed( true)
			ObjectiveTracker_Update(0, nil, module);
		end
	end

	--dprint("inTorghast", _G.ScenarioBlocksFrame.MawBuffsBlock:IsVisible())

	if maw.isInMaw() then
		outTorghast()
		return
	end

	--dprint("inMAWTorghast", _G.ScenarioBlocksFrame.MawBuffsBlock:IsVisible())

	tc:Show()
	tc:RegisterEvent("BAG_UPDATE")
	tc:RegisterEvent("BAG_UPDATE_COOLDOWN")
	tc.inTorghast = true
end

local function onEvent(self, event, ...)
	--print( event, ...)

	if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then

		--tc:UnregisterEvent("PLAYER_ENTERING_WORLD")
		tc.inTorghast = _G.ScenarioBlocksFrame.MawBuffsBlock.Container:IsVisible()

		if tc.inTorghast then
			inTorghast()
			tc:cellsDataUpdate()
		else
			outTorghast()
		end

	elseif event == "BAG_UPDATE" then
		tc:cellsDataUpdate()

	elseif event == "BAG_UPDATE_COOLDOWN" then
		tc:cellsCDUpdate()
		tc:cellsDataUpdate()
	end
end

tc:SetPoint("TOP", UIParent, "BOTTOM", 0, 200)
tc:SetWidth(250)
tc:SetHeight(size)
tc:RegisterEvent("PLAYER_ENTERING_WORLD")
tc:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tc:SetScript("OnEvent", onEvent)

tc:cellsDataCreate()

_G.ScenarioBlocksFrame.MawBuffsBlock.Container:HookScript("OnShow", inTorghast)
_G.ScenarioBlocksFrame.MawBuffsBlock.Container:HookScript("OnHide", outTorghast)