blackSpells = {
	[36900]  = true, -- Soul Split: Evil!
	[36901]  = true, -- Soul Split: Good
	[36893]  = true, -- Transporter Malfunction
	[97821]  = true, -- Void-Touched
	[36032]  = true, -- Arcane Charge
	[8733]   = true, -- Blessing of Blackfathom
	[25771]  = true, -- Forbearance (pally: divine shield, hand of protection, and lay on hands)
	[57724]  = true, -- Sated (lust debuff)
	[57723]  = true, -- Exhaustion (heroism debuff)
	[80354]  = true, -- Temporal Displacement (timewarp debuff)
	[95809]  = true, -- Insanity debuff (hunter pet heroism: ancient hysteria)
	[58539]  = true, -- Watcher's Corpse
	[26013]  = true, -- Deserter
	[71041]  = true, -- Dungeon Deserter
	[41425]  = true, -- Hypothermia
	[55711]  = true, -- Weakened Heart
	[8326]   = true, -- Ghost
	[23445]  = true, -- Evil Twin
	[24755]  = true, -- Tricked or Treated
	[25163]  = true, -- Oozeling's Disgusting Aura
	[124275] = true, -- Stagger
	[124274] = true, -- Stagger
	[124273] = true, -- Stagger
	[117870] = true, -- Touch of The Titans
	[123981] = true, -- Perdition
	[15007]  = true, -- Ress Sickness
	[113942] = true, -- Demonic: Gateway
	[89140]  = true, -- Demonic Rebirth: Cooldown
	
	--[783]	= true,  -- test
	--[188031] = true, -- test
	[206151] = true, -- Бремя претендента
	[206150] = true, -- Бремя претендента на мобах
	[61573]	 = true, -- Знамя альянса
	[226802] = true, --
	[233375] = true, -- Возрождение от Сурамары
	[264689] = true, -- Усталость от БЛа
}

