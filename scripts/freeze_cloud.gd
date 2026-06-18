class_name FreezeCloud extends Node2D

@export var hit_area : HitboxComponent
@export var speed : float = 0.1
@export var my_sprite : AnimatedSprite2D
var destination : Vector2
var active = true

func _ready() -> void:
	%FlashComponent.flash_detected.connect(dissipate)
	await get_tree().create_timer(11).timeout
	dissipate()

func _process(_delta: float) -> void:
	if GameState.target_player.temperature == "cold": 
		dissipate()
	if self.position == destination:
		speed = 0

func _physics_process(_delta: float) -> void:
		if self.position.y < destination.y: #if player is below us
			self.position.y += speed #move down on Y axis
		else:
			if self.position.y >= destination.y: #if player is above us
				self.position.y -= speed #move up on Y axis
			
		if self.position.x < destination.x: #if player is to the right
			self.position.x += speed #move right
		else: 
			self.position.x -= speed #if player is to the left, move left

func dissipate(): 
	if active:
		active = false
		speed = 0
		my_sprite.play("dispel")
		await get_tree().create_timer(.5).timeout
		queue_free()

func _on_cloud_hitbox_body_entered(_body: Node2D) -> void:
	if active:
		#hit_area._on_player_touch(0) # do the on-touch effect
		dissipate()
