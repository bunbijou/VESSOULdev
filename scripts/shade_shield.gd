extends Node2D

func _process(_delta: float) -> void:
	if !GameState.shadeActive: 
		%ShieldArea.visible = false
		%ShieldArea.monitoring = false
	else:
		%ShieldArea.visible = true
		%ShieldArea.monitoring = true
