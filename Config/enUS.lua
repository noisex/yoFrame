local _, ns = ...
local L, yo = unpack( select( 2, ...)) or ns:NewLocale()

L.LOCALE_NAME = "enUS"

L["NEW"] 		= " |cffff0000(!)|r"
L["DEFAULT"]	= "Default: "
L["player"] 	= "Player"
L["target"] 	= "Target"
L["BCBBoss"] 	= "Boss1"
---------------------------------------------
-----		Header
---------------------------------------------
L["ResetConfig"] 	= "Reset config"
L["MOVE"] 			= "Move"
L["DONTMOVE"] 		= "Dont move"
L["ResetPosition"] 	= "Reset UI pos"
L["ReloadConfig"] 	= "Save & Reload"
L["RESET_DESC"] 	= "Reset config to default.\n\nWith reload..."
L["RESETUI_DESC"]	= "Reset the saved coordinates and return to the original position.\n\nWith reload..."
L["RELOAD_DESC"]	= "\nWith reload... :)"

---------------------------------------------
-----		General Settings
---------------------------------------------
L["PersonalConfig"] = "|cffff0000Personal config(!)|r"
L["scriptErrors"]	= "Show UI scripts errors"
L["System"] 		= "General settings"

L["texture"] 		= "Addon elements textures"
L["FontSize"] 		= "Addon elements font size"
L["sysfontsize"]	= "Game system font size"
L["AutoScale"] 		= "UI Scaling"
L["ScaleRate"] 		= "UI Scale"
L["ChangeSystemFonts"] = "Change system fonts to normal :)"

L["CONFIRM_PERSONAL"] = "Change the type of settings?\n(it is necessary to reload the interface)"
L["PERSONAL_DESC"]	= "|cffffff00(changes addon settings for this character from common to personal)|r"
L["SYSFONT_DESC"]	= "Try changing the size of the system font.\nAt your own risk.\n\n By default: 10"
L["SCALE_NONE"]		= "No scaling"
L["SCALE_AUTO"] 	= "Auto scaling"
L["SCALE_MANUAL"] 	= "Manual scaling"

---------------------------------------------
-----		Addons
---------------------------------------------
L["Addons"] 		= "Addons"
L["MiniMaps"] 		= "Minimap settings"
L["FlashIconCooldown"] = "Show icon of spell comming out of cooldown in the center of the screen"
L["RaidUtilityPanel"] = "Raid Utility Panel"
L["ArtifactPowerbar"] = "Experience, reputations and Azerit bar"
L["Potatos"] 		= "Potatos"
L["mythicProcents"] = "Show the percentage of mobs progress in M+ on mouseover"
L["MiniMap"] 		= "Minimap redesign"
L["MiniMapCoord"] 	= "Coordinates on the minimap"
L["MMColectIcons"]	= "Collect and remove icons from the minimap"
L["unitFrames"]		= "Enable unitframes, but why do you need addon without them?"
L["MiniMapHideText"]= "Hide location name"
L["MMCoordColor"]	= "Coordinate text color"
L["MMCoordSize"] 	= "Font size"
L["InfoPanels"] 	= "Show infopanels at the bottom of the screen"
L["BlackPanels"] 	= "Show black panels on the right and left bottom of the screen"
L["IDInToolTip"] 	= "ID of item, spell, buff and other in tooltip"
L["ObjectiveHeight"]= "ObjectiveQuestList height"
L["hideObjective"]	= "Hide ObjectiveQuestList in scenario"
L["afk"]			= "Enable AFK animations"
L["MoveBlizzFrames"]= "Move all Blizzard frames with Shift keypressed"
L["disenchanting"]	= "Milling, Prospecting and Disenchanting by Alt + click"
L["stbEnable"]		= "Enable Scrolling Combat Text"

