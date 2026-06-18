class_name FallingJar extends Node2D

@export var delay : float
@export var sprite : AnimatedSprite2D
@export var my_mote : Node2D
@export var attack_area_0 : Vector2
@export var attack_area_1 : Vector2
@export var attack_area_3 : Vector2
@export var attack_area_4 : Vector2
var impact_area : Vector2
@export var fall_speed : float = 3
@export var indestructable : bool = false
var active : bool = false

func _ready() -> void:
	my_mote.moteValue = 50
	#my_mote.moteValue = int(GameState.playerFlashMin+1)
	await get_tree().create_timer(delay).timeout
	active = true
	Sound.fallOut()

func _physics_process(_delta: float) -> void:
	if active:
		self.position.y += fall_speed
		
		if self.position.y >= 0:
			shatter()

func shatter():
	%ParticleAbyss.emitting = true
	active = false
	sprite.animation = "break"
	Sound.VesselBreak()
