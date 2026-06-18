class_name AreaDoor extends Node2D

signal open

@export_enum("abyss","woods","town") var door_variant: String = "abyss"
@export var abyss_door_particle : CPUParticles2D
## controls collision state
@export var myAnimPlayer : AnimationPlayer
## controls visual appearance e.g. variants (boss door, etc.)
@export var mySprite : AnimatedSprite2D
## shows requirements to condition_met
#@export var myLabel : Label
## condition_met condition
@export_enum("kills", "souls", "bells") var requirement: String
## goal to reach condition_met state
@export var myGoal : int = 1
## area to monitor
@export var current_zone : int = 999
## whether to conceal on ready
@export var isHidden : bool = false
## whether to use boss graphic
@export var boss_Door : bool = false 
@export var target_enemy : Node2D
var condition_met : bool = false ## check whether to keep door locked or unlocked
var myCount = 0 ## active kill-count

func sfx(state : String):
	Sound.DoorOpen(door_variant,state)

func _ready() -> void:
	GameState.playerVictory.connect(incrementDeathTally) #only for Kill condition
	#myLabel.text = str(myGoal)
	if boss_Door:
		mySprite.animation = "boss"
		if target_enemy:
			target_enemy.death_rattle.connect(_boss_unlock)
	#	myLabel.visible = false
	else: mySprite.animation = "default"
	
	if isHidden:
		_unlock()

func _process(_delta: float) -> void:
	## Clear out Abyss doors after Amphora defeated
	if GameState.abyssDict["abyssMiniBoss"] == 1:
		get_tree().call_group("Abyss", "destroy")
	
	## Ditto, but for the Abyssoul boss arena doors
	if GameState.abyssDict["abyssBoss"][0] == 1:
		get_tree().call_group("Chasm", "destroy")
	
	## Ditto, but for Frenzied Growth
	if GameState.woodsDict["woodsBoss"] == 1:
		get_tree().call_group("Woods", "destroy")
	
	## Just for good measure, remove the Church Town doors if player has the bells
	if GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
		get_tree().call_group("Town", "destroy")
	
	if GameState.target_player.current_zone == current_zone and !condition_met:
			match requirement:
				"souls":
					if GameState.playerLifetimeSouls >= myGoal: #if goal met
						open.emit()
						condition_met = true
						_unlock()
				"kills":
					if myCount >= myGoal: #if goal met
						open.emit()
						condition_met = true
						_unlock()
	if hidden:
		if GameState.target_player.current_zone != current_zone: #until player enters, stay condition_met
			_unlock()
		else: _lock() #when player enters, close

###Door opening as a result of soul/kill requirements
#func door_criteria_met():
	#condition_met = true
	#_unlock()

## Door opening as a result of boss defeat
func _boss_unlock():
	condition_met = true
	_unlock()

func _lock():
	if !condition_met:
		if isHidden and mySprite.frame == 1:
			if abyss_door_particle:
				abyss_door_particle.emitting = true
			sfx("close")
		mySprite.visible = true
		myAnimPlayer.current_animation = "RESET" #blocks collisions
		mySprite.frame = 0
		##Play sound if it's a door closing behind the player

func _unlock():
	##Play sound if the player has met the condition to open the door
	if condition_met and mySprite.frame == 0:
		if abyss_door_particle:
				abyss_door_particle.emitting = true
		sfx("open")
	#myLabel.visible = false
	myAnimPlayer.current_animation = "open" #doesn't block collisions
	mySprite.frame = 1

func incrementDeathTally():
	##if the target player is in our zone, keep track of how many kills they've got (for Kill requirement)
	if GameState.target_player.current_zone == current_zone:
			myCount += 1
			print("Door kill tally:"+str(myCount))

func destroy():
	queue_free()
