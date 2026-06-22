extends Node2D
@export var gold : bool = false
@export var silver : bool = false
@export var detect_area : HitboxComponent
@export var my_sprite : AnimatedSprite2D
var player_contact : bool = false
var acquired : bool = false

func anim_idle(type : String):
	match type:
		"gold":
			my_sprite.play("gold",0,false)
		"silver":
			my_sprite.play("silver",0,false)

func anim_ring(type : String, silent : bool):
	%HealParticle.emitting = true
	match type:
		"gold":
			my_sprite.play("gold",1,false)
			if !silent:
				Sound.enemy_slain()
		"silver":
			my_sprite.play("silver",1,false)
			if !silent:
				Sound.enemy_slain()

func anim_ring_repaired(type : String, silent : bool):
	%HealParticle.emitting = true
	match type:
		"gold":
			my_sprite.play("gold_repaired",1,false)
			if !silent:
				Sound.enemy_slain()
		"silver":
			my_sprite.play("silver_repaired",1,false)
			if !silent:
				Sound.enemy_slain()


func _ready() -> void:
	%HealParticle.emitting = false
	if gold:
		if !acquired:
			anim_idle("gold")
		else: anim_ring("gold", true)
	
	if silver:
		if !acquired:
			anim_idle("silver")
		else: anim_ring("silver", true)


func _process(_delta: float) -> void:
	##Update visual state when conditions have been met
	if gold and GameState.townDict["townSanctuaryBells"][0] == 1 and !acquired:
		##Achievement: Ring Gold Bell
		SteamHandler.achievement_get("a_bell_gold_rung")
		GameState.target_player.show_sidebar()
		anim_ring("gold", false)
		acquired = true
	if silver and GameState.townDict["townSanctuaryBells"][1] == 1 and !acquired:
		##Achievement: Ring Silver Bell
		SteamHandler.achievement_get("a_bell_silver_rung")
		GameState.target_player.show_sidebar()
		anim_ring("silver", false)
		acquired = true
	if player_contact:
		if gold and GameState.townDict["townSanctuaryBells"][0] == 0:
			if Input.is_action_just_pressed("ui_accept"):
				Localize.reference_dialogue("BellTollGold")
		if silver and GameState.townDict["townSanctuaryBells"][1] == 0:
			if Input.is_action_just_pressed("ui_accept"):
				Localize.reference_dialogue("BellTollSilver")

func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	if acquired:
		if gold:
			anim_ring_repaired("gold", false)
		if silver:
			anim_ring_repaired("silver", false)
	else:
		Sound.textPopup()
		player_contact = true
		%InteractSprite.visible = true

func _on_hitbox_component_body_exited(_body: Node2D) -> void:
	player_contact = false
	%InteractSprite.visible = false
