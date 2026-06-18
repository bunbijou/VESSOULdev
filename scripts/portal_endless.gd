extends Node2D

func _ready() -> void:
	%DestinationLabel.text = Localize.endless_enter_maze

func _on_area_2d_body_entered(_body: Node2D) -> void:
	%EndlessConfig.portal_entered()
