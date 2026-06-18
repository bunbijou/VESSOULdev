extends AnimatedSprite2D
@export var fall_speed : float = 3

func _physics_process(_delta: float) -> void:
	self.position.y += fall_speed
