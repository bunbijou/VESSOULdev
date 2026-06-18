extends Node
@export var target_enemy : EnemyBlackMote

## If Jari's dialogue has already been started, get rid of the Black Mote
func _ready() -> void:
	if GameState.npcDict["jari"] != 0:
		target_enemy.cleanup()
