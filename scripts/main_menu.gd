extends Node2D
@export_enum("res://abyss.tscn","res://chasm.tscn","res://woods.tscn","res://depths.tscn","res://town.tscn","res://catacombs.tscn","res://clerestory.tscn","res://sanctuary.tscn","res://yz.tscn") var sceneNewGame: String

@onready var display_setting : String = "Windowed"
@onready var music_setting : float = 1
@onready var sound_setting : float = 1
@onready var language_setting : String = "English"
@onready var has_played_endless : bool = false

func anim_menu_light(setting : String):
	match setting:
		"on":
			%lightSprite.visible = true
			%lightSprite2.visible = true
		"off":
			%lightSprite.visible = false
			%lightSprite2.visible = false
			Sound.PlayerExtinguished()

func _ready() -> void:
		get_tree().paused = false
		DecisionSelect.endless_start.connect(endless_mode)
		%NewGame.grab_focus()
		Sound.LoopingSoundCleanup()
		print("Loading engine data...")
		engine_load()
		GameState.new_game.connect(start_new_game)
		LevelTransition.fadeFromBlack()
		anim_menu_light("on")
		##ONLY if the Good endings(s) have been aquired during this session do we provide Samael buddy
		if GameState.townDict["townEndingChoice"][1] == 2 or GameState.townDict["townEndingChoice"][2] == 2:
			%NewGame.text = "φ "+str(Localize.menu_new_game)
		else: %NewGame.text = str(Localize.menu_new_game)
		
		if GameState.completion == true:
			%CompletionLabel.visible = true
			%CompletionLabel.text = str(Localize.menu_completion)+"
			(NG+"+str(GameState.newgame)+")"
		else:
			%CompletionLabel.visible = false
			%CompletionLabel.text = ""
		
		%Continue.text = str(Localize.menu_continue)
		%Options.text = str(Localize.menu_options)
		%LabelOptionsHeader.text = str(Localize.menu_options)
		%LabelLanguage.text = str(Localize.menu_language)
		%LabelDisplay.text = str(Localize.menu_display)
		%LabelMusic.text = str(Localize.menu_music)
		%LabelSFX.text = str(Localize.menu_sfx)
		%OptionsClose.text = str(Localize.menu_return_to_menu)
		%LabelMute1.text = str(Localize.menu_mute)
		%LabelMute2.text = str(Localize.menu_mute)
		%DeleteSaveConsentHeader.text = str(Localize.menu_delete_save_consent)
		%DeleteSaveConsentSubheader.text = str(Localize.menu_delete_save_consent_add)
		%DeleteSaveConsentYes.text = str(Localize.menu_confirm)
		%DeleteSaveConsentNo.text = str(Localize.menu_deny)
		%SimpleModeLabel.text = str(Localize.menu_simple_mode)
		%SimpleModeDescLabel.text = str(Localize.menu_simple_mode_desc)
		%Quit.text = str(Localize.menu_quit_to_desktop)
		%Endless.text = str(Localize.menu_endless_mode)
		BgmController.abyss_chasm_ambience.play()
		BgmController.menu_theme.play()

func _on_new_game_pressed() -> void:
	BgmController.stopAll()
	Sound.menu("accept")
	%MainMenu.visible = false
	##This will only trigger during the active game session; an ending will have to be acquired during this session to trigger
	if GameState.completion == true:
		Localize.new_game_plus_consent()
	else:start_new_game()

func start_new_game():
	%CompletionLabel.visible = false
	BgmController.stopAll()
	anim_menu_light("off")
	##if not new game plus, defer to default un-saved state
	if GameState.newgame == 0:
		GameState.saveslot = 0
	GameState.playerCurrentLocation = Vector2(0,320) #Hardcoded location of Abyss spawn point
	await get_tree().create_timer(1.5).timeout
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(1.5).timeout
	if GameState.newgame == 0:
		GameState.reset_game_values()
	else: GameState.new_game_plus()
	GameState.player_hp_previous = 1
	get_tree().change_scene_to_file(sceneNewGame)

