extends Node

signal playerDisplayItem(frame) #for showing items over player's head after aquiring
signal playerVictory # used when player gets a kill, sure it has other functions too
signal playerHeal # Self explanatory
signal battle_begin #set in motion the events of the final battle
signal new_game #emitted when the player selects new game plus on the main menu, activates the dialogue box
signal show_gui_save_menu #see remote_save()
signal game_saved #used to indicate to save points that the game can be saved again
signal unpause
signal rumble

##Values that will change per-game and that will reset when the Player dies
##Also important; these values are not modified directly by any upgrades/stat bonuses 
var target_player : PlayerVessel
var target_buddy : CharacterBody2D
var buddy = preload("res://scenes/player_two.tscn")
var playerHP = 1
#var isPaused : bool = false
var decisionActive : bool = false
var shadeActive : bool = false 
var cheating : bool = false
var pause_mote_decay : bool = false ##currently only used in Endless Mode
##whether or not to play the respawning anim when loading player
var respawning : bool = false
##we want player HP to be preserved between scene changes
var player_hp_previous : int = 0
##Secret boss only available in playthroughs with Samael buddy
var impostor : bool  = false
var last_enemy : String
var gold_toll : int = 750 #was 1000
var silver_toll : int = 250 #was 500
var disable_mote_rewards : bool = false
##Boss mote rewards
var reward_amphora : int = 100
var reward_abyssoul : int = 120
var reward_lenore : int = 300
var reward_stump : int = 200
var reward_jawer : int = 200
var reward_growth : int = 400
var reward_censer : int = 200
var reward_forsaken : int = 1000
##Enemy mote rewards
var reward_pothead : int = 10
var reward_blackmote : int = 5
var reward_motemouse : int = 5
var reward_liljawer : int = 5
var reward_wispflower : int = 10
var reward_lurker : int = 10
var reward_muncher : int = 10
var reward_motebearer : int = 10
var reward_shadowsnake : int = 10
var reward_raven : int = 10
var reward_sinkhole : int = 15
var reward_mimic : int = 15
var reward_muckman : int = 15
var reward_ossuary : int = 15
var reward_gazer : int = 20
var reward_burnout : int = 20

# values that ARE directly changed as a result of item stat bonuses
var playerBaseSpd : float #player base movement speed when not empowered
var playerBuffedSpd : float #player movement speed when empowered
var playerBaseHP : float #player base HP with no items
var playerBoostMin : float #souls to enter Empowered state
var playerFlashMin : float #souls to ready "Flash" ability state
var playerExhaustPoint : float #if empowered and souls hit this number, lose state
var playerMoteDecay : float #how quickly motes tick down
var playerSatietyMod : float #self explanatory 
var playerSatietyAdd : float #endless mode only
var playerDamageMod : int #damage modifier from items 
var playerMotesPreserved : float = 0.1 #from 0 to 1, a percentage of motes saved when player has Pot Lid
var playerSoulSpeedGain : float = 0.025 # was 0.01, 0.1 is just too fast
var playerFlashMax : int
var playerSpeedGainAdd : float = 0 #Endless Mode Only
var playerDamageAdd : int #Endless Mode Only
var playerHitstunAdd : bool = false #Endless Mode Only
var playerEfficiencyAddAlpha : int = 0 #Endless Mode Only / Grimoire
var playerEfficiencyAddBeta : int = 0 #Endless Mode Only / Void's Curse
var playerCapacityAdd : int = 0 #Endless Mode Only

##Data that we'll Save/Load (see: saveload.gd, savepoint.gd, main_menu.gd)
var saveslot = 0 #default
var playerActiveScene = "res://scenes/nullscn.tscn" #this will be overrwritten with player's first save
var playerCurrentLocation = Vector2(0,0) #this is just for storage, it shouldnt be referenced or changed except by save points!
var playerActiveSouls : float = 0 #is referenced
var playerLifetimeSouls : float = 0 #is referenced
var playerKillCount : int = 0 #is referenced
var playerBulbsHeld : int = 0 #can carry up to 5
var playerTomesHeld : int = 0 #can carry up to 3
var playerKindlingHeld : int = 0 #can carry up to 10
var playerCapacity : int = 0 #goes up to 5, upgraded by Jari in exchange for bulbs
var playerEfficiency : int = 0 #goes up to 3, upgraded by Sculptor in exchange for tomes
var playerIntensity : int = 0 #goes up to 10, upgraded by Zenith in exchange for kindling
var mote_residue : bool = false
var mote_residue_value : int = 0
var mote_residue_position : Vector2 = Vector2(9999,9999)
var mote_residue_scene : String = "res://scenes/nullscn.tscn"
var EasyMode : bool = false
## -1 = default, 1 = access to secret ending, 0 = lenore dialogue failed
var favor : int = -1
var completion : bool = false
var newgame : int = 0
var player_church_town_entered : bool = false
var player_gods_wood_entered : bool = false
var debug : bool = false #tells game not to reset game state if we're in debug mode
var language : String = "English"
var cleanup_time_enemy : int = 1
var cleanup_time_boss : int = 30
var coop : bool = false

