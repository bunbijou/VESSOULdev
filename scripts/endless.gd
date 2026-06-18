extends Node

signal update_theme
signal activate_A
signal activate_B
signal activate_C
signal activate_D
signal activate_E
signal condition_met

## Adjustable values
@export var tileset_dawn : TileSet 
@export var tileset_dusk : TileSet
@export var tileset_twilight : TileSet
var guardian_spd : float = 0
var guardian_spd_base : int = 5
var guardian_spd_mod : int = 1
var guardian_hitstun : float = 1.28
@export var maze_time_limit : float = 3500
#@export_enum("Store", "Standard", "Hazard", "Freezing", "Burning", "Dousing", "Explosion","Cloud","SelfDestruct","Alert","FallOut","Instakill","AdvancedDarkness") var maze_data: String #make into strings?
#@export var maze_start_point : Array
@export var sidebar_base : AnimationPlayer
@export var maze_random_selection_hi_lo : Array
## Data that will change every run
var initial_time_limit : float = 0 #see below
var initial_position : Vector2 = Vector2(0,0)
var count : float = 0
var maze_state : int = 1
var initial_motes : int 
var motes_required : int = 0
@export_enum("RandomMaze","Shop") var maze_current : String
var maze_previous : String = "Null"
var maze_current_num : int = 0
var restock : bool = false #signals to restock shop items by reloading scene
var initial_difficulty : int = 0
var game_over : bool = false

## Info Banner (Resurrection, Ascension)
func anim_banner_info(type : String, duration):
	match type:
		"cure_success":
			%BoonMessage.text = Localize.endless_cure_scroll_positive
			%BoonMessage.visible = true
			await get_tree().create_timer(duration).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
		"cure_backfire": pass
		"resurrect":
			%BoonMessage.text = Localize.endless_jupiter_resurrection
			%BoonMessage.visible = true
			await get_tree().create_timer(duration).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
		"ascension":
			%BoonMessage.text = Localize.endless_ascension
			%BoonMessage.visible = true
			await get_tree().create_timer(duration).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
		"ruler_alert":
			%BoonMessage.text = Localize.endless_ruler_alert
			%BoonMessage.visible = true
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = Localize.endless_ruler_alert
			%BoonMessage.visible = true
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = Localize.endless_ruler_alert
			%BoonMessage.visible = true
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = Localize.endless_ruler_alert
			%BoonMessage.visible = true
			await get_tree().create_timer(duration/4).timeout #IMPORTANT 
			%BoonMessage.text = ""
			%BoonMessage.visible = false

## Gameplay
func _ready() -> void:
	initial_time_limit = maze_time_limit
	%EndlessGUI.visible = true
	%BoonMessage.visible = false
	GameState.target_player.player_resurrect.connect(boon_jupiter_ascension)
	DecisionSelect.motebasin.connect(mote_storage)
	GameState.disable_mote_rewards = true
	theme_switch()
	if maze_current == "Shop":
		Sound.LoopingSoundCleanup()
		enter_store()
	else: random_maze_select()
	##Bonus HP for endless mode
	GameState.playerCapacityAdd = 2

