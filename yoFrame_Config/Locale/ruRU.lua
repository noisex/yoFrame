local addonName, ns = ...
local L, yo, n = unpack( ns)

if GetLocale() ~= "ruRU" then return end

L["yoFrame"]	= "yoFrame"
L["DEFAULT"]	= "По-умолчанию: "
L["player"] 	= "Игрок"
L["target"] 	= "Таргет"

---------------------------------------------
-----		Header
---------------------------------------------
L["ResetConfig"] 	= "Вернуть как было"
L["MOVE"] 			= "Двигать"
L["DONTMOVE"] 		= "Не двигать"
L["ResetPosition"] 	= "Сброс позиции"
L["ReloadConfig"] 	= "Спаси и сохрани"
L["RESET_DESC"] 	= "Сброс конфига в дефолтое состояние. Обнуление всех данных, собранных аддоном.\n\nС перезагрузочкой... :)"
L["RESETUI_DESC"]	= "Сброс сохраеных координат файмов и возврат к изначальному положению.\n\nС перезагрузочкой... :)"
L["RELOAD_DESC"]	= "\nС перезагрузочкой... :)"

---------------------------------------------
-----		General Settings
---------------------------------------------
L["ChangeSystemFonts"] 	= "Изменить шрифты игры на нормальные"
L["scriptErrors"]		= "Показывать ошибки скриптов"
L["System"] 			= "Системные настройки"
L["PersonalConfig"] 	= "|cffff0000Персональные профили (!)|r"
L["texture"] 			= "Текстура элементов аддона"
L["FontSize"] 			= "Размер шрифтов элементов аддона"
L["sysfontsize"]		= "Размер системных шрифтов игры"
L["AutoScale"] 			= "Тип скалирования"
L["ScaleRate"] 			= "Кофицент скалирования"

--L["PERSONAL_DESC"]		= "|cffffff00(меняет настройки аддона для даннного персонажа с общих для всех на персональные)|r"
L["PERSONAL_DESC"]		= "|cffffff00(создавать отдельные профили настроек для каждого персона)|r"
L["SYSFONT_DESC"]		= "Попробовать изменить размер системного шрифта.\nНа свой страх и риск.\n\nПо-умолчанию: 10"
L["CONFIRM_PERSONAL"] 	= "Меняем тип настроек?\n(необходимо перегрузить интерфейс)"
L["SCALE_NONE"]			= "Без скалирования"
L["SCALE_AUTO"] 		= "Автоматическое"
L["SCALE_MANUAL"] 		= "Ручное управление"

---------------------------------------------
-----		Addons
---------------------------------------------
L["Addons"] 			= "Дополнения"
L["MiniMaps"] 			= "Настройки миникарты"
L["FlashIconCooldown"] 	= "Показывать икноку откатившегося спела в центра экрана"
L["RaidUtilityPanel"] 	= "Панель рэйдовых утилит"
L["ArtifactPowerbar"] 	= "Показывать азеритовую палку и палку репутации/опыта"
L["Potatos"] 			= "Потатос"
L["mythicProcents"] 	= "Показывать проценты мобов в М+ при наведении курсора"
L["MiniMap"] 			= "Редизайн миникарты"
L["MiniMapCoord"] 		= "Координаты на миникарте"
L["MMColectIcons"]		= "Собирать и убирать иконки с миникарты"
L["MiniMapSize"]		= "Размер миникарты"
L["MiniMapHideText"]	= "Прятать название локации"
L["MMCoordColor"]		= "Цвет текста координат"
L["MMCoordSize"] 		= "Размер шрифта"
L["InfoPanels"] 		= "Показывать информационные панели внизу экрана"
L["BlackPanels"] 		= "Показывать черные панели справа и слева внизу экрана"
L["ObjectiveHeight"]	= "Высота списка квестов"
L["hideObjective"]		= "Прятать окно квестов в сценариях"
L["equipNewItem"]		= "Пытаться надеть новую вещь"
L["equipNewItemLevel"]	= "но уровня не более:"
L["afk"]				= "Включить АФК анимацию"
L["MoveBlizzFrames"] 	= "Двигать стандартные Близзардовые окошки"
L["disenchanting"]		= "Распылять, просеивать и т.д. предметы, нажимая Alt + кнопка мыши"
L["stbEnable"]			= "Включить скроллинг текст боя"
L["showToday"]			= "Показывать тудейки. Ежедневные квесты, при входе."
L["addonFont"]			= "Основной шрифт аддона"
L["pixelFont"]			= "Пиксельный шрифт для работяг"
L["fontSizeAddon"]		= "Размер основного шрифта аддона"
L["minimapMove"]		= "Двигать миникарту туда-сюда"
L["covenantsCD"]		= "Бары с откатом ковенантовских абилок в группе"
L["RaidCoolDowns"]		= "Бары с откатом сбивальных абилок в рейде и группе ( 6 максимум)"
L["movePersonal"]		= "Хранить настройки расположения элементов аддона в персонально"

