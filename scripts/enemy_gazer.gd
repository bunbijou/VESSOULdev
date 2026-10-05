class_name EnemyGazer extends Node2D

signal death_rattle
signal stunned

@export_category("Gazer HP should be tied to amount of tendrils they have, modifiable")
@export var hit_area : HitboxComponent
@export var debug_hitbox : HitboxComponent
var spin_speed : float = 0.005
var dead : bool = false

func anim_stun():
	Sound.gazer("stun")
	%sprBase.animation = "stun"
	await get_tree().create_timer(hit_area.hitstun).timeout
	if !dead:
		anim_idle()

func anim_idle():
	%sprBase.animation = "default"

func anim_death():
	%sprBase.visible = false
	Sound.gazer("death")
	%DeathParticle.emitting = true

func _ready() -> void:
	hit_area.death_rattle.connect(death)

func stun():
	if !dead:
		stunned.emit()
		hit_area.hp -= 1
		anim_stun()

func death():
	if !dead:
		dead = true
		%CollisionShape2D.disabled = true
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(hit_area.initial_hitstun).timeout
		anim_death()
		GameState.addKillCount()
		death_rattle.emit()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()


func _on_debug_hitbox_body_entered(_body: PlayerVessel) -> void:
	if debug_hitbox:
		queue_free()
		death_rattle.emit()
		print("Removed Gazer to prevent softlock")
