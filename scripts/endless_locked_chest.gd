extends Node2D
var player_contact : bool = false
var unlocked : bool = false

func _ready() -> void:
	if GameState.endless["all_boons_obtained"] == 1:
		queue_free()
		print("All buffs obtained; disabling boon chest")
	else:
		%ChestSprite.play("default")
		%ChestLabel.text = Localize.endless_chest

func give_boon():
	var selection : int = 0
	randomize()
	selection = randi_range(0,7)
	match selection:
		0:
			if GameState.endless["boon_sun"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_sun"] = 1
				%ChestLabel.text = Localize.endless_sun_boon+"
				"+Localize.endless_sun_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll
		1:
			if GameState.endless["boon_mercury"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_mercury"] = 1
				%ChestLabel.text = Localize.endless_mercury_boon+"
				"+Localize.endless_mercury_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll
		2:
			if  GameState.endless["boon_venus"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_venus"] = 1
				%ChestLabel.text = Localize.endless_venus_boon+"
				"+Localize.endless_venus_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: 
				give_boon() #reroll
		3:
			if GameState.endless["boon_moon"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_moon"] = 1
				%ChestLabel.text = Localize.endless_moon_boon+"
				"+Localize.endless_moon_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: 
				give_boon() #reroll
		4:
			if GameState.endless["boon_mars"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_mars"] = 1
				%ChestLabel.text = Localize.endless_mars_boon+"
				"+Localize.endless_mars_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll
		5:
			if GameState.endless["boon_jupiter"] == 0:
				BgmController.success_jingle.play()
				GameState.endless["boon_jupiter"] = 1
				%ChestLabel.text = Localize.endless_jupiter_boon+"
				"+Localize.endless_jupiter_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll
		6:
			if GameState.endless["curse_saturn"] == 0:
				Sound.samael("laugh_ominous")
				GameState.target_player.anim_parry()
				GameState.endless["curse_saturn"] = 1
				%ChestLabel.text = Localize.endless_saturn_boon+"
				"+Localize.endless_saturn_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll
		7:
			if GameState.endless["curse_void"] == 0:
				GameState.playerEfficiency += 1
				Sound.samael("laugh_ominous")
				GameState.endless["curse_void"] = 1
				%ChestLabel.text = Localize.endless_void_boon+"
				"+Localize.endless_void_desc
				await get_tree().create_timer(3).timeout #IMPORTANT 
				%ChestLabel.visible = false
			else: give_boon() #reroll

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !unlocked:
		Sound.textPopup()
		%ChestInteractSprite.visible = true
		player_contact = true

func _process(_delta: float) -> void:
	if player_contact:
			if Input.is_action_just_pressed("ui_accept") and player_contact and !unlocked:
				if GameState.woodsDict["woodsKey"] == 1:
					give_boon()
					unlocked = true
					%ChestSprite.play("open")
					GameState.woodsDict["woodsKey"] = 0
					GameState.target_player.anim_key()
					%ChestInteractSprite.visible = false
				else:
					Localize.reference_dialogue("EndlessKeyRequired")
					player_contact = false
					%ChestInteractSprite.visible = false

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_contact = false
	%ChestInteractSprite.visible = false