##NOTE: to-do switch .tres to .res for final build / steam release 
func _on_continue_pressed() -> void:
		var data1 = ResourceLoader.load("user://save_data_1.res") as SceneData #load saved data
		var data2 = ResourceLoader.load("user://save_data_2.res") as SceneData #load saved data
		var data3 = ResourceLoader.load("user://save_data_3.res") as SceneData #load saved data

		Sound.menu("accept")
		%TitleMenu.visible = false
		%SaveSelect.visible = true
		%Save1.grab_focus()
		
		if data1: #if data exists
			var glaze_icon : String
			var samael_icon : String
			var favor_icon : String
			var value : int = 0 #for calcualtion
			var title : String #shown to players
			var completion : int #ditto
			var ngplus : String
			
			if data1.abyssData["abyssGlaze"] != 0:
				glaze_icon = "☼"
				value += 1
			else: glaze_icon = ""
			
			if data1.townData["townEndingChoice"][1] == 2 or data1.townData["townEndingChoice"][2] == 2:
				samael_icon = " φ"
			else: samael_icon = ""
			
			if data1.favor == 1:
				favor_icon = " ♥"
			else: favor_icon = ""
			
			if data1.abyssData["abyssLid"] > 0:
				value += 1

			value += data1.playercapacity+data1.playerefficiency+data1.playerintensity

			if value >= 19:
				title = Localize.noun_rank_20
			else:
				match value:
					0: title = Localize.noun_rank
					1: title = Localize.noun_rank_2 
					2: title = Localize.noun_rank_3
					3: title = Localize.noun_rank_4
					4: title = Localize.noun_rank_5
					5: title = Localize.noun_rank_6
					6: title = Localize.noun_rank_7
					7: title = Localize.noun_rank_8
					8: title = Localize.noun_rank_9
					9: title = Localize.noun_rank_10
					10: title = Localize.noun_rank_11 
					11: title = Localize.noun_rank_12
					12: title = Localize.noun_rank_13
					13: title = Localize.noun_rank_14
					14: title = Localize.noun_rank_15
					15: title = Localize.noun_rank_16
					16: title = Localize.noun_rank_17
					17: title = Localize.noun_rank_18
					18: title = Localize.noun_rank_19
			completion = value*5
			
			if data1.newgame != 0: #if player is in NG+
				ngplus = "- NG+"+str(data1.newgame)
			
			%Save1.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
			 "+"Ω ".repeat(int(data1.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
			 "+str(Localize.menu_player_location)+" "+str(data1.activescn).capitalize()+"
			 • × "+str(int(data1.playersouls))+" "+str(ngplus)
		else: %Save1.text =str(Localize.menu_no_data)

		if data2: #if data exists
			var glaze_icon : String
			var samael_icon : String
			var favor_icon : String
			var value : int = 0 #for calcualtion
			var title : String #shown to players
			var completion : int #ditto
			var ngplus : String
			
			if data2.abyssData["abyssGlaze"] != 0:
				glaze_icon = "☼"
				value += 1
			else: glaze_icon = ""
			
			if data2.townData["townEndingChoice"][1] == 2 or data2.townData["townEndingChoice"][2] == 2:
				samael_icon = " φ"
			else: samael_icon = ""
			
			if data2.favor == 1:
				favor_icon = " ♥"
			else: favor_icon = ""
			
			if data2.abyssData["abyssLid"] > 0:
				value += 1

			value += data2.playercapacity+data2.playerefficiency+data2.playerintensity

			if value >= 19:
				title = Localize.noun_rank_20
			else:
				match value:
					0: title = Localize.noun_rank
					1: title = Localize.noun_rank_2 
					2: title = Localize.noun_rank_3
					3: title = Localize.noun_rank_4
					4: title = Localize.noun_rank_5
					5: title = Localize.noun_rank_6
					6: title = Localize.noun_rank_7
					7: title = Localize.noun_rank_8
					8: title = Localize.noun_rank_9
					9: title = Localize.noun_rank_10
					10: title = Localize.noun_rank_11 
					11: title = Localize.noun_rank_12
					12: title = Localize.noun_rank_13
					13: title = Localize.noun_rank_14
					14: title = Localize.noun_rank_15
					15: title = Localize.noun_rank_16
					16: title = Localize.noun_rank_17
					17: title = Localize.noun_rank_18
					18: title = Localize.noun_rank_19
			completion = value*5
			
			if data2.newgame != 0: #if player is in NG+
				ngplus = "- NG+"+str(data2.newgame)
			
			%Save2.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
			 "+"Ω ".repeat(int(data2.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
			 "+str(Localize.menu_player_location)+" "+str(data2.activescn).capitalize()+"
			 • × "+str(int(data2.playersouls))+" "+str(ngplus)
		else: %Save2.text = str(Localize.menu_no_data)

		if data3: #if data exists
			var glaze_icon : String
			var samael_icon : String
			var favor_icon : String
			var value : int = 0 #for calcualtion
			var title : String #shown to players
			var completion : int #ditto
			var ngplus : String
			
			if data3.abyssData["abyssGlaze"] != 0:
				glaze_icon = "☼"
				value += 1
			else: glaze_icon = ""
			
			if data3.townData["townEndingChoice"][1] == 2 or data3.townData["townEndingChoice"][2] == 2:
				samael_icon = " φ"
			else: samael_icon = ""
			
			if data3.favor == 1:
				favor_icon = " ♥"
			else: favor_icon = ""
			
			if data3.abyssData["abyssLid"] > 0:
				value += 1

			value += data3.playercapacity+data3.playerefficiency+data3.playerintensity

			if value >= 19:
				title = Localize.noun_rank_20
			else:
				match value:
					0: title = Localize.noun_rank
					1: title = Localize.noun_rank_2 
					2: title = Localize.noun_rank_3
					3: title = Localize.noun_rank_4
					4: title = Localize.noun_rank_5
					5: title = Localize.noun_rank_6
					6: title = Localize.noun_rank_7
					7: title = Localize.noun_rank_8
					8: title = Localize.noun_rank_9
					9: title = Localize.noun_rank_10
					10: title = Localize.noun_rank_11 
					11: title = Localize.noun_rank_12
					12: title = Localize.noun_rank_13
					13: title = Localize.noun_rank_14
					14: title = Localize.noun_rank_15
					15: title = Localize.noun_rank_16
					16: title = Localize.noun_rank_17
					17: title = Localize.noun_rank_18
					18: title = Localize.noun_rank_19
			completion = value*5
			
			if data3.newgame != 0: #if player is in NG+
				ngplus = "- NG+"+str(data3.newgame)
			
			%Save3.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
			 "+"Ω ".repeat(int(data3.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
			 "+str(Localize.menu_player_location)+" "+str(data3.activescn).capitalize()+"
			 • × "+str(int(data3.playersouls))+" "+str(ngplus)
		else: %Save3.text = str(Localize.menu_no_data)

