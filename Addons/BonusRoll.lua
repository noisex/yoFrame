local addon, ns = ...

local L, yo, N = unpack( ns)

	--local _, _, classID = UnitClass('player')
	--local lootSpecialization = GetLootSpecialization() or 0
	--if(lootSpecialization == 0) then
	--	lootSpecialization = (GetSpecializationInfo(GetSpecialization() or 0)) or 0
	--end

	----EJ_SetLootFilter( 0, 0)
	--local mapID = C_Map.GetBestMapForUnit("player");
	--local instanceID = mapID and EJ_GetInstanceForMap(1594) or 0;

	--EJ_SetLootFilter(classID, lootSpecialization)
	--EJ_SelectInstance(1012)
	--EJ_SetDifficulty( 23) -- 1, 2, 23 ( 8	Mythic Keystone	party	isHeroic, isChallengeMode)

	--local hasLoot = C_EncounterJournal.InstanceHasLoot( 1012)
	--local difficultyID = EJ_GetDifficulty();
	--print( mapID, instanceID, hasLoot, EJ_GetNumLoot(), difficultyID) --EJ_GetInstanceInfo())

	--for index = 1, EJ_GetNumLoot() do
	--	local itemInfo = C_EncounterJournal.GetLootInfoByIndex( index)
	--	print( itemInfo.link)
	--	--local itemID, encounterID, name, icon, slot, armorType, link = EJ_GetLootInfoByIndex(index)
 --                                                      --= EJ_GetLootInfoByIndex(index [, encounterIndex])
	--	--print( itemID, encounterID, name, icon, slot, armorType, link)
	--end

	----C_EncounterJournal.InstanceHasLoot([instanceID])