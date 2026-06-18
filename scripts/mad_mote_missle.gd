extends CharacterBody2D

signal defuse

@export var target_enemy : BossImpostor
@export var explode_hitbox : HitboxComponent
@export var info_component : Node2D
@export var boss_explode_hitbox : HitboxComponent
var active : bool = false
var initial_spd : float
var spd : float = 55
var spd_increment : float = 8.0
var add_damage : int = 10
var volley_count : int = 1
var reverse : bool = false
var momentum : int

## Animations
func anim_active():
	Sound.fire("big")
	%FlameTrailParticle.visible = true
	self.visible = true
	%MadMoteSprite.visible = true
	%MadMoteSprite.visible = true
	%MadMoteSprite.play("default")

func anim_deflect():
	Sound.PlayerFlash()
	%MadMoteSprite.visible = true
	%MadMoteSprite.play("deflect")
	await get_tree().create_timer(0.25).timeout
	anim_active()

func anim_explode():
	%FlameTrailParticle.visible = false
	%MadMoteSprite.play("explode")
	%ExplodeParticle.emitting = true
	Sound.fire("big")
	Sound.explosion()
	GameState.target_player.anim_flash_fill()
	await get_tree().create_timer(0.25).timeout
	%MadMoteSprite.visible = false

## Gameplay Functions
func _ready() -> void:
	initial_spd = spd
	self.position = Vector2(9999,9999)
	explode_hitbox.selfDestruct.connect(explode)
	GameState.target_player.player_death.connect(explode)
	target_enemy.mad_mote_missle.connect(launch)
	info_component.parry.connect(player_deflect)
	boss_explode_hitbox.enemy_alert.connect(counterattack)
	target_enemy.death_rattle.connect(cleanup)
	self.visible = false

##Called by the boss
func launch():
	print("Ebon launched mote missle")
	print("Momentum: "+str(momentum))
	anim_active()
	active = true
	reverse = false
	spd = initial_spd
	momentum = volley_count #apply difficulty to projectile 
	self.position = target_enemy.position
	boss_explode_hitbox.on_touch_effect = "None"

## Called as a result of boss failed check / player failed parry
func explode():
	if active:
		anim_explode()
		defuse.emit()
		active = false
		momentum = 0
		volley_count += 1 #increase difficulty
		if !reverse: #if targeting the player
			if !GameState.EasyMode:
				GameState.target_player.isHurt(volley_count) ##i'm evil
			else: GameState.target_player.isHurt(1)
		else: #if targeting the boss
			target_enemy.hurt()

##Colliding with the boss 
func counterattack():
	print("Mote missle made contact with boss")
	if momentum <= 0:
		print("Missle lost momentum and exploded")
		explode()
	if momentum >= 1:
		%EbonVessel.anim_parry()
		deflect() #see below

## Specifically triggered by the info_component
func player_deflect():
	if !reverse:
		info_component.disable()
		deflect()

##Projectile parried
func deflect():
	print("Mote missle was deflected")
	print("Momentum: "+str(momentum))
	anim_deflect()
	if !reverse:
		reverse = true
	else: reverse = false
	momentum -= 1
	boss_explode_hitbox.on_touch_effect = "Alert"
	spd += spd_increment
	info_component.can_interact = true

func _physics_process(_delta: float) -> void:
	var directionx : float
	var directiony : float
	var target : Vector2
	
	#commented out so the missle can travel during sammy dialogue
	if active:# and !get_tree().paused
		if !reverse:
			target = GameState.target_player.position
		else: target = target_enemy.position
		
		self.look_at(target)
		
		if self.position.y < target.y: #if destination is below us
			directiony = 1 #move down
		else:
			if self.position.y >= target.y: #if destination is above us
				directiony = -1
		
		if self.position.x < target.x: #if destination is to the right
				directionx = 1 #move right
		else: 
				directionx = -1 #move left
		
		if directionx:
			velocity.x = directionx * spd
		else: velocity.x = 0 #when not inputting, you stop moving
	
		if directiony:
			velocity.y = directiony * spd
		else: velocity.y = 0 #ditto
		move_and_slide()
func cleanup():
	queue_free()