func _return_to_title() -> void:
	Sound.menu("cancel")
	%TitleMenu.visible = true
	%SaveSelect.visible = false
	%NewGame.grab_focus()

func _save_1_selected() -> void:
	Sound.menu("accept")
	GameState.saveslot = 1
	##If save data exists, load game, otherwise, start a new game
	if %Save1.text != str(Localize.menu_no_data):
		load_game()
	else: start_new_game()

func _save_2_selected() -> void:
	Sound.menu("accept")
	GameState.saveslot = 2
	if %Save2.text != str(Localize.menu_no_data): 
		load_game()
	else: start_new_game()

func _save_3_selected() -> void:
	Sound.menu("accept")
	GameState.saveslot = 3
	if %Save3.text != str(Localize.menu_no_data): 
		load_game()
	else: start_new_game()

##Used by the save select saveslot buttons
func load_game():
	Sound.menu("accept")
	GameState._load()
	LevelTransition.fadeToBlack() 
	print("You're on your way to..."+str(GameState.playerActiveScene))
	get_tree().call_deferred("change_scene_to_file","res://"+GameState.playerActiveScene+".tscn")

func _on_options_pressed() -> void:
	Sound.menu("accept")
	%MainMenu.visible = false
	%OptionsMenu.visible = true
	%LanguageOptionButton.grab_focus()
	
