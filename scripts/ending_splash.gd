extends Node2D
@export_enum("Good", "Bad", "Secret") var ending_spoof: String
@export var pre_credits_pause : float = 5
@export var post_credits_pause : float = 5

func _ready() -> void:
	BgmController.stopAll()
	LevelTransition.fadeFromBlack()
	GameState.completion = true
	match ending_spoof:
		"Bad": GameState.townDict["townEndingChoice"][0] = 1
		"Good": GameState.townDict["townEndingChoice"][1] = 1
		"Secret": GameState.townDict["townEndingChoice"][2] = 1
	
	if GameState.townDict["townEndingChoice"][0] == 1:
		GameState.endless["theme"] = 1
		%EndingLabel.text = "Ending 1 - Antithesis (Bad Ending)"
		%EndingGood.visible = false
		%EndingSecret.visible = false
		%EndingBad.visible = true
		%BunsoftLogoGood.visible = false
		%BunsoftLogoEvil.visible = true
		GameState.townDict["townEndingChoice"][0] = 2 #set to completed state
		BgmController.ending_bad.play()
		
	if GameState.townDict["townEndingChoice"][1] == 1:
		GameState.endless["theme"] = 0
		%EndingLabel.text = "Ending 2 - Thesis (Good Ending)"
		GameState.townDict["townEndingChoice"][1] = 2 #set to completed state
		%EndingGood.visible = true
		%EndingSecret.visible = false
		%EndingBad.visible = false
		%BunsoftLogoGood.visible = true
		%BunsoftLogoEvil.visible = false
		BgmController.ending_good.play()

	if GameState.townDict["townEndingChoice"][2] == 1:
		GameState.endless["theme"] = 2
		%EndingLabel.text = "Ending 3 - Synthesis (Secret Ending)"
		GameState.townDict["townEndingChoice"][2] = 2 #set to completed state
		%EndingGood.visible = false
		%EndingSecret.visible = true
		%EndingBad.visible = false
		%BunsoftLogoGood.visible = true
		%BunsoftLogoEvil.visible = false
		BgmController.ending_good.play()

	await get_tree().create_timer(pre_credits_pause).timeout
	%CreditsAnim.current_animation = "creditroll"

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_select"):
		%CreditsAnim.speed_scale = 10
	else: %CreditsAnim.speed_scale = 0.1

func end_credits():
	await get_tree().create_timer(post_credits_pause).timeout
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://mainMenu.tscn")
