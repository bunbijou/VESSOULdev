class_name AbyssSnail extends Node2D
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var sprite : AnimatedSprite2D
@export var hide_time : int = 10
@export var point_a : Vector2
@export var point_b : Vector2
@export var speed : float = 1
var destination : String = "b"

func _ready() -> void:
	GameState.target_player.flashed.connect(snail_hide)

func _process(delta: float) -> void:
	if sprite.animation != "hide": #if not hiding
		if destination == "b": #default: go to point_b
			self.position.x += speed*delta
			#self.scale = Vector2(0.5,0.5)
			sprite.flip_h = false
		
		if self.position >= point_b:
			destination = "a" #switch goal
		
		if destination >= "a":
			self.position.x -= speed*delta
			#self.scale = Vector2(-0.5,0.5)
			sprite.flip_h = true
			if self.position == point_a:
				destination = "b"
	

func snail_hide():
	if sprite.animation != "hide":
		sprite.animation = "hide"
		await get_tree().create_timer(hide_time).timeout
		snail_emerge()

func snail_emerge():
	sprite.animation = "emerge"
	await get_tree().create_timer(.5).timeout
	sprite.animation = "default"
