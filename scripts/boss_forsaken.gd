class_name BossForsaken extends Node2D


signal cast_spikes
signal cast_sphere
signal cast_fire
#signal impact_big

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var movement : Node2D
@export var sprite : AnimatedSprite2D
@export var circle_sprite : AnimatedSprite2D
@export var anim : AnimationPlayer
@export var shadow : Sprite2D
@export_enum("pre_battle","phase_1","phase_2") var combat_phase: String = "pre_battle"
@export var fade_wait : float = 3
@export var destination_scene : String
@export var debug : bool = false
var initial_position : Vector2 #will go back to this spot between phases
var impact_area : Vector2
var dialogue_wait : float = 3
var combat_wait : float = 1
var spell_wait : float = 10
var hyperspeed : int = 999
var busy : bool = false
var target_acquired : bool = false
var dialogue_state : int = 0
var spell_state : int = 0
var stun : bool = false #to keep stun animation/sound from playing repeatedly
var counter : bool = false #counterattack with fire wheel (first phase only)
var player_is_visible : bool = false

##Anims / Music
func anim_reveal():
	music_start()
	sprite.visible = true
	sprite.play("base_r_reject_speak",1,false)

func anim_transform():
	sprite.play("base_transform",1,false)
	Sound.warble() ##was "PlayerFlash"
	await get_tree().create_timer(dialogue_wait-1).timeout
	anim_angel_idle()

func anim_angel_idle():
	sprite.play("angel_idle",1,false)

func anim_ascend():
	Sound.woosh_ascend()
	sprite.play("angel_ascend",1,false)
	await get_tree().create_timer(combat_wait/2).timeout
	anim.current_animation = "ascend"

func anim_descend():
	anim.current_animation = "descend"
	await get_tree().create_timer(combat_wait/2).timeout
	sprite.play("angel_descend",1,false)
	await get_tree().create_timer(combat_wait/6).timeout
	Sound.impact_big()
	GameState.anim_rumble(0.15,10)

func anim_channel():
	sprite.play("angel_cast",1,false)

func anim_wisp(state : bool):
	match state:
		true: 
			%WispFire.emitting = true
			Sound.samael("incant_fire")
		false: %WispFire.emitting = false

func anim_flashed():
	Sound.samael("stun")
	if sprite.animation != "angel_ascend" and sprite.animation != "angel_descend":
		sprite.play("flash",1,false)

func music_stop():
	BgmController.track_grimoire.stop()
	
func music_start():
	BgmController.track_grimoire.play()


## Functions
func _ready() -> void:
	GameState.target_player.flashed.connect(boss_flashed)
	GameState.target_player.player_death.connect(reset)
	GameState.target_player.fatal_damage.connect(death_quip)
	GameState.battle_begin.connect(anim_reveal)
	if !debug:
		reset("start")
	else: final_battle_reset()

func _process(_delta: float) -> void:
	if combat_phase == "pre_battle":
		Dialogue.anim.current_animation = "up"
		##Once the player enters the active battle zone, do the dramatic reveal
		if GameState.target_player.current_zone == 19 and GameState.npcDict["sculptor"] == 101: #see res://sculptor_reveal.gd
			Localize.reference_dialogue("SamaelReveal")
			GameState.npcDict["sculptor"] = 103#
		
		if !get_tree().paused and GameState.npcDict["sculptor"] == 103:
			anim_transform()
			Localize.reference_dialogue("SamaelReveal2")
			GameState.npcDict["sculptor"] = 104

		if !get_tree().paused and GameState.npcDict["sculptor"] == 104:
			Localize.reference_dialogue("SamaelReveal3")
			GameState.npcDict["sculptor"] = 105
		
		if !get_tree().paused and GameState.npcDict["sculptor"] == 105:
			Localize.reference_dialogue("SamaelReveal4")
			GameState.npcDict["sculptor"] = 106
		
		if !get_tree().paused and GameState.npcDict["sculptor"] == 106:
			Localize.reference_dialogue("SamaelReveal5")
			GameState.npcDict["sculptor"] = 107
		
		if !get_tree().paused and GameState.npcDict["sculptor"] == 107:
			GameState.npcDict["sculptor"] = 108
			combat_phase = "phase1"

	if get_tree().paused:
		anim.speed_scale = 0
	else:
		if combat_phase == "phase1" and !busy:
			anim.speed_scale = 1
			if !GameState.target_player.dead: #??? 
				fallen_angel_descent()
			else:
				busy = true
				anim_angel_idle()
			#	fallen_angel_realign()
		
		if combat_phase == "phase2" and !busy:
			anim.speed_scale = 1
			if spell_state == 0:
				fallen_angel_realign()
			else:
				anim_channel()
			
			match spell_state:
				1: #Abyssal Spire Barrage
					spell_abyssal_spires()
				2: #Ascendant Celestial Sphere
					spell_celestial_sphere()

##Used to just jump around randomly, instead, now targets the player
func find_impact_zone():
	if !target_acquired:
		impact_area = GameState.target_player.position+(Vector2(0,5))
		#randomize()
		#impact_area = Vector2((randf_range(attack_area_0[0], attack_area_1[1])),(randf_range(attack_area_0[1], attack_area_4[1])))
		shadow.position = impact_area
		target_acquired = true

func fallen_angel_descent():
	busy = true
	#vulnerable = false
	anim_ascend()
	find_impact_zone()
	await get_tree().create_timer(combat_wait).timeout
	movement.position = impact_area
	anim_descend()
	#vulnerable = true
	await get_tree().create_timer(combat_wait).timeout
	target_acquired = false
	busy = false

