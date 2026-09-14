class_name EnemyBurnout extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var activation_area : HitboxComponent
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var my_sprite_overlay : AnimatedSprite2D
@export var speed : float = .5
#@export var lenore_variant : bool = false
var anim_wait : float = 1
var stun : bool = false
var charging : bool = false
var erupted : bool = false
var initial_position : Vector2 = Vector2(0,0)
var initial_speed : float
var destination : Vector2
var knockback : bool = false
var knockback_amount : float = 1.5
var regrouping : bool = false
var dead : bool = false
var aggression : bool = false

##-----ANIMATIONS----##
func anim_idle():
	Sound.fire_crackle_loop("start")
	my_sprite.play("default",1,false)
	my_sprite_overlay.play("default",1,false)

func anim_erupt():
	Sound.undead_emerge()
	my_sprite.play("erupt",1,false)
	my_sprite_overlay.play("erupt",1,false)
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
	anim_move_down()

func anim_move_horizontal(dir : String):
	my_sprite.play("floatSide",1,false)
	my_sprite_overlay.play("floatSide",1,false)
	if dir == "right":
		my_sprite.flip_h = false
	else: my_sprite.flip_h = true

func anim_move_up():
	my_sprite.play("floatUp",1,false)
	my_sprite_overlay.play("floatUp",1,false)


func anim_move_down():
		my_sprite.play("floatDown",1,false)
		my_sprite_overlay.play("floatDown",1,false)


func anim_stun():
	Sound.burnout("pain")
	my_sprite.play("stun",1,false)
	my_sprite_overlay.visible = false
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
	if !dead:
		#my_sprite_overlay.visible = true
		anim_move_down()

func anim_death():
	Sound.fire_crackle_loop("stop")
	Sound.burnout("death")
	%DeathParticle.emitting = true
	my_sprite.visible = false
	#my_sprite_overlay.visible = false
	%CPUParticles2D.emitting = false
	GameState.mote_reward(GameState.reward_burnout,0,"small")

##-----FUNCTIONS------##
func _ready() -> void:
	GameState.target_player.state_revert.connect(target)
	initial_position = self.position
	initial_speed = speed
	hit_area.painState.connect(damage)
	flash_component.flash_detected.connect(flashed)	
	hit_area.death_rattle.connect(death)
	hit_area.attack_success.connect(reposition)
	activation_area.enemy_alert.connect(emerge)
	hit_area.disabled = true
	activation_area.collision_reset()

func emerge():
	flash_component.is_flashable = true
	%CPUParticles2D.emitting = true
	anim_erupt()
	erupted = true
	hit_area.disabled = false
	activation_area.disabled = true
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
	charging = true

func bury():
	if !dead:
		flash_component.is_flashable = false
		%CPUParticles2D.emitting = false
		erupted = false
		anim_idle()
		hit_area.disabled = true
		activation_area.disabled = false
		self.position = initial_position

func target():
	destination = GameState.target_player.position
	activation_area.collision_reset()

func _process(_delta: float) -> void:	
	if GameState.target_player.current_zone != current_zone:
		my_sprite.visible = false
	else: 
		if !dead:
			my_sprite.visible = true
	
	if GameState.target_player.current_zone == current_zone and !stun and !dead:
		my_sprite_overlay.visible = true
	else: my_sprite_overlay.visible = false
	
	## Endless Mode Only
	if GameState.favor == 2 and !aggression:
		speed = 0
	else: speed = initial_speed
	
	if charging and !dead:
		if GameState.target_player.dead: ##Endless Mode Only
			charging = false
			anim_move_down()
		if self.position.y > GameState.target_player.position.y: #if destination is above us
			anim_move_up()
		else:
			if self.position.y < GameState.target_player.position.y: #if destination is below us
				anim_move_down()
			else:
				if self.position.x < GameState.target_player.position.x: #if destination is to the right
					anim_move_horizontal("right")
				else:
					if self.position.x > GameState.target_player.position.x: #if destination is to the left
						anim_move_horizontal("left")


func _physics_process(_delta: float) -> void:
	if !dead and charging and GameState.target_player.current_zone == current_zone and !GameState.target_player.dead:
		if !regrouping:
			destination = GameState.target_player.position
		
		if self.position.y < destination.y: #if destination is below us
			self.position.y += speed #move down on Y axis
		else:
			if self.position.y >= destination.y: #if destination is above us
				self.position.y -= speed #move up on Y axis
		if self.position.x < destination.x: #if destination is to the right
			self.position.x += speed #move right
		else: 
			self.position.x -= speed #if destination is to the left, move left
		
		if knockback:
			if self.position.y < GameState.target_player.position.y: #if player is below us
					self.position.y -= knockback_amount #move up
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y += knockback_amount #move down
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x -= knockback_amount #move left
			else: 
				self.position.x += knockback_amount #if player is to the left, move right
			await get_tree().create_timer(hit_area.hitstun/4).timeout
			knockback = false

# derives func wander (see enemy_muncher.gd)
func reposition():
	var interval : float = 1.0
	var wander_distance : int = 50
	var new_destination : Vector2 = Vector2(randfn(-wander_distance, wander_distance),randfn(-wander_distance, wander_distance))

	regrouping = true
	## if player is still alive for a follow up attack
	if !GameState.target_player.dead and !dead:
		#start moving away
		destination = (self.position + new_destination)
		await get_tree().create_timer(interval).timeout
		#double back and attack
		destination = GameState.target_player.position
		regrouping = false

func flashed():
	if GameState.target_player.current_zone == current_zone and erupted == true and !dead:
		knockback = true
		hit_area.hp -= flash_component.flash_damage
		damage()

func damage():
	if !stun and !dead and GameState.target_player.current_zone == current_zone and erupted:
				anim_stun()
				aggression = true
				charging = false #interrupt charge
				stun = true #give i-frames to self
				await get_tree().create_timer(hit_area.hitstun).timeout 
				stun = false #end i frames
				charging = true #continue attack

func death():
	if !dead:
		dead = true
		flash_component.is_flashable = false
		await get_tree().create_timer(hit_area.hitstun).timeout
		anim_death()
		hit_area.on_touch_effect = "None"
		GameState.addKillCount()
		death_rattle.emit()
		await get_tree().create_timer(5).timeout
		queue_free()

##Experimental
func _exit_tree() -> void:
	Sound.fire_crackle_loop("stop")
