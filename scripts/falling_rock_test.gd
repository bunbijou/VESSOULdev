extends Node2D
signal cast_spikes

func _process(_delta: float) -> void:
	if !GameState.target_player.dead:
		await get_tree().create_timer(1).timeout
		cast_spikes.emit()
		await get_tree().create_timer(1).timeout