func fallen_angel_realign():
	Sound.samael("anger")
	spell_state = -1
	shadow.visible = false
	busy = true
	anim_ascend()
	await get_tree().create_timer(combat_wait).timeout
	movement.position = initial_position
	await get_tree().create_timer(combat_wait).timeout
	anim_descend()
	spell_state = 1
	busy = false
	await get_tree().create_timer(combat_wait).timeout
	anim_channel()

func spell_abyssal_spires():
	if !busy:
		Sound.samael("incant_rocks")
		busy = true
		circle_sprite.visible = true
		circle_sprite.play("abyss",1,false)
		cast_spikes.emit()
		await get_tree().create_timer(spell_wait).timeout
		#Sound.placeHolder() #ground rumbling
		busy = false
		spell_state = 2 #Cast celestial sphere


func spell_celestial_sphere():
	if !busy:
		music_stop()
		Sound.samael("incant_sphere")
		Sound.dark_sphere()
		busy = true
		circle_sprite.visible = true
		circle_sprite.play("ascendant",1,false)
		cast_sphere.emit()
		await get_tree().create_timer(spell_wait).timeout
		busy = false
		spell_state = 3 #Cast Flame

func boss_flashed():
	if combat_phase != "pre_battle" and player_is_visible and !stun:
		stun = true
		anim_flashed()
		match dialogue_state:
			0:
				Localize.reference_dialogue("SamaelFlashed")
				dialogue_state += 1
			1: 
				Localize.reference_dialogue("SamaelFlashed2")
				dialogue_state += 1
			2: 
				Localize.reference_dialogue("SamaelFlashed3")
				dialogue_state += 1
			3: 
				Localize.reference_dialogue("SamaelFlashed4")
				dialogue_state += 1
			4: 
				#No line of dialogue
				dialogue_state += 1
			5: 
				if !GameState.EasyMode:
					counter = true
					combat_wait = 0.75 ##Experimental
					anim_wisp(true)
					Localize.reference_dialogue("SamaelFlashed5")
					dialogue_state += 1
				else: #skip forward
					Localize.reference_dialogue("SamaelFlashed10")
					combat_phase = "phase2"
			6: 
				if GameState.EasyMode:
					pass
				else:
					Localize.reference_dialogue("SamaelFlashed6")
					dialogue_state += 1
			7: 
				if GameState.EasyMode:
					pass
				else:
					Localize.reference_dialogue("SamaelFlashed7")
					dialogue_state += 1
			8: 
				if GameState.EasyMode:
					pass
				else:
					Localize.reference_dialogue("SamaelFlashed8")
					dialogue_state += 1
			9: 
				if GameState.EasyMode:
					pass
				else:
					Localize.reference_dialogue("SamaelFlashed9")
					dialogue_state += 1
			10: 
				if GameState.EasyMode:
					pass
				else:
					Localize.reference_dialogue("SamaelFlashed10")
					combat_phase = "phase2"
		await get_tree().create_timer(combat_wait).timeout
		stun = false
		if combat_phase == "phase1" and counter:
			await get_tree().create_timer(.5).timeout
			cast_fire.emit()
			circle_sprite.visible = true
			circle_sprite.play("forsaken",1,false)
			await get_tree().create_timer(.5).timeout
			circle_sprite.visible = false
		

func fadeout():
	await get_tree().create_timer(fade_wait).timeout
	#Maintain the player HP state between scenes
	GameState.player_hp_previous = GameState.playerHP
	get_tree().change_scene_to_file(destination_scene)

func death_quip():
	var death_message : int = 0
	Sound.samael("victory")
	randomize()
	death_message = (randi() % 10)
	match death_message:
		0: Localize.reference_dialogue("SamaelPlayerDefeat")
		1: Localize.reference_dialogue("SamaelPlayerDefeat2")
		2: Localize.reference_dialogue("SamaelPlayerDefeat3")
		3: Localize.reference_dialogue("SamaelPlayerDefeat4")
		4: Localize.reference_dialogue("SamaelPlayerDefeat5")
		5: Localize.reference_dialogue("SamaelPlayerDefeat6")
		6: Localize.reference_dialogue("SamaelPlayerDefeat7")
		7: Localize.reference_dialogue("SamaelPlayerDefeat8")
		8: Localize.reference_dialogue("SamaelPlayerDefeat9")
		9: Localize.reference_dialogue("SamaelPlayerDefeat10")
	await get_tree().create_timer(GameState.target_player.respawn_time-0.01).timeout
	final_battle_reset()

func reset(arg : String):
	await get_tree().create_timer(GameState.target_player.respawn_time-0.01).timeout
	print("Battle Reset (Reason:"+arg+")")
	if combat_phase != "pre_battle":
		combat_phase = "phase_1"
	shadow.position = Vector2(999,999)
	movement.position = Vector2(0,-5)#self.position
	sprite.visible = false
	circle_sprite.visible = false


func final_battle_reset():
	print("boss_forsaken.gd - Reset the final battle state")
	GameState.npcDict["sculptor"] = 100


func _on_vision_area_body_entered(_body: PlayerVessel) -> void:
	%FlashComponent.is_flashable = true
	player_is_visible = true

func _on_vision_area_body_exited(_body: PlayerVessel) -> void:
	%FlashComponent.is_flashable = false
	player_is_visible = false
