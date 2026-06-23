extends Node2D
@export_enum("bloombulb","glaze","humanity","key","kindling","lid","teddybear","tome_abyss","tome_town","tome_woods","rare_bulb","rare_tome","rare_scale","glaze_upgrade") var type : String
var bloombulb_cost : int = 0
var glaze_cost : int = 0
var extra_coat_cost : int = 0
var humanity_cost : int = 0
var key_cost : int = 0
var shard_cost : int = 0
var kindling_cost : int = 0
var lid_cost : int = 0
var teddy_cost : int = 0
var tome_cost : int = 0
var rare_bulb_cost : int = 0
var rare_tome_cost : int = 0
var rare_scale_cost : int = 0
var rare_cost_mod : float = .10
@export var item_a : Node2D
@export var item_b : Node2D
@export var label_top : Label
@export var label_bottom : Label
var player_contact : bool = false
@export var override : bool = false
@export var debug : bool = true
var collected : bool = false
var cost : int = 0

## check if it's the players first time
func _ready() -> void:
	var restorative_item_cost_mod : int = 0
	if GameState.endless["curse_saturn"] == 1 and GameState.endless["curse_void"] == 0:
		restorative_item_cost_mod = 1
	if GameState.endless["curse_saturn"] == 0 and GameState.endless["curse_void"] == 1:
		restorative_item_cost_mod = 1
	if GameState.endless["curse_saturn"] == 1 and GameState.endless["curse_void"] == 1:
		restorative_item_cost_mod = 2
	
	@warning_ignore("narrowing_conversion")
	bloombulb_cost = 50+(25*(GameState.playerBaseHP+GameState.playerCapacityAdd))
	glaze_cost = 150
	extra_coat_cost = 250*(GameState.abyssDict["abyssGlaze"]+GameState.playerDamageAdd)
	@warning_ignore("narrowing_conversion")
	humanity_cost = 10+(10*GameState.playerBaseHP)+(500+restorative_item_cost_mod)
	key_cost = 100+(100*(GameState.endless["boon_sun"]+GameState.endless["boon_mercury"]+GameState.endless["boon_venus"]+GameState.endless["boon_moon"]+GameState.endless["boon_mars"]+GameState.endless["boon_jupiter"]))
	@warning_ignore("narrowing_conversion")
	shard_cost = 1+(1*GameState.playerBaseHP)
	kindling_cost = 100+(50*GameState.playerIntensity)
	lid_cost = 150
	teddy_cost = 100
	tome_cost = 200+(50*GameState.playerEfficiency) #was 400
	@warning_ignore("narrowing_conversion")
	rare_bulb_cost = bloombulb_cost*2.5
	@warning_ignore("narrowing_conversion")
	rare_tome_cost = tome_cost*2.5
	rare_scale_cost = kindling_cost*3
	%InteractSprite.visible = false
	reroll()

## check to make sure my item is different than my neighbor's item
func _process(_delta: float) -> void:
	##Venus buff enables duplicate items in the shop
	if GameState.endless["boon_venus"] != 1:
		if item_a:
			if type == item_a.type:
				reroll()
		if item_b:
			if type == item_b.type:
				reroll()
		
	if Input.is_action_just_pressed("ui_accept") and player_contact:
		if cost <= GameState.playerLifetimeSouls:
			give()
			GameState.playerLifetimeSouls -= cost
		else: 
			_on_area_2d_body_exited(%Player)
			Localize.reference_dialogue("BarrelbyNoMotes")

