local addonName, ns = ...

---local L = unpack( select( 2, ...)) or ns:NewLocale()
local L = ns:NewLocale()

ns[1] = L

L.LOCALE_NAME = "enUS"

L.yoFrame	= "yoFrame"
L.NEW 		= " |cffff0000(!)|r"
L.DEFAULT	= "Default: "
L.player 	= "Player"
L.target 	= "Target"
L.BCBBoss 	= "Boss1"
---------------------------------------------
-----		Header
---------------------------------------------
L.ResetConfig 	= "Reset config"
L.MOVE 			= "Move"
L.DONTMOVE 		= "Dont move"
L.ResetPosition = "Reset UI pos"
L.ReloadConfig 	= "Save & Reload"
L.RESET_DESC 	= "Reset config to default.\n\nWith reload..."
L.RESETUI_DESC	= "Reset the saved coordinates and return to the original position.\n\nWith reload..."
L.RELOAD_DESC	= "\nWith reload... :)"

---------------------------------------------
-----		General Settings
---------------------------------------------
L.PersonalConfig 	= "|cffff0000Personal config(!)|r"
L.scriptErrors		= "Show UI scripts errors"
L.System 			= "General settings"

L.texture 			= "Addon elements textures"
L.FontSize 			= "Addon elements font size"
L.sysfontsize		= "Game system font size"
L.AutoScale 		= "UI Scaling"
L.ScaleRate 		= "UI Scale"
L.ChangeSystemFonts = "Change system fonts to normal :)"

L.CONFIRM_PERSONAL 	= "Change the type of settings?\n(it is necessary to reload the interface)"
L.PERSONAL_DESC		= "|cffffff00(changes addon settings for this character from common to personal)|r"
L.SYSFONT_DESC		= "Try changing the size of the system font.\nAt your own risk.\n\n By default: 10"
L.SCALE_NONE		= "No scaling"
L.SCALE_AUTO 		= "Auto scaling"
L.SCALE_MANUAL 		= "Manual scaling"

---------------------------------------------
-----		Addons
---------------------------------------------
L.Addons 			= "Addons"
L.MiniMaps 			= "Minimap settings"
L.FlashIconCooldown = "Show icon of spell comming out of cooldown in the center of the screen"
L.RaidUtilityPanel 	= "Raid Utility Panel"
L.ArtifactPowerbar 	= "Experience, reputations and Azerit bar"
L.Potatos 			= "Potatos"
L.mythicProcents 	= "Show the percentage of mobs progress in M+ on mouseover"
L.MiniMap 			= "Minimap redesign"
L.MiniMapCoord 		= "Coordinates on the minimap"
L.MMColectIcons		= "Collect and remove icons from the minimap"
L.MiniMapHideText	= "Hide location name"
L.MMCoordColor		= "Coordinate text color"
L.MMCoordSize 		= "Font size"
L.InfoPanels 		= "Show infopanels at the bottom of the screen"
L.BlackPanels 		= "Show black panels on the right and left bottom of the screen"
L.IDInToolTip 		= "ID of item, spell, buff and other in tooltip"
L.ObjectiveHeight	= "ObjectiveQuestList height"
L.hideObjective		= "Hide ObjectiveQuestList in scenario"
L.afk				= "Enable AFK animations"
L.MoveBlizzFrames	= "Move all Blizzard frames with keypressed"
L.disenchanting		= "Milling, Prospecting and Disenchanting by Alt + click"
L.stbEnable			= "Enable Scrolling Combat Text"
L.MiniMapSize		= "MiniMap size"
L.pixelFont 		= "Pixel font"
L.addonFont			= "Base addon font"
L.covenantsCD 		= "Bars with party covenats CD"
L.RaidCoolDowns 	= "Bars with party/raid interrupts CD ( 6 max)"
L.movePersonal		= "Save addon elements layout settings personally"
L.minimapMove		= "Move minimap"
L.showToday 		= "Show daily auto-quests"
L.fontSizeAddon 	= "Addon main font size"
L.moveWidget		= "Move top-central widget ( The Eye of the Jailer)"

