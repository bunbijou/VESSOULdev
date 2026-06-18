class_name DouserSplash extends Node2D

@export var hit_area : HitboxComponent
@export var speed : float = 0.25
var active = true
var destination : Vector2

func _ready() -> void:
	#destination = GameState.target_player.position
	#if self.position.x <= destination.x:
		#self.position.x += splash_offset
		#self.scale = Vector2(-0.5,-0.5)
	#else: 
		#self.position.x -= splash_offset
		#self.scale = Vector2(0.5,0.5)
	await get_tree().create_timer(1.5).timeout
	dissipate()

#func _physics_process(_delta: float) -> void:
	#if self.position.x < destination.x: #if player is to the right
		#self.position.x += speed #move right
	#else: 
		#self.position.x -= speed #if player is to the left, move left
	#if self.position.y < GameState.target_player.position.y: #if player is below us
		#self.position.y += speed #move down on Y axis
	#else:
		#if self.position.y >= GameState.target_player.position.y: #if player is above us
			#self.position.y -= speed #move up on Y axis

func dissipate(): 
	if active:
		active = false
		queue_free()

func _on_splash_hitbox_body_entered(_body: PlayerVessel) -> void:
	GameState.target_player.is_doused()
	dissipate()
