##Super Simple; Special label that shows up when you're in the area of effect
class_name AreaHint extends Label

func _ready() -> void:
	self.visible = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	self.visible = true

func _on_area_2d_2_body_exited(_body: Node2D) -> void:
	self.visible = false