L["RUP_DESC"] 		= "Targets mark, world marks, readycheck...( ERT requiued)"
L["POT_DESC"] 		= "Enable module to track the use of pots in battle."
L["OBJQ_DESC"] 		= "Default: 500"
L["MMHIDE_DESC"] 	= "Show the name of the current location only when you hover the mouse on the minimap."

---------------------------------------------
-----		Automatic
---------------------------------------------
L["Automatic"]		= "Automatic"
L["equipNewItem"]	= "Trying to wear a new thing while getting"
L["equipNewItemLevel"]= "with iLVL not more than:"
L["AutoRepair"] 	= "Auto repair from vendor, priority from guildbank"
L["AutoSellGrayTrash"] = "Autosale trash to vendor"
L["AutoInvite"]		= "Autoinvite in party by whisper \'inv\'"
L["AutoLeader"]		= "Give party/raid leader role by whisper \'!leader\' (danger, but can be usefull)"
L["AutoQuesting"] 	= "Autoquestings"
L["AutoQuest"]		= "Auto accept quests"
L["AutoQuestComplete"]= "Auto take quest"
L["AutoQuestSkipScene"]= "Scip videos"
L["AutoQuestComplete2Choice"]= "Autochoice best item by iLVL"
L["AutoInvaitFromFriends"] = "Accept an invitation to the group from friends and co-guilds"
L["AutoScreenOnLvlUpAndAchiv"] = "Auto-screenshot"

L["QUACP_DESC"] 	= "Automatically accept the quest. \n\nPress |cff00ffffShift|r when contacting NPS to temporarily disable it."
L["QUCOM_DESC"] 	= "Automatically complete the quest. \n\nPress |cff00ffffShift|r when contacting NPS to temporarily disable it."
L["QU2CH_DESC"] 	= "Automatically choose the best thing if there is a choice, based on the greater difference with the character you are wearing. \n\nIn addition to the trinkets, shields and weapons. \n\nPress |cff00ffffShift|r when contacting an NPC to temporarily disable it."
L["SALE_DESC"] 		= "For possible consequences, the addon author is not responsible! :)"

---------------------------------------------
-----		CasrBars
---------------------------------------------
L["CastBar"] 		= "CastBars"
L["PCB"] 			= "Player casbar"
L["BCBenable"]		= "Enable Big CastBar"
L["PCBenable"] 		= "Enable Player CastBar"
L["width"]			= "Width"
L["height"]			= "Height"
L["offsetX"]		= "Offset Х"
L["offsetY"]		= "Offset Y"
L["BCDunit"]		= "Whose castbar"
L["icon"]			= "Icon"
L["iconSize"]		= "Icon size"
L["iconoffsetX"]	= "Offset icon X"
L["iconoffsetY"]	= "Offset icon Y"
L["iconincombat"]	= "Show icon in combat"
L["CBclasscolor"]	= "Castbar in class color"
L["BCB"] 			= "Big CastBar"
L["castbarAlpha"]	= "CastBar Alpha"

L["treatborder"]	= "Interrupt color border"
L["DESC_BCB_TREAT"] = "Castbar border in cast-interapt possible color"
L["DESC_BCB_CC"] 	= "Castbar in class color or cast-interapt possible color"

---------------------------------------------
-----		Bags and Bank
---------------------------------------------
L["Bags"] 			= "Bags and Bank"
L["BAGenable"] 		= "Enable"
L["buttonSize"] 	= "Icon size"
L["buttonSpacing"] 	= "Icons gap"
L["numMaxRow"]		= "Row count"
L["containerWidth"] = "Bags/Bank width"
L["newIconAnimation"]= "New items animation"
L["newAnimationLoop"]= "Looped flash animation on new items"

