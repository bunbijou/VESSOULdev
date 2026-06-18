extends Node2D
@onready var target_enemy = %Samael
@export var delay_time : float = 0.0
@export var hit_area : HitboxComponent 
@export var sprite : AnimatedSprite2D
@export var sprite_bg : AnimatedSprite2D
@export var flame_particle_down : CPUParticles2D
@export var flame_particle_side : CPUParticles2D
@export_enum("Down", "Side") var flame_direction: String
var beat : int = 1

var reveal : bool = false

func _ready() -> void:
	sprite.visible = false
	sprite.visible = false
	target_enemy.cast_flame.connect(active)
	hit_area.on_touch_effect = "None"
	flame_particle_down.emitting = false
	flame_particle_side.emitting = false


func active():
	await get_tree().create_timer(delay_time).timeout
	Sound.fire("small")
	reveal = true
	sprite.visible = true
	sprite_bg.visible = true
	await get_tree().create_timer(beat).timeout
	incinerate()

func incinerate():
	Sound.fire("big")
	if flame_direction == "Down":
		flame_particle_down.emitting = true
	
	if flame_direction == "Side":
		flame_particle_side.emitting = true
	
	await get_tree().create_timer(beat).timeout
	hit_area.on_touch_effect = "Burning"
	await get_tree().create_timer(beat).timeout
	fizzle()

func fizzle():
	reveal = false
	
	if flame_direction == "Down":
		flame_particle_down.emitting = false
	
	if flame_direction == "Side":
		flame_particle_side.emitting = false
	
	hit_area.on_touch_effect = "None"
	await get_tree().create_timer(beat).timeout
	self.position = Vector2(999,999)
