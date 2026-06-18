extends Node

func _ready() -> void:
	BgmController.stopAll()
	##if combat hasn't started yet
	if !GameState.npcDict["sculptor"] == 100:
		##play the initial Sanctuary dialogue
		GameState.npcDict["sculptor"] = 15
		print ("sanctuary_dialogue_skip.gd - Skipped to relevant dialogue")
	else: print ("sanctuary_dialogue_skip.gd - Skip deferred")
