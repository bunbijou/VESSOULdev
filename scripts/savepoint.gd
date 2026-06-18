class_name SavePoint extends Node2D

@export var myTarget : Node2D 
var locked : bool = false
var can_interact : bool  = false
var player_contact : bool = false

func _ready() -> void:
	GameState.game_saved.connect(enable)
	if myTarget: #will crash if is hidden and a target not assigned
		myTarget.death_rattle.connect(unlock)
		self.visible = false
		locked =  true

func unlock():
		self.visible = true
		locked = false

func enable():
	can_interact = true
	%InteractSprite.visible = true

func _process(_delta: float) -> void:
	if can_interact and player_contact and Input.is_action_just_pressed("ui_accept"):
			GameState.playerCurrentLocation = GameState.target_player.position
			Sound.menu("accept")
			##Game Manager function that essentially emits a signal that the GUI node responds to
			GameState.save_remote() #pass to gamestate which in turn passes to gui handler
			can_interact = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
		if !locked:
			player_contact = true
			Sound.menu("move")
			can_interact = true
			%InteractSprite.visible = true

func _on_my_area_2d_body_exited(_body: Node2D) -> void:
	player_contact = false
	Sound.menu("move")
	%InteractSprite.visible = false
	can_interact = false