L.RUP_DESC 			= "Targets mark, world marks, readycheck...( ERT requiued)"
L.POT_DESC 			= "Enable module to track the use of pots in battle."
L.OBJQ_DESC 		= "Default: 500"
L.MMHIDE_DESC 		= "Show the name of the current location only when you hover the mouse on the minimap."
L.ObjectiveTracker	= "Redesign ObjectiveTracker"

---------------------------------------------
-----		Automatic
---------------------------------------------
L.Automatic			= "Automatic"
L.equipNewItem		= "Trying to wear a new thing while getting"
L.equipNewItemLevel	= "with iLVL not more than:"
L.AutoRepair 		= "Auto repair from vendor, priority from guildbank"
L.AutoSellGrayTrash = "Autosale trash to vendor"
L.AutoInvite		= "Autoinvite in party by whisper \'inv\'"
L.AutoLeader		= "Give party/raid leader role by whisper \'!leader\' (danger, but can be usefull)"
L.AutoQuesting 		= "Autoquestings"
L.AutoQuest			= "Auto accept quests"
L.AutoQuestComplete = "Auto take quest"
L.AutoQuestSkipScene= "Skip videos"
L.AutoQuestComplete2Choice= "Autochoice best item by iLVL"
L.AutoInvaitFromFriends = "Accept an invitation to the group from friends and co-guilds"
L.AutoScreenOnLvlUpAndAchiv = "Auto-screenshot"
L.AutoQuestEnhance	= "Print more information about quest"
L.RepairGuild 		= "Guild repair"
L.AutoScreenOnLvlUp = "Auto-screenshot on Level up"
L.AutoScreenOnAndAchiv = "Auto-screenshot on achievment"
L.AutoCovenantsMission = "Try to quick close covenants mission"

L.TalkingHeadHead 	= "Talking Head"
L.hideHead			= "Hide the TalkingHead you've already seen"
L.hideForAll			= "Collect data personally (none = general data on all characters)"
L.hideClearAll		= "Clean up after all"
L.hideClearData		= "Remove your ... data"
L.hideCopyData		= "Copy personally data to all"
L.hideCopyBack		= "Copy all data to personally"
L.hideSound			= "Remove TalkingHead voice"

L.QUCOM_ENCH 		= "Print the purpose of the assignment, not just the \'order\'' part"
L.QUACP_DESC 		= "Automatically accept the quest. \n\nPress |cff00ffffShift|r when contacting NPS to temporarily disable it."
L.QUCOM_DESC 		= "Automatically complete the quest. \n\nPress |cff00ffffShift|r when contacting NPS to temporarily disable it."
L.QU2CH_DESC 		= "Automatically choose the best thing if there is a choice, based on the greater difference with the character you are wearing. \n\nIn addition to the trinkets, shields and weapons. \n\nPress |cff00ffffShift|r when contacting an NPC to temporarily disable it."
L.SALE_DESC 		= "For possible consequences, the addon author is not responsible! :)"

---------------------------------------------
-----		CasrBars
---------------------------------------------
L.CastBar 			= "CastBars"
L.PCB 				= "Player casbar"
L.BCBenable			= "Enable Big CastBar"
L.PCBenable 		= "Enable Player CastBar"
L.width				= "Width"
L.height			= "Height"
L.offsetX			= "Offset Х"
L.offsetY			= "Offset Y"
L.BCDunit			= "Whose castbar"
L.icon				= "Icon"
L.iconSize			= "Icon size"
L.iconoffsetX		= "Offset icon X"
L.iconoffsetY		= "Offset icon Y"
L.iconincombat		= "Show icon in combat"
L.CBclasscolor		= "Castbar in class color"
L.BCB 				= "Big CastBar"
L.castbarAlpha		= "CastBar Alpha"
L.treatborder		= "Interrupt color border"
L.QueueWindow 		= "Spell QueueWindow time (ms)"
L.bigBar 			= "Big castbar"
L.castBoss 			= "...but replace with Boss"

L.DESC_BCB_TREAT 	= "Castbar border in cast-interapt possible color"
L.DESC_BCB_CC 		= "Castbar in class color or cast-interapt possible color"
L.DESC_QUEUE		= "The time that allows you to queue up the next spell and automatically cast it without wasting time. Recommended 200-500 ms. (Drawn in red at the end of the Player's casbara)"
L.DESC_CASTBOSS		= "During the battle with \"Bosses\" it changes to their castes, but at the end of the battle it returns to the previously selected position (the castes of the Player or the Target). Convenient for healers to see the Boss castes without targeting him."

