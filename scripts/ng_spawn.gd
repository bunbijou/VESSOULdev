extends Node

##Super simple; if the player isn't on New Game Plus, we just delete this enemy
func _ready() -> void:
	if GameState.newgame < 1: ##was 2
		queue_free()
		Sound.LoopingSoundCleanup()
