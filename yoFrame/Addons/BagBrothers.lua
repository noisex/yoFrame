local L, yo = unpack( select( 2, ...))

local GetContainerItemInfo, GetItemCount, GetContainerNumSlots, GetNumGuildBankTabs, GetGuildBankTabInfo, GetCurrentGuildBankTab, GetGuildBankItemLink, GetGuildBankItemInfo, GetItemInfo, GetItemQualityColor
	= GetContainerItemInfo, GetItemCount, GetContainerNumSlots, GetNumGuildBankTabs, GetGuildBankTabInfo, GetCurrentGuildBankTab, GetGuildBankItemLink, GetGuildBankItemInfo, GetItemInfo, GetItemQualityColor

local select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, find, match, floor, ceil, abs, mod, modf, format, len, sub, split, gsub, gmatch
	= select, unpack, tonumber, pairs, ipairs, strrep, strsplit, max, min, string.find, string.match, math.floor, math.ceil, math.abs, math.fmod, math.modf, string.format, string.len, string.sub, string.split, string.gsub, string.gmatch

--local tinsert, tremove, tconcat = table.insert, table.remove, table.concat
--local strlower, strsub, strlen, strupper, strtrim, strmatch = strlower, strsub, strlen, strupper, strtrim, strmatch

local COMPLETE_LINK 	= '|c.+|H.+|h.+|h|r'
local PET_LINK 			= '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PET_STRING 		= '^' .. strrep('%d+:', 6) .. '%d+$'
local RACE_PORTRAITS 	= 'Interface\\CharacterFrame\\TEMPORARYPORTRAIT-%s-%s'
local RACE_TEMP			= 'Interface\\CharacterFrame\\TempPortrait'
local ERROR_HEAD		= "|cffff0000Oops, NO DATA FOUND!|cffffff00 "

local reloader = 0

local gender 	= { "", 'Male', 'Female'}
local bankBags 	= {-1, 5, 6, 7, 8, 9, 10, 11}
local bagBags  	= {0, 1, 2, 3, 4}

local borderCols= { 0.12, 0.12, 0.12, 0.7}

local bankas = {
	["bags"] = {0, 1, 2, 3, 4},
	["bank"] = {-1, 5, 6, 7, 8, 9, 10, 11},
	["regs"] = {-3},
	["gbank"]= {1}, 	--, 2, 3, 4, 5, 6, 7, 8},
}

local bagBro = CreateFrame("Frame", "yo_BBFrame", UIParent)

function bagBro:tableCopy(t)
	if not t then return end

  	local u = { }
  	for k, v in pairs(t) do
  		--u[k] = strsplit( ":", v)
  		local id, check = strsplit( ":", v)
  		id = tonumber(id)
  		if check then
  			u[id] = id
  		end
  	end
  	return setmetatable(u, getmetatable(t))
end

function bagBro:Tooltip_Show()
	GameTooltip:SetOwner(self);
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)

	if self.ttText2 then
		if self.ttText2desc then
			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
		else
			GameTooltip:AddLine(self.ttText2)
		end
	end
	GameTooltip:Show()
	local color = yo_BBFrame.nameColor
	self.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
end

function bagBro:Tooltip_Hide()
	GameTooltip:Hide()
	self.shadow:SetBackdropBorderColor( unpack( borderCols))
end

local function OnEnter( self)
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

		if self.link:match("battlepet") then
			local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", self.link)
			BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed))
		else
			GameTooltip:SetHyperlink( self.link)
		end
		GameTooltip:Show()
	elseif self.text then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:AddLine(self.text)
		GameTooltip:Show()
	end
end

local function OnLeave( self)
	GameTooltip:Hide()
end

