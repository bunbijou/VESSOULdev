extends Node
@export_category("Skip to a message")
@export var message : int = 0
@export_category("Timing options")
@export var beat : float = 1
@export var drama_beat : float = 1.5
@export_category("Talk speed options")
@export var panic_speed : float = 3
@export var default_speed : float = 1

func _ready() -> void:
	Dialogue.anim.current_animation = "RESET"
	BgmController.track_moon.play() #placeholder for Lailun theme
	##Move dialogue box into the up position
	#Dialogue.anim.play("up")
	LevelTransition.fadeFromBlack()
	await get_tree().create_timer(drama_beat).timeout
	GameState.target_player.anim_samael_emerge()
	if message == 0:
		increment_message(1)

func _process(_delta: float) -> void:
	if !get_tree().paused:
		match message:
			0: pass
			1: #Lailun
				Localize.reference_dialogue("LailunDarkSpace1")
				increment_message(1)
			2: #Lailun
				Localize.reference_dialogue("LailunDarkSpace2")
				increment_message(1)
			3: #Lailun
				Localize.reference_dialogue("LailunDarkSpace3")
				increment_message(1)
			4: #Samael
				Localize.reference_dialogue("SamaelDarkSpace1")
				increment_message(1)
			5: #Lailun
				Localize.reference_dialogue("LailunDarkSpace4")
				increment_message(1)
			6: #Lailun
				Localize.reference_dialogue("LailunDarkSpace5")
				increment_message(1)
			7: #Lailun Question
				Localize.reference_dialogue("LailunQuestion")
				increment_message(1)
			8: #Conditional Tree
				#if bad ending selected
				if GameState.townDict["townEndingChoice"][0] == 1:
					increment_message(1)
				else:
					increment_message(10)
			9: #Vessel is destroyed
				BgmController.stopAll()
				Localize.reference_dialogue("LailunPlayerAccept")
				increment_message(1)
			10: #Samael Released
				%RockAnimPlayer.play("attack")
			11: 
				Localize.reference_dialogue("SamaelPlayerAccept1")
				increment_message(1)
			12:
				Localize.reference_dialogue("SamaelPlayerAccept2")
				Sound.samael("ominous_laugh")
				Sound.fire_crackle_loop("play")
				%SamaelAnimPlayer.play("glare")
				increment_message(1)
			13:
				##Achievement: Released Samael
				GameState.target_player.anim_achievement("a_ngplus_reset_accept")
				end_cutscene()
			18: #Samael not released
				GameState.target_player.anim_achievement("a_ngplus_reset_deny")
				Localize.reference_dialogue("LailunPlayerDecline")
				increment_message(-5) #see above

func increment_message(value : int):
	message += value
	print("Current message: "+str(message))

func end_cutscene():
	BgmController.stopAll()
	increment_message(1)
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(drama_beat*3).timeout
	print("Changing scene")
	get_tree().change_scene_to_file("res://ending.tscn")

func destroy_player():
	GameState.target_player.anim_samael_hide()
	GameState.playerHP = 0
	GameState.target_player.anim_death()
	GameState.target_player.anim_flash_fill()
	%SamaelAnimPlayer.play("emerge")
