extends Node2D

@export_category("Skip to a message")
@export var message : int = 0
@export_category("Timing options")
@export var beat : float = 1
@export var drama_beat : float = 1.5
@export_category("Talk speed options")
@export var panic_speed : float = 3
@export var default_speed : float = 1

func _ready() -> void:
	BgmController.track_trial.play()
	##Move dialogue box into the up position
	Dialogue.anim.play("RESET")
	await get_tree().create_timer(drama_beat).timeout
	if message == 0:
		Localize.reference_dialogue("anon1A")
		message += 1

func _process(_delta: float) -> void:
	if !get_tree().paused:
		match message:
			0: pass ## see above
			1:
				Localize.reference_dialogue("anon2B")
				increment_message()
			2:
				Localize.reference_dialogue("anon1C")
				increment_message()
			3:
				Localize.reference_dialogue("anon1D")
				increment_message()
			4:
				Localize.reference_dialogue("anon2E")
				increment_message()
			5:
				Localize.reference_dialogue("anon1F")
				increment_message()
			6: 
				LevelTransition.fadeToBlack()
				await get_tree().create_timer(beat).timeout
				get_tree().quit()
				#get_tree().call_deferred("change_scene_to_file","res://demo_start.tscn")

func increment_message():
	message += 1