L["RUP_DESC"] 			= "Метки на цели, на полу, пул, готовность и прочее..."
L["POT_DESC"] 			= "Включить модуль для отслеживания использования пота в бою."
L["OBJQ_DESC"] 			= "Изменение высоты окна списка квестов. \nПо-умолчанию: 500"
L["MMHIDE_DESC"] 		= "Показывать название текущейлокации только при наведении мышкой на миникарту."
L["ObjectiveTracker"]	= "Редизайн списка квестов"

---------------------------------------------
-----		Automatic
---------------------------------------------
L["Automatic"]			= "Автоматизация"
L["AutoRepair"] 		= "Автопочинка у вендора, приоритет у гильдейского"
L["AutoSellGrayTrash"] 	= "Автопродажа мусора"
L["AutoQuesting"] 		= "Автоквестинг"
L["AutoQuest"]			= "Принимать квесты"
L["AutoQuestComplete"]	= "Сдавать квест"
L["AutoQuestSkipScene"]	= "Пропускать видюшки"
L["AutoInvite"]			= "Автоприглашение персонажа в группу по команде \'inv\\инв\' в приват"
L["AutoLeader"]			= "Отдать лидера группы или рейда по команде \'!leader\\!лидер\'"
L["AutoInvaitFromFriends"] = "Принимать приглашение в группу от друзей  и согильдийцев"
L["AutoQuestComplete2Choice"]= "Автовыбор наилучшей вещи по iLVL"
L["AutoScreenOnLvlUp"] = "Автоскриншот получения уровня"
L["AutoScreenOnAndAchiv"] = "Автоскриншот ачивки"
L["AutoQuestEnhance"]	= "Выводить больше информации о квете"
L["RepairGuild"] 		= "Жлобская починка за счет братюнь из гильдии"
L["AutoCovenantsMission"] = "Автоматически завершать миссии на столе у  ковенантов"
L["TalkingHeadHead"] 	= "Говорящая голова"
L["hideHead"]			= "Прятать Говорящую голову, которую ты уже видел"
L["hideForAll"]			= "Собирать данные персонально ( нет = общие данные на всех персонажах)"
L["hideClearAll"]		= "Почистить за всеми"
L["hideClearData"]		= "Убрать свои... данные"
L["hideCopyData"]		= "Занести свою долю в общаг"
L["hideCopyBack"]		= "Закрысить общаг в норку"
L["hideSound"]			= "Убрать так же и голос"

