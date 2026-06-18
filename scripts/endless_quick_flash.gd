extends Node2D

func _ready() -> void:
	if GameState.abyssDict["abyssGlaze"] > 0:
		queue_free()
	GameState.target_player.has_flash.connect(cleanup)

func _process(_delta: float) -> void:
	if GameState.shadeActive:
		self.visible = false
		%CollisionShape2D.set_deferred("disabled", true)
	else:
		self.visible = true
		%CollisionShape2D.set_deferred("disabled", false)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	GameState.target_player.force_flash()
	cleanup()

func cleanup():
	queue_free()
