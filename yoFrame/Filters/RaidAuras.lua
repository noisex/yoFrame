local L, yo, n = unpack( select( 2, ...))

n.blackSpells = {
	[36900]  = true, -- Soul Split: Evil!
	[36901]  = true, -- Soul Split: Good
	[36893]  = true, -- Transporter Malfunction
	[97821]  = true, -- Void-Touched
	[36032]  = true, -- Arcane Charge
	[8733]   = true, -- Blessing of Blackfathom
	--[25771]  = true, -- Forbearance (pally: divine shield, hand of protection, and lay on hands)
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
	--[15007]  = true, -- Ress Sickness
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
	[124013] = true, -- Убийца хозенов
	[287825] = true, -- конфета какая-то

	[338906] = true, -- цепи тюремщика
	[340870] = true, -- дамаг по танку на изобретателе
	[326758] = true, -- пауки
}

local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return id
		--return name
	else
		print("|cffff0000WARNING: spell ID ["..tostring(id).."] no longer exists! Report this to Shestak.|r")
		return "Empty"
	end
end

n.RaidDebuffList = {
	[160029] = true, -- Воскрешение

-----------------------------------------------------------------
-- Castle Nathria
-----------------------------------------------------------------
	-- Shriekwing
	[328897] = 3, -- Exsanguinated
	[330713] = 3, -- Reverberating Pain
	[342923] = 3, -- Deadly Descent
	[342863] = 3, -- Echo Screech
	-- Huntsman Altimor
	[335304] = 3, -- Sinseeker
	[334971] = 3, -- Jagged Claws
	[335111] = 3, -- Huntsman's Mark
	[334945] = 3, -- Bloody Thrash
	-- Hungering Destroyer
	[334228] = 3, -- Volatile Ejection
	[329298] = 3, -- Gluttonous Miasma
	-- Lady Inerva Darkvein
	[325936] = 3, -- Shared Cognition
	[335396] = 3, -- Hidden Desire
	[324983] = 3, -- Shared Suffering
	[324982] = 3, -- Shared Suffering (Partner)
	[332664] = 3, -- Concentrate Anima
	[325382] = 3, -- Warped Desires
	-- Sun King's Salvation
	[333002] = 3, -- Vulgar Brand
	[326078] = 3, -- Infuser's Boon
	[325251] = 3, -- Sin of Pride
	-- Artificer Xy'mox
	[327902] = 3, -- Fixate
	[326302] = 3, -- Stasis Trap
	[325236] = 3, -- Glyph of Destruction
	[327414] = 3, -- Possession
	-- The Council of Blood
	[327052] = 3, -- Drain Essence
	[346651] = 3, -- Drain Essence Mythic
	[328334] = 3, -- Tactical Advance
	[330848] = 3, -- Wrong Moves
	[331706] = 3, -- Scarlet Letter
	[331636] = 3, -- Dark Recital
	-- Sludgefist
	[335470] = 3, -- Chain Slam
	[339181] = 3, -- Chain Slam (Root)
	[331209] = 3, -- Hateful Gaze
	[335293] = 3, -- Chain Link
	[335295] = 3, -- Shattering Chain
	-- Stone Legion Generals
	[334498] = 3, -- Seismic Upheaval
	[337643] = 3, -- Unstable Footing
	[334765] = 3, -- Heart Rend
	[333377] = 3, -- Wicked Mark
	[334616] = 3, -- Petrified
	[334541] = 3, -- Curse of Petrification
	[339690] = 3, -- Crystalize
	[342655] = 3, -- Volatile Anima Infusion
	[342698] = 3, -- Volatile Anima Infection
	-- Sire Denathrius
	[326851] = 3, -- Blood Price
	[327796] = 3, -- Night Hunter
	[327992] = 3, -- Desolation
	[328276] = 3, -- March of the Penitent
	[326699] = 3, -- Burden of Sin
	[329181] = 3, -- Wracking Pain
	[335873] = 3, -- Rancor
	[329951] = 3, -- Impale

	[328897] = true,
	[333913] = true,
}
-----------------------------------------------------------------
-- Dungeons
-----------------------------------------------------------------
--local any = {
--	-- Mythic+ Affixes
--	[226489] = 5,	-- Sanguine Ichor
--	[209858] = 5,	-- Necrotic Wound
--	[240559] = 5,	-- Grievous Wound
--	[240443] = 5,	-- Burst

--	-- Halls of Atonement
--	[335338] = 3, -- Ritual of Woe
--	[326891] = 3, -- Anguish
--	[329321] = 3, -- Jagged Swipe
--	[319603] = 3, -- Curse of Stone
--	[319611] = 3, -- Turned to Stone
--	[325876] = 3, -- Curse of Obliteration
--	[326632] = 3, -- Stony Veins
--	[323650] = 3, -- Haunting Fixation
--	[326874] = 3, -- Ankle Bites
--	[340446] = 3, -- Mark of Envy
--	-- Mists of Tirna Scithe
--	[325027] = 3, -- Bramble Burst
--	[323043] = 3, -- Bloodletting
--	[322557] = 3, -- Soul Split
--	[331172] = 3, -- Mind Link
--	[322563] = 3, -- Marked Prey
--	[322487] = 3, -- Overgrowth
--	[328756] = 3, -- Repulsive Visage
--	[325021] = 3, -- Mistveil Tear
--	[321891] = 3, -- Freeze Tag Fixation
--	[325224] = 3, -- Anima Injection
--	[326092] = 3, -- Debilitating Poison
--	[325418] = 3, -- Volatile Acid
--	-- Plaguefall
--	[336258] = 3, -- Solitary Prey
--	[331818] = 3, -- Shadow Ambush
--	[329110] = 3, -- Slime Injection
--	[325552] = 3, -- Cytotoxic Slash
--	[336301] = 3, -- Web Wrap
--	[322358] = 3, -- Burning Strain
--	[322410] = 3, -- Withering Filth
--	[328180] = 3, -- Gripping Infection
--	[320542] = 3, -- Wasting Blight
--	[340355] = 3, -- Rapid Infection
--	[328395] = 3, -- Venompiercer
--	[320512] = 3, -- Corroded Claws
--	[333406] = 3, -- Assassinate
--	[332397] = 3, -- Shroudweb
--	[330069] = 3, -- Concentrated Plague
--	-- The Necrotic Wake
--	[321821] = 3, -- Disgusting Guts
--	[323365] = 3, -- Clinging Darkness
--	[338353] = 3, -- Goresplatter
--	[333485] = 3, -- Disease Cloud
--	[338357] = 3, -- Tenderize
--	[328181] = 3, -- Frigid Cold
--	[320170] = 3, -- Necrotic Bolt
--	[323464] = 3, -- Dark Ichor
--	[323198] = 3, -- Dark Exile
--	[343504] = 3, -- Dark Grasp
--	[343556] = 3, -- Morbid Fixation
--	[324381] = 3, -- Chill Scythe
--	[320573] = 3, -- Shadow Well
--	[333492] = 3, -- Necrotic Ichor
--	[334748] = 3, -- Drain FLuids
--	[333489] = 3, -- Necrotic Breath
--	[320717] = 3, -- Blood Hunger
--	-- Theater of Pain
--	[333299] = 3, -- Curse of Desolation
--	[319539] = 3, -- Soulless
--	[326892] = 3, -- Fixate
--	[321768] = 3, -- On the Hook
--	[323825] = 3, -- Grasping Rift
--	[342675] = 3, -- Bone Spear
--	[323831] = 3, -- Death Grasp
--	[330608] = 3, -- Vile Eruption
--	[330868] = 3, -- Necrotic Bolt Volley
--	[323750] = 3, -- Vile Gas
--	[323406] = 3, -- Jagged Gash
--	[330700] = 3, -- Decaying Blight
--	[319626] = 3, -- Phantasmal Parasite
--	[324449] = 3, -- Manifest Death
--	[341949] = 3, -- Withering Blight
--	-- Sanguine Depths
--	[326827] = 3, -- Dread Bindings
--	[326836] = 3, -- Curse of Suppression
--	[322554] = 3, -- Castigate
--	[321038] = 3, -- Burden Soul
--	[328593] = 3, -- Agonize
--	[325254] = 3, -- Iron Spikes
--	[335306] = 3, -- Barbed Shackles
--	[322429] = 3, -- Severing Slice
--	[334653] = 3, -- Engorge
--	-- Spires of Ascension
--	[338729] = 3, -- Charged Stomp
--	[323195] = 3, -- Purifying Blast
--	[327481] = 3, -- Dark Lance
--	[322818] = 3, -- Lost Confidence
--	[322817] = 3, -- Lingering Doubt
--	[324205] = 3, -- Blinding Flash
--	[331251] = 3, -- Deep Connection
--	[328331] = 3, -- Forced Confession
--	[341215] = 3, -- Volatile Anima
--	[323792] = 3, -- Anima Field
--	[317661] = 3, -- Insidious Venom
--	[330683] = 3, -- Raw Anima
--	[328434] = 3, -- Intimidated
--	-- De Other Side
--	[320786] = 3, -- Power Overwhelming
--	[334913] = 3, -- Master of Death
--	[325725] = 3, -- Cosmic Artifice
--	[328987] = 3, -- Zealous
--	[334496] = 3, -- Soporific Shimmerdust
--	[339978] = 3, -- Pacifying Mists
--	[323692] = 3, -- Arcane Vulnerability
--	[333250] = 3, -- Reaver
--	[330434] = 3, -- Buzz-Saw
--	[331847] = 3, -- W-00F
--	[327649] = 3, -- Crushed Soul
--	[331379] = 3, -- Lubricate
--	[332678] = 3, -- Gushing Wound
--	[322746] = 3, -- Corrupted Blood
--	[323687] = 3, -- Arcane Lightning
--	[323877] = 3, -- Echo Finger Laser X-treme
--	[334535] = 3, -- Beak Slice
--}