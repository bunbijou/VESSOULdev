extends AnimatedSprite2D
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	self.position = GameState.target_player.position
	
	if self.position.x >= 0:
		self.scale = Vector2(-0.5,0.5)
	else: self.scale = Vector2(0.5,0.5)
