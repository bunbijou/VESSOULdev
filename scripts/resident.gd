extends Node2D
@export var message : String
var can_interact : bool = false
var player_contact : bool = false

func _ready() -> void:
	Dialogue.dialogue_end.connect(reset)

func reset():
	%InteractArea2D.monitoring = false
	await get_tree().create_timer(.10).timeout
	%InteractArea2D.monitoring = true

func _on_touch(_body: Node2D) -> void:
	Sound.textPopup()
	player_contact = true #the order is important
	can_interact = true
	%InteractSprite.visible = true

func disable():
	can_interact = false
	%InteractSprite.visible = false

func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		Sound.menu("accept")
		disable()
		Localize.reference_dialogue(message)

func _on_area_exit(_body: Node2D) -> void:
	player_contact = false #the order is important
	disable()
