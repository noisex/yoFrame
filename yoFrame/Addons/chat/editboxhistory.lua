local addon, ns = ...
local L, yo, N = unpack( ns)

----------------------------------------------------------------------------------------
--	Save slash command typo
----------------------------------------------------------------------------------------

local function editboxAddHistory( self)
	local text = self.tempString

	if text and #text > 1 then
		if not yo_AllData.editHistory then yo_AllData.editHistory = {} end

		if text ~= yo_AllData.editHistory[ table.maxn( yo_AllData.editHistory)] then
			tinsert( yo_AllData.editHistory, text)
		end

		if #yo_AllData.editHistory > 25 then
			tremove( yo_AllData.editHistory, 1)
		end
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	local editbox = _G[format("ChatFrame%sEditBox", i)]

	if yo_AllData.editHistory then
		for ind = 1, #yo_AllData.editHistory do
			editbox:AddHistoryLine( yo_AllData["editHistory"][ind])
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
	if text and #text > 1 then
		self.editBox:AddHistoryLine( text)
	end
end)