---------------------------------------------
-----		Bags and Bank
---------------------------------------------
L.Bags 				= "Bags and Bank"
L.BAGenable 		= "Enable"
L.buttonSize 		= "Icon size"
L.buttonSpacing 	= "Icons gap"
L.numMaxRow			= "Row count"
L.containerWidth 	= "Bags/Bank width"
L.newIconAnimation	= "New items animation"
L.newAnimationLoop	= "Looped flash animation on new items"
L.ladyMod			= "Tooltip for beauty and ladies"
L.ladyModShift		= "...only with \'Shift\' key pressed"
L.showAltBags		= "Show bags and bank for alts"
L.showGuilBank		= "Show guild bank offline"
L.countAltBags		= "Show count items with another chatacters"
L.ResetBB 			= "Clear Data"
L.countGuildBank 	= "...also show in guild bank"
L.LeftToRight 		= "Sort and fill bags from bottom to top"

L.RESET_BB_DESC		= "Reset all collected bags, banks and guilsbanks data.\n\nNeed reload"

---------------------------------------------
-----		RaiFrames
---------------------------------------------
L.Raid 				= "Raidframes"
L.simpeRaid			= "Simple Raid template"
L.RAIDenable 		= "Enable Raidframes"
L.classcolor 		= "Raidframe colors:"
L.showSolo 			= "Show with no group (solo player frame)"
L.showGroupNum 		= "Show group numbers in the raid"
L.numgroups 		= "Number of columns (groups)"
L.spaicing 			= "Distance between frames"
L.manabar 			= "Show Manabar:"
L.manacolorClass 	= "Manabar in classcolor"
L.partyScale 		= "Party frame more then Raid ( scale)"
L.hpBarRevers 		= "Health draw in reverse order"
L.hpBarVertical 	= "Health draw vertically."
L.groupingOrder 	= "Sort:"
L.showLFD 			= "Show player role icon"
L.showHPValue 		= "Player health:"
L.noHealFrames 		= "Disabled when using another addons for healing (VuhDo, Grid, HealBot ...)"
L.healPrediction 	= "Show incoming heal, absorb and healabsorb"
L.aurasRaid 		= "Show debuff icons in the raid"
L.aurasParty 		= "Show debuff icons in a group"
L.debuffHight 		= "Highlight debuffs on player frames"
L.filterHighLight	= "Highlight only dispellable debuffs"
L.classBackground	= "In the dark scheme, draw the substrate in the color of the class"
L.showMT			= "Show Main Tanks"
L.showMTT			= "Show Main Tanks targets"
L.heightMT			= "Main Tanks Height"
L.widthMT			= "Main Tanks Width"
L.darkAbsorb 		= "Absorb color (less than zero is darker, more - lighter)"
L.showValueTreat 	= "Show on the Main Tank frame the value of the accumulated aggro"
L.showMTTT 			= "Show Main Tank Target-Target ( oh yeah baby you want it)"
L.fadeColor 		= "Change the brightness of a class color"
L.raidTemplate 		= "Raid template"

L.MB_ALL 		= "All"
L.MB_HEAL 		= "Heals Only"
L.MB_HIDE 		= "Hide"
L.HP_HIDE 		= "Do not show"
L.HP_PROC 		= "Percent Only"
L.HP_HPPROC 	= "HP | Percentage"
L.HBAR_CC 		= "Color Class"
L.HBAR_CHP 		= "Health color (gradient)"
L.HBAR_DARK 	= "Into the Dark"
L.SRT_ID 		= "By Player ID"
L.SRT_GR 		= "By groups"
L.SRT_TDH		= "Tank DD Heal"
L.SRT_THD		= "Tank Heal DD"
L.SRT_PIHORA	= "Pihora Edition"

