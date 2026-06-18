extends Node2D

signal item_get

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var current_zone = 0 #which zone i'm a part of, default 0
@export var locked = true #all 3 will have a condition where
@export_category("0 = Kindling, 1 = VesselBloom, 2 = Tome")
@export var item_type = 0 #0 = Kindling, 1 = VesselBloom, 2 = Tome
@export_category("Tome: 0 = Abyss, 1 = Woods, 2 = Town")
@export var item_subtype : int 
@export_category("Reward Conditions")
@export var required_souls : int #for chests
@export var required_kills : int #for flowers
@export var target_enemy : Node #when my targeted boss dies, enter give state
##For use in the demo; collecting glaze gives you extra flash charges
@export var demo : bool = false
var collected : bool = false
var beat : int = 1

#--------VESSELBLOOM-------#
func anim_bloom_lock():
	%myArea2D.set_deferred("monitoring", false)
	%AnimsVesselBloom.visible = true
	%AnimsVesselBloom.animation = "default"
	%VesselBloomOverlay.visible = false

func anim_bloom_unlock():
	%myArea2D.set_deferred("monitoring", true)
	%AnimsVesselBloom.visible = true
	%AnimsVesselBloom.play("open",1,false)
	%VesselBloomOverlay.visible = true
	%VesselBloomOverlay.play("open",1,false)

func anim_bloom_empty():
	%myArea2D.set_deferred("monitoring", false)
	%AnimsVesselBloom.visible = true
	%AnimsVesselBloom.animation = "passive"
	%VesselBloomOverlay.animation = "passive"
	
#--------------CHEST--------------#
func anim_chest_lock():
	%myArea2D.set_deferred("monitoring", false)
	%AnimsChest.visible = true
	%AnimsChest.animation = "default"

func anim_chest_unlock():
	if %AnimsChest.animation == "default" and locked:
		Sound.ChestOpen()
	%myArea2D.set_deferred("monitoring", true)
	%AnimsChest.visible = true
	%AnimsChest.animation = "open" 

func anim_chest_empty():
	%myArea2D.set_deferred("monitoring", false)
	%AnimsChest.visible = true
	%AnimsChest.animation = "passive" 
#--------------TOMES-----------------#
##Tomes function a little differently, so only two functions here
func anim_tome_hidden():
	%myArea2D.set_deferred("monitoring", false)
	%AnimsEnchantedTome.visible = false

func anim_tome_show():
	%myArea2D.set_deferred("monitoring", true)
	%AnimsEnchantedTome.visible = true
	match item_subtype:
		0: $AnimsEnchantedTome.animation = "default"
		1: $AnimsEnchantedTome.animation = "variantWoods"
		2: $AnimsEnchantedTome.animation = "variantTown"

func anim_item_info():
	%itemLabel.visible = true
	await get_tree().create_timer(beat*3.0).timeout
	%itemLabel.visible = false



