class_name TextReference extends Node
#@export_enum("English","Pirate","Spanish","French","German","Greek") var selection : String = "English"

##Gameplay
var state_empowered : String = "#STATE_EMPOWERED"
var item_mote : String = "#ITEM_MOTES"
var item_motes_plural : String = "#PLURAL_MOTES"
var item_bloombulb : String = "#ITEM_BLOOMBULB"
var item_kindling : String = "#ITEM_KINDLING"
var item_tome : String = "#ITEM_TOME"
var item_tome_abyss : String = "#ITEM_TOME_ABYSS"
var item_tome_woods : String = "#ITEM_TOME_WOODS"
var item_tome_town : String = "#TOMETOWN"
var item_get_suffix : String = "#SUFFIX_GET"
var item_bonus_suffix : String = "#SUFFIX_BONUS"
var item_glaze : String = "#ITEM_GLAZE"
var item_glaze_hint : String = "#HINT_GLAZE"
var item_lid : String = "#ITEM_LID"
var item_lid_hint : String = "#HINT_LID"
var stat_intensity : String = "#STAT_INTENSITY"
var stat_capacity : String = "#STAT_CAPACITY"
var stat_efficiency : String = "#STAT_EFFICIENCY"
var suffix_all_time : String = "#SUFFIX_ALL_TIME"
var death_message : String = "#PLAYER_DEATH"
var slain_message : String = "#BOSS_DEATH"
var humanity_message : String = "#ITEM_HUMANITY"
var impostor_message : String = "#IMPOSTOR_DEATH"
var to_gods_wood : String = "#HINT_RETURN_TO_WOODS"
var to_abyss_chasm : String = "#HINT_RETURN_TO_CHASM"
var to_abyss_proper : String = "#HINT_RETURN_TO_ABYSS"
var return_to_town : String = "#HINT_RETURN_TO_TOWN"
var player_rank : String = "#RANK"
var noun_rank : String = "#RANK_1"
var noun_rank_2 : String = "#RANK_2"
var noun_rank_3 : String = "#RANK_3"
var noun_rank_4 : String = "#RANK_4"
var noun_rank_5 : String = "#RANK_5"
var noun_rank_6 : String = "#RANK_6"
var noun_rank_7 : String = "#RANK_7"
var noun_rank_8 : String = "#RANK_8"
var noun_rank_9 : String = "#RANK_9"
var noun_rank_10 : String = "#RANK_10"
var noun_rank_11 : String = "#RANK_11"
var noun_rank_12 : String = "#RANK_12"
var noun_rank_13 : String = "#RANK_13"
var noun_rank_14 : String = "#RANK_14"
var noun_rank_15 : String = "#RANK_15"
var noun_rank_16 : String = "#RANK_16"
var noun_rank_17 : String = "#RANK_17"
var noun_rank_18 : String = "#RANK_18"
var noun_rank_19 : String = "#RANK_19"
var noun_rank_20 : String = "#RANK_20"
var death_description : String = "#CAUSE_OF_DEATH: " 
var death_message_generic : String = "#HAZARD"
## Endless Mode - General
var endless_items : String = "#ITEMS"
var endless_boons : String = "#BOONS"
var menu_endless_level : String = "#LEVEL"
var menu_endless_difficulty : String = "#DIFFICULTY"
var menu_endless_mode = "#ENDLESS_MODE"
var endless_goal : String = "#GOAL:"
var endless_death : String = "#GAMEOVER"
var endless_enter_maze : String = "#ENTER
MAZE"
var endless_chest : String = "#LOCKED_CHEST"
var endless_bowl : String = "#MOTE_BASIN"
var endless_ascension : String = "#DIFFICULTY_UP"
var endless_ruler_alert : String = "#!!MAZE_RULER_INBOUND!!"
var endless_cure_scroll_positive = "#CURE_SUCCESSFUL"
var endless_cure_scroll_negative = "#CURE_HAD_CONSEQUENCES"


## Endless - Items
var endless_item_junk : String = "#SHARDS"
var endless_item_glaze : String = "#FLASHBOOST"
var endless_item_humanity : String = "#CURE_SCROLL"
var endless_item_key : String = "#SMALLKEY"
var endless_bloombulb_desc : String = "#+CAPACITY"
var endless_glaze_desc : String = "#+FLASHDAMAGE"
var endless_humanity_desc : String = "#+FULLHEAL
+UNDOES CURSES"
var endless_key_desc : String = "#+OPENS_CHEST"
var endless_kindling_desc : String = "#+INTENSITY"
var endless_lid_desc : String = "#DOUSING
IMMUNITY"
var endless_junk_desc : String = "#HEAL_1HP"
var endless_tome_desc: String = "#+EFFICIENCY"
var endless_item_teddybear : String = "#TEDDYBEAR"
var endless_teddybear_desc : String = "#PACIFIES
UNDEAD"
var endless_rare_bulb : String = "#BIG_BLOOMBULB"
var endless_rare_bulb_desc : String = "#CAPACITY_+3"
var endless_rare_tome : String = "#GRIMOIRE"
var endless_rare_tome_desc : String = "#EFFICIENCY_+2"
var endless_rare_scale : String = "#CHIMERA_SCALE"
var endless_rare_scale_desc : String = "#INTENSITY +3
+ FIRE IMMUNITY
+ ICE IMMUNITY"

## Endless - Boons / Curses
var endless_sun_boon : String = "#AURAEL'S_BOON"
var endless_sun_desc : String = "#MOTE_GAIN_DOUBLED"
var endless_mercury_boon : String = "#HARUME'S_BOON"
var endless_mercury_desc : String = "#MORE_MOTES
#MORE_SPEED"
var endless_venus_boon : String = "#VENOCH'S_BOON"
var endless_venus_desc : String = "#ENABLES_REPEAT
SHOP_ITEMS"
var endless_moon_boon : String = "#LAILUN'S_BOON"
var endless_moon_desc : String = "#SHOP_DISCOUNT"
var endless_mars_boon : String = "#MARUME'S_BOON"
var endless_mars_desc : String = "#LENGTHEN_ENEMY_HITSTUN"
var endless_jupiter_boon : String = "#JOVIEL'S_BOON"
var endless_jupiter_desc : String = "#PREVENT_DEATH_ONCE"
var endless_jupiter_resurrection : String = "#JUPITER_ASCENSION_TRIGGERED"
var endless_saturn_boon : String = "#SAMAEL'S_CURSE"
var endless_saturn_desc : String = "#-MAZE_GUARDIANS_SPAWN_FASTER
+ ONE_FEWER_MAZE_GUARDIAN"
var endless_void_boon : String = "#VOID'S_CURSE"
var endless_void_desc : String = "#-DAMAGE_REMOVES_EMPOWERED_STATE
+ LESS_MOTES_REQUIRED_FOR_EMPOWERED_STATE"

##Menus
var menu_paused : String = "#MENU_PAUSED"
var menu_return_to_menu : String = "#MENU_RETURN"
var menu_quit_to_desktop : String = "#MENU_QUIT"
var menu_continue : String = "#MENU_CONTINUE"
var menu_quit_consent : String = "#MENU_QUIT_CONSENT"
var menu_quit_consent_add : String = "#MENU_QUIT_WARNING"
var menu_new_game : String = "#MENU_NEW_GAME"
var menu_save_1 : String = "#MENU_SAVE_1"
var menu_save_2 : String = "#MENU_SAVE_2"
var menu_save_3 : String = "#MENU_SAVE_3"
var menu_delete_save_consent : String = "#MENU_DELETE_CONSENT"
var menu_delete_save_consent_add : String = "#MENU_DELETE_WARNING"
var menu_confirm : String = "#MENU_CONFIRM"
var menu_deny : String = "#MENU_DENY"
var menu_completion : String = "#MENU_COMPLETION"
var menu_options : String = "#MENU_OPTIONS"
var menu_language : String = "#MENU_LANGUAGE"
var menu_display : String = "#MENU_DISPLAY"
var menu_music : String = "#MENU_MUSIC"
var menu_sfx : String = "#MENU_SFX"
var menu_mute : String = "#MENU_MUTE"
var menu_no_data : String = "#MENU_NEW_GAME"
var menu_simple_mode : String = "#MENU_SIMPLE_MODE"
var menu_simple_mode_desc : String = "#MENU_SIMPLE_MODE_HINT"
var menu_decision_consent : String = "#MENU_ACCEPT_DENY"
var menu_player_location = "#MENU_CURRENT_LOCATION: "

