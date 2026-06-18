extends Node
##Used in EnemyZoo (yz.tscn) and SanctuaryAlt (sanctuaryalt.tscn)
## DEBUG ONLY
@export var debug : bool = false
@export var impostor_route : bool = true

func _ready() -> void:
	if impostor_route:
		GameState.newgame = 1
		GameState.townDict["townEndingChoice"][1] = 1
		GameState.impostor = 1
	if debug:
		GameState.playerCapacity = 2
		GameState.playerIntensity = 5
		GameState.playerEfficiency = 1
		GameState.abyssDict["abyssGlaze"] = 1
		GameState.playerActiveSouls = 999
