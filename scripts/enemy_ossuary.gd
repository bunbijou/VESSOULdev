class_name EnemyOssuary extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var my_sprite : AnimatedSprite2D
@export var my_sprite_overlay : AnimatedSprite2D
@export var flash_component : FlashComponent
@export var activation_area : HitboxComponent
@export var hit_area : HitboxComponent
@export var add_damage : int = 2 
@export var speed : float = 1
@export var burst_particle : CPUParticles2D
@export var silenced : bool = false
var activation_delay : float = 0.25
var charging : bool = false
var erupted : bool = false
var initial_position : Vector2 = Vector2(0,0)
var knockback : bool = false
var knockback_amount : float = 1
var dead : bool = false
var resentment : bool = false #prevents mote gain on death via explosion
var aggression : bool = false

#-----------------ANIMATIONS------------#
func anim_idle():
	if !silenced:
		if GameState.target_player.current_zone == current_zone:
			Sound.ossuary("snore_start")
	my_sprite.play("idle",1,false)
	my_sprite_overlay.play("idle",1,false)

func anim_emerge():
	Sound.undead_emerge()
	Sound.ossuary("snore_stop")
	my_sprite.play("emerge",1,false)
	my_sprite_overlay.play("emerge",1,false)

func anim_float():
	my_sprite_overlay.visible = true
	Sound.ossuary("chase_start")
	my_sprite.play("float",1,false)
	my_sprite_overlay.play("float",1,false)

func anim_wait():
	my_sprite_overlay.visible = true
	my_sprite.play("float",0,false)
	my_sprite_overlay.play("float",0,false)

func anim_stun():
	my_sprite_overlay.visible = false
	Sound.ossuary("pain")
	my_sprite.play("stun",1,false)

func anim_explode():
	Sound.VesselBreak()
	Sound.explosion()
	my_sprite.play("explode",1,false)
	my_sprite_overlay.play("explode",1,false)
	burst_particle.emitting = true
	%BlackSmokeParticle.emitting = false

func anim_death():
	%ShadeShield.visible = false
	Sound.ossuary("chase_stop")
	Sound.ossuary("death")
	my_sprite.visible = false
	my_sprite_overlay.visible = false
	%BlackSmokeParticle.emitting = false
	if !resentment:
		%DeathParticle.emitting = true
		GameState.mote_reward(GameState.reward_ossuary,0,"small")

#---------FUNCTIONS-------------------#
func _ready() -> void:
	z_index = 1
	initial_position = self.position #where to return to if player leaves our zone
	flash_component.flash_detected.connect(stun) #flash component
	activation_area.enemy_alert.connect(erupt) #activation radius component
	hit_area.disabled = true 
	hit_area.selfDestruct.connect(explode)
	hit_area.painState.connect(stun)
	hit_area.death_rattle.connect(death)
	_bury()

func _bury():
	anim_idle()
	erupted = false
	activation_area.disabled = false
	hit_area.set_deferred("disabled", true) 
	self.position = initial_position

func erupt():
	if !dead:
		anim_emerge()
		erupted = true #to keep from repeating the animation
		activation_area.disabled = true
		hit_area.disabled = false #!!!
		await get_tree().create_timer(activation_delay).timeout #wait so anim can play
		charging = true

func pursuit():
	z_index = 999
	if erupted and !dead:# and !charging:
		anim_float()
		charging = true

func _process(_delta: float) -> void:
	if GameState.favor == 2 and !aggression:
		anim_wait()
		charging = false

func _physics_process(_delta: float) -> void:
	if charging and erupted and !dead:
		pursuit()
		if GameState.target_player.current_zone == current_zone:
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += speed #move down on Y axis
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= speed #move up on Y axis
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += speed #move right
				my_sprite.flip_h = false
				my_sprite_overlay.flip_h = false
			else: 
				self.position.x -= speed #if player is to the left, move left
				my_sprite.flip_h = true
				my_sprite_overlay.flip_h = true
		else: 
			_bury()
		
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

##Only able to be damaged by flash, otherwise just blows up
func stun():
	if GameState.target_player.current_zone == current_zone and erupted and !dead:
			aggression = true
			knockback = true
			charging = false #interrupt charge
			hit_area.hp -= flash_component.flash_damage
			anim_stun()
			await get_tree().create_timer(hit_area.hitstun).timeout
			anim_float()
			charging = true #continue attack
			knockback = false

func explode():
	if charging and !dead:
		resentment = true
		charging = false
		anim_explode()
		if !GameState.EasyMode: GameState.target_player.isHurt(1+GameState.newgame)
		else: GameState.target_player.isHurt(3+GameState.newgame) ##was 1+NGvalue // #+add_damage)
		activation_area.disabled = true
		hit_area.disabled = true
		death()	

func death():
	if !dead:
		dead = true
		flash_component.is_flashable = false
		await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()

##Experimental
func _exit_tree() -> void:
	Sound.ossuary("snore_stop")
	Sound.ossuary("chase_stop")
