extends Area2D
@export var parent_enemy : EnemySinkhole
var pulling : bool = false

#func _ready() -> void:
	#parent_enemy.death_rattle.connect(stop)
#
#func _on_body_entered(_body: PlayerVessel) -> void:
	#if !pulling:
		#pulling = true
#
#func _process(_delta: float) -> void:
	#if pulling:
		#GameState.target_player.position = GameState.target_player.position + ((self.position)+Vector2(0.01,0.01))
		##GameState.target_player.position = self.position+(GameState.target_player.position/1.01)
#
#func _on_body_exited(_body: PlayerVessel) -> void:
	#pulling = false
#
#func stop():
	#pulling = false
	#queue_free()
