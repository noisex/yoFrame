local _, ns = ...

local L = ns:NewLocale()

L.LOCALE_NAME = "ruRU"

L["yoFrame"]		= "yoFrame"
L["ChangeSystemFonts"] = "Изменить шрифты игры на нормальные"
L["scriptErrors"]	= "Показывать ошибки скриптов"
L["System"] 		= "Системные настройки"
L["PersonalConfig"] = "|cffff0000Персональные настройки (!)|r"
L["texture"] 		= "Текстура элементов аддона"
L["FontSize"] 		= "Размер шрифтов элементов аддона"
L["sysfontsize"]	= "Размер системных шрифтов игры"
L["AutoScale"] 		= "Тип скалирования"
L["ScaleRate"] 		= "Кофицент скалирования"


L["DEFAULT"]		= "По-умолчанию: "
L["PERSONAL_DESC"]	= "|cffffff00(меняет настройки аддона для даннного персонажа с общих для всех на персональные)|r"
L["SYSFONT_DESC"]	= "Попробовать изменить размер системного шрифта.\nНа свой страх и риск.\n\nПо-умолчанию: 10"
L["CONFIRM_PERSONAL"] = "Меняем тип настроек?\n(необходимо перегрузить интерфейс)"
L["SCALE_NONE"]		=	"Без скалирования"
L["SCALE_AUTO"] 	= "Автоматическое"
L["SCALE_MANUAL"] 	= "Ручное управление"
L["ResetConfig"] 	= "Вернуть как было"
L["MOVE"] 			= "Двигать"
L["DONTMOVE"] 		= "Не двигать"
L["ResetPosition"] 	= "Сброс позиции"
L["ReloadConfig"] 	= "Спаси и сохрани"
L["RESET_DESC"] 	= "Сброс конфига в дефолтое состояние.\n\nС перезагрузочкой... :)"
L["RESETUI_DESC"]	= "Сброс сохраеных координат файмов и возврат к изначальному положению.\n\nС перезагрузочкой... :)"
L["RELOAD_DESC"]	= "\nС перезагрузочкой... :)"
L["BIND_DESC"]		= "Наведите мышь над иконкой панели команд что бы назначить клавишу действия.\n \'Escape\' или правый клик мышью для очистки текущего значения"
L["BIND_SAVE"]		= "|cff00a2ffИзменения настроек клавиш были сохранены.|r"
L["BIND_ESC"]		= "|cffff9900Изменения настроек клавиш были отменены.|r"

L["Addons"] = "Дополнения"
L["MiniMaps"] = "Настройки миникарты"
L["FlashIconCooldown"] = "Показывать икноку откатившегося спела в центра экрана"
L["RaidUtilityPanel"] = "Панель рэйдовых утилит"
L["ArtifactPowerbar"] = "Показывать азеритовую палку и палку репутации/опыта"
L["AutoRepair"] = "Автопочинка у вендора, приоритет у гильдейского"
L["AutoSellGrayTrash"] = "Автопродажа мусора"
L["AutoScreenOnLvlUpAndAchiv"] = "Автоскриншот"
L["Potatos"] = "Потатос"
L["mythicProcents"] = "Показывать проценты мобов в М+ при наведении курсора"
L["MiniMap"] = "Редизайн миникарты"
L["MiniMapCoord"] = "Координаты на миникарте"
L["MMColectIcons"]= "Собирать и убирать иконки с миникарты"
L["unitFrames"]= "Включить юнитфрймы, а зачем аддон без них?"
L["MiniMapHideText"]= "Прятать название локации"
L["MMCoordColor"]= "Цвет текста координат"
L["MMCoordSize"] = "Размер шрифта"
L["InfoPanels"] = "Показывать информационные панели внизу экрана"
L["BlackPanels"] = "Показывать черные панели справа и слева внизу экрана"
L["IDInToolTip"] = "ID предмата, спелла, бафа и прочего в тултипе"
L["AutoInvaitFromFriends"] = "Принимать приглашение в группу от друзей  и согильдийцев"
L["AutoQuest"]= "Принимать квесты"
L["AutoQuestComplete"]= "Сдавать квест"
L["AutoQuestSkipScene"]= "Пропускать видюшки"
L["AutoQuestComplete2Choice"]= "Автовыбор наилучшей вещи по iLVL"
L["ObjectiveHeight"]= "Высота списка квестов"
L["hideObjective"]= "Прятать окно квестов в сценариях"
L["equipNewItem"]= "Пытаться надеть новую вещь"
L["equipNewItemLevel"]= "но уровня не более:"
L["afk"]= "Включить АФК анимацию"
L["Automatic"]= "Автоматизация"

