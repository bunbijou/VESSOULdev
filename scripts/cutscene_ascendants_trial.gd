extends Node2D
@export_category("Skip to a message")
@export var message : int = 0
@export_category("Timing options")
@export var beat : float = 1
@export var drama_beat : float = 1.5
@export_category("Talk speed options")
@export var panic_speed : float = 3
@export var default_speed : float = 1
@export var has_humanity : bool = false

func _ready() -> void:
	BgmController.track_trial.play()
	##Move dialogue box into the up position
	Dialogue.anim.play("up")
	##Secret ending (debug)
	if has_humanity:
		GameState.favor = 1
	LevelTransition.fadeFromBlack()
	await get_tree().create_timer(drama_beat).timeout
	if message == 0:
		Localize.reference_dialogue("SamaelTrial")
		message += 1

func _process(_delta: float) -> void:
	if !get_tree().paused:
		match message:
			0: pass
			1: #Joviel
				Localize.reference_dialogue("JovielTrial")
				increment_message()
			2: #Samael
				Localize.reference_dialogue("SamaelTrial2")
				increment_message()
			3: #Joviel
				Localize.reference_dialogue("JovielTrial2")
				increment_message()
			4: 	#Joviel
				Localize.reference_dialogue("JovielTrial3")
				increment_message()
			5: #Samael
				Localize.reference_dialogue("SamaelTrial3")
				increment_message()
			6: #Samael
				%Samael.play("idle")
				Localize.reference_dialogue("SamaelTrial4")
				increment_message()
			7: #Samael
				Localize.reference_dialogue("SamaelTrial5")
				increment_message()
			8: 	#Joviel
				Localize.reference_dialogue("JovielTrial4")
				await get_tree().create_timer(drama_beat).timeout
				%Samael.play("fear")
				increment_message()
			9: #Joviel
				Localize.reference_dialogue("JovielTrial5")
				%AscendantAnimPlayer.play("retreat")
				await get_tree().create_timer(drama_beat*2).timeout
				increment_message()
			10: #Samael
				%Samael.play("anger")
				%SamaelAnimPlayer.play("zoom")
				Localize.reference_dialogue("SamaelTrial6")
				increment_message()
			11: #Joviel
				%AscendantAnimPlayer.current_animation = "idle"
				%SamaelAnimPlayer.current_animation = "RESET"
				%Samael.animation = "fear"
				Localize.reference_dialogue("JovielTrial6")
				increment_message()
				%TrialLoop.stop()
			12: #Joviel
				Localize.reference_dialogue("JovielTrial7")
				increment_message()
			13: #Samael
				BgmController.ending_bad.play()
				%AscendantAnimPlayer.play("retreat")
				%VoidAnim.play("fadein")
				%Samael.animation = "fear"
				Localize.reference_dialogue("SamaelTrial7")
				increment_message()
			14: #Lailun
				BgmController.ending_bad.stop()
				BgmController.track_moon.play() #placeholder for lailuin theme
				%AscendantAnimPlayer.play("emerge")
				%Samael.play("fear")
				Localize.reference_dialogue("JovielTrial8")
				increment_message()
			15: #Lailun
				%AscendantAnimPlayer.play("idle")
				Localize.reference_dialogue("JovielTrial9")
				increment_message()
			16: #Joviel
				%VoidAnim.play("fadeout")
				Localize.reference_dialogue("JovielTrial10")
				increment_message()
				await get_tree().create_timer(drama_beat).timeout
			17: 
				## see samael_protest() (below)
				%SamaelAnimPlayer.speed_scale = 0.5
				%SamaelAnimPlayer.current_animation = "conversion"
				#wait for anim end 
			18:
				BgmController.stopAll() #stop lailun theme
				##If player has reclaimed their humanity
				if GameState.favor == 1:
					##Skip to special ending dialogue
					message = 99
				else: 
					%SamaelAnimPlayer.current_animation = "aftermath"
					Localize.reference_dialogue("JovielAftermath")
					increment_message()
			19:
				Localize.reference_dialogue("JovielAftermath2")
				increment_message()
			20:
				Localize.reference_dialogue("JovielAftermath3")
				increment_message()
			21:
				Localize.reference_dialogue("JovielAftermath4")
				increment_message()
			22: 
				Localize.reference_dialogue("JovielAftermath5")
				increment_message()
			23:
				LevelTransition.fadeToBlack()
				increment_message()
			24: ##Good Ending Tree
				GameState.townDict["townEndingChoice"][1] = 1
				await get_tree().create_timer(drama_beat*3).timeout
				get_tree().change_scene_to_file("res://ending.tscn")
			99: ##Special Ending Tree
				Localize.reference_dialogue("JovielSecretEnding")
				increment_message()
			100:
				LevelTransition.fadeToWhite()
				##Enable special ending
				GameState.townDict["townEndingChoice"][2] = 1
				increment_message()
			101:
				await get_tree().create_timer(drama_beat*3).timeout
				print("Changing scene")
				get_tree().change_scene_to_file("res://ending.tscn")

func samael_protest():
	Sound.samael("refusal")
	Localize.reference_dialogue("SamaelConversion")

func increment_message():
	message += 1

func mote_collected():
	Sound.PlayerHeal()
	Sound.MoteCollect()
