extends Node2D
@export var id : int 

func _on_area_2d_body_entered(_body: BossImpostor) -> void:
	if id == %EbonVessel.count:
		%EbonVessel.count += 1
