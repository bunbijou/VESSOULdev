class_name BossImpostor extends CharacterBody2D

signal mote_conversion
signal mad_mote_missle
signal boss_damaged
signal death_rattle

@export var projectile : CharacterBody2D
var motes_active : int = 0
var motes_lifetime : int = 0
var charge_value : int = 8 #how many motes it takes for a full charge
var active : bool = false
var spd : float = 0
var hitstun : float = .35
var count : int = 0
var enraged : int = 0

## Animations / Music
func bgm_battle():
	BgmController.stopAll()
	BgmController.track_incantation.play()

func anim_warcry():
	Sound.ebon("fire")
	%SpriteBase.visible = true
	%SpriteEmpowered.visible = false
	#Sound.AbyssalCry()

func anim_shriek():
	Sound.ebon("pain")

func anim_active():
	%SpriteBase.play("bite")

func anim_charge():
	%SpriteBase.visible = false
	%SpriteEmpowered.visible = true
	%SpriteEmpowered.play("charge")
	Sound.ebon("charge")
	Sound.PlayerEmpowered()
	Sound.whoosh()
	await get_tree().create_timer(1).timeout
	mad_mote_missle.emit() #we want this in time with the animation
	%SpriteEmpowered.play("powerdown")
	await get_tree().create_timer(1).timeout
	%SpriteEmpowered.visible = false
	%SpriteBase.visible = true
	%SpriteBase.play("default")

func anim_parry():
	Sound.ebon("fire")
	%SpriteEmpowered.visible = true
	%SpriteEmpowered.play("parry")
	await get_tree().create_timer(.5).timeout
	%SpriteEmpowered.visible = false
	%SpriteBase.visible = true
	%SpriteBase.play("default")

func anim_stun():
	Sound.ebon("pain")
	%SpriteEmpowered.visible = false
	%SpriteBase.visible = true
	%SpriteBase.play("stun")

func anim_victory(input : String):
	print("Player died: "+input)
	Sound.ebon("laugh")

func anim_death():
	##Achievement: Defeat Ebon Vessel
	SteamHandler.achievement_get("a_ebon_vessel_defeat")
	%Music.stop()
	%SpriteBase.flip_v = false
	GameState.target_player.current_zone = -199
	Sound.AbyssalPain()
	%SpriteEmpowered.visible = false
	%SpriteBase.visible = true
	%SpriteBase.play("stun")
	await get_tree().create_timer(3).timeout
	Sound.ebon("pain")
	%SpriteBase.visible = false
	%DarknessExplosion.emitting = true
	await get_tree().create_timer(1.5).timeout
	%DarknessExplosion.emitting = false
	GameState.target_player.anim_impostor_slain()
	GameState.target_player.anim_lighten()
	GameState.target_player.current_zone = 999

###Gameplay
##Connect
func _ready() -> void:
	GameState.target_player.player_death.connect(anim_victory)
	projectile.defuse.connect(detonation)
	%FinalBattle.battle_end.connect(defeat)

##Battle Start
func start():
	%FinalBattle.phase = "start"
	bgm_battle()
	#Modify camera position
	GameState.target_player.current_zone = -199
	anim_warcry()
	await get_tree().create_timer(3).timeout
	Sound.warble()
	#ditto
	GameState.target_player.current_zone = -200
	anim_warcry()
	%DarkFlash.emitting = true
	GameState.target_player.anim_darken()
	await get_tree().create_timer(.5).timeout
	mote_conversion.emit()
	%DarkFlash.emitting = false
	await get_tree().create_timer(1).timeout
	GameState.target_player.current_zone = -201
	active = true #start motion
	anim_active()
	GameState.target_player.waiting = false

func missle_launch():
	motes_active = 0 #reset count
	active = false
	anim_charge()

func detonation():
	if projectile.reverse:
		print("Ebon took damage")
	else: 
		anim_victory("defeat")
		await get_tree().create_timer(hitstun).timeout
		if !GameState.target_player.dead:
			active = true

func hurt():
	anim_stun()
	boss_damaged.emit()
	await get_tree().create_timer(hitstun).timeout
	anim_active()
	active = true

## Mote Conversion Behavior / Mote Missle Launch
func _process(_delta: float) -> void:
	if motes_active == charge_value and enraged == 0:
		missle_launch()
	
	if enraged == -1:
		anim_warcry()
		anim_active()
		enraged = 2 #rage already active
		self.scale = Vector2(1.5,1.5)

## Movement
func _physics_process(_delta: float) -> void:
	var directionx : float
	var directiony : float
	var target : Vector2
	
	match count:
		0:
			target = %Path0.position
		1:
			target = %Path1.position
		2:
			target = %Path2.position
		3:
			target = %Path3.position
		4:
			target = %Path4.position
		5:
			target = %Path5.position
		6:
			target = %Path6.position
		7:
			target = %Path7.position
		8:
			target = %Path8.position
		9:
			target = %Path9.position
		10:
			target = %Path10.position
		11:
			target = %Path11.position
		12:
			target = %Path12.position
		13:
			target = %Path13.position
		14:
			target = %Path14.position
		15:
			target = %Path15.position
		16:
			target = GameState.target_player.position
			if enraged == 0: #if rage not active
				anim_shriek()
				print("Boss entered rage state")
				enraged = 1
		#17:
			#target = %Path17.position
		#18:
			#

	if active:
		self.look_at(target)
	else: self.rotation = 0

	if active and !get_tree().paused:
		if self.position.y < target.y: #if destination is below us
			directiony = 1 #move down
		else:
			if self.position.y >= target.y: #if destination is above us
				directiony = -1
			if self.position.x < target.x: #if destination is to the right
				%SpriteBase.flip_v = true
				directionx = 1 #move right
			else: 
				%SpriteBase.flip_v = false
				directionx = -1 #move left
		
		if directionx:
			velocity.x = directionx * spd
		else: velocity.x = 0 #when not inputting, you stop moving
	
		if directiony:
			velocity.y = directiony * spd
		else: velocity.y = 0 #ditto
		move_and_slide()

## For ebon vessel phase 2 "enraged" state
func on_player_bite(_body: PlayerVessel) -> void:
	if enraged:
		GameState.playerActiveSouls -= GameState.playerFlashMin

func defeat():
	if active:
		%HazardHitbox.on_touch_effect = "None"
		anim_death()
		await get_tree().create_timer(1.66).timeout
		death_rattle.emit()
		active = false
