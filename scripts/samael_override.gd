extends Node
##Used in EnemyZoo (yz.tscn) and SanctuaryAlt (sanctuaryalt.tscn)
## DEBUG ONLY
@export var debug : bool = false
@export var intensity_override : int = 5
@export var efficiency_override : int = 1
@export var capacity_override : int = 2
@export var impostor_route : bool = true

func _ready() -> void:
	if impostor_route:
		GameState.newgame = 1
		GameState.townDict["townEndingChoice"][1] = 1
		GameState.impostor = 1
	if debug:
		GameState.playerLifetimeSouls = 999
		GameState.playerActiveSouls = 999
		GameState.playerCapacity = capacity_override
		GameState.playerIntensity = intensity_override
		GameState.playerEfficiency = efficiency_override
		GameState.abyssDict["abyssGlaze"] = 1
