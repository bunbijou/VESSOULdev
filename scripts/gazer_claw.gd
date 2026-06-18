class_name GazerClaw extends Node2D

@export var gazer_base : EnemyGazer
@export var my_sprite_arm : AnimatedSprite2D
@export var my_sprite_hand : AnimatedSprite2D
var stunned : bool = false
var hitstun : float = 0.35

func _ready() -> void:
	gazer_base.stunned.connect(anim_stun)
	gazer_base.death_rattle.connect(cleanup)

func anim_stun():
	my_sprite_arm.play("stun")
	my_sprite_hand.play("stun")
	await get_tree().create_timer(0.35).timeout
	my_sprite_arm.play("default")
	my_sprite_hand.play("default")

func cleanup():
	queue_free()