func language_set(language : String):
	GameState.language = language
	match language:
		"English":
			state_empowered = "EMPOWERED"
			item_mote = "Mote"
			item_motes_plural = "Motes"
			item_bloombulb = "Bloombulb"
			item_kindling = "Kindling"
			item_tome = "Tome"
			item_tome_abyss = "Acolyte's Tome"
			item_tome_woods = "Faithful's Tome"
			item_tome_town  = "Forsaken's Tome"
			item_get_suffix = "Acquired"
			item_bonus_suffix = "Bonus"
			item_glaze = "Ceramic Glaze"
			item_glaze_hint = "Use Flash 
			by pressing F (Keyboard) 
            / Right Button (Gamepad)"
			item_lid = "Lid of Sealing"
			item_lid_hint = "Preserve some motes
			between lives,
			on occasion"
			stat_intensity = "Intensity"
			stat_capacity = "Capacity"
			stat_efficiency = "Efficiency"
			suffix_all_time = "All-Time"
			death_message = "VESSEL SHATTERED"
			humanity_message = "HUMANITY GAINED"
			slain_message = "FLAWED VESSEL DESTROYED"
			impostor_message = "SHADOW PURIFIED"
			to_gods_wood = "To Gods' Grove"
			to_abyss_chasm = "Return to Chasm"
			to_abyss_proper = "Return to Abyss"
			return_to_town = "Return to Church Town"
			player_rank = "Level"
			noun_rank = "Clay Lump"
			noun_rank_2 = "Flawed Vessel"
			noun_rank_3 = "Unfinished Vessel"
			noun_rank_4 = "Chamberpot"
			noun_rank_5 = "Spittoon"
			noun_rank_6 = "Kettle"
			noun_rank_7 = "Jar"
			noun_rank_8 = "Pot"
			noun_rank_9 = "Glazed Pot"
			noun_rank_10 = "Vase"
			noun_rank_11 = "Urn"
			noun_rank_12 = "Amphora"
			noun_rank_13 = "Cauldron"
			noun_rank_14 = "Hot-pot"
			noun_rank_15 = "Black Kettle"
			noun_rank_16 = "Reliquary"
			noun_rank_17 = "Cracked Pot"
			noun_rank_18 = "Greatjar"
			noun_rank_19 = "Sepulcher"
			noun_rank_20 = "Perfect Vessel"
			death_description = "Vessel was shattered by " 
			death_message_generic = "the hand of Fate"
			menu_endless_mode = "Endless Mode"
			##Endless Mode
			endless_items = "Items"
			endless_boons = "Blessings and Curses"
			menu_endless_level = "Level"
			menu_endless_difficulty = "Difficulty"
			endless_goal = "Goal:"
			endless_death = "GAME OVER"
			endless_enter_maze = "Enter
			Maze"
			endless_chest = ""
			endless_bowl = ""#"Motebasin"
			endless_item_junk = "Vessel Shards"
			endless_item_glaze = "Extra Coat"
			endless_item_humanity = "Restorative Scroll"
			endless_item_key = "Key"
			endless_bloombulb_desc = "Increases
			Capacity"
			endless_glaze_desc = "Boosts Flash
			Damage by 1"
			endless_humanity_desc = "-RARE-
			Restores all HP and dispels Curses, but may misfire"
			endless_key_desc = "May open a lock"
			endless_kindling_desc = "Increases 
			Intensity"
			endless_lid_desc = "Prevents dousing"
			endless_junk_desc = "Restores HP"
			endless_tome_desc = "Increases
			Efficiency"
			endless_item_teddybear = "Mr. Bjorn"
			endless_teddybear_desc = "Decreases undead aggression"
			endless_rare_bulb = "Big Bloombulb"
			endless_rare_bulb_desc = "-RARE-
			Capacity +3"
			endless_rare_tome = "Grimoire"
			endless_rare_tome_desc = "-RARE-
			Efficiency +2"
			endless_rare_scale = "Chimera Scale"
			endless_rare_scale_desc = "-RARE-
			Intensity +3 
			Fire Immunity 
			Ice Immunity"
			endless_sun_boon = "Blessing of Aurael"
			endless_sun_desc = "All mote gain is doubled"
			endless_mercury_boon = "Blessing of Harume"
			endless_mercury_desc = "Increased speed gain from collected motes"
			endless_venus_boon = "Blessing of Venoch"
			endless_venus_desc = "Find duplicates of shop items, on occasion"
			endless_moon_boon = "Blessing of Lailun"
			endless_moon_desc= "All shop items are 50% cheaper"
			endless_mars_boon= "Blessing of Marume"
			endless_mars_desc= "Enemies take more hitstun"
			endless_jupiter_boon = "Blessing of Joviel"
			endless_jupiter_desc = "Prevent death once"
			endless_jupiter_resurrection = "Joviel's boon prevented death and was used up"
			endless_saturn_boon = "Curse of Samael"
			endless_saturn_desc = "Maze Guardians spawn faster
			One less Maze Guardian per maze"
			endless_void_boon = "Curse of the Void"
			endless_void_desc = "Taking damage removes empowered state
			Efficiency Boost"
			endless_ascension = "Enemies strengthened"
			endless_ruler_alert = "!! MAZE RULER INCOMING !!"
			endless_cure_scroll_positive = "The Curative Scroll dispelled all curses"
			endless_cure_scroll_negative = "The Scroll dispelled curses, and a boon"

			##Menus
			menu_paused = "Game Paused"
			menu_return_to_menu = "Return to Menu"
			menu_quit_to_desktop = "Quit Game"
			menu_continue = "Continue"
			menu_quit_consent = "Are you sure you want to quit?"
			menu_quit_consent_add = "Unsaved progress will be lost."
			menu_new_game = "New Game"
			menu_save_1 = "Save Slot 1"
			menu_save_2 = "Save Slot 2"
			menu_save_3 = "Save Slot 3"
			menu_delete_save_consent = "Delete save data?"
			menu_delete_save_consent_add = "Game progress will be reverted back to its default state."
			menu_confirm = "Yes"
			menu_deny = "No"
			menu_completion = "Game Complete"
			menu_options = "Options"
			menu_language = "Language"
			menu_display = "Display"
			menu_music = "Music"
			menu_sfx = "SFX"
			menu_mute = "Mute"
			menu_no_data = "No Data"
			menu_simple_mode = "Easy Mode"
			menu_simple_mode_desc = "Enemies deal less damage and have less HP"
			menu_decision_consent = "Your choice may affect gameplay. Continue?
Enter (Keyboard) / Bottom Button (Gamepad): Confirm
Escape (Keyboard) / Left Button (Gamepad): Go Back"
			menu_player_location = "Current Location:"

		"Pirate": ##Test implementation
			state_empowered = "AFLAME"
			item_mote = "Wisp"
			item_motes_plural = "Wisps"
			item_bloombulb = "Fruit o'-the-bloom"
			item_kindling = "Bundle-o'-sticks"
			item_tome = "Leatherbound Volume"
			item_tome_abyss = "Book o' the Deep"
			item_tome_woods = "Book o' the Old Ones"
			item_tome_town  = "Book o' the Wretched"
			item_get_suffix = "Plundered"
			item_bonus_suffix = "Bonanza"
			item_glaze = "Peg-Leg Polish"
			item_glaze_hint = "Dazzle foes with a Flash of ghostly light"
			item_lid = "Chamberpot Cover"
			item_lid_hint = "Lose naught but a pittance of Wisps upon capcisin', on occasion"
			stat_intensity = "Flameswell"
			stat_capacity = "Cargo Room"
			stat_efficiency = "Seaworthiness"
			suffix_all_time = "According to Legend"
			death_message = "VESSEL CAPSIZED"
			humanity_message = "MAIDEN'S FAVOR GAINED"
			slain_message = "FOE PLUNDERED"
			impostor_message = "BILGE-RAT SCOURED"
			to_gods_wood = "Sail to God's Tinderbox"
			to_abyss_chasm = "Sail to Briny Deep"
			to_abyss_proper = "Sail to Cave of Angels"
			return_to_town = "Sail to Port"
			player_rank = "Vessel Quality"
			noun_rank = "Piss-poor"
			noun_rank_2 = "Decent"
			noun_rank_3 = "Servicable"
			noun_rank_4 = "Fine"
			noun_rank_5 = "Well-worn"
			noun_rank_6 = "Polished"
			noun_rank_7 = "Reinforced"
			noun_rank_8 = "De-barnacled"
			noun_rank_9 = "Re-upholstered"
			noun_rank_10 = "Shimmering"
			noun_rank_11 = "Ironclad"
			noun_rank_12 = "Gilded"
			noun_rank_13 = "Illuminated"
			noun_rank_14 = "Diamond-encrusted"
			noun_rank_15 = "Legendary"
			noun_rank_16 = "Otherwordly"
			noun_rank_17 = "Fit for a King"
			noun_rank_18 = "Gob-smacking"
			noun_rank_19 = "Nigh-unbelievable"
			noun_rank_20 = "Sheer Perfection"
			death_description = "Keelhauled by " 
			death_message_generic = "Lady Luck"
			## Endless Mode
			endless_items = "Booty"
			endless_boons = "Divine Bestowals"
			menu_endless_mode = "Voyage Mode"
			menu_endless_level = "Trial"
			menu_endless_difficulty = "Wrath"
			endless_goal = "Toll:"
			endless_death = "VOYAGE END"
			endless_enter_maze = "Enter
			Labyrinth"
			endless_chest = ""
			endless_bowl = ""#"Dreg Bowl"
			endless_item_junk = "Broken Bits"
			endless_item_glaze = "Vessel Polish"
			endless_item_humanity = "Devil's Deal"
			endless_item_key = "Skeleton
			Key"
			endless_bloombulb_desc = "Cargo Room Up"
			endless_glaze_desc = "Ghostly light be more deadly"
			endless_humanity_desc = "Makes Vessel like new and banishes maladies, but beware…"
			endless_key_desc = "Unlock Treasure Chests"
			endless_kindling_desc = "Flameswell Up"
			endless_lid_desc = "Preserve some wisps between voyages"
			endless_junk_desc = "Repairs vessel"
			endless_tome_desc = "Seaworthiness Up"
			endless_item_teddybear = "Night's Friend"
			endless_teddybear_desc = "Wrathful spirits be less ornery"
			endless_rare_bulb = "Hearty Bloom-fruit"
			endless_rare_bulb_desc = "-RARE-
			Cargo Room +3"
			endless_rare_tome = "Grimoire"
			endless_rare_tome_desc = "-RARE-
			Seaworthiness +2"
			endless_rare_scale = "Chimera Scale"
			endless_rare_scale_desc = "-RARE-
			Flameswell +3
			+ Flame Guard
			+ Chill Guard"
			endless_sun_boon = "Sun's Boon"
			endless_sun_desc = "All mote gain is doubled"
			endless_mercury_boon = "Mercury's Boon"
			endless_mercury_desc = "Increased speed gain from collected motes"
			endless_venus_boon = "Venus' Boon"
			endless_venus_desc = "Find duplicates of shop items, on occasion"
			endless_moon_boon = "Moon's Boon"
			endless_moon_desc= "All shop items are 50% cheaper"
			endless_mars_boon= "Mars' Boon"
			endless_mars_desc= "Enemies take more hitstun"
			endless_jupiter_boon = "Jove's boon"
			endless_jupiter_desc = "Prevent death once"
			endless_jupiter_resurrection = "Jove's boon prevented death and was used up"
			endless_saturn_boon = "Saturn's Wrath"
			endless_saturn_desc = "Labyrinth Guards spawn faster
			One less Labyrinth Guard"
			endless_void_boon = "Wrath of the Deep"
			endless_void_desc = "Taking damage removes empowered state"
			endless_ascension = "Enemies strengthened"
			endless_ruler_alert = "!! LABYRINTH RULER INCOMING !!"
			endless_cure_scroll_positive = "Devil's Deal banished curses"
			endless_cure_scroll_negative = "Devil's Deal banished curses, and a boon"
			
			##Menus
			menu_paused = "Ship'
            Anchored"
			menu_return_to_menu = "Abandon Ship"
			menu_quit_to_desktop = "Return to Port"
			menu_continue = "Go On"
			menu_quit_consent = "End your days on the seven seas?"
			menu_quit_consent_add = "Anythin' not saved will be lost."
			menu_new_game = "New Journey"
			menu_save_1 = "Journey 1"
			menu_save_2 = "Journey 2"
			menu_save_3 = "Journey 3"
			menu_delete_save_consent = "Erase sailing logs?"
			menu_delete_save_consent_add = "Progress thus far will be reverted."
			menu_confirm = "Aye"
			menu_deny = "Nay"
			menu_completion = "Journey Complete"
			menu_options = "Rigging"
			menu_language = "Verbiage"
			menu_display = "Dimensions"
			menu_music = "Shanties"
			menu_sfx = "Squawkin'"
			menu_mute = "Silence"
			menu_no_data = "No Record"
			menu_simple_mode = "Landlubber Mode"
			menu_simple_mode_desc = "Enemies are less hardy; Yer vessel be more sturdy."
			menu_decision_consent = "Decide now, and ye fate shall be sealed for good.