L["QUCOM_ENCH"]			= "Печатать цель задания, а не только его приказную часть"
L["QUACP_DESC"] 		= "Автоматически принимать квест.\n\nНажать Shift при контакте с НПС для временного отключения."
L["QUCOM_DESC"] 		= "Автоматически сдавать квест.\n\nНажать Shift при контакте с НПС для временного отключения."
L["QU2CH_DESC"] 		= "Автоматически выбирать лучшую вещь, если есть выбор, исходя из большей разницы с надетой на персонаже.\n\nКроме тринек, щитов и одноручного оружия.\n\nНажать Shift при контакте с НПС для временного отключения."
L["SALE_DESC"] 			= "За возможные последствия автор адона ответственность не несет!"

---------------------------------------------
-----		CasrBars
---------------------------------------------
L["BCBBoss"] 		= "Босс (вне боя с босом показывать касты таргета)"
L["CastBar"] 		= "Кастбары"
L["PCB"] 			= "Кастбар Игрока"
L["BCBenable"]		= "Включить Большой Кастбар"
L["PCBenable"] 		= "Включить кастбар игрока"
L["width"]			= "Ширина"
L["height"]			= "Высота"
L["offsetX"]		= "Смещение Х"
L["offsetY"]		= "Смещение Y"
L["BCDunit"]		= "Чей касбар"
L["icon"]			= "Иконка"
L["iconSize"]		= "Размер иконки"
L["iconoffsetX"]	= "Смещение иконки X"
L["iconoffsetY"]	= "Смещение иконки Y"
L["iconincombat"]	= "Показывать иконку в бою"
L["CBclasscolor"]	= "Кастбар в цвет класса"
L["treatborder"]	= "Сбивательный ободок"
L["BCB"] 			= "Большой Каст Бар"
L["castbarAlpha"]	= "Прозрачность кастбара"
L["QueueWindow"]	= "Время окна Очереди заклинаний (ms)"
L["castBoss"]		= "...но заменять на Босса"
L["bigBar"]			= "Увеличенный кастбар"

L["DESC_BCB_TREAT"] = "Бордер кастаба в цвет возможности сбить каст"
L["DESC_BCB_CC"] 	= "Кастбар в цвет класса или в цвет возможности сбития каста"
L["DESC_QUEUE"]		= "Время, которое позволяет вам поставить следующее заклинание в очередь и автоматически применить его без потери времени. Рекомендуется 200-500 ms. (Рисуется красной зоной в конце касбара Игрока)"
L["DESC_CASTBOSS"]	= "Во время боя с \"Боссами\" меняет на их касты, но по окончания боя возвращается в выбранное ранее положение ( касты Игрока или Цели). Удобно для хилов, что бы видеть касты Босса, не беря его в таргет."

---------------------------------------------
-----		Bags and Bank
---------------------------------------------
L["Bags"] 			= "Сумки и банк"
L["BAGenable"] 		= "Включить модуль"
L["buttonSize"] 	= "Размер иконки"
L["buttonSpacing"] 	= "Растояние между иконками"
L["numMaxRow"]		= "Количество строк"
L["containerWidth"] = "Ширина окна"
L["newIconAnimation"]= "Анимация на новых предметах"
L["newAnimationLoop"]= "Зацикленная анимация на новых предметах"
L["showAltBags"]	= "Показывать сумки и банк других персонажей"
L["showGuilBank"]	= "Просматривать содержимое гильдбанка"
L["countAltBags"]	= "Показывать количество предметов других персонажей во всплывающей подсказке"
L["ResetBB"] 		= "Очистить данные"
L["LeftToRight"] 	= "Сортировать и заполнять сумки снизу вверх"
L["countGuildBank"] = "так же показывать гильдбанк..."

L["RESET_BB_DESC"]	= "Удалить собранные данные о сумках, банках и гильдбанке ВСЕХ персонажей.\n\nПотребуется перезагрузочка"

