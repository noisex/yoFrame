﻿local L, yo, n = unpack( select( 2, ...))
--if C.misc.move_blizzard ~= true then return end

----------------------------------------------------------------------------------------
--	Move some Blizzard frames
----------------------------------------------------------------------------------------
local frames = {
	"CharacterFrame", "SpellBookFrame", "TaxiFrame", "QuestFrame", "PVEFrame", "AddonList",
	"QuestLogPopupDetailFrame", "MerchantFrame", "TradeFrame", "MailFrame", "LootFrame",
	"FriendsFrame", "CinematicFrame", "TabardFrame", "PetStableFrame", "MissingLootFrame",
	"PetitionFrame", "HelpFrame", "GossipFrame", "DressUpFrame", "GuildRegistrarFrame",
	"WorldStateScoreFrame", "ChatConfigFrame", "RaidBrowserFrame", "InterfaceOptionsFrame",
	"GameMenuFrame", "VideoOptionsFrame", "GuildInviteFrame", "ItemTextFrame", "BankFrame",
	"OpenMailFrame", "StackSplitFrame", "MacOptionsFrame", "TutorialFrame", "StaticPopup1",
	"StaticPopup2", "ScrollOfResurrectionSelectionFrame", "WorldMapFrame", "SplashFrame",
}

local AddOnFrames = {
	["Blizzard_WeeklyRewards"] 	= {"WeeklyRewardsFrame"},
	["Blizzard_AchievementUI"] 	= {"AchievementFrame"},
	["Blizzard_ArchaeologyUI"] 	= {"ArchaeologyFrame"},
	["Blizzard_AuctionUI"] 		= {"AuctionFrame"},
	["Blizzard_BarberShopUI"] 	= {"BarberShopFrame"},
	["Blizzard_BindingUI"] 		= {"KeyBindingFrame"},
	["Blizzard_BlackMarketUI"] 	= {"BlackMarketFrame"},
	["Blizzard_Calendar"] 		= {"CalendarCreateEventFrame", "CalendarFrame", "CalendarViewEventFrame", "CalendarViewHolidayFrame"},
	["Blizzard_ChallengesUI"] 	= {"ChallengesLeaderboardFrame"},
	["Blizzard_Collections"] 	= {"CollectionsJournal"},
	["Blizzard_EncounterJournal"] = {"EncounterJournal"},
	["Blizzard_GarrisonUI"] 	= {"GarrisonLandingPage", "GarrisonMissionFrame", "GarrisonCapacitiveDisplayFrame", "GarrisonBuildingFrame", "GarrisonRecruiterFrame", "GarrisonRecruitSelectFrame", "GarrisonShipyardFrame", "CovenantMissionFrame"},
	["Blizzard_GMChatUI"] 		= {"GMChatStatusFrame"},
	["Blizzard_GMSurveyUI"] 	= {"GMSurveyFrame"},
	["Blizzard_GuildBankUI"] 	= {"GuildBankFrame"},
	["Blizzard_GuildControlUI"] = {"GuildControlUI"},
	["Blizzard_GuildUI"] 		= {"GuildFrame", "GuildLogFrame"},
	["Blizzard_InspectUI"] 		= {"InspectFrame"},
	["Blizzard_ItemAlterationUI"] = {"TransmogrifyFrame"},
	["Blizzard_ItemSocketingUI"]= {"ItemSocketingFrame"},
	["Blizzard_ItemUpgradeUI"] 	= {"ItemUpgradeFrame"},
	["Blizzard_LookingForGuildUI"] = {"LookingForGuildFrame"},
	["Blizzard_MacroUI"] 		= {"MacroFrame"},
	["Blizzard_QuestChoice"] 	= {"QuestChoiceFrame"},
	["Blizzard_TalentUI"] 		= {"PlayerTalentFrame"},
	["Blizzard_TradeSkillUI"] 	= {"TradeSkillFrame"},
	["Blizzard_TrainerUI"] 		= {"ClassTrainerFrame"},
	["Blizzard_VoidStorageUI"] 	= {"VoidStorageFrame"},
	["Blizzard_TalkingHeadUI"] 	= {"TalkingHeadFrame"},
	["Blizzard_Communities"] 	= {"CommunitiesFrame"},
	["Blizzard_AzeriteUI"]		= {"AzeriteEmpoweredItemUI"},
	["Blizzard_FlightMap"]		= {"FlightMapFrame"},
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, addon)

	if event == "ADDON_LOADED" then

		--print(addon)
		if not yo.Addons.MoveBlizzFrames then return end

		if AddOnFrames[addon] then
			for _, v in pairs(AddOnFrames[addon]) do
				if _G[v] then
					_G[v]:EnableMouse(true)
					_G[v]:SetMovable(true)
					_G[v]:SetClampedToScreen(true)
					_G[v]:RegisterForDrag("LeftButton")
					_G[v]:SetScript("OnDragStart", function(self)
						--if IsShiftKeyDown() then
							self:StartMoving()
						--	 end
					end)
					_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then

		if not yo.Addons.MoveBlizzFrames then return end

		for i, v in pairs(frames) do
			if _G[v] then
				_G[v]:EnableMouse(true)
				_G[v]:SetMovable(true)
				_G[v]:SetClampedToScreen(true)
				_G[v]:RegisterForDrag("LeftButton")
				_G[v]:SetScript("OnDragStart", function(self)
				--	if IsShiftKeyDown() then
						self:StartMoving()
				--	end
				end)
				_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
			end
		end
	end
end)