var npcDict = {
	"sculptor": 0,
	"jari": 0,
	"zn": 0
}

var abyssDict = {
"abyssBlooms": [0,0], ## Cave of Reflection, Tomb of a Hero
"abyssMiniBoss": 0, ## Amphora
"abyssTome": 0, ## Abyss Tome
"abyssBonusR": [0,0,0], 
"abyssKindling": [0,0,0],
"abyssLid": 0,
"abyssGlaze": 0, ## 1 = Flash Enabled ## Greater than 1 = Extra Coat (Endless Mode only)
"abyssBoss": [0,0] 
}

var woodsDict = {
"woodsBlooms": 0, #Town Gate Exterior
"woodsMiniBoss": [0,0], #Stump, Gaping Jawer
"woodsTome": 0, #from Gaping Jawer
"woodsBonusR": [0,0], #14, 15
"woodsKindling": [0,0],
"woodsBoss": 0, #Frenzied Growth
"woodsKey": 0 #Church Town Key 
}

var townDict = {
"townBlooms": [0,0], #16/17
"townMiniBoss": 0, #Censer / 24
"townTome": 0, #from Censer / 24
"townBonusR": [0,0,0,0], #B1/19, B2/20, B3/21, B4/22
"townSanctuaryBells": [0,0], #gold and silver key, respectively
"townKindling": [0,0,0,0,0], #19,20,21,22,23
"townEndingChoice": [0,0,0], #bad, good, secret
"townBoss": 0 #Samael
}

var endless = {
"theme": 0, #0 = dawn, 1 = dusk, 2 = twilight
"maze_level": [0,0], #current, highest reached 
"maze_difficulty": [0,0], #current, highest
"stored_motes": 0, 
"boon_sun": 0, 
"boon_mercury": 0,
"boon_venus": 0,
"boon_moon": 0,
"boon_mars": 0, 
"boon_jupiter": 0,
"curse_saturn":0,
"curse_void": 0,
"all_boons_obtained": 0
}

var endless_completion = {
	"PotheadMaze": 0,
	"BlackMoteMaze": 0,
	"MoteMouseMaze": 0,
	"LilJawerMaze": 0,
	"WispflowerMaze": 0,
	"ShadowLurkerMaze": 0,
	"MoteMuncherMaze": 0,
	"ShadowSnakeMaze": 0,
	"SinkholeMaze": 0,
	"MimicMaze": 0,
	"MuckmanMaze": 0,
	"OssuaryMaze": 0,
	"GazerMaze": 0,
	"BurnoutMaze": 0,
	"CrematorMaze": 0,
	"DouserMaze": 0,
	"ShadeMaze": 0,
	"FreezerMaze": 0,
	"RavenMaze": 0
}

##Can be called by any object
func anim_rumble(duration : float,amplitude):
	rumble.emit(true,amplitude)
	await get_tree().create_timer(duration).timeout
	rumble.emit(false,amplitude)


