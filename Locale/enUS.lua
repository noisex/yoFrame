local _, ns = ...

local L = ns:NewLocale()

L.LOCALE_NAME = "enUS"


L["yoFrame"]	= "yoFrame"
	
L["player"] = "Player"
L["target"] = "Target"
L["BCBBoss"] = "Boss1"

L["BIND_DESC"]		= "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."
L["BIND_SAVE"]		= "|cff00a2ffKey settings changes have been saved.|r"
L["BIND_ESC"]		= "|cffff9900Changes to key settings have been canceled.|r"

L["gbank"] 	= GUILD_BANK
L["bags"] 	= BAGSLOT
L["bank"] 	= BANK
L["regs"] 	= REAGENT_BANK

---------------------------------------------

L["SCIP_VIDEO"] = "|cffffff00Autoquest: |cff00ffff I missed the awesome video, what a pity ... |r"
L["DONT_SHIFT"] = "|cff666666 (do not forget about Shift when contacting NPC)|r"
L["MAKE_CHOICE"] = "|cffff0000Select the award yourself somehow...|r"

L["Y_STATUS"] = "Your Status:"
L["Y_STATUS_DC"] = "Your Status: Not Finished"
L["Y_STATUS_C"] = "Your Status: Completed"

L["CLASS"] = "Class"
L["BAG"] = "Bag"
L["BANK"] = "Bank"
L["TOTAL"] = "Total"

L["Expand"] 	= "Expand"
L["Collapse"] 	= "Collapse"
L["Sound"] 	= "Sound"
L["Sound_OFF"] 	= "Disable sound until the next entry into the game."
L["Close"] 	= "Close"
L["Close_OFF"] 	= "Close CTA until the next entry into the game.\n(You can re-run from the addon settings menu)"
L["Role"] = "Role:"
L["Not enough"] 	= "Not enough:"
L["In the queue"] 	= "In the queue:"
L["Waiting"] 	= "Waiting:"
L["HRENDOM"] 	= "Heroic random"

L["MAP_CURSOR"] = "Cursor: "
L["MAP_BOUNDS"] = "Outside the map!"

L["Bagzy and banksy"]	= "Bagzy and banksy"
L["Busy"] 	= "Busy"
L["Free"] 	= "Free"
L["Friends"] 	= "Friends"

L["For the game"] 	= "For the game: "
L["Received"] 	= "Received:"
L["Spent"] 	= "Spent:"
L["Loss"] 	= "Loss:"
L["Profit"] 	= "Profit:"
L["General information"] 	= "General information: "

L["Fog of war"] = "Fog of war"

L["JUNKSOLD"] 	= "Junk sold, earned:"
L["REMONT"] 	= "Repaired:"
L["NOMONEY"] 	= "|cffff0000Where is the money, Lebowski ?! There is no money even for repairs! You have played all my life !!!!!"

L["Left"] 	= "Left:"
L["Collected"] 	= "Gathered:"
L["Rest"] 	= "Rest:"
L["Totals"] 	= "Total:"

L["LEVEL"] 	= "Level: "
L["CANLEARN"] 	= "Can learn"
L["features"] 	= "features."

L["instead"] 	= " instead "
L["put on"] 	= "|cffff0000After combat wear it: |r"
L["weared"] 	= "|cffff0000Weared: |r"
L["can change"] 	= "|cffff0000Can change: |r"
						
L["Money"] 	= "Money"
L["Skill Points"] 	= "Skill Points"
L["Expirience"] 	= "Expirience"
L["Currency"] 	= "Currency"
L["Reward"] 	= "Reward"
L["Choice"] 	= "Choice"
L["Better than"] 	= "Better than"
L["Quest"] 	= "Quest"
L["Your choice"] 	= "Your choice"

L["Spend"] 	= "Spend"
L["myself"] 	= "myself! :)"
L["Pay"] 	= "Pay"
L["this huckster"] 	= "this huckster"
L["Give it to him"] 	= "Give it to him"
L["on"] 	= " on "
L["from"] 	= "from"

L["completion1"] = "Beat the timer for |cff8787ED%s [%s]|r in |cff00ffff%s|r. You were %s ahead of the timer, and missed +2 by %s."
L["completion2"] = "Beat the timer for +2 |cff8787ED%s [%s]|r in |cff00ffff%s|r. You were %s ahead of the +2 timer, and missed +3 by %s."
L["completion3"] = "Beat the timer for +3 |cff8787ED%s [%s]|r in |cff00ffff%s|r. You were %s ahead of the +3 timer."
L["completion0"] = "Timer expired for |cff8787ED[%s] %s|r with |cffff0000%s|r, you were %s over the time limit."


L["Ovirva4zzz"]		= "Overwatch"
L["In MobilApps"]	= "In MobilApps"
L["In Apps"]		= "In Apps"

L["Schedule"] 	= "Schedule"
L["Rewards"] 	= "Rewards"
L["WeekLeader"] = "Week Leaders"

L["EXPEDIT_COMPLETE"] = "And someone has still not closed the expedition weekly..."

ns[1] = L
