extends Node2D
@onready var anim : AnimatedSprite2D = %AnimatedSprite2D

var beat : int = 1
var dialogue_start : bool = false
var dialogue : int = 0 

func anim_sculptor(value : String):
	match value:
		"idle": anim.play("SculptorIdle",1,false)
		"talk": anim.play("SculptorTalk",1,false)
		"showhands": anim.play("SculptorTalkOpenHands",1,false)
		"transform": anim.play("SculptorTransform",1,false)
		"unmask": anim.play("SculptorFaceReveal",1,false)
		"unmask_talk": anim.play("SculptorUnmaskedTalk",1,false)
		"unmask_reject": anim.play("SculptorUnmaskedReject",1,false)
		"unmask_reject_stare":anim.play("SculptorUnmaskedRejectedStare",1,false)

##Determining initial animation state
func _ready() -> void:
	anim_sculptor("idle")


func _process(_delta: float) -> void:
	##Switches animation state back once the NPC is done talking
	if !get_tree().paused:
		anim_sculptor("idle")
		if dialogue_start:
			dialogue_read()
			

func dialogue_read():
	match dialogue:
		0:
			increment_dialogue(1)
			Dialogue.openDialogue("* Ah, my creation. Finally, the light inside you has awakened. Good.","sculptor",3,false)
		1:
			increment_dialogue(1)
			Dialogue.openDialogue("* The time is ripe. You will be tested.","sculptor",3,false)
		2:
			increment_dialogue(1)
			Dialogue.openDialogue("* You will break. You will shatter, again and again. And I will re-make you as many times as is needed, until our task is done.","sculptor",2,false)
		3:
			increment_dialogue(1)
			Dialogue.openDialogue("* The heavens shall be within our reach. Well, shall we begin?","sculptor",3,false)


func increment_dialogue(value):
	if !get_tree().paused:
		dialogue += value

##Triggering npc dialogue
func _on_area_2d_body_entered(_body: Node2D) -> void:	
	dialogue_start = true
