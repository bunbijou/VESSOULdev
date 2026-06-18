extends Node

func _ready() -> void:
	if GameState.woodsDict["woodsMiniBoss"][1] != 0:
		queue_free()
		print("Cleaned up NG+ Jawer arena enemies")
