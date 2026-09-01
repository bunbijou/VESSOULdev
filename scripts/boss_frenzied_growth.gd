class_name BossFrenzyGrowth extends Node2D

signal death_rattle 

@export var current_zone : int = 999
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export_enum("base:0","jabL:1","jabR:2","swipeL:3","swipeR:4","shoot:5","fire:6") var moves : int
@export var health : int = 6
var current : int = 0
var speed : float = 0.030 #gaping jawer speed = 0.05
var attacking : bool = false
var stun : bool = false
var wait : bool = true
var vulnerable : bool = false
var initial_hp : float
var initial_speed : float 
var hitstun : float = .5
var knockback : bool = false
@warning_ignore("narrowing_conversion")
var knockback_amount : float = .5
var dead : bool = false

func _ready():
	if GameState.EasyMode:
		health = 3
	
	##This is for determining what the halfway point of HP is
	initial_hp = health
	initial_speed = speed
	health += GameState.newgame
	if GameState.woodsDict["woodsBoss"] == 1:
		queue_free()
	else: GameState.target_player.flashed.connect(_pain)

func _intro():
	Sound.fire("small")
	Sound.frenzygrowth("roar")
	%AnimationPlayer.current_animation = "roar"
	await get_tree().create_timer(2).timeout
	current = 1 #queue next attack

func _process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone and !dead: #when player enters
		if wait == true: #if battle not yet started
			_intro() #start battle
			wait = false
		
		if !knockback:
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += speed #move down on Y axis
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= speed #move up on Y axis
			
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += speed #move right
			else: 
				self.position.x -= speed #if player is to the left, move left
		else:
			self.position.y -= knockback_amount #move up on Y axis
			await get_tree().create_timer(hitstun).timeout
			knockback = false

		if !attacking and !stun: #if not currently in an active state
			match current:
				1: 
					attacking = true
					_random_melee(2)
					#_jabLeft() 
				2:
					attacking = true
					_random_melee(5)
					#_jabRight()
				5:
					attacking = true
					_seedSpit()
				3:
					attacking = true
					_random_melee(4)
					#_leftHook()
				4:
					attacking = true
					_random_melee(6)
					#_rightHook()
				6:
					attacking = true
					_flameSpit()

		if health < 1: 
			death()
func _on_hitbox_body_entered(_body: PlayerVessel) -> void:
	if !dead:
		GameState.target_player.isHurt(1+GameState.newgame)
	

func _on_fire_hitbox_entered(_body: PlayerVessel) -> void:
	if !dead:
		GameState.target_player.isHurt(1+GameState.newgame)
		GameState.target_player.is_burning()

func _random_melee(next : int):
	var selection : int = 0
	randomize()
	selection = randi_range(0,3)
	if !dead:
		match selection:
			0: ##jab left
				Sound.frenzygrowth("jab")
				Sound.woosh_ascend()
				%AnimationPlayer.current_animation = "jabL"
				%JabLeftCollider.set_deferred("disabled", false)
				await get_tree().create_timer(1).timeout
				Sound.impact()
				Sound.PumpkinSplat()
				await get_tree().create_timer(.5).timeout
				%JabLeftCollider.set_deferred("disabled", true)
			1: ##jab right
				print("Attack: Right jab")
				Sound.frenzygrowth("jab")
				Sound.woosh_ascend()
				%AnimationPlayer.current_animation = "jabR"
				%JabRightCollider.set_deferred("disabled", false)
				await get_tree().create_timer(1).timeout
				Sound.impact()
				Sound.PumpkinSplat()
				await get_tree().create_timer(.5).timeout
				%JabRightCollider.set_deferred("disabled", true)
			2: ##swipe left
				print("Attack: Left Hook")
				%AnimationPlayer.current_animation = "hookL"
				%SwipeCollider.set_deferred("disabled", false)
				Sound.frenzygrowth("swipe")
				Sound.woosh_ascend()
				await get_tree().create_timer(1.5).timeout
				%SwipeCollider.set_deferred("disabled", true)
			3: ##swipe right
				print("Attack: Right Hook")
				%AnimationPlayer.current_animation = "hookR"
				%SwipeCollider.set_deferred("disabled", false)
				Sound.frenzygrowth("swipe")
				Sound.woosh_ascend()
				await get_tree().create_timer(1.5).timeout
				%SwipeCollider.set_deferred("disabled", true)
		current = next
		attacking = false

#func _jabLeft(): #jabL
	#if !dead:
		#print("Attack: Left jab")
		#Sound.frenzygrowth("jab")
		#Sound.woosh_ascend()
		#%AnimationPlayer.current_animation = "jabL"
		#%JabLeftCollider.set_deferred("disabled", false)
		#await get_tree().create_timer(1).timeout
		#Sound.impact()
		#Sound.PumpkinSplat()
		#await get_tree().create_timer(.5).timeout
		#%JabLeftCollider.set_deferred("disabled", true)
		#current = 2 #queue up next attack, see above
		#attacking = false
	#
