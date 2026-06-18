#Fade In / Fade Out
extends TextureRect
@onready var animation_player = %AnimationPlayer

func _ready() -> void:
	animation_player.current_animation = "fadein"

## Legacy Functions
func fadeToWhite():
	animation_player.current_animation = "whiteOut"

func fadeFromBlack():
	animation_player.current_animation = "fadein"

func fadeToBlack():
	animation_player.current_animation = "fadeout"

## New
func play(type : String, duration):
	match type:
		"White Fade Up": 
			%ParticlesWhite.emitting = true
			await get_tree().create_timer(duration).timeout 
			%ParticlesWhite.emitting = false
		"Black Fade Down":
			%ParticlesBlack.emitting = true
			await get_tree().create_timer(duration).timeout 
			%ParticlesBlack.emitting = false
