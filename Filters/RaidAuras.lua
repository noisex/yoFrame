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
	[271571] = true, -- сделай выбор
}

RaidDebuffList = {
	-- Mythic Dungeons
	--[209858] = true, -- Necrotic
	--[226512] = true, -- Sanguine
	--[240559] = true, -- Grievous
	--[240443] = true, -- Bursting
	--[196376] = true, -- Grievous Tear
	--BFA Dungeons
	--Freehold
	--[258323] = true, -- Infected Wound
	--[257775] = true, -- Plague Step
	--[257908] = true, -- Oiled Blade
	--[257436] = true, -- Poisoning Strike
	--[274389] = true, -- Rat Traps
	--[274555] = true, -- Scabrous Bites
	--[258875] = true, -- Blackout Barrel
	--[256363] = true, -- Ripper Punch
	----Shrine of the Storm
	--[264560] = true, -- Choking Brine
	--[268233] = true, -- Electrifying Shock
	--[268322] = true, -- Touch of the Drowned
	--[268896] = true, -- Mind Rend
	--[268104] = true, -- Explosive Void
	--[267034] = true, -- Whispers of Power
	--[276268] = true, -- Heaving Blow
	--[264166] = true, -- Undertow
	--[264526] = true, -- Grasp of the Depths
	--[274633] = true, -- Sundering Blow
	--[268214] = true, -- Carving Flesh
	--[267818] = true, -- Slicing Blast
	--[268309] = true, -- Unending Darkness
	--[268317] = true, -- Rip Mind
	--[268391] = true, -- Mental Assault
	--[274720] = true, -- Abyssal Strike
	----Siege of Boralus
	--[257168] = true, -- Cursed Slash
	--[272588] = true, -- Rotting Wounds
	--[272571] = true, -- Choking Waters
	--[274991] = true, -- Putrid Waters
	--[275835] = true, -- Stinging Venom Coating
	--[273930] = true, -- Hindering Cut
	--[257292] = true, -- Heavy Slash
	--[261428] = true, -- Hangman's Noose
	--[256897] = true, -- Clamping Jaws
	--[272874] = true, -- Trample
	--[273470] = true, -- Gut Shot
	--[272834] = true, -- Viscous Slobber
	--[257169] = true, -- Terrifying Roar
	--[272713] = true, -- Crushing Slam
	---- Tol Dagor
	--[258128] = true, -- Debilitating Shout
	--[265889] = true, -- Torch Strike
	--[257791] = true, -- Howling Fear
	--[258864] = true, -- Suppression Fire
	--[257028] = true, -- Fuselighter
	--[258917] = true, -- Righteous Flames
	--[257777] = true, -- Crippling Shiv
	--[258079] = true, -- Massive Chomp
	--[258058] = true, -- Squeeze
	--[260016] = true, -- Itchy Bite
	--[257119] = true, -- Sand Trap
	--[260067] = true, -- Vicious Mauling
	--[258313] = true, -- Handcuff
	--[259711] = true, -- Lockdown
	--[256198] = true, -- Azerite Rounds: Incendiary
	--[256101] = true, -- Explosive Burst
	--[256044] = true, -- Deadeye
	--[256474] = true, -- Heartstopper Venom
	----Waycrest Manor
	--[260703] = true, -- Unstable Runic Mark
	--[263905] = true, -- Marking Cleave
	--[265880] = true, -- Dread Mark
	--[265882] = true, -- Lingering Dread
	--[264105] = true, -- Runic Mark
	--[264050] = true, -- Infected Thorn
	--[261440] = true, -- Virulent Pathogen
	--[263891] = true, -- Grasping Thorns
	--[264378] = true, -- Fragment Soul
	--[266035] = true, -- Bone Splinter
	--[266036] = true, -- Drain Essence
	--[260907] = true, -- Soul Manipulation
	--[260741] = true, -- Jagged Nettles
	--[264556] = true, -- Tearing Strike
	--[265760] = true, -- Thorned Barrage
	--[260551] = true, -- Soul Thorns
	--[263943] = true, -- Etch
	--[265881] = true, -- Decaying Touch
	--[261438] = true, -- Wasting Strike
	--[268202] = true, -- Death Lens
	---- Atal'Dazar
	--[252781] = true, -- Unstable Hex
	--[250096] = true, -- Wracking Pain
	--[250371] = true, -- Lingering Nausea
	--[253562] = true, -- Wildfire
	--[255582] = true, -- Molten Gold
	--[255041] = true, -- Terrifying Screech
	--[255371] = true, -- Terrifying Visage
	--[252687] = true, -- Venomfang Strike
	--[254959] = true, -- Soulburn
	--[255814] = true, -- Rending Maul
	--[255421] = true, -- Devour
	--[255434] = true, -- Serrated Teeth
	--[256577] = true, -- Soulfeast
	----King's Rest
	--[270492] = true, -- Hex
	--[267763] = true, -- Wretched Discharge
	--[276031] = true, -- Pit of Despair
	--[265773] = true, -- Spit Gold
	--[270920] = true, -- Seduction
	--[270865] = true, -- Hidden Blade
	--[271564] = true, -- Embalming Fluid
	--[270507] = true, -- Poison Barrage
	--[267273] = true, -- Poison Nova
	--[270003] = true, -- Suppression Slam
	--[270084] = true, -- Axe Barrage
	--[267618] = true, -- Drain Fluids
	--[267626] = true, -- Dessication
	--[270487] = true, -- Severing Blade
	--[266238] = true, -- Shattered Defenses
	--[266231] = true, -- Severing Axe
	--[266191] = true, -- Whirling Axes
	--[272388] = true, -- Shadow Barrage
	--[271640] = true, -- Dark Revelation
	--[268796] = true, -- Impaling Spear
	----Motherlode
	--[263074] = true, -- Festering Bite
	--[280605] = true, -- Brain Freeze
	--[257337] = true, -- Shocking Claw
	--[270882] = true, -- Blazing Azerite
	--[268797] = true, -- Transmute: Enemy to Goo
	--[259856] = true, -- Chemical Burn
	--[269302] = true, -- Toxic Blades
	--[280604] = true, -- Iced Spritzer
	--[257371] = true, -- Tear Gas
	--[257544] = true, -- Jagged Cut
	--[268846] = true, -- Echo Blade
	--[262794] = true, -- Energy Lash
	--[262513] = true, -- Azerite Heartseeker
	--[260829] = true, -- Homing Missle (travelling)
	--[260838] = true, -- Homing Missle (exploded)
	--[263637] = true, -- Clothesline
	----Temple of Sethraliss
	--[269686] = true, -- Plague
	--[268013] = true, -- Flame Shock
	--[268008] = true, -- Snake Charm
	--[273563] = true, -- Neurotoxin
	--[272657] = true, -- Noxious Breath
	--[267027] = true, -- Cytotoxin
	--[272699] = true, -- Venomous Spit
	--[263371] = true, -- Conduction
	--[272655] = true, -- Scouring Sand
	--[263914] = true, -- Blinding Sand
	--[263958] = true, -- A Knot of Snakes
	--[266923] = true, -- Galvanize
	--[268007] = true, -- Heart Attack
	----Underrot
	--[265468] = true, -- Withering Curse
	--[278961] = true, -- Decaying Mind
	--[259714] = true, -- Decaying Spores
	--[272180] = true, -- Death Bolt
	--[272609] = true, -- Maddening Gaze
	--[269301] = true, -- Putrid Blood
	--[265533] = true, -- Blood Maw
	--[265019] = true, -- Savage Cleave
	--[265377] = true, -- Hooked Snare
	--[265625] = true, -- Dark Omen
	--[260685] = true, -- Taint of G'huun
	--[266107] = true, -- Thirst for Blood
	--[260455] = true, -- Serrated Fangs
		
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
	[272146] = true, -- Аннигиляция
	-- G'huun
	[263436] = true, -- Imperfect Physiology
	[263227] = true, -- Putrid Blood
	[263372] = true, -- Power Matrix
	[272506] = true, -- Explosive Corruption
	[267409] = true, -- Dark Bargain
	[267430] = true, -- Torment
	[263235] = true, -- Blood Feast
	[270287] = true, -- Blighted Ground
	[270447] = true,  -- growing-corruption
}
