local L, yo = unpack( select( 2, ...))

local COMPLETE_LINK = '|c.+|H.+|h.+|h|r'
local PET_LINK = '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PET_STRING = '^' .. strrep('%d+:', 6) .. '%d+$'
local reloader

local bankBags = {-1, 5, 6, 7, 8, 9, 10, 11} 
local bagBags  = {0, 1, 2, 3, 4}

local bankas = {
	["bags"] = {0, 1, 2, 3, 4},
	["bank"] = {-1, 5, 6, 7, 8, 9, 10, 11},
	["regs"] = {-3},
	["gbank"]= {1}, 	--, 2, 3, 4, 5, 6, 7, 8},
}

local function OnEnter( self)
	--print(self.link )
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetHyperlink( self.link)
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

local function CreateteItemIcon( self, stolb, stroka, buttonSize, buttonSpacing)
	local icon = CreateFrame("Button", nil, self) 		-----, ["template"])
	icon:SetSize(buttonSize, buttonSize)

	icon.icon = icon:CreateTexture(nil, "OVERLAY")
	--icon.icon:SetAllPoints()
	icon.icon:SetPoint("TOPLEFT", 1, -1)
	icon.icon:SetPoint("BOTTOMRIGHT", -1, 1)
	icon.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	
	local hover = icon:CreateTexture("frame", nil, icon)
	hover:SetTexture( texture)
	hover:SetVertexColor( 0, 1, 0, 1)
	hover:SetPoint("TOPLEFT", 1, -1)
	hover:SetPoint("BOTTOMRIGHT", -1, 1)
	hover:SetAlpha( 0.4)
	icon.hover = hover
	icon:SetHighlightTexture( hover)

	icon.count = icon:CreateFontString(nil, "OVERLAY")
	icon.count:SetFont( font, fontsize, "OUTLINE")
	icon.count:SetTextColor(1, 0.75, 0)
	icon.count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, 0)

	icon.level = icon:CreateFontString(nil, "OVERLAY")
	icon.level:SetFont( font, fontsize, "OUTLINE")
	icon.level:SetTextColor(1, 0.75, 0)
	icon.level:SetPoint("TOP", icon, "TOP", 0, -2)

	CreateStyle( icon, 4)

	icon:SetScript("OnEnter", OnEnter)
	icon:SetScript("OnLeave", OnLeave)

	return icon
end
local nrFrame, nrSelf, nrName

local function RestoreLinkData(partial)
	if type(partial) == 'string' and not partial:find(COMPLETE_LINK) then
		if partial:sub(1,9) == 'battlepet' or partial:find(PET_STRING) then
			local id, quality = partial:match('(%d+):%d+:(%d+)')
			local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
			local color = select(4, GetItemQualityColor(quality))

			return PET_LINK:format(color, partial, name), id, quality, icon
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
		local _, link, quality, _, _, _, _, _, _, icon = GetItemInfo(partial)
		local id = tonumber(partial) or tonumber(partial:match('^(%d+)') or partial:match('item:(%d+)'))
		return link, id, quality, icon
	end
end

local function GetMaxSlots( self, name, bank)
	local numSlots = 0	
	
	--tprint( bankas[bank])
	for k, bagID in pairs( bankas[bank]) do		
		if yo_BB[myRealm][name] and yo_BB[myRealm][name][bagID] and yo_BB[myRealm][name][bagID][0] then
			--print( k, v, yo_BB[myRealm][name][v][0])
			numSlots  = numSlots + yo_BB[myRealm][name][bagID][0]
		end
	end
	--print(self, name, bank, numSlots)
	if numSlots == 0 then
		print( "|cffff0000ERROR, NO DATA FOUND!|cffffff00 Pls, refresh bags and bank for this character...|r")
	end 

	return numSlots
end

