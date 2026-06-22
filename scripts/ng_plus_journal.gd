extends Node2D

func _ready() -> void:
	if GameState.townDict["townEndingChoice"][1] == 2 or GameState.townDict["townEndingChoice"][2] == 2:
		##Achievement: Get Samael's  Journal
		SteamHandler.achievement_get("a_ngplus_journal_get")
		Localize.reference_dialogue("JournalTip")
	else: queue_free()