func _ready() -> void:
	#cleaning up old/obsolete instances
	match item_type:
		0: #Kindling Chest
			match current_zone:
				5: #recluse cave
					if GameState.abyssDict["abyssKindling"][0] == 1: queue_free()
				6: #jari hideaway
					if GameState.abyssDict["abyssKindling"][1] == 1: queue_free()
				7: #acolyte labyrinth
					if GameState.abyssDict["abyssKindling"][2] == 1: queue_free()
				12: #ruiend fort
					if GameState.woodsDict["woodsKindling"][0] == 1: queue_free()
				15: #storm drain
					if GameState.woodsDict["woodsKindling"][1] == 1: queue_free()
				20: if GameState.townDict["townKindling"][0] == 1: queue_free()
				21: if GameState.townDict["townKindling"][1] == 1: queue_free()
				22: if GameState.townDict["townKindling"][2] == 1: queue_free()
				23: if GameState.townDict["townKindling"][3] == 1: queue_free()
				999: if GameState.townDict["townKindling"][4] == 1: queue_free()

		1: #VesselBlooms
			match current_zone:
				1: #Cave of Reflection
					if GameState.abyssDict["abyssBlooms"][0] == 1: queue_free()
				2: #Grave of a Hero
					if GameState.abyssDict["abyssBlooms"][1] == 1: queue_free()
				9: #Woods Gateway
					if GameState.woodsDict["woodsBlooms"] == 1: queue_free()
				18: #Town Bloom 1
					if GameState.townDict["townBlooms"][0] == 1: queue_free()
				-17: #Town Bloom 2
					if GameState.townDict["townBlooms"][1] == 1: queue_free()
		2: #Tomes
			match current_zone:
				3: #Antechamber
					if GameState.abyssDict["abyssTome"] == 1: queue_free()
				999: #Gaping Mawer Arena
					if GameState.woodsDict["woodsTome"] == 1: queue_free()
				24: #Censer
					if GameState.townDict["townTome"] == 1: queue_free()
	if item_type == 0 and item_subtype == 1: #if is a Glaze chest and player already has Glaze
		if GameState.abyssDict["abyssGlaze"] == 1: 
			GameState.abyssDict["abyssGlaze"] = 2 #turn into bonus chest
	if item_type == 0 and item_subtype == 2: #if is a Lid chest and player already has Lid
		if GameState.abyssDict["abyssLid"] == 1:
			GameState.abyssDict["abyssLid"] = 2 #turn into bonus chest
	
	##This just tells the player what they got / how to use it
	%itemLabel.visible = false
	
	if target_enemy:
		target_enemy.death_rattle.connect(target_defeated)
	
	match item_type: #All this stuff is cosmetic
		0: #Chest (Kindling / Pot Lid / Glaze)
			%AnimsVesselBloom.visible = false
			%AnimsEnchantedTome.visible = false
			if !locked:
				anim_chest_unlock()
			else: anim_chest_lock()
		1: #Vesselbloom
			%AnimsEnchantedTome.visible = false
			%AnimsChest.visible = false
			if !locked:
				anim_bloom_unlock()
			else: anim_bloom_lock()
		2: #Tome
			%AnimsChest.visible = false
			%AnimsVesselBloom.visible = false
			if !locked:
				anim_tome_show()
			else: anim_tome_hidden()

func _process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone:
		#Commented because I feel like generally, Chests should req. miniboss/boss or kills in general, whilst doors req. souls
		#if GameState.playerLifetimeSouls >= required_souls and required_souls > 0 and locked: #Soul Req (Unused)
			#locked = false #see below
			#%AnimsChest.animation = "open"
			#%AnimsVesselBloom.animation = "open"
			#%myArea2D.monitoring = true
		#else:
			if required_kills > 0 and GameState.playerKillCount >= required_kills and locked:
				locked = false #keeps this statement from repeating and overriding other anim. states
				anim_bloom_unlock()


func target_defeated():
	if !collected:
		match item_type:
			0: #Chest
				anim_chest_unlock()
			1: #Vesselbloom
				anim_bloom_unlock()
			2:  #Tome
				anim_tome_show()
	##See animation events
	#%myArea2D.monitoring = true

