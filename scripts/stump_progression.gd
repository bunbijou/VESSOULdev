extends Node

func _ready() -> void:
	if GameState.woodsDict["woodsMiniBoss"][0] == 0:
		queue_free()
		print("Cleaned up blazing stump NG+ enemies")
