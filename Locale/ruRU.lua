local _, ns = ...

if ns:IsSameLocale("ruRU") then
	local L, yo = unpack( select( 2, ...)) or ns:NewLocale()

	L.LOCALE_NAME = "ruRU"

	L["yoFrame"]		= "yoFrame"

	L["player"] = "Игрок"
	L["target"] = "Таргет"
	L["BCBBoss"] = "Босс (вне боя с босом показывать касты таргета)"

	L["BIND_DESC"]		= "Наведите мышь над иконкой панели команд что бы назначить клавишу действия.\n \'Escape\' или правый клик мышью для очистки текущего значения"
	L["BIND_SAVE"]		= "|cff00a2ffИзменения настроек клавиш были сохранены.|r"
	L["BIND_ESC"]		= "|cffff9900Изменения настроек клавиш были отменены.|r"

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

	L["completion1"] = "Закрыли вовремя |cff8787ED%s [%s]|r за |cff00ffff%s|r. Осталось %s от таймера, и отстали от +2 на %s."
	L["completion2"] = "Закрыли вовремя |cff8787ED%s [%s]|r +2 за |cff00ffff%s|r. Осталось %s от +2 таймера, и отстали от +3 на %s."
	L["completion3"] = "Закрыли вовремя |cff8787ED%s [%s]|r +3 за |cff00ffff%s|r. Осталось %s от +3 таймера."

	L["completion0"] = "|cff8787ED[%s] %s|r окончили за |cffff0000%s|r, вы отстали на %s от общего лимита времени."

	L["Ovirva4zzz"]		= "Оверватчз"
	L["In MobilApps"]	= "В мобильном"
	L["In Apps"]		= "В приложении"

--[[
L[""] 	= "
L["DESC"] 	= 

]]
	ns[1] = L
end