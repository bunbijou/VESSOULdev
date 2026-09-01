class_name BossAbyssal extends Node2D

signal death_rattle
signal helper_start
signal helper_stop
signal boss_stun

@onready var anim : AnimationPlayer = %AbyssAnimPlayer
var current_zone : int = 4
var myCount : int = -1
var battleStart : bool = false
@export var hp : int = 5 #default: 5
var stunState : bool = false
#var abyssVesselVulnerable : bool = false
var tendrilLRDead : bool = false
var tendrilLRVulnerable : bool = false
var tendrilUDDead : bool = false
var tendrilUDVulnerable : bool = false
var desperation : bool = false
var dead : bool = false
var hitstun : float = 3

func anim_stun():
	%ParticleAbyss.emitting = true
	%AbyssalBody.play("stun",1,false)
	await get_tree().create_timer(3).timeout
	if !dead:
		%AbyssalBody.play("lookDn",1,false)

func anim_attack_():
	Sound.ThreeTendrilSwipe()

func anim_death():
	var fade_time : float = 5.0
	##Achievement: Defeat Abyssoul
	GameState.target_player.anim_achievement("a_abyssoul_defeat")
	GameState.target_player.play_anim("lighten")
	%AbyssAnimPlayer.play("defeat",1,0)
	GameState.target_player.waiting = true
	Sound.AbyssalCry()
	%AbyssalBody.play("stun",1)
	self.position = Vector2(8,72) 
	BgmController.stopAll()
	GameState.target_player.current_zone = -999
	GameState.target_player.temp_position = Vector2(0,0) #hardcoded middle of arena
	%MoteExplosion.emitting = true
	%DarknessExplosion.emitting = true
	await get_tree().create_timer(fade_time/2).timeout
	%DarknessParticles.emitting = false
	%MoteExplosion.emitting = false
	%DarknessExplosion.emitting = false
	%AbyssalBody.play("fade")
	%ParticleAbyss.emitting = true
	Sound.rock_break()
	Sound.AbyssalDeath()
	await get_tree().create_timer(fade_time/2).timeout
	GameState.target_player.waiting = false
	%AbyssAnimPlayer.play("defeat",0,1)
	%SwirlSprite.visible = false
	GameState.target_player.anim_enemy_slain()
	GameState.target_player.current_zone = 4 #arena zone
	GameState.mote_reward(GameState.reward_abyssoul,0,"big")

func _ready() -> void:
	if !GameState.EasyMode:
		#scales with ng+
		hp = hp+GameState.newgame
	else: hp = 5
	if GameState.abyssDict["abyssBoss"][0] == 1:
		death_rattle.emit() #for Tome pedestal / itemChest.tscn
		dead = true
		queue_free()
	GameState.target_player.flashed.connect(flashReceived) #we wanna check if boss can be damaged when player flashes

#Pre-battle phase
func _on_area_2d_body_entered(_body: Node2D) -> void:
	start_battle()

func start_battle():
	anim_stun()
	anim.current_animation = "intro"  # start battle, disable body hitbox
	Sound.AbyssalCry()
	GameState.anim_rumble(2,5)
	myCount += 1 #entering next phase
	BgmController.abyss_chasm_music.stop()
	await get_tree().create_timer(0.1).timeout
	BgmController.track_phantoms.play()

#End of pre-battle phase, triggered by the divider animplayer (i assume)
func vesselRecede():
	if !dead:
		anim.current_animation = "vesselRecede"
		myCount += 1
		%DividerAnimPlayer.current_animation = "long_tendril_attack_v"
		#This is the cue to begin the attack phase proper

#This is the abyssal's default while the tendrils are in their attack phase, reverts back to this phase after stun
func vesselOrbit():
	if !dead:
		anim.current_animation = "orbit"
		match myCount:
			2: myCount += 1

##Called by the flash signal from the player character
func flashReceived():
	if !dead and myCount != -1:
		helper_start.emit()
		boss_stun.emit()
		if tendrilLRVulnerable and !tendrilLRDead: #if LR tendrils vulnerable and flash recieved
			%TendrilAnimationPlayer.current_animation = "stunLR" #do directional stun anim
			await get_tree().create_timer(0.5).timeout #wait a tic
			%TendrilAnimationPlayer.current_animation = "RESET" #retract tendril
			Sound.AbyssalPain()
			hp -= %FlashComponent.flash_damage #Quick and dirty implementation
			tendrilLRDead = true #prevent tendril from being used further
			_enemyDamaged() #pass to damage handler e.g abyssal stun state
			#abyssVesselVulnerable = true #re: above
		if tendrilUDVulnerable and !tendrilUDDead: #if UP tendrils vulnerable and flash recieved
			%TendrilAnimationPlayer.current_animation = "stunUD" #do directional stun anim
			await get_tree().create_timer(0.5).timeout #wait a tic
			%TendrilAnimationPlayer.current_animation = "RESET" #retract tendril
			Sound.AbyssalPain()
			#print("Second set tendrils destroyed")
			hp -= 1
			tendrilUDDead = true #prevent tendril from being used further
			_enemyDamaged() #pass to damage handler e.g abyssal stun state
			#abyssVesselVulnerable = true #re: above