L["RUP_DESC"] = "Метки на цели, на полу, пул, готовность и прочее..."
L["POT_DESC"] = "Включить модуль для отслеживания использования пота в бою."
L["OBJQ_DESC"] = "Изменение высоты окна списка квестов. \nПо-умолчанию: 500"
L["MMHIDE_DESC"] = "Показывать название текущейлокации только при наведении мышкой на миникарту."

L["QUACP_DESC"] = "Автоматически принимать квест.\n\nНажать Shift при контакте с НПС для временного отключения."
L["QUCOM_DESC"] = "Автоматически сдавать квест.\n\nНажать Shift при контакте с НПС для временного отключения."
L["QU2CH_DESC"] = "Автоматически выбирать лучшую вещь, если есть выбор, исходя из большей разницы с надетой на персонаже.\n\nКроме тринек, щитов и одноручного оружия.\n\nНажать Shift при контакте с НПС для временного отключения."

L["SALE_DESC"] = "За возможные последствия автор адона ответственность не несет!"
L["AutoQuesting"] = "Автоквестинг"


L["player"] = "Игрок"
L["target"] = "Таргет"
L["BCBBoss"] = "Босс (вне боя с босом показывать касты таргета)"

L["CastBar"] = "Кастбары"
L["PCB"] = "Кастбар Игрока"
L["BCBenable"]= "Включить Большой Кастбар"
L["PCBenable"] = "Включить кастбар игрока"
L["width"]= "Ширина"
L["height"]= "Высота"
L["offsetX"]= "Смещение Х"
L["offsetY"]= "Смещение Y"
L["BCDunit"]= "Чей касбар"
L["icon"]= "Иконка"
L["iconSize"]= "Размер иконки"
L["iconoffsetX"]= "Смещение иконки X"
L["iconoffsetY"]= "Смещение иконки Y"
L["iconincombat"]= "Показывать иконку в бою"
L["CBclasscolor"]= "Кастбар в цвет класса"
L["treatborder"]= "Сбивательный ободок"
L["DESC_BCB_TREAT"] = "Бордер кастаба в цвет возможности сбить каст"
L["DESC_BCB_CC"] = "Кастбар в цвет класса или в цвет возможности сбития каста"
L["BCB"] = "Большой Каст Бар"
L["castbarAlpha"]= "Прозрачность кастбара"

L["Bags"] = "Сумки и банк"
L["BAGenable"] = "Включить модуль"
L["buttonSize"] = "Размер иконки"
L["buttonSpacing"] = "Растояние между иконками"
L["numMaxRow"]= "Количество строк"
L["containerWidth"] = "Ширина окна"
L["newIconAnimation"]= "Анимация на новых предметах"

L["ActionBar"] = "Панель кнопок"
L["ABenable"]= "Вклюючить экшнбары"
L["ShowGrid"]= "Всегда показывать кнопки"
L["HideHotKey"]= "Не показывать хоткей"
L["CountSize"]= "Размер шрифта стаков"
L["HideName"]= "Не показывать макросы"
L["MicroMenu"]= "Микроменю"
L["MicroScale"]= "Масштаб микроменю"

L["Chat"] = "Чат"
L["EnableChat"] = "Изуродовать чат"
L["fontsize"] = "Размер шрифта чата"
L["BarChat"]= "Включить чатбар"
L["linkOverMouse"]= "Ссылка на ачив под мышкой"
L["showVoice"]= "Показывать иконки голосового чата"
L["showHistory"]= "Показывать историю чата гильдии и группы"
L["fadingEnable"]= "Затухание текста чата"
L["fadingTimer"]= "... через секунд:"
L["wisperSound"]= "Звук личного сообщения"
L["wisperInCombat"]= "Звук в бою"

L["CTA"] = "СТА ( поиск сумки)"
L["CTAenable"]= "Включить СТА ( поиск мега-сумки с барахлом)"
L["nRole"]= "Текущая ( не менять)"
L["heroic"]= "Проверять героик"
L["lfr"]= "Проверять ЛФР"
L["CTAtimer"]= "Частота проверки (сек)"
L["setN"]= "Текущая ( не менять)"
L["tank"]= "Танк"
L["heal"]= "Хил"
L["dd"]= "ДД"
L["CTAnosound"]= "Запускать без звука"
L["expand"]= "Запускать свернутым"
L["CTAsound"]= "Звук оповещения:"
L["hideLast"]= "Не показывать, если убит ласт босс"
L["readRole"]= "Выбрать роли, которые будет отслеживать СТА:"
L["CTAlaunch"] = "Запустить заново"
L["DESC_SETN"] = "Выбрать роль, выставляемые при подключении в очередь:"
L["DESC_NROLE"] = "Выставляется автоматически в соответсвии со значение выставленном в... ну, в том окошке, где выставляются роли... Для каждого пеоснажа своё, само собой."

