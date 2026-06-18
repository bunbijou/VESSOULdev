class_name FallingRubble extends AnimatedSprite2D

@export var delay : float
var active : bool = false

func _ready() -> void:
	self.play("default",0,false)
	await get_tree().create_timer(delay).timeout
	self.play("default",1,false)
	Sound.rock_break()