function bagBro:CreateteItemIcon( self, buttonSize, noChecked)
	local icon = CreateFrame("CheckButton", nil, self)--, "BagSlotButtonTemplate")--, "BankItemButtonBagTemplate") 		-----, ["template"])
	icon:SetSize(buttonSize, buttonSize)

	icon.icon = icon:CreateTexture(nil, "OVERLAY")
	icon.icon:SetPoint("TOPLEFT", 0, -0)
	icon.icon:SetPoint("BOTTOMRIGHT", -0, 0)
	icon.icon:SetTexCoord(unpack( yo.tCoord))

	local hover = icon:CreateTexture(nil, "OVERLAY")--("frame", nil, icon)
	hover:SetTexture( yo.texture) --"Interface\\AddOns\\yoFrame\\Media\\boder6px.blp")
	hover:SetVertexColor( 0, 1, 0, 1)
	hover:SetPoint("TOPLEFT", -0, 0)
	hover:SetPoint("BOTTOMRIGHT", 0, -0)
	hover:SetAlpha( 0.4)
	icon.hover = hover
	icon:SetHighlightTexture( hover)

	if not noChecked then
		local checked = icon:CreateTexture(nil, "BORDER")--("frame", nil, self)
		checked:SetTexture( "Interface\\AddOns\\yoFrame\\Media\\boder6px.blp")
		checked:SetVertexColor( 0, 1, 0, 1)
		checked:SetPoint("TOPLEFT", -5, 5)
		checked:SetPoint("BOTTOMRIGHT", 5, -5)
		checked:SetAlpha( 0.9)
		icon.checked = checked
		icon:SetCheckedTexture( checked)
	end

	icon.count = icon:CreateFontString(nil, "OVERLAY")
	icon.count:SetFont( yo.font, yo.fontsize, "OUTLINE")
	icon.count:SetTextColor(1, 0.75, 0)
	icon.count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, 0)

	icon.level = icon:CreateFontString(nil, "OVERLAY")
	icon.level:SetFont( yo.font, yo.fontsize, "OUTLINE")
	icon.level:SetTextColor(1, 0.75, 0)
	icon.level:SetPoint("TOP", icon, "TOP", 0, -2)

	CreateStyle( icon, 3)

	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", OnLeave)

	return icon
end

function bagBro:RestoreLinkData(partial)
	if type(partial) == 'string' and not partial:find(COMPLETE_LINK) then
		if partial:sub(1,9) == 'battlepet' or partial:find(PET_STRING) then
			local id, quality = partial:match('(%d+):%d+:(%d+)')
			local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
			local color = select(4, GetItemQualityColor(quality))

			return PET_LINK:format(color, partial, name), tonumber( id), tonumber( quality), icon
		elseif partial:find('*') then
			--partial = string.sub( partial, 2)
			partial = "|Hitem:138019::::::::110:105:4587520:::1456:69::::|h"
			--partial = 'keystone:' .. partial
			--partial = 'item:' .. partial
			--print( "BAD: ", partial)
		elseif partial:sub(1,5) ~= 'item:' then
			partial = 'item:' .. partial
		end
	end

	if partial then
		local _, link, quality, _, _, _, _, _, itemEquipLoc, icon, _, classID = GetItemInfo(partial)
		local id = tonumber(partial) or tonumber(partial:match('^(%d+)') or partial:match('item:(%d+)'))
		return link, id, quality, icon, classID, itemEquipLoc
	end
end

function bagBro:ParseItem( link, count)
	if link then

		if link:find('0:0:0:0:0:%d+:%d+:%d+:0:0') then
			link = link:match('|H%l+:(%d+)')
		elseif link:find('Hkeystone') then
			link = "*keystoner" --.. link --:match('|H%l+:([%d:]+)')  --link = string.sub( link, 12)
		else
			link = link:match('|H%l+:([%d:]+)')
		end

		if count then -- and count > 1 then
			link = link .. ';' .. count
		end

		return link
	end
end

local function GetMaxSlots( self, name, bank)
	local numSlots = 0

	for k, bagID in pairs( bankas[bank]) do
		if self.Realm[name] and self.Realm[name][bagID] and self.Realm[name][bagID][0] then
			numSlots  = numSlots + self.Realm[name][bagID][0]
		end
	end

	if numSlots == 0 then
		print( ERROR_HEAD .. "Please, refresh " .. L[bank] .. " for " .. name .. "...|r")
	end

	return numSlots
end

