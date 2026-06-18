class_name MinibossAmphora extends Node2D

signal death_rattle
signal amphoraPerished
signal counterattack
signal cleanup

@export var current_zone : int = 999 #my home zone
@export var my_sprite : AnimatedSprite2D
@export var hit_area : Area2D
@export var collision_area : StaticBody2D
@export var hitstun : float = .30
@export var health : int = 3
@export var fade_time : float = 5
var count : int = 0
var stunned : bool = false
var busy : bool = false 
var initial_health : int
var dead : bool = false 
var counterattack_armed : bool = true

##anims
func anim_idle():
	my_sprite.animation = "default"
func anim_attack_1():
	Sound.Amphora1()
	Sound.whoosh()
	my_sprite.play("attack1",1,false)
func anim_attack_2():
	Sound.Amphora2()
	Sound.whoosh()
	my_sprite.play("attack2",1,false)
func anim_stun():
	Sound.VesselBreak()
	Sound.AmphoraStun()
	my_sprite.play("stun",1,false)
	await get_tree().create_timer(hitstun).timeout
	if !dead:
		anim_idle()
func anim_death():
	GameState.target_player.waiting = true
	%OrbitParticles.emitting = false
	GameState.target_player.current_zone = -999
	GameState.target_player.temp_position = self.position
	my_sprite.play("stun",1,false)
	BgmController.stopAll()
	await get_tree().create_timer(fade_time/2).timeout
	%DarknessExplosion.emitting = true
	%MoteExplosion.emitting = true
	%LiquidExplosion.emitting = true
	Sound.AmphoraDeath()
	Sound.VesselBreak()
	Sound.splash()
	await get_tree().create_timer(fade_time/2).timeout
	GameState.target_player.waiting = false
	#GameState.isPaused = false
	my_sprite.play("remnant")
	%DarknessExplosion.emitting = false
	%MoteExplosion.emitting = false
	%LiquidExplosion.emitting = false
	GameState.target_player.anim_enemy_slain()
	GameState.mote_reward(GameState.reward_amphora,0,"big")
	#Re-focus camera on player
	GameState.target_player.current_zone = 3

##functions

func _ready() -> void:
	#health_label.visible = false
	if GameState.EasyMode:
		health = 3
	else:	
		health += GameState.newgame #NG+
	initial_health = health
	if GameState.abyssDict["abyssMiniBoss"] == 1: #if amphora defeated
		queue_free()
		death_rattle.emit()
		amphoraPerished.emit()

#func _process(_delta: float) -> void:
		#if health == initial_health:
			#health_label.text = ""
		#else: 
			#health_label.visible = true
			#health_label.text = str(health)+"/"+str(initial_health)
		#if health == 0:
			#health_label.text = "K.O."

func _physics_process(_delta: float) -> void:
		if GameState.target_player.current_zone == current_zone and !dead:
			count += 1
			match count:
				85: 
					if !busy:
						anim_attack_1()
						busy = true
				150:
					anim_idle()
					busy = false
				325:
					if !busy:
						anim_attack_2()
						busy = true
				350:
					anim_idle()
					busy = false #trying to get the animations to play smoothly

			if health < 1: #if my health is below zero, kill me
					death()

func _on_area_2d_body_entered(_body: PlayerVessel) -> void:
	if GameState.target_player.empowered: 
		hurt()
	else: 
		GameState.target_player.isHurt(1+GameState.newgame)

func hurt():
	if !stunned and !dead:
		if counterattack_armed:
			counterattack.emit()
			counterattack_armed = false
		stunned = true
		health -= 1
		anim_stun()
		await get_tree().create_timer(hitstun).timeout #wait so anim and sound can play
		stunned = false

func death():
	if !dead:
		%AmphoraCollisionShape.set_deferred("disabled",true)
		cleanup.emit()
		dead = true
		hit_area.set_deferred("monitoring",true)
		anim_death()
		GameState.addKillCount()
		death_rattle.emit()
		amphoraPerished.emit()
		GameState.abyssDict["abyssMiniBoss"] = 1 
		await get_tree().create_timer(GameState.cleanup_time_boss).timeout
		queue_free() #banish self to shadow realm
