class_name EnemyLurker extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var my_sprite : AnimatedSprite2D
@export var hit_area : HitboxComponent
@export var flash_component: FlashComponent
@export var leech_rate : float = 0.01
var stunned : bool = false
var fleeing : bool = false
var speed : float = 0.1
var leech : bool = false
var scale_mod : float = 0
var dead : bool = false
var channeling : bool = false

##-----ANIMATIONS----##
func anim_idle():
	self.visible = true
	my_sprite.play("default")
	%AnimatedSpriteOverlay.play("default")
	%DeathParticle.emitting = true

func anim_erupt():
	Sound.lurker("cast")
	my_sprite.play("erupt")
	%AnimatedSpriteOverlay.play("erupt")
	await get_tree().create_timer(1).timeout
	anim_flee()

func anim_flee():
	Sound.lurker("channel_start")
	my_sprite.play("float")
	%AnimatedSpriteOverlay.play("float")
	
func anim_stun():
	Sound.lurker("pain")
	my_sprite.play("stun")
	%AnimatedSpriteOverlay.visible = false
	await get_tree().create_timer(hit_area.hitstun).timeout
	if !dead:
		anim_flee()
		%AnimatedSpriteOverlay.visible = true

func anim_disappear():
	self.visible = false
	%DeathParticle.emitting = true

func anim_death():
	Sound.lurker("death")
	Sound.lurker("channel_stop")
	%SoulFlameParticle.emitting = false
	%DeathParticle.emitting = true
	my_sprite.visible = false
	GameState.mote_reward(GameState.reward_lurker+int(scale_mod),0,"small")

##----------FUNCTIONS----------##
func _ready() -> void:
	%VoidParticle.emitting = false
	%HidingSpot.lurker_found.connect(_found)
	z_index = 0
	flash_component.flash_detected.connect(_enemyFled)
	hit_area.disabled = true
	hit_area.enemy_alert.connect(flash_if_ready)
	hit_area.death_rattle.connect(death)
	leech_rate = leech_rate*(1+GameState.newgame) #experimental

func _process(_delta: float) -> void:
	if leech and GameState.playerActiveSouls >= 0:
		GameState.playerActiveSouls -= leech_rate
		scale_mod += (leech_rate/10000)
		self.scale = Vector2(1,1)+Vector2(scale_mod,scale_mod)

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone: #if target player is in my zone
		if !fleeing: #if not already running away 
			position = (GameState.target_player.position)+(Vector2(0,1)) #hide at player position
			leeching(true)
		else: 
			self.position = %HidingSpot.position
			leeching(false)
	else: 
		anim_disappear()
		leeching(false)
		##Experimental
		GameState.target_player.anim_darkness_advanced(false)
		Sound.lurker("channel_stop")


func leeching(state : bool):
	match state:
		true: 
			if leech != true:
				Sound.lurker("start")
				leech = true
				while leech == true: ##experimental, was 4
					await get_tree().create_timer(1).timeout
					Sound.lurker("leech")
		false:
			if leech != false:
				leech = false

##This is called when the player flashes
func _enemyFled():
		if GameState.target_player.current_zone == current_zone:
			##Hide and start doing other things
			if !fleeing:
				z_index = 2000
				fleeing = true ## If we haven't already left from our hiding position, go and hide
				%VoidParticle.emitting = true
				GameState.target_player.anim_darkness_advanced(true)
				anim_erupt()
				hit_area.disabled = false #just for good measure
				leech = false
				self.position = %HidingSpot.position
				channeling = true
				flash_component.is_flashable = false
			else: 
				##Take damage like normal
				damage()

func flash_if_ready():
		if fleeing:
			flash_component.is_flashable = true

func damage():
	if !stunned:
			anim_stun()
			hit_area.hp -= flash_component.flash_damage
			stunned = true #give i-frames to self
			await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
			stunned = false


##This is called when the player enters/leaves our hiding spot radius
func _found(state : bool):
	if fleeing:
		flash_component.is_flashable = state

func death():
	if !dead:
		%VoidParticle.emitting = false
		GameState.target_player.anim_darkness_advanced(false)
		dead = true
		anim_stun()
		await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()

func _exit_tree() -> void:
	Sound.lurker("channel_stop")
