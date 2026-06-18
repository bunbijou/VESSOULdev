class_name BreakableEnvironmentObject extends Node2D

@export var anim : AnimatedSprite2D
@export var collision_area : CollisionShape2D
@export var effect_area : CollisionShape2D
@export var fade_time : int = 10
@export var break_particle : CPUParticles2D
@export var break_particle_aux : CPUParticles2D
@export_enum("wood","stone","ceramic") var break_sound: String = "ceramic"
var active : bool = true


func _boss_touch(_area: Area2D) -> void:
	if active:
		destroyed()

func destroyed():
	if active:
		match break_sound:
			"wood":
				Sound.wood_break()
			"stone":
				Sound.rock_break()
			"ceramic":
				Sound.VesselBreak()
		if break_particle:
			break_particle.emitting = true
		if break_particle_aux:
			break_particle_aux.emitting = true
		collision_area.set_deferred("disabled", true)
		active = false
		anim.play("break",1,false)
		cleanup()

func cleanup():
	if !active:
		await get_tree().create_timer(fade_time).timeout
		queue_free()
