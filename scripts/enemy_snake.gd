class_name EnemySnake extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var eye_overlay : AnimatedSprite2D
var dead : bool = false

##----------ANIMATIONS-----------##

func anim_idle():
	if !GameState.shadeActive: 
		eye_overlay.visible = true
		my_sprite.play("default")
		eye_overlay.play("default")
	else: 
		eye_overlay.visible = false
		my_sprite.play("default")
		eye_overlay.play("default")
	

func anim_active():
	Sound.shadow_snake("hiss")
	if !GameState.shadeActive: 
		eye_overlay.visible = true
	else: eye_overlay.visible = false
	my_sprite.play("active")
	eye_overlay.play("active")
	
func anim_stun():
	Sound.shadow_snake("pain")
	eye_overlay.visible = false
	#Sound.AmphoraStun()
	my_sprite.play("stun")
	await get_tree().create_timer(hit_area.hitstun).timeout
	if !dead:
		anim_idle()

func anim_death():
	#Sound.deathGeneric()
	Sound.shadow_snake("death")
	my_sprite.visible = false
	eye_overlay.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_shadowsnake,0,"small")

##---------FUNCTIONS----------##

func _ready() -> void:
	##if flashable
	flash_component.flash_detected.connect(flash)
	flash_component.is_flashable = false
	hit_area.enemy_alert.connect(emerge)
	hit_area.death_rattle.connect(death)
	conceal()

func emerge():
	if !GameState.target_player.dead and !dead:
		anim_active()
		flash_component.is_flashable = true
		await get_tree().create_timer(hit_area.hitstun).timeout
		hit_area.on_touch_effect = "Hazard"
		await get_tree().create_timer(hit_area.hitstun*3).timeout
		conceal()

func flash():
	if !dead:
		hit_area.hp -= flash_component.flash_damage
		hurt()

func hurt():
	if !dead:
		anim_stun()
		await get_tree().create_timer(hit_area.hitstun).timeout
		conceal()

func conceal():
	if !dead:
		hit_area.on_touch_effect = "Alert"
		flash_component.is_flashable = false
		anim_idle()

func death():
	if !dead:
		dead = true
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(hit_area.hitstun/2).timeout
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()