local function CreateBag( self, name, bank, gtab)

	if not self.bag then
		self.bag = CreateFrame("Frame", nil, UIParent)
		self.bag:SetPoint("TOPLEFT", UIParent, "CENTER", -250, 300)
		self.bag:SetFrameStrata("HIGH")
		self.Items = {}

		self.bag.text = self.bag:CreateFontString(nil, "OVERLAY")
		self.bag.text:SetFont( yo.font, yo.fontsize, "OUTLINE")
		self.bag.text:SetPoint("TOPLEFT", self.bag, "TOPLEFT", 30, -6)

		self.bag.header = self.bag:CreateFontString(nil, "OVERLAY")
		self.bag.header:SetFont( font, fontsize+ 2, "OUTLINE")
		self.bag.header:SetPoint("TOP", self.bag, "TOP", 0, -3)

		self.bag.close = CreateFrame("Button", nil, self.bag, "UIPanelCloseButton")
		self.bag.close:SetPoint("TOPRIGHT", self.bag, "TOPRIGHT", 3, 5)

		self.bag.regs = CreateFrame("Button", nil, self.bag)
		self.bag.regs:SetPoint("TOPRIGHT", self.bag, "TOPRIGHT", -35, -4)
		self.bag.regs:SetNormalTexture( "Interface\\ICONS\\INV_Misc_Flower_02.blp")	--Spell_Nature_Polymorph_Cow.blp") --"Interface\\ICONS\\INV_Misc_Herb_09")
		self.bag.regs:GetNormalTexture():SetTexCoord(unpack( yo.tCoord))
		self.bag.regs:SetSize(17, 17)
		self.bag.regs:RegisterForClicks('anyUp')
		self.bag.regs:SetScript("OnEnter", self.Tooltip_Show)
		self.bag.regs:SetScript("OnLeave", self.Tooltip_Hide)
		CreateStyleSmall( self.bag.regs, 1)

		self.bag.bank = CreateFrame("Button", nil, self.bag)
		self.bag.bank:SetPoint("TOPRIGHT", self.bag.regs, "TOPLEFT", -4, 0)
		self.bag.bank:SetNormalTexture( "Interface\\ICONS\\INV_Misc_Coin_01")
		self.bag.bank:GetNormalTexture():SetTexCoord(unpack( yo.tCoord))
		self.bag.bank:SetSize(17, 17)
		self.bag.bank:RegisterForClicks('anyUp')
		self.bag.bank:SetScript("OnEnter", self.Tooltip_Show)
		self.bag.bank:SetScript("OnLeave", self.Tooltip_Hide)
		CreateStyleSmall( self.bag.bank, 1)

		self.bag.bag = CreateFrame("Button", nil, self.bag)
		self.bag.bag:SetPoint("TOPRIGHT", self.bag.bank, "TOPLEFT", -4, 0)
		self.bag.bag:SetNormalTexture( "Interface\\ICONS\\INV_Misc_Bag_07")
		self.bag.bag:GetNormalTexture():SetTexCoord(unpack( yo.tCoord))
		self.bag.bag:SetSize(17, 17)
		self.bag.bag:RegisterForClicks('anyUp')
		self.bag.bag:SetScript("OnEnter", self.Tooltip_Show)
		self.bag.bag:SetScript("OnLeave", self.Tooltip_Hide)
		CreateStyleSmall( self.bag.bag, 1)

		self.bag:EnableMouse(true)
		self.bag:SetMovable(true)
		self.bag:RegisterForDrag("LeftButton", "RightButton")
		self.bag:SetScript("OnDragStart", function(self) self:StartMoving() end)
		self.bag:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

		self:CreateBagIconButton( self.bag, self.bag)
		CreateStyle( self.bag, 3)
	end

	local buttonSize 		= yo.Bags.buttonSize
	local buttonSpacing 	= yo.Bags.buttonSpacing
	local containerWidth 	= yo.Bags.containerWidth
	local numMaxRow 		= yo.Bags.numMaxRow

	local bankList = {}
	local maxStolbs, numContainerRows, holderWidth, rows, stroka, stolb = 0, 0, 0

	if bank == "gbank" then
		if not self.Realm[name] then
			print( ERROR_HEAD .. "Please, refresh ".. GUILD_BANK .."!|r")
			return
		elseif not self.Realm[name][gtab] then
			print( ERROR_HEAD  .. "Please, refresh #".. gtab.." tab ".. GUILD_BANK .."...|r")
			return
		elseif not self.Realm[name][gtab][0] then
			print( ERROR_HEAD  .. "Please, refresh #".. gtab.." tab ".. GUILD_BANK .."...|r")
			return
		end

		containerWidth 	= 570
		maxSlots = 98
		bankList = { gtab}
		self.nameColor 	= self.myColor

		if not self.bag.gtab then
			self.bag.gtab = CreateFrame("Frame", nil, self.bag)
			self.bag.gtab:SetPoint("TOPLEFT", self.bag, "TOPRIGHT", 5, 0)
			self.bag.gtab:SetSize( buttonSize + buttonSpacing * 2, 30)
			CreateStyle( self.bag.gtab, 3)

			self.bag.gtab.icons = {}
			for tabID, data in pairs( self.Realm[name]) do

				self.bag.gtab.icons[tabID] = self:CreateteItemIcon( self.bag.gtab, buttonSize)
				self.bag.gtab.icons[tabID]:SetPoint("TOPLEFT", self.bag.gtab, "TOPLEFT", 7, -( buttonSize + 5) * ( tabID - 1) - 7)
				self.bag.gtab.icons[tabID].icon:SetTexture( data.icon)
				self.bag.gtab.icons[tabID].text = data.name
				self.bag.gtab.icons[tabID]:SetScript("OnClick", function(self, ...)
					CreateBag( yo_BBFrame, GetGuildInfo('player') .. '*', "gbank", tabID)
				end)
			end
		end
		for i = 1, #self.bag.gtab.icons do
			self.bag.gtab.icons[i]:SetChecked( i == gtab)
		end

		self.bag.header:SetTextColor( myColor.r, myColor.g, myColor.b)
		self.bag.header:SetText( name .. " : " .. self.bag.gtab.icons[gtab].text)

		self.bag.text:SetText( date( "%d.%m.%y %H:%M", self.Realm[name][gtab].lgbtime))
		self.bag.text:SetTextColor( myColor.r, myColor.g, myColor.b)

		self.bag.bagButton:SetNormalTexture( format( RACE_PORTRAITS, gender[yo_AllData[myRealm][myName].Sex], yo_AllData[myRealm][myName].Race))
		self.bag.gtab:Show()
	else
		maxSlots = GetMaxSlots( self, name, bank)
		if maxSlots == 0 then return end

		bankList = bankas[bank]
		self.nameColor = yo_AllData[myRealm][name].Color

		if self.bag.gtab then self.bag.gtab:Hide() end
		self.bag.header:SetTextColor( self.nameColor.r, self.nameColor.g, self.nameColor.b)
		self.bag.header:SetText( name .. " : " .. L[bank])
		self.bag.text:SetText("")
		self.bag.bagButton:SetNormalTexture( format( RACE_PORTRAITS, gender[yo_AllData[myRealm][name].Sex], yo_AllData[myRealm][name].Race))
	end

	if maxSlots == 0 then return end

	repeat
		maxStolbs = floor(containerWidth / (buttonSize + buttonSpacing));
		holderWidth = ((buttonSize + buttonSpacing) * maxStolbs) - buttonSpacing;
		rows = math.ceil( maxSlots / maxStolbs)

		if rows > numMaxRow then
			containerWidth = containerWidth + buttonSize + buttonSpacing
		end
	until rows <= numMaxRow

	local holderHeight = rows * ( buttonSize + buttonSpacing)

	self.bag:SetSize( holderWidth + 20, holderHeight + 35)

	local buttonName 		= gtab and myName or name
	self.bag.bank.ttText 	= buttonName .. ": " .. BANK
	self.bag.bag.ttText 	= buttonName .. ": " .. BAGSLOT
	self.bag.regs.ttText 	= buttonName .. ": " .. REAGENT_BANK
	self.bag.bag:SetScript( 'OnClick', function( ) CreateBag( self, buttonName, "bags") end)
	self.bag.bank:SetScript('OnClick', function( ) CreateBag( self, buttonName, "bank") end)
	self.bag.regs:SetScript('OnClick', function( ) CreateBag( self, buttonName, "regs") end)

	if self.bag.gtab then
		self.bag.gtab:SetSize( buttonSize + buttonSpacing * 2, holderHeight + 35)
	end

	local index = 0

	local needReload = false
	for i, bagID in pairs( bankList) do

		if self.Realm[name][bagID] and self.Realm[name][bagID][0]  > 0 then

			for i = 1, self.Realm[name][bagID][0] do

				self.Items[index] = self.Items[index] or self:CreateteItemIcon( self.bag, buttonSize, true)

				if bank == "gbank" then
					stroka = mod( index + rows , rows)
					stolb = modf( index / rows) ---!!!!!
				else
					stroka = modf( index / maxStolbs) 	--!!!!
					stolb = mod( index + maxStolbs , maxStolbs)
				end
				local x = ( buttonSize + buttonSpacing) * ( stolb) + 10
				local y = ( buttonSize + buttonSpacing) * ( stroka) + 30

				self.Items[index]:ClearAllPoints()
				self.Items[index]:SetPoint("TOPLEFT", self.bag, "TOPLEFT", x, -y)

				self.Items[index]:Show()

				local itemStr = self.Realm[name][bagID][i]

				if itemStr then
					local itemLinkStr, count = strsplit( ";", itemStr)

					local itemLink, id, itemRarity, itemIcon, itemClass, equipLoc = self:RestoreLinkData( itemLinkStr)

					if itemLink and itemRarity and itemIcon then

						local item 	= Item:CreateFromItemLink( itemLink)
						local itemLevel = item:GetCurrentItemLevel()

						local r, g, b = unpack( borderCols)				--0.12, 0.12, 0.12 -- !!! DEFAULT COLOR
						if itemRarity > 1 then r, g, b = GetItemQualityColor(itemRarity)	end
						if itemClass == 12 then r, g, b = 1.0, 0.3, 0.3	end 					-- Quest item color

						--if (equipLoc ~= nil and equipLoc ~= 0 and equipLoc ~= 18 and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_QUIVER" and equipLoc ~= "INVTYPE_TABARD") and itemRarity > 1 and itemLevel > 1 then
						if ( equipLoc and _G[equipLoc] and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_TABARD") and itemRarity > 1 and itemLevel > 1 then
							self.Items[index].level:SetText( itemLevel)
						else
							self.Items[index].level:SetText("")
						end

						if count and tonumber( count) > 1 then
							self.Items[index].count:SetText( count)
						else
							self.Items[index].count:SetText( "")
						end

						self.Items[index].link = itemLink
						self.Items[index].icon:SetTexture( itemIcon)
						self.Items[index].level:SetTextColor(r, g, b)
						self.Items[index].shadow:SetBackdropBorderColor(r, g, b, 0.7)
					else
						needReload = true
					end
				else
					self.Items[index].link = nil
					self.Items[index].count:SetText( "")
					self.Items[index].level:SetText( "")
					self.Items[index].icon:SetTexture( nil)
					self.Items[index].shadow:SetBackdropBorderColor( unpack( borderCols))
				end
				index = index + 1
			end
		end
	end

	for i = maxSlots, #self.Items do self.Items[i]:Hide() end

	self.bag:Show()

	if needReload then
		C_Timer.After( 0.5, function()
			reloader = reloader + 1
			if reloader < 5 then
				CreateBag( self, name, bank, gtab)
			else
				print("|cffff9900Warning!|r Hmmm... something going wrong, no found item info in cache!")
			end
		end)
	else
		reloader = 0
	end
end

local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = BAGSLOT, isTitle = true, notCheckable=true},
}