whiteList = {
	-- Battle for Azeroth
	-- Uldir
	-- MOTHER
	[268277] = true, -- Purifying Flame
	[268253] = true, -- Surgical Beam
	[268095] = true, -- Cleansing Purge
	[267787] = true, -- Sundering Scalpel
	[268198] = true, -- Clinging Corruption
	[267821] = true, -- Defense Grid
	-- Vectis
	[265127] = true, -- Lingering Infection
	[265178] = true, -- Mutagenic Pathogen
	[265206] = true, -- Immunosuppression
	[265212] = true, -- Gestate
	[265129] = true, -- Omega Vector
	[267160] = true, -- Omega Vector
	[267161] = true, -- Omega Vector
	[267162] = true, -- Omega Vector
	[267163] = true, -- Omega Vector
	[267164] = true, -- Omega Vector
	-- Mythrax
	--[272146] = true, -- Annihilation
	[272536] = true, -- Imminent Ruin
	[274693] = true, -- Essence Shear
	[272407] = true, -- Oblivion Sphere
		-- Fetid Devourer
	[262313] = true, -- Malodorous Miasma
	[262292] = true, -- Rotting Regurgitation
	[262314] = true, -- Deadly Disease
		-- Taloc
	[270290] = true, -- Blood Storm
	[275270] = true, -- Fixate
	[271224] = true, -- Plasma Discharge
	[271225] = true, -- Plasma Discharge
		-- Zul
	[273365] = true, -- Dark Revelation
	[273434] = true, -- Pit of Despair
	[274195] = true, -- Corrupted Blood
	[272018] = true, -- Absorbed in Darkness
		-- Zek'voz, Herald of N'zoth
	[265237] = true, -- Shatter
	[265264] = true, -- Void Lash
	[265360] = true, -- Roiling Deceit
	[265662] = true, -- Corruptor's Pact
	[265646] = true, -- Will of the Corruptor
		-- G'huun
	[263436] = true, -- Imperfect Physiology
	[263227] = true, -- Putrid Blood
	[263372] = true, -- Power Matrix
	[272506] = true, -- Explosive Corruption
	[267409] = true, -- Dark Bargain
	[267430] = true, -- Torment
	[263235] = true, -- Blood Feast
	[270287] = true, -- Blighted Ground 
	
	-- Mythic Dungeons
	[226303] = true, -- Piercing Shards (Neltharion's Lair)
	[227742] = true, -- Garrote (Karazhan)
	[209858] = true, -- Necrotic
	[226512] = true, -- Sanguine
	[240559] = true, -- Grievous
	[240443] = true, -- Bursting
	[196376] = true, -- Grievous Tear
	[200227] = true, -- Tangled Web

	-- Legion
	-- Antorus, the Burning Throne
	-- Garothi Worldbreaker
	[244590] = true, -- Molten Hot Fel
	[244761] = true, -- Annihilation
	[246920] = true, -- Haywire Decimation
	[246369] = true, -- Searing Barrage
	[246848] = true, -- Luring Destruction
	[246220] = true, -- Fel Bombardment
	[247159] = true, -- Luring Destruction
	[244122] = true, -- Carnage
	[244410] = true, -- Decimation
	[245294] = true, -- Empowered Decimation
	[246368] = true, -- Searing Barrage
	-- Felhounds of Sargeras
	[245022] = true, -- Burning Remnant
	[251445] = true, -- Smouldering
	[251448] = true, -- Burning Maw
	[244086] = true, -- Molten Touch
	[244091] = true, -- Singed
	[244768] = true, -- Desolate Gaze
	[244767] = true, -- Desolate Path
	[244471] = true, -- Enflame Corruption
	[248815] = true, -- Enflamed
	[244517] = true, -- Lingering Flames
	[245098] = true, -- Decay
	[251447] = true, -- Corrupting Maw
	[244131] = true, -- Consuming Sphere
	[245024] = true, -- Consumed
	[244071] = true, -- Weight of Darkness
	[244578] = true, -- Siphon Corruption
	[248819] = true, -- Siphoned
	[254429] = true, -- Weight of Darkness
	[244072] = true, -- Molten Touch
	-- Antoran High Command
	[245121] = true, -- Entropic Blast
	[244748] = true, -- Shocked
	[244824] = true, -- Warp Field
	[244892] = true, -- Exploit Weakness
	[244172] = true, -- Psychic Assault
	[244388] = true, -- Psychic Scarring
	[244420] = true, -- Chaos Pulse
	[254771] = true, -- Disruption Field
	[257974] = true, -- Chaos Pulse
	[244910] = true, -- Felshield
	[244737] = true, -- Shock Grenade
		-- Portal Keeper Hasabel
	[244016] = true, -- Reality Tear
	[245157] = true, -- Everburning Light
	[245075] = true, -- Hungering Gloom
	[245240] = true, -- Oppressive Gloom
	[244709] = true, -- Fiery Detonation
	[246208] = true, -- Acidic Web
	[246075] = true, -- Catastrophic Implosion
	[244826] = true, -- Fel Miasma
	[246316] = true, -- Poison Essence
	[244849] = true, -- Caustic Slime
	[245118] = true, -- Cloying Shadows
	[245050] = true, -- Delusions
	[245040] = true, -- Corrupt
	[244607] = true, -- Flames of Xoroth
	[244915] = true, -- Leech Essence
	[244926] = true, -- Felsilk Wrap
	[244949] = true, -- Felsilk Wrap
	[244613] = true, -- Everburning Flames
		-- Eonar the Life-Binder
	[248326] = true, -- Rain of Fel
	[248861] = true, -- Spear of Doom
	[249016] = true, -- Feedback - Targeted
	[249015] = true, -- Feedback - Burning Embers
	[249014] = true, -- Feedback - Foul Steps
	[249017] = true, -- Feedback - Arcane Singularity
	[250693] = true, -- Arcane Buildup
	[250691] = true, -- Burning Embers
	[248795] = true, -- Fel Wake
	[248332] = true, -- Rain of Fel
	[250140] = true, -- Foul Steps
		-- Imonar the Soulhunter
	[248424] = true, -- Gathering Power
	[247552] = true, -- Sleep Canister
	[247565] = true, -- Slumber Gas
	[250224] = true, -- Shocked
	[248252] = true, -- Infernal Rockets
	[247687] = true, -- Sever
	[247716] = true, -- Charged Blasts
	[247367] = true, -- Shock Lance
	[250255] = true, -- Empowered Shock Lance
	[247641] = true, -- Stasis Trap
	[255029] = true, -- Sleep Canister
	[248321] = true, -- Conflagration
	[247932] = true, -- Shrapnel Blast
	[248070] = true, -- Empowered Shrapnel Blast
	[254183] = true, -- Seared Skin
		-- Kin'garoth
	[244312] = true, -- Forging Strike
	[254919] = true, -- Forging Strike
	[246840] = true, -- Ruiner
	[248061] = true, -- Purging Protocol
	[249686] = true, -- Reverberating Decimation
	[246706] = true, -- Demolish
	[246698] = true, -- Demolish
	[245919] = true, -- Meteor Swarm
	[245770] = true, -- Decimation
	
	[257978] = true, -- Decimation
		-- Varimathras
	[244042] = true, -- Marked Prey
	[243961] = true, -- Misery
	[248732] = true, -- Echoes of Doom
	[243973] = true, -- Torment of Shadows
	[244005] = true, -- Dark Fissure
	[244093] = true, -- Necrotic Embrace
	[244094] = true, -- Necrotic Embrace
		-- The Coven of Shivarra
	[244899] = true, -- Fiery Strike
	[245518] = true, -- Flashfreeze
	[245586] = true, -- Chilled Blood
	[246763] = true, -- Fury of Golganneth
	[245674] = true, -- Flames of Khaz'goroth
	[245671] = true, -- Flames of Khaz'goroth
	[245910] = true, -- Spectral Army of Norgannon
	[253520] = true, -- Fulminating Pulse
	[245634] = true, -- Whirling Saber
	[253020] = true, -- Storm of Darkness
	[245921] = true, -- Spectral Army of Norgannon
	[250757] = true, -- Cosmic Glare
		-- Aggramar
	[244291] = true, -- Foe Breaker
	[255060] = true, -- Empowered Foe Breaker
	[245995] = true, -- Scorching Blaze
	[246014] = true, -- Searing Tempest
	[244912] = true, -- Blazing Eruption
	[247135] = true, -- Scorched Earth
	[247091] = true, -- Catalyzed
	[245631] = true, -- Unchecked Flame
	[245916] = true, -- Molten Remnants
	[245990] = true, -- Taeshalach's Reach
	[254452] = true, -- Ravenous Blaze
	[244736] = true, -- Wake of Flame
	[247079] = true, -- Empowered Flame Rend
		-- Argus the Unmaker
	[251815] = true, -- Edge of Obliteration
	[248499] = true, -- Sweeping Scythe
	[250669] = true, -- Soulburst
	[251570] = true, -- Soulbomb
	[248396] = true, -- Soulblight
	[258039] = true, -- Deadly Scythe
	[252729] = true, -- Cosmic Ray
	[256899] = true, -- Soul Detonation
	[252634] = true, -- Cosmic Smash
	[252616] = true, -- Cosmic Beacon
	[255200] = true, -- Aggramar's Boon
	[255199] = true, -- Avatar of Aggramar
	[258647] = true, -- Gift of the Sea
	[253901] = true, -- Strength of the Sea
	[257299] = true, -- Ember of Rage
	[248167] = true, -- Death Fog
	[258646] = true, -- Gift of the Sky
	[253903] = true, -- Strength of the Sky
}
