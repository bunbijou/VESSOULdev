class_name EnemyMotebearer extends Node2D

signal death_rattle

@export_enum("Douser", "Cremator", "Chiller", "Shade") var enemy_type: String
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var current_zone : int = 999
@export_category("General")
@export var my_sprite : AnimatedSprite2D
@export var flash_component : FlashComponent
@export var effect_area : HitboxComponent
@export var hit_area : HitboxComponent
@export var shield_area : HitboxComponent
@export var shield_collider : CollisionShape2D
@export var can_repeatedly_attack : bool = false
@export var just_attacked : bool = false
@export var speed : float = 0.1
@export var fade_time : int = 60 #was 30
@export_category("Cremator") 
var projectile = preload("res://scenes/explosive_flame.tscn")
#export_enum("right", "left", "up", "down") var target_direction: String = "right"
@export var fire_cooldown : float = 3
@export_category("Chiller")
var chiller_projectile = preload("res://scenes/chiller_cloud.tscn")
#@export var freeze_hitbox : HitboxComponent
@export var freeze_particle : CPUParticles2D
@export var freeze_cooldown : float = 5
@export_category("Douser")
var douser_projectile = preload("res://scenes/douser_splash.tscn")
@export var mote_bonus_mult : float = 0
@export_category("Shade")
var shade_projectile = preload("res://scenes/dark_orb.tscn")
var shade_orb_casting : bool = false
var freeze_triggered : bool = false
var dispelled : bool = false
var destroyed : bool = false #for motes
var beat : float = 1.00
var default_speed : float = 0

##---------ANIMATIONS-----------------##
func play_anim(type : String, cremator_direction : String):
	match type:
		"idle": my_sprite.play("default",1,false)
		"dispel": 
			my_sprite.play("dispel",1,false)
			if enemy_type != "Shade":
				Sound.motebearer("dispel")
			else: 
				Sound.motebearer("dispel_no_cloth")
			if enemy_type == "Cremator":
				Sound.cremator_dispel()
		"cremator_channel":
			Sound.fire("small")
			%FlameBurst.emitting = true
			await get_tree().create_timer(beat*1.5).timeout
			%FlameBurst.emitting = false
		"cremator_cast":
			match cremator_direction:
				"up":
					my_sprite.play("attackUp",1,false)
					await get_tree().create_timer(beat*1.5).timeout
					if !dispelled:
						anim_motebearer_idle()
					else:
						anim_motebearer_dispel()
						if !destroyed:
							anim_mote_show()
				"right":
					my_sprite.play("attackSide",1,false)
					my_sprite.flip_h = false
					await get_tree().create_timer(beat*1.5).timeout
					if !dispelled:
						anim_motebearer_idle()
					else:
						anim_motebearer_dispel()
						if !destroyed:
							anim_mote_show()
				"down":
					my_sprite.play("attackDown",1,false)
					await get_tree().create_timer(beat*1.5).timeout
					if !dispelled:
						anim_motebearer_idle()
					else:
						anim_motebearer_dispel()
						if !destroyed:
							anim_mote_show()
				"left":
					my_sprite.play("attackSide",1,false)
					my_sprite.flip_h = true
					await get_tree().create_timer(beat*1.5).timeout
					if !dispelled:
						anim_motebearer_idle()
					else:
						anim_motebearer_dispel()
						if !destroyed:
							anim_mote_show()
		"douser_attack":
			#if enemy_type == "Douser":
			my_sprite.play("attack",1,false)
			await get_tree().create_timer(.33).timeout 
			%SplashSprite.visible = true
			%SplashSprite.play("default",1,false)
			Sound.splash()
			await get_tree().create_timer(.66).timeout 
			Sound.PlayerExtinguished()
		"douser_unarmed":
			#if enemy_type == "Douser":
			my_sprite.play("unarmed",1,false)
			#await get_tree().create_timer(1).timeout 
			#%SplashSprite.visible = false
		"chiller_cast":
			#if enemy_type == "Chiller":
			Sound.motebearer("freeze")
			my_sprite.play("cast",1,false)
			freeze_particle.emitting = true 
			await get_tree().create_timer(beat).timeout
			if !dispelled:
				anim_motebearer_idle()
		"shade_cast":
			Sound.motebearer("reveal")
			my_sprite.animation = "cast"
		"mote_hide":
			%moteSprite.visible = false
			%moteSprite.show_behind_parent = true
		"mote_show":
			%moteSprite.play("default",1,false)
			%moteSprite.visible = true
		"mote_stun":
			%moteSprite.play("stun",1,false)
