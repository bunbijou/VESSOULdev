class_name GazerTendril extends AnimatedSprite2D



@export var gazer_base : EnemyGazer
var stunned : bool = false
var hitstun : float = 0.35

func anim_stun():
	self.animation = "stun"

func _on_soul_mote_body_entered(_body: PlayerVessel) -> void:
	if !GameState.shadeActive:
		anim_stun()
		stunned = true
		gazer_base.stun()
	else: GameState.target_player.isHurt(1+GameState.newgame)

func _process(_delta: float) -> void:
	if stunned:
		await get_tree().create_timer(hitstun).timeout #wait so anim and sound can play
		queue_free()
	
	if GameState.shadeActive:
		%ShadeShieldBlock.disabled = false
	else: %ShadeShieldBlock.disabled = true
