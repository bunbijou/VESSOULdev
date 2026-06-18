extends Node2D

signal parry

@export_enum("BlackMote",
"Motemouse",
"LilJawer",
"Pothead",
"Wispflower",
"ShadowLurker",
"Motemuncher",
"Motebearer",
"Sinkhole",
"Mimic",
"ShadowSnake",
"OneEyeRaven",
"Muckman",
"Ossuary",
"Gazer",
"Burnout",
"Amphora",
"GodwoodStump",
"Censer",
"GapingJawer",
"Lenore",
"Abyssoul",
"FrenziedGrowth",
"SamaelUnmasked",
"SamaelShadow",
"MoteMissle",
"shadow-tainted motes",
"£E$¢€¥÷¤+B-*/=%'#O@&_(¶µ§¼Nφ‰",
"undulating shadows",
"saturnine flames",
"MazeGuardian",
"MazeRuler",
"falling rocks") var enemy : String
@export var interact_area : Area2D
@export var no_interact : bool = false
var inspect : bool = false
var can_interact : bool = false
var player_contact : bool = false
var follow_up : bool = false
var warning : bool = true

func _ready() -> void:
	Dialogue.dialogue_end.connect(addendum)
	%InteractSprite.visible = false
	## If good ending (secret) achieved this save
	if GameState.townDict["townEndingChoice"][2] >= 1:
		inspect = true
	## Ditto
	if GameState.townDict["townEndingChoice"][1] >= 1:
		inspect = true

func update():
	#Don't update this if the player has already died
	#We want this to report the last thing the player touched before they died
	if !GameState.target_player.dead:
		GameState.last_enemy = str(enemy)

func _on_touch(_body: CharacterBody2D) -> void:
	update()
	if !no_interact:
		if enemy == "MoteMissle": #Parry behavior
			if warning:
				parry.emit()
				GameState.target_player.anim_parry()
				warning = false
				await get_tree().create_timer(.5).timeout
				Localize.reference_dialogue("SamaelSpriteIncoming")
			else: #Normal Behavior 
				Sound.textPopup()
				player_contact = true #the order is important
				can_interact = true
				%InteractSprite.visible = true
		else: #Normal behavior
			if inspect:
				GameState.target_player.anim_samael_emerge()
				Sound.textPopup()
				player_contact = true #the order is important
				can_interact = true
				%InteractSprite.visible = true


func disable():
	if !follow_up:
		can_interact = false
		%InteractSprite.visible = false

func _process(_delta: float) -> void:
	if can_interact and !GameState.target_player.dead and Input.is_action_just_pressed("ui_accept") and inspect:
			match enemy:
				"Pothead":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattlePothead1")
				"BlackMote":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleBlackMote1")
				"Motemouse":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleMotemouse1")
				"LilJawer":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleLilJawer1")
				"Wispflower":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleWisp1")
				"ShadowLurker":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleLurker1")
				"Motemuncher":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleMuncher1")
				"Motebearer":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleMotebearer1")
				"Sinkhole":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleSinkhole1")
				"Mimic":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleMimic1")
				"ShadowSnake":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleShadowSnake1")
				"Muckman":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleMuckman1")
				"Ossuary":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleOssuary1")
				"Gazer":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleGazer1")
				"Burnout":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleBurnout1")
				"Amphora":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleAmphora1")
				"GodwoodStump":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleStump1")
				"Censer":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleCenser1")
				"GapingJawer":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleGapingJawer1")
				"Lenore":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleLenore1")
				"Abyssoul":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleAbyssoul1")
				"FrenziedGrowth":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleFrenzyGrowth1")
				"OneEyeRaven":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleRaven1")
				"SamaelUnmasked":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleSamaelBase1")
				"SamaelShadow":
					Sound.itemGet("tome")
					Localize.reference_dialogue("TattleSamaelDjinn1")
				"MoteMissle":
					parry.emit()
					GameState.target_player.anim_parry()

func addendum():
	if player_contact and inspect:
		await get_tree().create_timer(.01).timeout
		if !follow_up:
			match enemy:
					"Pothead":
						Localize.reference_dialogue("TattlePothead2")
					"BlackMote":
						Localize.reference_dialogue("TattleBlackMote2")
					"Motemouse":
						Localize.reference_dialogue("TattleMotemouse2")
					"LilJawer":
						Localize.reference_dialogue("TattleLilJawer2")
					"Wispflower":
						Localize.reference_dialogue("TattleWisp2")
					"ShadowLurker":
						Localize.reference_dialogue("TattleLurker2")
					"Motemuncher":
						Localize.reference_dialogue("TattleMuncher2")
					"Motebearer":
						Localize.reference_dialogue("TattleMotebearer2")
					"Sinkhole":
						Localize.reference_dialogue("TattleSinkhole2")
					"Mimic":
						Localize.reference_dialogue("TattleMimic2")
					"ShadowSnake":
						Localize.reference_dialogue("TattleShadowSnake2")
					"Muckman":
						Localize.reference_dialogue("TattleMuckman2")
					"Ossuary":
						Localize.reference_dialogue("TattleOssuary2")
					"Gazer":
						Localize.reference_dialogue("TattleGazer2")
					"Burnout":
						Localize.reference_dialogue("TattleBurnout2")
					"Amphora":
						Localize.reference_dialogue("TattleAmphora2")
					"GodwoodStump":
						Localize.reference_dialogue("TattleStump2")
					"Censer":
						Localize.reference_dialogue("TattleCenser2")
					"GapingJawer":
						Localize.reference_dialogue("TattleGapingJawer2")
					"Lenore":
						Localize.reference_dialogue("TattleLenore2")
					"Abyssoul":
						Localize.reference_dialogue("TattleAbyssoul2")
					"FrenziedGrowth":
						Localize.reference_dialogue("TattleFrenzyGrowth2")
					"OneEyeRaven":
						Localize.reference_dialogue("TattleRaven2")
					"SamaelUnmasked":
						Localize.reference_dialogue("TattleSamaelBase2")
					"SamaelShadow":
						Localize.reference_dialogue("TattleBase2")
			follow_up = true #indicating that the follow-up message has read 
			can_interact = false #prevent further dialogues
		else: queue_free() #to-do, signal to other info_components of the same type to self-destruct

func _on_area_exit(_body: CharacterBody2D) -> void:
	if enemy != "MoteMissle":
		GameState.target_player.anim_samael_hide()
	player_contact = false #the order is important
	disable()
