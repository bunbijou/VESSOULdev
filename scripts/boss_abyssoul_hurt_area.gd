##Old Hurtbox Node, used by Abyss Presence fight
#it's all wrapped up in animationplayers, so let's not replace it, for now
extends Area2D

@onready var myHurtBox = %CollisionShape2D
@export var current_zone : int

func _ready():
	##If abyss presence is defeated, remove hurtboxes
	if GameState.abyssDict["abyssBoss"][0] == 1:
		queue_free()

func _on_body_entered(_body: PlayerVessel) -> void:
		if GameState.target_player.current_zone == current_zone:
				GameState.target_player.isHurt(1+GameState.newgame)
