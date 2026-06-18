extends Node

@export var target_object : Node2D

func _ready() -> void:
	if GameState.favor == 1:
		target_object.cleanup()
		print("Cleaned up Lenore objects to prevent softlock")
		queue_free()
