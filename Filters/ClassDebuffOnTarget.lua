local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000WARNING: spell ID ["..tostring(id).."] no longer exists! (ClassDebuffOnTarger)|r")
		return "Empty"
	end
end

DebuffWhiteList = {
	-- Death Knight
	[SpellName(108194)] = true,	-- Asphyxiate
	[SpellName(47476)] = true,	-- Strangulate
	[SpellName(55078)] = true,	-- Blood Plague
	[SpellName(55095)] = true,	-- Frost Fever
	[SpellName(45524)] = true,	-- Ледяные оковы
	-- Druid
	[SpellName(33786)] = true,	-- Cyclone
	[SpellName(339)] = true,	-- Entangling Roots
	[SpellName(164812)] = true,	-- Moonfire
	[SpellName(164815)] = true,	-- Sunfire
	[SpellName(58180)] = true,	-- Infected Wounds
	[SpellName(155722)] = true,	-- Rake
	[SpellName(1079)] = true,	-- Rip
	[SpellName(106830)] = true,	-- взбучка
	-- Hunter
	[SpellName(3355)] = true,	-- Freezing Trap
	[SpellName(259491)] = true,	-- Укус змеи
	[SpellName(270339)] = true,	-- Шрапнельная бомба
	[SpellName(271049)] = true,	-- Нестабильная бомба
	[SpellName(270332)] = true,	-- Феромонная бомба
	[SpellName(217200)] = true,	-- Разрывательный выстрел
	--[SpellName(272790)] = true,	-- Разрывательный выстрел PET
	--[SpellName(131894)] = true,	-- Crows
	-- Mage
	[SpellName(118)] = true,	-- Polymorph
	[SpellName(31661)] = true,	-- Dragon's Breath
	[SpellName(122)] = true,	-- Frost Nova
	[SpellName(44457)] = true,	-- Living Bomb
	[SpellName(114923)] = true,	-- Nether Tempest
	--[SpellName(112948)] = true,	-- Frost Bomb - NOT EXISTS
	[SpellName(120)] = true,	-- Cone of Cold
	-- Monk
	[SpellName(115078)] = true,	-- Paralysis
	-- Paladin
	[SpellName(20066)] = true,	-- Repentance
	[SpellName(853)] = true,	-- Hammer of Justice
	-- Priest
	[SpellName(9484)] = true,	-- Shackle Undead
	[SpellName(8122)] = true,	-- Psychic Scream
	[SpellName(64044)] = true,	-- Psychic Horror
	[SpellName(15487)] = true,	-- Silence
	[SpellName(589)] = true,	-- Shadow Word: Pain
	[SpellName(34914)] = true,	-- Vampiric Touch
	-- Rogue
	[SpellName(6770)] = true,	-- Sap
	[SpellName(2094)] = true,	-- Blind
	[SpellName(1776)] = true,	-- Gouge
	-- Shaman
	[SpellName(51514)] = true,	-- Hex
	[SpellName(3600)] = true,	-- Earthbind
	[SpellName(196840)] = true,	-- Frost Shock
	[SpellName(188389)] = true,	-- Flame Shock
	-- Warlock
	[SpellName(710)] = true,	-- Banish
	[SpellName(6789)] = true,	-- Mortal Coil
	[SpellName(5782)] = true,	-- Fear
	[SpellName(5484)] = true,	-- Howl of Terror
	[SpellName(6358)] = true,	-- Seduction
	[SpellName(30283)] = true,	-- Shadowfury
	[SpellName(603)] = true,	-- Doom
	[SpellName(980)] = true,	-- Agony
	[SpellName(146739)] = true,	-- Corruption
	[SpellName(48181)] = true,	-- Haunt
	[SpellName(348)] = true,	-- Immolate
	[SpellName(30108)] = true,	-- Unstable Affliction
	[SpellName(63106)] = true,	-- ???????
	[SpellName(27243)] = true,	-- ?????
	[SpellName(80240)] = true,	-- хаос
	-- Warrior
	[SpellName(5246)] = true,	-- Intimidating Shout
	[SpellName(132168)] = true,	-- Shockwave
	[SpellName(115767)] = true,	-- Deep Wounds
	-- Racial
	[SpellName(25046)] = true,	-- Arcane Torrent
	[SpellName(20549)] = true,	-- War Stomp
	[SpellName(107079)] = true,	-- Quaking Palm
}

