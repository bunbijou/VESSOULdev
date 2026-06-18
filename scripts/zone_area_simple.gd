class_name AreaZoneSimple extends Area2D

@onready var isActive : bool
@export var zoneCamera : Camera2D
@export var myID : int

func _on_body_entered(_body: PlayerVessel) -> void:
	GameState.target_player.current_zone = myID
	zoneCamera.position = self.position
