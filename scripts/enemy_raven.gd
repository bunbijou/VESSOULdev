class_name EnemyRaven extends Node2D

signal death_rattle #used for miniboss item chests

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var current_zone : int = 999
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var rest_position : Vector2 #should be assigned on a case-by-case basis
@export var mote_bonus_mod : float = 0
@export var stay_in_home_zone : bool = false
var initial_position : Vector2
var speed : float = .65
var down_time : float = 2
var active : bool = false
var stun : bool = false
var stun_offset : float = 48
var initial_speed : float
var alert_sound : bool = false
var player_in_range : bool = false
var dead : bool = false
var regrouping : bool = false
var destination : Vector2 = Vector2(0,0)

##--------ANIMATIONS------------#
func anim_idle():
	while !active and !stun:
		my_sprite.play("default",1,false)
		await get_tree().create_timer(randi_range(5,10)).timeout
		my_sprite.play("preen",1,false)
		%FeatherParticles.emitting = true
		await get_tree().create_timer(randi_range(3,5)).timeout
		%FeatherParticles.emitting = false

func anim_active():
	if !alert_sound:
		Sound.raven("alert")
		alert_sound = true
	my_sprite.play("fly",1,false)
	%FeatherParticles.emitting = true
	
func anim_stun():
	%FeatherParticles.emitting = false
	alert_sound = false
	Sound.raven("stun")
	if !stun:
		my_sprite.play("stun",1,false)
	else: my_sprite.play("groundedStun",1,false)

func anim_falling():
	Sound.fallOut() 
	my_sprite.play("fall",1,false)

func anim_grounded():
	my_sprite.play("grounded",1,false)

func anim_death():
	Sound.raven("death")
	my_sprite.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_raven,mote_bonus_mod,"small")

##-------FUNCTIONS----------#
func _ready() -> void:
	initial_speed = speed
	initial_position = self.position
	if rest_position == Vector2(0,0): #if rest position not set
		rest_position = (initial_position + Vector2(stun_offset, 0))
	hit_area.attack_success.connect(reposition)
	hit_area.death_rattle.connect(death)
	flash_component.flash_detected.connect(flashed)
	hit_area.disabled = true
	perch()

func _physics_process(_delta: float) -> void:
	if !dead:
		#if in stunned state
		if stun:
			#fall down
			if self.position.y <= rest_position.y:
				self.position.y += 1
			else: #once grounded
				grounded() #stop moving
		else:
			if !regrouping:
				destination = GameState.target_player.position
			if active: #if entering aggressive state
				if self.position.y < destination.y: #if destination is below us
					self.position.y += speed #move down on Y axis
					flying()
				else:
					if self.position.y >= destination.y: #if destination is above us
						self.position.y -= speed #move up on Y axis
						flying()
				if self.position.x < destination.x: #if destination is to the right
					self.position.x += speed #move right
					flying()
				else: 
					self.position.x -= speed #if destination is to the left, move left
					flying()
				if stay_in_home_zone and GameState.target_player.current_zone != current_zone: #experimental
					perch()
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


func perch():
	if !dead:
		anim_idle()
		self.position = initial_position
		rest_position = initial_position + Vector2(0,stun_offset)
		hit_area.disabled = true
		active = false

func flying():
	if !dead:
		anim_active()
		flash_component.is_flashable = true
		hit_area.disabled = false

func grounded():
	if !dead:
		anim_grounded()
		flash_component.is_flashable = false

func flashed():
	if player_in_range and !stun and !dead:
		anim_stun() #play animation
		rest_position = rest_position + Vector2(0,stun_offset) #set where we should fall
		active = false #stop moving
		stun = true #ditto
		hit_area.disabled = true #keep player from being hurt
		hit_area.hp -= flash_component.flash_damage #deal damage
		await get_tree().create_timer(hit_area.hitstun).timeout 
		if !dead:
			anim_falling() 
			await get_tree().create_timer(down_time).timeout
			stun = false 
			active = true
			hit_area.disabled = false

func death():
	if !dead:
		dead = true
		hit_area.disabled = true
		await get_tree().create_timer(hit_area.hitstun).timeout 
		anim_death()
		GameState.addKillCount()
		death_rattle.emit()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()

func _on_local_area_body_entered(_body: PlayerVessel) -> void:
	player_in_range = true
	flash_component.is_flashable = true

func _on_local_area_body_exited(_body: PlayerVessel) -> void:
	player_in_range = false
	flash_component.is_flashable = false
