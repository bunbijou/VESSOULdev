class_name WarpSpecial extends Area2D


@export var anim : AnimationPlayer
@export var my_sprite : AnimatedSprite2D
@export var myLabel : Label
@export var overridePlayerPosition = false
@export var newPlayerCoord : Vector2
##For demo use only
@export var override : bool = false
var miniBossScene : String = "res://lenore.tscn"

func _ready() -> void:
	anim.current_animation = "hidden"

func _process(_delta: float) -> void:
	if !override:
		if GameState.abyssDict["abyssBoss"][0] == 1: #if abyss presence defeated
			anim.current_animation = "black"
			if GameState.abyssDict["abyssBoss"][1] == 1: #if lenore defeated
				anim.current_animation = "hidden"
	else: anim.current_animation = "black"

func _on_body_entered(_body: Node2D) -> void:
		if GameState.abyssDict["abyssBoss"][0] == 1: #if abyss presence defeated
			GameState.playerCurrentLocation = Vector2(0,0)
			LevelTransition.animation_player.current_animation = "fadeout"
			toMiniBoss()
		else: 
			if override:
				GameState.playerCurrentLocation = Vector2(0,0)
				LevelTransition.animation_player.current_animation = "fadeout"
				toMiniBoss()
			else: print("Lenore warp condition not met")

func toMiniBoss():
		Sound.warp()
		#Maintain the player HP state between scenes
		GameState.player_hp_previous = GameState.playerHP
		get_tree().call_deferred("change_scene_to_file",miniBossScene)
		LevelTransition.animation_player.current_animation = "fadein"
