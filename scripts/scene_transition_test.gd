extends Node2D
@export var my_hitbox : HitboxComponent
@export_enum("White Fade Up","Black Fade Down") var selection : String = "White Fade Up"

func _ready() -> void:
	my_hitbox.enemy_alert.connect(my_transition)

func my_transition():
	match selection:
		"White Fade Up": LevelTransition.play("WhiteFadeUp",3)
		"Black Fade Down": LevelTransition.play("BlackFadeDown",3)
