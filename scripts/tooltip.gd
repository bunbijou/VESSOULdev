class_name KeyHint extends Node2D
@export var position_override : Vector2

func _ready() -> void:
	%tipLabel.visible = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	match GameState.woodsDict["woodsKey"]:
		0: #No Key
			%tipLabel.visible = true
			await get_tree().create_timer(5).timeout
			%tipLabel.visible = false
			%tipLabel.text = "Key Required"
		1: #Has Key
			doorOpen()
			GameState.woodsDict["woodsKey"]= 2 #door condition fulfilled
			%tipLabel.text = "To Church Town"
		2: #Key used
			doorOpen()
			%tipLabel.text = "To Church Town"

func doorOpen():
	GameState.target_player.waiting = true
	LevelTransition.animation_player.current_animation = "fadeout"
	Sound.DoorOpen("town","open")
	await get_tree().create_timer(3).timeout
	Sound.DoorOpen("town","close")
	GameState.playerCurrentLocation = position_override
	#Maintain the player HP state between scenes
	GameState.player_hp_previous = GameState.playerHP
	GameState.target_player.waiting = false
	get_tree().change_scene_to_file("res://town.tscn")
	LevelTransition.animation_player.current_animation = "fadein"
