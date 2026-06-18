class_name IllusoryWall extends Node

@export var mySprite : AnimatedSprite2D 
@export var current_zone : int = 999 
@export var my_fog_particle : CPUParticles2D

func _ready():
	GameState.target_player.flashed.connect(_flash)
	self.visible = true
	if my_fog_particle:
				my_fog_particle.emitting = true
	#Clean up obsolete instances
	match current_zone:
		0: #Start, see below
			if GameState.abyssDict["abyssBonusR"][0] == 1:
				queue_free()
		5: #Recluse's Cave
			if GameState.abyssDict["abyssBonusR"][0] == 1:
				queue_free()
		#-------------------PAIRED -------------------------#
		1: #Cave reflection, see below
			if GameState.abyssDict["abyssBonusR"][1] == 1:
				queue_free()
		6: #jari's hideaway
			if GameState.abyssDict["abyssBonusR"][1] == 1:
				queue_free()
		#-------------------PAIRED -------------------------#
		2: #Hero's grave, see below
			if GameState.abyssDict["abyssBonusR"][2] == 1:
				queue_free()
		7: #acolyte's cave
			if GameState.abyssDict["abyssBonusR"][2] == 1:
				queue_free()
		#-------------------PAIRED -------------------------#
		9: #town gate preceding bonus room
			if GameState.woodsDict["woodsBonusR"][0] == 1:
				queue_free()
		15: #storm drain
			if GameState.woodsDict["woodsBonusR"][0] == 1:
				queue_free()
		#-------------------PAIRED -------------------------#
		11: #pumpkin patch
			if GameState.woodsDict["woodsBonusR"][1] == 1:
				queue_free()
		14: #great tree stump
			if GameState.woodsDict["woodsBonusR"][1] == 1:
				queue_free()
		#-------------------PAIRED -------------------------#
		-17:
			if GameState.townDict["townBonusR"][0] == 1:
				queue_free()
			if GameState.townDict["townBonusR"][1] == 1:
				queue_free()
		18: 
			if GameState.townDict["townBonusR"][2] == 1:
				queue_free()
			if  GameState.townDict["townBonusR"][3] == 1:
				queue_free()
		
func _flash():
	match GameState.target_player.current_zone: #check which zone the player's in
		current_zone: #if it matches my home zone, do stuff
			if my_fog_particle:
				my_fog_particle.emitting = false
			BgmController.success_jingle.play()
			mySprite.play("fade")
			#await get_tree().create_timer(3).timeout
			wallCleared()
			await get_tree().create_timer(1).timeout
			queue_free()

func wallCleared():
	match current_zone:
		0:
			GameState.abyssDict["abyssBonusR"][0] = 1
			print("Abyss Illusory Wall 1 Cleared")
		1:
			GameState.abyssDict["abyssBonusR"][1] = 1
			print("Abyss Illusory Wall 2 Cleared")
		2:
			GameState.abyssDict["abyssBonusR"][2] = 1
			print("Abyss Illusory Wall 3 Cleared")
		9:
			GameState.woodsDict["woodsBonusR"][0] = 1
			print("Woods Illusory wall 1 cleared")
		11:
			GameState.woodsDict["woodsBonusR"][1] = 1
			print("Woods Illusory wall 2 cleared")
		-17:
			GameState.townDict["townBonusR"][0] = 1
			GameState.townDict["townBonusR"][1] = 1
			print("Town Illusory wall 1 and 2 cleared")
		18:
			GameState.townDict["townBonusR"][2] = 1
			GameState.townDict["townBonusR"][3] = 1
			print("Town Illusory Wall 3 and 4 cleared")
		
