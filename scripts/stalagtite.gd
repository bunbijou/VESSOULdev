class_name BreakableStalagtite extends Node2D

@export_enum("index","middle","pinky","ring") var appearance: String
@export var anim : AnimatedSprite2D
@export var collision_area : CollisionShape2D
@export var effect_area : CollisionShape2D
@export var fade_time : int = 10
var active : bool = true

func _ready() -> void:
	anim.visible = true
	anim.animation = appearance

func destroyed():
	if active:
		active = false
		anim.animation = "break"
		Sound.stone_break()
		cleanup()

func cleanup():
	if !active:
		await get_tree().create_timer(fade_time).timeout
		queue_free()

func _on_boss_touch(_body: Node2D) -> void:
	pass
#	if active:
#		destroyed()
