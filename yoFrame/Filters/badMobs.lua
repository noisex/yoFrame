local L, yo, n = unpack( select( 2, ...))

-- https://wago.io/slraid1

-- https://wago.io/c297bUudj

-- PLATERS from https://wago.io/5gtnFIJ5x
-- https://wago.io/7ejwklo8W

-- "url": "https://wago.io/7KA6ZDIRW/8",   v1.0.7
-- https://wago.io/GwsXJnOam/9

--(.*\()(\d+)(.*)  replace reg
--[$2] = true,
n.alertCasts = {
    --[774]       = { sec = 5, text = "Омоложаюсь"},    -- омоложение тест
    [106898]    = { sec = 5, text = "Рев"},             -- тревожный рев
    --[342494]    = { sec = 4, text = "Прицеливаюсь"},    -- бахвальство
    [342466] 	= { sec = 3, text = "Прицеливаюсь"},  --бахвальство
}

n.animainfoNPC = {
    --All Wings
    [152594] = 305308, --Broker Ve'ken
    [170257] = 305308, --Broker Ve'nott
    [151353] = 295187, --Mawrat
    [154030] = 295187, --Oddly Large Mawrat
    [155798] = 297413, --Mawsworn Shackler
    --Skoldus Hall
    [152708] = 304918, --Mawsworn Seeker
    [153878] = 305269, --Mawsworn Archer
    [150959] = 305269, --Mawsworn Interceptor
    [150958] = 305266, --Mawsworn Guard
    [153874] = 305266, --Mawsworn Sentry
    --Fracture Chambers
    [155790] = 305287, --Mawsworn Acolyte
    [155830] = 305287, --Mawsworn Disciple
    [157810] = 305287, --Mawsworn Endbringer
    [155949] = 305287, --Mawsworn Soulbinder
    [155824] = 305287, --Lumbering Creation
    [155793] = 305288, --Skeletal Remains
    [157819] = 305266, --Mawsworn Shadestalker
    --Soulforges
    [157584] = 305277, --Flameforge Master
    [157583] = 305277, --Forge Keeper
    [157572] = 305277, --Mawsworn Firecaller
    [157571] = 305277, --Mawsworn Flametender
    [157634] = 305266, --Flameforge Enforcer
    --Coldheart Interstitia
    [156212] = 305274, --Coldheart Agent
    [170800] = 305274, --Coldheart Ambusher
    [156157] = 305274, --Coldheart Ascendant
    [156226] = 305274, --Coldheart Binder
    [156213] = 305274, --Coldheart Guardian
    [156159] = 305274, --Coldheart Javelineer
    [156219] = 305274, --Coldheart Scout
    --Upper Reaches
    --All NPCs in Upper Reaches are also in other wings!
    --Mort'Regar
    [152644] = 295754, --Deadsoul Drifter
    [151815] = 295754, --Deadsoul Echo
    [151816] = 295754, --Deadsoul Scavenger
    [151814] = 295754, --Deadsoul Shade
    [153879] = 295754, --Deadsoul Shadow
    [153885] = 295754, --Deadsoul Shambler
    [153882] = 295754, --Deadsoul Spirit
    [153552] = 295754, --Weeping Wraith
    --Invasions
    [154128] = 305277, --Blazing Elemental
    [154129] = 305277, --Burning Emberguard
    [155225] = 305282, --Faeleaf Grovesinger
    [155221] = 305282, --Faeleaf Tender
    [155216] = 305282, --Faeleaf Warden
    [155226] = 305282, --Verdant Keeper
    [155215] = 305282, --Faeleaf Lasher
    [155211] = 305282, --Gormling Pest
    [155219] = 305282, --Gormling Spitter
    [154011] = 305293, --Armed Prisoner
    [154015] = 305293, --Escaped Ritualist
    [154014] = 305293, --Imprisoned Cabalist
    [154020] = 305293, --Prisonbreak Cursewalker
    [154018] = 305293, --Prisonbreak Mauler
    [154016] = 305293, --Prisonbreak Soulmender
    --Debug
    [87318] = 305293, --Dungeoneer's Training Dummy
    [88314] = 305282, --Dungeoneer's Training Dummy
}

n.badMobsCasts = {
    [330614] = true,
    [330868] = true,
    [333294] = true,
    [330562] = true,
    [327413] = true,
    [317936] = true,
    [328295] = true,
    [328288] = true,
    [334329] = true,
    [322433] = true,
    [322429] = true,
    [320991] = true,
    [326836] = true,
    [335305] = true,
    [328395] = true,
    [328400] = true,
    [318949] = true,
    [336450] = true,
    [327233] = true,
    [327155] = true,
    [323496] = true,
    [327130] = true,
    [324293] = true,
    [320208] = true,
    [323496] = true,
    [320822] = true,
    [335143] = true,
    [326046] = true,
    [331718] = true,
    [321828] = true,
    [324914] = true,
    [322938] = true,
    [324776] = true,
    [321968] = true,
    [326607] = true,
    [325701] = true,
    [325701] = true,
    [326450] = true,
    [325523] = true,
    [325700] = true,
    [333227] = true,
    [327646] = true,
    [334493] = true,
    [326171] = true,
    [332612] = true,
    [332706] = true,
    [332671] = true,

    [334970] = true,
    [328740] = true,
    [334051] = true,
    [334664] = true,
    [332605] = true,
    [331379] = true,
    [333787] = true,
    [326409] = true,
    [326021] = true,
    [331743] = true,
    [322939] = true,
    [340160] = true,
    [340544] = true,
    [337235] = true,
    [337249] = true,
    [337255] = true,
    [319070] = true,
    [330403] = true,
    [328016] = true,
    [322169] = true,
    [322417] = true,
    [324086] = true,
    [334558] = true,
    [334625] = true,
    [328217] = true,
    [328137] = true,
    [328458] = true,
    [327647] = true,
    [324323] = true,
    [333477] = true,
    [333479] = true,
    [323190] = true,
    [338353] = true,
    [320574] = true,
    [328667] = true,
    [334748] = true,
    [341902] = true,
    [341969] = true,
    [333241] = true,
    [330716] = true,
    [333540] = true,
    [341977] = true,
    [342135] = true,
    [342675] = true,

    -- Торгаст interupt
    [288210] = true,
    [294362] = true,
    [304075] = true,
    [270248] = true,
    [270348] = true,
    [263085] = true,
    [294526] = true,
    [298844] = true,
    [332165] = true,
    [294517] = true,
    [296839] = true,
    [294165] = true,
    [330118] = true,
    [258935] = true,
    [277040] = true,
    [242391] = true,
    [330573] = true,
    -- Торгаст warning
    [215710] = true,
    [292903] = true,
    [270264] = true,
    [295942] = true,
    [308026] = true,
    [330471] = true,
    [294401] = true,
    [297020] = true,
    [335528] = true,
    [295985] = true,

    [346506] = true, --https://ru.wowhead.com/spell=346506
    [330822] = true, --https://ru.wowhead.com/spell=330822
    --[298844] = true, -- Ужасающий вой
    --[242391] = true, -- https://ru.wowhead.com/spell=242391
    [329608] = true, -- ужасающий-рев
    [330573] = true, -- Благословение леса
    --[329423] = true, -- внутреннее-пламя
    --[329422] = true, -- внутреннее-пламя
    --[258938] = true, -- внутреннее-пламя
}

n.badMobs = {

        --Farben--
        --    "9f1bb0"    rosarot für seasonal mob--
        --    "bb52f7"    hell purple--

        --    "278f2e"    зеленый для особых мобов с аурой
        --    "-ff9883"    T1 high HP --
        --    "00d1ff"    T2 light blue -- голубой
        --    "0016ff"    T3 deep blau --

        [177286] = "00d1ff",    --Слияние фантазмы ( Торгаст)

--         [174569] = "ff9883",
        [174568] = "00d1ff",

        -- M+ Seasonal
        [173729] = "9f1bb0", -- "Prideful"
        -- M+ Special
        [163520] = "138502",

        --Raid: Castle--
        [165067] = "278f2e", --Huntsman 1. Add--
        [169457] = "278f2e", --Huntsman 2. Add--
        [169458] = "278f2e", --Huntsman 3. Add--
--         [165066] = "ff9883", --Huntsman--
        [171557] = "0016ff", --Shade of Bargin--
--         [165764] = "ff9883", --Kael Vanquisher--
        [165762] = "0016ff", --Kael Infuser--
        [165763] = "00d1ff", --Kael Occultist--
        [165805] = "278f2e", --Shade of Kael--
        [168962] = "ff7c01", --Kael Phoenix--

        -- De Other Side--
        [168992] = "138502",
        [168992] = "00d1ff",
        [169905] = "278f2e",
        [168942] = "0016ff",
--         [168934] = "ff9883",
--         [166608] = "ff9883",
--         [167962] = "ff9883",
--         [167964] = "ff9883",
        [167963] = "00d1ff",
        [167965] = "0016ff",
--         [164556] = "ff9883",
--         [164555] = "ff9883",
        [170490] = "00d1ff",
        [170572] = "0016ff",
        [170480] = "278f2e",
        [164861] = "0016ff",
        [171341] = "00d1ff",
        [171343] = "278f2e",
--         [164450] = "ff9883",

        --Halls of Atonement--
--         [165515] = "ff9883",
        [164562] = "278f2e",
        [165414] = "0016ff",
        [165529] = "00d1ff",
--         [164557] = "ff9883",
--         [174175] = "ff9883",
        [167612] = "0016ff",
        [167611] = "278f2e",
--         [167607] = "ff9883",
--         [164185] = "ff9883",
--         [165410] = "ff9883",
        [167876] = "0016ff",
--         [164218] = "ff9883",

        -- Mist of Tirna --
        [164929] = "278f2e",
        [164921] = "0016ff",
--         [164926] = "ff9883",
        [164567] = "0016ff",
--         [164804] = "ff9883",
        [166301] = "0016ff",
        [166304] = "00d1ff",
        [166276] = "278f2e",
        [166299] = "0016ff",
--         [164501] = "ff9883",
        [165251] = "278f2e",
        [167111] = "0016ff",
        [172312] = "00d1ff",
--         [164517] = "ff9883",


        --Plaguefall--
--         [168153] = "ff9883",
        [168572] = "0016ff",
--         [164255] = "ff9883",
--         [163894] = "ff9883",
        [168627] = "00d1ff",
        [164705] = "760509",
        [164707] = "bb52f7",
        [163891] = "05764c",
--         [164967] = "ff9883",
        [163862] = "278f2e",
        [167493] = "0016ff",
--         [164266] = "ff9883",
        [164737] = "00d1ff",
        [169861] = "0016ff",

        --Sanguine Depths--
        [166396] = "278f2e",
        [171448] = "00d1ff",
--         [162047] = "ff9883",
        [162038] = "0016ff",
--         [162100] = "ff9883",
        [162039] = "0016ff",
--         [162057] = "ff9883",
        [162040] = "278f2e",
--         [171376] = "ff9883",
        [171799] = "0016ff",
        [172265] = "00d1ff",
--         [162103] = "ff9883",
--         [162102] = "ff9883",
        [162099] = "0016ff",

        --Spires--
        [168318] = "0016ff",
--         [163457] = "ff9883",
        [163459] = "00d1ff",
--         [162059] = "ff9883",
        [163520] = "278f2e",
--         [162058] = "ff9883",
        [168681] = "0016ff",
--         [162060] = "ff9883",
--         [162061] = "ff9883",

        --Necrotic Wake--
        [166302] = "0016ff",
--         [163121] = "ff9883",
        [165137] = "0016ff",
--         [162691] = "ff9883",
        [163128] = "00d1ff",
        [163618] = "278f2e",
        [163126] = "00d1ff",
        [165919] = "0016ff",
        [165222] = "00d1ff",
        [165824] = "0016ff",
--         [165197] = "ff9883",
--         [163157] = "ff9883",
--         [165911] = "ff9883",
        [165872] = "00d1ff",
        [173016] = "00d1ff",
        [163621] = "278f2e",
--         [172981] = "ff9883",
        [163620] = "278f2e",
        [162689] = "0016ff",

        --Theater of Pain--
        [174197] = "00d1ff",
        [170850] = "278f2e",
--         [164451] = "ff9883",
        [164461] = "00d1ff",
        [164463] = "00d1ff",
        [164506] = "278f2e",
--         [162329] = "ff9883",
--         [167998] = "ff9883",
        [170882] = "00d1ff",
        [160495] = "00d1ff",
        [169893] = "0016ff",
--         [162309] = "ff9883",
        [174210] = "0016ff",
--         [170690] = "ff9883",
--         [169927] = "ff9883",
--         [163086] = "ff9883",
--         [162317] = "ff9883",
--         [165946] = "ff9883",

        -- explosives
        --[165342] = {1, 0.411765, 0.705882, 1}, --"hotpink", --" Mawrat"
        --[151353] = {1, 0.411765, 0.705882, 1}, --"hotpink", --" Mawrat"
        [120651] = "ff7c01", --"Fel Explosive"
        [156212] = {1, 0.411765, 0.705882, 1},  --"hotpink", -- Торгаст - Бессердечный посланнник
        [153885] = {1, 0.411765, 0.705882, 1},  --"hotpink", -- Торгаст - Бессердечный посланнник
        [174773] = {1, 0.411765, 0.705882, 1},  --"hotpink", --" Spiteful"


}

for id, arg in pairs( n.badMobs) do
	if type(arg) ~= "table" then
		local arg1, arg2, arg3 = tonumber("0x" .. arg:sub (1, 2))/255, tonumber("0x" .. arg:sub (3, 4))/255, tonumber("0x" .. arg:sub (5, 6))/255
		n.badMobs[id] = { arg1, arg2, arg3, 1}
	end
end

