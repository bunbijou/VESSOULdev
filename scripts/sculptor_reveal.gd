class_name ForsakenPreBattle extends AnimatedSprite2D
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var smoke : CPUParticles2D
@export var pre_battle_wait : int = 3
#@export var anim : AnimationPlayer


func _ready() -> void:
	self.visible = false
	GameState.battle_begin.connect(reveal)

func reveal():
	if GameState.npcDict["sculptor"] == 101:
		smoke.emitting = true
		GameState.target_player.current_zone = 998
		self.visible = true
		self.animation = "base_r_reject_speak"
		await get_tree().create_timer(pre_battle_wait).timeout
		if !get_tree().paused:
			GameState.npcDict["sculptor"] = 102
