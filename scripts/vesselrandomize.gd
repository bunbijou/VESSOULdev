extends AnimatedSprite2D
@export var override : bool = false
@export var random_frames : int = 6
@export var collision_area : CollisionShape2D
@export var fade_time : int = 60
var active : bool = true

func _ready() -> void:
	if !override:
		randomize()
		self.frame = randi() % random_frames+1

func _boss_touch(_area: Area2D) -> void:
	if active and self.frame == 6:  ##Only for the big chunky vessels
		destroyed()

func destroyed():
	if active:
			active = false
			collision_area.set_deferred("disabled", true)
			self.animation = "break"
			Sound.VesselBreak()
			%ParticleAbyss.emitting = true
			cleanup()

func cleanup():
	if !active:
		await get_tree().create_timer(fade_time).timeout
		queue_free()
