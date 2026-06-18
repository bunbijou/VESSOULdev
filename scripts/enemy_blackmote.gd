class_name EnemyBlackMote extends Node2D

signal death_rattle

@export var current_zone : int ##be careful messing with this or you'll have to set all the zone nums manually
@export var hit_area : HitboxComponent
@export var shield_area : HitboxComponent
@export var flash_component : FlashComponent
@export var speed : float = 0.1
@export var my_sprite : AnimatedSprite2D
@export var active : bool = false #true = enables following behavior
@export var shieldable : bool = false #may or may not be needed, currently not referenced
@export var vulnerable : bool = true # Water/Fire/Ice/Shade Motes
@export var mote_bonus_mult : float = 0.0
var projectile = preload("res://scenes/fireball.tscn")
var dead : bool = false
var casting : bool = false


func anim_idle():
	my_sprite.animation = "default"

func anim_cast():
	%castSprite.play("default")

func anim_stun():
	Sound.painGeneric()
	my_sprite.animation = "stun"
	await get_tree().create_timer(hit_area.hitstun).timeout
	if hit_area.hp > 0:
		anim_idle()

func anim_death():
	Sound.deathGeneric()
	my_sprite.visible = false
	%myDarkSprite.visible = false
	%DarknessParticles.emitting = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_blackmote,mote_bonus_mult,"small")

func _ready() -> void:
	flash_component.flash_detected.connect(death)

func _process(_delta: float) -> void:
	if GameState.shadeActive:
		%myDarkSprite.visible = true
	else: %myDarkSprite.visible = false
	
	if GameState.target_player.current_zone == current_zone and !casting and GameState.newgame != 0 and !dead:
		cast_fire()

func cast_fire():
	var fireball_instance = projectile.instantiate()
	casting = true
	await get_tree().create_timer(randi_range(5,10)).timeout
	anim_cast()
	await get_tree().create_timer(.25).timeout
	add_child(fireball_instance)
	fireball_instance.current_zone = current_zone
	casting = false

##Can only be damaged by flash, only has 1 HP
func death():
	if GameState.target_player.current_zone == current_zone and !dead:
		dead = true
		hit_area.on_touch_effect = "None"
		%CollisionShape2D.set_deferred("disabled",true)
		anim_stun()
		anim_death()
		await get_tree().create_timer(hit_area.initial_hitstun).timeout
		GameState.addKillCount()
		death_rattle.emit()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()

func cleanup():
	death_rattle.emit()
	queue_free()
