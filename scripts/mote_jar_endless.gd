extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var myBlocker = %StaticBody2D
@export var my_sprite : AnimatedSprite2D
@export var pumpkin = false
#var fade_time : int = 999

func _ready() -> void:
	%EndlessConfig.update_theme.connect(switch)
	await get_tree().create_timer(0.1).timeout
	switch(GameState.endless["theme"])

func switch(theme : int):
	randomize()
	match theme:
		0:
			my_sprite.frame = randi_range(1, 4)
		1:
			my_sprite.frame = randi_range(5, 8)
		2:
			my_sprite.frame = randi_range(9, 12)

func broken():
	#The idea of this is to keep the hitbox from being repeatedly triggered after destruction
	%Area2D.set_deferred("monitoring",true)
	animation_player.play("empty")
	#cleanup()

func _on_body_entered(_body: Node2D) -> void:
	if GameState.target_player.empowered:
		match my_sprite.frame:
			0: pass
			1: Sound.VesselBreak()
			2: Sound.VesselBreak()
			3: Sound.VesselBreak()
			4: Sound.glass_break()
			5: Sound.rock_break()
			6: Sound.wood_impact()
			7: Sound.rock_break()
			8: Sound.PumpkinSplat()
			9: Sound.glass_break()
			10: Sound.rock_break()
			11: Sound.glass_break()
			12: Sound.glass_break()
		animation_player.play("pickup")
		await get_tree().create_timer(0.35).timeout
		broken()
