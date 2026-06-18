extends TextureRect
@export var spin : float

func _process(delta: float) -> void:
	self.rotation -= spin
