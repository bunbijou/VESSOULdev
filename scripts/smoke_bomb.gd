##Smoke bomb
extends CPUParticles2D


func _ready() -> void:
	GameState.battle_begin.connect(smoke)

func smoke():
	Sound.PlayerFlash()
	Sound.PlayerExtinguished()
	self.emitting = true
	await get_tree().create_timer(10).timeout 
	queue_free()