func _process(_delta: float) -> void:
	###Signal when difficulty changes (see below)
	initial_difficulty = GameState.newgame
	
	## Scaling Difficulty
	guardian_spd = guardian_spd_base*guardian_spd_mod*(GameState.endless["maze_difficulty"][0]+1)
	@warning_ignore("integer_division")
	GameState.newgame = int(GameState.endless["maze_level"][0]/10)
	GameState.endless["maze_difficulty"][0] = GameState.newgame
	
	if GameState.newgame > initial_difficulty:
		anim_banner_info("ascension", 5)
		maze_time_limit *= 1-(GameState.newgame*.10)
		initial_difficulty = GameState.newgame
		print("Endless difficulty increased")
	
	##Boons and Curses / Endless Mode GUI
	if GameState.endless["boon_sun"] == 1:
		%SpriteBoonSun.visible = true
		GameState.playerSatietyAdd = 1
	else:
		%SpriteBoonSun.visible = false
		GameState.playerSatietyAdd = 0
	
	if GameState.endless["boon_mercury"] == 1:
		%SpriteBoonMercury.visible = true
		GameState.playerSpeedGainAdd = GameState.playerSoulSpeedGain
	else:
		%SpriteBoonMercury.visible = false
		GameState.playerSpeedGainAdd = 0
	
	if GameState.endless["boon_venus"] == 1:
		%SpriteBoonVenus.visible = true
	else: %SpriteBoonVenus.visible = false
	
	if GameState.endless["boon_moon"] == 1:
		%SpriteBoonMoon.visible = true
	else: %SpriteBoonMoon.visible = false
	
	if GameState.endless["boon_mars"] == 1:
		%SpriteBoonMars.visible = true
		GameState.playerHitstunAdd = true
		guardian_hitstun = 2
	else:
		%SpriteBoonMars.visible = false
		GameState.playerHitstunAdd = false
		guardian_hitstun = 1.28 #see above	
	
	if GameState.endless["boon_jupiter"] == 1:
		%SpriteBoonJupiter.visible = true
	else: %SpriteBoonJupiter.visible = false
	
	if GameState.endless["curse_void"] == 1:
		%SpriteCurseVoid.visible = true
		GameState.target_player.fragile = true
		GameState.playerEfficiencyAddBeta = 1
	else: 
		%SpriteCurseVoid.visible = false
		GameState.playerEfficiencyAddBeta = 0
	
	if GameState.endless["curse_saturn"] == 1:
		%SpriteCurseSaturn.visible = true
		maze_time_limit = initial_time_limit*0.75
	else: %SpriteCurseSaturn.visible = false
	
	##Endless GUI
	%MazeLevel.text = Localize.menu_endless_level+"
	"+str(GameState.endless["maze_level"][0])
	if GameState.newgame > 0:
		%DifficultyLevel.visible = true
		%DifficultyLevel.text = Localize.menu_endless_difficulty+"
		"+str(GameState.newgame)
	else: %DifficultyLevel.visible = false
	
	#We want these to only happen once per complete maze event cycle
	if maze_current != "Shop":
		if maze_state <= 5:
			if GameState.target_player.current_zone != 1000:
				if GameState.playerLifetimeSouls >= initial_motes+motes_required:
					maze_success()
			count += 1
			#activate_A.emit()
			#activate_B.emit()
			#activate_C.emit()
			#activate_D.emit()
			# At 1/4th elapsed time
			if count >= maze_time_limit*0.25 and maze_state == 0:
				activate_A.emit()
				print("Activated Guardian A")
				maze_state = 1
			# At 1/2 elapsed time
			if count >= maze_time_limit*0.5 and maze_state == 1:
				activate_B.emit()
				print("Activated Guardian B")
				maze_state = 2
			# At 3/4ths elapsed time:
			if count >= maze_time_limit*0.75 and maze_state == 2:
				activate_C.emit()
				print("Activated Guardian C")
				maze_state = 3
			# When time limit reached:
			if count >= maze_time_limit and maze_state == 3:
				activate_D.emit()
				print("Activated Guardian E")
				maze_state = 4
			# When 2x time limit reached (temporarily 1.5)
			if count >= maze_time_limit*1.5 and maze_state == 4:
				anim_banner_info("ruler_alert",4)
				activate_E.emit()
				print("Activated Guardian F")
				maze_state = 5

	## Manual theme change by player
	if Input.is_action_just_pressed("endless_switch_theme_dawn"):
		if GameState.endless["theme"] != 0:
			GameState.endless["theme"] = 0
			theme_switch()
	if Input.is_action_just_pressed("endless_switch_theme_dusk"):
		if GameState.endless["theme"] != 1:
			GameState.endless["theme"] = 1
			theme_switch()
	if Input.is_action_just_pressed("endless_switch_theme_twilight"):
		if GameState.endless["theme"] != 2:
			GameState.endless["theme"] = 2
			theme_switch()

## Mote Basin
func mote_storage(action : String):
	match action:
		"deposit":
			if GameState.playerLifetimeSouls > 0:
				Sound.MoteCollect()
				@warning_ignore("narrowing_conversion")
				GameState.endless["stored_motes"] += GameState.playerLifetimeSouls
				#GameState.playerActiveSouls = 0
				GameState.playerLifetimeSouls = 0
				Localize.mote_basin_interface("Deposit", GameState.endless["stored_motes"])
				Dialogue.remote_end_dialogue()
			else: 
				Localize.reference_dialogue("BellInsufficientMotes")
				Dialogue.remote_end_dialogue()
		"withdraw":
			if GameState.endless["stored_motes"] > 0:
				if GameState.endless["stored_motes"] < 65:
					GameState.target_player.anim_mote_absorb_small()
				else: GameState.target_player.anim_mote_absorb()
				#GameState.playerActiveSouls += GameState.endless["stored_motes"]
				GameState.playerLifetimeSouls += GameState.endless["stored_motes"]
				Localize.mote_basin_interface("Withdraw", GameState.endless["stored_motes"])
				await get_tree().create_timer(.01).timeout
				GameState.endless["stored_motes"] = 0
				Dialogue.remote_end_dialogue()
			else: 
				Localize.reference_dialogue("BellInsufficientMotes")
				Dialogue.remote_end_dialogue()

