class_name BounceMushroom extends Node2D

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
#@export var current_zone = 999
#@export var push_force_horizontal : float
#@export var push_force_vertical : float
#var active : bool = false
#var power_x : float = 0
#var power_y : float = 0

#func anim_bounce():
	#%AnimatedSprite2D.animation = "active"#
#
#func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if !active and !GameState.target_player.dead: #ideally keeps this from occuring more than once, but am getting animation issues
		#anim_bounce()
		#power_x = push_force_horizontal
		#power_y = push_force_vertical
		#active = true
		##GameState.target_player.velocity.x += push_force_horizontal
		##GameState.target_player.velocity.y -= push_force_vertical
		##GameState.target_player.dead = true
		##await get_tree().create_timer(effect_time).timeout
		##GameState.target_player.dead = false
		##active = false
#
#
#func _physics_process(_delta: float) -> void:
	#if active:
		#if power_x > 0:
			#GameState.target_player.position.x += power_x
			#power_x -= 1
		#
		#if power_y > 0:
			#GameState.target_player.position.y -= power_y
			#power_y -= 1
#
#
#func _on_area_2d_body_exited(_body: Node2D) -> void:
	#active = false
