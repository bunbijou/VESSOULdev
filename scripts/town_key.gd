## Town Key (derive this for Church bells?)
class_name ItemKey extends Node2D
@export var bossTarget : Node2D
var unlocked = false

func _ready() -> void:
	if GameState.woodsDict["woodsKey"] >= 1: #if key already collected
		queue_free()
	else: 
		self.visible = false
		if bossTarget:
			bossTarget.death_rattle.connect(unlock)

func _on_area_2d_body_entered(_body: PlayerVessel) -> void:
	if unlocked:
		BgmController.success_jingle.play()
		GameState.woodsDict["woodsKey"] = 1
		print("Town Key collected")
		queue_free()
	else: print ("Key condition not met")

func unlock():
	self.visible = true
	unlocked = true