func player_reposition():
		GameState.target_player.fallen = false
		await get_tree().create_timer(2).timeout
		GameState.target_player.position = initial_position
		GameState.target_player.play_anim("reset")

## Jove's Boon Resurrection
func boon_jupiter_ascension():
	if GameState.endless["boon_jupiter"] == 1:
		GameState.target_player.dead = false
		anim_banner_info("resurrect",3)
		GameState.fullHeal()
		GameState.target_player.invincibility = true
		print("Jove's boon was used up")
		GameState.endless["boon_jupiter"] = 0
		await get_tree().create_timer(GameState.target_player.hit_stun*2).timeout
		GameState.target_player.invincibility = false
		if GameState.target_player.fallen:
			player_reposition()
	else: 
		print("Player failed resurrection check")
		initial_motes = 0
		maze_current = "RandomMaze"
		await get_tree().create_timer(2.5).timeout
		get_tree().call_deferred("change_scene_to_file","res://gameover.tscn")

## Portal to shop / Portal to maze
func portal_entered() -> void:
	var shop_gap : int = 0
	
	if GameState.newgame != 0:
		shop_gap = int((GameState.endless["maze_level"][0]/GameState.newgame)/GameState.newgame)
	else: shop_gap = 0
	
	GameState.player_hp_previous = GameState.playerHP
	Sound.warp()
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(1).timeout
	if maze_current == "Shop":
		random_maze_select()
	else: #to-do tie to maze level
		if shop_gap == 0:
			maze_previous = maze_current
			enter_store()
		else:
			if (GameState.endless["maze_level"][0] / shop_gap) == 0:
				random_maze_select()
			else: enter_store()

## Enter Shop
func enter_store():
	GameState.pause_mote_decay = true
	GameState.target_player.current_zone = 1000
	GameState.shadeActive = false
	if restock == true:
		restock = false
		GameState.playerCurrentLocation = %Axis0.position
		if GameState.coop:
			GameState.target_buddy.position = %Axis0.position + Vector2(10,0)
		get_tree().reload_current_scene() 
	#%EndlessMoteGoalBox.visible = false
	#%EndlessMoteGoal.visible = false
	LevelTransition.fadeFromBlack()
	initial_motes = 0
	motes_required = 0
	GameState.target_player.position = %Axis0.position
	%RoamingCamera.position = GameState.target_player.position+Vector2(0,3)
	BgmController.stopAll()
	restock = true
	shop_music()

func shop_music():
	## This is just to prevent a slight stutter when reloading the scene
	#await get_tree().create_timer(1).timeout
	BgmController.track_market.play()

## Generate a random maze selection
func random_maze_select():
	var selection : int = 0
	BgmController.stopAll()
	BgmController.play_random()
	LevelTransition.fadeFromBlack()
	randomize()
	selection = randi_range(maze_random_selection_hi_lo[0],maze_random_selection_hi_lo[1])
	GameState.target_player.current_zone = 1000+selection
	@warning_ignore("narrowing_conversion")
	maze_state = 0
	count = 0 #reset count
	start_maze(selection)