local function CreateBag( self, name, bank, gtab)
	
	if not self.bag then
		self.bag = CreateFrame("Frame", nil, UIParent)
		self.bag:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		self.Items = {}

		self.bag.text = self.bag:CreateFontString(nil, "OVERLAY")
		self.bag.text:SetFont( font, fontsize, "OUTLINE")
		self.bag.text:SetPoint("TOPLEFT", self.bag, "TOPLEFT", 25, -5)		

		self.bag.close = CreateFrame("Button", nil, self.bag, "UIPanelCloseButton")
		self.bag.close:SetPoint("TOPRIGHT", self.bag, "TOPRIGHT", 3, 5)

		self.bag:EnableMouse(true)
		self.bag:SetMovable(true)
		self.bag:RegisterForDrag("LeftButton", "RightButton")
		self.bag:SetScript("OnDragStart", function(self) self:StartMoving() end)
		self.bag:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

		CreateBagIconButton( self.bag, self.bag)

		CreateStyle( self.bag, 3)
	end

	local buttonSize 			= yo.Bags.buttonSize
	local buttonSpacing 		= yo.Bags.buttonSpacing
	local containerWidth 		= yo.Bags.containerWidth
	local numMaxRow 			= yo.Bags.numMaxRow
	local maxSlots
	local rows
	local cols, bankList = {}, {}

	local maxStolbs, numContainerRows, holderWidth = 0, 0, 0
	
	if bank == "gbank" then
		if not yo_BB[myRealm][name] then
			print( "|cffff0000ERROR, NO DATA FOUND!|cffffff00 Please, refresh guildbank!|r")
			return
		elseif not yo_BB[myRealm][name][gtab][0] then
			print( "|cffff0000ERROR, NO DATA FOUND!|cffffff00 Pls, refresh guildbank for this tab...|r")
			return
		end

		containerWidth 	= 570
		maxSlots = 98
		cols.r = 1 cols.g = .75 cols.b = 0
		bankList = { gtab}

		if not self.bag.gtab then
			self.bag.gtab = CreateFrame("Frame", nil, self.bag)
			self.bag.gtab:SetPoint("TOPLEFT", self.bag, "TOPRIGHT", 5, 0)
			self.bag.gtab:SetSize( buttonSize + buttonSpacing * 2, 30) 
			CreateStyle( self.bag.gtab, 3)

			self.bag.gtab.icons = {}
			for k,v in pairs( yo_BB[myRealm][name]) do

				self.bag.gtab.icons[k] = CreateteItemIcon( self.bag.gtab, 1, k, buttonSize, buttonSpacing)
				self.bag.gtab.icons[k]:SetPoint("TOPLEFT", self.bag.gtab, "TOPLEFT", 7, -( buttonSize + 5) * ( k - 1) - 7)
				self.bag.gtab.icons[k].icon:SetTexture( v.icon)
				self.bag.gtab.icons[k].text = v.name
				self.bag.gtab.icons[k]:SetScript("OnClick", function(self, ...)
					CreateBag( yo_BBFrame, GetGuildInfo('player') .. '*', "gbank", k)
				end)
			end
		end
		self.bag.gtab:Show()
	else
		maxSlots = GetMaxSlots( self, name, bank)
		cols = yo_AllData[myRealm][name].Color
		bankList = bankas[bank]
		if self.bag.gtab then self.bag.gtab:Hide() end
	end
	
	if maxSlots == 0 then return end
	
	repeat
		maxStolbs = floor(containerWidth / (buttonSize + buttonSpacing));
		holderWidth = ((buttonSize + buttonSpacing) * maxStolbs) - buttonSpacing;
		rows = math.ceil( maxSlots / maxStolbs)
	
		if rows > numMaxRow then
			containerWidth = containerWidth + buttonSize + buttonSpacing
		end
		--print( rows, maxStolbs, containerWidth, holderWidth, containerWidth / (buttonSize + buttonSpacing))
	until rows <= numMaxRow

	local holderHeight = rows * ( buttonSize + buttonSpacing)	

	self.bag.text:SetText( name)
	self.bag.text:SetTextColor(cols.r, cols.g, cols.b)
	self.bag:SetSize( holderWidth + 20, holderHeight + 35)
	
	if self.bag.gtab then 
		self.bag.gtab:SetSize( buttonSize + buttonSpacing * 2, holderHeight + 35) 
	end

	local index = 0	
	
	local needReload = false
	for i, bagID in pairs( bankList) do	

		--print( name, bank, maxSlots, bagID)--, yo_BB[myRealm][name][bagID][0])
		if yo_BB[myRealm][name][bagID] and yo_BB[myRealm][name][bagID][0]  > 0 then
		
			local numSlots = yo_BB[myRealm][name][bagID][0]
		
			for i = 1, numSlots do
				local stroka = math.modf( index / maxStolbs)
				local stolb = mod( index + maxStolbs , maxStolbs)
				
				self.Items[index] = self.Items[index] or CreateteItemIcon( self.bag, stolb, stroka, buttonSize, buttonSpacing)
				local x = ( buttonSize + buttonSpacing) * ( stolb) + 10
				local y = ( buttonSize + buttonSpacing) * ( stroka) + 30
				self.Items[index]:ClearAllPoints()
				self.Items[index]:SetPoint("TOPLEFT", self.bag, "TOPLEFT", x, -y)

				self.Items[index]:Show()

				local itemStr = yo_BB[myRealm][name][bagID][i]
				if itemStr then									
					local itemLinkStr, count = strsplit( ";", itemStr)	
					--print( index, " max: ", maxStolbs, " stolb: ", stolb, " stroka: : ", stroka, itemLink, containerWidth / (buttonSize + buttonSpacing) )
					
					local itemLink, id, itemRarity, itemIcon = RestoreLinkData( itemLinkStr)
					
					if itemLink and itemRarity and itemIcon then
						local item 	= Item:CreateFromItemLink( itemLink)
						local itemColor = item:GetItemQualityColor()
						local itemLevel = item:GetCurrentItemLevel()
						local equipLoc	= item:GetInventoryType()
						--local itemIcon 	= item:GetItemIcon()
						--local itemRarity= item:GetItemQuality()
						--tprint( itemColor)
					
						local r, g, b = itemColor.r, itemColor.g, itemColor.b
						--print( bagID, i, itemStr, itemLink, count, itemRarity, itemLevel, equipLoc)
						if (equipLoc ~= nil and equipLoc ~= 0 and equipLoc ~= 18 and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_QUIVER" and equipLoc ~= "INVTYPE_TABARD") and itemRarity > 1 and itemLevel > 1 then
							--print(equipLoc, itemLevel, itemLink)
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
						self.Items[index].shadow:SetBackdropBorderColor(r, g, b, 0.3)
					else
						needReload = true
					end				
				else
					self.Items[index].link = nil
					self.Items[index].count:SetText( "") 
					self.Items[index].level:SetText( "")
					self.Items[index].icon:SetTexture( nil)
					self.Items[index].shadow:SetBackdropBorderColor( 0.2, 0.2, 0.2, 0.4)
				end
				index = index + 1
			end
		end
	end	

	for i = maxSlots, #self.Items do
		self.Items[i]:Hide()
	end

	self.bag:Show()
	
	if needReload then 
		nrSelf, nrName, nrBank = self, name, bank
		
		C_Timer.After( 0.5, function(self, ...)
			reloader = reloader + 1
			if reloader < 4 then
				--print("Reload...", reloader)
				CreateBag( nrSelf, nrName, nrBank)		
			end
		end)
	end
end

local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{ text = BAGSLOT, isTitle = true, notCheckable=true},	
}

