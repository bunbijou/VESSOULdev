class_name AmphoraMote extends Area2D

@onready var animation_player = %AnimationPlayer
@onready var mySprite = %AnimatedSprite2D
@onready var myLabel = %soulLabel
@onready var target_enemy = %MiniBossAmphora
@onready var targetDoor = %DoorC3Unique
@export_enum("Wave1 : 0","Wave2 : 1","Defense : 2") var waveID: int
var current_zone : int = 3 #my home zone
var myInitPositionY = 0 #position before descending
var descending = false #whether or not wave has descended
var chillOut = 0 #value determining state over the course of the active aves
var chilled = false #whether mote has flipped into it's passive/positive state
var prevKillState = 0 #temp var, how many kills the player had prior to entering
var myCount = 0
var isReady = false

func _ready():
	if GameState.abyssDict["abyssMiniBoss"] == 1: #if Amphora already defeated
		queue_free()
	target_enemy.cleanup.connect(queue_free) #experimental
	target_enemy.counterattack.connect(counter)
	descending = false #wait until process event
	myInitPositionY = self.position.y
	position.y -= 500
	myLabel.text = " "
	randomize()# wavy motes effect
	mySprite.frame = randi() % 14 # ditto

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone: #if target player is in my zone, do this stuff
			if !isReady: #determine kills required for boss fight completion
				prevKillState = GameState.playerKillCount
				isReady = true
			
			if GameState.playerKillCount > prevKillState:
				queue_free() #if boss killed, remove red motes
			
			#temporarily reduced from 1 to fix anims
			chillOut += 1 #after a while, become regular motes
			
			match chillOut:
				125: #after 100 frames
					match waveID:
						0: #wave 0 descends
							if !descending:
								descending = true
				325: #after 500 frames
					match waveID:
						0: #wave 0 coolin'
							mySprite.animation = "transition"
						1: #wave 1 descends
							if !descending:
								descending = true
						2: #wave 2 coolin'
							mySprite.animation = "transition"
				360: #50 frames later
					match waveID:
						0:
							chilled = true
							mySprite.animation = "safe"
						2:
							chilled = true
							mySprite.animation = "safe"
				525:
					match waveID:
						0: #wave 0 warmin'
							mySprite.animation = "transition"
						1: #wave 0 coolin'
							mySprite.animation = "transition"
						2:
							mySprite.animation = "transition"
				575:
					match waveID:
						0: #wave 0 hot
							chilled = false
							mySprite.animation = "idle"
							chillOut = 0
						1: #wave 0 cooled
							chilled = true
							mySprite.animation = "safe"
						2:
							chilled = false
							mySprite.animation = "idle"
							chillOut = 0
				675:
					match waveID:
						1:
							mySprite.animation = "transition"
				700:
					match waveID:
						1:
							chilled = false
							mySprite.animation = "idle"
							chillOut = 0
			
			if descending:
				if position.y != myInitPositionY:
					position.y += 5
			##If player has enough souls for the door to open, deploy defensive mote array
			#if targetDoor.open:
				

func counter():
	match waveID:
					2: 
						descending = true
						Sound.whoosh()


func _on_body_entered(_body: PlayerVessel) -> void:
		if !chilled:
			animation_player.play("pickup") 
			GameState.target_player.isHurt(1)
			GameState.playerActiveSouls -= 1
			GameState.playerLifetimeSouls -= 1
		else:
			animation_player.play("pickup") 
			Sound.MoteCollect()
			GameState.addSoul(1)
			myLabel.text = str(GameState.playerLifetimeSouls)
