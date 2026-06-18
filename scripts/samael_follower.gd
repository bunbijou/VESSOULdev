extends Node2D
var projectile = preload("res://scenes/flame_wheel_samael.tscn")
var disabled : bool = false

func _ready() -> void:
	%Forsaken.cast_spikes.connect(disable)
	%Forsaken.cast_fire.connect(cast_wheel)

func cast_wheel():
	var my_instance = projectile.instantiate()
	if !disabled:
		add_child(my_instance)
		my_instance.position = %BossMovementHandler.position

func disable():
	disabled = true