func _save(lastPosition,sceneName):
	var saveData = SceneData.new()
	Dialogue.save_indicate()
	saveData.activescn = str(sceneName)
	saveData.playerxy = lastPosition
	saveData.playersouls = playerActiveSouls
	saveData.playersoulsl = playerLifetimeSouls
	saveData.playerkills = playerKillCount
	saveData.playerbulbs = playerBulbsHeld
	saveData.playertomes = playerTomesHeld
	saveData.playerkindling = playerKindlingHeld
	saveData.playercapacity = playerCapacity
	saveData.playerefficiency = playerEfficiency
	saveData.playerintensity = playerIntensity
	saveData.mote_residue = mote_residue
	saveData.mote_residue_value = mote_residue_value
	saveData.mote_residue_position = mote_residue_position
	saveData.mote_residue_scene = mote_residue_scene
	saveData.EasyMode = EasyMode
	saveData.favor = favor
	saveData.completion = completion
	saveData.newgame = newgame
	saveData.player_church_town_entered = player_church_town_entered
	saveData.player_gods_wood_entered = player_gods_wood_entered
	saveData.language = language
	saveData.npcState = {
		"sculptor": npcDict["sculptor"],
		"jari": npcDict["jari"],
		"zn": npcDict["zn"]
	}
	saveData.abyssData = {
		"abyssBlooms": [abyssDict["abyssBlooms"][0],abyssDict["abyssBlooms"][1]],
		"abyssMiniBoss": abyssDict["abyssMiniBoss"], #amphora
		"abyssTome": abyssDict["abyssTome"],
		"abyssBonusR": [abyssDict["abyssBonusR"][0],abyssDict["abyssBonusR"][1],abyssDict["abyssBonusR"][2]],
		"abyssKindling": [abyssDict["abyssKindling"][0],abyssDict["abyssKindling"][1],abyssDict["abyssKindling"][2]],
		"abyssLid": abyssDict["abyssLid"],
		"abyssGlaze": abyssDict["abyssGlaze"],
		"abyssBoss": [abyssDict["abyssBoss"][0], abyssDict["abyssBoss"][1]] #abyss presence, lenore
	}
	saveData.woodsData = {
		"woodsBlooms": woodsDict["woodsBlooms"],
		"woodsMiniBoss": [woodsDict["woodsMiniBoss"][0],woodsDict["woodsMiniBoss"][1]], #Stump, Gaping Jawer
		"woodsTome": woodsDict["woodsTome"], #from Gaping Jawer
		"woodsBonusR": [woodsDict["woodsBonusR"][0],woodsDict["woodsBonusR"][1]], #14, 15
		"woodsKindling": [woodsDict["woodsKindling"][0],woodsDict["woodsKindling"][1]],
		"woodsBoss": woodsDict["woodsBoss"], #Frenzied Growth
		"woodsKey": woodsDict["woodsKey"] #Church Town Key
	}
	saveData.townData = {
		"townBlooms": [townDict["townBlooms"][0],townDict["townBlooms"][1]], #16/17
		"townMiniBoss": townDict["townMiniBoss"], #Censer / 24
		"townTome": townDict["townTome"],
		"townBonusR": [townDict["townBonusR"][0],townDict["townBonusR"][1],townDict["townBonusR"][2],townDict["townBonusR"][3]], #B1/19, B2/20, B3/21, B4/22
		"townKindling": [townDict["townKindling"][0],townDict["townKindling"][1],townDict["townKindling"][2],townDict["townKindling"][3],townDict["townKindling"][4]], #19,20,21,22,23
		"townSanctuaryBells": [townDict["townSanctuaryBells"][0],townDict["townSanctuaryBells"][1]],
		"townEndingChoice": [townDict["townEndingChoice"][0],townDict["townEndingChoice"][1],townDict["townEndingChoice"][2]], #accept, refuse, secret 3rd thing
		"townBoss": townDict["townBoss"]
		}
	ResourceSaver.save(saveData, "user://save_data_"+str(saveslot)+".res") #change to .res for Steam version
	game_saved.emit() #see declaration line
	print("Saved via SavePoint")

