extends Node2D
@export var target : Node2D

## to-do Make this into an enum to be able to spawn multiple types of enemies
var enemy_pothead = preload("res://scenes/enemy_pothead_lenore.tscn")
var enemy_burnout = preload("res://scenes/enemy_burnout_lenore.tscn")

func _ready() -> void:
	target.enemy_summon_pothead.connect(spawn_pothead)
	target.enemy_summon_burnout.connect(spawn_burnout)


func spawn_pothead():
	var spawned_enemy_pothead = enemy_pothead.instantiate()
	add_child(spawned_enemy_pothead)
	spawned_enemy_pothead.target_boss = target
	#spawned_enemy_pothead.current_zone = -2

func spawn_burnout():
	var spawned_enemy_burnout = enemy_burnout.instantiate()
	add_child(spawned_enemy_burnout)
	spawned_enemy_burnout.target_boss = target
	#spawned_enemy_burnout.current_zone = -2
