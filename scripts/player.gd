##Player ver. Jan 2026
class_name PlayerVessel extends CharacterBody2D

signal flashed
signal flash_weak
signal has_flash ##Endless Mode only
signal player_resurrect
#signal endless_reposition
signal player_death
signal fatal_damage
signal item_get
signal state_revert
signal humanity_gained
#signal coop_start

## Could be replaced with await potentially
#@onready var hunger_timer : Timer = %hunger_timer
## Purely visual indicator that shows the active amount of souls for use
@onready var soul_label : Label = %soulLabel
## Purely visual indicator that pops up when player gains HP / Takes damage
@onready var health_label : Label =  %HPlabel #debug
## Controls hitboxes, sprites, etc.
@onready var anim : AnimationPlayer = %AnimationPlayer
## Purely visual effect to indicate when the player flashes
@onready var flash_sprite : TextureRect = %FlashTexture2D
## Purely visual effect to indicate when flash is ready to use
@onready var flash_ready_sprite : AnimatedSprite2D = %flashReadySprite

##Enemies and objects will reference this to determine their active state
@export var current_zone : int = 999
var respawn_time : float = 5
var hit_stun : float = .85
var temperature: String = "standard"
var burning_speed_modifier : float = 1.33
@export var position_override : bool = false
@export var demo : bool = false
@export var endless : bool = false

var empowered : bool = false
##keeps player from getting damaged repeatedly
var invincibility : bool = false 
##keeps player from switching into the dead state repeatedly
var dead : bool = false 
##keeps unnerve anim from interrupting fall animation
var fallen : bool =  false 
##signals to other things that flash is ready e.g. flash ready sprite
var flash_ready : bool = false
## when greater than 1, reduces speed
var mice_count : int 
##temporary speed for physics calculation, is determined by global player stats in the ready event
var speed : float
## For boss death cam; allows enemies to pass their position to the player,
# then in turn, to the camera controller in the scene
var temp_position : Vector2
var fragile : bool = false #Endless Mode Only
##For mashing out of frozen state
#var mash_count : int = 0
##If the player is waiting for a cutscene to finish, prevent moving while in this state
var waiting : bool = false


##------------------------ANIMATIONS------------------##

##When we get a new item, show the item overhead
func displayItem(frame):
	item_get.emit()
	%aSpriteItemDisplay.visible = true
	%aSpriteItemDisplay.frame = frame
	await get_tree().create_timer(2.5).timeout
	%aSpriteItemDisplay.visible = false

