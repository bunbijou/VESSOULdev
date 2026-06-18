extends Node

func _ready() -> void:
	if GameState.abyssDict["abyssMiniBoss"] != 0 and GameState.newgame != 0:
		queue_free()
		print("Cleaned up NG+ black motes guarding amphora")
