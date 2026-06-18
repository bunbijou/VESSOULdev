extends Node2D
@export var sprite : AnimatedSprite2D
@export var object_target : AreaDoor
var state : String = "idle"
var orientation : int = 0
var spd : float = 0.001

func _ready() -> void:
	##Randomize starting orientation e.g. facing left or right
	randomize()
	orientation = randi_range(1,2)
	match orientation:
		1: sprite.frame = 0
		2: sprite.frame = 2
	await get_tree().create_timer(0.5).timeout
	##Fly away once our target object state changes
	if object_target:
		object_target.open.connect(flee)
	else:
		%HitboxComponent.enemy_alert.connect(flee)

func flee():
	sprite.play("fly")
	state = "flee"

func _process(delta: float) -> void:
	match state:
		"idle": pass
		"flee": 
			if orientation == 1: ##Fly right
				self.position += Vector2(spd,-spd*2)/delta
			else: ## Fly left
				sprite.flip_h = true
				self.position += Vector2(-spd,-spd*2)/delta
			spd += 0.001