func play_anim(animation : String):
	match animation:
		"hud_show_sidebar": item_get.emit() #show the sidebar
		"reset":
			if !dead:
				if mice_count < 1:
					if empowered:
						anim.play("idleBoosted")
					else:
						anim.play("idleBase")
				else: anim_unnerve()
		"respawn":
			if GameState.respawning:
				Sound.respawn()
				anim.play("respawn")
				await get_tree().create_timer(1).timeout
				anim_reset()
				GameState.respawning = false
			else: anim_reset()
		"boost":
			if mice_count < 1:
				anim.play("idleBoosted")
				Sound.PlayerEmpowered()
			else: anim_unnerve()
		"unnerve": anim.play("unnerve")
		"burning":
			Sound.fire("small")
			Sound.fire_crackle_loop("start")
			anim.play("burning")
		"stun":
			if !dead:
				Sound.PlayerDamaged()
				if temperature != "hot" and temperature != "cold":
					anim.play("Stun")
					await get_tree().create_timer(.25).timeout #give player time to move away
					if empowered:
							anim_boost()
					else: anim_reset()
				if temperature == "cold":
					anim_freeze()
				if temperature == "hot":
					anim_burning()
		"fallout":
			Sound.fallOut()
			self.z_index = 999
			anim.play("fallOut")
			await get_tree().create_timer(2).timeout
			if fallen:
				BgmController.stopAll()
				Sound.VesselBreak()
		"death":
			if anim.current_animation != "Death":
				BgmController.stopAll()
				%vesselSprite.play("death") #workaround
				anim.play("Death")
				Sound.VesselBreak()
				Sound.PlayerFlash()
				flash_ready_sprite.visible = false
		"freeze": 
			Sound.freeze()
			anim.play("freeze")
			%SteamParticle.emitting = true
			%iceSprite.visible = true
			%iceSprite.play("default",1)
		"ice_break": 
			Sound.glass_break()
			%iceSprite.play("break",1)
			await get_tree().create_timer(1).timeout #give player time to move away
			%iceSprite.visible = false
		"flash": 
			Sound.PlayerFlash()
			%FlashParticle.emitting = true
			%FlashAnim.play("flash")
			await get_tree().create_timer(.15).timeout
			%FlashAnim.play("RESET")
		"darken": %DarkMask.visible = true
		"lighten": 
			Sound.PlayerExtinguished() #placeholder
			%DarkMask.visible = false
		"banner_humanity": humanity_gained.emit(Localize.humanity_message)
		"banner_enemy_defeat": humanity_gained.emit(Localize.slain_message)
		"banner_impostor_defeat": humanity_gained.emit(Localize.impostor_message)
		"heal": 
			Sound.PlayerHeal()
			%HealFX.emitting = true
		"enchant": 
			%EnchantCircle.visible = true
			await get_tree().create_timer(3).timeout
			%EnchantCircle.visible = false
		"sparkle":
			%UpgradeSparkle.visible = true
			await get_tree().create_timer(3).timeout
			%UpgradeSparkle.visible = false
		"key": 
			if GameState.woodsDict["woodsKey"] == 1: #if we have key
				%aSpriteKeyDisplay.visible = true
			else: %aSpriteKeyDisplay.visible = false #if we either don't have it or already used it
		"mote_gain_small":
			%AbsorbSmall.play("default")
			await get_tree().create_timer(0.5).timeout
			Sound.MoteCollect()
		"mote_gain_big": 
			var absorb_time : float = 3
			%MoteAbsorb.emitting = true
			await get_tree().create_timer(0.5).timeout
			Sound.MoteAbsorb()
			await get_tree().create_timer(absorb_time).timeout
			%MoteAbsorb.emitting = false
		"samael_emerge": 
			%SamaelSpriteNG.visible = true
			%SamaelAnimPlayer.play("emerge")
			await get_tree().create_timer(1).timeout
			%SamaelAnimPlayer.play("idle")
		"samael_hide": 
			%SamaelAnimPlayer.play("hide")
			await get_tree().create_timer(1).timeout
			%SamaelSpriteNG.visible = false
		"samael_parry": 
			%ParryShield.visible = true
			%ParryShield.play("default")
			Sound.samael("parry")
		"efficiency_flame": 
			if empowered:
				if !%PowerFlame.emitting:
					%PowerFlame.emitting = true
			else: %PowerFlame.emitting = false
		"fire_deflect":
			Sound.fire("small") #placeholder
			%ChimeraFlameFire.emitting = true
		"ice_deflect":
			Sound.fire("small") #placeholder
			%ChimeraFlameIce.emitting = true
		"void":
			Sound.PlayerExtinguished()
			%VoidParticle.emitting = true

func anim_darkness_advanced(toggle : bool):
	%DarkAdvanced.visible = toggle

func anim_hurt_indicator(quantity : int):
	%HurtParticle.amount = quantity
	%HurtParticle.emitting = true

##Legacy Functions (These are referenced by other scripts, I know it's messy, maybe we cleanup the code at some point)
func show_sidebar(): play_anim("hud_show_sidebar")

func anim_reset(): play_anim("reset")

func anim_respawn(): play_anim("respawn")

func anim_boost(): play_anim("boost")

func anim_unnerve(): play_anim("unnerve")

func anim_burning(): play_anim("burning")

func anim_stun(): play_anim("stun")

func anim_falling(): play_anim("fallout")

func anim_death(): play_anim("death")

func anim_freeze(): play_anim("freeze")

func anim_ice_break(): play_anim("ice_break")

func anim_flash_fill(): play_anim("flash")

func anim_darken(): play_anim("darken")

func anim_lighten(): play_anim("lighten")

func anim_humanity_gained(): play_anim("banner_humanity")

func anim_enemy_slain(): play_anim("banner_enemy_defeat")

func anim_impostor_slain(): play_anim("banner_impostor_defeat")

func anim_heal(): play_anim("heal")

