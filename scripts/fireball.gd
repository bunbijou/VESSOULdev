extends Node2D
@export_enum("MagicFire","AbyssSoil") var substance : String = "MagicFire"
@export var flame_particle : CPUParticles2D
@export var flash_can_dispel : bool = true
var velocity : Vector2 = Vector2.RIGHT
var velocity_mod : float = 1
@export var lifetime : int = 5
var current_zone : int = 999

func anim(type : String):
	match type:
		##This is called "flame particle" but it can be whatever we want
		"flame_burst": 
			if flame_particle:
				flame_particle.emitting = true

func _ready() -> void:
	if flash_can_dispel:
		GameState.target_player.flashed.connect(dispel)
	match substance:
		"MagicFire": Sound.fire("small")
		"AbyssSoil": Sound.rock_break()
	##See above
	anim("flame_burst")
	self.rotation = get_angle_to(GameState.target_player.position)
	await get_tree().create_timer(0.001).timeout
	velocity = velocity.rotated(self.rotation)
	cleanup()

func _process(_delta: float) -> void:
	if GameState.target_player.current_zone != current_zone:
		queue_free()

func _physics_process(_delta: float) -> void:
	position += velocity*velocity_mod

func cleanup():
	await get_tree().create_timer(lifetime).timeout
	queue_free() 

func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(.1).timeout
	match substance:
		"MagicFire": Sound.explosion()
		"AbyssSoil": Sound.rock_break()
	anim("flame_burst")
	dispel()

func dispel():
	velocity = Vector2(0,0)
	%AnimatedSprite2D.visible = false
	@warning_ignore("integer_division")
	await get_tree().create_timer(GameState.cleanup_time_enemy/10).timeout
	queue_free()
