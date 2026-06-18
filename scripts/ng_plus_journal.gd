extends Node2D

func _ready() -> void:
	if GameState.townDict["townEndingChoice"][1] == 2 or GameState.townDict["townEndingChoice"][2] == 2:
		Localize.reference_dialogue("JournalTip")
	else: queue_free()