---------------------------------------------
-----		ActionBars
---------------------------------------------
L.ActionBar 	= "ActionBars"
L.ABenable		= "Enable"
L.ShowGrid		= "Allways show grid"
L.HideHotKey	= "Dont show hotkeys"
L.CountSize		= "Stacks font size"
L.HideName		= "Dont show macros names"
L.MicroMenu		= "Micromenu"
L.MicroScale	= "Micromenu scale"
L.panel3Nums	= "Panel:3 Num Buttons"
L.panel3Cols	= "Panel:3 Num Collumns"
L.buttonsSize	= "Panels:1-3 buttons size"
L.buttonSpace	= "Panels:1-3 button space"
L.hoverTexture	= "Hover/Highlight border vs texture"
L.showBar5 		= "Show Bar 5"
L.showBar3 		= "Show Bar 3"
L.showNewGlow 	= "Another spell ready animation ( for fun)"
L.HotKeySize	= "HotKey font size"
L.HotKeyColor	= "HotKey font color"
L.secondHot		= "Show second HotKey on the button"
L.HotToolTip	= "Show MacrosName and HotKeys in GameTooptip"

---------------------------------------------
-----		NamePlates
---------------------------------------------
L.NamePlates 	= "NamePlates"
L.maxDispance	= "NamePlates max distance"
L.NPenable		= "Enable NamePlates"
L.iconDSize		= "Player debuff icon size"
L.iconBSize		= "Size of Right Icons"
L.iconDiSize	= "Size of central icons"
L.iconCastSize	= "Castbar icon size"
L.showCastIcon	= "Show cast icon"
L.showCastName	= "Show cast name"
L.showCastTarget= "Show supposed target of cast"
L.showPercTreat = "Show treat procent ( in group):"
L.showArrows	= "Show side arrows on target nameplate"
L.executePhaze	= "Execute phase"
L.executeProc	= "Execute %"
L.executeColor	= "Execute color"
L.blueDebuff	=  "Draw players debuffs in the spell schools color"
L.dissIcons		= "Central Icons:"
L.buffIcons		= "Right icons:"
L.classDispell	= "Dispell, only if your class can dispell them (for right icons)"
L.showToolTip	= "Show tooltip on buffs on mousover:"
L.glowBadType	= "Glow type on bad mobs"
L.glowTarget	= "Show glow amination ot target"
L.showResourses	= "Show player resourses ( cp, arcane, shards)"
L.tankMode		= "Fixed Tank Mode"
L.showTauntDebuff= "Show another players taunts icons"
L.badCasts 		= "Highlight bad/importants casts ( dungeons/torgast mobs usually)"
L.moreDebuffIcons= "Show Blizzard choise debuffs icons (a bit more)"

L.c0			= "0. Good agro ( DPS, Healer)"
L.c0t			= "0. Tank"
L.c1			= "1. Big argo ( mob on tank) > 100%"
L.c2			= "2. Loose agro ( mob on you) < 100%"
L.c3			= "3. Tanking ( DPS, Healer)"
L.c3t			= "3. Tank"
L.myPet			= "My pet ( party pet, if you tank)"
L.tankOT		= "Agro on another tank ( if you tank)"
L.badGood		= "Mob without agro to you, but in combat ( possible not danger)"

L.DESC_iconD 	= "Icons on the left side of the nameplates showing negative debuffs from player or control debuffs on the monster.\n\nBy default: 20"
L.DESC_iconB 	= "Icons on the right side of the nameplates displaying positive buffs on the monster. \n\nBy default: 20"
L.DESC_iconC 	= "Icons in the central part of the nameplates displaying positive buffs on the monster that can be dispelled. \n\nBy default: 30"
L.DESC_TCOL 	= "Agro Colors:"
L.DESC_ACOL 	= "Additional colors:"

L.NONE 			= "None"
L.DISS_ALL 		= "Dispellable all"
L.DISS_CLASS 	= "Dispellable by class"
L.DISS 			= "Dispellable"
L.ALL_BUFF 		= "All buffs"
L.ALL_EX_DIS 	= "All, exept dispellable"
L.scaledPercent = "scaledPercent ( 0 - 100%)"
L.rawPercent 	= "rawPercent ( 0 - 255%)"
L.UND_CURCOR 	= "Mousover"
L.IN_CONNER 	= "In the default corner"

