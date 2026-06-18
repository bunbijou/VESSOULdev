extends Node2D
var player_contact : bool = false

func anim_gold_basin():
	if GameState.endless["boon_sun"] == 1:
		%GoldBasin.visible = true
		if GameState.endless["stored_motes"] != 0:
			%GoldBasin.play("default",1)
		else: %GoldBasin.play("default",0)
	else: %GoldBasin.visible = false

func anim_basin_mote():
	if GameState.endless["stored_motes"] == 0:
		%BasinMote.visible = false
	else: %BasinMote.visible = true

func _ready() -> void:
	%BasinLabel.text = Localize.endless_bowl

func _on_area_2d_body_entered(_body: Node2D) -> void:
	Sound.textPopup()
	%BasinInteractSprite.visible = true
	player_contact = true

func _process(_delta: float) -> void:
	anim_gold_basin()
	anim_basin_mote()
	if Input.is_action_just_pressed("ui_accept") and player_contact:
		Localize.mote_basin_interface("Interact", GameState.endless["stored_motes"])
		player_contact = false

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_contact = false
	%BasinInteractSprite.visible = false