function CreateBagIconButton( self, parent)
	local parent = parent and parent or yo_BagsFrame.bagFrame 
	local gender = { "", 'Male', 'Female'}
	--local RACE_ICON 		= '|TInterface\\CharacterFrame\\TEMPORARYPORTRAIT-%s-%s:24:24:-5:0|t'
	local RACE_PORTRAITS 	= 'Interface\\CharacterFrame\\TEMPORARYPORTRAIT-%s-%s'
	local RACE_TEMP			= 'Interface\\CharacterFrame\\TempPortrait'	

	local icon = format( RACE_PORTRAITS, gender[mySex], myRace)

	self.bagButton = CreateFrame("Button", nil, self)
	self.bagButton:SetSize(20, 20)
	self.bagButton:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
	self.bagButton:SetParent( parent)

	self.bagsChoice = self.bagButton:CreateTexture(nil, "OVERLAY")
	self.bagsChoice:SetTexture( icon)	
	self.bagsChoice:SetAllPoints()

	if parent.editBox then
		local a1, p, a2, x, y = parent.editBox:GetPoint(1)
		parent.editBox:ClearAllPoints()
		parent.editBox:SetPoint( a1, p, a2, x + 20, y)
	end

	self.bagButton:SetScript("OnEnter", function(self, ...)
		local index = 2

		if yo.Bags.showGuilBank then
			menuList[index] = { text = "|cff00ff00Guild Bank|r", notCheckable=true, func = function() CreateBag( yo_BBFrame, GetGuildInfo('player') .. '*', "gbank", 1) end}
			index = index + 1
		end

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
		reloader = 0
		EasyMenu(menuList, menuFrame, self, -20, -3, "MENU", 10)
	end)
end

function ParseItem( link, count)
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