func anim_enchant(): play_anim("enchant")

func anim_sparkle(): play_anim("sparkle")

func anim_key(): play_anim("key")

func anim_mote_absorb(): play_anim("mote_gain_big")

func anim_mote_absorb_small(): play_anim("mote_gain_small")

func anim_samael_emerge(): play_anim("samael_emerge")

func anim_samael_hide(): play_anim("samael_hide")

func anim_parry(): play_anim("samael_parry")

func anim_endless(type : String):
	match type:
		"fire_deflect":
			play_anim("fire_deflect")
		"ice_deflect":
			play_anim("ice_deflect")
		"void":
			play_anim("void")

func anim_power_flame():
	play_anim("efficiency_flame")
##-------------FUNCTIONS --------------#

func _ready() -> void: #only do this once
	var active_scene = get_tree().get_current_scene().get_name()
	if !position_override and active_scene != "endless":
		#Reposition the player character according to what's in the loaded save data
		self.position = GameState.playerCurrentLocation
	anim_respawn()
	GameState.target_player = self
	GameState.playerDisplayItem.connect(displayItem)
	GameState.playerHeal.connect(isHealed) 
	##Ensure game isn't currently paused
	get_tree().paused = false
	LevelTransition.fadeFromBlack()
	await get_tree().create_timer(0.1).timeout
	## Preserve player HP between scenes
	if GameState.player_hp_previous <= 0: GameState.playerHP = GameState.playerBaseHP
	else: GameState.playerHP = GameState.player_hp_previous
	##Update player position
	await get_tree().create_timer(0.1).timeout
	GameState.playerCurrentLocation = self.position
	if demo:
		GameState.playerCapacityAdd = 2
		GameState.playerHP = 3
	GameState.stat_update()

func _physics_process(_delta: float) -> void:
	## Define variable values based on system input 
	var directionx := (Input.get_axis("ui_left", "ui_right"))
	var directiony := (Input.get_axis("ui_up", "ui_down"))
	
	## Modifying speed value based on state e.g mice, freezing, death, waiting
	if !dead and temperature != "cold" and !waiting: 
		if temperature == "hot":
			speed = GameState.playerBaseSpd * burning_speed_modifier
		else: ## being hot will remove the mouse debuff, so they're mutually exclusive
			if mice_count < 1:
				speed = GameState.playerBaseSpd
			else:
				speed = (GameState.playerBaseSpd/(0.85*mice_count)) #was 0.75
	else:
		speed = 0
		velocity.x = 0
		velocity.y = 0
		%hunger_timer.stop()

	## Quick maths
	if directionx:
		velocity.x = directionx * speed
	else: velocity.x = 0 #when not inputting, you stop moving
	
	if directiony:
		velocity.y = directiony * speed
	else: velocity.y = 0 #ditto
	move_and_slide()