## Legacy functions
func anim_motebearer_idle():
	play_anim("idle","")

func anim_motebearer_dispel():
	play_anim("dispel","")

func anim_cremator_channel():
	play_anim("cremator_channel","")

func anim_cremator_attack_left():
	play_anim("cremator_cast","left")

func anim_cremator_attack_right():
	play_anim("cremator_cast","right")

func anim_cremator_attack_up():
	play_anim("cremator_cast","up")

func anim_cremator_attack_down():
	play_anim("cremator_cast","down")

func anim_douser_attack():
	play_anim("douser_attack","")

func anim_douser_unarmed():
	play_anim("douser_unarmed","")

func anim_chiller_cast():
	play_anim("chiller_cast","")

func anim_mote_hide():
	play_anim("mote_hide","")

func anim_mote_show():
	play_anim("mote_show","")

func anim_mote_stun():
	play_anim("mote_stun","")

func _ready() -> void:
	anim_mote_hide()
	hit_area.shroudBroken.connect(_reveal)
	flash_component.flash_detected.connect(mote_stunned)
	flash_component.is_flashable = false
	if enemy_type == "Cremator": 
		%HitboxUp.explosionSpell.connect(_invokeFireUp)
		%HitboxDown.explosionSpell.connect(_invokeFireDown)
		%HitboxRight.explosionSpell.connect(_invokeFireRight)
		%HitboxLeft.explosionSpell.connect(_invokeFireLeft)
		default_speed = speed
	if enemy_type == "Chiller":
		effect_area.cloudSpell.connect(_invokeCloud)
		#GameState.target_player.state_revert.connect(_retarget)
		default_speed = speed
	if enemy_type == "Douser":
		effect_area.douseTarget.connect(_douse)
		effect_area.attackSpent.connect(_disarm)
		%SplashSprite.visible = false
		z_index = 999

#func _retarget():
	#effect_area.collision_reset()

func _process(_delta: float) -> void:
	if !dispelled:
		if enemy_type != "Shade": #Only applies to Shade's shield targets
			if !GameState.shadeActive:
				shield_area.monitoring = false
				shield_area.visible = false
				shield_collider.disabled = true
			else:
				shield_area.visible = true
				shield_area.monitoring = true
				shield_collider.disabled = false
		else:
			if GameState.target_player.current_zone == current_zone:
				if !GameState.shadeActive and !just_attacked:
					await get_tree().create_timer(.75).timeout
					_invokeDarkness()
		
		if enemy_type == "Chiller":
			if GameState.target_player.temperature == "cold":
				speed = 0 #stop pursuing
			else: speed = default_speed
		
	if enemy_type == "Shade" and dispelled and !destroyed:
		_invokeDarkOrb()
	

func _physics_process(_delta: float) -> void:
		#----------------------- CREMATOR, CHILLER -----------------------------#
		## Cremator and Chiller don't turn their bodies to face the player
		if enemy_type != "Shade" and enemy_type != "Douser" and !GameState.shadeActive:
			if GameState.target_player.current_zone == current_zone and !GameState.target_player.empowered:
				if self.position.y < GameState.target_player.position.y: #if player is below us
					self.position.y += speed #move down on Y axis
				else:
					if self.position.y >= GameState.target_player.position.y: #if player is above us
						self.position.y -= speed #move up on Y axis
				
				if self.position.x < GameState.target_player.position.x: #if player is to the right
					self.position.x += speed #move right
				else: 
					self.position.x -= speed #if player is to the left, move left
		#------------------------DOUSER------------------------#
		if enemy_type == "Douser" and !GameState.shadeActive:
			if GameState.target_player.current_zone == current_zone and GameState.target_player.empowered:
				if self.position.y < GameState.target_player.position.y: #if player is below us
					self.position.y += speed #move down on Y axis
				else:
					if self.position.y >= GameState.target_player.position.y: #if player is above us
						self.position.y -= speed #move up on Y axis
				
				if self.position.x < GameState.target_player.position.x: #if player is to the right
					self.position.x += speed #move right
				else: 
					self.position.x -= speed #if player is to the left, move left
			##Turn to face the player
			if !dispelled:
				if self.position.x < GameState.target_player.position.x: #if player is to the right
					self.scale = Vector2(1,1)
				else: 
					self.scale = Vector2(-1,1)