## Load the properties of the selected maze (see above)
func start_maze(selection : int):
	GameState.pause_mote_decay = false
	maze_current_num = selection
	@warning_ignore("narrowing_conversion")
	initial_motes = GameState.playerLifetimeSouls
	motes_required = 999 #debug
	match selection:
		1:
			##The conditional completion stuff in this block doesn't work
			#if GameState.endless_completion["PotheadMaze"] != 1:
			maze_current = "PotheadMaze"
			motes_required = 233 ## is precise
			GameState.target_player.position = %Axis1.position
			#else: 
			#	print("PotheadMaze complete, cycling to next")
			#start_maze(selection+1)
		2:
			maze_current = "BlackMoteMaze"
			motes_required = 208 ##is precise
			GameState.target_player.position = %Axis2.position
		3:
			maze_current = "MoteMouseMaze"
			motes_required = 226 ##is precise
			GameState.target_player.position = %Axis3.position
		4:
			maze_current = "LilJawerMaze"
			motes_required = 248 ##is precise
			GameState.target_player.position = %Axis4.position
		5:
			maze_current = "WispflowerMaze"
			motes_required = 206 ##precise
			GameState.target_player.position = %Axis5.position
		6:
			maze_current = "ShadowLurkerMaze"
			motes_required = 293 ##exact
			GameState.target_player.position = %Axis6.position
		7:
			maze_current = "MoteMuncherMaze"
			motes_required = 236 ##is precise
			GameState.target_player.position = %Axis7.position
		8:
			maze_current = "ShadowSnakeMaze"
			motes_required = 275 ##is exact
			GameState.target_player.position = %Axis8.position
		9:
			maze_current = "SinkholeMaze"
			motes_required = 235 ##precise
			GameState.target_player.position = %Axis9.position
		10:
			maze_current = "MimicMaze"
			motes_required = 168 ##precise
			GameState.target_player.position = %Axis10.position
		11:
			maze_current = "MuckmanMaze"
			motes_required = 244
			GameState.target_player.position = %Axis11.position
		12:
			maze_current = "OssuaryMaze"
			motes_required = 222 ##is exact
			GameState.target_player.position = %Axis12.position
		13:
			maze_current = "GazerMaze"
			motes_required = 139 ##is precise
			GameState.target_player.position = %Axis13.position
		14:
			maze_current = "BurnoutMaze"
			motes_required = 201 ## is precise
			GameState.target_player.position = %Axis14.position
		15:
			maze_current = "CrematorMaze"
			motes_required = 214 ## is precise
			GameState.target_player.position = %Axis15.position
		16:
			maze_current = "DouserMaze"
			motes_required = 224 ##precise
			GameState.target_player.position = %Axis16.position
			
		17:
			maze_current = "ShadeMaze"
			motes_required = 220 ##is precise
			GameState.target_player.position = %Axis17.position
			
		18:
			maze_current = "FreezerMaze"
			motes_required = 245
			GameState.target_player.position = %Axis18.position
		19:
			maze_current = "RavenMaze"
			motes_required = 208
			GameState.target_player.position = %Axis19.position
	initial_position = GameState.target_player.position
	if GameState.endless["boon_sun"] == 1:
		motes_required = motes_required*2
	#%EndlessMoteGoalBox.visible = true
	#%EndlessMoteGoal.visible = true
	#%EndlessMoteGoal.text = str(Localize.endless_goal)+"
	#• × "+str(motes_required)
	##Not working as of right now
	#No one likes playing the same maze twice
	#if maze_current == maze_previous:
		#maze_previous = maze_current
		#random_maze_select()
	await get_tree().create_timer(.01).timeout
	%RoamingCamera.position = GameState.target_player.position
	if GameState.coop:
		GameState.target_buddy.position = GameState.target_player.position+Vector2(10,0)

## "Ascension" / Resetting maze completion state + Increase Difficulty
# Currently not used because the mazes are too goddamn hard
#func endless_difficulty_up():
	#print("All mazes complete; resetting")
	#GameState.endless_completionmaze_completion["PotheadMaze"] = 0
	#GameState.endless_completionmaze_completion["BlackMoteMaze"] = 0
	#GameState.endless_completion["MoteMouseMaze"] = 0
	#GameState.endless_completion["LilJawerMaze"] = 0
	#GameState.endless_completion["WispflowerMaze"] = 0
	#GameState.endless_completion["ShadowLurkerMaze"] = 0
	#GameState.endless_completion["MoteMuncherMaze"] = 0
	#GameState.endless_completion["ShadowSnakeMaze"] = 0
	#GameState.endless_completion["SinkholeMaze"] = 0
	#GameState.endless_completion["MimicMaze"] = 0
	#GameState.endless_completion["MuckmanMaze"] = 0
	#GameState.endless_completion["OssuaryMaze"] = 0
	#GameState.endless_completion["GazerMaze"] = 0
	#GameState.endless_completion["BurnoutMaze"] = 0
	#GameState.endless_completion["CrematorMaze"] = 0
	#GameState.endless_completion["DouserMaze"] = 0
	#GameState.endless_completion["ShadeMaze"] = 0
	#GameState.endless_completion["FreezerMaze"] = 0
	#GameState.endless_completion["RavenMaze"] = 0
	#GameState.newgame += 1
	#random_maze_select()
	#await get_tree().create_timer(.01).timeout
	#anim_banner_info("ascension",3)