function bagBro:CreateBagIconButton( self, parent)
	local parent = parent and parent or yo_BagsFrame.bagFrame
	local gicon, guildTexCoord

	self.bagButton = CreateFrame("Button", nil, self)
	self.bagButton:SetSize(22, 22)
	self.bagButton:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
	self.bagButton:SetParent( parent)
	self.bagButton:SetNormalTexture( format( RACE_PORTRAITS, gender[mySex], myRace))

	if parent.editBox then
		local a1, p, a2, x, y = parent.editBox:GetPoint(1)
		parent.editBox:ClearAllPoints()
		parent.editBox:SetPoint( a1, p, a2, x + 25, y)
	end

	self.bagButton:SetScript("OnClick", function(self, ...)
		local index = 2

		for name, player in pairs( yo_BB[myRealm]) do
			if not name:match( "*") then
				local iconPers
				if not gender[yo_AllData[myRealm][name].Sex] or not yo_AllData[myRealm][name].Race then
					iconPers = RACE_TEMP
				else
					iconPers = format( RACE_PORTRAITS, gender[yo_AllData[myRealm][name].Sex], yo_AllData[myRealm][name].Race)
				end

				menuList[index] = {text = "|T" .. iconPers .. ":24:24:-5:0|t" .. name, notCheckable=true, hasArrow = true, func = function() CreateBag( yo_BBFrame, name, "bags") end,
					menuList = {
						{ text = name, icon = iconPers	, isTitle = true, notCheckable=true},
						{ text = BAGSLOT, 		notCheckable=true, func = function() CreateBag( yo_BBFrame, name, "bags") end},
						{ text = BANK, 			notCheckable=true, func = function() CreateBag( yo_BBFrame, name, "bank") end},
						{ text = REAGENT_BANK,	notCheckable=true, func = function() CreateBag( yo_BBFrame, name, "regs") end},
					},
				}
				index = index + 1
			end
		end
		--select(10, GetGuildLogoInfo())
		if GuildFrameTabardEmblem then
			guildTexCoord = {GuildFrameTabardEmblem:GetTexCoord()}
		end

		if IsInGuild() and guildTexCoord then
			gicon = "|TInterface\\GuildFrame\\GuildEmblemsLG_01:24:24:-5:0:32:32:"..(guildTexCoord[1]*32)..":"..(guildTexCoord[7]*32)..":"..(guildTexCoord[2]*32)..":"..(guildTexCoord[8]*32).."|t"
		else
			gicon = "|TInterface\\GuildFrame\\GuildLogo-NoLogo:24:24:-5:0|t"
		end

		if yo.Bags.showGuilBank and IsInGuild() then
			menuList[index] = { text = gicon .. "|cff00ff00" .. GUILD_BANK, notCheckable=true, func = function() CreateBag( yo_BBFrame, GetGuildInfo('player') .. '*', "gbank", 1) end}
			index = index + 1
		end

		reloader = 0
		EasyMenu(menuList, menuFrame, self, -20, -3, "MENU", 3)
	end)