#func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if !dispelled:
		#match enemy_type:
			#"Douser":
				#if !just_attacked and GameState.target_player.empowered:
					#effect_area._on_player_touch(0) #Cast dousing water
			#"Cremator":
				#pass
			#"Chiller":
				#if !just_attacked and !dispelled:
					#effect_area._on_player_touch(0) #Cast chill cloud
					#await get_tree().create_timer(beat*5).timeout
					#just_attacked = false
			#"Shade":
				#pass
	#else: #if shroud has been dispelled
		#await get_tree().create_timer(hit_area.hitstun).timeout
		#hit_area.on_touch_effect = "Hazard"
	#hit_area._on_player_touch(0) #<-- super duper important

#---------------------DOUSER------------------------------------#
func _douse():
		var splash_instance = douser_projectile.instantiate()
		var splash_offset : int = 25
		if enemy_type == "Douser" and !dispelled:
			anim_douser_attack()
			await get_tree().create_timer(.5).timeout 
			add_child(splash_instance)
			splash_instance.position.x += splash_offset
			if !dispelled: #in the case of animation interrupts
				anim_douser_unarmed()
			_disarm()

func _disarm(): #Douser
	just_attacked = true #keep from attacking
	effect_area.on_touch_effect = "None" #disarm water hitbox
	hit_area.on_touch_effect = "Standard" #enable melee damage

#----------------------SHADE--------------------------------------#
func _invokeDarkness():
	if !dispelled and !GameState.shadeActive:
		GameState.shadeActive = true
		print("GameState: Shade Enabled")
		just_attacked = true
		play_anim("shade_cast","")
		GameState.target_player.anim_darken()
		await get_tree().create_timer(1.5).timeout
		#if !dispelled: #in the case of animation interrupts
		my_sprite.animation = "active"

func _invokeDarkOrb():
	var dark_orb_instance = shade_projectile.instantiate()

	if shade_orb_casting == false:
		shade_orb_casting = true
		await get_tree().create_timer(3.5).timeout
		if !destroyed and GameState.target_player.current_zone == current_zone:
			add_child(dark_orb_instance)
			dark_orb_instance.current_zone = current_zone
			dark_orb_instance.velocity = (Vector2.RIGHT*0.75)
			shade_orb_casting = false

#----------------------CREMATOR-----------------------------------#
func _invokeFireUp():
	if !just_attacked and !dispelled and !GameState.target_player.dead: #keep from interrupting itself
		_invokeFire("up")
func _invokeFireRight():
	if !just_attacked and !dispelled and !GameState.target_player.dead: #keep from interrupting itself
		_invokeFire("right")
func _invokeFireDown():
	if !just_attacked and !dispelled and !GameState.target_player.dead: #keep from interrupting itself
		_invokeFire("down")
func _invokeFireLeft():
	if !just_attacked and !dispelled and !GameState.target_player.dead: #keep from interrupting itself
		_invokeFire("left")
	
