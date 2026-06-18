class_name EnemyMimic extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var speed : float = 0.1
var dead : bool = false
var aggression : bool = false
var vulnerable : bool = false
var invulnerability : bool = false
var initial_position : Vector2 = Vector2(0,0)

##----------ANIMATIONS-----------##

func anim(value : String):
	match value:
		"idle_loop": 
			while !aggression:
				%AnimatedSprite2D.play("default")
				await get_tree().create_timer(randi_range(5,10)).timeout
				%AnimatedSprite2D.play("peek")
				await get_tree().create_timer(1).timeout
		"peek": 
			pass
		"bite":
			Sound.mimic("bite")
			%AnimatedSprite2D.play("active")
			await get_tree().create_timer(hit_area.hitstun*1).timeout 
			if aggression:
				anim_shuffle()
			else: anim_idle()
		"stun":
			Sound.mimic("pain") #placeholder
			%AnimatedSprite2D.play("stun")
			await get_tree().create_timer(hit_area.hitstun).timeout
			if !dead:
				anim_shuffle()
		"active": 
			%AnimatedSprite2D.play("shuffle")
		"death":
				Sound.mimic("death") #placeholder
				%AnimatedSprite2D.visible = false
				%DeathParticle.emitting = true
				GameState.mote_reward(GameState.reward_mimic,0,"small")

##Legacy functions
func anim_idle():
	anim("idle")

func anim_active():
	anim("bite")
	
func anim_stun():
	anim("stun")

func anim_death():
	anim("death")

func anim_shuffle():
	anim("active")

##---------FUNCTIONS------------#

func _ready() -> void:
	anim("idle_loop")
	initial_position = self.position
	flash_component.flash_detected.connect(flash)	
	hit_area.enemy_alert.connect(bite)
	hit_area.painState.connect(hurt)
	hit_area.death_rattle.connect(death)

func bite():
	if !dead:
		anim_active()
		GameState.target_player.isHurt(1+GameState.newgame)
		#await get_tree().create_timer(hit_area.hitstun*1.50).timeout

func hurt():
	if GameState.target_player.current_zone == current_zone and !dead and !invulnerability:
		anim_stun()
		if !aggression:
			aggression = true
			anim_shuffle()

func flash():
	if GameState.target_player.current_zone == current_zone and !dead and vulnerable:
		hit_area.hp -= flash_component.flash_damage
		hurt()

func _process(_delta: float) -> void:
	if aggression: ## If chasing the player
		if GameState.target_player.current_zone != current_zone: ##Re-seat if they leave my current zone
			aggression = false
			self.position = initial_position
			anim_idle()
		else: vulnerable = true ##vulnerable when chasing the player
	else: ##When waiting for player innput
		if !invulnerability: ##if not in i-frames
			if %AnimatedSprite2D.animation == "peek": #if peeking
				vulnerable = true #can be flashed
			else: vulnerable = false #can't be flashed

func _physics_process(_delta: float) -> void:
		if aggression:
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += speed #move down on Y axis
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= speed #move up on Y axis
				
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += speed #move right
			else: 
				self.position.x -= speed #if player is to the left, move left


func death():
	if !dead:
		dead = true
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(hit_area.hitstun).timeout 
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()
