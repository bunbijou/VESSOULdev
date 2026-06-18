extends Node2D
var item_list : String = ""
var boon : int = 0
var boon_list : String = ""

func concatenate(add_string : String):
	if item_list == "":
		item_list = add_string
	else:
		item_list += ","+add_string

func concatenate_boon(add_string : String):
	if boon_list == "":
		boon_list = add_string
	else:
		boon_list += ","+add_string

func _ready() -> void:
	%Restart.grab_focus()
	LevelTransition.fadeFromBlack()
	%GameOverText.text = Localize.endless_death
	
	%DecorDawn.visible = false
	%DecorDusk.visible = false
	%DecorTwilight.visible = false
	
	match GameState.endless["theme"]:
		0: 
			%DecorDawn.visible = true
			BgmController.track_tomorrow.play()
		1: 
			%DecorDusk.visible = true
			BgmController.catacombs.play() #Sacrosanct
		2: 
			%DecorTwilight.visible = true
			BgmController.zn_theme.play() #Chimera
		
	
	##Update high scores
	if GameState.endless["maze_level"][0] > GameState.endless["maze_level"][1]:
		GameState.endless["maze_level"][1] = GameState.endless["maze_level"][0]
	if GameState.endless["maze_difficulty"][0] > GameState.endless["maze_difficulty"][1]:
		GameState.endless["maze_difficulty"][1] = GameState.endless["maze_difficulty"][0]
	
	## Generate list of acquired items
	## Grimoire
	if GameState.npcDict["sculptor"] == 999: 
		concatenate(Localize.endless_rare_tome) 
		if GameState.playerEfficiency > 2: ## Regular tomes
			concatenate(Localize.item_tome+" x "+str(GameState.playerEfficiency - 2))
	## Big Bloombulb
	if GameState.npcDict["jari"] == 999: 
		concatenate(Localize.endless_rare_bulb)
		if GameState.playerCapacity > 6:
			concatenate(Localize.item_bloombulb+" x "+str(GameState.playerCapacity - 6))
	## Chimera Scale
	if GameState.npcDict["zn"] == 999: 
		concatenate(Localize.endless_rare_scale)
		if GameState.playerIntensity > 3:
			concatenate(Localize.item_kindling+" x "+str(GameState.playerIntensity - 3))
	## Mr. Bjorn
	if GameState.favor == 2: concatenate(Localize.endless_item_teddybear)
	## Pot Lid
	if GameState.abyssDict["abyssLid"] == 1: concatenate(Localize.item_lid)
	## Glaze
	if GameState.abyssDict["abyssGlaze"] != 0: concatenate(Localize.item_glaze)
	## Extra Coat
	if GameState.abyssDict["abyssGlaze"] >= 1:
		var coats : int = GameState.abyssDict["abyssGlaze"]
		concatenate(Localize.endless_item_glaze+" x "+str(coats))
	## Key (Idk why you would not just use this)
	if GameState.woodsDict["woodsKey"] == 1:
		concatenate(Localize.endless_item_key)
	## No items
	if item_list == "":
		item_list = "N/A"
	## Boons and Curses
	boon = GameState.endless["boon_sun"]+GameState.endless["boon_mercury"]+GameState.endless["boon_venus"]+GameState.endless["boon_moon"]+GameState.endless["boon_mars"]+GameState.endless["boon_jupiter"]+GameState.endless["curse_saturn"]+GameState.endless["curse_void"]
	if boon > 1:
		if GameState.endless["boon_sun"] == 1:
			concatenate_boon(Localize.endless_sun_boon)
		if GameState.endless["boon_mercury"] == 1:
			concatenate_boon(Localize.endless_mercury_boon)
		if GameState.endless["boon_venus"] == 1:
			concatenate_boon(Localize.endless_venus_boon)
		if GameState.endless["boon_moon"] == 1:
			concatenate_boon(Localize.endless_moon_boon)
		if GameState.endless["boon_mars"] == 1:
			concatenate_boon(Localize.endless_mars_boon)
		if GameState.endless["boon_jupiter"] == 1:
			concatenate_boon(Localize.endless_jupiter_boon)
		if GameState.endless["curse_saturn"] == 1:
			concatenate_boon(Localize.endless_saturn_boon)
		if GameState.endless["curse_void"] == 1:
			concatenate_boon(Localize.endless_void_boon)
	else: boon_list = "N/A"

	## Text display
	%StatsLabel.text = Localize.menu_endless_level+": "+str(GameState.endless["maze_level"][0])+"
	"+Localize.menu_endless_level+" ("+Localize.suffix_all_time+"): "+str(GameState.endless["maze_level"][1])+"
	"+Localize.menu_endless_difficulty+": "+str(GameState.endless["maze_difficulty"][0])+"
	"+Localize.menu_endless_difficulty+" ("+Localize.suffix_all_time+"): "+str(GameState.endless["maze_difficulty"][0])+"
	"+Localize.death_description+str(GameState.last_enemy)+"
	"+Localize.endless_items+" "+Localize.item_get_suffix+": "+item_list+"
	"+Localize.endless_boons+" "+Localize.item_get_suffix+": "+boon_list

func reset_game_values():
	GameState.endless["maze_level"][0] = 0 #reset current level
	GameState.endless["boon_sun"] = 0
	GameState.endless["boon_mercury"] = 0
	GameState.endless["boon_venus"] = 0
	GameState.endless["boon_moon"] = 0
	GameState.endless["boon_mars"] = 0
	GameState.endless["boon_jupiter"] = 0
	GameState.endless["curse_saturn"] = 0
	GameState.endless["curse_void"] = 0
	GameState.newgame = 0
	GameState.playerSatietyAdd = 0
	GameState.playerSpeedGainAdd = 0
	GameState.playerDamageAdd = 0
	GameState.playerHitstunAdd = 0
	GameState.playerActiveSouls = 0
	GameState.playerLifetimeSouls = 0
	GameState.playerKillCount = 0
	GameState.playerCapacity = 0
	GameState.playerEfficiency = 0
	GameState.playerIntensity = 0
	GameState.abyssDict["abyssLid"] = 0
	GameState.abyssDict["abyssGlaze"] = 0
	GameState.woodsDict["woodsKey"] = 0
	GameState.favor = 0
	GameState.player_hp_previous = 3
	GameState.npcDict["sculptor"] = 0
	GameState.npcDict["zn"] = 0
	GameState.npcDict["jari"] = 0

func _on_restart_pressed() -> void:
	Sound.menu("accept")
	reset_game_values()
	await get_tree().create_timer(.5).timeout
	BgmController.stopAll()
	get_tree().call_deferred("change_scene_to_file","res://endless.tscn")


func _on_main_menu_pressed() -> void:
	Sound.menu("accept")
	reset_game_values()
	await get_tree().create_timer(.5).timeout
	BgmController.stopAll()
	get_tree().change_scene_to_file("res://mainMenu.tscn") # change scene