local function SaveBags( self, bag)
	local size = GetContainerNumSlots(bag)
	yo_BB[myRealm][myName][bag] = {}	--items = {}
	--print( "Bag Size: ", bag, size)

	if size > 0 then		
		for slot = 1, size do
			local _, count, _,_,_,_, link, _, _, itemID = GetContainerItemInfo(bag, slot)
			yo_BB[myRealm][myName][bag][slot] = ParseItem( link, count)
			--items[slot] = ParseItem( link, count)

			if itemID and count then
				--print(itemID, count, link)
				yo_BBCount[myRealm][myName][itemID] = GetItemCount( itemID, true)
			else
				if itemID and yo_BBCount[myRealm][myName][itemID] then
					yo_BBCount[myRealm][myName][itemID] = nil
				end
			end
		end

		--if not yo_BB[myRealm][myName][bag] then yo_BB[myRealm][myName][bag] = {} end		
		--yo_BB[myRealm][myName][bag] = items
		yo_BB[myRealm][myName][bag][0] = size		

		--print("BAG-SIZE: ", bag, size, yo_BB[myRealm][myName][bag][0])
	else
		yo_BB[myRealm][myName][bag][0] = 0 	--nil
	end
end

local function SaveGuilds( self)
	local id = GetGuildInfo('player') .. '*'
	local guild = yo_BB[myRealm][id] or {}
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

			items[i] = ParseItem( link, count)			
		end
		items[0] = 98
	end

	yo_BB[myRealm][id] = guild	 
end

local function OnEvent( self, event, change)
	--print(event, change)
	if event == "PLAYER_ENTERING_WORLD" then
		if not yo.Bags.showAltBags then return end

		--firstRun = true 			---------!!!!!!!!!!!!!!			

		local firstRun
		if not yo_BB then yo_BB = {} end
		if not yo_BB[myRealm] then yo_BB[myRealm] = {} end
		if not yo_BB[myRealm][myName] then yo_BB[myRealm][myName] = {} firstRun = true end		

		if not yo_BBCount then yo_BBCount = {} end
		if not yo_BBCount[myRealm] then yo_BBCount[myRealm] = {} end
		if not yo_BBCount[myRealm][myName] then yo_BBCount[myRealm][myName] = {} end

		--self.Realm  	= yo_BB[myRealm]
		--self.Player 	= yo_BB[myRealm][myName]
		--self.iRealm 	= yo_BBCount[myRealm]
		--self.iPlayer 	= yo_BBCount[myRealm][myName]

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent('BAG_UPDATE')

		self:RegisterEvent('BANKFRAME_OPENED')
		self:RegisterEvent('BANKFRAME_CLOSED')

		if yo.Bags.showGuilBank then
			self:RegisterEvent('GUILD_ROSTER_UPDATE')
			self:RegisterEvent('GUILDBANKFRAME_OPENED')
			self:RegisterEvent('GUILDBANKFRAME_CLOSED')
			self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
		end

		--self:RegisterEvent("GET_ITEM_INFO_RECEIVED")

		if firstRun then
			for i, bag in pairs( bankas["bags"]) do
				SaveBags( self, bag)
			end	
		end

		CreateBagIconButton( self)

	elseif event == "BAG_UPDATE" then
		if change >= 0 and change <= 4 then
			SaveBags( self, change)	
		end		
	
	elseif event == "BANKFRAME_OPENED" then
		self.needUpBank = true

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

	elseif event == "GUILDBANKBAGSLOTS_CHANGED" then
		SaveGuilds( self)

	--elseif event == "GET_ITEM_INFO_RECEIVED" then
	--	print(event, bag)
	end
end

local bb = CreateFrame("Frame", "yo_BBFrame", UIParent)
bb:RegisterEvent("PLAYER_ENTERING_WORLD")
bb:SetScript("OnEvent", OnEvent)


--[Virag's DT]: 19 - 
--|cffa335ee|Hitem:
--45457:3828:3395:3395:0:0:0:0:80:0:0:0|h[Staff of Endless Winter]|h|r, 
--113602:0:0:0:0:0:0:0:100:0:5:1:566|h[Throat-Ripper Gauntlets]|h|r
--itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:upgradeId:instanceDifficultyID:numBonusIds:bonusId1:bonusid2:..
--158923:252:8:9:7:12:0
--Hkeystone:158923:252:8:9:7:12:0[Ключ: Святилище Штормов (8)];1
