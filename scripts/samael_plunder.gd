extends Node2D
##Quick script for after player chooses to give their soul up to Samael,
##Gives them the bad ending and boots them to the end credits

func _ready() -> void:
	BgmController.stopAll()
	Sound.samael("ominous_laugh")
	LevelTransition.fadeFromBlack()
	%AnimationPlayer.current_animation = "plunder"

func change_scene():
	LevelTransition.fadeToBlack()
	GameState.townDict["townEndingChoice"][0] = 1
	get_tree().change_scene_to_file("res://ending.tscn")
