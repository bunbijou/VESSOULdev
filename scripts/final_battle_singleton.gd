extends Node

signal battle_end

@export var target_enemy : Node2D
@export_enum("pre-battle","intro","start") var phase: String
var core_1_initial_position : Vector2
var core_2_initial_position : Vector2
var core_3_initial_position : Vector2
var core_4_initial_position : Vector2
var core_5_initial_position : Vector2
var core_6_initial_position : Vector2
var core_7_initial_position : Vector2
var count : int = 0
var size_mod : Vector2 = Vector2(.10,.10)

func _ready() -> void:
	Dialogue.anim.current_animation = "up"
	GameState.playerKillCount = 0
	target_enemy.battle_start.connect(next)
	%EbonVessel.boss_damaged.connect(dislodge)
	phase = "pre-battle"
	core_1_initial_position = %Core1.position
	core_2_initial_position = %Core2.position
	core_3_initial_position = %Core3.position
	core_4_initial_position = %Core4.position
	core_5_initial_position = %Core5.position
	core_6_initial_position = %Core6.position
	core_7_initial_position = %Core7.position
	%EbonVessel.scale += Vector2(.10,.10)*7
	%EbonVessel.spd = 25
func _process(_delta: float) -> void:
	if GameState.playerKillCount == 7:
		battle_end.emit()

func next():
	match phase:
		"pre-battle":
			#this wait is important to keep the events from overlapping
			await get_tree().create_timer(.01).timeout
			Localize.reference_dialogue("SamaelSpriteCallOut")
			phase = "intro"
		"intro":
			BgmController.stopAll()
			target_enemy.anim_reveal()
		"start":
			pass

func dislodge():
	Sound.PumpkinSplat() #placeholder
	count += 1
	match count:
		1:
			%Core1.position = %EbonVessel.position
			%Core1.visible = true
			%Core1.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*6)
			%EbonVessel.spd = 25
		2:
			%Core2.position = %EbonVessel.position
			%Core2.visible = true
			%Core2.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*5)
			%EbonVessel.spd = 30
		3:
			%Core3.position = %EbonVessel.position
			%Core3.visible = true
			%Core3.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*4)
			%EbonVessel.spd = 35
		4:
			%Core4.position = %EbonVessel.position
			%Core4.visible = true
			%Core4.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*3)
			%EbonVessel.spd = 40
		5:
			%Core5.position = %EbonVessel.position
			%Core5.visible = true
			%Core5.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*2)
			%EbonVessel.spd = 45
		6:
			%Core6.position = %EbonVessel.position
			%Core6.visible = true
			%Core6.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)+(Vector2(.10,.10)*1)
			%EbonVessel.spd = 50
		7:
			%Core7.position = %EbonVessel.position
			%Core7.visible = true
			%Core7.current_zone = -201
			%EbonVessel.scale = Vector2(1,1)
			%EbonVessel.spd = 55
