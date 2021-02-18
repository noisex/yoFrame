local AddOnName, engine = ...

local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local addon = AceAddon:NewAddon( AddOnName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')

local yo  = _G.yoFrame_Config[2] --CopyTable( _G.yoFrame_Config[2])

engine[1] = {}		-- L, Locales
engine[2] = yo 		-- Config
engine[3] = addon	-- N,
engine[4] = {}

_G[AddOnName] = engine

-- 0.075, 0.078, 0.086  back
-- 0.126, 0.129, 0.145  fore
-- 0.392, 0.392, 0.392  text  646464
-- 0.059, 0.616, 0.345	green 0f9d58

local oops = false
if 	   IsAddOnLoaded("ElvUI") 		then oops = "ElvUI"
elseif IsAddOnLoaded("ShestakUI") then oops = "ShestakUI"
elseif IsAddOnLoaded("Tukui") 		then oops = "Tukui" end

local text    = "Извиняюсь, но |cff00ffffyoFrame|r не совместим с таким модом как |cffff0000%s|r. Вам придется сделать свой выбор... отключить |cff00ffffyoFrame|r, удалить и забыть его навсегда.\nЯ вам его уже выключил, просто нажмите кнопку для перезагрузки интерфейса игры.\nСпасибо, что скачали."
local button1 = "Ну его нафик"
local button2 = "или попробовать?"
local mousOver= "Целевые марки по наведению мышки ( MOUSEOVER) или таргету"

if GetLocale() ~= "ruRU" then
    text    = "Sorry, but |cff00ffffyoFrame|r is not compatible with a addon like |cffff0000%s|r. You will have to make your choice... disable |cff00ffffyoFrame|r, delete and forget it forever.\nI already turned it off, just click the button to restart the game interface.\nThank you for downloading."
    button1 = "Well fuck it"
    button2 = "or try?"
    mousOver= "Raid targetmarks by MOUSEOVER or TARGET"
end

StaticPopupDialogs["CONFIRM_ADDON"] = {
  	text = text,
  	button1 = button1,
  	button2 = button2,
  	OnAccept = function()
  		DisableAddOn("yoFrame")
     	ReloadUI()
  	end,
  	OnCancel = function (_,reason)
		  DisableAddOn( oops)
     	ReloadUI()
  	end,
  	timeout = 0,
  	whileDead = true,
  	hideOnEscape = true,
  	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

if oops then StaticPopup_Show ("CONFIRM_ADDON", oops)  end

_G.CONFIRM_XP_LOSS_AGAIN = "Shut up and ресай меня скорее!!!"

_G ["BINDING_HEADER_YOFRAME"]	= "yoFrame"
_G ["BINDING_HEADER_TAR_MARK"] 	= mousOver

_G ["BINDING_NAME_TOGGLE_WIM"] 	= "Toggle WIM window"
_G ["BINDING_NAME_TOGGLE_CFG"] 	= "Toggle Config window"
_G ["BINDING_NAME_TOGGLE_MOV"] 	= "Toggle move frame"

_G ["BINDING_NAME_TAR_MARK_1"] 	= RAID_TARGET_1
_G ["BINDING_NAME_TAR_MARK_2"] 	= RAID_TARGET_2
_G ["BINDING_NAME_TAR_MARK_3"] 	= RAID_TARGET_3
_G ["BINDING_NAME_TAR_MARK_4"] 	= RAID_TARGET_4
_G ["BINDING_NAME_TAR_MARK_5"] 	= RAID_TARGET_5
_G ["BINDING_NAME_TAR_MARK_6"] 	= RAID_TARGET_6
_G ["BINDING_NAME_TAR_MARK_7"] 	= RAID_TARGET_7
_G ["BINDING_NAME_TAR_MARK_8"] 	= RAID_TARGET_8
_G ["BINDING_NAME_TAR_MARK_0"] 	= RAID_TARGET_NONE

-- text count color
hooksecurefunc( 'SetItemButtonCount', function( slot, slotCount)
  --_G.HIGHLIGHT_FONT_COLOR.r = 1
  --_G.HIGHLIGHT_FONT_COLOR.g = 215/255
  ---_G.HIGHLIGHT_FONT_COLOR.b = 0

  --print( "HOOKSEC", slot, slotCount, slot:GetName())
  if slot:GetName() then
    if slotCount and slotCount > 0 then
      local slotText = _G[slot:GetName().."Count"]
      if slotText then
          slotText:SetTextColor( 1, 215/255, 0)       --- COUNT COLOR
      end
    end
  end
end)