## set item properties
func reroll():
	var selection : int = 0
	var rare_selection : int = 0
	if !override:
		randomize()
		selection = randi_range(0,12)
	else:
		match type:
			"bloombulb": selection = 0
			"glaze": selection = 1
			"humanity": selection = 2
			"key": selection = 3
			"kindling": selection = 4
			"lid": selection = 5
			"tome_town": selection = 6
			"tome_abyss": selection = 7
			"tome_woods": selection = 8
			"teddybear": selection = 9
			"rare_bulb": selection = 10
			"rare_scale": selection = 11
			"rare_tome": selection = 12
	match selection:
		0:  ##Bloombulb
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "bloombulb"
			cost = bloombulb_cost
			label_bottom.text = Localize.item_bloombulb+"
			"+Localize.endless_bloombulb_desc
		1:  ##Ceramic Glaze / Extra Coat
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "glaze"
			## Base Glaze
			if GameState.abyssDict["abyssGlaze"] == 0:
				cost = glaze_cost
				label_bottom.text = Localize.item_glaze+"
			"+Localize.item_glaze_hint
			else: ##Glaze Upgrade (was 900)
				type = "glaze_upgrade"
				%SpriteRare.visible = true
				%Pedestal.play("rare")
				cost = extra_coat_cost
				label_bottom.text = Localize.endless_item_glaze+"
			"+Localize.endless_glaze_desc
		2: ##Curative Scroll
			type = "humanity"
			cost = humanity_cost
			label_bottom.text = Localize.endless_item_humanity+"
			"+Localize.endless_humanity_desc
			%SpriteRare.visible = true
			%Pedestal.play("rare")
		3: ## Small Key
			if GameState.endless["all_boons_obtained"] == 0:
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "key"
				cost = key_cost
				label_bottom.text = Localize.endless_item_key+"
				"+Localize.endless_key_desc
			else: 
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "rubbish"
				cost = shard_cost
				label_bottom.text = Localize.endless_item_junk+"
				"+Localize.endless_junk_desc
		4: ## Kindling Bundle
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "kindling"
			cost = kindling_cost
			label_bottom.text = Localize.item_kindling+"
			"+Localize.endless_kindling_desc
		5:
			if GameState.abyssDict["abyssLid"] == 0:
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "lid"
				cost = lid_cost
				label_bottom.text = Localize.item_lid+"
			"+Localize.endless_lid_desc
			else: 
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "rubbish"
				cost = shard_cost
				label_bottom.text = Localize.endless_item_junk+"
				"+Localize.endless_junk_desc
		6: 
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "tome_town"
			cost = tome_cost
			label_bottom.text = Localize.item_tome_town+"
			"+Localize.endless_tome_desc
		7: 
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "tome_abyss"
			cost = tome_cost
			label_bottom.text = Localize.item_tome_abyss+"
			"+Localize.endless_tome_desc
		8: 
			%SpriteRare.visible = false
			%Pedestal.play("default")
			type = "tome_woods"
			cost = tome_cost
			label_bottom.text = Localize.item_tome_woods+"
			"+Localize.endless_tome_desc
		9: 
			if GameState.favor != 2:
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "teddybear"
				cost = teddy_cost
				label_bottom.text = Localize.endless_item_teddybear+"
				"+Localize.endless_teddybear_desc
			else: 
				%SpriteRare.visible = false
				%Pedestal.play("default")
				type = "rubbish"
				@warning_ignore("narrowing_conversion")
				cost = shard_cost
				label_bottom.text = Localize.endless_item_junk+"
				"+Localize.endless_junk_desc
		10: #Rare Bulb
			randomize()
			rare_selection = randi_range(0,1)
			if rare_selection == 0: ##No rare
				print("Player failed Rare Bloombulb roll")
				reroll()
			else:
				if GameState.npcDict["jari"] != 999:
					%SpriteRare.visible = true
					%Pedestal.play("rare")
					type = "rare_bulb"
					cost = rare_bulb_cost
					label_bottom.text = Localize.endless_rare_bulb+"
				"+Localize.endless_rare_bulb_desc
				else:
					print("Player already has Big Bloombulb")
					reroll()
		11: #Rare Tome
			randomize()
			rare_selection = randi_range(0,1)
			if rare_selection == 0: ##No rare
				print("Player failed Rare Tome roll")
				reroll()
			else:
				if GameState.npcDict["sculptor"] != 999:
					%SpriteRare.visible = true
					%Pedestal.play("rare")
					type = "rare_tome"
					cost = rare_tome_cost
					label_bottom.text = Localize.endless_rare_tome+"
			"+Localize.endless_rare_tome_desc
				else:
					print("Player already has Grimoire")
					reroll()
		12: #Rare Kindling
			randomize()
			rare_selection = randi_range(0,1)
			if rare_selection == 0: ##No rare
				print("Player failed Rare Kindling roll")
				reroll()
			else:
				if GameState.npcDict["zn"] != 999:
					%SpriteRare.visible = true
					%Pedestal.play("rare")
					type = "rare_scale"
					cost = rare_scale_cost
					label_bottom.text = Localize.endless_rare_scale+"
			"+Localize.endless_rare_scale_desc
				else:
					print("Player already has Chimera Scale")
					reroll()
	if debug:
		cost = 0
	if override:
		cost = 0
	else:
		@warning_ignore("integer_division")
		cost = cost*(1+(GameState.newgame/10))
		if GameState.endless["boon_moon"] == 1: #lailun's buff reduces shop prices
			@warning_ignore("narrowing_conversion")
			cost = cost*0.5
	label_top.text = "• × "+str(cost)
	%AnimSprite2D.play(type)

