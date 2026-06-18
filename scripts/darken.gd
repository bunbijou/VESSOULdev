extends Node
## A widely-used script that enables a darkness effect on the player whilst in dark scenes
@export_enum("No Condition","Abyssoul Defeated") var condition : String = "No Condition"

func _ready() -> void:
	match condition:
		"No Condition": GameState.target_player.anim_darken()
		"Abyssoul Defeated":
			if GameState.abyssDict["abyssBoss"][0] == 1: pass
			else: GameState.target_player.anim_darken()