---------------------------------------------
-----		UnitFrames
---------------------------------------------
L["UF"] 			= "Юнитфреймы"
L["unitFrames"]		= "Включить юнитфреймы, а зачем аддон без них?"
L["UFenable"] 		= "Включить юнитфреймы"
L["colorUF"]		= "Раскрасить как"
L["simpleUF"] 		= "Упрощенный вид"
L["showGCD"]		= "Показывать мелкую ГКДшку сверху"
L["showShards"]		= "Показывать шард-холипавер-комбо-бар на фрейме игрокан"
L["HBAR_TS"]		= "Как и рейд"
L["enableSPower"]	= "...но все же показывать поуэрбар"
L["rightAbsorb"]	= "Показать абсорбар сверху фрейма игрока"
L["hideOldAbsorb"]	= "и спрятать нормальный, который идет сверху фрейма игрока"
L["powerHeight"]	= "Высота бара энергии и шардов/рун"

---------------------------------------------
-----		RaiFrames
---------------------------------------------
L["Raid"] 			= "Рэйдфрэймы"
L["RAIDenable"] 	= "Включить рэйдфрэймы"
L["simpeRaid"]		= "Шаблон: Simple Raid"
L["width"] 			= "Ширина"
L["height"]   		= "Высота"
L["classcolor"] 	= "Раскрасить фрейм игрока в:"
L["showSolo"] 		= "Показывать без группы (соло фрейм игрока)"
L["showGroupNum"]	= "Показывать номера групп в рейде"
L["numgroups"]  	= "Количество колонок (групп)"
L["spaicing"]  		= "Растояние между фрэймами"
L["manabar"] 		= "Показывать манабар:"
L["manacolorClass"] = "Манабар в цвет класса"
L["partyScale"] 	= "Фрейм группы больше в:"
L["hpBarRevers"]	= "Здоровье рисовать в обратном порядке"
L["hpBarVertical"]	= "Здоровье рисовать вертикально."
L["groupingOrder"] 	= "Сортировать:"
L["showLFD"]		= "Показывать иконку роли игрока"
L["showHPValue"]	= "Здоровье игрока:"
L["noHealFrames"]	= "Не загружать, если есть хиловскои аддоны ( VuhDo, Grid, HealBot...)"
L["healPrediction"]	= "Показывать входящий хил и абсорб"
L["aurasRaid"]		= "Показывать иконки дебафов в рейде"
L["aurasParty"]		= "Показывать иконки дебафов в группе"
L["debuffHight"]	= "Подсвечивать дебафы на рамках игроков"
L["classBackground"]= "В темной схеме рисовать подложку в цвет класса"
L["filterHighLight"]= "Показывать только дебафы, которые могу сдиспелить"
L["raidTemplate"]	= "Шаблон рейда"

L["showMT"]			= "Show Main Tank"
L["showMTT"]		= "Show Main Tank Target"
L["showMTTT"]		= "Show Main Tank Target-Target ( о, да, детка, ты хочешь этого)"
L["showValueTreat"] = "Показывать на фрейме Main Tank значение набранного им агро"
L["heightMT"]		= "Main Tanks Height"
L["widthMT"]		= "Main Tanks Width"
L["fadeColor"]		= "Изменить яркость классового цвета"
L["darkAbsorb"]		= "Цвет абсорббара ( меньше нуля темнее, больше - светлее)"

L["MB_ALL"]		= "У всех"
L["MB_HEAL"]	= "Только у хилов"
L["MB_HIDE"]	= "Скрыть"
L["HP_HIDE"]	= "Не показывать"
L["HP_PROC"]	= "Только процент"
L["HP_HPPROC"]	= "ХП | Процент"
L["HBAR_CC"]	= "Цвет класса"
L["HBAR_CHP"]	= "Цвет здоровья (градиент)"
L["HBAR_DARK"]	= "В темненькое"
L["SRT_ID"]		= "По ID игрока"
L["SRT_GR"]		= "По группам"
L["SRT_TDH"]	= "Танк Дамагер Хил"
L["SRT_THD"]	= "Танк Хил Дамагер"
L["SRT_PIHORA"]	= "Pihora Edition"

