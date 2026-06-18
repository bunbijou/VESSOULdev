class_name EnemyMoteMuncher extends Node2D

signal death_rattle

@export_category("Please don't nest me, it messes with my pathing")
@export var current_zone : int = 999
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var mote_bonus_mult : float = 0
@export var wander_disable : bool = false
var angered : bool = false
var mobile : bool = false
var stun : bool = false
var interval : float = 2 #time between jumps
var spd : float = .35
var health : int
var scale_mod : float = 0
var motes_absorbed : int = 5
var destination : Vector2
var dead : bool = false

##----------ANIMATIONS-------##

func anim_idle():
	if !angered:
		%animPlayer.current_animation = "RESET"
		%animSprite.play("idle")
	else: 
		%animPlayer.current_animation = "RESET"
		%animSprite.play("idle_angry")

func anim_jump():
	if !angered:
		%animPlayer.current_animation = "jump"
		%animSprite.play("jump")
	else: 
		%animPlayer.current_animation = "jump"
		%animSprite.play("jump_angry")

func anim_stun():
	Sound.muncher("pain")
	%animSprite.animation = "stun"
	await get_tree().create_timer(hit_area.hitstun+0.1).timeout
	if !dead:
		anim_idle() 

func anim_death():
	Sound.muncher("death")
	%animSprite.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_muncher+motes_absorbed,mote_bonus_mult,"small")

##---------FUNCTIONS----------##

func _ready() -> void:
	if GameState.EasyMode:
		health = 1
	else:
		health = 2+(1*GameState.newgame)
	flash_component.flash_detected.connect(flashed)
	hit_area.painState.connect(damaged)
	hit_area.death_rattle.connect(death)
	hit_area.enemy_alert.connect(munch)
	GameState.target_player.fatal_damage.connect(wander)
	%Timer.wait_time = interval
	if GameState.newgame != 0:
		angered = true

func flashed():
	if GameState.target_player.current_zone == current_zone:
		hit_area.hp -= flash_component.flash_damage
		damaged()

func damaged():
	mobile = false
	stun = true
	anim_stun()
	await get_tree().create_timer(hit_area.hitstun).timeout 
	_anger()
	stun = false

func _anger():
	if !angered:
		angered = true
		interval = 1
		spd = .5
	
func _jump():
	mobile = true
	if !stun and !dead:
		anim_jump()
		await get_tree().create_timer(1).timeout
		anim_idle()
		mobile = false

func _process(_delta: float) -> void:
	self.scale = Vector2(1+scale_mod,1+scale_mod)

func _physics_process(_delta: float):	
	#If player isn't around, wander aimlessly
	if GameState.target_player.current_zone != current_zone :
		if !wander_disable:
			wander()
	else: #Chase player
		destination = GameState.target_player.position
		#Move around
		if !dead and mobile and !stun:
				if self.position.y < destination.y: #if player is below us
					self.position.y += spd #move down on Y axis
				else:
					if self.position.y >= destination.y: #if player is above us
						self.position.y -= spd #move up on Y axis
		
				if self.position.x < destination.x: #if player is to the right
					self.position.x += spd #move right
					%animSprite.flip_h = false
				else: 
					self.position.x -= spd #if player is to the left, move left
					%animSprite.flip_h = true

func _on_timer_timeout() -> void:
	if !stun and !mobile and !dead:
		_jump()

func wander():
	var wander_distance : int = 5 #was 20
	var new_destination : Vector2 = Vector2(randfn(-wander_distance, wander_distance),randfn(-wander_distance, wander_distance))
	if !dead and !wander_disable:
		destination = (self.position + new_destination)
		await get_tree().create_timer(interval).timeout

func munch():
	var munch_strength : int
	var scale_increment : float = 0.1
	if !dead:
		if !angered: #if not angry, not harmful (by default)
			#check if player's motes are less than our mote-subtraction amount (motes_absorbed)
			if GameState.playerActiveSouls < motes_absorbed: 
				#if player has no motes, damage them instead and absorb motes that way
				if GameState.playerActiveSouls == 0:
					GameState.target_player.isHurt(1)
					motes_absorbed += motes_absorbed
				else: #otherwise, just take what motes they do have, as long as it's less than motes_absorbed
					motes_absorbed += int(GameState.playerActiveSouls)
					GameState.playerActiveSouls = 0
					GameState.target_player.anim_stun()
				Sound.muncher("eat")
				%HealParticle.emitting = true
				scale_mod += scale_increment
			else: #If player has more motes than motes_absorbed, absorb away
				motes_absorbed += motes_absorbed
				GameState.playerActiveSouls -= motes_absorbed
				GameState.target_player.anim_stun()
				Sound.muncher("eat")
				%HealParticle.emitting = true
				scale_mod += scale_increment
		else: #if the muncher is angered, scale their damage by their motes_absorbed value
			@warning_ignore("integer_division")
			munch_strength = int(motes_absorbed/5)
			if munch_strength > 1:
				GameState.target_player.isHurt(munch_strength+GameState.newgame)
			else: GameState.target_player.isHurt(1+GameState.newgame)
			Sound.PlayerDamaged()
			Sound.muncher("eat")
			%HealParticle.emitting = true
			scale_mod += scale_increment


func death():
	if !dead:
		dead = true
		await get_tree().create_timer(.35).timeout #wait so anim and sound can play
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout #wait so anim and sound can play
		queue_free() #banish self to shadow realm
