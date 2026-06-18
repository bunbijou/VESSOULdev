extends AnimatedSprite2D

var active : bool = true

func _ready() -> void:
		randomize()
		self.frame = randi() % 4
