class_name EnemyPotHead extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var activation_area : HitboxComponent
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var my_sprite_overlay : AnimatedSprite2D
@export var silence : bool = false
@export_enum("Offensive","Defensive") var behavior : String = "Defensive"
@export var mote_bonus_mult : float = 0.0
var target_boss : Node2D
var anim_wait : float = 1
var stun : bool = false
var erupted : bool = false
var dead : bool = false
var glow : bool = false
var projectile = preload("res://scenes/flame_spit.tscn")
var casting : bool = false


##-----ANIMATIONS----##
func play_anim(type : String, dir : String):
	match type:
		"idle":
			if !silence:
				if GameState.target_player.current_zone == current_zone:
					Sound.pothead("snore")
			my_sprite.play("default",1,false)
			my_sprite_overlay.play("default",1,false)
		"erupt":
			%ParticleAbyss.emitting = true
			Sound.pothead("snore_stop")
			Sound.rock_break()
			my_sprite.play("erupt",1,false)
			my_sprite_overlay.play("erupt",1,false)
			await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
			%IdleFlame.emitting = true
			anim_move_down()
		"bury":
			%IdleFlame.emitting = false
			%ParticleAbyss.emitting = true
			Sound.rock_break()
			#Sound.undead_emerge()
			my_sprite.play("erupt",-1,false)
			my_sprite_overlay.play("erupt",-1,false)
			await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
			play_anim("idle","")
		"move":
			match dir:
				"up":
					my_sprite.play("floatUp",1,false)
					my_sprite_overlay.play("floatUp",1,false)
				"down":
					my_sprite.play("floatDown",1,false)
					my_sprite_overlay.play("floatDown",1,false)
				"left":
					my_sprite.play("floatSide",1,false)
					my_sprite_overlay.play("floatSide",1,false)
					my_sprite.flip_h = true
					my_sprite_overlay.flip_h = true
				"right":
					my_sprite.play("floatSide",1,false)
					my_sprite_overlay.play("floatSide",1,false)
					my_sprite.flip_h = false
					my_sprite_overlay.flip_h = false
		"stun":
			Sound.VesselBreak()
			Sound.pothead("pain")
			my_sprite.play("stun",1,false)
			await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
			if !dead:
				play_anim("move","down")
		"death":
			%IdleFlame.emitting = false
			%ShadeShield.visible = false
			%CPUParticles2D.emitting = false #weak flame particle
			Sound.pothead("death")
			my_sprite.visible = false
			%DeathParticle.emitting = true
			##Ported from Ossuary, only used by the Lenore potheads at this point
			if !target_boss:
				GameState.mote_reward(GameState.reward_pothead,mote_bonus_mult,"small")

## Legacy functions
func anim_idle():
	play_anim("idle","")

func anim_erupt():
	play_anim("erupt","")

func anim_move_horizontal(dir : String):
	if dir == "left":
		play_anim("move","left")
	else: play_anim("move","right")

func anim_move_up():
	play_anim("move","up")

func anim_move_down():
	play_anim("move","down")

func anim_stun():
	play_anim("stun","")

func anim_death():
	play_anim("death","")

##-----FUNCTIONS------##
func _ready() -> void:
	flash_component.flash_detected.connect(flashed)	
	hit_area.death_rattle.connect(death)
	hit_area.disabled = true
	anim_idle() #buried
	activation_area.enemy_alert.connect(emerge) #when player in radius, emerge
	activation_area.collision_reset()
	GameState.unpause.connect(retarget)
	Dialogue.dialogue_end.connect(retarget)
	if target_boss:
		target_boss.dispel_summoned_enemies.connect(death)

func emerge():
	if !dead and GameState.target_player.current_zone == current_zone:
		flash_component.is_flashable = true
		%CPUParticles2D.emitting = true
		anim_erupt()
		hit_area.disabled = false
		activation_area.disabled = true
		#await get_tree().create_timer(hit_area.hitstun*2).timeout
		erupted = true
		if GameState.favor != 2 and !GameState.target_player.dead: #Endless Mode Only
			cast_fire()

func bury():
	if !dead:
		play_anim("bury","")
		flash_component.is_flashable = false
		%CPUParticles2D.emitting = false
		erupted = false
		casting = false
		hit_area.disabled = true
		activation_area.disabled = false

##Animation processing
func _process(_delta: float) -> void:
	##Only show this enemy if the target player is in our zone
	if GameState.target_player.current_zone != current_zone:
		my_sprite.visible = false
	else: 
		if !dead:
			my_sprite.visible = true
	
	##Only show the glow overlay if above, and not stunned and not dead
	if GameState.target_player.current_zone == current_zone and !stun and !dead:
		my_sprite_overlay.visible = true
	else: my_sprite_overlay.visible = false
	
	if erupted and !dead:
		if GameState.target_player.dead:
			bury()
		if self.position.y > GameState.target_player.position.y: #if destination is above us
			anim_move_up()
		else:
			if self.position.y <= GameState.target_player.position.y: #if destination is below us
				anim_move_down()
			else:
				if self.position.x <= GameState.target_player.position.x: #if destination is to the right
					anim_move_horizontal("right")
				else:
					if self.position.x > GameState.target_player.position.x: #if destination is to the left
						anim_move_horizontal("left")



