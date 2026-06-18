extends CPUParticles2D

func anim_pain(count : int):
	self.emitting = true
	self.amount = count
	self.gravity.y = -100
	await get_tree().create_timer(.75).timeout
	self.gravity.y = 100