#func _jabRight(): #jabR
	#if !dead:
		#print("Attack: Right jab")
		#Sound.frenzygrowth("jab")
		#Sound.woosh_ascend()
		#%AnimationPlayer.current_animation = "jabR"
		#%JabRightCollider.set_deferred("disabled", false)
		#await get_tree().create_timer(1).timeout
		#Sound.impact()
		#Sound.PumpkinSplat()
		#await get_tree().create_timer(.5).timeout
		#%JabRightCollider.set_deferred("disabled", true)
		#current = 5 #queue up next attack, see above
		#attacking = false
	
func _seedSpit(): #shoot
	if !dead:
		Sound.frenzygrowth("giggle")
		print("Attack: Seed Spit")
		%SeedParticle.emitting = true
		%AnimationPlayer.current_animation = "shoot"
		%SeedCollider.set_deferred("disabled", false)
		Sound.seed_spit()
		await get_tree().create_timer(1.5).timeout
		%SeedParticle.emitting = false
		%SeedCollider.set_deferred("disabled", true)
		current = 3 #queue up next attack, see above
		attacking = false
	
#func _leftHook(): #swipeL
	#if !dead:
		#print("Attack: Left Hook")
		#%AnimationPlayer.current_animation = "hookL"
		#%SwipeCollider.set_deferred("disabled", false)
		#Sound.frenzygrowth("swipe")
		#Sound.woosh_ascend()
		#await get_tree().create_timer(1.5).timeout
		#%SwipeCollider.set_deferred("disabled", true)
		#current = 4 #queue up next attack, see above
		#attacking = false
	#
#func _rightHook(): #swipeR
	#if !dead:
		#print("Attack: Right Hook")
		#%AnimationPlayer.current_animation = "hookR"
		#%SwipeCollider.set_deferred("disabled", false)
		#Sound.frenzygrowth("swipe")
		#Sound.woosh_ascend()
		#await get_tree().create_timer(1.5).timeout
		#%SwipeCollider.set_deferred("disabled", true)
		#current = 6 #queue up next attack, see above
		#attacking = false
	
func _flameSpit(): #fire
	if !dead:
		Sound.frenzygrowth("giggle")
		print("Attack: Flame Spit")
		%AnimationPlayer.current_animation = "fire"
		%FireCollider.set_deferred("disabled", false)
		%FireParticle.emitting = true
		vulnerable = true
		Sound.fire("big")
		await get_tree().create_timer(1.5).timeout
		%FireCollider.set_deferred("disabled", true)
		current = 1 #queue up next attack, see above
		attacking = false
		vulnerable = false

func _pain():
	if vulnerable and !stun and !dead:
		knockback = true
		print("Frenzied Growth took damage")
		health -= 1
		vulnerable = false
		stun = true
		Sound.frenzygrowth("pain")
		%AnimationPlayer.current_animation = "stun"
		await get_tree().create_timer(hitstun).timeout
		stun = false

func death():
		var fade_time : float = 5
		##Achievement: Defeat Frenzygrowth
		GameState.target_player.anim_achievement("a_frenzied_growth_defeat")
		dead = true
		Sound.frenzygrowth("pain")
		Sound.frenzygrowth("pain")
		Sound.frenzygrowth("pain")
		%AnimationPlayer.play("stun")
		GameState.target_player.waiting = true
		BgmController.stopAll()
		GameState.target_player.current_zone = -999
		GameState.target_player.temp_position = self.position
		%DarknessExplosion.emitting = true
		%FireExplosion.emitting = true
		%MoteExplosion.emitting = true
		%SeedExplosion1.emitting = true
		%SeedExplosion2.emitting = true	
		await get_tree().create_timer(fade_time/2).timeout
		%AnimationPlayer.play("roar",1,-1)
		GameState.anim_rumble(1.5,1)
		Sound.frenzygrowth("death")
		Sound.explosion_pumpkin()
		%DeathSeedExplosion.emitting = true
		%DeathFireExplosion.emitting = true
		%DarknessExplosion.emitting = false
		%FireExplosion.emitting = false
		%MoteExplosion.emitting = false
		%SeedExplosion1.emitting = false
		%SeedExplosion2.emitting = false
		await get_tree().create_timer(fade_time/2).timeout
		Sound.key_drop()
		GameState.target_player.current_zone = 13 #revert camera change
		GameState.target_player.anim_enemy_slain()
		GameState.mote_reward(GameState.reward_growth,0,"big")
		death_rattle.emit()
		print("Frenzied Growth was defeated")
		GameState.woodsDict["woodsBoss"] = 1 #Register boss completion
		GameState.target_player.waiting = false
		queue_free()