#func _physics_process(_delta: float) -> void:
	#if !GameState.isPaused and !dead:
		#if charging:
			#if GameState.target_player.current_zone == current_zone and !GameState.target_player.dead:
				##If the player is empowered, we're going to be hesitant about fighting them
				#if GameState.target_player.empowered and !aggression:
					##want to go home
					#speed = 0
				#else:
					#if !regrouping: #see below
						#destination = GameState.target_player.position
					#speed = initial_speed
				#if self.position.y < destination.y: #if destination is below us
					#self.position.y += speed #move down on Y axis
				#else:
					#if self.position.y >= destination.y: #if destination is above us
						#self.position.y -= speed #move up on Y axis
				#if self.position.x < destination.x: #if destination is to the right
					#self.position.x += speed #move right
				#else: 
					#self.position.x -= speed #if destination is to the left, move left
		#
		#if knockback:
			#if self.position.y < GameState.target_player.position.y: #if player is below us
					#self.position.y -= knockback_amount #move up
			#else:
				#if self.position.y >= GameState.target_player.position.y: #if player is above us
					#self.position.y += knockback_amount #move down
			#if self.position.x < GameState.target_player.position.x: #if player is to the right
				#self.position.x -= knockback_amount #move left
			#else: 
				#self.position.x += knockback_amount #if player is to the left, move right
			#await get_tree().create_timer(hit_area.hitstun/4).timeout
			#knockback = false

# derives func wander (see enemy_muncher.gd)
#func reposition():
	#var interval : float = .5 ## was .75
	#var wander_distance : int = 30
	#var new_destination : Vector2 = Vector2(randfn(-wander_distance, wander_distance),randfn(-wander_distance, wander_distance))
	#
	#regrouping = true
	### if player is still alive for a follow up attack
	#if !GameState.target_player.dead and !dead:
		##start moving away
		#destination = (self.position + new_destination)
		#await get_tree().create_timer(interval).timeout
		##double back and attack
		#destination = GameState.target_player.position
		#regrouping = false

func flashed():
	if GameState.target_player.current_zone == current_zone and erupted and !dead and !stun:
		hit_area.hp -= flash_component.flash_damage
		%ParticleAbyss.emitting = true
		anim_stun()
		stun = true #give i-frames to self
		await get_tree().create_timer(hit_area.hitstun).timeout 
		stun = false #end i frames
		if behavior == "Defensive":
			bury()

func cast_fire():
	var flame_spit_instance_a = projectile.instantiate()
	var flame_spit_instance_b = projectile.instantiate()
	var flame_spit_instance_c = projectile.instantiate()
	var flame_spit_instance_d = projectile.instantiate()
	var flame_spit_instance_e = projectile.instantiate()
	var flame_spit_interval : float = 0.05
	var beat : float = 1.5
	var flame_spit_scale_mod : Vector2 = Vector2(1,1)
	if target_boss:
		flame_spit_interval = 0.03
		beat = 0.5
		##Doesnt rlly do anything ATP
		flame_spit_scale_mod = Vector2(2,2)
	if !casting and erupted and !GameState.target_player.dead and !get_tree().paused:
		casting = true
		await get_tree().create_timer(randi_range(2,5)).timeout
		##anim_cast()
		await get_tree().create_timer(flame_spit_interval).timeout
		%FireExplosion.emitting = true
		add_child(flame_spit_instance_a)
		flame_spit_instance_a.current_zone = current_zone
		flame_spit_instance_a.scale = flame_spit_scale_mod
		await get_tree().create_timer(flame_spit_interval).timeout
		%FireExplosion.emitting = true
		add_child(flame_spit_instance_b)
		flame_spit_instance_b.current_zone = current_zone
		flame_spit_instance_b.scale = flame_spit_scale_mod
		await get_tree().create_timer(flame_spit_interval).timeout
		%FireExplosion.emitting = true
		add_child(flame_spit_instance_c)
		flame_spit_instance_c.current_zone = current_zone
		flame_spit_instance_c.scale = flame_spit_scale_mod
		await get_tree().create_timer(flame_spit_interval).timeout
		%FireExplosion.emitting = true
		add_child(flame_spit_instance_d)
		flame_spit_instance_d.current_zone = current_zone
		flame_spit_instance_d.scale = flame_spit_scale_mod
		await get_tree().create_timer(flame_spit_interval).timeout
		%FireExplosion.emitting = true
		add_child(flame_spit_instance_e)
		flame_spit_instance_e.current_zone = current_zone
		flame_spit_instance_e.scale = flame_spit_scale_mod
		await get_tree().create_timer(beat).timeout
		if behavior == "Defensive": #Bury then emerge
			play_anim("bury","")
			erupted = false
			await get_tree().create_timer(randi_range(3,5)).timeout
			play_anim("erupt","")
			erupted = true
			await get_tree().create_timer(randi_range(3,5)).timeout
		else: ##Offensive behavior (E.g. do neither)
			await get_tree().create_timer(randi_range(0,2)).timeout
		casting = false
		if !dead:
			if GameState.target_player.current_zone == current_zone and !GameState.target_player.dead:
				cast_fire() #repeat
			else: bury()

func retarget():
	if !dead and GameState.target_player.current_zone == current_zone and GameState.favor != 2 and !GameState.target_player.dead:
		cast_fire()

func death():
	if !dead:
		anim_death()
		dead = true
		flash_component.is_flashable = false
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
		GameState.addKillCount()
		death_rattle.emit() #for Tome pedestal / itemChest.tscn
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout 
		queue_free() #banish self to shadow realm

## Sound Cleanup
func _exit_tree() -> void:
	Sound.pothead("snore_stop")
	Sound.fire_crackle_loop("stop")