func _on_option_language_selected(index: int) -> void:
	match index:
		0: #English
			Sound.menu("move")
			Localize.language_set("English")
			language_setting = "English"
		1: #Pirate
			Sound.menu("move")
			Localize.language_set("Pirate")
			language_setting = "Pirate"

func _on_options_close_pressed() -> void:
	Sound.menu("cancel")
	%OptionsMenu.visible = false
	%MainMenu.visible = true
	%NewGame.grab_focus()

func _on_simple_mode_toggled(toggled_on: bool) -> void:
	match toggled_on:
		false:
			Sound.menu("cancel")
			GameState.EasyMode = false
			print("Easy mode not enabled")
		true:
			Sound.menu("accept")
			GameState.EasyMode = true
			print("Easy mode enabled")

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: #Fullscreen
			display_setting = "Fullscreen"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
		1: #Windowed
			display_setting = "Windowed"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
		2: #Borderless Windowed
			display_setting = "Borderless Windowed"
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
	Sound.MoteCollect() #to-do affect screen size
	engine_save()

func _on_music_slider_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicNoReverb"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDistort"), linear_to_db(_value))
	engine_save()

func _on_sfx_slider_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX Reverb"), linear_to_db(_value))
	engine_save()

func _on_quit_pressed() -> void:
	%MenuControl.grab_focus() #prevent additional inputs by player
	LevelTransition.fadeToBlack()
	Sound.menu("cancel")
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _on_endless_pressed() -> void:
	if GameState.completion == false:
		if !has_played_endless:
			%MenuControl.grab_focus() #prevent additional inputs by player
			Localize.reference_dialogue("EndlessWarning")
		else: endless_mode()
	else: endless_mode()

func endless_mode():
	has_played_endless = true
	Sound.menu("select")
	LevelTransition.fadeToBlack()
	GameState.player_hp_previous = 3
	engine_save()
	await get_tree().create_timer(1).timeout
	get_tree().call_deferred("change_scene_to_file","res://endless.tscn")

##New functions for saving and loading engine-related data
func engine_save():
	var saveData = EngineData.new()
	saveData.language = language_setting
	saveData.display_mode = display_setting
	saveData.music_volume = music_setting
	saveData.sound_volume = sound_setting
	saveData.easy_mode = GameState.EasyMode
	saveData.endless_enabled = has_played_endless
	Dialogue.save_indicate()
	ResourceSaver.save(saveData, "res://scripts/engine.res")
	print("Saved new engine configuration")

func engine_load():
	var data = ResourceLoader.load("res://scripts/engine.res") as EngineData #load saved data	
	##Apply saved language setting
	language_setting = data.language
	Localize.language_set(data.language)
	###Apply saved audio settings
	music_setting = data.music_volume
	sound_setting = data.sound_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_setting))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicNoReverb"), linear_to_db(music_setting))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDistort"), linear_to_db(music_setting))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sound_setting))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX Reverb"), linear_to_db(sound_setting))
	
	##Apply saved display settings
	display_setting = data.display_mode
	match display_setting:
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
		"Borderless Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
	GameState.EasyMode = data.easy_mode
	has_played_endless = data.endless_enabled
	print("Engine data loaded successfully")


#func _on_save_1_delete_pressed() -> void:
	#Sound.MoteCollect()
	#delete_save = 1
	#delete_save_consent_show()
#
#
#func _on_save_2_delete_pressed() -> void:
	#Sound.MoteCollect()
	#delete_save = 2
	#delete_save_consent_show()
#
#
#func _on_save_3_delete_pressed() -> void:
	#Sound.MoteCollect()
	#delete_save = 3
	#delete_save_consent_show()
#
#func delete_save_consent_show():
	#%DeleteSaveConsent.visible = true
#
#func _on_delete_save_consent_yes_pressed() -> void:
	#GameState.reset_save(delete_save)
	#Sound.deathGeneric()
	#delete_save = -1
	#%DeleteSaveConsent.visible = false
#
#
#func _on_delete_save_consent_no_pressed() -> void:
	#Sound.MoteCollect()
	#%DeleteSaveConsent.visible = false
	#delete_save = -1
