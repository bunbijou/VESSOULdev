## Remove NPC - For Sculptor 
extends Node2D
@onready var target_enemy : BossForsaken = %Forsaken

 
func _ready() -> void:
	self.visible = true
	GameState.battle_begin.connect(dispel)

func _process(_delta: float) -> void:
	if target_enemy.combat_phase != "pre_battle":
		queue_free()

func dispel():
	await get_tree().create_timer(1).timeout 
	queue_free()
