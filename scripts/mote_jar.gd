#Breakable Soul Jar
extends Area2D
@onready var animation_player = $AnimationPlayer
@onready var myBlocker = %StaticBody2D
@export var pumpkin = false
var fade_time : int = 999

func broken():
	#The idea of this is to keep the hitbox from being repeatedly triggered after destruction
	self.set_deferred("monitoring",true)
	animation_player.play("empty")
	cleanup()

func _on_body_entered(_body: Node2D) -> void:
	if GameState.target_player.empowered:
		#GameState.anim_rumble(0.5)
		animation_player.play("pickup")
		await get_tree().create_timer(0.25).timeout
		if pumpkin:
			Sound.PumpkinSplat()
			%ParticlePumpkin.emitting = true
		else: 
			Sound.VesselBreak()
			%ParticleAbyss.emitting = true
		broken()

#func _on_area_2d_area_entered(_area: Area2D) -> void:
		#animation_player.play("pickup")
		#if pumpkin:
			#Sound.PumpkinSplat()
		#else: Sound.VesselBreak()
		#await get_tree().create_timer(0.35).timeout
		#broken()

func cleanup():
		await get_tree().create_timer(fade_time).timeout
		queue_free()
