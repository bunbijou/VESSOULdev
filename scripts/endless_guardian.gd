extends CharacterBody2D
@export var my_sprite : AnimatedSprite2D
@export var hit_area : HitboxComponent
@export var nearby_area : HitboxComponent
@export_enum("a","b","c","d") var id: String
var player_nearby : bool = false
var active : bool = false
var stunned : bool = false
var aggression : bool = false
var aggression_time : float = 3.0
var aggression_spd_mod : float = 1

## Animations ##
func anim(type : String, direction : String):
	match type:
		"war_cry":
			Sound.maze_guardian("spawn")
		"appear":
			%DuskParticle.emitting = false
			%DawnParticle.emitting = false
			%TwilightParticle.emitting = false
			Sound.maze_guardian("spawn")
			match GameState.endless["theme"]:
				0: 
					my_sprite.play("dawn_down")
				1:
					my_sprite.play("dusk_down")
				2:
					my_sprite.play("twilight_down")
			%DeathParticle.emitting = true #placeholder
		"disappear":
				%DuskParticle.emitting = false
				%DawnParticle.emitting = false
				%TwilightParticle.emitting = false
				Sound.maze_guardian("death")
				my_sprite.visible = false
				self.visible = false
				%DeathParticle.emitting = true
				#to-do cute particle effect
		"active":
			match GameState.endless["theme"]:
				0: 
					%DuskParticle.emitting = false
					%DawnParticle.emitting = true
					%TwilightParticle.emitting = false
					match direction:
						"up":
							my_sprite.play("dawn_up")
						"down":
							my_sprite.play("dawn_down")
						"left":
							my_sprite.play("dawn_side")
							my_sprite.flip_h = false
						"right":
							my_sprite.play("dawn_side")
							my_sprite.flip_h = true
				1:
					%DuskParticle.emitting = true
					%DawnParticle.emitting = false
					%TwilightParticle.emitting = false
					match direction:
						"up":
							my_sprite.play("dusk_up")
						"down":
							my_sprite.play("dusk_down")
						"left":
							my_sprite.play("dusk_side")
							my_sprite.flip_h = false
						"right":
							my_sprite.play("dusk_side")
							my_sprite.flip_h = true
				2:
					%DuskParticle.emitting = false
					%DawnParticle.emitting = false
					%TwilightParticle.emitting = true
					match direction:
						"up":
							my_sprite.play("twilight_up")
						"down":
							my_sprite.play("twilight_down")
						"left":
							my_sprite.play("twilight_side")
							my_sprite.flip_h = false
						"right":
							my_sprite.play("twilight_side")
							my_sprite.flip_h = true
		"stun":
			%DuskParticle.emitting = false
			%DawnParticle.emitting = false
			%TwilightParticle.emitting = false
			Sound.maze_guardian("pain")
			match GameState.endless["theme"]:
				0: 
					my_sprite.play("dawn_stun")
				1:
					my_sprite.play("dusk_stun")
				2:
					my_sprite.play("twilight_stun")

## Gameplay ##
##Enable player flash response
func _ready() -> void:
	self.visible = false
	nearby_area.enemy_alert.connect(player_near)
	GameState.target_player.flashed.connect(stun)
	GameState.target_player.flash_weak.connect(stun_weak)
	%EndlessConfig.condition_met.connect(disable)
	match id:
		"a":
			%EndlessConfig.activate_A.connect(start)
		"b":
			%EndlessConfig.activate_B.connect(start)
		"c":
			%EndlessConfig.activate_C.connect(start)
		"d":
			if GameState.endless["curse_saturn"] != 1:
				%EndlessConfig.activate_D.connect(start)
			else: print("Samael's curse deferred guardian D")

func start():
	if !active:
		self.visible = true
		self.position = GameState.target_player.position
		anim("appear","")
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun*2).timeout
		hit_area.on_touch_effect = "Hazard"
		active = true

## If the maze condition has been met
func disable():
	if self.visible:
		anim("disappear","")
		hit_area.on_touch_effect = "None"
		active = false
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
		self.position = Vector2(9999,9999)

## Don't damage the player if this unit hasn't been activated yet
func _process(_delta: float) -> void:
	if !active:
		hit_area.on_touch_effect = "None"
	else:
		if !stunned:
			hit_area.on_touch_effect = "Hazard"

## Flash response
func stun():
	if !stunned and active:
		hit_area.on_touch_effect = "None"
		stunned = true
		anim("stun","")
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
		stunned = false
		hit_area.on_touch_effect = "Hazard"
		aggro()

## Quick motes don't stun for as long
func stun_weak():
	if !stunned and active:
		hit_area.on_touch_effect = "None"
		stunned = true
		anim("stun","")
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun/2).timeout
		stunned = false
		hit_area.on_touch_effect = "Hazard"
		aggro()

func aggro():
	if !aggression:
		anim("war_cry","")
		aggression = true
		aggression_spd_mod = 2
		%AngerSprite.visible = true
		await get_tree().create_timer(aggression_time*(1+GameState.newgame)).timeout
		aggression = false
		aggression_spd_mod = 1
		%AngerSprite.visible = false

func player_near():
	player_nearby = true

func _physics_process(_delta: float) -> void:
	var directionx : float
	var directiony : float
	var target : Vector2
	var offset : int = 64
	match id:
		"a": ## Follows player when close, goes top right when not close
			if aggression:
				target = GameState.target_player.position
			else:
				if player_nearby:
					target = GameState.target_player.position
				else: target = GameState.target_player.position + Vector2(offset, -offset)
		"b": ## Tries to be to the right of player, moves top left when not close
			if aggression:
				target = GameState.target_player.position
			else:
				if player_nearby:
					target = GameState.target_player.position+Vector2(5,0)
				else: target = GameState.target_player.position + Vector2(-offset, -offset)
		"c": ## Moves relative to A and B, moves bottom right when not close
			if aggression:
				target = GameState.target_player.position
			else:
				if player_nearby:
					target = GameState.target_player.position+Vector2(0,5)#(%MazeGuardianA.position-%MazeGuardianB.position)/2 #idfk man
				else: target = GameState.target_player.position + Vector2(offset, offset)
		"d": ## Goes bottom left when player close; Chases when player far away
			if aggression:
				target = GameState.target_player.position
			else:
				if player_nearby:
					target = GameState.target_player.position + Vector2(-offset, offset)
				else: target = GameState.target_player.position
	
	if active and !stunned and !GameState.target_player.dead:
		if self.position.y < target.y: #if destination is below us
			directiony = 1 #move down
			anim("active","down")
		else:
			if self.position.y >= target.y: #if destination is above us
				anim("active","up")
				directiony = -1
		if self.position.x < target.x: #if destination is to the right
			anim("active","right")
			directionx = 1 #move right
		else: 
			anim("active","left")
			directionx = -1 #move left
		
		if directionx:
			velocity.x = directionx * (%EndlessConfig.guardian_spd*aggression_spd_mod)
		
		if directiony:
			velocity.y = directiony * (%EndlessConfig.guardian_spd*aggression_spd_mod)
		move_and_slide()


func player_far(_body: PlayerVessel) -> void:
	player_nearby = false