---------------------------------------------
-----		ActionBars
---------------------------------------------
L["ActionBar"] 		= "Панель кнопок"
L["ABenable"]		= "Включить экшнбары"
L["ShowGrid"]		= "Всегда показывать кнопки"
L["HideHotKey"]		= "Не показывать хоткей"
L["CountSize"]		= "Размер шрифта стаков"
L["HideName"]		= "Не показывать макросы"
L["MicroMenu"]		= "Микроменю"
L["MicroScale"]		= "Масштаб микроменю"
L["panel3Nums"]		= "Панель:3 Кол-во кнопок"
L["panel3Cols"]		= "Панель:3 Кол-во столбцов"
L["buttonsSize"]	= "Размер иконок панелей №1-3"
L["buttonSpace"]	= "Растояние между кнопками"
L["hoverTexture"]	= "Рамка при подсветке кнопки"
L["showNewGlow"] 	= "Показывать вместо свечения готовности спела анимашку"
L["showBar3"]		= "Показать Панель:3"
L["showBar5"]		= "Показать Панель:5, кторый вертикально сбоку "
L["HotKeySize"]		= "HotKey font size"
L["HotKeyColor"]	= "HotKey font color"
L["secondHot"]		= "Показывать 2й хоткей на кнопке, если он есть"
L["HotToolTip"]		= "Показывать имя макроса и хоткей в тултипе"

---------------------------------------------
-----		ToolTip
---------------------------------------------
L["ToolTip"]	 	= "Тултипыч"
L["TTenable"]		= "Жестко разрисовать тултип и всякое с ним"
L["ladyMod"]		= "Показывать DDD модель предмета"
L["ladyModShift"]	= "...с клавишей 'Shift'"
L["showSpells"]		= "Показывать таланты игорька"
L["showSpellShift"] = "...с клавишей `Shift`"
L["showSpellsVert"] = "показывать таланты вертикально ( с названием)"
L["showBorder"]		= "Веселенькая рамочка вокруг тултипа ( на себе это малость тупит, работаем)"
L["borderClass"]	= "Классовый дефолтный цвет бордюра"
L["IDInToolTip"] 	= "ID предмета, спелла, бафа и прочего в тултипе"

---------------------------------------------
-----		NamePlates
---------------------------------------------
L["NamePlates"]	 	= "Нэймплэйты"
L["NPenable"]		= "Включить нэймплэйты"
L["iconDSize"]		= "Размер дебафов от игрока"
L["iconBSize"]		= "Размер правых иконок"
L["iconDiSize"]		= "Размер центральных иконок"
L["iconCastSize"]	= "Размер иконки кастбара"
L["showCastIcon"]	= "Показывать иконку кастбара"
L["showCastName"]	= "Показывать название каста"
L["showCastTarget"]	= "Показывать имя предполагаемого таргета каста"
L["showPercTreat"] 	= "Проценты агро циферками ( в группе):"
L["showArrows"]		= "Показывать боковые стрелочки на таргете"
L["executePhaze"]	=  "Изменять цвет на экзекут фазе"
L["executeProc"]	= "Фаза начинается с %"
L["executeColor"]	= "Цвет экзекут фазы"
L["blueDebuff"]		= "Рисовать дебафы от игрока в цвет школы абилки"
L["dissIcons"]		= "Центральные иконки:"
L["buffIcons"]		= "Правые иконки:"
L["classDispell"]	= "Диспельные, только если твой класс может их сдиспелить ( для правых)"
L["showToolTip"]	= "Показывать тултип на бафами:"
L["glowBadType"]	= "Анимация на \'плохих\' мобах"
L["tankMode"]		= "Фиксированный режим \"Танка\""
L["maxDispance"]	= "Максимальное расстояние для отображения"
L["showResourses"]	= "Реусрсы игрока ( комбопойнты, шарды, ци, ...)"
L["glowTarget"]		= "Показывать бегущую анимацию на таргете"
L["showTauntDebuff"]= "Показывать таунты других игроков если ты не танк"
L["badCasts"]		= "Выделить опасные касты мобов в М+"
L["moreDebuffIcons"]= "Показывать чуть больше своих дебафоф на мобах"