end

local function SaveBags( self, bag)
	local size = GetContainerNumSlots(bag)
	self.Player[bag] = {}	--items = {}

	if size > 0 then
		for slot = 1, size do
			local _, count, _,_,_,_, link, _, _, itemID = GetContainerItemInfo(bag, slot)
			self.Player[bag][slot] = self:ParseItem( link, count)

			if itemID and count > 0 then
				--print( link, itemID, GetItemCount( itemID, true))
				yo_BBCount[myRealm][myName][itemID] = GetItemCount( itemID, true)
				if self.tempBags and self.tempBags[bag] then
					self.tempBags[bag][itemID] = nil
				end
			end
		end

		self.Player[bag][0] = size
	else
		self.Player[bag][0] = 0 	--nil
	end
end

local function SaveGuilds( self)
	local id = GetGuildInfo('player') .. '*'
	local guild = self.Realm[id] or {}
	--guild.faction = UnitFactionGroup('player') == 'Alliance'
	guild.faction = nil

	for i = 1, GetNumGuildBankTabs() do
		guild[i] = guild[i] or {}
		guild[i].name, guild[i].icon, guild[i].view = GetGuildBankTabInfo(i)
	end

	local tab = GetCurrentGuildBankTab()
	local items = guild[tab]
	if items then
		items.deposit, items.withdraw, items.remaining = select(4, GetGuildBankTabInfo(tab))

		for i = 1, 98 do
			local link = GetGuildBankItemLink(tab, i)
			local _, count = GetGuildBankItemInfo(tab, i)

			items[i] = self:ParseItem( link, count)
		end
		items[0] = 98
		guild[tab].lgbtime = time()
	end

	self.Realm[id] = guild
	yo_AllData[myRealm][myName]["LGBTime"] = time()
