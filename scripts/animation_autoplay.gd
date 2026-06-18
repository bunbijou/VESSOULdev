extends AnimationPlayer
@export var fade_wait : float = 3
@export var destination_scene : String
@export var animation_to_loop : String = "loop"
var anim_spd : float = 1

func _ready() -> void:
	anim_spd = self.speed_scale
	BgmController.descent_battle.play()
	self.current_animation = "loop"
	self.active = true

func fadeout():
	self.current_animation = "RESET"
	self.active = false
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(fade_wait).timeout
	get_tree().change_scene_to_file(destination_scene)

## While paused, paused animations
func _process(_delta: float) -> void:
	if get_tree().paused:
		self.speed_scale = 0
	else: self.speed_scale = anim_spd