---------------------------------------------
-----		RaiFrames
---------------------------------------------
L["Raid"] 			= "Riadframes"
L["RAIDenable"] 	= "Enable Raidframes"
L["classcolor"] 	= "Raidframe colors:"
L["showSolo"] 		= "Show with no group (solo player frame)"
L["showGroupNum"] 	= "Show group numbers in the raid"
L["numgroups"] 		= "Number of columns (groups)"
L["spaicing"] 		= "Distance between frames"
L["manabar"] 		= "Show Manabar:"
L["manacolorClass"] = "Manabar in classcolor"
L["partyScale"] 	= "Party frame more then Raid ( scale)"
L["hpBarRevers"] 	= "Health draw in reverse order"
L["hpBarVertical"] 	= "Health draw vertically."
L["groupingOrder"] 	= "Sort:"
L["showLFD"] 		= "Show player role icon"
L["showHPValue"] 	= "Player health:"
L["noHealFrames"] 	= "Disabled when using another heal addons (VuhDo, Grid, HealBot ...)"
L["healPrediction"] = "Show incoming heal, absorb and healabsorb"
L["aurasRaid"] 		= "Show debuff icons in the raid"
L["aurasParty"] 	= "Show debuff icons in a group"
L["debuffHight"] 	= "Highlight debuffs on player frames"
L["classBackground"]= "In the dark scheme, draw the substrate in the color of the class"

L["MB_ALL"] 	= "All"
L["MB_HEAL"] 	= "Heals Only"
L["MB_HIDE"] 	= "Hide"
L["HP_HIDE"] 	= "Do not show"
L["HP_PROC"] 	= "Percent Only"
L["HP_HPPROC"] 	= "HP | Percentage"
L["HBAR_CC"] 	= "Color Class"
L["HBAR_CHP"] 	= "Health color (gradient)"
L["HBAR_DARK"] 	= "Into the Dark"
L["SRT_ID"] 	= "By Player ID"
L["SRT_GR"] 	= "By groups"
L["SRT_TDH"]	= "Tank DD Heal"
L["SRT_THD"]	= "Tank Heal DD"

---------------------------------------------
-----		ActionBars
---------------------------------------------
L["ActionBar"] 	= "ActionBars"
L["ABenable"]	= "Enable"
L["ShowGrid"]	= "Allways show grid"
L["HideHotKey"]	= "Dont show hotkeys"
L["CountSize"]	= "Stacks font size"
L["HideName"]	= "Dont show macros names"
L["MicroMenu"]	= "Micromenu"
L["MicroScale"]	= "Micromenu scale"

---------------------------------------------
-----		NamePlates
---------------------------------------------
L["NamePlates"] 	= "NamePlates"
L["NPenable"]		= "Enable NamePlates"
L["iconDSize"]		= "Player debuff icon size"
L["iconBSize"]		= "Size of Right Icons"
L["iconDiSize"]		= "Size of central icons"
L["iconCastSize"]	= "Castbar icon size"
L["showCastIcon"]	= "Show cast icon"
L["showCastName"]	= "Show cast name"
L["showCastTarget"]	= "Show supposed target of cast"
L["showPercTreat"] 	= "Show treat procent ( in group):"
L["showArrows"]		= "Show side arrows on target nameplate"
L["executePhaze"]	= "Execute phase"
L["executeProc"]	= "Execute %"
L["executeColor"]	= "Execute color"
L["blueDebuff"]		=  "Draw players debuffs in the spell schools color"
L["dissIcons"]		= "Central Icons:"
L["buffIcons"]		= "Right icons:"
L["classDispell"]	= "Disspell, only if your class can disspell them (for right icons)"
L["showToolTip"]	= "Show tooltip on buffs on mousover:"
L["glowBadType"]	= "Glow type on bad mobs"

L["c0"]			= "0. Good agro ( DPS, Healer)"
L["c0t"]		= "0. Tank"
L["c1"]			= "1. Big argo ( mob on tank) > 100%"
L["c2"]			= "2. Loose agro ( mob on you) < 100%"
L["c3"]			= "3. Tanking ( DPS, Healer)"
L["c3t"]		= "3. Tank"
L["myPet"]		= "My per ( party pet, if you tank)"
L["tankOT"]		= "Agro on another tank ( if you tank)"
L["badGood"]	= "Mob without agro to you, but in combat ( possible not danger)"