end

function bagBro:CheckForClean( self)
	for bagID, val in pairs( self.needUpBag) do

		for itemID, bag in pairs( self.tempBags[bagID]) do
			local count = GetItemCount( itemID, true)
			if count > 0 then
				yo_BBCount[myRealm][myName][itemID] = count
			else
				if itemID and yo_BBCount[myRealm][myName][itemID] then
					yo_BBCount[myRealm][myName][itemID] = nil
				end
			end
		end
		self.needUpBag[bagID] = nil
	end
end

local function OnEvent( self, event, change)
	--print(event, change)
	if event == "PLAYER_ENTERING_WORLD" then
		if not yo.Bags.showAltBags then return end

		local firstRun
		if not yo_BB then yo_BB = {} end
		if not yo_BB[myRealm] then yo_BB[myRealm] = {} end
		if not yo_BB[myRealm][myName] then yo_BB[myRealm][myName] = {} firstRun = true end

		if not yo_BBCount then yo_BBCount = {} end
		if not yo_BBCount[myRealm] then yo_BBCount[myRealm] = {} end
		if not yo_BBCount[myRealm][myName] then yo_BBCount[myRealm][myName] = {} end

		self.needUpBag 	= {}
		self.Realm  	= yo_BB[myRealm]
		self.Player 	= yo_BB[myRealm][myName]
		self.myColor 	= yo_AllData[myRealm][myName].Color
		--self.iRealm 	= yo_BBCount[myRealm]
		--self.iPlayer 	= yo_BBCount[myRealm][myName]

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent('BAG_UPDATE')

		self:RegisterEvent('BANKFRAME_OPENED')
		self:RegisterEvent('BANKFRAME_CLOSED')

		if yo.Bags.showGuilBank then
			--self:RegisterEvent('GUILD_ROSTER_UPDATE')
			self:RegisterEvent('GUILDBANKFRAME_OPENED')
			self:RegisterEvent('GUILDBANKFRAME_CLOSED')
			self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
		end

		if yo_BagsFrame.bagFrame then
			yo_BagsFrame.bagFrame:HookScript("OnShow", function()
				self.tempBags = {}
				for i, bag in pairs( bankas["bags"]) do
					self.tempBags[bag] = self:tableCopy( self.Player[bag])
				end
			end)

			yo_BagsFrame.bagFrame:HookScript("OnHide", function() bagBro:CheckForClean( self) end)
		end

		if firstRun then
			for i, bag in pairs( bankas["bags"]) do
				SaveBags( self, bag)
			end
		end

		self:CreateBagIconButton( self)

	elseif event == "BAG_UPDATE" then
		if change >= 0 and change <= 4 then
			SaveBags( self, change)
			self.needUpBag[change] = true
		end

	elseif event == "BANKFRAME_OPENED" then
		self.needUpBank = true
		for i, bag in pairs( bankas["bank"]) do
			self.tempBags[bag] = self:tableCopy( self.Player[bag])
		end
		if IsReagentBankUnlocked() then
			self.tempBags[-3] = self:tableCopy( self.Player[-3])
		end

	elseif event == "BANKFRAME_CLOSED" then
		if self.needUpBank then
			for i, bag in pairs( bankas["bank"]) do
				SaveBags( self, bag)
			end
			if IsReagentBankUnlocked() then
				SaveBags( self, -3)
			end
			self.needUpBank = false
		end

	elseif event == "GUILDBANKFRAME_OPENED" then
		self.needUpGB = true

	elseif event == "GUILDBANKFRAME_CLOSED" then
		self.needUpGB = false

	elseif event == "GUILDBANKBAGSLOTS_CHANGED" then
		if self.needUpGB then
			SaveGuilds( self)
		end
	end