---------------------------------------------
-----		Chat
---------------------------------------------
L.Chat 				= "Chat"
L.EnableChat 		= "Redesign chat"
L.fontsize 			= "Chat font size"
L.BarChat			= "Enable chatbar"
L.linkOverMouse		= "Item, achievment tooltip under mousover"
L.showVoice			= "Show voicechat buttons"
L.showHistory		= "Show guild, party chat history"
L.fadingEnable		= "Chat fading"
L.fadingTimer		= "...in seconds:"
L.wisperSound		= "PM sound"
L.wisperInCombat	= "PM sound in combat"
L.chatFont			= "Chat font"
L.wim				= "WoW Instant Messages"
L.chatFontsize 		= "Chat font size"
L.showHistoryAll 	= "... and another chats"
L.chatBubble		= "ChatBubbls:"
L.chatBubbleShadow	= "Add shadow to chatBubble"
L.chatBubbleFont	= "Fontsize"
L.chatBubbleShift	= "Reduce size"
L.combatLog 		= "Remove '	View Log' tab ( Combat Log)"

L.chBdontchange		= "Dont change"
L.chBremove			= "Remove border"
L.chBchangeS		= "Change border (skin)"
L.chBchangeB		= "Change border (border)"

---------------------------------------------
-----		CTA
---------------------------------------------
L.CTA 			= "CTA ( Call To Arms)"
L.CTAenable		= "Enable CTA"
L.nRole			= "Current (not change)"
L.heroic		= "Check Heroic dungens"
L.lfr			= "Check LFR"
L.CTAtimer		= "Check Frequency (s)"
L.setN			= "Current (not change)"
L.tank			= "Tank"
L.heal			= "Healer"
L.dd			= "DPS"
L.CTAnosound	= "Run silently"
L.expand		= "Run minimized"
L.CTAsound		= "Alert Sound:"
L.hideLast		= "Do not show if the last boss is killed"
L.readRole		= "Select the roles that CTA will track:"
L.CTAlaunch 	= "Start Again"
L.lfdMode 		= "5 ppl dungens"

L.DESC_SETN 	= "Select the role to be assigned when connecting to the queue:"
L.DESC_NROLE	= "It is set automatically according to the value set in ... well, in the window where the roles are set ... For each players, its own, by itself."

---------------------------------------------
-----		Fliger
---------------------------------------------
L.fliger 		= "Fliger"
L.FLGenable		= "Enable"
L.iconsize 		= "Icon size"
L.grow 			= "Growth:"
L.right 		= "Right"
L.left 			= "Left"
L.up 			= "Up"
L.down 			= "Down"
L.pCDTimer 		= "Time Limit"
L.checkBags 	= "Check the cooldowns of items from the actionbars - some fail on potions!!!"
L.gAzerit		= "Azerit \"General\" treits procs"
L.DESC_FILGER	= "|cffff0000Terrible experimental work, at your own risk :)"
L.DESC_PCD 		= "Less than this time, cooldowns are not shown"

L.fligerBuffGlow = "Animated border"
L.fligerBuffAnim = "Fade animation"
L.fligerBuffColr = "Color animation"
L.fligerBuffCount= "Stack/Timer"
L.fligerBuffSpell= "Buff/debuff spell name"
L.buffAnims		= "Filger icons Buff/debuff animation"
L.fligerSpell	= "long pepega"

L.DESC_ST		= "Animation criterion for buff/debuff: \nsN - stacks, highlight if stacks are MORE or equal than indicated N. If the buff technically cannot have more than 1 stack (Corruption, Wild growth, etc.), then you need to write zero: s0 \ntN - timer, animation, if there is LESS time left than N. \n\nFor example: \nt4 \ns3t6 \ns5 \n\nWrite opposite the desired buff in the next window. \nPossibly, but not necessarily, use together : s5t6 - blink if the buff has more than 4 stacks and less than 6 seconds left (and, not or)."
L.DESC_BSPELL	= "The full, correct spell name of the buff/debuff that we want to highlight among the icons according to some criteria. Separator: a new line or use a long pepega at the bottom, but it has its own atmosphere, there is not everything you want. It's funny, but a reboot, like a violinist, is not needed, we add, change, delete along the way ... \n\nFor example: \nAgony, \nRejuvenation \nFlame shock"

