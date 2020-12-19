local addon, ns = ...
local L, yo, n = unpack( ns)

----------------------------------------------------------------------------------------
--	Save slash command typo
----------------------------------------------------------------------------------------
--local n.allData = n.allData
local tinsert = tinsert
local tremove = tremove
local table_maxn = table.maxn

local function editboxAddHistory( self)
	local text = self.tempString

	if text and #text > 1 then
		if not n.allData.editHistory then n.allData.editHistory = {} end

		if text ~= n.allData.editHistory[ table_maxn( n.allData.editHistory)] then
			tinsert( n.allData.editHistory, text)
		end

		if #n.allData.editHistory > 25 then
			tremove( n.allData.editHistory, 1)
		end
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	local editbox = _G[format("ChatFrame%sEditBox", i)]

	if n.allData.editHistory then
		for ind = 1, #n.allData.editHistory do
			editbox:AddHistoryLine( n.allData["editHistory"][ind])
		end
	end

	editbox:HookScript( "OnEnterPressed", editboxAddHistory)
	editbox:HookScript( "OnTextChanged", function(self, texted)
		if texted then self.tempString = self:GetText() end
	end)
end

-- кривые команды, которые с ошибкой
hooksecurefunc("ChatFrame_DisplayHelpTextSimple", function(self, ...)
	local text = self.editBox:GetText()
	if text and #text > 2 then
		self.editBox:AddHistoryLine( text)
	end
end)