func _invokeFire(direction : String):
	var projectile_offset : int = 12 #experimental
	var projectile_interval : float = 0.25
	var fireball_instance_a = projectile.instantiate()
	var fireball_instance_b = projectile.instantiate()
	var fireball_instance_c = projectile.instantiate()
	var fireball_instance_d = projectile.instantiate()
	var fireball_instance_e = projectile.instantiate()
	
	if enemy_type == "Cremator" and GameState.target_player.current_zone == current_zone:
		anim_cremator_channel()
		speed = 0
		just_attacked = true
		match direction:
			"up":
				%HitboxUp.on_touch_effect = "None"
				anim_cremator_attack_up()
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_a)
				fireball_instance_a.position.y = (-projectile_offset*1)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_b)
				fireball_instance_b.position.y = (-projectile_offset*2)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_c)
				fireball_instance_c.position.y = (-projectile_offset*3)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_d)
				fireball_instance_d.position.y = (-projectile_offset*4)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_e)
				fireball_instance_e.position.y = (-projectile_offset*5)
			"down":
				%HitboxDown.on_touch_effect = "None"
				anim_cremator_attack_down()
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_a)
				fireball_instance_a.position.y = (projectile_offset*1)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_b)
				fireball_instance_b.position.y = (projectile_offset*2)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_c)
				fireball_instance_c.position.y = (projectile_offset*3)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_d)
				fireball_instance_d.position.y = (projectile_offset*4)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_e)
				fireball_instance_e.position.y = (projectile_offset*5)
			"left":
				%HitboxLeft.on_touch_effect = "None"
				anim_cremator_attack_left()
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_a)
				fireball_instance_a.position.x = (-projectile_offset*1)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_b)
				fireball_instance_b.position.x = (-projectile_offset*2)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_c)
				fireball_instance_c.position.x = (-projectile_offset*3)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_d)
				fireball_instance_d.position.x = (-projectile_offset*4)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_e)
				fireball_instance_e.position.x = (-projectile_offset*5)
			"right":
				%HitboxRight.on_touch_effect = "None"
				anim_cremator_attack_right()
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_a)
				fireball_instance_a.position.x = (projectile_offset*1)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_b)
				fireball_instance_b.position.x = (projectile_offset*2)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_c)
				fireball_instance_c.position.x = (projectile_offset*3)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_d)
				fireball_instance_d.position.x = (projectile_offset*4)
				await get_tree().create_timer(projectile_interval).timeout
				add_child(fireball_instance_e)
				fireball_instance_e.position.x = (projectile_offset*5)
		await get_tree().create_timer(fire_cooldown-(projectile_interval*5)).timeout
		if !dispelled:
			just_attacked = false
			speed = default_speed
			## Check in all directions for player collisions
			%HitboxUp.on_touch_effect = "Explosion"
			%HitboxUp.collision_reset()
			%HitboxRight.on_touch_effect = "Explosion"
			%HitboxRight.collision_reset()
			%HitboxDown.on_touch_effect = "Explosion"
			%HitboxDown.collision_reset()
			%HitboxLeft.on_touch_effect = "Explosion"
			%HitboxLeft.collision_reset()

#----------------------CHILLER------------------------------------#
func _invokeCloud(): 
	var cloud_instance = chiller_projectile.instantiate()
	if enemy_type == "Chiller" and !dispelled and GameState.target_player.current_zone == current_zone:
		if !just_attacked:
			if GameState.target_player.temperature != "cold":
				anim_chiller_cast()
				#freeze_triggered = true
				just_attacked = true
				await get_tree().create_timer(1).timeout
				add_child(cloud_instance)
				cloud_instance.destination = GameState.target_player.position-self.position
				##This is to make it look like it's coming out of her womb
				cloud_instance.position.y += 5
				await get_tree().create_timer(freeze_cooldown).timeout
				just_attacked = false
				effect_area.collision_reset()
			else: effect_area.collision_reset()

#--------------------ALL MOTEBEARER-TYPES------------------------#
func _reveal(): 
	if !dispelled and GameState.target_player.empowered:
			z_index = 1
			death_rattle.emit() ##still broken seemingly
			dispelled = true
			flash_component.is_flashable = true
			anim_motebearer_dispel()
			anim_mote_show()
			speed = 0 #keep from moving
			hit_area.canMelee = false
			if enemy_type == "Chiller" or enemy_type == "Douser":
					effect_area.disabled = true #disarm effect activation hitbox
			else:
				if GameState.shadeActive and enemy_type == "Shade":
					GameState.target_player.anim_lighten()
					GameState.shadeActive = false
					print("GameState: Shade disabled")
			hit_area.collision_reset()
	else:
		if !GameState.target_player.empowered:
			GameState.target_player.isHurt(1+GameState.newgame)

#--------------------MOTES----------------------------#
func mote_stunned():
	anim_mote_stun()
	await get_tree().create_timer(hit_area.hitstun).timeout
	mote_death()

##Only able to be damaged by flash + Only has 1 HP
func mote_death():
	if !destroyed:
		destroyed = true
		flash_component.is_flashable = false
		#print("Motebearer's Mote Destroyed")
		death_rattle.emit()
		match enemy_type:
			"Shade":
				GameState.target_player.anim_lighten()
				%DarknessParticles.emitting = false
				Sound.AmphoraDeath() #placeholder
			"Chiller":
				Sound.VesselBreak() #placeholder
			"Cremator":
				Sound.fire("small") #placeholder
			"Douser":
				Sound.vesselflower("death") #placeholder
		#Sound.deathGeneric() #placeholder
		anim_mote_hide()
		hit_area.disabled = true
		%DeathParticle.emitting = true
		GameState.mote_reward(GameState.reward_motebearer,mote_bonus_mult,"small")
		_cleanup()

func _cleanup():
	await get_tree().create_timer(fade_time).timeout
	queue_free()

##Experimental
func _exit_tree() -> void:
	if GameState.shadeActive:
		GameState.shadeActive = false
