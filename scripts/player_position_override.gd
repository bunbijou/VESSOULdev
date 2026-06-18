extends Node2D

func _process(_delta: float) -> void:
	%Player.position = self.position
	queue_free()