## On player touch
func _on_my_area_2d_body_entered(_body: Node2D) -> void:
	if GameState.target_player.current_zone == current_zone and !collected:
		match item_type:
			0: ##Chest
				match item_subtype:
					0: ## Chest - Kindling
						match current_zone:
							5: #recluse cave
								GameState.abyssDict["abyssKindling"][0] = 1
								print("Abyss Kindling 1/3 collected")
							6: #jari hideaway
								GameState.abyssDict["abyssKindling"][1] = 1
								print("Abyss Kindling 2/3 collected")
							7: #acolyte labyrinth
								GameState.abyssDict["abyssKindling"][2] = 1
								print("Abyss Kindling 3/3 collected")
							12: #Ruined Fort
								GameState.woodsDict["woodsKindling"][0] = 1
								print("Woods kindling 1/2 collected")
							15: #Storm Drain
								GameState.woodsDict["woodsKindling"][1] = 1
								print("Woods kindling 2/2 collected")
							20: 
								GameState.townDict["townKindling"][0] = 1
								print("Town kindling 1/5 collected")
							21: 
								GameState.townDict["townKindling"][1] = 1
								print("Town kindling 2/5 collected")
							22: 
								GameState.townDict["townKindling"][2] = 1
								print("Town kindling 3/5 collected")
							23: 
								GameState.townDict["townKindling"][3] = 1
								print("Town kindling 4/5 collected")
							999: ## Catacombs
								GameState.townDict["townKindling"][4] = 1
								print("Town kindling 5/5 collected")
						Sound.itemGet("kindling")
						GameState.bestowItem(0) #Kindling
						anim_item_info()
						%itemLabel.text = str(Localize.item_kindling)+" "+str(Localize.item_get_suffix)
						collected = 1
						
					1: ## Chest - Glaze
						#If glaze already collected in a past life
						if GameState.abyssDict["abyssGlaze"] == 2:
							print("Player got Mote Bonus (Glaze Already Acquired)")
							Sound.PlayerFlash() #placeholder
							%MoteExplosion.emitting = true
							anim_item_info()
							%itemLabel.text = str(Localize.item_mote)+" "+str(Localize.item_bonus_suffix)+"
							"+str(Localize.item_motes_plural)+" +"+str(50+(50*GameState.newgame))
							GameState.playerActiveSouls += (50+(50*GameState.newgame))
							collected = 1
							await get_tree().create_timer(0.5).timeout
							GameState.target_player.anim_mote_absorb()
						else:
							if GameState.abyssDict["abyssGlaze"] == 0:
								Localize.reference_dialogue("GameFlash")
							GameState.abyssDict["abyssGlaze"] = 1
							BgmController.success_jingle.play()
							print("Player acquired Glaze")
							GameState.bestowItem(-1) #Glaze
							anim_item_info()
							%itemLabel.text = str(Localize.item_glaze)+" "+str(Localize.item_get_suffix)
							#+str(Localize.item_glaze_hint)
							collected = 1
							if demo: GameState.playerActiveSouls += 5*GameState.playerFlashMin
					2: ## Chest - Pot Lid
						#If lid already collected in a past life
						if GameState.abyssDict["abyssLid"] == 2:
							print("Player got Mote Bonus (Lid Already Acquired)")
							GameState.target_player.anim_mote_absorb()
							anim_item_info()
							%itemLabel.text = str(Localize.item_mote)+" "+str(Localize.item_bonus_suffix)+"
							"+str(Localize.item_motes_plural)+" +"+str(100+(100*GameState.newgame))
							GameState.playerActiveSouls += (100+(100*GameState.newgame))
							collected = 1
						else:
							print("Player got Pot Lid")
							BgmController.success_jingle.play()
							GameState.bestowItem(-2) #Pot Lid
							anim_item_info()
							%itemLabel.text = str(Localize.item_lid)+" "+str(Localize.item_get_suffix)+"
							"+str(Localize.item_lid_hint)
							GameState.abyssDict["abyssLid"] = 1
							collected = 1
				anim_chest_empty()
				current_zone = -999 #workaround to keep player from getting items repeatedly from the same chest
				collected = 1
			1: ##Vesselbloom
				match current_zone:
					1: #Cave of Reflection
						GameState.abyssDict["abyssBlooms"][0] = 1
						print ("Abyss Bloom 1/2 Collected")
					2: #Grave of a Hero
						GameState.abyssDict["abyssBlooms"][1] = 1
						print ("Abyss Bloom 2/2 Collected")
					9: #Woods Gateway
						GameState.woodsDict["woodsBlooms"] = 1
						print("Woods Bloom 1/1 Collected")
					18: #Town 1
						GameState.townDict["townBlooms"][0] = 1
						print("Town Bloom 1/2 Collected")
					-17: #Town 2
						GameState.townDict["townBlooms"][1] = 1
						print("Town Bloom 2/2 Collected")
				Sound.itemGet("bulb")
				anim_bloom_empty()
				GameState.bestowItem(1) #BloomBulb
				current_zone = -999
				anim_item_info()
				%itemLabel.text = str(Localize.item_bloombulb)+" "+str(Localize.item_get_suffix)
				collected = 1
			2: ##Tome
				match item_subtype:
					0: 
						GameState.abyssDict["abyssTome"] = 1
						GameState.bestowItem(2) #Tome - Amphora
						anim_item_info()
						%itemLabel.text = str(Localize.item_tome_abyss)+" "+str(Localize.item_get_suffix)
					1: 
						#if GameState.woodsDict["woodsTome"] == 0: #function unclear
						GameState.woodsDict["woodsTome"] = 1
						GameState.bestowItem(3) #Tome - Gaping Jawer
						anim_item_info()
						%itemLabel.text = str(Localize.item_tome_woods)+" "+str(Localize.item_get_suffix)
					2: 
						GameState.townDict["townTome"] = 1
						GameState.bestowItem(4) #Tome - Censer
						anim_item_info()
						%itemLabel.text = str(Localize.item_tome_town)+" "+str(Localize.item_get_suffix)
				Sound.itemGet("tome")
				anim_tome_hidden()
				current_zone = -999
				collected = 1
		item_get.emit()
		GameState._save(GameState.playerCurrentLocation,str(get_tree().current_scene.name))
		print("Game was saved following item collection")
