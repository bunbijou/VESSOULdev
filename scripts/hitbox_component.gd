class_name HitboxComponent extends Area2D

signal painState
signal death_rattle #All enemies that derive enemy.gd
signal shroudBroken #All mote-bearer type enemies
signal douseTarget #Douser
signal attackSpent #Douser
signal explosionSpell #Cremator
signal cloudSpell #Chiller
signal selfDestruct #Ossuary
signal enemy_alert #ditto
signal player_reposition #Sinkhole
signal attack_success

@export_enum("Common","Miniboss","Boss") var enemy_class : String
@export_enum("None", "Standard", "Hazard", "Freezing", "Burning", "Dousing", "Explosion","Cloud","SelfDestruct","Alert","FallOut","Instakill","AdvancedDarkness") var on_touch_effect: String #make into strings?
@export var hp : int = 1
var easy_hp : int = 1
var easy_miniboss_hp : int = 3
var easy_boss_hp : int = 5
@export var health_label : Label
@export var hitstun : float = 0.35
@export var canMelee : bool = false
@export var moteBearer : bool = false
var deathDelay : float = 0.35 #for death timer, see below
var initialeffect : String = "Standard"
var disabled : bool = false
var stunned : bool = false
var initial_health : int
var dead : bool = false
#@export var fireChildren = [0]  #Cremator
##Indicates we don't want this health component to scale with NG e.g. with Gazer
@export_category("Disable/Enable HP scaling with NG+")
@export var do_not_scale_with_ng : bool = false
@export_category("Disable/Enable Attack Damage scaling with NG+")
@export var scale_damage_with_ng : bool = true
var initial_hitstun : float = 0 #endless mode only, see below
var advanced_darkness_duration : float = 3.0

func _ready() -> void:
	initial_hitstun = hitstun
	if GameState.EasyMode:
		match enemy_class:
			"Common":
				hp = easy_hp
			"Miniboss":
				hp = easy_miniboss_hp
			"Boss":
				hp = easy_boss_hp
	else:
		if !do_not_scale_with_ng: #scale hp for NG+
			hp = hp+(1*GameState.newgame)
	
	##999 is an important value and we dont want it to change
	if hp == 999:
		do_not_scale_with_ng = true 
	initialeffect = on_touch_effect
	initial_health = hp
	#GameState.shadeActive = false #????

func _process(_delta: float) -> void:
	###Health Label, currently not used
	#if hp != 999: #if hp not infinite
		#if hp == initial_health:
			#health_label.text = ""
		#else: 
			##visual indicator that NG+ is active
			#if GameState.newgame != 0:
				#health_label.text = str(hp)+"/"+str(initial_health)+"*"
			#else: health_label.text = str(hp)+"/"+str(initial_health)
		#if hp <= 0:
			#health_label.text = "K.O."
	
	## Mars boon (endless mode)
	if GameState.playerHitstunAdd:
		hitstun = initial_hitstun*2 #experimental
	
	##hacky solution to allow state to be updated whilst still in contact with player
	if on_touch_effect != initialeffect: #if hit state changed
		collision_reset()
		initialeffect = on_touch_effect #stop this from happening until next state change
	
	if disabled:
		self.monitoring = false
	else: self.monitoring = true
	
	if hp <= 0 and !stunned and !dead:
		_death()

##Formerly, this had entities pass in the hitstun value
# That fact may be causing issues
func _on_player_touch(_body : CharacterBody2D) -> void:
	match on_touch_effect:
		"None": 
			pass
		"Standard":
			if GameState.target_player.empowered:
				_meleeDamaged()
			else: 
				#If player isn't in simple mode and the hitbox is allowed to scale damage with NG, add damage
				if !GameState.EasyMode and scale_damage_with_ng:
						GameState.target_player.isHurt(1+(1*GameState.newgame))
				else: GameState.target_player.isHurt(1)
				attack_success.emit()
		"Hazard":
			if !GameState.EasyMode and scale_damage_with_ng:
				GameState.target_player.isHurt(1+(1*GameState.newgame))
			else: GameState.target_player.isHurt(1)
			attack_success.emit()
		"Freezing": #Chiller
			if GameState.target_player.temperature != "cold":
				GameState.target_player.is_frozen()
				attack_success.emit()
		"Burning":
			GameState.target_player.is_burning()
			if !GameState.EasyMode and scale_damage_with_ng:
				GameState.target_player.isHurt(1+(1*GameState.newgame))
			else: GameState.target_player.isHurt(1)
			attack_success.emit()
		"Dousing": ##Douser
				douseTarget.emit() #For Motebearer-Douser
				Sound.splash() #water splash sound
				attackSpent.emit()
		"Explosion": ##Cremator 
			explosionSpell.emit()
		"Cloud": ##Chiller
			cloudSpell.emit()
		"SelfDestruct": ##Ossuary
			selfDestruct.emit()
			attack_success.emit()
		"Alert": ##Potheads, Ossuaries, Burnout
			enemy_alert.emit()
		"FallOut": ##Sinkhole
			player_reposition.emit()
			GameState.target_player.is_fallen()
			attack_success.emit()
		"Instakill": ##Used by Maze Rulers
			GameState.target_player.isHurt(GameState.playerHP)
		"AdvancedDarkness":
			##This used to be an effect where it'd put the lurker darkness on the player
			##for a short time, it was too OP tho
			##Now it just reduces the player's soul meter / flash count
			Sound.LurkerGiggle()
			GameState.target_player.isHurt(1+(1*GameState.newgame))
			GameState.target_player.play_anim("void")
			if GameState.abyssDict["abyssGlaze"] != 0:
				if GameState.playerActiveSouls > GameState.playerFlashMin:
					GameState.playerActiveSouls =- GameState.playerFlashMin
				else: GameState.playerActiveSouls = 0
			else: GameState.playerActiveSouls = int(GameState.playerActiveSouls/2)

func collision_reset():
	self.set_deferred("monitoring", true) #turn it off and on again
	self.set_deferred("monitoring", false)

func _meleeDamaged():
	if !stunned and canMelee:
		if !moteBearer:
			stunned = true
			hp -= 1+GameState.playerDamageMod
			painState.emit() #pass to parent
			await get_tree().create_timer(hitstun).timeout 
			stunned = false
		else: ##Motebearer-type enemies
			shroudBroken.emit()

func _death():
		dead = true
		death_rattle.emit() #pass to parent
