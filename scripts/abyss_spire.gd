extends Node2D

@export var delay : float
@export var sprite : AnimatedSprite2D
@export var hit_area : HitboxComponent
@onready var target_enemy : BossForsaken = %Forsaken

func _ready() -> void:
	self.visible = false
	target_enemy.cast_spikes.connect(active)
	hit_area.on_touch_effect = "None"

func active():
	Sound.stone_break()
	self.visible = true
	sprite.play("default",1,false)
	await get_tree().create_timer(delay*2).timeout
	emerge()

func emerge():
	Sound.impact_big()
	sprite.play("emerge",1,false)
	hit_area.on_touch_effect = "Hazard"
	await get_tree().create_timer(delay).timeout
	conceal()

func conceal():
	hit_area.on_touch_effect = "None"
	self.visible = false
