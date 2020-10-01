local L, yo = unpack( select( 2, ...))

aura_env.interval = 3   -- интервал в секундах
aura_env.endTime = 0
aura_env.cGUID = 0
npm = {}

aura_env.mPool = {8, 7, 5, 4, 3, 1, 6, 2}

-- макрос ручного запуска установки меток перед пулом
-- /run  WeakAuras.ScanEvents('TOGGLE_MARK')

aura_env.bMobs = {   --- таблеID плохих мобов (
    -- [npcID] = 1..9,  -- Данж моб коммент)

    [90241] = 1,    --- очень вэри страшный моб
    [93619] = 2,    --- ваще пизда
    [120651] = 9,     -- fel explosives

    -- Квартал Роз
    [104251] = 1,    -- КР страж портала
    [105699] = 2,    -- КР манапард
    [105715] = 1,    -- КР инквизитор
    [104247] = 1,    -- КР колдунец у центрального входа

    -- Чаша темного сердца
    [95772] = 1,      -- ЧТС левопард
    [99358] = 1,      -- ЧТС дриада
    [99359] = 1,      -- ЧТС большой кентавр
    [99365] = 1,      -- ЧТС ласт пак
    [99366] = 1,      -- ЧТС  ласт пак / сумоннер
    [100539] = 1,    -- ЧТС ласт пак

    -- Око Азшары
    [91787] = 1,     -- ОА ЧАЙКА

    -- Логово Нелтариона
    [97720] = 1 ,   -- ЛН Ползун из Рокморы
    [91008] = 2,    -- ЛН камнешвыр
    [90998] = 2,    -- ЛН рядом с большим
    [92612] = 1,    -- ЛН генератор Лавины - 1
    [113998] = 1,  -- ЛН генератор Лавины - 2
    [90997] = 1,    -- ЛН генератор Лавины - 3
    [92387] = 3,    -- ЛН барабан
    [101437] = 4,  -- ЛН жеода
    [92538] = 2,    -- ЛН личинка
    [94869] = 3,    -- ЛН личинка тоже???
    [101075] = 1,  -- ЛН прислужники червя
    [101476] = 1,  -- ЛН большая хрень на ласте

    --Чертоги доблести
    [95834] = 4,  -- ЧД мистик
    [96664] = 3,  -- ЧД рунер
    [97197] = 1,   -- ЧД пурлиффиер
    [101637] = 1, -- ЧД  аспирант
    [102019] = 1,  -- ЧД  моб от Одина

    -- Утроба Душ
    [97043] = 1,    -- УД  проклятые воды
    [97097] = 1,    -- УД  2 больших дядьки
    [97365] = 1,   -- УД тетка на днище
    [99033] = 1,   -- УД тетка вверху
    [99801] = 1,    -- УД  щупальце
    [102375] = 2  -- УД  рунекарвер
}

function( )
    local  gt = math.floor( GetTime())

    if gt >= aura_env.endTime or aura_env.endTime == 0 then
        aura_env.endTime = gt + aura_env.interval
        npm = {}
        bm = {}

        for idx, frame in pairs(C_NamePlate.GetNamePlates()) do
            unit = frame.namePlateUnitToken

            if  UnitAffectingCombat( unit) and not UnitIsUnit( unit, "boss1") or aura_env.mt == 1 then    -- plate in combat UnitIsUnit( unit, "boss1")
                --            if  UnitName( unit) then                                                                                                   -- у моба есть имя / для теста
                health = UnitHealth( unit)
                uGUID =  UnitGUID( unit)
                mobID =  select( 6,  strsplit("-", uGUID))
                mobID = tonumber( mobID)

                if aura_env.bMobs[ mobID] then
                    ibm = aura_env.bMobs[ mobID]..  uGUID
                    table.insert( bm , {ibm , unit})
                end

                npm[ health ] = {unit}
            end
        end

        if #bm >= 1 then
            table.sort( bm, function(a, b) return a[1] > b[1] end)
            for k, v in ipairs( bm) do
                if GetRaidTargetIndex( v[2]) ~=  aura_env.mPool[k] then
                    SetRaidTarget( v[2],  aura_env.mPool[k]);
                end
            end
        else
            nWin =  npm[ table.maxn ( npm)]
            if nWin then
                if not GetRaidTargetIndex( nWin[1]) then
                    SetRaidTarget( nWin[1], 8);
                end
            end
        end
    end
    aura_env.mt = 0
end



COMBAT_LOG_EVENT_UNFILTERED PLAYER_REGEN_DISABLED TOGGLE_MARK

function( event, ts, sub, ...)

    if sub == "UNIT_DIED" or event == "PLAYER_REGEN_ENABLED" then
        aura_env.endTime = 0
        --                cDead = select( 6, ...)
        --              print (  " DED :",cDead)
    end

    if  event == "TOGGLE_MARK" then
        aura_env.mt = 1
        aura_env.endTime = 0
    end
end
