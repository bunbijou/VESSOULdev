extends StaticBody2D

##Allows the player to proceed into the sanctuary area once they have finished samael's dialogue
func _process(_delta: float) -> void:
	if GameState.npcDict["sculptor"] == 101:
		queue_free()
		print("sanctuary_barrier_temp.gd - Battle begun; barrier removed")