func _load():
	var data = ResourceLoader.load("user://save_data_"+str(saveslot)+".res") as SceneData #load saved data
	playerActiveScene = data.activescn
	playerCurrentLocation = data.playerxy #update player current vector2
	playerActiveSouls = data.playersouls
	playerLifetimeSouls = data.playersoulsl
	playerKillCount = data.playerkills
	playerBulbsHeld = data.playerbulbs
	playerTomesHeld = data.playertomes
	playerKindlingHeld = data.playerkindling
	playerCapacity = data.playercapacity
	playerEfficiency = data.playerefficiency
	playerIntensity = data.playerintensity
	mote_residue = data.mote_residue
	mote_residue_value = data.mote_residue_value
	mote_residue_position = data.mote_residue_position
	mote_residue_scene = data.mote_residue_scene
	EasyMode = data.EasyMode
	favor = data.favor
	completion = data.completion
	newgame = data.newgame
	language = data.language
	@warning_ignore("integer_division")
	gold_toll = int(750+((750/2)*newgame))
	@warning_ignore("integer_division")
	silver_toll = int(250+((250/2)*newgame))
	
	npcDict =  {
		"sculptor": data.npcState["sculptor"],
		"jari": data.npcState["jari"],
		"zn": data.npcState["zn"]
	}
	
	abyssDict = {
		"abyssBlooms": [data.abyssData["abyssBlooms"][0],data.abyssData["abyssBlooms"][1]],
		"abyssMiniBoss": data.abyssData["abyssMiniBoss"], #amphora
		"abyssTome": data.abyssData["abyssTome"],
		"abyssBonusR": [data.abyssData["abyssBonusR"][0],data.abyssData["abyssBonusR"][1],data.abyssData["abyssBonusR"][2]],
		"abyssKindling": [data.abyssData["abyssKindling"][0],data.abyssData["abyssKindling"][1],data.abyssData["abyssKindling"][2]],
		"abyssLid": data.abyssData["abyssLid"],
		"abyssGlaze": data.abyssData["abyssGlaze"],
		"abyssBoss": [data.abyssData["abyssBoss"][0], data.abyssData["abyssBoss"][1]] #abyss presence, lenore
	}
	woodsDict = {
		"woodsBlooms": data.woodsData["woodsBlooms"],
		"woodsMiniBoss": [data.woodsData["woodsMiniBoss"][0],data.woodsData["woodsMiniBoss"][1]], #Stump, Gaping Jawer
		"woodsTome": data.woodsData["woodsTome"], #from Gaping Jawer
		"woodsBonusR": [data.woodsData["woodsBonusR"][0],data.woodsData["woodsBonusR"][1]], #14, 15
		"woodsKindling": [data.woodsData["woodsKindling"][0],data.woodsData["woodsKindling"][1]],
		"woodsBoss": data.woodsData["woodsBoss"], #Frenzied Growth
		"woodsKey": data.woodsData["woodsKey"] #Church Town Key
	}
	townDict = {
		"townBlooms": [data.townData["townBlooms"][0],data.townData["townBlooms"][1]], #16/17
		"townMiniBoss": data.townData["townMiniBoss"], #Censer / 24
		"townTome": data.townData["townTome"],
		"townBonusR": [data.townData["townBonusR"][0],data.townData["townBonusR"][1],data.townData["townBonusR"][2],data.townData["townBonusR"][3]], #B1/19, B2/20, B3/21, B4/22
		"townKindling": [data.townData["townKindling"][0],data.townData["townKindling"][1],data.townData["townKindling"][2],data.townData["townKindling"][3],data.townData["townKindling"][4]], #19,20,21,22,23
		"townSanctuaryBells": [data.townData["townSanctuaryBells"][0],data.townData["townSanctuaryBells"][1]],
		"townEndingChoice": [data.townData["townEndingChoice"][0],data.townData["townEndingChoice"][1],data.townData["townEndingChoice"][2]], #accept, refuse, secret 3rd thing
		"townBoss": data.townData["townBoss"]
		}
	
	##Determining / signalling secret-final-boss state
	if townDict["townEndingChoice"][1] != 0:
		impostor = true

	if townDict["townEndingChoice"][2] != 0:
		impostor = true
	print("Save data loaded successfully")

func save_remote():
	##Pass to local GUI handler
	show_gui_save_menu.emit()

