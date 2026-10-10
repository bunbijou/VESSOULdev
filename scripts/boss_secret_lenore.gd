class_name BossSecretLenore extends Node2D

signal death_rattle
signal cast_spikes
signal enemy_summon_pothead
signal enemy_summon_burnout
signal dispel_summoned_enemies

@export var current_zone : int = 999
@export var target_npc : Node2D
@export var health : int = 3
@export var anim : AnimationPlayer
@export var hand_hitbox : HitboxComponent
@export var demo : bool = false
var current : int = 0
var speed : float = 0.05 #gaping jawer speed = 0.05
var attacking : bool = false
var stun : bool = false
var wait : bool = true
var vulnerable : bool = false
var hitstun : float = .35
var beat : float = 1
var active_phase = 0 #for registering state changes
var cycle : int = 0
var repeat : int = 0
var enemy_type : String = "Pothead"
var dead : bool = false

##----ANIMATIONS------##
func anim_idle():
	self.visible = true
	anim.play("hiding_idle",1,1,false)
	%Head.animation = "default"
	%HandL.animation = "default"
	%HandR.animation = "default"

func anim_stun():
	%Telegraph.visible = false
	Sound.lenore("pain")
	%Head.animation = "stun"
	%HandL.animation = "stun"
	%HandR.animation = "stun"
	await get_tree().create_timer(hitstun).timeout
	anim_idle()

func anim_slap_r():
	Sound.lenore("slap")
	anim.current_animation = "hiding_slap"
	%HandR.animation = "slap"
	

func anim_scratch_r():
	Sound.lenore("claw")
	%HandR.animation = "claw"
	anim.current_animation = "hiding_scratch_r"
	await get_tree().create_timer(hitstun*2).timeout
	Sound.lenore("claw")

func anim_dig_r():
	Sound.lenore("dig")
	anim.current_animation = "hiding_dig_r"
	Sound.rock_break()
	await get_tree().create_timer(beat/2).timeout
	Sound.rock_break()
	await get_tree().create_timer(beat).timeout
	Sound.rock_break()

func anim_place_enemy_r():
	Sound.lenore("place")
	anim.current_animation = "hiding_place_r"

func anim_toss_enemy_r():
	Sound.lenore("place")
	anim.current_animation = "hiding_toss_r"
	Sound.ossuary("chase_start")

func anim_ossuary_burst():
	%BurstParticle.emitting = true
	Sound.VesselBreak()
	Sound.explosion()
	Sound.ossuary("explode")
	Sound.ossuary("chase_stop")

func anim_overhead_strike_lr():
	%Telegraph.visible = true
	Sound.lenore("slam")
	anim.current_animation = "overhead_strike"
	await get_tree().create_timer(beat*2).timeout
	Sound.impact_big()
	GameState.anim_rumble(.5,20)
	await get_tree().create_timer(beat).timeout
	%Telegraph.visible = false


func _ready():
	self.visible = false
	GameState.target_player.flashed.connect(_pain)
	target_npc.battle_start.connect(_intro)

func _intro():
	%LenoreDarkSmoke.emitting = true
	anim_idle()
	GameState.target_player.anim_darken()
	vulnerable = false
	Sound.lenore("warcry")
	await get_tree().create_timer(beat).timeout
	wait = false
	current = 1

func _process(_delta: float) -> void:
	if wait == false and !get_tree().paused:
		if health < 1: 
			defeat()
		else:
			if !attacking and !stun: #if not currently in an active state
				match current:
					1: 
						attacking = true
						slap()
					2:
						attacking = true
						scratch()
					3:
						attacking = true
						dig()
					4:
						attacking = true
						place_enemy()
					5:
						attacking = true
						toss_enemy()
					6: 
						attacking = true
						toss_enemy()
					7:
						attacking = true
						toss_enemy()
					8:
						attacking = true
						overhead_strike()


func slap():
	anim_slap_r()
	await get_tree().create_timer(beat*5).timeout
	attacking = false
	current = 2

func scratch():
	anim_scratch_r()
	await get_tree().create_timer(beat*4).timeout
	attacking = false
	current = 3

func dig():
		anim_dig_r()
		await get_tree().create_timer(beat*5).timeout
		attacking = false
		current = 4

func place_enemy():
	anim_place_enemy_r()
	await get_tree().create_timer(beat*1.5).timeout
	##First time, we want her to bring out a Pothead, second time, we want her to bring out a Burnout
	##(Alternate?)
	if enemy_type == "Pothead":
		enemy_summon_pothead.emit()
		enemy_type = "Burnout"
	else: 
		if !demo:
			enemy_summon_burnout.emit()
		else: enemy_summon_pothead.emit()
	attacking = false
	## Every time we do this attack, we want to do it an additional time next loop
	## This value indicates how many times to cycle the attack
	#if repeat == cycle:
	current = 5
		#cycle += 1
	#else: 
		#current = 3
		#repeat += 1

func toss_enemy():
	anim_toss_enemy_r()
	await get_tree().create_timer(beat*5).timeout
	attacking = false
	current += 1

func bone_bomb():
	%BoneColl1.set_deferred("disabled", false)
	%BoneColl2.set_deferred("disabled", false)
	%BoneColl3.set_deferred("disabled", false)
	%BoneColl4.set_deferred("disabled", false)
	%BoneColl5.set_deferred("disabled", false)
	%BoneColl6.set_deferred("disabled", false)
	%BoneColl7.set_deferred("disabled", false)
	%BoneColl8.set_deferred("disabled", false)
	await get_tree().create_timer(beat*2).timeout
	%BoneColl1.set_deferred("disabled", true)
	%BoneColl2.set_deferred("disabled", true)
	%BoneColl3.set_deferred("disabled", true)
	%BoneColl4.set_deferred("disabled", true)
	%BoneColl5.set_deferred("disabled", true)
	%BoneColl6.set_deferred("disabled", true)
	%BoneColl7.set_deferred("disabled", true)
	%BoneColl8.set_deferred("disabled", true)

func overhead_strike():
	anim_overhead_strike_lr()
	vulnerable = true
	await get_tree().create_timer(beat*5).timeout
	vulnerable = false
	attacking = false
	current = 1 #loop

func falling_stalagmites():
	cast_spikes.emit()

func block_flash():
	vulnerable = false

func _pain():
	if vulnerable and !stun:
		dispel_summoned_enemies.emit()
		anim_stun()
		health -= 1
		vulnerable = false #prevent further attacks for this cycle
		stun = true
		await get_tree().create_timer(hitstun).timeout
		stun = false

func defeat():
	if !dead:
		dead = true
		##Achievement: Betray Lenore
		dispel_summoned_enemies.emit()
		GameState.target_player.anim_achievement("a_lenore_defeat")
		GameState.target_player.waiting = true
		BgmController.stopAll()
		Sound.lenore("death")
		LevelTransition.fadeToWhite()
		await get_tree().create_timer(beat*3).timeout
		if !demo:
			GameState.target_player.waiting = false
			GameState.target_player.anim_lighten()
			LevelTransition.fadeFromBlack()
			death_rattle.emit()
			BgmController.abyss_main.play()
			queue_free()
		else: 
			get_tree().call_deferred("change_scene_to_file","res://demo_end.tscn")

func cleanup():
	death_rattle.emit()
	queue_free()
