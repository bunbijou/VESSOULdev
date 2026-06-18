extends Node2D

##if the player isn't on New Game Plus, we delete this node
func _ready() -> void:
	if GameState.newgame == 0:
		queue_free()
	else:
		DecisionSelect.ng_adjust.connect(addendum)

func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	if GameState.newgame < 0:
		GameState.newgame *= -1
	await get_tree().create_timer(0.01).timeout
	Localize.reference_dialogue("NGAdjust")

func addendum(line : String):
	await get_tree().create_timer(0.01).timeout
	match line:
		"change": Localize.reference_dialogue("NGResult")
		"no_change": Localize.reference_dialogue("NGNoOption")
