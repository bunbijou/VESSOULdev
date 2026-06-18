extends Node2D
@export var my_sprite : AnimatedSprite2D
var locked : bool = true

func _ready() -> void:
	%EndlessConfig.condition_met.connect(unlock)

func unlock():
	if locked:
		BgmController.success_jingle.play() #placeholder
		locked = false
		%CollisionShape2D.disabled = true

func _process(_delta: float) -> void:
	match GameState.endless["theme"]:
		0: 
			if locked:
				my_sprite.play("dawn",-1)
			else: my_sprite.play("dawn",1)
		1:
			if locked:
				my_sprite.play("dusk",-1)
			else: my_sprite.play("dusk",1)
		2:
			if locked:
				my_sprite.play("twilight",-1)
			else: my_sprite.play("twilight",1)
