class_name WispBase extends Node2D

signal death_rattle
signal enable_wisps

@export var my_sprite : AnimatedSprite2D
@export var flash_component : FlashComponent
@export var hit_area : HitboxComponent
@export var current_zone : int = 999 #my home zone
var wisp = preload("res://scenes/protective_flame.tscn")
#var wisp_quantity : int = 1
var dead : bool = false
var stunned : bool = false
var hitstun : float

##-----ANIMATIONS----##
func anim_idle():
	my_sprite.play("default",1,false)

func anim_stun():
	Sound.vesselflower("pain")
	my_sprite.play("stun",1,false)
	await get_tree().create_timer(hit_area.hitstun).timeout
	if hit_area.hp != 0:
		anim_idle()
		wisp_enable()

func anim_death():
	%ShadeShield.visible = false
	Sound.vesselflower("death")
	my_sprite.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_wispflower,0,"small")

##-----FUNCTIONS------##
func _ready(): #on level start
	flash_component.flash_detected.connect(flash)
	hit_area.painState.connect(anim_stun)
	#hit_area.painState.connect(wisp_enable)
	hit_area.death_rattle.connect(death)
	hitstun = hit_area.hitstun
	my_sprite.animation = "default" #set my current animation to idle anim from my statblock
	wisp_create()

func wisp_create():
	var wisp_1 = wisp.instantiate()
	var wisp_2 = wisp.instantiate()
	var wisp_3 = wisp.instantiate()
	add_child(wisp_1)
	wisp_1.wisp_parent = self
	await get_tree().create_timer(.75).timeout
	add_child(wisp_2)
	wisp_2.wisp_parent = self
	wisp_2.toggle(false)
	await get_tree().create_timer(.7525).timeout
	add_child(wisp_3)
	wisp_3.wisp_parent = self
	wisp_3.toggle(false)

##Temporarily disabled 
#func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	#if !dead:
		#hit_area._on_player_touch(hit_area.hitstun)

func wisp_enable():
	print("Wispflower summoned wisps")
	enable_wisps.emit()

func flash():
	if GameState.target_player.current_zone == current_zone and !dead:
		anim_stun()
		hit_area.hp -= flash_component.flash_damage

func death():
	if !dead:
		dead = true
		flash_component.is_flashable = false
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(hit_area.hitstun).timeout
		anim_death()
		death_rattle.emit()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()
