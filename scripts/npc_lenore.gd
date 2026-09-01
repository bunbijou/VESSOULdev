extends Node2D

signal unlock_humanity
signal battle_start

@export var anim : AnimatedSprite2D
@export var debug_battle : bool = false
var dialogue : int = 0
var start_dialogue : bool = false
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
var beat : int = 1

func anim_lenore(value : String):
	match value:
		"idle": anim.play("idle",1,false)
		"cry": anim.play("cry",1,false)
		"fade": anim.play("fade",1,false)

func _ready() -> void:
	if debug_battle == true:
		GameState.favor = 0
	BgmController.abyss_main.play()

func _player_touch(_body: Node2D) -> void:
	if GameState.favor == -1:
		start_dialogue = true
	if GameState.favor == 0: #player messed up
		begin_battle()

func _process(_delta: float) -> void:
	%DebugDialogueState.text = str(dialogue)
	if start_dialogue:
		if !Dialogue.isReading:
			match dialogue: 
					0: #first meet
						Localize.reference_dialogue("LenoreIntro")
						increment_message(1)
					1:
						Localize.reference_dialogue("Lenore2")
						increment_message(1)
					2:
						Localize.reference_dialogue("Lenore3")
						increment_message(1)
					3:
						Localize.reference_dialogue("Lenore4")
						increment_message(1)
					4:
						Localize.reference_dialogue("Lenore5")
						increment_message(1)
					5:
						Localize.reference_dialogue("Lenore6")
						increment_message(1)
					6:
						Localize.reference_dialogue("Lenore7")
						increment_message(1)
						BgmController.stopAll()
					7:
						Localize.reference_dialogue("Lenore8")
						increment_message(1)
					8:
						Localize.reference_dialogue("Lenore9")
						increment_message(1)
					9: 
						Localize.reference_dialogue("Lenore10")
						increment_message(1)
					10:
						Localize.reference_dialogue("Lenore11")
						increment_message(1)
					11: 
						Localize.reference_dialogue("Lenore12")
						increment_message(1)
					12: #question prompt
						Localize.reference_dialogue("LenoreQuestion1")
						increment_message(1)
					13: 
						if GameState.favor == 1:
							increment_message(2) #->15
						if GameState.favor == 0:
							increment_message(1) #->14
					14: #player loses favor / battle start
						BgmController.stopAll()
						anim_lenore("cry")
						Localize.reference_dialogue("LenoreFavorLost")
						BgmController.stopAll()
						increment_message(100) #->114
						BgmController.track_echoes.play()
					114: #battle start
						begin_battle()
						increment_message(999) #doesn't have additional behaviors past this point
					15: #player gains favor/humanity gained
						##Achievement: Lenore's Favor
						GameState.target_player.anim_achievement("a_lenore_favor")
						BgmController.success_jingle.play()
						BgmController.abyss_main.play()
						Localize.reference_dialogue("LenoreFavorGained")
						increment_message(100)
					115: #humanity unlocked
						anim_lenore("fade")
						increment_message(999) #doesn't have additional behaviors past this point
						unlock_humanity.emit()

func increment_message(value : int):
	dialogue += value

func begin_battle():
	if !BgmController.track_echoes.playing:
		BgmController.abyss_main.stop()
		BgmController.track_echoes.play()
	anim_lenore("fade")
	battle_start.emit()
	await get_tree().create_timer(1.5).timeout
	self.position = Vector2(9999,9999)
