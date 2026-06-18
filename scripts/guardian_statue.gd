extends AnimatedSprite2D
@export_enum("gold","silver") var type : String
@export var spr_pedestal : AnimatedSprite2D
@export var spr_arm_shield : AnimatedSprite2D
@export var spr_arm_spear : AnimatedSprite2D
#@export var spr_body : AnimatedSprite2D
@export var my_particle : CPUParticles2D
var active : bool = false

func anim_rumble():
	my_particle.emitting = true
	Sound.stone_break() #placeholder

func anim_activate():
	if GameState.target_player.current_zone == 16:
		GameState.target_player.current_zone = -1000
		GameState.target_player.temp_position = ((%StatueLeft.position/%StatueRight.position)/2)+(Vector2(0,-30))
		await get_tree().create_timer(1).timeout
		%GuardianAnimPlayer.play("activate")
		match type:
			"gold":
				self.play("left")
				spr_arm_shield.play("shield_L")
				spr_arm_spear.play("spear_L")
			"silver":
				self.play("right")
				spr_arm_shield.play("shield_R")
				spr_arm_spear.play("spear_R")
		spr_pedestal.play("default")
		await get_tree().create_timer(3.5).timeout
		GameState.target_player.current_zone = 16
	else:
		%GuardianAnimPlayer.play("activate")
		match type:
			"gold":
				self.play("left")
				spr_arm_shield.play("shield_L")
				spr_arm_spear.play("spear_L")
			"silver":
				self.play("right")
				spr_arm_shield.play("shield_R")
				spr_arm_spear.play("spear_R")
		spr_pedestal.play("default")
	%SanctuaryDoors.play("default")

func _process(_delta: float) -> void:
	if GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
		if !active:
			anim_activate()
			active = true
