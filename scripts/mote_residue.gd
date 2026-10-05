extends Node2D
@export var detection_area : CollisionShape2D
@export var my_sprite : AnimatedSprite2D 
@export var value_label : Label 
@export var fade_time : float = 1.5

func anim_motes_reclaimed():
	Sound.MoteCollect()
	Sound.PlayerHeal()

func _ready() -> void:
	GameState.target_player.player_death.connect(initialize)
	if GameState.mote_residue:
		activate()
	else:
		my_sprite.visible = false
		%HealParticle.emitting = false
		detection_area.set_deferred("disabled", true)

func initialize(msg : String):
	##Function doesn't work unless you provide a use for the passed-in value
	print("Player died; initializing mote residue: " + msg)
	#Important that we're drawing from the soul meter and not the lifetime souls
	GameState.mote_residue_value = int(GameState.playerActiveSouls)
	GameState.mote_residue = true #next time the scene resets, we'll do our thing
	GameState.mote_residue_position = GameState.target_player.position
	GameState.mote_residue_scene = get_tree().get_current_scene().get_name()

func activate():
	var active_scene = get_tree().get_current_scene().get_name()
	
	if active_scene == GameState.mote_residue_scene:
		%HealParticle.emitting = true
		self.position = GameState.mote_residue_position
		my_sprite.visible = true
		detection_area.set_deferred("disabled", false)
	else: print("Player has mote residue, but not in this scene")

func _on_touch(_body: Node2D) -> void:
	restore_motes()

func restore_motes():
	my_sprite.visible = false
	#value_label.visible = true
	#value_label.text = "+"+str(GameState.mote_residue_value)
	anim_motes_reclaimed()
	GameState.mote_restore(GameState.mote_residue_value)
	deactivate()

func deactivate():
		%HealParticle.emitting = false
		#not overwriting player location, just saving the active scene/mote residue state
		GameState.mote_residue_value = 0
		GameState.mote_residue = false
		GameState.mote_residue_position = Vector2(99999,99999)
		GameState.mote_residue_scene = "res://scenes/nullscn.tscn"
		#Defer to stored player location and scene
		GameState._save(GameState.playerCurrentLocation,GameState.playerActiveScene)
		detection_area.set_deferred("disabled", true)
		await get_tree().create_timer(fade_time).timeout
		#value_label.visible = false
