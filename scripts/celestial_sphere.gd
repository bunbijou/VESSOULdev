extends Node2D

@export var delay : float
@export var sprite : AnimatedSprite2D
@export var anim : AnimationPlayer
@onready var target_enemy : BossForsaken = %Forsaken
@export var target_position : Vector2
@export var sphere_wait_time : float = 10
#var add_damage : int
var activated : bool = false

func _ready() -> void:
	#add_damage = int((GameState.playerBaseHP/2))#-1)
	self.visible = false
	target_enemy.cast_sphere.connect(active)

func active():
	self.visible = true
	anim.current_animation = "descend"
	activated = true

func nuke():
	GameState.anim_rumble(5,10)
	Sound.sanctuary_destroy()
	GameState.target_player.isHurt(int(GameState.playerBaseHP/2))
	LevelTransition.fadeToWhite()
	await get_tree().create_timer(sphere_wait_time).timeout
	if !GameState.target_player.dead:
		target_enemy.fadeout() ## Pass to boss handler

func conceal():
	anim.current_animation = "reset"
	self.visible = false
