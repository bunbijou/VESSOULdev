extends Node2D
@export_enum("1", "2", "3", "4") var id: String
var projectile = preload("res://scenes/flame_wheel.tscn")
var disabled : bool = false

func _ready() -> void:
	%MinibossCenser.fatal_damage.connect(disable)
	match id:
		"1": %MinibossCenser.cast_1.connect(cast_wheel)
		"2": %MinibossCenser.cast_2.connect(cast_wheel)
		"3": %MinibossCenser.cast_3.connect(cast_wheel)
		"4": %MinibossCenser.cast_4.connect(cast_wheel)

func cast_wheel():
	var my_instance = projectile.instantiate()
	if !disabled:
		add_child(my_instance)

func disable():
	disabled = true
	%AnimatedSprite2D.play("defeat")
	%AnimatedSprite2D2.visible = false