##Stat calculations
func _process(_delta: float) -> void:
	match playerCapacity: 
		##each rank of capacity increase player baseHP by 1
		##the latter part is for endless mode only
		0:
			playerBaseHP = 1 + playerCapacityAdd
			playerFlashMax = 5
		1:
			playerBaseHP = 2 + playerCapacityAdd
			playerFlashMax = 6
		2:
			playerBaseHP = 3 + playerCapacityAdd
			playerFlashMax = 7
		3: 
			playerBaseHP = 4 + playerCapacityAdd
			playerFlashMax = 8
		4:
			playerBaseHP = 5 + playerCapacityAdd
			playerFlashMax = 9
		5:
			playerBaseHP = 6 + playerCapacityAdd
			playerFlashMax = 10
	
	if playerCapacity > 5: #experimental
		playerBaseHP = 1+(playerCapacity)
		playerFlashMax = 4+(playerCapacity)
		if !completion:
			cheater()

	match playerEfficiency:
		0: #base value
			#important note: this doesn't change the rate at which motes are consumed,
			#it controls the approximate amount of motes that are consumed each tick
			if pause_mote_decay:
				playerMoteDecay = 0
			else: 
				playerMoteDecay = .95
			playerSatietyMod = 0
			playerFlashMin = 50
			playerBoostMin = 20
			playerExhaustPoint = 15
		1:
			if pause_mote_decay:
				playerMoteDecay = 0
			else: 
				playerMoteDecay = .90
			playerSatietyMod = 0
			playerFlashMin = 45
			playerBoostMin = 15
			playerExhaustPoint = 10
		2:
			if pause_mote_decay:
				playerMoteDecay = 0
			else: 
				playerMoteDecay = .85
			playerSatietyMod = 0
			playerFlashMin = 40
			playerBoostMin = 10
			playerExhaustPoint = 5
		3: #max
			if pause_mote_decay:
				playerMoteDecay = 0
			else: 
				playerMoteDecay = .80
			##Endless Mode Only
			if !target_player.endless:
				playerSatietyMod = 1
			else: playerSatietyMod = 0
			playerFlashMin = 35
			playerBoostMin = 5
			playerExhaustPoint = 0 
	if playerEfficiency > 3: #experimental
		if pause_mote_decay:
			playerMoteDecay = 0
		else: playerMoteDecay = 0.50 #= 1 - .15*playerEfficiency
		if !target_player.endless:
			playerSatietyMod = 1 + .10*playerEfficiency# + (playerSatietyAdd)
		else: playerSatietyMod = 0
		playerFlashMin = 30
		playerBoostMin = 1
		playerExhaustPoint = 0 
		if !completion:
			cheater()
	
	match playerIntensity:
		0: #base value
			playerBaseSpd = 25 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 50 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		1: 
			playerBaseSpd = 30 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 55 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		2:
			playerBaseSpd = 35 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 60 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		3:
			playerBaseSpd = 40 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 65 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		4:
			playerBaseSpd = 45 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 70 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		5:
			playerBaseSpd = 50 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 75 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		6:
			playerBaseSpd = 55 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 80 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		7:
			playerBaseSpd = 60 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 85 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		8:
			playerBaseSpd = 65 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 90 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		9:
			playerBaseSpd = 70 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 95 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 0 + playerDamageAdd
		10:
			playerBaseSpd = 75 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerBuffedSpd = 100 + playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd)
			playerDamageMod = 1 + playerDamageAdd
		
	if playerIntensity > 10: #experimental
		playerBaseSpd = (7.75*playerEfficiency)+(playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd))
		playerBuffedSpd = (11*playerEfficiency)+(playerActiveSouls*(playerSoulSpeedGain+playerSpeedGainAdd))
		playerDamageMod = int(.10*playerEfficiency)
		if !completion:
			cheater()

#To be called when enemies and bosses provide a mote reward on death
func mote_reward(moteValue:int,bonusMod:float,size:String):
	var absorb_wait_time : float = 0.5
	var absorb_big_wait_time : float = 0.05
	var absorb_increment : int = 65
	if !disable_mote_rewards:
		match size:
			"small":
				await get_tree().create_timer(absorb_wait_time).timeout 
				GameState.target_player.anim_mote_absorb_small()
				await get_tree().create_timer(absorb_wait_time).timeout 
				GameState.playerActiveSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
				GameState.playerLifetimeSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
			"big":
				target_player.anim_mote_absorb()
				for i in absorb_increment:
					GameState.playerActiveSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
					GameState.playerLifetimeSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
					await get_tree().create_timer(absorb_big_wait_time).timeout 
			"sound_only":
				await get_tree().create_timer(absorb_wait_time).timeout 
				Sound.player("mote_collect")
				GameState.playerActiveSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
				GameState.playerLifetimeSouls += ((moteValue+((moteValue*bonusMod)+(moteValue*bonusMod))*GameState.newgame))/absorb_increment+1
	else: print("Mote rewards disabled")

##Called by all Mote types
func addSoul(soulValue):
	#if player has less souls than their maximum
	if GameState.playerActiveSouls < GameState.playerFlashMin*GameState.playerFlashMax:
		playerActiveSouls += (soulValue + soulValue*playerSatietyMod) + playerSatietyAdd
		playerLifetimeSouls += soulValue + (soulValue*playerSatietyAdd)
	else: #refill player souls
		playerActiveSouls = GameState.playerFlashMin*GameState.playerFlashMax+5 #see below
		playerLifetimeSouls += soulValue + (soulValue*playerSatietyAdd)
		