BuffWhiteList = {	-- ElvUI
	--PRIEST = {
	[SpellName(194384)] = true,		-- Atonement
	[SpellName(214206)] = true, 	-- Atonement (PvP)
	[SpellName(41635)] = true, 		-- Prayer of Mending
	[SpellName(193065)] = true, 	-- Masochism
	[SpellName(139)] = true, 		-- Renew
	[SpellName(17)] = true, 		-- Power Word: Shield
	[SpellName(47788)] = true, 		-- Guardian Spirit
	[SpellName(33206)] = true, 		-- Pain Suppression
	--},
	--DRUID = {
	[SpellName(774)] = true, 		-- Rejuvenation
	[SpellName(155777)] = true,		-- Germination
	[SpellName(8936)] = true,		-- Regrowth
	[SpellName(33763)] = true, 		-- Lifebloom
	[SpellName(48438)] = true,		-- Wild Growth
	[SpellName(207386)] = true, 	-- Spring Blossoms
	[SpellName(102351)] = true, 	-- Cenarion Ward (Initial Buff)
	[SpellName(102352)] = true, 	-- Cenarion Ward (HoT)
	[SpellName(200389)] = true, 	-- Cultivation
	[SpellName(22812)] = true, 		-- Ironskin
	[SpellName(102342)] = true, 	-- Ironskin
	[SpellName(29166)] = true, 		-- ozarenie
	--},
	--PALADIN = {
	[SpellName(53563)] = true, 		-- Beacon of Light
	[SpellName(156910)] = true, 	-- Beacon of Faith
	[SpellName(200025)] = true, 	-- Beacon of Virtue
	[SpellName(1022)] = true, 		-- Hand of Protection
	[SpellName(1044)] = true, 		-- Hand of Freedom
	[SpellName(6940)] = true,		-- Hand of Sacrifice
	[SpellName(223306)] = true, 	-- Bestow Faith
	--},
	--SHAMAN = {
	[SpellName(61295)] = true, 		-- Riptide
	[SpellName(974)] = true, 	 	-- Earth Shield
	--},
	--MONK = {
	[SpellName(119611)] = true, 	-- Renewing Mist
	[SpellName(116849)] = true, 	-- Life Cocoon
	[SpellName(124682)] = true, 	-- Enveloping Mist
	[SpellName(191840)] = true, 	-- Essence Font
	--},
	--ROGUE = {
	[SpellName(57934)] = true,		 -- Tricks of the Trade
	--},
	--WARRIOR = {
	[SpellName(114030)] = true, 	-- Vigilance
	--[SpellName(3411)] = true, 	 	-- Intervene
	--},
	--PET = {
	-- Warlock Pets
	[SpellName(193396)] = true, 	-- Demonic Empowerment
	-- Hunter Pets
	[SpellName(19615)] = true, 		-- Frenzy
	[SpellName(136)] = true, 		-- Mend Pet
	--},
	--HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	--DEMONHUNTER = {},
	--WARLOCK = {},
	--MAGE = {},
	--DEATHKNIGHT = {},
}