L["fliger"] = "Флигер ( Filger)"
L["FLGenable"]= "Включить филгер"
L["iconsize"] = "Размер иконки"
L["grow"]= "Рост:"
L["right"]= "Вправо"
L["left"]= "Влево"
L["up"]= "Вверх"
L["down"]= "Вниз"
L["pCDTimer"]= "Ограничение времени"
L["checkBags"]= "Проверять кулдауны предметов с панелей команд - тупит на потах!!!"
L["gAzerit"]= "Проки \"общих\" азеритовых трейтов"
L["DESC_FILGER"] = "|cffff0000Страшно экспериментальное дело, на свой страх и вкус..."
L["DESC_PCD"] = "Меньше этого времени кулдауны не показываются"

L["Raid"] = "Рэйдфрэймы"
L["RAIDenable"] = "Включить рэйдфрэймы"
L["width"] = "Ширина"
L["height"]   = "Высота"
L["classcolor"] = "Раскрасить фрейм игрока в:"
L["showSolo"] = "Показывать без группы (соло фрейм игрока)"
L["showGroupNum"]= "Показывать номера групп в рейде"
L["numgroups"]  = "Количество колонок (групп)"
L["spaicing"]  = "Растояние между фрэймами"
L["manabar"] = "Показывать манабар:"
L["manacolorClass"] = "Манабар в цвет класса"
L["partyScale"] = "Фрейм группы больше в:"
L["hpBarRevers"]= "Здоровье рисовать в обратном порядке"
L["hpBarVertical"]= "Здоровье рисовать вертикально."
L["groupingOrder"] = "Сортировать:"
L["showLFD"]= "Показывать иконку роли игрока"
L["showHPValue"]=  "Здоровье игрока:"
L["noHealFrames"]= "Не загружать, если есть хиловскои аддоны ( VuhDo, Grid, HealBot...)"
L["healPrediction"]= "Показывать входящий хил и абсорб"
L["aurasRaid"]= "Показывать иконки дебафов в рейде"
L["aurasParty"]= "Показывать иконки дебафов в группе"
L["debuffHight"]= "Подсвечивать дебафы на рамках игроков"
L["classBackground"]= "В темной схеме рисовать подложку в цвет класса"

L["MB_ALL"]= "У всех"
L["MB_HEAL"]= "Только у хилов"
L["MB_HIDE"]= "Скрыть"
L["HP_HIDE"]= "Не показывать"
L["HP_PROC"]= "Только процент"
L["HP_HPPROC"]= "ХП | Процент"
L["HBAR_CC"]= "Цвет класса"
L["HBAR_CHP"]= "Цвет здоровья (градиент)"
L["HBAR_DARK"]= "В темненькое"
L["SRT_ID"]= "По ID игрока"
L["SRT_GR"]= "По группам"
L["SRT_TDH"]= "Танк Дамагер Хил"
L["SRT_THD"]= "Танк Хил Дамагер"

L["NamePlates"] = "Нэймплэйты"
L["NPenable"]= "Включить нэймплэйты"
L["iconDSize"]= "Размер дебафов от игрока"
L["iconBSize"]= "Размер правых иконок"
L["iconDiSize"]= "Размер центральных иконок"
L["iconCastSize"]= "Размер иконки кастбара"
L["showCastIcon"]= "Показывать иконку кастбара"
L["showCastName"]= "Показывать название каста"
L["showCastTarget"]= "Показывать имя предполагаемого таргета каста"
L["showPercTreat"] = "Проценты агро циферками ( в группе):"
L["showArrows"]= "Показывать боковые стрелочки на таргете"
L["executePhaze"]=  "Изменять цвет на экзекут фазе"
L["executeProc"]= "Фаза начинается с %"
L["executeColor"]= "Цвет экзекут фазы"
L["blueDebuff"]= "Рисовать дебафы от игрока в цвет школы абилки"
L["dissIcons"]= "Центральные иконки:"
L["buffIcons"]= "Правые иконки:"
L["classDispell"]= "Диспельные, толко если твой класс может их сдиспелить ( для правых)"
L["showToolTip"]= "Показывать тултип на бафами:"
L["c0"]= "0. Малое агро ( ДД, хил)"
L["c0t"]= "0. Танк"
L["c1"]= "1. Срыв агро ( моб еще на танке) > 100%"
L["c2"]= "2. Потеря агро ( моб еще на тебе) < 100%"
L["c3"]= "3. Танкинг ( ДД, хил)"
L["c3t"]= "3. Танк"
L["myPet"]= "Мой пет ( чужой пет из группы, если танк)"
L["tankOT"]= "Агро на другом танке ( если ты танк)"
L["badGood"]= "Моб с таргетом, в бою ( нулевое агро, не опасно)"

