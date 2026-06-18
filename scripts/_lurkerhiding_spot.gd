extends Node2D
signal lurker_found

func _ready() -> void:
	self.visible = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("Player entered lurker hiding spot")
	lurker_found.emit(true)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	print("Player exited lurker hiding spot")
	lurker_found.emit(false)
