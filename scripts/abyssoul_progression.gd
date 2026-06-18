extends Node
## A script used only when the player enters the Chasm
func _ready() -> void:
	BgmController.abyss_chasm_ambience.play()
	BgmController.abyss_chasm_music.play()

func _process(_delta: float) -> void:
	if GameState.abyssDict["abyssBoss"][0] != 0: 
		print("Cleaned up NG+ Abyssoul enemies")
		queue_free()