Enter (Keyboard) / Bottom Button (Gamepad): Confirm
Escape (Keyboard) / Left Button (Gamepad): Go Back"
			menu_player_location = "Heading:"

func new_game_plus_consent():
	match GameState.language:
		"English":
			DecisionSelect.decision_prompt("Start New Game+? Enemies are stronger and more plentiful, driven to rage by Samael's flame. Items will be kept.","Yes (NG+)","No (Restart Game)","ContinueGame", true)
		"Pirate": ##Test implementation
			DecisionSelect.decision_prompt("Begin quest anew? Demonic fire spurs monsters to march on the land, but yer loot will be kept.","Aye (NG+)","Naw (Restart Game)","ContinueGame", true)

#Endless Mode Mote Basin
func mote_basin_interface(line, balance):
	match line:
		"Interact":
			DecisionSelect.decision_prompt("You approach the mote basin.
			Balance: "+str(int(balance))+"
			Select an option:","Deposit all
			motes","Withdraw all
			motes","EndlessMoteBasin", false)
		"Deposit":
			Dialogue.openDialogue("Motes deposited.
			Current balance: "+str(int(balance)), "none", 50, false)
		"Withdraw":
			Dialogue.openDialogue("Motes withdrawn.
			The basin is now empty.
			"+str(int(balance))+" motes gained.","none", 50, false)

##Dialogue
func reference_dialogue(line):
	var TextSpeedBase : float = 3
	var TextSpeedFast : float = 3
	var TextSpeedSlow : float = 2.5
	var TextSpeedVeryFast : float = 6
	
	match line:
		##Gameplay Hints
		"NGAdjust":
			DecisionSelect.decision_prompt("Adjust difficulty?
Current value: NG+"+str(GameState.newgame),"
			Reduce NG by 1","
			Increase NG by 1","NGAdjust",true)
		"NGResult": 
			Dialogue.openDialogue("* NG+ level adjusted. 
New value: "+str(GameState.newgame), "none",TextSpeedVeryFast,false)
		"NGNoOption":
			Dialogue.openDialogue("* No effect. The sword awaits a greater challenge.
(Disabling NG+ is not permitted)", "none",TextSpeedVeryFast,false)

		
		"SleepingSerpent": 
			Dialogue.openDialogue("* (A brumating serpent blocks the passageway.) 
            
			* (It would be rude to awaken it…)", "player",TextSpeedBase,false)
		"NPCWaiting":
			Dialogue.openDialogue("* (Seems as if they're waiting for something…) 
            
			* (I should explore more, maybe I'll find something they like.)", "player",TextSpeedBase,false)
		"SanctuaryDecline":
			Dialogue.openDialogue("* I should check with Jari, Zenith, and Nadir, to make sure I'm in prime shape before entering.
			(You may talk with the Sculptor again to enter the Sanctuary once ready.)", "player",TextSpeedBase,false)
		"GameFlash":
			Dialogue.openDialogue("You got the Ceramic Glaze! 
			When Empowered, press F (Keyboard) / Right Button (Gamepad) to damage enemies and reveal secrets in the current room. Collect items to enhance your Flash ability further.", "tip", TextSpeedSlow, false)
		"BellTollSilver":
			DecisionSelect.decision_prompt("Pay toll and ring the Argent Bell?
			Required Motes:"+str(GameState.silver_toll),"Accept","Decline","RingBellSilver", false)
		"BellTollGold":
			DecisionSelect.decision_prompt("Pay toll and ring the Ochre Bell?
			Required Motes:"+str(GameState.gold_toll),"Accept","Decline","RingBellGold", false)
		"BellInsufficientMotes":
			Dialogue.openDialogue("Insufficient motes.", "none", TextSpeedFast, false)
		"EndlessWarning":
			DecisionSelect.decision_prompt("It's recommended to have completed Vessoul at least once before playing Endless Mode. Continue Anyway?
			","Go Back","Continue","EndlessModeWarning", false)
		"EndlessKeyRequired":
			Dialogue.openDialogue("Small Key required.", "none", TextSpeedFast, false)
		## Barrelby - Endless Mode
		"BarrelbyNoMotes": 
			Dialogue.openDialogue("* Come back when ya' get some more motes, small fry!", "barrelby_serious", TextSpeedBase, false)
		"Barrelby1": 
			Dialogue.openDialogue("* Meowdy! Say, have you ever tried ramming into small enemies while powered up? Give it a try sometime!", "barrelby", TextSpeedBase, false)
		"Barrelby2": 
			Dialogue.openDialogue("* Glaze not in stock? Yellow motes will appear in the maze, and emit a weak flash when collected; this flash doesn't scale with your Intensity, though.", "barrelby", TextSpeedBase, false)
		"Barrelby3": 
			Dialogue.openDialogue("* Be sure to hurry when traversing the maze, or else the Maze Guardians will appear and chase you down. Using Flash will slow them down, if for a moment.", "barrelby", TextSpeedBase, false)
		"Barrelby4": 
			Dialogue.openDialogue("* Don't take too long, meow… the Maze Ruler doesn't take kindly to intruders. One touch will be the end of you, regardless of your boons or your Capacity!", "barrelby_serious", TextSpeedBase, false)
		"Barrelby5": 
			Dialogue.openDialogue("* See that chest down there? Legends say it's blessed by a divine force… you'll have to buy a key to know for sure, though!", "barrelby", TextSpeedBase, false)
		"Barrelby6": 
			Dialogue.openDialogue("* Got a few extra motes? Toss em' in the bowl over there! When you come back, you may find the number has grown!", "barrelby_laugh", TextSpeedBase, false)
		"Barrelby7": 
			Dialogue.openDialogue("* You've met my sister, Jari, haven't you? Yup, we're thick as thieves, but this tumbleweed was born to roam!", "barrelby", TextSpeedBase, false)
		"Barrelby8": 
			Dialogue.openDialogue("* Every few mazes you complete will increase the difficulty of future mazes. Enemies will deal more damage, and Maze Guardians and the Maze Rulers will be faster, and take less hit-stun.", "barrelby", TextSpeedBase, false)
		"Barrelby9": 
			Dialogue.openDialogue("* Maze Guardians don't like being flashed, and they'll chase you down aggressively for a while afterwards. Be careful!", "barrelby_serious", TextSpeedBase, false)
		"Barrelby10":
			Dialogue.openDialogue("* Curses got you down? A Curative Scroll will remove curses, but those dubious incantations may result in you losing a boon, too.", "barrelby_serious", TextSpeedBase, true)
		
		##Jari
		"JariUpgradeGeneric": 
			Dialogue.openDialogue("* A bloombulb!? Yes, yes! Thank you! Oh, you've made me the happiest cat in all the Innerlands! (Your Capacity increased.)", "jari", TextSpeedFast, false)
		"JariIntro": 
			Dialogue.openDialogue("* "+"Is someone there? I feel a warmth… Say, might you have a Bloombulb? In exchange for one, I'd happily teach you some of my secrets.","jari",TextSpeedBase, false)
		"JariBloombulbReminder": 
			Dialogue.openDialogue("* Ah, bloombulbs! Nothing in this world makes me happier than when I get my paws on one… such velvety smoothness, such warmth!","jari",TextSpeedFast, false)
		"JariThanks": 
			Dialogue.openDialogue("* "+"Oh, splendid, thank you kindly! In turn, I shall teach you a few tricks to increase the capacity of your vessel. (Your Capacity increased.)","jari",TextSpeedBase, false)
		"JariAmphoraDefeated": 
			Dialogue.openDialogue("* "+"Hmm, it seems my neighbor the Amphora has gone quiet. It never was the friendly sort…","jari_sad",TextSpeedBase, false)
		"JariAbyssPresenceDefeated": 
			Dialogue.openDialogue("* "+"Ah, it feels as though a shadow has lifted from this place. I sense a new presence stirring… Perhaps you should return to your place of origin, for old times' sake.","jari",TextSpeedBase, false)
		"JariGodsWood": 
			Dialogue.openDialogue("* "+"Ah, yes, the Gods' Grove… it used to be a lively place. But now, only spirits and shadows reside there… a sad fate.","jari_sad",TextSpeedBase, false)
		"JariGrowthDefeated": 
			Dialogue.openDialogue("* "+"Once, Samael took a large pumpkin to make into my vessel. But when I left to gather bloombulbs, I found a menacing shadow had moved in… so, now I’m here!","jari",TextSpeedBase, false)
		"JariChurchTown": 
			Dialogue.openDialogue("* "+"Church Town…? Oh no, that place is far too bustling for me. Samael’s servants are always a-clamor. No, I prefer the dark quietude of the Abyss.","jari_sad",TextSpeedBase, false)
		"JariPraise": 
			Dialogue.openDialogue("* Oh, hello. You know, I have become quite fond of your company… Samael should be proud of his handiwork! May I…?
			(Jari reaches a paw out and pats your Vessel.) Yes, quite robust indeed!","jari",TextSpeedBase, false)
		"JariMotivational": 
			Dialogue.openDialogue("* Samael has created many vessels in his time, but you are unlike the rest. Dare I say, you seem nearly… human? Oh, perish the thought. Samael is not too fond of humans…","jari",TextSpeedBase, false)
		"JariCompletion": 
			Dialogue.openDialogue("* "+"Ah, yes! Excellent! Much thanks, humble vessel! I shall never want for a Bloombulb again… but… if you have more… I shan't decline!","jari",TextSpeedBase, false)
		
		##Zenith/Nadir
		"ZNKindlingReminder":
			Dialogue.openDialogue("(The dragon looks you over, visibly disappointed at your bland olfactory quality.)
            
			(Perhaps you should come back once you've found more kindling.)","player",TextSpeedBase, false)
		"ZNUpgradeGeneric": 
			Dialogue.openDialogue("(Smelling the Kindling within you, the dragon bellows out a jet of flame, reducing it to cinders. Your Intensity increased. The dragon seems to crack a smile at the scent…)","player",TextSpeedBase, false)
		"ZenithIntro": 
			Dialogue.openDialogue("* "+"I thought I smelled an ember. Samael’s creations yet toil in this dark… Fragile vessel, know this: my kind and kindling are of a piece…","zenith",TextSpeedFast, false)
		"ZenithIntroAlt":
			Dialogue.openDialogue("* "+"Halt, vessel. That scent… you possess the kindling of auld. Allow me to ignite it, and bolster your flame.
			(Zenith bathes you in warm flames. Your Intensity increased.)","zenith",TextSpeedBase, false)
		"NadirIntro": 
			Dialogue.openDialogue("* "+"Hmm… another dim light glows yet. Samael toils ever on… perhaps this creature of mud will bring his salvation? Be useful, and provide kindling, earthen slave…","nadir",TextSpeedSlow, false)
		"NadirIntroAlt":
			Dialogue.openDialogue("(You approach, and Nadir abruptly blasts you with flame, causing your held Kindling to ignite. Your Intensity increased.)
			* That scent… how my blood boils! Bring more kindling, I demand it!"+"","nadir",TextSpeedBase, false)
		"ZenithRetort": 
			Dialogue.openDialogue("* "+"I see you’ve met my twin. Yes, since birth, he and I have been as one. Truly, I try not to fault him, but his ceaseless negativity can be quite taxing. Oh, there he is now…","zenith_contemplative",TextSpeedFast, false)
		"NadirRetort": 
			Dialogue.openDialogue("* "+"Bah, don’t listen to my sister. She maintains an unshakable ignorance of worldly affairs. My perspective is grounded in reality, not ideals. Until next time, fragile vessel.","nadir",TextSpeedSlow, false)
		"ZenithAbyssPresence":
			Dialogue.openDialogue("* "+"Be wary, vessel. A dark presence looms ahead. A dangerous and unpredictable creature, created by none other than your own master. The purest of light will drive it out, undoubtedly.","zenith", TextSpeedFast, false)
		"NadirAbyssPresence":
			Dialogue.openDialogue("* "+"Samael's creations possess the gift of vision. However, one peered out, and fearing what it saw, withdrew. Now, the shadows have become an extension of itself. An ill portent…","nadir", TextSpeedFast, false)
		"ZenithGodsWood": 
			Dialogue.openDialogue("* "+"Allow me to confide in thee. There was a time when the denizens of this land lived in peace, until an embittered fool thrust it into chaos… Be on your guard. Farewell.","zenith",TextSpeedFast, false)
		"NadirGodsWood": 
			Dialogue.openDialogue("* "+"The natural state of all life is chaos. Those who once inhabited this land thought themselves above the natural order. Their foolishness was dealt with in turn. Do not mourn them.","nadir",TextSpeedSlow, false)
		"ZenithChurchTown": 
			Dialogue.openDialogue("* "+"We meet again. How your flame surges now… you have grown much. However, you are but a lamb… ignorant to the reality of your state. Find yourself, and be true.","zenith",TextSpeedFast, false)
		"NadirChurchTown":
			Dialogue.openDialogue("* "+"Earthen vessel; I would impart upon thee a lesson. You must abandon your sense of self. A higher calling awaits. Be willing to serve your creator, regardless of the outcome. For that is your purpose.","nadir_contemplative",TextSpeedSlow, false)
		
			##Samael/Sculptor
		"SculptorUpgradeGeneric":
			Dialogue.openDialogue("(Samael pores over the works you've collected, before waving his gloved hand and uttering an incantation. Your Efficiency increased.)","sculptor",TextSpeedBase,false)
		"SculptorIntro": 
			Dialogue.openDialogue("* "+"Welcome, my creation. You're looking well. Might you fetch me my tome? I was imbuing my Amphora with an enchantment, and I must have left my tome behind. Silly me…" ,"sculptor",TextSpeedBase,false)
		"SculptorRemindAmphora": 
			Dialogue.openDialogue("* "+"My tome, please. You may find it in the next room. However, you may need to gather more motes before then. Hurry, now. It's much needed for the task at hand…" ,"sculptor",TextSpeedFast,false)
		"SculptorAmphoraDefeated": 
			Dialogue.openDialogue("* Impressive, very impressive. The time has come for you to prove your mettle. When you have finished your work here, enter the dark swirl in Amphora's chamber. Your true test awaits…","sculptor",TextSpeedBase,false)
		"SculptorRemindAbyssal": 
			Dialogue.openDialogue("* "+"Hello again. Have you met my good friend Jari? She is quite full of secrets. Find her, and she may aid you.","sculptor",TextSpeedBase,false)
		"SculptorAbyssalDefeated": 
			Dialogue.openDialogue("* "+"Good, good. The creature you encountered… a sad, malformed thing, it was. You've done us both a favor by dispatching it.","sculptor",TextSpeedBase,false)
		"SculptorAbyssalDefeated2": 
			Dialogue.openDialogue("* "+"At one point, I spent much of my time in the Abyss, honing my craft. The creature you just faced… It was my first creation.","sculptor",TextSpeedBase,false)
		"SculptorAbyssalDefeated3": 
			Dialogue.openDialogue("* "+" Doing so enlightened me to the unique properties of abyssal earth, and the unseen force that would draw spiritual essence down into its depths.","sculptor",TextSpeedBase,false)
		"SculptorAbyssalDefeated4": 
			Dialogue.openDialogue("* "+"But, my creation was misbegotten… flawed. And now, it can rest. And you and I… we're onto greater things, aren't we?","sculptor",TextSpeedBase,false)
		"SculptorGodsWood": 
			Dialogue.openDialogue("* "+"Ah yes, the Gods' Grove. Its peaceful tranquility brings me much joy… a marked improvement from the dank depths. How I do so enjoy the sunshine…","sculptor",TextSpeedBase,false)
		"SculptorGodsWood2": 
			Dialogue.openDialogue("* "+"Once you're through seeing the sights, a tome of mine is in storage nearby, if you'd be so kind as to retrieve it for me…","sculptor",TextSpeedBase,false)
		"SculptorGodsWood3": 
			Dialogue.openDialogue("* "+"Also, I ought to mention; to enter Church Town, you must have the key. It just so happens that said key is embedded in a giant orange abomination’s head. Best of luck to you, dear vessel.","sculptor",TextSpeedBase,false)
		"SculptorGrowthDefeated": 
			Dialogue.openDialogue("* "+"Excellent, excellent! You truly are my finest work. Now that you’ve obtained the key, you may pass freely between this wood and the Church Town.","sculptor",TextSpeedBase,false)
		"SculptorChurchTown": 
			Dialogue.openDialogue("* "+"Welcome, Vessel. This town has become my home during my time in this realm. Though, it was rather quiet prior to my settling here…","sculptor",TextSpeedBase,false)
		"SculptorChurchTown2": 
			Dialogue.openDialogue("* "+"The cowled figures in this place are my creations, the Motebearers. Though, in truth, they’re mere puppets compared to you. They don't have quite the same… spark.","sculptor",TextSpeedBase,false)
		"SculptorChurchTown3": 
			Dialogue.openDialogue("* "+"I apologize for the inconvenience, but you'll need to ring both bells in order to enter the Sanctuary. I hope you saved up on Motes…","sculptor",TextSpeedBase,false)
		"SculptorBellsRetrieved": 
			Dialogue.openDialogue("* "+"Good, good. Ah yes, how I love to hear them ring out! Now, let us proceed, shall we?","sculptor",TextSpeedBase,false)
		"SculptorEnterSanctuary":
			DecisionSelect.decision_prompt("Enter the Sculptor's Sanctuary? You will be unable to leave after entering, and the Sculptor will no longer accept Tomes or provide upgrades.","Enter","Do Not","EnterSanctuary", true)
		"SculptorSanctuary": 
			Dialogue.openDialogue("* "+"You've performed very well, fair vessel. However, you remain incomplete in your current state; this fact must be remedied.","sculptor",TextSpeedBase,false)
		"SculptorSanctuary2": 
			Dialogue.openDialogue("* "+"You are on the precipice of becoming something wonderful, something truly unlike anything of this earth…","sculptor",TextSpeedBase,false)
		"SculptorSanctuary3": 
			Dialogue.openDialogue("* "+"However, to do so, you must shed this weathered, earthen form. You will be vulnerable, but for a moment. However, I have a new vessel for you to occupy. I beg you, trust me.","sculptor",TextSpeedBase,false)
		"SculptorQuestion": 
			Dialogue.openDialogue("* "+"Dear vessel, true greatness awaits you! You shall be perfection personified! All I ask is you allow me to strip you of your cerulean cask… but for a moment. I will use the utmost care.","sculptor_unmask",TextSpeedBase,false)
		"SculptorPrompt": 
			if GameState.favor != 1: #If Lenore's favor not gained
				DecisionSelect.decision_prompt("Give up your vessel?","Yes
				(End Game)","No
				(Continue)","GiveUpSoul",false) #ignore the last part, it's for behind-the-scenes purposes
			else:
				DecisionSelect.decision_prompt("Give up your vessel?","Yes
				(End Game)","No
				(Recommended)", "GiveUpSoul", false)
		"SculptorPlayerAccept": 
			Dialogue.openDialogue("* "+"Good. Now, come closer. Trust in me. This will only hurt for a moment.","sculptor_unmask",TextSpeedBase,false)
		"SculptorPlayerDecline": 
			Dialogue.openDialogue("* "+"… aha. Ha ha ha… a wily one, you are. No matter! You forget, you belong to me. I made you… and I can unmake you.","sculptor_unmask_reject",TextSpeedBase,false)
		"SamaelFlashed": 
			Dialogue.openDialogue("* Infernal creation, cease this foolishness!","samael_anger",TextSpeedFast,true)
		"SamaelFlashed2": 
			Dialogue.openDialogue("* I will snuff out your flame.","samael",TextSpeedBase,true)
		"SamaelFlashed3": 
			Dialogue.openDialogue("* Your existence is meaningless without me!","samael_anger",TextSpeedFast,true)
		"SamaelFlashed4": 
			Dialogue.openDialogue("* BREAK AND SHATTER!!","samael_anger",TextSpeedBase,true)
		"SamaelFlashed5": 
			Dialogue.openDialogue("* Useless, useless.","samael_anger",TextSpeedFast,true)
		"SamaelFlashed6": 
			Dialogue.openDialogue("* GAH!! DIM THAT INCESSANT LIGHT!!","samael_anger",TextSpeedFast,true)
		"SamaelFlashed7": 
			Dialogue.openDialogue("* CEASE YOUR STRUGGLING!", "samael_anger",TextSpeedFast,true)
		"SamaelFlashed8": 
			Dialogue.openDialogue("* Ungrateful whelp.", "samael",TextSpeedBase,true)
		"SamaelFlashed9": 
			Dialogue.openDialogue("* You think I want to do this!? If you had just listened…!", "samael_anger",TextSpeedFast,true)
		"SamaelFlashed10": 
			Dialogue.openDialogue("* ENOUGH!!", "samael_anger",TextSpeedFast,true)
		"SamaelPlayerDefeat":
			Dialogue.openDialogue("* My ascension is at hand.", "samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat2": 
			Dialogue.openDialogue("* Those who have forsaken me… shall burn.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat3": 
			Dialogue.openDialogue("* Thank you. Now, I shall become complete.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat4": 
			Dialogue.openDialogue("* Do you hear it, Ascendants? The bell tolls for thee.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat5": 
			Dialogue.openDialogue("* No longer shall I be shackled to this accursed realm.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat6": 
			Dialogue.openDialogue("* A spirited effort, but all for naught.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat7": 
			Dialogue.openDialogue("* I shall remember thee, fragile vessel. You served me well.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat8": 
			Dialogue.openDialogue("* Ha ha ha… pathetic.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat9": 
			Dialogue.openDialogue("* Return now, to whence you came.","samael_triumph",TextSpeedBase,true)
		"SamaelPlayerDefeat10": 
			Dialogue.openDialogue("* Be shrouded, once again, in darkness.","samael_triumph",TextSpeedBase,true)
		
		##Samael Reveal/Pre Battle
		"SamaelReveal":
			Dialogue.openDialogue("* I believe you and I are well past the point of pleasantries, and I have no further interest in obscuring my nature or my intent.","sculptor_unmask",TextSpeedBase, false)
		"SamaelReveal2":
			Dialogue.openDialogue("* Surely it is apparent; I am no mere man. Granted, I'm but a shadow of my former glory…","sculptor_unmask_reject",TextSpeedBase, false)
		"SamaelReveal3":
			Dialogue.openDialogue("* I must thank you for your co-operation up to this point, dear vessel.","samael",TextSpeedBase, false)
		"SamaelReveal4":
			Dialogue.openDialogue("* But now, I shall be taking back that which I have bestowed upon you… your life.","samael",TextSpeedBase, false)
		"SamaelReveal5":
			Dialogue.openDialogue("* Please, try not to move too much. This shall only take but a moment.","samael",TextSpeedBase, false)
		
		##Djinn Samael Fight
		"SamaelDjinnBattleStart":
			Dialogue.openDialogue("* ENOUGH PLAY! RELINQUISH THINE SOUL!!", "samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed":
			Dialogue.openDialogue("* OBEY ME!!","samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed2":
			Dialogue.openDialogue("* DIE! DIE! DIE!!","samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed3":
			Dialogue.openDialogue("* RRRRRAAAGHH!!", "samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed4":
			Dialogue.openDialogue("* STOP… MOVING…!", "samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed5":
			Dialogue.openDialogue("* DIE!!", "samael_djinn",TextSpeedFast, true)
		"SamaelDjinnFlashed6":
			Dialogue.openDialogue("* INDOLENT PEST!!", "samael_djinn",TextSpeedFast, true)
		"SamaelDjinnConfounded":
			Dialogue.openDialogue("* "+"GAH!! CEASE YOUR TRICKS, VESSEL!! Wait… no! This can't be…!!","samael_djinn",TextSpeedFast, true)
		
		##Ascendant Trial
		"SamaelTrial": 
			Dialogue.openDialogue("* "+"I… I…","samael_fear",TextSpeedFast,false)
		"JovielTrial": 
			Dialogue.openDialogue("* "+"Samael.","jove",TextSpeedFast,false)
		"SamaelTrial2": 
			Dialogue.openDialogue("* … Joviel. It has been… ages.","samael_fear",TextSpeedFast,false)
		"JovielTrial2": 
			Dialogue.openDialogue("* "+"Indeed. I take it you understand why we've summoned you here.","jove",TextSpeedBase,false)
		"JovielTrial3":    
			Dialogue.openDialogue("* "+"It is clear that you have been left to your own devices for too long. The Innerlands shine with Ascendant light. What is the meaning of this?","jove",TextSpeedBase,false)
		"SamaelTrial3": 
			Dialogue.openDialogue("* I… well… I have been experimenting. You see… I created this vessel, using a part of myself.","samael_fear",TextSpeedBase,false)
		"SamaelTrial4":
			Dialogue.openDialogue("* The spirit essence that flows into the Innerlands… this vessel is able to absorb and condense it.","samael",TextSpeedBase,false)
		"SamaelTrial5": 
			Dialogue.openDialogue("* It has even come to display intelligence, and wiles… to some extent.","samael",TextSpeedBase,false)
		"JovielTrial4": 
			Dialogue.openDialogue("* "+"I see. Oh, Samael. Never satisfied without a lesser being to subjugate. My disappointment is immeasurable. You truly have learned nothing. The other Ascendants and I must convene. A moment, if you will.","jove",TextSpeedBase,false)
		"JovielTrial5": 
			Dialogue.openDialogue("* "+"We shall return henceforth. Stand, and await your judgement.","jove",TextSpeedBase,false)
		"SamaelTrial6": 
			Dialogue.openDialogue("* This is all your fault, you know. You could have had a purpose. You could have helped me achieve perfection!  But now you're just… GAH! Useless.","samael_anger",TextSpeedFast,false)
		"JovielTrial6": 
			Dialogue.openDialogue("* "+"We have reached a conclusion. Samael, you tirelessly push the boundaries we attempt to impose on you.","jove",TextSpeedBase,false)
		"JovielTrial7": 
			Dialogue.openDialogue("* "+"You have wrought destruction with every step. As punishment, your essence shall be returned to the Void, never to return. It brings me no pleasure to do this… Goodbye, brother.","jove",TextSpeedBase,false)
		"SamaelTrial7": 
			Dialogue.openDialogue("* What!? No…! I am a GOD! You can't do this to me! I am your kin! Confound you, traitors! Of all your treachery…!","samael_anger",TextSpeedFast,false)
		"JovielTrial8": 
			Dialogue.openDialogue("* "+"No…! I can't let this happen…! As drastic as his actions were… in razing the Innerlands, he only wanted to project an image of strength, and teach me to rule…","lailun",TextSpeedBase,false)
		"JovielTrial9":
			Dialogue.openDialogue("* "+"The Innerlands… are my domain. I would have Samael bound to the Vessel of his creation, and permitted to dwell the Innerlands. He'd be no harm to anyone that way…","lailun",TextSpeedBase,false)
		"JovielTrial10":
			Dialogue.openDialogue("* "+"… I suppose. This whole trouble with Samael seems to revolve around you, Lailun. If you're willing to claim responsibility for him… so be it. Enjoy your confinement, brother.","jove",TextSpeedBase,false)
		"SamaelConversion": 
			Dialogue.openDialogue("* T-thank you, but… s-surely there must be another way? Oh, confound it all!!","samael_fear", 6, true)
		"JovielAftermath": 
			Dialogue.openDialogue("* Humble vessel. We must thank you for enduring Samael's tomfoolery up to this point.","jove",TextSpeedBase,false)
		"JovielAftermath2": 
			Dialogue.openDialogue("* We are sorry to burden you with Samael's presence, but we would hope that you might teach him humility.","jove",TextSpeedBase,false)
		"JovielAftermath3": 
			Dialogue.openDialogue("* You have done us a great service; undoubtedly, Samael would have brought ruin upon the Outer Realms at his full power.","jove",TextSpeedBase,false)
		"JovielAftermath4": 
			Dialogue.openDialogue("* We are forever in your debt. Truly, you have gone beyond what has been expected of you.","jove",TextSpeedBase,false)
		"JovielAftermath5": 
			Dialogue.openDialogue("* Perhaps, in another cycle, you and Samael shall prove yourselves worthy of Ascension. Until then.","jove",TextSpeedBase,false)
		"JovielSecretEnding": 
			Dialogue.openDialogue("* What is this…? Something is happening…! Within your flame is a presence… could it be… Humanity…?","jove_surprise",TextSpeedBase,false)
		##Lenore
		"LenoreIntro":
			Dialogue.openDialogue("* Oh… you found me. Did the darkness draw you in, too? The darkness can be scary, but also, calming. Are you… a pot? That's quite silly.","lenore",TextSpeedSlow,false)
		"Lenore2":
			Dialogue.openDialogue("* You've got one big eye… You're a monoculus, just like Mister Bjorn!
(She holds up her stuffed bear.)
			* And you're always staring… Do you ever blink…? Tee hee…","lenore_happy",TextSpeedSlow,false)
		"Lenore3":
			Dialogue.openDialogue("* My name is Lenore. It's been such a long time since I had anyone else to talk to. I miss my Mom and Dad… They gave me Mister Bjorn, and told me to be brave… but I'm still scared.","lenore",TextSpeedSlow,false)
		"Lenore4":
			Dialogue.openDialogue("* I used to like walking through the woods with them, but now, I don't feel safe there. My parents told me if I ever felt unsafe, to go here. This place is very old, and cold.","lenore",TextSpeedSlow,false)
		"Lenore5":
			Dialogue.openDialogue("* Though, sometimes, when I'm here, I hear a voice. A familiar voice. The voice of an Angel. But not the good kind of Angel.","lenore",TextSpeedSlow,false)
		"Lenore6":
			Dialogue.openDialogue("* Before the Angel came, there were lots of kids like me, who lived on the surface. But now, they're all gone.","lenore",TextSpeedSlow,false)
		"Lenore7":
			Dialogue.openDialogue("* The cruel Angel burned them all.","lenore_sad",TextSpeedSlow-1.5,false)
		"Lenore8":
			Dialogue.openDialogue("* He burned me. He burned Mommy. He burned Daddy. He burned Mister Bjorn.","lenore_sad",TextSpeedFast,false)
		"Lenore9":
			Dialogue.openDialogue("* The other Angels knew what he did. They chained him up in the dark for ages. I watched him draw shapes in the sand. I watched him make things.","lenore",TextSpeedSlow,false)
		"Lenore10":
			Dialogue.openDialogue("* After a while, he didn't seem so scary anymore. The other Angels had taken a part of him. But I couldn't forget what he did. To Daddy. To Mommy. To my friends.", "lenore_sad", TextSpeedSlow,false)
		"Lenore11":
			Dialogue.openDialogue("* I know he made you too, but you're different. When I look at you, I think of Mommy, Daddy, and my friends. I think part of them… is inside you. It makes me feel warm…", "lenore_happy", TextSpeedSlow, false)
		"Lenore12":
			Dialogue.openDialogue("* I want to ask you. Is it foolish to think someone as bad as him can change…? A part of me wishes he was still locked up, but… I don't think that would make me happy.", "lenore", TextSpeedSlow, false)
		"LenoreQuestion1":
			DecisionSelect.decision_prompt("","You are foolish
			(Battle)","You are kind
			(Do Not Battle)","LenoreQuestion1", false)
		"LenoreFavorLost":
			Dialogue.openDialogue(" * You're right… He took everything from me… my home… my body… my family… Why would I ever trust him…? I… I want to be alone now. Please, go away. JUST GO AWAY!!", "lenore_sad", TextSpeedSlow-1, false)
		"LenoreFavorGained":
			Dialogue.openDialogue("* Well, okay… if you say so. You're… really special, did you know that? I'd like to join you, if that's ok… I want to be with Mommy and Daddy. So, if you would…", "lenore_happy", TextSpeedFast, false)
		
		##Friendly motes
		"FriendlyMoteAbyss": #wrt Sinkhole
			Dialogue.openDialogue("* This cave system is so peaceful. Though, I've noticed in some places, the shadows seem to swallow up everything… steer well clear of them.", "friendly_mote", TextSpeedSlow, false)
		"FriendlyMoteChasm": #wrt Abyss Presence
			Dialogue.openDialogue("* They call this place the Chasm of Broken Vessels. Me? Well, I realized that I don't need a vessel. I'm free now… are you?", "friendly_mote", TextSpeedSlow, false)
		"FriendlyMoteWoods": #wrt Abyss Serpent
			Dialogue.openDialogue("* Doesn't the sunlight feel wonderful? Though, some here can't seem to leave the shadows behind. Even here, they're drawn to the dark… Be careful.", "friendly_mote", TextSpeedSlow, false)
		"FriendlyMoteDepths": #wrt Gaping Jawer
			Dialogue.openDialogue("* These Depths are actually teeming with life. I feel quite comfortable… just stay far away from the storeroom. That… creature should be left well alone.", "friendly_mote", TextSpeedSlow, false)
		"FriendlyMoteChurchTown": #wrt Shade Motebearer
			Dialogue.openDialogue("* Ah, sunlight… I so abhor the dark. I've seen shadows so impenetrable that they consume all light. What will you do? I say, charge forth bravely.", "friendly_mote", TextSpeedSlow, false)
		"FriendlyMoteCatacombs": #wrt Ossuary
			Dialogue.openDialogue("* I feel safe here… surrounded by kindred spirits. But those pots oozing black smoke… They scare me. Half-buried, like someone tried hastily to hide them…", "friendly_mote", TextSpeedFast, false)
		
		##Samael Tattle
		"JournalTip":
			Dialogue.openDialogue("(You found a weathered old Journal!
Interact with enemies and bosses to reveal detailed information.
			In addition, Samael will provide his own insights.)", "journal", TextSpeedVeryFast, false)
		"TattlePothead1":
			Dialogue.openDialogue("Name: Pot-head
Category: Undead / Light
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattlePothead2":
			Dialogue.openDialogue("φ An unsightly thing, found in ruins and old burial sites. It seems the light inside you draws it to anger, and it will attack with jets of vibrant saturnine flame.","samael_sprite",TextSpeedFast, false)
		
		"TattleMotemouse1":
			Dialogue.openDialogue("Name: Mote-mouse
Category: Mote / Light
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleMotemouse2":
			Dialogue.openDialogue("φ A bothersome pest. These gently-glowing, rodent-like creatures avoid predation by hiding in any nearby Vessels, yourself included. A flash of light will reduce them back to their base components.","samael_sprite",TextSpeedFast, false)
			
		"TattleBlackMote1":
			Dialogue.openDialogue("Name: Black Mote
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleBlackMote2":
			Dialogue.openDialogue("φ A common occurrence, growing slowly in the shade, nearly imperceptible at first. Grows by absorbing motes from the nearby environment, exhibiting a sort of gravity, pulling nearby motes into itself.","samael_sprite",TextSpeedFast, false)
		
		"TattleLilJawer1":
			Dialogue.openDialogue("Name: Little Jawer
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleLilJawer2":
			Dialogue.openDialogue("φ Good grief… Yes, another one of my failed experiments. It possesses the same ravenous hunger as its larger counterpart, but is composed of such thin bodies, that it cannot be contained by normal means.","samael_sprite",TextSpeedFast, false)

		"TattleWisp1":
			Dialogue.openDialogue("Name: Wispflower
Category: Mote / Light
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleWisp2":
			Dialogue.openDialogue("φ A naturally occurring, parasitic organism composed of many motes. It latches onto a host Vesselbloom and prevents it from fruiting properly. It employs entrancing saturnine flames for defense.","samael_sprite",TextSpeedFast, false)

		"TattleLurker1":
			Dialogue.openDialogue("Name: Shadow Lurker
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleLurker2":
			Dialogue.openDialogue("φ A perplexing creature. It hides in the shadow of sources of radiant light, growing larger as it siphons spiritual energy. If disturbed, it will flee and utter a dark incantation. Pursue, and purify.","samael_sprite",TextSpeedFast, false)

		"TattleMuncher1":
			Dialogue.openDialogue("Name: Mote-Eater
Category: Mote / Light
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleMuncher2":
			Dialogue.openDialogue("φ An aggregate of luminous motes; while non-damaging at first, it will absorb motes on contact. Be wary of drawing its ire, or the entire mass will turn on you, and potentially cause damage.","samael_sprite",TextSpeedFast, false)

		"TattleMotebearer1":
			Dialogue.openDialogue("Name: Mote-bearer
Category: Mote / Vessel
			Weakness: Empowered Attack (When Cowled), Flash (Once Dispelled)", "journal", TextSpeedVeryFast, false)
		"TattleMotebearer2":
			Dialogue.openDialogue("φ My finest works… besides you, of course. They harness the power of the unique motes within for offense and defense, all in service of me. Otherwise, they are physically fragile.","samael_sprite",TextSpeedFast, false)

		"TattleSinkhole1":
			Dialogue.openDialogue("Name: Sinkhole
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleSinkhole2":
			Dialogue.openDialogue("φ A Black Mote gone awry; its gravitational pull has grown, taking in motes, soil, and earth into itself and leaving a vast void in their place. Exercise caution, or you too shall be consumed.","samael_sprite",TextSpeedFast, false)

		"TattleMimic1":
			Dialogue.openDialogue("Name: Mimic
Category: Vessel / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleMimic2":
			Dialogue.openDialogue("φ I claim no responsibility for these creatures. Such deception, how cruel do you think me? It is the nature of shadow to seek shadow, as such, my storage chests have been commandeered. Be on your guard.","samael_sprite",TextSpeedFast, false)

		"TattleShadowSnake1":
			Dialogue.openDialogue("Name: Abyssal Serpent
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleShadowSnake2":
			Dialogue.openDialogue("φ These creatures lie in wait, obscuring their true form until exactly the right moment, at which point they emerge, in pursuit of your very soul. What? What do you mean they're exactly like me?!","samael_sprite",TextSpeedFast, false)

		"TattleRaven1":
			Dialogue.openDialogue("Name: One-Eyed Raven
Category: Mote / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleRaven2":
			Dialogue.openDialogue("φ Peculiar beasts, always watching their surroundings with their one large, beady eye. Who can say what they desire? However, it's clear that they hate bright light, as any exposure will drive them to rage.","samael_sprite",TextSpeedFast, false)

		"TattleMuckman1":
			Dialogue.openDialogue("Name: Muck-man
Category: Vessel / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleMuckman2":
			Dialogue.openDialogue("φ Unfortunate creatures; some of my later attempts at creating a vessel using abyssal earth. Perhaps a little too much water added, but you can't fault me for trying.","samael_sprite",TextSpeedFast, false)

		"TattleOssuary1":
			Dialogue.openDialogue("Name: Ossuary
Category: Undead / Shadow
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleOssuary2":
			Dialogue.openDialogue("φ Oh dear. These filthy, cracked vessels will emerge and charge you, channeling their pain and resentment into a staggering blast. Put them to rest, won't you?","samael_sprite",TextSpeedFast, false)

		"TattleGazer1":
			Dialogue.openDialogue("Name: Gazer
Category: Mote / Light
			Weakness: Mote Absorption", "journal", TextSpeedVeryFast, false)
		"TattleGazer2":
			Dialogue.openDialogue("φ A lively sort, this. They latch onto the largest motes they can find and slowly absorb essence to grow their form. This bestows them with an innate resistance to Flash; otherwise, their defenses are weak.","samael_sprite",TextSpeedFast, false)

		"TattleBurnout1":
			Dialogue.openDialogue("Name: Burn-out
Category: Undead / Light
			Weakness: Flash", "journal", TextSpeedVeryFast, false)
		"TattleBurnout2":
			Dialogue.openDialogue("φ Oh my, is it hot in here? Who could have weft such a vibrant, dare I say, masculine hue upon these sorry bones? These remains burn with the saturnine flame characteristic of their bestower.","samael_sprite",TextSpeedFast, false)

		"TattleAmphora1":
			Dialogue.openDialogue("Name: Amphora
Category: Vessel / Shadow
			Weakness: Empowered Attack", "journal", TextSpeedVeryFast, false)
		"TattleAmphora2":
			Dialogue.openDialogue("φ One of my most recent works. The Amphora employs nearby motes for defense. Though, the motes seem to be unstable, and constantly fluctuate between damaging and non-damaging states.","samael_sprite",TextSpeedFast, false)

		"TattleStump1":
			Dialogue.openDialogue("Name: Godwood Stump
Category: Vessel / Light
			Weakness: Flash, Empowered Attack (In that order)", "journal", TextSpeedVeryFast, false)
		"TattleStump2":
			Dialogue.openDialogue("φ An experiment I would consider somewhat successful. Trees that grow above the Abyss naturally absorb the spiritual essence rife within the Innerlands. However, this stump lacks the same spark that you possess.","samael_sprite",TextSpeedFast, false)

		"TattleCenser1":
			Dialogue.openDialogue("Name: Censer
Category: Vessel / Light
			Weakness: Empowered Attack (whilst not swinging)", "journal", TextSpeedVeryFast, false)
		"TattleCenser2":
			Dialogue.openDialogue("φ A hardy Vessel that burns Kindling and produces thick clouds of fragrant smoke. Though it swings about with ferocity, it has a tendency to tire itself out. While I do favor the scent, I found it cloying, at a certain point. As such, I stowed this vessel in a forgotten wing of my Sanctuary, without a thought. Now, I know how it feels to be confined.met","samael_sprite",TextSpeedFast, false)

		"TattleGapingJawer1":
			Dialogue.openDialogue("Name: Gaping Jawer
Category: Vessel / Shadow
			Weakness: Flash (when not Invisible)", "journal", TextSpeedVeryFast, false)
		"TattleGapingJawer2":
			Dialogue.openDialogue("φ A gluttonous shadow that refused to exist harmoniously within a vessel. As punishment, I sealed it away in the dank depths. Now, bound to you, I see my mistake. A parent should allow its child to grow.","samael_sprite",TextSpeedFast, false)

		"TattleLenore1":
			Dialogue.openDialogue("No Data", "journal", 50, false)
		"TattleLenore2":
			Dialogue.openDialogue("φ Oh, a straggler? Wait… I recognise this one. Ha… ha ha. I suppose I was sloppy in my work eradicating those sniveling humans. Do me a kindness and finish the job, won't you? Not that there's anyone left to miss her…","samael_sprite",TextSpeedFast, false)

		"TattleAbyssoul1":
			Dialogue.openDialogue("Name: Abyssoul
Category: Vessel / Shadow
			Weakness: Flash (Tendrils only)", "journal", TextSpeedVeryFast, false)
		"TattleAbyssoul2":
			Dialogue.openDialogue("φ Imprisoned in the Abyss, I created a Vessel using mud, stones, and the dregs of my divinity. In time, I was able to reach the surface. However, my creation feared the light, for all it had ever known was shadow.","samael_sprite",TextSpeedFast, false)

		"TattleFrenzyGrowth1":
			Dialogue.openDialogue("Name: Frenzied Growth
Category: Vessel/Shadow
			Weakness: Flash (Whilst firing Shadowflame)", "journal", TextSpeedVeryFast, false)
		"TattleFrenzyGrowth2":
			Dialogue.openDialogue("φ I have to admit, I was the one who placed the key there. My aim was to test you, while also disposing of one of my failed creations. The flame that burns within… a shadow cast by light truly divine.","samael_sprite",TextSpeedFast, false)
		
		##Unused in base game
		"TattleSamaelBase1":
			Dialogue.openDialogue("Name: Samael, Ascendant of the Seventh Sphere
Category: Handsome Rogue
			Weakness: Sweet treats, wine, having goddamn lights flashed in my eyes", "journal", TextSpeedVeryFast, false)
		"TattleSamaelBase2":
			Dialogue.openDialogue("φ Nosy one, aren't you? I modelled my appearance after the horn-decked beasts of the grove of the Gods. I sought to reflect their strength and nobility.","samael_sprite",TextSpeedFast, false)
		##Unused in base game
		"TattleSamaelDjinn1":
			Dialogue.openDialogue("Name: Samael, Ascendant of the Seventh Sphere
Category: Pissed-off Imperfect God
			Weakness: Nosy alabaster space-ninnies", "journal", TextSpeedVeryFast, false)
		"TattleBase2":
			Dialogue.openDialogue("φ To see me in this state, is to have truly drawn my ire. How a mere clay pot could have gotten the best of me eludes me to this day. Know this; my appearance is a vestige of my prior status as a truly divine being! ","samael_sprite",TextSpeedFast, false)

		#Impostor
		"Impostor1":
			Dialogue.openDialogue("(* The cloaked figure stands motionless, staring at you with a pale, masked countenance.)", "impostor", TextSpeedVeryFast, false)
		"ImpostorFollowUpHasTome":
			Dialogue.openDialogue("φ Allow me to assist you, vessel. This… impostor doesn't seem interested in conversation.
			(Your Efficiency stat increased.)","samael_sprite",TextSpeedFast, false)
		"ImpostorFollowUpNoTome":
			Dialogue.openDialogue("φ The existence of this… thing defies all logic. Stay well clear of it.","samael_sprite",TextSpeedFast, false)
		"SamaelSpriteGuidance":
			Dialogue.openDialogue("φ As you may recall, we will need to ring both Bells to progress. Once you have done so, return here, and we'll proceed inside.","samael_sprite",TextSpeedFast, false)
		"SamaelSpriteHalfwayPoint":
			Dialogue.openDialogue("φ Almost there, only one bell left, dear vessel. One will be here in town, and one is located in the Chasm of the Abyss.","samael_sprite",TextSpeedFast, false)
		"SamaelSpriteWarning":
			Dialogue.openDialogue("φ Good, you've rung both bells. Are you ready to step inside?","samael_sprite",TextSpeedFast, false)
		"ImpostorEnterSanctuary":
			DecisionSelect.decision_prompt("?¤E+N-*T/=£$E¢€R¥÷%'#@&_(¶Eµ§B¼Oφ‰N¿","
			Enter","
			Do Not","EnterImpostorSanctuary", false)
		"SamaelSpriteCallOut":
			Dialogue.openDialogue("φ Alright, that's ENOUGH! I think I speak for both of us when I say, we've had it with your games, impostor! Reveal yourself at once!","samael_sprite",TextSpeedFast, false)
		"SamaelSpriteIncoming":
			Dialogue.openDialogue("φ Try to destroy my hard work, will you!? Vessel! Let's obliterate this pile of rubbish!
			(Press Interact to parry the opponent's attacks!)","samael_sprite",TextSpeedVeryFast,false)
		
		#Lailun in Dark Space
		"LailunDarkSpace1":
			Dialogue.openDialogue("* "+"Samael? It's me… Lailun. I've been following you… watching you. I feel… responsible for you, in a way.","lailun",TextSpeedBase,false)
		"LailunDarkSpace2":
			Dialogue.openDialogue("* "+"You and your vessel… you've been working together. That's good… I tried to make one too… but it came out wrong. However, it was just means to an end.","lailun",TextSpeedBase,false)
		"LailunDarkSpace3":
			Dialogue.openDialogue("* "+"My goal was to bring you into the dark, here, with me. The other Ascendants can't listen to us here.","lailun",TextSpeedBase,false)
		"SamaelDarkSpace1":
			Dialogue.openDialogue("* "+"Very good, Lailun. You've done well. Now, while it's just us, would you kindly free me from this vessel? It's awfully cold, and stuffy, too…","samael_sprite",TextSpeedBase,false)
		"LailunDarkSpace4":
			Dialogue.openDialogue("* "+"F-free you? But… you and your Vessel are so intertwined, to release you would destroy it! And… I haven't forgotten the chaos you unleashed upon humanity, brother…","lailun",TextSpeedBase,false)
		"LailunDarkSpace5":
			Dialogue.openDialogue("* "+"Kindly Vessel… your bond with Samael has grown, but no doubt it wears on you. Would it please you, I would free Samael from your confines, but there may be… consequences.","lailun",TextSpeedBase,false)
		"LailunQuestion":
			DecisionSelect.decision_prompt("Free Samael? Doing so will reset the timeline, and give Samael control over the Innerlands yet again. He will no longer accompany you on your journey.","
			Yes","
			No","TimelineReset",false)
		"LailunPlayerAccept":
			Dialogue.openDialogue("* "+"If that is your wish, I shall abide by it. Thank you, kindly Vessel. Rest now, in peaceful darkness…","lailun",TextSpeedBase,false)
		"SamaelPlayerAccept1":
			Dialogue.openDialogue("* "+"Dearest sister, your gentle nature places you above the rest of our kin. However… I've gained more than experience from accompanying this Vessel.","samael",TextSpeedBase,false)
		"SamaelPlayerAccept2":
			Dialogue.openDialogue("* "+"The flame within me has grown in intensity… and such a flame does not discriminate, and seeks to consume all. And consume, it shall… until your realm, and our kin, are all but cinders.","samael_triumph",TextSpeedBase,false)
		"LailunPlayerDecline":
			Dialogue.openDialogue("* "+"I see… Well, I cannot disagree with your decision. Undoubtedly, Samael has much more learning to do. We shall meet again… I would ask that you help the denizens of the Innerlands find peace. Until then…","lailun",TextSpeedBase,false)
		
		## Test dialogues
		"moteTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","friendly_mote",TextSpeedBase,false)
		"sculptorTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","sculptor",TextSpeedBase,false)
		"jariTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","jari",TextSpeedBase,false)
		"zenithTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","zenith",TextSpeedBase,false)
		"nadirTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","nadir",TextSpeedBase,false)
		"jovielTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","jove",TextSpeedBase,false)
		"djinnTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","samael_djinn",TextSpeedBase,false)
		"lenoreTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","lenore",TextSpeedBase,false)
		"samaelspriteTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","samael_sprite",TextSpeedBase,false)
		"lailunTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","lailun",TextSpeedBase,false)
		"barrelbyTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","barrelby",TextSpeedBase,false)
		"portiaTest":
			Dialogue.openDialogue("* "+"Lorum ipsum doloramet non sequitur trancelerationes deleritamus!","portia",TextSpeedBase,false)
		
		## Portia (Demo)
		"portiaA":
			Dialogue.openDialogue("* "+"Hi there, nice to meet you! My name is Portia, and I'll be your guide to help you understand the world of VESSOUL!","portia_happy",TextSpeedBase,false)
		"portiaB":
			Dialogue.openDialogue("* "+"VESSOUL is all about exploring a world of labyrinths. Your goal will vary; sometimes, collecting the white dots, or 'motes', will allow you to progress. Other times, you'll have to defeat enemies or bosses to continue.","portia",TextSpeedBase,false)
		"portiaC":
			Dialogue.openDialogue("* "+"You exist as a spirit flame, inhabiting a vessel, just like me! By collecting motes, you'll enter the 'Empowered' state. In this state, you can destroy obstacles such as jars that stand in your way.","portia_happy",TextSpeedBase,false)
		"portiaD":
			Dialogue.openDialogue("* "+"For now, try to collect all the motes in this room! Small motes are worth 1, whereas larger motes, found in corners or inside mote jars can be worth anywhere from 5 to 20 motes!","portia",TextSpeedBase,false)
		"portiaE":
			Dialogue.openDialogue("* "+"Occasionally, you'll find chests containing items. Some items can be traded to NPCs in exchange for stat increases. Others will grant permanent upgrades as soon as you collect them. Give it a try!","portia_wink",TextSpeedBase,false)
		"portiaF":
			Dialogue.openDialogue("* "+"Oh no! Some enemies appeared! When they emerge, you can use Flash to damage them! Purify the enemies to escape the room! Don't worry about me, I'll be making my daring escape!","portia_sad",TextSpeedBase,false)
		"portiaG":
			Dialogue.openDialogue("* "+"You did great! You're gonna do great things, I'm sure of it! I hope this tutorial helped to give you an idea of what to expect from VESSOUL.","portia_happy",TextSpeedBase,false)
		"portiaH":
			Dialogue.openDialogue("* "+"Unfortunately, I won't be able to follow you to the next area. Even though I never learned your name, it was nice knowing you, friend! Best of luck to you!","portia_wink",TextSpeedBase,false)
		
		## Mysterious Voices (Demo)
		"anon1A":
			Dialogue.openDialogue("* "+"Was that…? A flash in the darkness?","anon1",TextSpeedFast,false)
		"anon2B":
			Dialogue.openDialogue("* "+"Oh dear… it came from the Innerlands… from the dark Abyss. Could it be…?","anon2",TextSpeedFast,false)
		"anon1C":
			Dialogue.openDialogue("* "+"The One Forsaken…","anon1",TextSpeedFast,false)
		"anon1D":
			Dialogue.openDialogue("* "+"We must keep a watchful eye on the Innerlands… a great deal of time has passed since He was imprisoned there.","anon1",TextSpeedFast,false)
		"anon2E":
			Dialogue.openDialogue("* "+"Dear brother… won't you come to see reason, and set aside your wrathful ways…?","anon2",TextSpeedFast,false)
		"anon1F":
			Dialogue.openDialogue("* "+"We shall know with certainty soon enough. Have patience, sister.","anon1",TextSpeedFast,false)
