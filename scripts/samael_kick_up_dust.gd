extends Node2D
var projectile = preload("res://particle_dust_big.tscn")

func _ready() -> void:
	%Forsaken.impact_big.connect(instance_dust)

func instance_dust():
	var my_instance = projectile.instantiate()
	add_child(my_instance)
	my_instance.position = %BossMovementHandler.position
