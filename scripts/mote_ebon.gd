class_name EbonMote extends Area2D
@onready var animation_player = $AnimationPlayer
@onready var myLabel = %soulLabel

func _ready():
	%MoteDefault.visible = true
	%EbonVessel.mote_conversion.connect(ebon_transformation) #experimental
	%EbonVessel.death_rattle.connect(cleanup)

func ebon_transformation():
	%MoteDefault.visible = false
	%MoteTransition.visible = true
	await get_tree().create_timer(.5).timeout
	%MoteTransition.visible = false
	%MoteEbon.visible = true

func _on_body_entered(body: Node2D) -> void:
	body.motes_active += 1
	body.motes_lifetime += 1
	animation_player.play("pickup")

func cleanup():
	queue_free()
