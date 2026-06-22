extends Node2D

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var anim : AnimationPlayer
@export var sprite : AnimatedSprite2D 
@export var attack_randomness : int = 50 
var attack_interval : float = 5
var attack_intensity : float = 0
var attack_interval_modifier : float = 0.10
var attack_intensity_gain : float = 1
var busy : bool = false
@export_enum("none","top","left","right","confusion") var attack_angle: String = "none"
var initial_position : Vector2
var flash_count : int = 0
var speed : float = .6 #was .5
var attack_prepared : bool = false
var drama_beat : float = 3
var battle_finish : bool = false
var flashes_required : int = 7

func anim_idle():
	if attack_angle == "none" and !busy:
		sprite.play("idleFront",1,false)
	
	if attack_angle == "top" and !busy:
		sprite.play("idleFront",1,false)
	
	if attack_angle == "left":
		sprite.flip_h = false
		sprite.play("idleSide",1,false)
	
	if attack_angle == "right":
		sprite.flip_h = true
		sprite.play("idleSide",1,false)
	
	if attack_angle == "confusion":
		sprite.flip_h = false
		sprite.play("confusion",1,false)

func anim_attack():
	Sound.djinn("charge")
	Sound.woosh_ascend()
	if attack_angle == "none":
		sprite.play("chargeFront",1,false)
	
	if attack_angle == "top":
		sprite.play("chargeFront",1,false)
	
	if attack_angle == "left":
		sprite.flip_h = false
		sprite.play("chargeSide",1,false)
	
	if attack_angle == "right":
		sprite.flip_h = true
		sprite.play("chargeSide",1,false)
	print ("Boss flash amount:"+str(flash_count))

func anim_stun():
	Sound.djinn("stun")
	sprite.play("stun",1,false)

func anim_confusion():
	Dialogue.anim.play("up")
	Sound.djinn("confusion")
	anim.current_animation = "RESET"
	anim.current_animation = "confusion"
	sprite.play("stun",1,false)
	Sound.AbyssalCry()


func _ready() -> void:
	BgmController.track_echoes.play()
	Sound.djinn("warcry")
	Localize.reference_dialogue("SamaelDjinnBattleStart")
	anim.speed_scale = speed
	GameState.target_player.flashed.connect(boss_flashed)
	initial_position = sprite.position
	await get_tree().create_timer(drama_beat).timeout #MAGIC NUMBER
	attack_prepared = true
	if GameState.EasyMode:
		flashes_required = 5
	else: flashes_required = 7

func _process(_delta: float) -> void:
	if !battle_finish:
		%EnvironmentAnimationPlayer.speed_scale = (flash_count)/4
		speed += flash_count*attack_intensity_gain
		if flash_count >= flashes_required and !get_tree().paused:
			anim_confusion()
			divine_intervention()
		else:
			if !get_tree().paused:
				if attack_prepared == true:
					attack_interval = (5*attack_intensity_gain)-(attack_intensity_gain/attack_intensity)
					
					if !GameState.target_player.dead: ##stop if player is dead
						if attack_angle == "none":
							await get_tree().create_timer(attack_interval*2).timeout
							attack_angle = "top" ##default

						if attack_angle == "top" and !busy:
							sprite.flip_h = false #see above
							forsaken_djinn_descent()
					else: pass

func boss_flashed():
	anim_stun()
	flash_count += 1
	await get_tree().create_timer(attack_interval/20).timeout
	samael_dialogue()
	if busy and attack_prepared:
		anim_attack()

func samael_dialogue():
	match flash_count:
		1: Localize.reference_dialogue("SamaelDjinnFlashed")
		2: Localize.reference_dialogue("SamaelDjinnFlashed2")
		3: Localize.reference_dialogue("SamaelDjinnFlashed3")
		4: Localize.reference_dialogue("SamaelDjinnFlashed4")
		5: Localize.reference_dialogue("SamaelDjinnFlashed5")
		6: 
			if GameState.EasyMode:
				pass
			else:
				Localize.reference_dialogue("SamaelDjinnFlashed6")

func forsaken_djinn_descent():
	if attack_prepared:
		sprite.position = initial_position
		randomize()
		sprite.position.x += randfn(-attack_randomness, attack_randomness)
		attack_angle = "top"
		anim_attack()
		anim.current_animation = "attack_top_down"
		busy = true
		await get_tree().create_timer(attack_interval).timeout
		anim.current_animation = "hide"
		busy = false
		attack_intensity += attack_intensity_gain
		print ("Intensity level:"+str(attack_intensity))
		forsaken_djinn_swipe_left()

func forsaken_djinn_swipe_left():
	if attack_prepared:
		sprite.position = initial_position
		randomize()
		sprite.position.y += randfn(-attack_randomness, attack_randomness)
		attack_angle = "left"
		anim_attack()
		anim.current_animation = "attack_left_right"
		busy = true
		await get_tree().create_timer(attack_interval).timeout
		anim.current_animation = "hide"
		attack_angle = "right"
		busy = false
		attack_intensity += attack_intensity_gain
		print ("Intensity level:"+str(attack_intensity))
		forsaken_djinn_swipe_right()
	
func forsaken_djinn_swipe_right():
	if attack_prepared:
		sprite.position = initial_position
		randomize()
		sprite.position.y += randfn(-attack_randomness, attack_randomness)
		attack_angle = "right"
		anim_attack()
		anim.current_animation = "attack_right_left"
		busy = true
		await get_tree().create_timer(attack_interval).timeout
		anim.current_animation = "hide"
		attack_angle = "right"
		busy = false
		attack_intensity += attack_intensity_gain
		print ("Intensity level:"+str(attack_intensity))
		forsaken_djinn_descent()

func divine_intervention():
	##Achievement: Defeat Samael
	SteamHandler.achievement_get("a_forsaken_defeat")
	BgmController.stopAll()
	battle_finish = true
	%EnvironmentAnimationPlayer.speed_scale = 1
	%EnvironmentAnimationPlayer.current_animation = "intervention"
	Localize.reference_dialogue("SamaelDjinnConfounded")
	GameState.target_player.waiting = true
	busy = true
	attack_prepared = false
	GameState.mote_reward(GameState.reward_forsaken,0,"big")
	await get_tree().create_timer(drama_beat).timeout
	LevelTransition.fadeToWhite()
	await get_tree().create_timer(drama_beat).timeout
	get_tree().change_scene_to_file("res://trial.tscn")
