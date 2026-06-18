extends Node2D
@export var current_zone : int = 999
@export var interval_hi_lo : Array = [0.5, 5]
@export var hole : Sprite2D
var enemy = preload("res://scenes/enemy_motemouse.tscn")
var can_spawn : bool = true
var active : bool = false

func _process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone and active:
		if can_spawn:
			spawn_mouse()

func spawn_mouse():
	var mouse_instance = enemy.instantiate()
	randomize()
	can_spawn = false
	await get_tree().create_timer(randi_range(interval_hi_lo[0],interval_hi_lo[1])).timeout 
	if !get_tree().paused:
		add_child(mouse_instance)
		mouse_instance.position = hole.position
		mouse_instance.current_zone = current_zone
		mouse_instance.z_index = self.z_index+1
	can_spawn = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	active = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	active = false