L["c0"]		= "0. Малое агро ( ДД, хил)"
L["c0t"]	= "0. Танк"
L["c1"]		= "1. Срыв агро ( моб еще на танке) > 100%"
L["c2"]		= "2. Потеря агро ( моб еще на тебе) < 100%"
L["c3"]		= "3. Танкинг ( ДД, хил)"
L["c3t"]	= "3. Танк"
L["myPet"]	= "Мой пет ( чужой пет из группы, если танк)"
L["tankOT"]	= "Агро на другом танке ( если ты танк)"
L["badGood"]= "Моб с таргетом, в бою ( нулевое агро, не опасно)"

L["DESC_iconD"] 	= "Иконки в левой части нэймтлейтов, показывающие отрицательные дебафы, которые наложил игрок или контролящие дебафы на монстре.\n\nПо-умолчанию: 20"
L["DESC_iconB"] 	= "Иконки в правой части нэймтлейтов, показывающие положительные бафы на монстре.\n\nПо-умолчанию: 20"
L["DESC_iconC"] 	= "Иконки в центральной части нэймтлейтов, показывающие положительные бафы на монстре, которые можно сдиспелить.\n\nПо-умолчанию: 30"
L["DESC_TCOL"] 		= "Цвета по типу агро:"
L["DESC_ACOL"] 		= "Дополнительные цвета:"

L["NONE"] 			= "Ничего"
L["DISS_ALL"] 		= "Диспельные все"
L["DISS_CLASS"] 	= "Диспельные по классу"
L["DISS"] 			= "Диспельные"
L["ALL_BUFF"] 		= "Все бафы"
L["ALL_EX_DIS"] 	= "Все, кроме диспельных"
L["scaledPercent"] 	= "Скалированные проценты ( 0 - 100%)"
L["rawPercent"] 	= "Полное значение процентов ( 0 - 255%)"
L["UND_CURCOR"] 	= "Под курсором"
L["IN_CONNER"] 		= "Да, в углу"

---------------------------------------------
-----		Chat
---------------------------------------------
L["Chat"] 			= "Чат"
L["EnableChat"] 	= "Изуродовать чат"
L["chatFontsize"]	= "Размер шрифта чата"
L["BarChat"]		= "Включить чатбар"
L["linkOverMouse"]	= "Ссылка на ачив под мышкой"
L["showVoice"]		= "Показывать иконки голосового чата"
L["showHistory"]	= "Показывать историю чата гильдии и группы"
L["fadingEnable"]	= "Затухание текста чата"
L["fadingTimer"]	= "... через секунд:"
L["wisperSound"]	= "Звук личного сообщения"
L["wisperInCombat"]	= "Звук в бою"
L["chatFont"]		= "Шрифт чата"
L["showHistoryAll"]	= "... и другие чаты"
L["chatBubble"]		= "Чат-бабл (сообщение в облачках):"
L["chatBubbleShadow"]= "Добавить тень у шрифта чат-бабла"
L["chatBubbleFont"]	= "Размер шрифта"
L["chatBubbleShift"]= "Уменьшить размер"

L["chBdontchange"]	= "Не изменять"
L["chBremove"]		= "Убрать рамку"
L["chBchangeS"]		= "Изменить рамку (skin)"
L["chBchangeB"]		= "Изменить рамку (border)"

