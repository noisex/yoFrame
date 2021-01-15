 local _, ns 	= ...
local L, yo, n 	= unpack( ns)
local oUF 		= ns.oUF or oUF

local _G = _G
local CreateFrame, SetUpAnimGroup, commav, nums, floor
	= CreateFrame, SetUpAnimGroup, commav, nums, floor

local maw = CreateFrame("Frame", nil, UIParent)
n.Addons.maw = maw

local progressPerTier= 1000
local totalTiers= 5

local colors = {
	[0] = "MAGE",
	[1] = "MONK",
	[2] = "HUNTER",
	[3] = "ROGUE",
	[4] = "DRUID",
	[5] = "DEATHKNIGHT",
}

local function createMawBar(self, ...)
	self.bar = CreateFrame("StatusBar", nil, self)
	self.bar:SetPoint("TOP", _G.UIWidgetTopCenterContainerFrame, "TOP", 0, -110)
	self.bar:SetWidth(140)
	self.bar:SetHeight(15)
	self.bar:SetStatusBarTexture(n.texture)
	self.bar:SetMinMaxValues(0, 5000)

	self.bar.tier = self.bar:CreateFontString(nil, "OVERLAY")
	self.bar.tier:SetFont( n.font, n.fontsize, "OUTLINE")
	self.bar.tier:SetPoint("LEFT", self.bar, "LEFT", 5, 0)

	self.bar.value = self.bar:CreateFontString(nil, "OVERLAY")
	self.bar.value:SetFont( n.font, n.fontsize, "OUTLINE")
	self.bar.value:SetPoint("RIGHT", self.bar, "RIGHT", -5, 0)

	self.bar.progress = self.bar:CreateFontString(nil, "OVERLAY")
	self.bar.progress:SetFont( n.font, n.fontsize + 10, "OUTLINE")
	self.bar.progress:SetPoint("TOP", self.bar, "BOTTOM", 0, -6)

	SetUpAnimGroup( self.bar.progress, "Fadeout", 0, 1, 1.7, 0)
	self.bar:createStyle( 3)

	self.bar:Hide()
end

maw.isInMaw = function()
    local id = C_Map.GetBestMapForUnit('player')
    return (id ==1543 or id ==1820 or id ==1821 or id ==1822 or id==1823), id
end

maw.getInfo = function()
    local setID = C_UIWidgetManager.GetTopCenterWidgetSetID()
    local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(setID)
    local i,widget,info
    for i=1,#widgets do
        widget = widgets[i]
        info = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(widget.widgetID)
        maw.widget = widget
        if (info) then
            return info
        end
    end
    return nil
end

maw.setInfo = function( info)

    local progress = info.progressVal

    if progress ~= maw.progress then

    	local tier 		= floor(progress / progressPerTier)
    	local colorTier = colors[tier]
    	local col 	 	= oUF.colors.class[colorTier]

    	maw.bar:SetStatusBarColor( col[1], col[2], col[3])
    	maw.bar.tier:SetTextColor( col[1], col[2], col[3])
    	maw.bar.value:SetTextColor( col[1], col[2], col[3])
    	maw.bar.progress:SetTextColor( col[1], col[2], col[3])

	   	if progress >= progressPerTier * totalTiers then
    		maw.bar.tier:SetText( "")
    		maw.bar.value:SetText( "Тікай хлопец, тобi пiзда!") --"Ты пьян, иди домой!")
    	else
    		maw.bar.tier:SetText( tier..'/'..totalTiers)
    		maw.bar.value:SetText( commav( progress) .. "/" .. nums( progressPerTier * totalTiers))
    	end

    	maw.bar:SetValue( progress)
    	maw.bar.progress:SetText( "+" .. progress - ( maw.progress or 0))

    	maw.info = info
    	maw.progress = progress

    	maw.bar.progress.Fadeout:Play()
    end

    maw.bar:Show()
end

maw.updateWiget = function ()
	local info = maw.getInfo()

	if info then
		maw.setInfo( info)
	end
end

local function checkForMaw( self)

	if maw.isInMaw() then
		if not maw.reged then
			if not maw.bar then createMawBar( self) end
			maw:RegisterEvent("UPDATE_UI_WIDGET")
			maw.reged = true
			maw.updateWiget()
		end
	else
		if maw.bar then maw.bar:Hide() end

		if maw.reged then
			maw:UnregisterEvent("UPDATE_UI_WIDGET")
			maw.reged = false
		end

	end
end

local function onEvent( self, event, ...)
	--local map, id = maw.isInMaw()
	--print(event, map, id)

	if event == "PLAYER_ENTERING_WORLD"	or event == "ZONE_CHANGED_NEW_AREA" then
		checkForMaw( self)
	elseif event == "UPDATE_UI_WIDGET" then
		maw.updateWiget()
	end
end

maw:RegisterEvent("PLAYER_ENTERING_WORLD")
maw:RegisterEvent("ZONE_CHANGED_NEW_AREA")
maw:SetScript("OnEvent", onEvent)