extends Node

func _process(_delta: float) -> void:
	if GameState.townDict["townMiniBoss"] == 1: #if already defeated
		queue_free()