func _process(_float) -> void:
	if !dead:
		if hp < 1: #if my hp is below zero, kill me
				bossDeath()
		if tendrilLRDead and tendrilUDDead: 
			desperation = 1 #set attacks to desperate
			tendrilLRDead = false
			tendrilUDDead = false
			Sound.AbyssalCry()

##Is referenced
func _enemyDamaged():
	if !stunState and !dead: #if enemy hasn't just been damaged prior to this (prevents spam)
		stunState = true #enter the protective stun state
		anim.play("stun")
		anim_stun()
		await get_tree().create_timer(3).timeout
		stunState = false
		await get_tree().create_timer(1).timeout

#Tendril Up-Down attack
func ThreeTendrilSwipeUD(): #called by the divider animation event
	if !dead:
		if !tendrilUDDead and !stunState and !desperation: #if top/bottom tendrils not destroyed and not in hitstun
			%TendrilAnimationPlayer.current_animation = "attackUD" #attack #attack
			tendrilUDVulnerable = true #indicate damage-able state
			await get_tree().create_timer(3.5).timeout
			%TendrilAnimationPlayer.current_animation = "RESET"
			tendrilUDVulnerable = false
		else: Sound.AbyssalCry()
		
		#desperation attacks
		if !tendrilUDDead and !tendrilLRDead and !stunState and desperation:
			%TendrilAnimationPlayer.current_animation = "attackUD" #attack
			tendrilUDVulnerable = true
			await get_tree().create_timer(3.5).timeout
			tendrilUDVulnerable = false
			%TendrilAnimationPlayer.current_animation = "attackLR" #attack
			tendrilLRVulnerable = true
			await get_tree().create_timer(3.5).timeout
			tendrilLRVulnerable = false
		else: Sound.AbyssalCry()
		
		if tendrilUDDead and !tendrilLRDead and !stunState and desperation:
			%TendrilAnimationPlayer.current_animation = "attackLR"
			tendrilLRVulnerable = true
			await get_tree().create_timer(1.5).timeout
			%TendrilAnimationPlayer.current_animation = "attackLR"
			await get_tree().create_timer(1.5).timeout
			%TendrilAnimationPlayer.current_animation = "attackLR"
			await get_tree().create_timer(1.5).timeout
			%TendrilAnimationPlayer.current_animation = "attackLR"
			tendrilLRVulnerable = false
		else: Sound.AbyssalCry()


#Tendril LR attack
func ThreeTendrilSwipeLR(): #called by the divider animation event
	if !dead:
		if !tendrilLRDead and !stunState and !desperation: #if tendrils not destroyed and not in hitstun
			%TendrilAnimationPlayer.current_animation = "attackLR" #attack
			tendrilLRVulnerable = true
			await get_tree().create_timer(3.5).timeout
			%TendrilAnimationPlayer.current_animation = "RESET"
			tendrilLRVulnerable = false
		else: Sound.AbyssalCry()
		
			#desperation attacks
		if !tendrilLRDead and !tendrilUDDead and !stunState and desperation:
			%TendrilAnimationPlayer.current_animation = "attackLR" #attack
			tendrilLRVulnerable = true
			await get_tree().create_timer(3.5).timeout
			tendrilLRVulnerable = false
			%TendrilAnimationPlayer.current_animation = "attackUD" #attack
			tendrilUDVulnerable = true
			await get_tree().create_timer(3.5).timeout
			tendrilUDVulnerable = false
		else: Sound.AbyssalCry()
		
		if tendrilLRDead and !tendrilUDDead and !stunState and desperation:
			%TendrilAnimationPlayer.current_animation = "attackUD"
			tendrilUDVulnerable = true
			await get_tree().create_timer(1.5).timeout
			%TendrilAnimationPlayer.current_animation = "attackUD"
			await get_tree().create_timer(1.5).timeout
			%TendrilAnimationPlayer.current_animation = "attackUD"
			await get_tree().create_timer(1.5).timeout
			tendrilUDVulnerable = false
		else: Sound.AbyssalCry()

func bossDeath():
	if !dead:
		helper_stop.emit()
		dead = true
		%TendrilAnimationPlayer.play("RESET")
		%DividerAnimPlayer.play("RESET")
		myCount = 999
		print ("Abyssal was defeated")
		anim_death()
		GameState.addKillCount()
		death_rattle.emit() #for Tome pedestal / itemChest.tscn
		%WoodsWarp.visible = true
		%WoodsWarp.call_deferred("false")
		await get_tree().create_timer(5).timeout
		GameState.abyssDict["abyssBoss"][0] = 1 
		await get_tree().create_timer(30).timeout
		queue_free() #banish self to shadow realm