## Called by Mote Residue
func mote_restore(moteValue):
	playerLifetimeSouls += moteValue 
	if GameState.playerActiveSouls > GameState.playerFlashMin*GameState.playerFlashMax:
		playerActiveSouls += (moteValue)
	else: #refill player souls
		playerActiveSouls = GameState.playerFlashMin*GameState.playerFlashMax+5
		#the plus five at the end is to keep the flash count from instantly ticking down, instead giving a 5 sec window

## Called by BigMotes
func healMe(amount):
	if playerHP < playerBaseHP and playerHP != 0: #if HP is low, restore HP
			if amount+playerSatietyMod+playerHP < playerBaseHP: #if the sum of these values is less than the player's base HP
				playerHP += amount+playerSatietyMod #heal however many points
			else: #refill player's hp
				playerHP = playerBaseHP
			Sound.PlayerHeal()
			playerHeal.emit(amount)  #show visual indicator (obsolete)

## Called by Save Points / Jari Upgrade
func fullHeal(): 
	playerHP = playerBaseHP
	playerHeal.emit(GameState.playerBaseHP) #show visual indicator (obsolete)

## Called by Enemies
func addKillCount():
	playerVictory.emit()
	playerKillCount += 1
	print ("killcount:"+str(playerKillCount))

## Called by Item Chests
func bestowItem(itemType):
	match itemType:
		-2: #Pot Lid
			playerDisplayItem.emit(0)
			abyssDict["abyssLid"] = 1
		-1: #Glaze
			playerDisplayItem.emit(1)
			abyssDict["abyssGlaze"] = 1
		0: #Kindling
			playerDisplayItem.emit(2)
			playerKindlingHeld += 1
		1: #Bloombulb
			playerDisplayItem.emit(3)
			playerBulbsHeld += 1
		2: #Tome Variant 1
			playerDisplayItem.emit(4)
			playerTomesHeld += 1
		3: #Tome Variant 2
			playerDisplayItem.emit(5)
			playerTomesHeld += 1
		4: #Tome Variant 3
			playerDisplayItem.emit(6)
			playerTomesHeld += 1

##Called by Samael during the final battle
func battleStart():
	battle_begin.emit()

##Called if the player has stats not obtainable in basegame
func cheater():
	cheating = true

## Not currently used
#func reset_game_values():
	#if !debug:
		#player_church_town_entered = false
		#player_gods_wood_entered = false
		#playerActiveSouls = 0 #is referenced
		#playerLifetimeSouls = 0 #is referenced
		#playerKillCount = 0 #is referenced
		#playerBulbsHeld = 0 #can carry up to 5
		#playerTomesHeld = 0 #can carry up to 3
		#playerKindlingHeld = 0 #can carry up to 10
		#playerCapacity = 0 #goes up to 5, upgraded by Jari in exchange for bulbs
		#playerEfficiency = 0 #goes up to 3, upgraded by Sculptor in exchange for tomes
		#playerIntensity = 0 #goes up to 10, upgraded by Zenith in exchange for kindling
		#favor = -1
		#completion = false
		#newgame = 0 #this controls enemies scaling with NG+, so on a new game it should be 0
		#npcDict["jari"] = 0
		#npcDict["sculptor"] = 0
		#npcDict["zn"] = 0
		##--------------Abyss------------#
		#abyssDict["abyssBlooms"][0] = 0
		#abyssDict["abyssBlooms"][1] = 0
		#abyssDict["abyssMiniBoss"] = 0
		#abyssDict["abyssTome"] = 0
		#abyssDict["abyssBonusR"][0] = 0
		#abyssDict["abyssBonusR"][1] = 0
		#abyssDict["abyssBonusR"][2] = 0
		#abyssDict["abyssLid"] = 0
		#abyssDict["abyssGlaze"] = 0
		#abyssDict["abyssKindling"][0] = 0
		#abyssDict["abyssKindling"][1] = 0
		#abyssDict["abyssKindling"][2] = 0
		#abyssDict["abyssBoss"][0] = 0 #Abyss presence
		#abyssDict["abyssBoss"][1] = 0 #Lenore
		##------------God's Wood-------------#
		#woodsDict["woodsBlooms"] = 0
		#woodsDict["woodsMiniBoss"][0] = 0 #Stump (i think)
		#woodsDict["woodsMiniBoss"][1] = 0 #Gaping Jawer
		#woodsDict["woodsTome"] = 0
		#woodsDict["woodsBonusR"][0] = 0 #14
		#woodsDict["woodsBonusR"][1] = 0 #15
		#woodsDict["woodsKindling"][0] = 0
		#woodsDict["woodsKindling"][1] = 0
		#woodsDict["woodsBoss"] = 0 #Frenzied Growth
		#woodsDict["woodsKey"] = 0 #1 = holding key, 2 = door unlocked
		##------------Church Town----------#
		#townDict["townBlooms"][0] = 0 #16
		#townDict["townBlooms"][1] = 0 #17
		#townDict["townMiniBoss"] = 0 
		#townDict["townTome"] = 0 
		#townDict["townBonusR"][0] = 0 #currently not set up as of 12/26
		#townDict["townBonusR"][1] = 0
		#townDict["townBonusR"][2] = 0
		#townDict["townBonusR"][3] = 0
		#townDict["townKindling"][0] = 0
		#townDict["townKindling"][1] = 0
		#townDict["townKindling"][2] = 0
		#townDict["townKindling"][3] = 0
		#townDict["townKindling"][4] = 0
		#townDict["townSanctuaryBells"][0] = 0 #gold
		#townDict["townSanctuaryBells"][1] = 0 #silver
		#townDict["townEndingChoice"][0] = 0
		#townDict["townEndingChoice"][1] = 0
		#townDict["townEndingChoice"][2] = 0
		#townDict["townBoss"] = 0 #Forsaken