func _process(_delta: float) -> void: #every frame
	anim_key()
	if GameState.playerEfficiency > 3:
		anim_power_flame()
	
	## Local Co-op
	if Input.is_action_just_pressed("ui_accept_2") and !GameState.coop:
		BgmController.success_jingle.play()
		print("Co-op enabled")
		player_2_start()
	
	##Debug
	#%DebugPositionLabel.text = str(self.position)
	##Mashing out of frozen state (Not working)
	#if temperature == "cold":
		#var requirement : String
		#if Input.is_action_just_pressed("ui_left") and requirement != "ui_right":
			#mash_count += 1
			#self.position = self.position+(Vector2(-1,0))
			#requirement = "ui_right"
		#if Input.is_action_just_pressed("ui_right") and requirement == "ui_right":
			#mash_count += 1
			#self.position = self.position+(Vector2(1,0))
			#requirement = "ui_left"
		#if mash_count == 10:
			#neutralize_status()
			#mash_count = 0
	
	##Unnerve State
	if mice_count >= 1 and !dead and !fallen: #can be overwritten by other states
		anim_unnerve()
	
	## Flash failure
	if GameState.playerActiveSouls <= GameState.playerFlashMin and !dead and GameState.abyssDict["abyssGlaze"] >= 1:
		if Input.is_action_just_pressed("ui_select"):
			Sound.FlashFail()
			%flashFailSprite.play("default")
	
	##Empowered State
	if empowered:
		if !invincibility: #wait until i-frames run out to revert state
				if GameState.playerActiveSouls <= GameState.playerExhaustPoint: #if player's soul meter reaches exhaustion threshold,
					empowered = false
					state_revert.emit()
					flash_ready_sprite.visible = false
					anim_reset()
					Sound.PlayerExtinguished()
					flash_ready_sprite.visible = false 
					%hunger_timer.stop() 
					speed = GameState.playerBaseSpd
		## Flash Ready State
		if GameState.playerActiveSouls >= GameState.playerFlashMin and !dead and GameState.abyssDict["abyssGlaze"] >= 1:
			has_flash.emit()
			flash_ready = true 
			flash_ready_sprite.visible = true 
			if temperature != "cold" and flash_ready: #if game not paused and not frozen
				if Input.is_action_just_pressed("ui_select"): #formerly ui_accept
					flash()
					if GameState.playerActiveSouls > GameState.playerBoostMin:
						anim_boost()
					else: anim_reset()
		else: flash_ready_sprite.visible = false
	else: ##Base State
		if GameState.playerActiveSouls >= GameState.playerBoostMin and !invincibility and !dead: #check if not powered and has souls greater than minimum to enter state
			empowered = true
			anim_boost()
			speed = GameState.playerBuffedSpd 
			%hunger_timer.start()

func player_2_start():
	if !GameState.coop:
		GameState.coop_start()
		%SlotLabel.visible = true
		await get_tree().create_timer(3).timeout
		%SlotLabel.visible = false

##When empowered, tick down soul meter (see above)
func _on_hunger_timer_timeout() -> void: 
	GameState.playerActiveSouls -= GameState.playerMoteDecay

## Dousing
func is_doused():
		if GameState.abyssDict["abyssLid"] != 2: #Endless Mode Only
			if empowered:
				empowered = false
				%hunger_timer.stop()
				state_revert.emit()
			GameState.playerActiveSouls = 0
			Sound.PlayerExtinguished()
			anim_reset()

## Falling (Only used by Sinkhole at this point)
func is_fallen(): #pretty much copies below
		self.z_index = 999
		anim_falling()
		fallen = true
		dead = true
		player_resurrect.emit()
		await get_tree().create_timer(.2).timeout #wait for resurrect (Endless mode only)
		if dead:
			await get_tree().create_timer(2).timeout
			Sound.bell()
			player_death.emit(Localize.death_message) 
			LevelTransition.fadeToBlack()
			await get_tree().create_timer(respawn_time-1).timeout
			GameState.respawning = true
			GameState.playerLifetimeSouls = 0
			##Soul Preservation on Death with Lid of Sealing
			if GameState.abyssDict["abyssLid"] != 0:
				print("Motes preserved (Pot Lid)")
				GameState.playerActiveSouls = GameState.playerActiveSouls*GameState.playerMotesPreserved
			else:
				print("Player souls lost")
				GameState.playerActiveSouls = 0
			@warning_ignore("narrowing_conversion")
			GameState.player_hp_previous = GameState.playerBaseHP
			get_tree().reload_current_scene() 
		else: 
			play_anim("reset")

## Death (also referred to as Shattering)
func is_dead():
	player_resurrect.emit()
	await get_tree().create_timer(.1).timeout #wait for resurrect (Endless mode only)
	if GameState.playerHP <= 0:
		dead = true
		player_death.emit(Localize.death_message)
		anim_death()
		await get_tree().create_timer(1).timeout
		LevelTransition.fadeToBlack()
		await get_tree().create_timer(respawn_time-1).timeout
		GameState.respawning = true
		GameState.playerLifetimeSouls = 0
		##Soul Preservation on Death with Lid of Sealing
		if GameState.abyssDict["abyssLid"] != 0:
			print("Motes preserved (Pot Lid)")
			GameState.playerActiveSouls = GameState.playerActiveSouls*GameState.playerMotesPreserved
		else:
			print("Player souls lost")
			GameState.playerActiveSouls = 0
		@warning_ignore("narrowing_conversion")
		GameState.player_hp_previous = GameState.playerBaseHP
		get_tree().reload_current_scene() 
	else: 
		print("Player death deferred (Jove's boon)")

