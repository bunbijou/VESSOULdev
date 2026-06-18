class_name JawerPrison extends Node2D

signal battleStart

func _ready() -> void:
	if GameState.woodsDict["woodsMiniBoss"][1] != 0: #if gaping mawer defeated
		queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	GameState.isPaused = true
	Sound.fallOut()
	%aBottleSprite.animation = "damage"
	await get_tree().create_timer(.5).timeout
	Sound.glass_break()
	LevelTransition.fadeToBlack()
	%DarknessExplosion.emitting = true
	await get_tree().create_timer(1.5).timeout
	Sound.jawer("warcry")
	await get_tree().create_timer(2.5).timeout
	LevelTransition.fadeFromBlack()
	battleStart.emit()
	GameState.isPaused = false
	queue_free()
