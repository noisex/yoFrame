local addon, engine = ...

engine[1] = {}	-- L, Locales
engine[2] = {}	-- yo, Config
engine[3] = {}	-- N,

yoFrame = engine


-- 0.075, 0.078, 0.086  back
-- 0.126, 0.129, 0.145  fore
-- 0.392, 0.392, 0.392  text  646464
-- 0.059, 0.616, 0.345	green 0f9d58

-- item maska 20569, 20570, 49215, 20392, 34001, 20565

-- оповещения всякие
--local qq = "Помните: отыскав свое тело, вы воскреснете без потерь. Если же я воскрешу вас, прочность всех ваших предметов понизится на 25%, а сами вы будете в течение %s испытывать слабость. Вы уверены, что хотите этого?"
CONFIRM_XP_LOSS_AGAIN = "Shut up and ресай меня скорее!!!"

_G ["BINDING_HEADER_YOFRAME"]	= "yoFrame"
_G ["BINDING_HEADER_TAR_MARK"] 	= "Целевые марки по наведению мышки ( MOUSEOVER) или таргету"

_G ["BINDING_NAME_TOGGLE_WIM"] 	= "Toggle WIM window"
_G ["BINDING_NAME_TOGGLE_CFG"] 	= "Toggle Config window"
_G ["BINDING_NAME_TOGGLE_MOV"] 	= "Toggle двигалка фреймов"

_G ["BINDING_NAME_TAR_MARK_1"] 	= "Звизда"
_G ["BINDING_NAME_TAR_MARK_2"] 	= "Печеня"
_G ["BINDING_NAME_TAR_MARK_3"] 	= "Ромб филтепетовый"
_G ["BINDING_NAME_TAR_MARK_4"] 	= "Треугольник зеленый"
_G ["BINDING_NAME_TAR_MARK_5"] 	= "Луняшка"
_G ["BINDING_NAME_TAR_MARK_6"] 	= "Квадрат синий же"
_G ["BINDING_NAME_TAR_MARK_7"] 	= "Крест православный"
_G ["BINDING_NAME_TAR_MARK_8"] 	= "Черепок"
_G ["BINDING_NAME_TAR_MARK_0"] 	= "Очистителька"


--_G ["BINDING_NAME_DETAILS_SCROLL_UP"] = Loc ["STRING_KEYBIND_SCROLL_UP"]
--_G ["BINDING_NAME_DETAILS_SCROLL_DOWN"] = Loc ["STRING_KEYBIND_SCROLL_DOWN"]
