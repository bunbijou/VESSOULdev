extends Node

@export var demo_mode_enable : bool = false
@onready var npc_lenore : Node2D = %NPCLenore
@onready var boss_lenore : Node2D = %BossLenore

func _ready() -> void:
	if demo_mode_enable:
		GameState.target_player.demo = true
		npc_lenore.debug_battle = true
		boss_lenore.demo = true