L["DESC_iconD"] = "Icons on the left side of the nameplates showing negative debuffs from player or control debuffs on the monster.\n\nBy default: 20"
L["DESC_iconB"] = "Icons on the right side of the nameplates displaying positive buffs on the monster. \n\nBy default: 20"
L["DESC_iconC"] = "Icons in the central part of the nameplates displaying positive buffs on the monster that can be dispelled. \n\nBy default: 30"
L["DESC_TCOL"] 	= "Agro Colors:"
L["DESC_ACOL"] 	= "Additional colors:"

L["NONE"] 		= "None"
L["DISS_ALL"] 	= "Disspellable all"
L["DISS_CLASS"] = "Disspellable by class"
L["DISS"] 		= "Disspellable"
L["ALL_BUFF"] 	= "All buffs"
L["ALL_EX_DIS"] = "All, exept dispellable"
L["scaledPercent"] 	= "scaledPercent ( 0 - 100%)"
L["rawPercent"] = "rawPercent ( 0 - 255%)"
L["UND_CURCOR"] = "Mousover"
L["IN_CONNER"] 	= "In the default corner"

L["glowTarget"]	=	"Show glow amination ot target"

---------------------------------------------
-----		Chat
---------------------------------------------
L["Chat"] 		= "Chat"
L["EnableChat"] = "Redesign chat"
L["fontsize"] 	= "Chat font size"
L["BarChat"]	= "Enable chatbar"
L["linkOverMouse"]= "Item, achievment tooltip under mousover"
L["showVoice"]	= "Show voicechat buttons"
L["showHistory"]= "Show guild, party chat history"
L["fadingEnable"]= "Chat fading"
L["fadingTimer"]= "...in seconds:"
L["wisperSound"]= "PM sound"
L["wisperInCombat"]= "PM sound in combat"

---------------------------------------------
-----		CTA
---------------------------------------------
L["CTA"] 		= "CTA ( Call To Arms)"
L["CTAenable"]	= "Enable CTA"
L["nRole"]		= "Current (not change)"
L["heroic"]		= "Check Heroic dungens"
L["lfr"]		= "Check LFR"
L["CTAtimer"]	= "Check Frequency (s)"
L["setN"]		= "Current (not change)"
L["tank"]		= "Tank"
L["heal"]		= "Healer"
L["dd"]			= "DPS"
L["CTAnosound"]	= "Run silently"
L["expand"]		= "Run minimized"
L["CTAsound"]	= "Alert Sound:"
L["hideLast"]	= "Do not show if the last boss is killed"
L["readRole"]	= "Select the roles that CTA will track:"
L["CTAlaunch"] 	= "Start Again"
L ["DESC_SETN"] = "Select the role to be assigned when connecting to the queue:"
L ["DESC_NROLE"]= "It is set automatically according to the value set in ... well, in the window where the roles are set ... For each players, its own, by itself."

---------------------------------------------
-----		Fliger
---------------------------------------------
L["fliger"] 	= "Filger"
L["FLGenable"]	= "Enable"
L["iconsize"] 	= "Icon size"
L["grow"] 		= "Growth:"
L["right"] 		= "Right"
L["left"] 		= "Left"
L["up"] 		= "Up"
L["down"] 		= "Down"
L["pCDTimer"] 	= "Time Limit"
L["checkBags"] 	= "Check the cooldowns of items from the actionbars - some fail on potions!!!"
L["gAzerit"]	= "Azerit \"General\" treits procs"
L["DESC_FILGER"]= "|cffff0000Terrible experimental work, at your own risk :)"
L["DESC_PCD"] 	= "Less than this time, cooldowns are not shown"