PlayerBuffWhiteList = {
	--Death Knight
		-- [SpellName(48707)]  = true, -- Anti-Magic Shell
		-- [SpellName(81256)]  = true, -- Dancing Rune Weapon
		-- [SpellName(55233)]  = true, -- Vampiric Blood
		-- [SpellName(193320)] = true, -- Umbilicus Eternus
		-- [SpellName(219809)] = true, -- Tombstone
		-- [SpellName(48792)]  = true, -- Icebound Fortitude
		-- [SpellName(207319)] = true, -- Corpse Shield
		-- [SpellName(194844)] = true, -- BoneStorm
		-- [SpellName(145629)] = true, -- Anti-Magic Zone
		-- [SpellName(194679)] = true, -- Rune Tap
		-- [SpellName(51271)]  = true, -- Pilar of Frost
		-- [SpellName(207256)] = true, -- Obliteration
		-- [SpellName(152279)] = true, -- Breath of Sindragosa
		-- [SpellName(233411)] = true, -- Blood for Blood
		-- [SpellName(212552)] = true, -- Wraith Walk
		-- [SpellName(215711)] = true, -- Soul Reaper
		-- [SpellName(194918)] = true, -- Blighted Rune Weapon
		-- [SpellName(195181)] = true, -- Bone Shield		
		-- [SpellName(77535)]  = true,	-- щит крови
		-- [SpellName(48265)]  = true,	-- поступь смерти
		-- [SpellName(194879)] = true,	-- ледяные когти
		-- [SpellName(59052)]  = true,	-- иней
		-- [SpellName(51124)]  = true,	-- машинка
		-- [SpellName(47568)]  = true,	-- усиленное руническое оружие
		-- [SpellName(81141)]  = true,	-- алая плеть
		-- --[SpellName(114556)] = true,	-- ад
	-- --Demon Hunter
		-- [SpellName(207811)] = true, -- Nether Bond (DH)
		-- [SpellName(207810)] = true, -- Nether Bond (Target)
		-- [SpellName(187827)] = true, -- Metamorphosis
		-- [SpellName(227225)] = true, -- Soul Barrier
		-- [SpellName(209426)] = true, -- Darkness
		-- [SpellName(196555)] = true, -- Netherwalk
		-- [SpellName(212800)] = true, -- Blur
		-- [SpellName(188499)] = true, -- Blade Dance
		-- [SpellName(203819)] = true, -- Demon Spikes
		-- --[SpellName(218256)] = true, -- Empower Wards
		-- [SpellName(206804)] = true, -- Rain from Above
		-- [SpellName(211510)] = true, -- Solitude
		-- --[SpellName(211048)] = true, -- Chaos Blades
		-- [SpellName(162264)] = true, -- Metamorphosis
		-- [SpellName(205629)] = true, -- Demonic Trample
	-- -- Druid
		-- [SpellName(102342)] = true, -- Ironbark
		-- [SpellName(61336)]  = true, -- Survival Instincts
		-- [SpellName(210655)] = true, -- Protection of Ashamane
		-- [SpellName(22812)]  = true, -- Barkskin
		-- [SpellName(200851)] = true, -- Rage of the Sleeper
		-- [SpellName(234081)] = true, -- Celestial Guardian
		-- [SpellName(192081)] = true, -- Ironfur
		-- [SpellName(29166)]  = true, -- Innervate
		-- [SpellName(194223)] = true, -- Celestial Alignment
		-- [SpellName(102560)] = true, -- Incarnation: Chosen of Elune
		-- [SpellName(102543)] = true, -- Incarnation: King of the Jungle
		-- [SpellName(102558)] = true, -- Incarnation: Guardian of Ursoc
		-- [SpellName(117679)] = true, -- Incarnation
		-- [SpellName(106951)] = true, -- Berserk
		-- [SpellName(5217)]   = true, -- Tiger's Fury
		-- [SpellName(1850)]   = true, -- Dash
		-- [SpellName(137452)] = true, -- Displacer Beast
		-- [SpellName(102416)] = true, -- Wild Charge
		-- [SpellName(77764)]  = true, -- Stampeding Roar (Cat)
		-- [SpellName(77761)]  = true, -- Stampeding Roar (Bear)		
		-- --[SpellName(203727)] = true, -- Thorns
		-- [SpellName(233756)] = true, -- Eclipse (it's this one or the other)
		-- [SpellName(234084)] = true, -- Eclipse
		-- [SpellName(22842)]  = true, -- Frenzied Regeneration
		-- [SpellName(164547)]	= true,	-- Lunar Empowerment
		-- [SpellName(164545)]	= true, -- Solar Empowerment
		-- [SpellName(5215)]	= true, -- Крадущийся зверь
		-- [SpellName(252216)]	= true, -- Рывок тигры
		-- [SpellName(202461)]	= true, -- в звездопаде
		-- [SpellName(114108)]	= true, -- душа леса
		-- [SpellName(197721)]  = true, -- рассвет
	-- --Hunter
		-- [SpellName(186265)] = true, -- Aspect of the Turtle
		-- [SpellName(53480)]  = true, -- Roar of Sacrifice
		-- [SpellName(202748)] = true, -- Survival Tactics
		-- [SpellName(62305)]  = true, -- Master's Call (it's this one or the other)
		-- [SpellName(54216)]  = true, -- Master's Call
		-- [SpellName(193526)] = true, -- Trueshot
		-- [SpellName(193530)] = true, -- Aspect of the Wild
		-- [SpellName(19574)]  = true, -- Bestial Wrath
		-- [SpellName(186289)] = true, -- Aspect of the Eagle
		-- [SpellName(186257)] = true, -- Aspect of the Cheetah
		-- [SpellName(118922)] = true, -- Posthaste
		-- [SpellName(90355)]  = true, -- Ancient Hysteria (Pet)
		-- [SpellName(160452)] = true, -- Netherwinds (Pet)
		-- [SpellName(5384)] 	= true, -- Притвориться мертвым
		-- [SpellName(781)] 	= true, -- Отрыв
		-- [SpellName(35079)] 	= true, -- Перенаправление
		-- [SpellName(272679)] = true, -- Выживает сильнейший
		-- [SpellName(199483)] = true, -- Комужлаг
	-- --Mage
		-- [SpellName(45438)]  = true, -- Ice Block
		-- [SpellName(113862)] = true, -- Greater Invisibility
		-- [SpellName(198111)] = true, -- Temporal Shield
		-- [SpellName(198065)] = true, -- Prismatic Cloak
		-- [SpellName(11426)]  = true, -- Ice Barrier
		-- [SpellName(190319)] = true, -- Combustion
		-- [SpellName(80353)]  = true, -- Time Warp
		-- [SpellName(12472)]  = true, -- Icy Veins
		-- [SpellName(12042)]  = true, -- Arcane Power
		-- [SpellName(116014)] = true, -- Rune of Power
		-- [SpellName(198144)] = true, -- Ice Form
		-- [SpellName(108839)] = true, -- Ice Floes
		-- [SpellName(205025)] = true, -- Presence of Mind
		-- [SpellName(198158)] = true, -- Mass Invisibility
		-- [SpellName(221404)] = true, -- Burning Determination
	-- --Monk
		-- [SpellName(122783)] = true, -- Diffuse Magic
		-- [SpellName(122278)] = true, -- Dampen Harm
		-- [SpellName(125174)] = true, -- Touch of Karma
		-- [SpellName(201318)] = true, -- Fortifying Elixir
		-- [SpellName(201325)] = true, -- Zen Moment
		-- [SpellName(202248)] = true, -- Guided Meditation
		-- [SpellName(120954)] = true, -- Fortifying Brew
		-- [SpellName(116849)] = true, -- Life Cocoon
		-- [SpellName(202162)] = true, -- Guard
		-- [SpellName(215479)] = true, -- Ironskin Brew
		-- [SpellName(152173)] = true, -- Serenity
		-- [SpellName(137639)] = true, -- Storm, Earth, and Fire
		-- [SpellName(216113)] = true, -- Way of the Crane
		-- [SpellName(213664)] = true, -- Nimble Brew
		-- [SpellName(201447)] = true, -- Ride the Wind
		-- [SpellName(195381)] = true, -- Healing Winds
		-- [SpellName(116841)] = true, -- Tiger's Lust
		-- [SpellName(119085)] = true, -- Chi Torpedo
		-- [SpellName(199407)] = true, -- Light on Your Feet
		-- [SpellName(209584)] = true, -- Zen Focus Tea
	-- --Paladin
		-- [SpellName(642)]    = true, -- Divine Shield
		-- [SpellName(498)]    = true, -- Divine Protection
		-- [SpellName(205191)] = true, -- Eye for an Eye
		-- [SpellName(184662)] = true, -- Shield of Vengeance
		-- [SpellName(1022)]   = true, -- Blessing of Protection
		-- [SpellName(6940)]   = true, -- Blessing of Sacrifice
		-- [SpellName(204018)] = true, -- Blessing of Spellwarding
		-- [SpellName(199507)] = true, -- Spreading The Word: Protection
		-- [SpellName(216857)] = true, -- Guarded by the Light
		-- [SpellName(228049)] = true, -- Guardian of the Forgotten Queen
		-- [SpellName(31850)]  = true, -- Ardent Defender
		-- [SpellName(86659)]  = true, -- Guardian of Ancien Kings
		-- [SpellName(212641)] = true, -- Guardian of Ancien Kings (Glyph of the Queen)
		-- [SpellName(209388)] = true, -- Bulwark of Order
		-- [SpellName(204335)] = true, -- Aegis of Light
		-- [SpellName(152262)] = true, -- Seraphim
		-- [SpellName(132403)] = true, -- Shield of the Righteous
		-- --[SpellName(31842)]  = true, -- Avenging Wrath (Holy)
		-- [SpellName(31884)]  = true, -- Avenging Wrath
		-- [SpellName(105809)] = true, -- Holy Avenger
		-- --[SpellName(224668)] = true, -- Crusade
		-- [SpellName(200652)] = true, -- Tyr's Deliverance
		-- [SpellName(216331)] = true, -- Avenging Crusader
		-- [SpellName(1044)]   = true, -- Blessing of Freedom
		-- [SpellName(210256)] = true, -- Blessing of Sanctuary
		-- [SpellName(199545)] = true, -- Steed of Glory
		-- [SpellName(210294)] = true, -- Divine Favor
		-- [SpellName(221886)] = true, -- Divine Steed
		-- [SpellName(31821)]  = true, -- Aura Mastery
		-- [SpellName(203538)] = true, -- Greater Blessing of Kings
		-- [SpellName(203539)] = true, -- Greater Blessing of Wisdom
	-- --Priest
		-- [SpellName(81782)]  = true, -- Power Word: Barrier
		-- [SpellName(47585)]  = true, -- Dispersion
		-- [SpellName(19236)]  = true, -- Desperate Prayer
		-- [SpellName(213602)] = true, -- Greater Fade
		-- [SpellName(27827)]  = true, -- Spirit of Redemption
		-- [SpellName(197268)] = true, -- Ray of Hope
		-- [SpellName(47788)]  = true, -- Guardian Spirit
		-- [SpellName(33206)]  = true, -- Pain Suppression
		-- [SpellName(200183)] = true, -- Apotheosis
		-- [SpellName(10060)]  = true, -- Power Infusion
		-- [SpellName(47536)]  = true, -- Rapture
		-- [SpellName(194249)] = true, -- Voidform
		-- [SpellName(193223)] = true, -- Surrdender to Madness
		-- [SpellName(197862)] = true, -- Archangel
		-- [SpellName(197871)] = true, -- Dark Archangel
		-- [SpellName(197874)] = true, -- Dark Archangel
		-- [SpellName(215769)] = true, -- Spirit of Redemption
		-- [SpellName(213610)] = true, -- Holy Ward
		-- [SpellName(121557)] = true, -- Angelic Feather
		-- [SpellName(214121)] = true, -- Body and Mind
		-- [SpellName(65081)]  = true, -- Body and Soul
		-- [SpellName(197767)] = true, -- Speed of the Pious
		-- [SpellName(210980)] = true, -- Focus in the Light
		-- [SpellName(221660)] = true, -- Holy Concentration
		-- [SpellName(15286)]  = true, -- Vampiric Embrace
	-- --Rogue
		-- [SpellName(5277)]   = true, -- Evasion
		-- [SpellName(31224)]  = true, -- Cloak of Shadows
		-- [SpellName(1966)]   = true, -- Feint
		-- [SpellName(199754)] = true, -- Riposte
		-- [SpellName(45182)]  = true, -- Cheating Death
		-- [SpellName(199027)] = true, -- Veil of Midnight
		-- [SpellName(121471)] = true, -- Shadow Blades
		-- [SpellName(13750)]  = true, -- Adrenaline Rush
		-- [SpellName(51690)]  = true, -- Killing Spree
		-- [SpellName(185422)] = true, -- Shadow Dance
		-- [SpellName(198368)] = true, -- Take Your Cut
		-- [SpellName(198027)] = true, -- Turn the Tables
		-- [SpellName(213985)] = true, -- Thief's Bargain
		-- [SpellName(197003)] = true, -- Maneuverability
		-- [SpellName(212198)] = true, -- Crimson Vial
		-- [SpellName(185311)] = true, -- Crimson Vial
		-- [SpellName(209754)] = true, -- Boarding Party
		-- [SpellName(36554)]  = true, -- Shadowstep
		-- [SpellName(2983)]   = true, -- Sprint
		-- [SpellName(202665)] = true, -- Curse of the Dreadblades (Self Debuff)
	-- --Shaman
		-- [SpellName(204293)] = true, -- Spirit Link
		-- [SpellName(204288)] = true, -- Earth Shield
		-- [SpellName(210918)] = true, -- Ethereal Form
		-- [SpellName(207654)] = true, -- Servant of the Queen
		-- [SpellName(108271)] = true, -- Astral Shift
		-- [SpellName(98007)]  = true, -- Spirit Link Totem
		-- [SpellName(207498)] = true, -- Ancestral Protection
		-- [SpellName(204366)] = true, -- Thundercharge
		-- [SpellName(209385)] = true, -- Windfury Totem
		-- [SpellName(208963)] = true, -- Skyfury Totem
		-- [SpellName(204945)] = true, -- Doom Winds
		-- [SpellName(205495)] = true, -- Stormkeeper
		-- [SpellName(208416)] = true, -- Sense of Urgency
		-- [SpellName(2825)]   = true, -- Bloodlust
		-- [SpellName(16166)]  = true, -- Elemental Mastery
		-- [SpellName(167204)] = true, -- Feral Spirit
		-- [SpellName(114050)] = true, -- Ascendance (Elem)
		-- [SpellName(114051)] = true, -- Ascendance (Enh)
		-- [SpellName(114052)] = true, -- Ascendance (Resto)
		-- [SpellName(79206)]  = true, -- Spiritwalker's Grace
		-- [SpellName(58875)]  = true, -- Spirit Walk
		-- [SpellName(157384)] = true, -- Eye of the Storm
		-- [SpellName(192082)] = true, -- Wind Rush
		-- [SpellName(2645)]   = true, -- Ghost Wolf
		-- [SpellName(32182)]  = true, -- Heroism
		-- [SpellName(108281)] = true, -- Ancestral Guidance
	-- --Warlock
		-- [SpellName(108416)] = true, -- Dark Pact
		-- [SpellName(104773)] = true, -- Unending Resolve
		-- [SpellName(221715)] = true, -- Essence Drain
		-- [SpellName(212295)] = true, -- Nether Ward
		-- [SpellName(212284)] = true, -- Firestone
		-- [SpellName(196098)] = true, -- Soul Harvest
		-- [SpellName(221705)] = true, -- Casting Circle
		-- [SpellName(111400)] = true, -- Burning Rush
		-- [SpellName(196674)] = true, -- Planeswalker
	-- --Warrior
		-- [SpellName(118038)] = true, -- Die by the Sword
		-- [SpellName(184364)] = true, -- Enraged Regeneration
		-- [SpellName(209484)] = true, -- Tactical Advance
		-- [SpellName(97463)]  = true, -- Commanding Shout
		-- [SpellName(213915)] = true, -- Mass Spell Reflection
		-- [SpellName(199038)] = true, -- Leave No Man Behind
		-- [SpellName(223658)] = true, -- Safeguard
		-- [SpellName(147833)] = true, -- Intervene
		-- [SpellName(198760)] = true, -- Intercept
		-- [SpellName(12975)]  = true, -- Last Stand
		-- [SpellName(871)]    = true, -- Shield Wall
		-- [SpellName(23920)]  = true, -- Spell Reflection
		-- [SpellName(216890)] = true, -- Spell Reflection (PvPT)
		-- [SpellName(227744)] = true, -- Ravager
		-- [SpellName(203524)] = true, -- Neltharion's Fury
		-- [SpellName(190456)] = true, -- Ignore Pain
		-- [SpellName(132404)] = true, -- Shield Block
		-- [SpellName(1719)]   = true, -- Battle Cry
		-- [SpellName(107574)] = true, -- Avatar
		-- [SpellName(227847)] = true, -- Bladestorm (Arm)
		-- [SpellName(46924)]  = true, -- Bladestorm (Fury)
		-- [SpellName(12292)]  = true, -- Bloodbath
		-- [SpellName(118000)] = true, -- Dragon Roar
		-- [SpellName(199261)] = true, -- Death Wish
		-- [SpellName(18499)]  = true, -- Berserker Rage
		-- [SpellName(202164)] = true, -- Bounding Stride
		-- [SpellName(215572)] = true, -- Frothing Berserker
		-- [SpellName(199203)] = true, -- Thirst for Battle
	-- --Racial
		-- [SpellName(65116)] = true, -- Stoneform
		-- [SpellName(59547)] = true, -- Gift of the Naaru
		-- [SpellName(20572)] = true, -- Blood Fury
		-- [SpellName(26297)] = true, -- Berserking
		-- [SpellName(68992)] = true, -- Darkflight
		-- [SpellName(58984)] = true, -- Shadowmeld
	--Consumables
		[SpellName(251231)] = true, -- Steelskin Potion (BfA Armor)
		[SpellName(251316)] = true, -- Potion of Bursting Blood (BfA Melee)
		[SpellName(269853)] = true, -- Potion of Rising Death (BfA Caster)
		[SpellName(279151)] = true, -- Battle Potion of Intellect (BfA Intellect)
		[SpellName(279152)] = true, -- Battle Potion of Agility (BfA Agility)
		[SpellName(279153)] = true, -- Battle Potion of Strength (BfA Strength)
		[SpellName(178207)] = true, -- Drums of Fury
		[SpellName(230935)] = true, -- Drums of the Mountain (Legion)
		[SpellName(256740)] = true, -- Drums of the Maelstrom (BfA)
		[SpellName(188023)] = true, -- Мир духов
		[SpellName(188024)] = true, -- зелье-небесной-поступи
		[SpellName(188021)] = true, -- эликсир-лавины
		[SpellName(126389)] = true, -- гоблинский-планер
		[SpellName(250878)] = true, -- зелье-легкой-поступи
		[SpellName(251143)] = true, -- зелье-морских-туманов
		[SpellName(250873)] = true, -- невидимость
		[SpellName(250956)] = true, -- зелье-сокрытия
	-- BLs
		[SpellName(31821)]  = true, -- Devotion Aura
		[SpellName(2825)]   = true, -- Bloodlust
		[SpellName(32182)]  = true, -- Heroism
		[SpellName(80353)]  = true, -- Time Warp
		[SpellName(90355)]  = true, -- Ancient Hysteria
		[SpellName(47788)]  = true, -- Guardian Spirit
		[SpellName(33206)]  = true, -- Pain Suppression
		[SpellName(116849)] = true, -- Life Cocoon
		[SpellName(22812)]  = true, -- Barkskin
	-- Азерит
		--[SpellName(273842)]  = true, -- Тайны глубин белая
		--[SpellName(273843)]  = true, -- Тайны глубин черная

		[SpellName(273406)]  = true, -- Гууун, темная сделка
		
} 