extends Node2D
@export var origin : AnimatedSprite2D 
@export var current_zone : int = 999
@export var interval_hi_lo : Array = [5, 10]
var can_spawn : bool = true
var enemy : PackedScene = preload("res://scenes/enemy_lil_jawer.tscn")
var initial : bool = true

func play_anim(type : String):
	match type:
		"show":
			Sound.jawer("warcry") #placeholder
			origin.visible = true
		"hide":
			Sound.jawer("death") #placeholder
			origin.visible = false

func _ready() -> void:
	origin.visible = false

func _process(_delta: float) -> void:
	if GameState.shadeActive == true and GameState.target_player.current_zone == current_zone:
		if origin.visible == false:
			play_anim("show")
		if can_spawn:
			spawn_enemy()
		else:
			%DarknessParticles.emitting = true
	else:
		if origin.visible != false:
			play_anim("hide")

func spawn_enemy():
	var lil_jawer_instance = enemy.instantiate()
	can_spawn = false
	if !initial:
		await get_tree().create_timer(randi_range(interval_hi_lo[0],interval_hi_lo[1])).timeout
	else: initial = false
	%DarknessParticles.emitting = true
	add_child(lil_jawer_instance)
	lil_jawer_instance.position = origin.position
	lil_jawer_instance.current_zone = current_zone
	lil_jawer_instance.z_index = 100
	can_spawn = true