## Switch between Dawn, Dusk, or Twilight visuals
func theme_switch():
	update_theme.emit(GameState.endless["theme"])
	match GameState.endless["theme"]:
		0: 
			var my_random : int
			randomize()
			GameState.endless["theme"] = 0
			%ThemeCursor.position = Vector2(5,83)
			%EndlessTileMap.tile_set = tileset_dawn
			%BGDuskA.visible = false
			%BGDuskB.visible = false
			%BGDuskC.visible = false
			%BGTwilightA.visible = false
			%BGTwilightB.visible = false
			%BGTwilightC.visible = false
			my_random = randi() % 3
			match my_random:
					0: 
						%BGDawnA.visible = true
						%BGDawnB.visible = false
						%BGDawnC.visible = false
					1: 
						%BGDawnA.visible = false
						%BGDawnB.visible = true
						%BGDawnC.visible = false
					2: 
						%BGDawnA.visible = false
						%BGDawnB.visible = false
						%BGDawnC.visible = true
		1: 
			var my_random : int
			randomize()
			GameState.endless["theme"] = 1
			%ThemeCursor.position = Vector2(5,93)
			%EndlessTileMap.tile_set = tileset_dusk
			%BGDawnA.visible = false
			%BGDawnB.visible = false
			%BGDawnC.visible = false
			%BGTwilightA.visible = false
			%BGTwilightB.visible = false
			%BGTwilightC.visible = false
			my_random = randi() % 3
			match my_random:
					0: 
						%BGDuskA.visible = true
						%BGDuskB.visible = false
						%BGDuskC.visible = false
					1: 
						%BGDuskA.visible = false
						%BGDuskB.visible = true
						%BGDuskC.visible = false
					2: 
						%BGDuskA.visible = false
						%BGDuskB.visible = false
						%BGDuskC.visible = true
		2: 
			var my_random : int
			randomize()
			GameState.endless["theme"] = 2
			%ThemeCursor.position = Vector2(5,102)
			%EndlessTileMap.tile_set = tileset_twilight
			%BGDawnA.visible = false
			%BGDawnB.visible = false
			%BGDawnC.visible = false
			%BGDuskA.visible = false
			%BGDuskB.visible = false
			%BGDuskC.visible = false
			my_random = randi() % 3
			match my_random:
					0: 
						%BGTwilightA.visible = true
						%BGTwilightB.visible = false
						%BGTwilightC.visible = false
					1: 
						%BGTwilightA.visible = false
						%BGTwilightB.visible = true
						%BGTwilightC.visible = false
					2: 
						%BGTwilightA.visible = false
						%BGTwilightB.visible = false
						%BGTwilightC.visible = true

func _on_button_dawn_pressed() -> void:
	if GameState.endless["theme"] != 0:
		Sound.respawn() #placeholder
		GameState.endless["theme"] = 0
		theme_switch()

func _on_button_dusk_pressed() -> void:
	if GameState.endless["theme"] != 1:
		Sound.respawn() #placeholder
		GameState.endless["theme"] = 1
		theme_switch()

func _on_button_twilight_pressed() -> void:
	if GameState.endless["theme"] != 2:
		Sound.respawn() #placeholder
		GameState.endless["theme"] = 2
		theme_switch()

##Experimental
func _exit_tree() -> void:
	print("Reset player added HP back to default value (0)")
	GameState.playerCapacityAdd = 0

func maze_success():
	print("Maze complete!")
	condition_met.emit()
	GameState.target_player.mice_count = 0
	GameState.target_player.play_anim("reset")
	maze_state = 6
	GameState.endless["maze_level"][0] += 1 
	@warning_ignore("integer_division")
	##Additional Interest Gain from Aurael's boon
	if GameState.endless["boon_sun"] == 1:
		GameState.endless["stored_motes"] += int(GameState.endless["stored_motes"]/2.5)
	else: GameState.endless["stored_motes"] += int(GameState.endless["stored_motes"]/5)
	print("Stored motes accrued interest (New value:"+str(GameState.endless["stored_motes"])+")")
	GameState.endless_completion[maze_current] = 1
