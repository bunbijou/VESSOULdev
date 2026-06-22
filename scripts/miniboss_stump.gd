class_name MinibossStump extends Node2D

signal death_rattle

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export_category("Please don't move me, it messes with my pathing") 
@export var movement_target : Array
@export var current_zone : int = 999
@export var battleReward : Node2D
@export var base_sprite : AnimatedSprite2D
@export var base_overlay : AnimatedSprite2D
@export var empowered_sprite : AnimatedSprite2D
@export var empowered_overlay : AnimatedSprite2D
@export var health : float = 4 #default: 4
var hitstun : float = 3
var hitstun_empowered : float = 1.5
var hitstun_quick : float = .5
var active : bool = false
var count : int = 0
var speed : float = 2
var initial_speed : float
var stunned : bool = false #keeps damage inputs from stacking
var empowered : bool = false
var initial_health : float #used for determining empowered state

var dead : bool = false
var vulnerable : bool = false

##Anims
func anim_roll_left():
	if !vulnerable and !dead:
		if empowered:
			empowered_sprite.play("rollLeft",1,false)
			empowered_overlay.play("rollLeft",1,false)
		else:
			base_sprite.play("rollLeft",1,false)
			base_overlay.play("rollLeft",1,false)

func anim_roll_right():
	if !vulnerable and !dead:
		if empowered:
			empowered_sprite.play("rollRight",1,false)
			empowered_overlay.play("rollRight",1,false)
		else:
			base_sprite.play("rollRight",1,false)
			base_overlay.play("rollRight",1,false)

func anim_roll_up():
	if !vulnerable and !dead:
		if empowered:
			empowered_sprite.play("rollUp",1,false)
			empowered_overlay.play("rollUp",1,false)
		else:
			base_sprite.play("rollUp",1,false)
			base_overlay.play("rollUp",1,false)


func anim_roll_down():
	if !vulnerable and !dead:
		if empowered:
			empowered_sprite.play("rollDown",1,false)
			empowered_overlay.play("rollDown",1,false)
		else:
			base_sprite.play("rollUp",1,false)
			base_overlay.play("rollUp",1,false)

func anim_flashed():
	if empowered:
			empowered_sprite.play("rollRight",0.1,false)
			#empowered_sprite.speed_scale = 0
			empowered_overlay.play("rollRight",0.1,false)
			#empowered_overlay.speed_scale = 0
	else:
		base_sprite.play("rollRight",0.1,false)
		#base_sprite.speed_scale = 0
		base_overlay.play("rollRight",0.1,false)
		#base_overlay.speed_scale = 0

func anim_stun():
	Sound.blazing("stun")
	Sound.wood_impact()
	%WoodFragment.emitting = true
	if empowered:
		empowered_sprite.play("stun",1,false)
		empowered_sprite.play("stun",1,false)
	else:
		base_sprite.play("stun",1,false)
		base_overlay.play("stun",1,false)
	await get_tree().create_timer(hitstun).timeout
	match count:
					0: #moving right
						anim_roll_right()
					1: 
						anim_roll_down()
					2: 
						anim_roll_left()
					3: 
						anim_roll_up()
func anim_death():
	var fade_time : float = 5
	##Achievement: Slayed Stump
	SteamHandler.achievement_get("a_flawed_vessel_stump")
	GameState.target_player.waiting = true
	#GameState.isPaused = true
	GameState.target_player.current_zone = -999
	GameState.target_player.temp_position = self.position
	empowered_sprite.play("stun",1,false)
	BgmController.stopAll()
	%MoteExplosion.emitting = true
	await get_tree().create_timer(fade_time/2).timeout
	base_sprite.visible = false
	base_overlay.visible = false
	empowered_sprite.visible = false
	empowered_overlay.visible = false
	%MoteExplosion.emitting = false
	%WoodFragment.emitting = true
	Sound.fire_crackle_loop("stop")
	Sound.wood_break()
	Sound.blazing("death")
	await get_tree().create_timer(fade_time/2).timeout
	GameState.target_player.waiting = false
	#GameState.isPaused =false
	GameState.target_player.anim_enemy_slain()
	GameState.mote_reward(GameState.reward_stump,0,"big")
	GameState.target_player.current_zone = 14 #Re-focus camera on player

	
