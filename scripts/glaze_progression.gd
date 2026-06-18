extends Node

func _ready() -> void:
	if GameState.abyssDict["abyssGlaze"] == 0:
		queue_free()
		print("Removed components that require Glaze")
