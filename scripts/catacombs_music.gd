extends Node

func _ready() -> void:
	BgmController.stopAll()
	BgmController.catacombs.play()
