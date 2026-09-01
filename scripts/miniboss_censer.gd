class_name MiniBossCenser extends Node2D

signal death_rattle
signal fatal_damage
signal cast_1
signal cast_2
signal cast_3
signal cast_4

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@onready var anim : AnimationPlayer = %MinibossAnimPlayer
@export var my_sprite : AnimatedSprite2D
@export var current_zone : int = 0
@export var hit_area : HitboxComponent
@export var battleReward : Node2D
@export_enum("wait","start","loop","defeat") var phase: String = "wait"
@export var wait_time : float = 1
var dead : bool = false
var busy : bool = false
var casting : bool = false
var desperation : bool = false

## Anims
func anim_warcry():
	Sound.censer("swing")
	my_sprite.play("default",1,false)

func anim_stun():
	Sound.metal_impact()
	%MetalFragment.emitting = true
	Sound.censer("stun")
	my_sprite.play("stun",1,false)
	if phase != "defeat":
			my_sprite.play("default",1,false)

func anim_exhaust():
	Sound.censer("swing")
	Sound.PlayerExtinguished()
	my_sprite.play("tired",1,false)

func anim_attack():
	Sound.censer("warcry")
	my_sprite.play("default",1,false)

func anim_death():
	var fade_time : float = 5
	##Achievement: Slayed Censer
	GameState.target_player.anim_achievement("a_flawed_vessel_censer")
	GameState.target_player.waiting = true
	GameState.target_player.current_zone = -999
	#hardcoded location of censer death
	GameState.target_player.temp_position = Vector2(0,-12)
	my_sprite.play("default",1,false)
	Sound.censer("warcry")
	BgmController.stopAll()
	BgmController.battle_1.stop()
	anim.current_animation = "defeat"
	%MoteExplosion.emitting = true
	await get_tree().create_timer(fade_time/2).timeout
	Sound.impact_big()
	%MetalFragment.emitting = true
	my_sprite.play("stun",1,false)
	await get_tree().create_timer(hit_area.hitstun).timeout
	my_sprite.play("default",1,false)
	await get_tree().create_timer(.5).timeout #------------- impact 1
	Sound.impact_big()
	%MetalFragment.emitting = true
	my_sprite.play("stun",1,false)
	await get_tree().create_timer(hit_area.hitstun).timeout
	my_sprite.play("default",1,false)
	await get_tree().create_timer(.5).timeout #------------- impact 2
	Sound.impact_big()
	%MetalFragment.emitting = true
	my_sprite.play("stun",1,false)
	await get_tree().create_timer(hit_area.hitstun).timeout
	my_sprite.play("tired",1,false)
	await get_tree().create_timer(1.5).timeout #------------- impact 3
	my_sprite.play("fade")
	GameState.mote_reward(GameState.reward_censer,0,"big")
	#Re-focus camera on player
	GameState.target_player.current_zone = 24
	GameState.anim_rumble(1.5,5)
	Sound.explosion()
	%FireExplosion.emitting = true
	%SmokeExplosion.emitting = true
	%MetalExplosion.emitting = true
	%SmokeParticle.emitting = false
	%MoteExplosion.emitting = false
	GameState.target_player.anim_enemy_slain()
	GameState.target_player.waiting = false

## Functions
func _ready() -> void:
	phase = "wait"
	hit_area.painState.connect(stun)
	hit_area.death_rattle.connect(defeated)
	hit_area.on_touch_effect = "Burning"
	hit_area.canMelee = false
	anim.current_animation = "RESET"
	if GameState.townDict["townMiniBoss"] == 1: #if already defeated
		queue_free()

func _process(_delta: float) -> void:
	#when player enters
	if GameState.target_player.current_zone == current_zone and phase == "wait":
		anim_warcry()
		phase = "start"
		anim.current_animation = "start"
		await get_tree().create_timer(wait_time/2).timeout
		phase = "loop" #enter attack loop
		swing_high()
	
	if phase == "loop" and !dead and !GameState.target_player.dead and busy:
		cast_wheel()

func stun():
	if phase == "loop" and !dead and !GameState.target_player.dead:
		%MetalFragment.emitting = true
		anim_stun()
		await get_tree().create_timer(hit_area.hitstun).timeout
		withdraw()
		if hit_area.hp == 1:
			desperation = true
	#else: print("Censer blocked damage")

func vulnerable():
	if phase == "loop" and !dead:
		hit_area.canMelee = true
		anim_exhaust()
		hit_area.on_touch_effect = "Standard"

func attacking():
	if phase == "loop" and !dead:
		hit_area.canMelee = false
		anim_attack()
		hit_area.on_touch_effect = "Burning"

func withdraw():
	hit_area.canMelee = false

func reposition():
	if !busy and !dead:
		var choose_attack : int
		randomize()
		choose_attack = (randi() % 3)
		match choose_attack:
			0:
				swing_high()
			1:
				swing_middle()
			2:
				swing_low()

func swing_high():
	if phase == "loop" and !dead:
		busy = true
		hit_area.on_touch_effect = "Burning"
		anim.current_animation = "swingHigh"
		await get_tree().create_timer(wait_time).timeout
		busy = false
		#swing_low()
		reposition()

func swing_low():
	if phase == "loop" and !dead:
		busy = true
		hit_area.on_touch_effect = "Burning"
		anim.current_animation = "swingMiddle"
		await get_tree().create_timer(wait_time).timeout
		busy = false
		reposition()

func swing_middle():
	if phase == "loop" and !dead:
		busy = true
		hit_area.on_touch_effect = "Burning"
		anim.current_animation = "swingLow"
		await get_tree().create_timer(wait_time).timeout
		busy = false
		reposition()

func cast_wheel():
	if !casting and !desperation:
		casting = true
		await get_tree().create_timer(randi_range(3,5)).timeout
		cast_1.emit()
		await get_tree().create_timer(randi_range(3,5)).timeout
		cast_2.emit()
		await get_tree().create_timer(randi_range(3,5)).timeout
		cast_3.emit()
		await get_tree().create_timer(randi_range(3,5)).timeout
		cast_4.emit()
		casting = false
	
	if !casting and desperation:
		casting = true
		await get_tree().create_timer(2.5).timeout
		cast_1.emit()
		cast_4.emit()
		await get_tree().create_timer(2.5).timeout
		cast_2.emit()
		cast_3.emit()
		casting = false

func defeated():
	if !dead:
		fatal_damage.emit()
		dead = true
		phase = "defeat"
		anim_death()
		GameState.addKillCount()
		GameState.townDict["townMiniBoss"] = 1 #register defeat
		death_rattle.emit()
		await get_tree().create_timer(30).timeout
		queue_free()