## give player the item's stat boost
func give():
	BgmController.success_jingle.play()
	match type:
		"bloombulb": 
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.playerCapacity += 1
			await get_tree().create_timer(0.1).timeout
			GameState.healMe(1)
		"glaze": 
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.abyssDict["abyssGlaze"] = 1
		"glaze_upgrade":
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.playerDamageAdd += 1
		"humanity":  ##now "Curative Scroll"
			var side_effect : int = 0
			if GameState.endless["curse_saturn"] == 1 or GameState.endless["curse_void"] == 1:
				GameState.endless["curse_saturn"] = 0
				GameState.endless["curse_void"] = 0
				BgmController.success_jingle.play()
			GameState.target_player.anim_heal()
			GameState.fullHeal()
			side_effect = randi_range(1,10)
			if side_effect == 10:
				##Negative effect
				if GameState.endless["boon_sun"] == 1:
					GameState.endless["boon_sun"] = 0
					%EndlessConfig.anim_banner_info("cure_backfire",5)
				else:
					if GameState.endless["boon_mercury"] == 1:
						GameState.endless["boon_mercury"] = 0
						%EndlessConfig.anim_banner_info("cure_backfire",5)
					else:
						if GameState.endless["boon_moon"] == 1:
							GameState.endless["boon_moon"] = 0
							%EndlessConfig.anim_banner_info("cure_backfire",5)
						else:
							if GameState.endless["boon_mars"] == 1:
								GameState.endless["boon_mars"] = 0
								%EndlessConfig.anim_banner_info("cure_backfire",5)
							else:
								if GameState.endless["boon_jupiter"] == 1:
									GameState.endless["boon_jupiter"] = 0
									%EndlessConfig.anim_banner_info("cure_backfire",5)
								else: ##No side effects
									%EndlessConfig.anim_banner_info("cure_success",5)
			else: ##No side effects
				%EndlessConfig.anim_banner_info("cure_success",5)
		"key": 
			GameState.target_player.anim_key()
			Sound.key_drop()
			GameState.woodsDict["woodsKey"] = 1
		"kindling": 
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.playerIntensity += 1
		"lid": 
			GameState.target_player.show_sidebar()
			GameState.abyssDict["abyssLid"] = 2
		"rubbish":
			GameState.fullHeal() #formerly heal(1)
		"tome_abyss": 
			Sound.upgrade("sculptor")
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_enchant()
			GameState.target_player.anim_sparkle()
			GameState.playerEfficiency += 1
		"tome_woods": 
			Sound.upgrade("sculptor")
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_enchant()
			GameState.target_player.anim_sparkle()
			GameState.playerEfficiency += 1
		"tome_town": 
			Sound.upgrade("sculptor")
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_enchant()
			GameState.target_player.anim_sparkle()
			GameState.playerEfficiency += 1
		"teddybear":
			Sound.lenore("teddy")
			GameState.target_player.show_sidebar()
			GameState.favor = 2
		"rare_bulb":
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.npcDict["jari"] = 999
			GameState.playerCapacity += 3
			await get_tree().create_timer(.1).timeout
			GameState.fullHeal()
		"rare_tome":
			Sound.upgrade("sculptor")
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_parry()
			GameState.target_player.anim_sparkle()
			GameState.npcDict["sculptor"] = 999
			GameState.playerEfficiency += 2
		"rare_scale":
			GameState.target_player.show_sidebar()
			GameState.target_player.anim_sparkle()
			GameState.npcDict["zn"] = 999
			GameState.playerIntensity += 3
	GameState.stat_update()
	collected = true
	queue_free()

#when player gets close enough
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !collected:
		Sound.textPopup()
		player_contact = true
		%InteractSprite.visible = true

#when player moves away
func _on_area_2d_body_exited(_body: Node2D) -> void:
	if !collected:
		player_contact = false
		%InteractSprite.visible = false