##Ties into the new game plus feature
## see: main_menu.gd
func start_new_game():
	new_game.emit()

## Called when player starts a new game
func reset_game_values():
	if !debug:
		player_church_town_entered = false
		player_gods_wood_entered = false
		playerActiveSouls = 0 #is referenced
		playerLifetimeSouls = 0 #is referenced
		playerKillCount = 0 #is referenced
		playerBulbsHeld = 0 #can carry up to 5
		playerTomesHeld = 0 #can carry up to 3
		playerKindlingHeld = 0 #can carry up to 10
		playerCapacity = 0 #goes up to 5, upgraded by Jari in exchange for bulbs
		playerEfficiency = 0 #goes up to 3, upgraded by Sculptor in exchange for tomes
		playerIntensity = 0 #goes up to 10, upgraded by Zenith in exchange for kindling
		favor = -1
		completion = false
		newgame = 0 #this controls enemies scaling with NG+, so on a new game it should be 0
		mote_residue = false
		mote_residue_value = 0
		mote_residue_position = Vector2(9999,9999)
		mote_residue_scene = "res://scenes/nullscn.tscn"
		npcDict["jari"] = 0
		npcDict["sculptor"] = 0
		npcDict["zn"] = 0
		#--------------Abyss------------#
		abyssDict["abyssBlooms"][0] = 0
		abyssDict["abyssBlooms"][1] = 0
		abyssDict["abyssMiniBoss"] = 0
		abyssDict["abyssTome"] = 0
		abyssDict["abyssBonusR"][0] = 0
		abyssDict["abyssBonusR"][1] = 0
		abyssDict["abyssBonusR"][2] = 0
		abyssDict["abyssLid"] = 0
		abyssDict["abyssGlaze"] = 0
		abyssDict["abyssKindling"][0] = 0
		abyssDict["abyssKindling"][1] = 0
		abyssDict["abyssKindling"][2] = 0
		abyssDict["abyssBoss"][0] = 0 #Abyss presence
		abyssDict["abyssBoss"][1] = 0 #Lenore
		#------------God's Wood-------------#
		woodsDict["woodsBlooms"] = 0
		woodsDict["woodsMiniBoss"][0] = 0 #Stump (i think)
		woodsDict["woodsMiniBoss"][1] = 0 #Gaping Jawer
		woodsDict["woodsTome"] = 0
		woodsDict["woodsBonusR"][0] = 0 #14
		woodsDict["woodsBonusR"][1] = 0 #15
		woodsDict["woodsKindling"][0] = 0
		woodsDict["woodsKindling"][1] = 0
		woodsDict["woodsBoss"] = 0 #Frenzied Growth
		woodsDict["woodsKey"] = 0 #1 = holding key, 2 = door unlocked
		#------------Church Town----------#
		townDict["townBlooms"][0] = 0 #16
		townDict["townBlooms"][1] = 0 #17
		townDict["townMiniBoss"] = 0 
		townDict["townTome"] = 0 
		townDict["townBonusR"][0] = 0 #currently not set up as of 12/26
		townDict["townBonusR"][1] = 0
		townDict["townBonusR"][2] = 0
		townDict["townBonusR"][3] = 0
		townDict["townKindling"][0] = 0
		townDict["townKindling"][1] = 0
		townDict["townKindling"][2] = 0
		townDict["townKindling"][3] = 0
		townDict["townKindling"][4] = 0
		townDict["townSanctuaryBells"][0] = 0 #gold
		townDict["townSanctuaryBells"][1] = 0 #silver
		townDict["townEndingChoice"][0] = 0
		townDict["townEndingChoice"][1] = 0
		townDict["townEndingChoice"][2] = 0
		townDict["townBoss"] = 0 #Forsaken