---------------------------------------------
-----		CTA
---------------------------------------------
L["CTA"] 		= "СТА ( поиск сумки)"
L["CTAenable"]	= "Включить СТА ( поиск мега-сумки с барахлом) Призыв к оружию!!!"
L["nRole"]		= "Текущая ( не менять)"
L["heroic"]		= "Проверять героик"
L["lfr"]		= "Проверять ЛФР"
L["CTAtimer"]	= "Частота проверки (сек)"
L["setN"]		= "Текущая ( не менять)"
L["tank"]		= "Танк"
L["heal"]		= "Хил"
L["dd"]			= "ДД"
L["CTAnosound"]	= "Запускать без звука"
L["expand"]		= "Запускать свернутым"
L["CTAsound"]	= "Звук оповещения:"
L["hideLast"]	= "Не показывать, если убиты все босы в ЛФГ рейде"
L["readRole"]	= "Выбрать роли, которые будет отслеживать СТА:"
L["CTAlaunch"] 	= "Запустить заново"
L["lfdMode"]	= "Режим проверки 5ппл"
L["DESC_SETN"] 	= "Выбрать роль, выставляемые при подключении в очередь:"
L["DESC_NROLE"] = "Выставляется автоматически в соответсвии со значение выставленном в... ну, в том окошке, где выставляются роли... Для каждого пеоснажа своё, само собой."

---------------------------------------------
-----		Fliger
---------------------------------------------
L["fliger"] 		= "Флигер ( Filger)"
L["FLGenable"]		= "Включить филгер"
L["iconsize"] 		= "Размер иконки"
L["grow"]			= "Рост:"
L["right"]			= "Вправо"
L["left"]			= "Влево"
L["up"]				= "Вверх"
L["down"]			= "Вниз"
L["pCDTimer"]		= "Ограничение времени"
L["checkBags"]		= "Проверять кулдауны предметов с панелей команд - тупит на потах!!!"
L["gAzerit"]		= "Проки \"общих\" ковенантовых трейтов"
L["fligerBuffGlow"] = "Анимированыый бордюр"
L["fligerBuffAnim"] = "Анимация с пропадашкой"
L["fligerBuffColr"] = "Анимация цветом красным"
L["fligerBuffCount"]= "Stack/Timer"
L["fligerBuffSpell"]= "Наименование баффа/дебафа"
L["buffAnims"]		= "Анимашка бафов/дебафов"
L["fligerSpell"]	= "добавить что-то куда-то"

L["DESC_ST"]		= "Критерий анимации для бафа/дебафа: \nsN - стаки, выделить если стаков БОЛЬШЕ или равно, чем указано N. Если у бафа технически не может быть больше 1-го стака ( Порча, Буйный рост и т.д.), то надо писать ноль: s0\ntN - таймер, анимация, если осталось времени МЕНЬШЕ, чем N. \n\nНапример:\nt4\ns3t6\ns5 \n\nПишем, напротив нужного бафа в соседнем окошке.\nВозможно, но не обязательно, использовать вместе: s5t6 - мигать, если у бафа больше 4 стаков и осталось меньше 6 секунд ( и, а не или)."
L["DESC_BSPELL"]	= "Полное, правильное прописное название баффа/дебафа, который мы хотим выделить по каким-то критериям среди иконок. Разделитель: новая строка  или воспользоваться длинной пепегой внизу, но  у нее своя атмосфера, есть не все, что хочется. Это смешно, но ребут, как и скрипач - не нужен, добвляем, меняем, удаляем по ходу  дела... \n\nНапример: \nАгония, \nОмоложение\nБуйный рост"
L["DESC_FILGER"]	= "|cffff0000Страшно экспериментальное дело, на свой страх и вкус..."
L["DESC_PCD"] 		= "Меньше этого времени кулдауны не показываются"

---------------------------------------------
-----		InfoTexts
---------------------------------------------
L["infoTexts"]	= "InfoTexts"
L["ITenable"] 	= "Включить инфотексты, хрень внизу экрана, которая показывает всякое, иногда даже полезное..."
L["countLeft"]  = "Колличество элементов на левой панели"
L["countRight"] = "Колличество элементов на правой панели"
L["left1"] 		= "номер 1"
L["left2"] 		= "номер 2"
L["left3"] 		= "номер 3"
L["left4"] 		= "номер 4"
L["left5"] 		= "номер 5"
L["left6"] 		= "номер 6"

