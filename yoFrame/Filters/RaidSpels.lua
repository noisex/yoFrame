local L, yo, N = unpack( select( 2, ...))

-- List of spells to display ticks
N.channelTicks = {
	-- Warlock
	[198590] = 5,	-- Drain Soul
	[755]    = 6,	-- Health Funnel
	[234153] = 6,	-- Drain Life
	-- Priest
	[64843]  = 4,	-- Divine Hymn
	[15407]  = 4,	-- Mind Flay
	[48045]  = 5,	-- Mind Sear
	[47757]  = 5,	-- Penance
	-- Mage
	[5143]   = 5,	-- Arcane Missiles
	[12051]  = 3,	-- Evocation
	[205021] = 10,	-- Ray of Frost
	-- Druid
	[740]    = 4,	-- Tranquility
}

bls = {
 	--[774] = true,     	-- "for esting..."   омоложение
    --[8936] = true,    	-- "for esting..." восстановление

    [80353] = true,     -- "Time Warp",
    [2825] = true,      -- "Bloodlust",
    [32182] = true,     -- "Heroism",
    [90355] = true,     -- "Ancient Hysteria",
    [160452] = true,    -- "Netherwinds",
    [178207] = true,    -- "Drums of Fury",
    [35475] = true,     -- "Drums of War",
    [230935] = true   	-- "Drums of the Mountain"
}

--- в найплейты для синей полосы НАДО ЧТо-то ДЕАЛТЬ С ЭТИМ!!!
N.interuptSpells = {
	-- Speck Knock
	[47528]  = 15, --Mind Freeze
    [106839] = 15, --Skull Bash
    [78675]  = 60, --Solar Beam
    [183752] = 15, --Consume Magic
    [147362] = 24, --Counter Shot
    [187707] = 15, --Muzzle
    [2139]   = 24, --Counter Spell
    [116705] = 15, --Spear Hand Strike
    [96231]  = 15, --Rebuke
    [15487]  = 45, --Silence
    [1766]   = 15, --Kick
    [57994]  = 12, --Wind Shear
    [6552]   = 15, --Pummel
    [171140] = 24, --Shadow прист
	[171138] = 24, --Shadow прист if used from pet bar
	--[119910] = 24, -- warloc new pet
	[19647]	 = 24, -- Запрет чар
}

-- в кастопалку кэдешку
raid_CD_Spells = {
	-- Testing
	--[48438] = 10,
	--[781] = 20,

	-- Speck Knock
	[47528]  = 15, --Mind Freeze
    [106839] = 15, --Skull Bash
    [78675]  = 60, --Solar Beam
    [183752] = 15, --Consume Magic
    [147362] = 24, --Counter Shot
    [187707] = 15, --Muzzle
    [2139]   = 24, --Counter Spell
    [116705] = 15, --Spear Hand Strike
    [96231]  = 15, --Rebuke
    [15487]  = 45, --Silence
    [1766]   = 15, --Kick
    [57994]  = 12, --Wind Shear
    [6552]   = 15, --Pummel
    [171140] = 24, --Shadow прист
	[171138] = 24, --Shadow прист if used from pet bar
	--[119910] = 24, -- warloc new pet
	[19647]	 = 24, -- Запрет чар

	--[46968]  = 40, 	-- shockwave
	--[30283]	 = 60, 	-- warlocl stun
	--[50613]  = 90, 	-- волшебный поток
	[20608] = 1800, 	-- реинкорнация шаман

	-- Battle rez
	--[20484] = 600,	-- Rebirth
	--[61999] = 600,	-- Raise Ally
	--[20707] = 600,	-- Soulstone
	--[126393] = 600,	-- Eternal Guardian (Quilen)
	--[159956] = 600,	-- Dust of Life (Moth)
	--[159931] = 600,	-- Gift of Chi-Ji (Crane)
	---- Heroism
	--[32182] = 300,	-- Heroism
	--[2825] = 300,		-- Bloodlust
	--[80353] = 300,	-- Time Warp
	--[90355] = 300,	-- Ancient Hysteria (Core Hound)
	--[160452] = 300,	-- Netherwinds (Nether Ray)
	---- Healing
	--[633] = 600,		-- Lay on Hands
	--[740] = 180,		-- Tranquility
	--[115310] = 180,	-- Revival
	--[64843] = 180,	-- Divine Hymn
	--[108280] = 180,	-- Healing Tide Totem
	--[15286] = 180,	-- Vampiric Embrace
	--[108281] = 120,	-- Ancestral Guidance
	--[157535] = 90,	-- Breath of the Serpent
	---- Defense
	--[62618] = 180,	-- Power Word: Barrier
	--[33206] = 180,	-- Pain Suppression
	--[47788] = 180,	-- Guardian Spirit
	--[31821] = 180,	-- Devotion Aura
	--[98008] = 180,	-- Spirit Link Totem
	--[97462] = 180,	-- Rallying Cry
	--[88611] = 180,	-- Smoke Bomb
	--[51052] = 120,	-- Anti-Magic Zone
	--[116849] = 120,	-- Life Cocoon
	--[6940] = 120,		-- Hand of Sacrifice
	--[114030] = 120,	-- Vigilance
	--[102342] = 60,	-- Ironbark
	---- Other
	--[106898] = 120,	-- Stampeding Roar
	[108119]	= 90, 	-- Хватка Кровожада


}