##Flash
func flash(): 
	var mice_count_prev : int = 0
	if flash_ready and !dead:
		if mice_count > 0:
			mice_count_prev = mice_count
			GameState.playerKillCount += mice_count
			GameState.mote_reward(GameState.reward_motemouse*mice_count_prev,0,"sound_only")
			Sound.motemouse("death")
			mice_count = 0
			anim_reset()
		anim_flash_fill()
		flashed.emit()
		await get_tree().create_timer(.05).timeout
		GameState.playerActiveSouls -= (GameState.playerFlashMin)
		invincibility = false
		flash_ready = false
		flash_ready_sprite.visible = false

##Weak Flash (Endless Mode Only)
func force_flash():
	if !dead:
		if mice_count > 0:
			GameState.playerKillCount += mice_count
			Sound.motemouse("death")
			mice_count = 0
			anim_reset()
		anim_flash_fill()
		flash_weak.emit()
		await get_tree().create_timer(.05).timeout

## Healing (E.g. by Big Motes)
func isHealed(value):
	if !dead:
		#if GameState.playerHP < GameState.playerBaseHP: #if my HP is less than my max
		anim_heal()
		print("Healed player for "+str(value)+" HP")

## Pain State
func isHurt(value : int):
	if !dead and !waiting:
		anim_hurt_indicator(value)
		if GameState.playerHP > 0 and !invincibility: #if HP is not 1, and player is not invulnerable
			print("Player took "+str(value)+" damage")
			GameState.playerHP -= value #if enemies should ever need to do more than one damage, you should change this 
			if GameState.playerHP < 1: #and !invincibility: #if it's a fatal blow and i'm not invulnerable, and i haven't died
				is_dead() #call death fucntion
				fatal_damage.emit()
			else:
				if fragile:
					anim_endless("void")
					GameState.playerActiveSouls = 0
					empowered = 0
					print("Empowered state removed by the Void's curse")
				invincibility = true 
				anim_stun()
				await get_tree().create_timer(hit_stun).timeout #give player time to move away
				invincibility = false #disable invuln frames
	else: print("Player damage deferred")

## Frozen State
func is_frozen():
	if GameState.npcDict["zn"] != 999: #Endless Mode Only
		if !dead:
			if temperature != "hot":
				if temperature != "cold":
					temperature = "cold"
					%hunger_timer.stop()
					anim_freeze()
					if GameState.playerBaseHP > 1:
						GameState.playerHP = 1
					#if empowered:
					%StatusTimer.wait_time = 3
					#else: 
					#	%StatusTimer.wait_time = 3.5 #tie into intensity value?
					%StatusTimer.start()
			else: 
				print("Burning state was removed by Freezer spell")
				neutralize_status()
	else: 
		print("Freezer spell repelled by Chimera Scale")
		anim_endless("ice_deflect")

## Burning State
func is_burning():
	if GameState.npcDict["zn"] != 999: #Endless Mode Only
		if !dead:
			if temperature != "cold":
				temperature = "hot"
				Sound.fire_crackle_loop("start")
				if mice_count > 0:
					GameState.playerKillCount += mice_count
					print("Vaporized "+str(mice_count)+" mice")
					mice_count = 0
					%hunger_timer.wait_time = 0.35
				if empowered:
					%StatusTimer.wait_time = 5
				else: %StatusTimer.wait_time = 3 #tie into intensity value?
				%StatusTimer.start()
			else: 
				print("Freezing state was removed by fire")
				neutralize_status()
	else: 
		print("Fire deflected by Chimera Scale")
		anim_endless("fire_deflect")

##Used when clearing temperature state e.g. Freeze or Burn
func _on_thaw_timer_timeout() -> void:
	neutralize_status()

## Ditto
func neutralize_status():
	if !dead and temperature != "standard":
		state_revert.emit()
		match temperature:
			"cold":
				anim_ice_break()
			"hot":
				Sound.fire_crackle_loop("stop")
				Sound.PlayerExtinguished()
		%StatusTimer.stop()
		anim_reset()
		temperature = "standard"

## Called by the GUI node when unpausing
func hunger_restart():
	%hunger_timer.start()
