local addon, ns = ...

local L, yo, n = unpack( ns)
local oUF = ns.oUF

if not yo.ToolTip.enable then return end

-------------------------------------------------------------------------------------------------------
--                                   from PremadeGroupsFilter
-------------------------------------------------------------------------------------------------------

function OnLFGListSearchEntryOnEnter(self)
	local resultID = self.resultID
	local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
	local _, _, _, _, _, _, _, _, displayType = C_LFGList.GetActivityInfo(searchResultInfo.activityID)

	-- do not show members where Blizzard already does that
	if displayType == LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then return end
	if searchResultInfo.isDelisted or not GameTooltip:IsShown() then return end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(CLASS_ROLES)

	local roles = {}
	local classInfo = {}
	for i = 1, searchResultInfo.numMembers do
		local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i)
		classInfo[class] = {
			name = classLocalized,
			color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
		}
		if not roles[role] then roles[role] = {} end
		if not roles[role][class] then roles[role][class] = 0 end
		roles[role][class] = roles[role][class] + 1
	end

	for role, classes in pairs(roles) do
		GameTooltip:AddLine(_G[role]..": ")
		for class, count in pairs(classes) do
			local text = "   "
			if count > 1 then text = text .. count .. " " else text = text .. "   " end
			text = text .. "|c" .. classInfo[class].color.colorStr ..  classInfo[class].name .. "|r "
			GameTooltip:AddLine(text)
		end
	end
	GameTooltip:Show()
end

local buttonHooksInitialized = false
function OnLFGListFrameSetActivePanel(self, panel)
	if not buttonHooksInitialized and panel == self.SearchPanel then
		buttonHooksInitialized = true
		local buttons = self.SearchPanel.ScrollFrame.buttons
		for i = 1, #buttons do
			buttons[i]:HookScript("OnEnter", OnLFGListSearchEntryOnEnter)
		end
	end
end

hooksecurefunc("LFGListSearchEntry_OnEnter", OnLFGListSearchEntryOnEnter)
hooksecurefunc("LFGListFrame_SetActivePanel", OnLFGListFrameSetActivePanel)