end


bagBro:RegisterEvent("PLAYER_ENTERING_WORLD")
bagBro:SetScript("OnEvent", OnEvent)

--[Virag's DT]: 19 -
--|cffa335ee|Hitem:
--45457:3828:3395:3395:0:0:0:0:80:0:0:0|h[Staff of Endless Winter]|h|r,
--113602:0:0:0:0:0:0:0:100:0:5:1:566|h[Throat-Ripper Gauntlets]|h|r
--itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:upgradeId:instanceDifficultyID:numBonusIds:bonusId1:bonusid2:..
--158923:252:8:9:7:12:0
--Hkeystone:158923:252:8:9:7:12:0[Ключ: Святилище Штормов (8)];1
--[[
function GuildMicroButton_UpdateTabard(forceUpdate)
	local tabard = GuildMicroButtonTabard;
	if ( not tabard.needsUpdate and not forceUpdate ) then
		return;
	end
	-- switch textures if the guild has a custom tabard
	local emblemFilename = select(10, GetGuildLogoInfo());
	if ( emblemFilename ) then
		if ( not tabard:IsShown() ) then
			local button = GuildMicroButton;
			button:SetNormalAtlas("hud-microbutton-Character-Up", true);
			button:SetPushedAtlas("hud-microbutton-Character-Down", true);
			-- no need to change disabled texture, should always be available if you're in a guild
			tabard:Show();
		end
		SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background);
	else
		if ( tabard:IsShown() ) then
			local button = GuildMicroButton;
			button:SetNormalAtlas("hud-microbutton-Socials-Up", true);
			button:SetPushedAtlas("hud-microbutton-Socials-Down", true);
			button:SetDisabledAtlas("hud-microbutton-Socials-Disabled", true);
			tabard:Hide();
		end
	end
	tabard.needsUpdate = nil;
end

function SetLargeGuildTabardTextures(unit, emblemTexture, backgroundTexture, borderTexture, tabardData)
	-- texure dimensions are 1024x1024, icon dimensions are 64x64
	local emblemSize, columns, offset;
	if ( emblemTexture ) then
		emblemSize = 64 / 1024;
		columns = 16
		offset = 0;
		emblemTexture:SetTexture("Interface\\GuildFrame\\GuildEmblemsLG_01");
	end
	SetGuildTabardTextures(emblemSize, columns, offset, unit, emblemTexture, backgroundTexture, borderTexture, tabardData);
end

function SetSmallGuildTabardTextures(unit, emblemTexture, backgroundTexture, borderTexture, tabardData)
	-- texure dimensions are 256x256, icon dimensions are 16x16, centered in 18x18 cells
	local emblemSize, columns, offset;
	if ( emblemTexture ) then
		emblemSize = 18 / 256;
		columns = 14;
		offset = 1 / 256;
		emblemTexture:SetTexture("Interface\\GuildFrame\\GuildEmblems_01");
	end
	SetGuildTabardTextures(emblemSize, columns, offset, unit, emblemTexture, backgroundTexture, borderTexture, tabardData);
end

function SetDoubleGuildTabardTextures(unit, leftEmblemTexture, rightEmblemTexture, backgroundTexture, borderTexture, tabardData)
	if ( leftEmblemTexture and rightEmblemTexture ) then
		SetGuildTabardTextures(nil, nil, nil, unit, leftEmblemTexture, backgroundTexture, borderTexture, tabardData);
		rightEmblemTexture:SetTexture(leftEmblemTexture:GetTexture());
		rightEmblemTexture:SetVertexColor(leftEmblemTexture:GetVertexColor());
	end
end

function SetGuildTabardTextures(emblemSize, columns, offset, unit, emblemTexture, backgroundTexture, borderTexture, tabardData)
	local bkgR, bkgG, bkgB, borderR, borderG, borderB, emblemR, emblemG, emblemB, emblemFilename;
	if ( tabardData ) then
		bkgR = tabardData[1];
		bkgG = tabardData[2];
		bkgB = tabardData[3];
		borderR = tabardData[4];
		borderG = tabardData[5];
		borderB = tabardData[6];
		emblemR = tabardData[7];
		emblemG = tabardData[8];
		emblemB = tabardData[9];
		emblemFilename = tabardData[10];
	else
		bkgR, bkgG, bkgB, borderR, borderG, borderB, emblemR, emblemG, emblemB, emblemFilename = GetGuildLogoInfo(unit);
	end
	if ( emblemFilename ) then
		if ( backgroundTexture ) then
			backgroundTexture:SetVertexColor(bkgR / 255, bkgG / 255, bkgB / 255);
		end
		if ( borderTexture ) then
			borderTexture:SetVertexColor(borderR / 255, borderG / 255, borderB / 255);
		end
		if ( emblemSize ) then
			local index = emblemFilename:match("([%d]+)");
			if ( index) then
				index = tonumber(index);
				local xCoord = mod(index, columns) * emblemSize;
				local yCoord = floor(index / columns) * emblemSize;
				emblemTexture:SetTexCoord(xCoord + offset, xCoord + emblemSize - offset, yCoord + offset, yCoord + emblemSize - offset);
			end
			emblemTexture:SetVertexColor(emblemR / 255, emblemG / 255, emblemB / 255);
		elseif ( emblemTexture ) then
			emblemTexture:SetTexture(emblemFilename);
			emblemTexture:SetVertexColor(emblemR / 255, emblemG / 255, emblemB / 255);
		end
	else
		-- tabard lacks design
		if ( backgroundTexture ) then
			backgroundTexture:SetVertexColor(0.2245, 0.2088, 0.1794);
		end
		if ( borderTexture ) then
			borderTexture:SetVertexColor(0.2, 0.2, 0.2);
		end
		if ( emblemTexture ) then
			if ( emblemSize ) then
				if ( emblemSize == 18 / 256 ) then
					emblemTexture:SetTexture("Interface\\GuildFrame\\GuildLogo-NoLogoSm");
				else
					emblemTexture:SetTexture("Interface\\GuildFrame\\GuildLogo-NoLogo");
				end
				emblemTexture:SetTexCoord(0, 1, 0, 1);
				emblemTexture:SetVertexColor(1, 1, 1, 1);
			else
				emblemTexture:SetTexture("");
			end
		end
	end
end

]]--