L["DESC_iconD"] = "Иконки в левой части нэймтлейтов, показывающие отрицательные дебафы, которые наложил игрок или контролящие дебафы на монстре.\n\nПо-умолчанию: 20"
L["DESC_iconB"] = "Иконки в правой части нэймтлейтов, показывающие положительные бафы на монстре.\n\nПо-умолчанию: 20"
L["DESC_iconC"] = "Иконки в центральной части нэймтлейтов, показывающие положительные бафы на монстре, которые можно сдиспелить.\n\nПо-умолчанию: 30"
L["DESC_TCOL"] = "Цвета по типу агро:"
L["DESC_ACOL"] = "Дополнительные цвета:"

L["NONE"] 	= "Ничего"
L["DISS_ALL"] 	= "Диспельные все"
L["DISS_CLASS"] = "Диспельные по классу"
L["DISS"] 	= "Диспельные"
L["ALL_BUFF"] 	= "Все бафы"
L["ALL_EX_DIS"] = "Все, кроме диспельных"
L["scaledPercent"] 	= "Скалированные проценты ( 0 - 100%)"
L["rawPercent"] 	= "Полное значение процентов ( 0 - 255%)"
L["UND_CURCOR"] 	= "Под курсором"
L["IN_CONNER"] 	= "Да, в углу"

----------------------------
L["SCIP_VIDEO"] = "|cffffff00Автоквест: |cff00ffffПропустил потрясающее видео, какая жалость...|r"
L["DONT_SHIFT"] = " |cff666666(не забывай про Шифт при контакте с НПС)|r"
L["MAKE_CHOICE"] = "|cffff0000Выбери награду сам уж как-нибудь...|r"

L["Y_STATUS"] = "Ваш статус:"
L["Y_STATUS_DC"] = "Ваш статус: Не закончено"
L["Y_STATUS_C"] = "Ваш статус: Завершено "

L["CLASS"] = "Класс"
L["BAG"] = "Сумка"
L["BANK"] = "Банк"
L["TOTAL"] = "Всего"

L["Expand"] 	= "Развернуть"
L["Collapse"] 	= "Свернуть"
L["Sound"] 	= "Звук"
L["Sound_OFF"] 	= "Отключить звук до следующего входа в игру."
L["Close"] 	= "Закрыть"
L["Close_OFF"] 	= "Закрыть СТА до следующего входа в игру.\n(Повторно можно запустить из меню настроек СТА)"
L["Role"] = "Роль:"
L["Not enough"] 	= "Не хватает:"
L["In the queue"] 	= "В очереди:"
L["Waiting"] 	= "Ожидание:"
L["HRENDOM"] 	= "Хероический рендом"

L["MAP_CURSOR"] = "Курсор: "
L["MAP_BOUNDS"] = "Вне карты!"

L["Bagzy and banksy"]	= "Сумки авоськи"
L["Busy"] 	= "Занято"
L["Free"] 	= "Свободно"
L["Friends"] 	= "Друзьяшки"

L["For the game"] 	= "За игру: "
L["Received"] 	= "Получено:"
L["Spent"] 	= "Потрачено:"
L["Loss"] 	= "Убыль:"
L["Profit"] 	= "Прибыль:"
L["General information"] 	= "Общая информация: "

L["Fog of war"] = "Туман войны"

L["JUNKSOLD"] 	= "Хлам продан, заработано: "
L["REMONT"] 	= "Отремонтированно на : "
L["NOMONEY"] 	= "|cffff0000Где деньги, Лебовски?! Нет денег даже на ремонт! Ты исполрил всю мою жизнь!!!!!"

L["Left"] 	= "Осталось:"
L["Collected"] 	= "Собрано:"
L["Rest"] 	= "Отдых:"
L["Totals"] 	= "Всего:"

L["LEVEL"] 	= "Уровень: "
L["CANLEARN"] 	= "Можно изучить"
L["features"] 	= "особенностей."

L["instead"] 	= " вместо "
L["put on"] 	= "|cffff0000После боя надень: |r"
L["weared"] 	= "|cffff0000Надето: |r"
L["can change"] 	= "|cffff0000Можно сменить: |r"
						
L["Money"] 	= "Денюжка"
L["Skill Points"] 	= "Очки умений"
L["Expirience"] 	= "Опыт"
L["Currency"] 	= "Валютка"
L["Reward"] 	= "Награда"
L["Choice"] 	= "Выбор"
L["Better than"] 	= "Лучше чем"
L["Quest"] 	= "Задание"
L["Your choice"] 	= "Наш выбор"

L["Spend"] 	= "Потрать"
L["myself"] 	= "сам! :)"
L["Pay"] 	= "Заплати"
L["this huckster"] 	= "этому барыге"
L["Give it to him"] 	= "Отдай ему"
L["on"] 	= " на "
L["from"] 	= "от"

L["stbEnable"]	=	"scrollingCoombatText ( test)"
--[[
L[""] 	= "
L["DESC"] 	= 

]]

ns.L = L