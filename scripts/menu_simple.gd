##All this stuff is copied from mainmenu.gd
extends Node2D
@export_enum("res://abyss.tscn","res://chasm.tscn","res://woods.tscn","res://depths.tscn","res://town.tscn","res://catacombs.tscn","res://clerestory.tscn","res://sanctuary.tscn","res://yz.tscn") var sceneNewGame: String
@export var language : String = "English" ##Default

func _ready() -> void:
		get_tree().paused = false
		%LanguageOptionButton.grab_focus()
		Sound.LoopingSoundCleanup()
		Localize.language_set(language)
		LevelTransition.fadeFromBlack()
		%LabelLanguage.text = str(Localize.menu_language)
		%LabelDisplay.text = str(Localize.menu_display)
		%LabelMusic.text = str(Localize.menu_music)
		%LabelSFX.text = str(Localize.menu_sfx)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(%MusicSlider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicNoReverb"), linear_to_db(%MusicSlider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDistort"), linear_to_db(%MusicSlider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(%SFXSlider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX Reverb"), linear_to_db(%SFXSlider.value))
		BgmController.abyss_chasm_ambience.play()

func _on_option_language_selected(index: int) -> void:
	match index:
		0: #English
			Sound.menu("move")
			Localize.language_set("English")
			language = "English"
		1: #Pirate
			Sound.menu("move")
			Localize.language_set("Pirate")
			language = "Pirate"

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
			Sound.MoteCollect() #to-do affect screen size
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
			Sound.MoteCollect() #to-do ditto
		2: #Borderless Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
			Sound.MoteCollect() #to-do ditto

func _on_music_slider_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicNoReverb"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDistort"), linear_to_db(_value))


func _on_sfx_slider_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX Reverb"), linear_to_db(_value))
	Sound.MoteCollect()


func _on_demo_start_pressed() -> void:
	%SimpleMenu.visible = false
	Sound.menu("accept")
	BgmController.stopAll()
	await get_tree().create_timer(1.5).timeout
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(1.5).timeout
	print("You're on your way to..."+str(GameState.playerActiveScene))
	get_tree().call_deferred("change_scene_to_file","res://abyss_demo.tscn")