##Functions
func _ready() -> void:
	#scales with ng+
	if !GameState.EasyMode:
		health = health+GameState.newgame
	else: health = 3 #miniboss health
	
	initial_health = health
	
	if GameState.woodsDict["woodsMiniBoss"][0] == 1:
		queue_free()
	else:
		if battleReward:
			battleReward.visible = false
		self.position = movement_target[0] #go to first spot
		GameState.target_player.flashed.connect(isFlashed)

func _process(_delta: float) -> void:
	if active and !stunned and !dead: #once started
		match count:
					0: #moving right
						anim_roll_right()
					1: 
						anim_roll_down()
					2: 
						anim_roll_left()
					3: 
						anim_roll_up()
		if !empowered:
			%AnimationPlayer.current_animation = "base"
			base_sprite.visible = true
			base_overlay.visible = true
			empowered_sprite.visible = false
			empowered_overlay.visible = false
			if !GameState.EasyMode:
				if health == initial_health/2: #if at halfHP
					_powerUp()
			else:
				if health == initial_health/3: #if at 1hp
					_powerUp()
		else:
				hitstun = hitstun_empowered #smaller window
				%AnimationPlayer.current_animation = "empowered"
				base_sprite.visible = false
				base_overlay.visible = false
				empowered_sprite.visible = true
				empowered_overlay.visible = true

	
	if health < 1 and !dead:
		death()

func _physics_process(_delta: float) -> void:
	if !active and !stunned: #if not yet started moving
		if GameState.target_player.current_zone == current_zone: #when player enters
			Sound.fire_crackle_loop("start")
			Sound.blazing("warcry")
			anim_roll_right()
			await get_tree().create_timer(1).timeout
			_startMotion()
	else:
		if !stunned and !GameState.target_player.dead:
			match count:
				0: #if at starting point
					self.position.x += speed #roll right
					if self.position.x >= movement_target[1][0]:
						count = 1
				1: #if having reached top right
					self.position.y += speed #roll down
					if self.position.y >= movement_target[2][1]:
						count = 2
				2: #if having reached bottom right
					self.position.x -= speed #roll left
					if self.position.x <= movement_target[3][0]:
						count = 3
				3: #if having reached bottom left
					self.position.y -= speed
					if self.position.y <= movement_target[0][1]:
						count = 0 #start over

func _powerUp():
	Sound.blazing("empowered")
	Sound.PlayerEmpowered()
	empowered = true

func _startMotion():
	active = true #ready set go!

func isFlashed():
	if !stunned: ##keep player from resetting the timer
		anim_flashed()
		#print("Stump _isFlashed")
		initial_speed = speed
		speed = 0
		vulnerable = true
		stunned = true
		active = false
		await get_tree().create_timer(hitstun).timeout
		speed = initial_speed #rervert
		vulnerable = false
		stunned = false
		active = true
		speed = initial_speed

func isDamaged():
	if vulnerable: #if not stunned
		if GameState.target_player.current_zone == current_zone:
			anim_stun()
			health -= 1
			vulnerable = false
			#print("Stump _isDamaged")

func _on_area_2d_body_entered(_body: PlayerVessel) -> void:
	if !GameState.target_player.dead and health > 0:
		if !vulnerable:
			GameState.target_player.isHurt(1+GameState.newgame)
			if empowered:
				GameState.target_player.is_burning()
		else: 
			isDamaged()
			Sound.blazing("stun")

func death():
	anim_death()
	dead = true
	speed = 0
	GameState.addKillCount()
	if battleReward:
		battleReward.visible = true
	GameState.woodsDict["woodsMiniBoss"][0] = 1
	#print("Blazing Stump defeated")
	death_rattle.emit()
	await get_tree().create_timer(GameState.cleanup_time_boss).timeout
	queue_free()
