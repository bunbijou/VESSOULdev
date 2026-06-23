class_name EnemyLilJaw extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var flash_component : FlashComponent
@export var hit_area : HitboxComponent
@export var shield_area : HitboxComponent
@export var speed : float = 0.1
@export var my_sprite : AnimatedSprite2D
var active : bool = true #true = enables following behavior

##-------ANIMATIONS---------#
func anim_idle():
	my_sprite.animation = "default"

func anim_stun():
	Sound.painGeneric() #placeholder
	my_sprite.animation = "stun"
	await get_tree().create_timer(hit_area.hitstun).timeout
	if hit_area.hp != 0:
		anim_idle()

func anim_death():
	Sound.deathGeneric() #placeholder
	my_sprite.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_liljawer,0,"small")

##-------GAMEPLAY FUNCTIONS--------#
func _ready() -> void:
	Sound.LurkerGiggle()
	flash_component.flash_detected.connect(hurt)
	hit_area.death_rattle.connect(death)
	hit_area.painState.connect(hurt)

func _process(_delta: float) -> void:
	if !GameState.shadeActive: 
		shield_area.visible = false
		shield_area.monitoring = false
	else:
		shield_area.visible = true
		shield_area.monitoring = true

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone:
		if active: 
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += speed #move down on Y axis
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= speed #move up on Y axis
				
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += speed #move right
			else: 
				self.position.x -= speed #if player is to the left, move left

func _on_area_2d_body_entered(_body: PlayerVessel) -> void: #this is important to pass the player character info to the hit_area
		var initial_speed : float = 0
		if active:
			initial_speed = speed
			speed = (speed)*16
			Sound.MuncherEat() #placeholder
			await get_tree().create_timer(hit_area.hitstun).timeout
			#hit_area._on_player_touch() # do the on-touch effect
			speed = initial_speed

##Only able to be damaged by flash
func hurt():
	if GameState.target_player.current_zone == current_zone and active:
		active = false
		anim_stun()
		await get_tree().create_timer(hit_area.hitstun).timeout
		hit_area.hp -= flash_component.flash_damage
		active = true

func death():
	hit_area.on_touch_effect = "None"
	active = false
	await get_tree().create_timer(hit_area.hitstun).timeout
	anim_death()
	GameState.addKillCount()
	death_rattle.emit()
	await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
	queue_free()
	

func _on_local_area_body_entered(_body: PlayerVessel) -> void:
	if GameState.target_player.current_zone == current_zone and active:
		flash_component.is_flashable = true
	

func _on_local_area_body_exited(_body: PlayerVessel) -> void:
	flash_component.is_flashable = false
