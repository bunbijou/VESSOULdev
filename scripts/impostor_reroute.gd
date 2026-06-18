extends Node

func _ready() -> void:
	if GameState.impostor:
		print("Re-routing player to Impostor battle scene")
