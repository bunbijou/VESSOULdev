class_name ItemHumanity extends Node2D

signal death_rattle

@export var bossTarget : Node2D
@export var target_npc : Node2D
var unlocked = false

func _ready() -> void:
	if GameState.favor == 1: #if humanity already collected
		cleanup()
	else: 
		self.visible = false
		if bossTarget:
			bossTarget.death_rattle.connect(unlock)
		if target_npc:
			target_npc.unlock_humanity.connect(unlock)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if unlocked:
		##Achievement: Humanity gained
		GameState.target_player.anim_achievement("a_humanity_obtained")
		GameState.target_player.show_sidebar()
		Sound.enemy_slain()
		GameState.target_player.anim_humanity_gained()
		GameState.abyssDict["abyssBoss"][1] = 1 #register boss completion
		GameState.favor = 1
		GameState.mote_reward(GameState.reward_lenore,0,"big")
		#Defer to stored player location and scene
		GameState._save(GameState.playerCurrentLocation,GameState.playerActiveScene)
		print("Game was saved following favor gain")
		cleanup()
	else: print ("Humanity condition not met")

func unlock():
	self.visible = true
	unlocked = true

func cleanup():
	print("Cleaned up Humanity item (condition already met)")
	death_rattle.emit() #spawn warp portal
	queue_free()