L["right1"] 	= "номер 1"
L["right2"] 	= "номер 2"
L["right3"] 	= "номер 3"
L["right4"] 	= "номер 4"
L["right5"] 	= "номер 5"
L["right6"] 	= "номер 6"

---------------------------------------------
-----		HealBotka
---------------------------------------------
L["hEnable"] 	= "Включить отображение своих хоток на рейдовых фреймах"
L["hSize"]		= "Размер иконок"
L["hTimeSec"]	= "Показывать только секунды, без десятых долек"
L["hTempW"]		= "Ширина фрейма HealBot"
L["hTempH"]		= "Высота HealBot"
L["hRedTime"] 	= "Рисовать таймер в \"красненький\" цвет, с ... секунд"
L["hDefCol"]	= "Цвет \"обычного\" таймера"
L["hRedCol"]	= "Цвет \"красного\" таймера"
L["bShiftY"]	= "Отступ сверху ( минус - вниз)"
L["bSpell"] 	= "Хотобар - полоска с хоткой"
L["bColEna"]	= "Изменить цвет хотабара"
L["funcEnable"]	= "Жахнуть похилить!"
L["funcDisable"]= "Всё, хватит, нахилился..."
L["borderC"]	= "Цвет рамки, которая при наведении курсорки"
L["borderS"]	= "Рамка в 2 пикселя (нет = 1)"
L["takeTarget"] = "Брать болезного в цель"
L["hideTimer"] 	= "Скрывать таймер больше времени:"
L["hColEnable"]	= "Свой цвет вместо иконки"
L["hScale"]		= "Масштаб"

L["DESC_HBOT_ENA"] = "|cff00ff00Включить|r бинды.\n|cff00ff00Включить|r хоты\nШаблон |cff00ff00HealBot|r\nПерезагрузка интерфейса."
L["DESC_HBOT_DIS"] = "|cffff0000Выключить|r бинды.\n|cffff0000Выключить|r хоты\nШаблон |cffff0000Normal|r\nПерезагрузка интерфейса."

L["DESC_RTEMPL"]= "Настойтельно рекомендуется выбрать шаблон рейда |cffff0000\"HealBotka\"|r. Более удобный, для отображения хоток и прочего, с минимуом лишнего."
L["DESC_KEY"]	= "Клац мышкой для смены бинды"
L["DESC_HENA"]	= "Настоятельно рекомендую предварительно установить |cffff0000`Персональные настройки`|r на первой странице."
L["DESC_TRINK"] = "Использовать триньки перед кастом"
L["DESC_STOP"]	= "Стопкаст перед кастом, ага, вот так тоже бывает..."

L["healBotka"]	= "Хилботка"
L["keneral"] 	= "Ключ вязать мышь ключдоска"
L["kEnable"]	= "Забинбить всякое, для кликания этим по рейдфреймам."
L["healset00"]	= "Маус ор клавабатон"
L["healset01"]	= "Спелл фор биндинг"
L["healtarg01"]	= "Взять в таргет"
L["healmenu01"]	= "Показать меню"
L["healres01"]	= "Авто воскресение"

L["heneral"]	= "Хотасы"
L["hSpell1"]	= "Иконка №1 ( лево-центр)"
L["hSpell2"]	= "Иконка №2 ( лево-низ)"
L["hSpell3"] 	= "Иконка №3 ( центр-низ)"
L["hSpell4"]	= "Иконка №4 ( право-низ)"
L["hSpell5"]	= "Иконка №5 ( право-центр)"
L["aenaral"]	= "Всякое с ..."
--[[L[""] 	= "
L["DESC"] 	=

]]