## Called when player initiates New Game Plus
func new_game_plus():
		playerActiveSouls = 0
		playerLifetimeSouls = 0 
		playerKillCount = 0 
		##player keeps all items and stat boosts
		completion = false
		##This is already called by the decision box event
		#newgame += 1 
		favor = -1
		npcDict["jari"] = 0
		npcDict["sculptor"] = 0
		npcDict["zn"] = 0
		#--------------Abyss------------#
		abyssDict["abyssBlooms"][0] = 0
		abyssDict["abyssBlooms"][1] = 0
		abyssDict["abyssMiniBoss"] = 0
		abyssDict["abyssTome"] = 0
		abyssDict["abyssBonusR"][0] = 0
		abyssDict["abyssBonusR"][1] = 0
		abyssDict["abyssBonusR"][2] = 0
		abyssDict["abyssLid"]= 2 #turns these chests into bonus chests
		abyssDict["abyssGlaze"] = 2 #ditto
		abyssDict["abyssKindling"][0] = 0
		abyssDict["abyssKindling"][1] = 0
		abyssDict["abyssKindling"][2] = 0
		abyssDict["abyssBoss"][0] = 0 #Abyss presence
		abyssDict["abyssBoss"][1] = 0 #Lenore
		#------------God's Wood-------------#
		woodsDict["woodsBlooms"] = 0
		woodsDict["woodsMiniBoss"][0] = 0 #Stump (i think)
		woodsDict["woodsMiniBoss"][1] = 0 #Gaping Jawer
		woodsDict["woodsTome"] = 0
		woodsDict["woodsBonusR"][0] = 0 #14
		woodsDict["woodsBonusR"][1] = 0 #15
		woodsDict["woodsKindling"][0] = 0
		woodsDict["woodsKindling"][1] = 0
		woodsDict["woodsBoss"] = 0 #Frenzied Growth
		woodsDict["woodsKey"] = 0 #1 = holding key, 2 = door unlocked
		#------------Church Town----------#
		townDict["townBlooms"][0] = 0 #16
		townDict["townBlooms"][1] = 0 #17
		townDict["townMiniBoss"] = 0 #Censer
		townDict["townTome"] = 0 #Censer Reward
		townDict["townBonusR"][0] = 0 
		townDict["townBonusR"][1] = 0
		townDict["townBonusR"][2] = 0
		townDict["townBonusR"][3] = 0
		townDict["townKindling"][0] = 0
		townDict["townKindling"][1] = 0
		townDict["townKindling"][2] = 0
		townDict["townKindling"][3] = 0
		townDict["townKindling"][4] = 0
		townDict["townSanctuaryBells"][0] = 0 #gold
		townDict["townSanctuaryBells"][1] = 0 #silver
		##We wanna preserve the state of these from previous runs (0 = not acquried, 1 = acquired this run, 2 = acquired sometime during this save), see below
		#townDict["townEndingChoice"][0] = 0
		#townDict["townEndingChoice"][1] = 0
		#townDict["townEndingChoice"][2] = 0
		townDict["townBoss"] = 0 #Forsaken
		await get_tree().create_timer(3).timeout
		if townDict["townEndingChoice"][1] == 2 or townDict["townEndingChoice"][2] == 2:
			impostor = true
			Localize.reference_dialogue("JournalTip")

func coop_start():
	var my_player_two = buddy.instantiate()
	coop = true
	add_child(my_player_two)
	target_buddy = my_player_two

##Seemingly only referenced by the updated Potheads
func signal_unpause():
	unpause.emit()
