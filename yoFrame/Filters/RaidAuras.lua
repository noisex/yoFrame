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
	[124013] = true, -- Убийца хозенов
	[287825] = true, -- конфета какая-то

	[338906] = true, -- цепи тюремщика
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
	[SpellName(328897)] = 3, -- Exsanguinated
	[SpellName(330713)] = 3, -- Reverberating Pain
	[SpellName(342923)] = 3, -- Deadly Descent
	[SpellName(342863)] = 3, -- Echo Screech
	-- Huntsman Altimor
	[SpellName(335304)] = 3, -- Sinseeker
	[SpellName(334971)] = 3, -- Jagged Claws
	[SpellName(335111)] = 3, -- Huntsman's Mark
	[SpellName(334945)] = 3, -- Bloody Thrash
	-- Hungering Destroyer
	[SpellName(334228)] = 3, -- Volatile Ejection
	[SpellName(329298)] = 3, -- Gluttonous Miasma
	-- Lady Inerva Darkvein
	[SpellName(325936)] = 3, -- Shared Cognition
	[SpellName(335396)] = 3, -- Hidden Desire
	[SpellName(324983)] = 3, -- Shared Suffering
	[SpellName(324982)] = 3, -- Shared Suffering (Partner)
	[SpellName(332664)] = 3, -- Concentrate Anima
	[SpellName(325382)] = 3, -- Warped Desires
	-- Sun King's Salvation
	[SpellName(333002)] = 3, -- Vulgar Brand
	[SpellName(326078)] = 3, -- Infuser's Boon
	[SpellName(325251)] = 3, -- Sin of Pride
	-- Artificer Xy'mox
	[SpellName(327902)] = 3, -- Fixate
	[SpellName(326302)] = 3, -- Stasis Trap
	[SpellName(325236)] = 3, -- Glyph of Destruction
	[SpellName(327414)] = 3, -- Possession
	-- The Council of Blood
	[SpellName(327052)] = 3, -- Drain Essence
	[SpellName(346651)] = 3, -- Drain Essence Mythic
	[SpellName(328334)] = 3, -- Tactical Advance
	[SpellName(330848)] = 3, -- Wrong Moves
	[SpellName(331706)] = 3, -- Scarlet Letter
	[SpellName(331636)] = 3, -- Dark Recital
	-- Sludgefist
	[SpellName(335470)] = 3, -- Chain Slam
	[SpellName(339181)] = 3, -- Chain Slam (Root)
	[SpellName(331209)] = 3, -- Hateful Gaze
	[SpellName(335293)] = 3, -- Chain Link
	[SpellName(335295)] = 3, -- Shattering Chain
	-- Stone Legion Generals
	[SpellName(334498)] = 3, -- Seismic Upheaval
	[SpellName(337643)] = 3, -- Unstable Footing
	[SpellName(334765)] = 3, -- Heart Rend
	[SpellName(333377)] = 3, -- Wicked Mark
	[SpellName(334616)] = 3, -- Petrified
	[SpellName(334541)] = 3, -- Curse of Petrification
	[SpellName(339690)] = 3, -- Crystalize
	[SpellName(342655)] = 3, -- Volatile Anima Infusion
	[SpellName(342698)] = 3, -- Volatile Anima Infection
	-- Sire Denathrius
	[SpellName(326851)] = 3, -- Blood Price
	[SpellName(327796)] = 3, -- Night Hunter
	[SpellName(327992)] = 3, -- Desolation
	[SpellName(328276)] = 3, -- March of the Penitent
	[SpellName(326699)] = 3, -- Burden of Sin
	[SpellName(329181)] = 3, -- Wracking Pain
	[SpellName(335873)] = 3, -- Rancor
	[SpellName(329951)] = 3, -- Impale
}
-----------------------------------------------------------------
-- Dungeons
-----------------------------------------------------------------
--local any = {
--	-- Mythic+ Affixes
--	[SpellName(226489)] = 5,	-- Sanguine Ichor
--	[SpellName(209858)] = 5,	-- Necrotic Wound
--	[SpellName(240559)] = 5,	-- Grievous Wound
--	[SpellName(240443)] = 5,	-- Burst

--	-- Halls of Atonement
--	[SpellName(335338)] = 3, -- Ritual of Woe
--	[SpellName(326891)] = 3, -- Anguish
--	[SpellName(329321)] = 3, -- Jagged Swipe
--	[SpellName(319603)] = 3, -- Curse of Stone
--	[SpellName(319611)] = 3, -- Turned to Stone
--	[SpellName(325876)] = 3, -- Curse of Obliteration
--	[SpellName(326632)] = 3, -- Stony Veins
--	[SpellName(323650)] = 3, -- Haunting Fixation
--	[SpellName(326874)] = 3, -- Ankle Bites
--	[SpellName(340446)] = 3, -- Mark of Envy
--	-- Mists of Tirna Scithe
--	[SpellName(325027)] = 3, -- Bramble Burst
--	[SpellName(323043)] = 3, -- Bloodletting
--	[SpellName(322557)] = 3, -- Soul Split
--	[SpellName(331172)] = 3, -- Mind Link
--	[SpellName(322563)] = 3, -- Marked Prey
--	[SpellName(322487)] = 3, -- Overgrowth
--	[SpellName(328756)] = 3, -- Repulsive Visage
--	[SpellName(325021)] = 3, -- Mistveil Tear
--	[SpellName(321891)] = 3, -- Freeze Tag Fixation
--	[SpellName(325224)] = 3, -- Anima Injection
--	[SpellName(326092)] = 3, -- Debilitating Poison
--	[SpellName(325418)] = 3, -- Volatile Acid
--	-- Plaguefall
--	[SpellName(336258)] = 3, -- Solitary Prey
--	[SpellName(331818)] = 3, -- Shadow Ambush
--	[SpellName(329110)] = 3, -- Slime Injection
--	[SpellName(325552)] = 3, -- Cytotoxic Slash
--	[SpellName(336301)] = 3, -- Web Wrap
--	[SpellName(322358)] = 3, -- Burning Strain
--	[SpellName(322410)] = 3, -- Withering Filth
--	[SpellName(328180)] = 3, -- Gripping Infection
--	[SpellName(320542)] = 3, -- Wasting Blight
--	[SpellName(340355)] = 3, -- Rapid Infection
--	[SpellName(328395)] = 3, -- Venompiercer
--	[SpellName(320512)] = 3, -- Corroded Claws
--	[SpellName(333406)] = 3, -- Assassinate
--	[SpellName(332397)] = 3, -- Shroudweb
--	[SpellName(330069)] = 3, -- Concentrated Plague
--	-- The Necrotic Wake
--	[SpellName(321821)] = 3, -- Disgusting Guts
--	[SpellName(323365)] = 3, -- Clinging Darkness
--	[SpellName(338353)] = 3, -- Goresplatter
--	[SpellName(333485)] = 3, -- Disease Cloud
--	[SpellName(338357)] = 3, -- Tenderize
--	[SpellName(328181)] = 3, -- Frigid Cold
--	[SpellName(320170)] = 3, -- Necrotic Bolt
--	[SpellName(323464)] = 3, -- Dark Ichor
--	[SpellName(323198)] = 3, -- Dark Exile
--	[SpellName(343504)] = 3, -- Dark Grasp
--	[SpellName(343556)] = 3, -- Morbid Fixation
--	[SpellName(324381)] = 3, -- Chill Scythe
--	[SpellName(320573)] = 3, -- Shadow Well
--	[SpellName(333492)] = 3, -- Necrotic Ichor
--	[SpellName(334748)] = 3, -- Drain FLuids
--	[SpellName(333489)] = 3, -- Necrotic Breath
--	[SpellName(320717)] = 3, -- Blood Hunger
--	-- Theater of Pain
--	[SpellName(333299)] = 3, -- Curse of Desolation
--	[SpellName(319539)] = 3, -- Soulless
--	[SpellName(326892)] = 3, -- Fixate
--	[SpellName(321768)] = 3, -- On the Hook
--	[SpellName(323825)] = 3, -- Grasping Rift
--	[SpellName(342675)] = 3, -- Bone Spear
--	[SpellName(323831)] = 3, -- Death Grasp
--	[SpellName(330608)] = 3, -- Vile Eruption
--	[SpellName(330868)] = 3, -- Necrotic Bolt Volley
--	[SpellName(323750)] = 3, -- Vile Gas
--	[SpellName(323406)] = 3, -- Jagged Gash
--	[SpellName(330700)] = 3, -- Decaying Blight
--	[SpellName(319626)] = 3, -- Phantasmal Parasite
--	[SpellName(324449)] = 3, -- Manifest Death
--	[SpellName(341949)] = 3, -- Withering Blight
--	-- Sanguine Depths
--	[SpellName(326827)] = 3, -- Dread Bindings
--	[SpellName(326836)] = 3, -- Curse of Suppression
--	[SpellName(322554)] = 3, -- Castigate
--	[SpellName(321038)] = 3, -- Burden Soul
--	[SpellName(328593)] = 3, -- Agonize
--	[SpellName(325254)] = 3, -- Iron Spikes
--	[SpellName(335306)] = 3, -- Barbed Shackles
--	[SpellName(322429)] = 3, -- Severing Slice
--	[SpellName(334653)] = 3, -- Engorge
--	-- Spires of Ascension
--	[SpellName(338729)] = 3, -- Charged Stomp
--	[SpellName(323195)] = 3, -- Purifying Blast
--	[SpellName(327481)] = 3, -- Dark Lance
--	[SpellName(322818)] = 3, -- Lost Confidence
--	[SpellName(322817)] = 3, -- Lingering Doubt
--	[SpellName(324205)] = 3, -- Blinding Flash
--	[SpellName(331251)] = 3, -- Deep Connection
--	[SpellName(328331)] = 3, -- Forced Confession
--	[SpellName(341215)] = 3, -- Volatile Anima
--	[SpellName(323792)] = 3, -- Anima Field
--	[SpellName(317661)] = 3, -- Insidious Venom
--	[SpellName(330683)] = 3, -- Raw Anima
--	[SpellName(328434)] = 3, -- Intimidated
--	-- De Other Side
--	[SpellName(320786)] = 3, -- Power Overwhelming
--	[SpellName(334913)] = 3, -- Master of Death
--	[SpellName(325725)] = 3, -- Cosmic Artifice
--	[SpellName(328987)] = 3, -- Zealous
--	[SpellName(334496)] = 3, -- Soporific Shimmerdust
--	[SpellName(339978)] = 3, -- Pacifying Mists
--	[SpellName(323692)] = 3, -- Arcane Vulnerability
--	[SpellName(333250)] = 3, -- Reaver
--	[SpellName(330434)] = 3, -- Buzz-Saw
--	[SpellName(331847)] = 3, -- W-00F
--	[SpellName(327649)] = 3, -- Crushed Soul
--	[SpellName(331379)] = 3, -- Lubricate
--	[SpellName(332678)] = 3, -- Gushing Wound
--	[SpellName(322746)] = 3, -- Corrupted Blood
--	[SpellName(323687)] = 3, -- Arcane Lightning
--	[SpellName(323877)] = 3, -- Echo Finger Laser X-treme
--	[SpellName(334535)] = 3, -- Beak Slice
--}