---------------------------------------------
-----		UnitFrames
---------------------------------------------
L.UF 			= "Unitframes"
L.unitFrames	= "Enable unitframes, but why do you need addon without them?"
L.UFenable 		= "Enable unitframes"
L.colorUF		= "Color as"
L.simpleUF 		= "Simplified view"
L.showGCD		= "Show small CD ot top player frame"
L.showShards	= "Show shards/cpoints/hpower on player frame"
L.HBAR_TS		= "As raid"
L.enableSPower	= "...but still show powerbar"
L.rightAbsorb	= "Show absorb bar on top player frame"
L.hideOldAbsorb	= "and hide the normal one that goes on player's frame"
L.powerHeight	= "Height of power/shard bars"

---------------------------------------------
-----		ToolTip
---------------------------------------------
L.ToolTip	 	= "Tooltip"
L.TTenable		= "Redesign tooltip"
L.showSpells	= "Show target unit talents"
L.showSpellShift= "...only with `Shift` pressed"
L.showSpellsVert= "Show talents vertically ( with name)"
L.showBorder	= "Tooltip border ( i forget what is it doit :)"
L.borderClass	= "Class colored tooltip border"

---------------------------------------------
-----		InfoTexts
---------------------------------------------
L.infoTexts		= "InfoTexts"
L.ITenable 		= "Include info texts, crap at the bottom of the screen that shows everything, sometimes even useful ..."
L.countLeft  	= "Items on the left panel"
L.countRight 	= "Items on the right panel"
L.left1 		= "Number 1"
L.left2 		= "Number 2"
L.left3 		= "Number 3"
L.left4 		= "Number 4"
L.left5 		= "Number 5"
L.left6 		= "Number 6"

L.right1 		= "Number 1"
L.right2 		= "Number 2"
L.right3 		= "Number 3"
L.right4 		= "Number 4"
L.right5 		= "Number 5"
L.right6 		= "Number 6"

---------------------------------------------
-----		HealBotka
---------------------------------------------
L.hEnable 		= "Enable displaying your hots on raid frames"
L.hSize			= "Icon size"
L.hTimeSec		= "Show only seconds, no tenths"
L.hTempW		= "Width HealBot"
L.hTempH		= "Height HealBot"
L.hRedTime 		= "Draw \"red-color\" timer, with ... seconds"
L.hDefCol		= "\"Common\" timer color"
L.hRedCol		= "\"Red\" timer color"
L.bShiftY		= "Top offset (minus - down)"
L.bSpell 		= "Hotbar"
L.bColEna		= "Hotbar color"
L.funcEnable	= "Go to heal!"
L.funcDisable	= "That's enough..."
L.borderC		= "Mouseover border color "
L.borderS		= "2 pixels border ( disable = 1)"
L.takeTarget 	= "Take target in target"
L.hideTimer 	= "Hide timer for more time:"
L.hColEnable	= "Custom color instead of spell icon ( imho, more usefull)"
L.hScale		= "Scale"

L.DESC_HBOT_ENA = "|cff00ff00Turn on|r keybinds.\n|cff00ff00Turn on|r hots icons\nUse template |cff00ff00HealBot|r\nReload UI."
L.DESC_HBOT_DIS = "|cffff0000Turn off|r keybinds.\n|cffff0000Turn off|r hots icons\nUse template |cffff0000Normal|r\nReload UI."

L.DESC_RTEMPL	= "I recommend pre-installing raid template |cffff0000\"HealBotka\"|r. More convenient for displaying a hots and other things, with a minimum of unnecessary."
L.DESC_KEY		= "Click for key/mouse binding"
L.DESC_HENA		= "I highly recommend pre-installing |cffff0000`Personal profile`|r."
L.DESC_TRINK 	= "Use trinkets before cast"
L.DESC_STOP		= "Stopcast before cast (yes, it happens too)"

L.healBotka		= "HealBotka"
L.keneral 		= "Mouse and Keyboard binding"
L.kEnable		= "Bind mouse button or key to click over raidframes"
L.healset00		= "Mouse or Key"
L.healset01		= "SpellName for cast"
L.healtarg01	= "Take in target"
L.healmenu01	= "Show menu"
L.healres01		= "Auto-resurection"

L.heneral		= "Hots icons"
L.hSpell1		= "Icon №1 ( left-center)"
L.hSpell2		= "Icon №2 ( left-bottom)"
L.hSpell3 		= "Icon №3 ( center-bottom)"
L.hSpell4		= "Icon №4 ( right-bottom)"
L.hSpell5		= "Icon №5 ( right-center)"
L.aenaral		= "Additional ..."