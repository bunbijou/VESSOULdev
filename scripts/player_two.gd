extends CharacterBody2D

var speed : float

func play_anim(anim : String):
	match anim:
		"start":
			await get_tree().create_timer(.1).timeout
			%SlotLabel.visible = true
			%flameSprite.visible = false
			%SteamParticle.emitting = true
			await get_tree().create_timer(.4).timeout
			%flameSprite.visible = true
			await get_tree().create_timer(2.5).timeout
			%SlotLabel.visible = false
		"stop":
			pass
func _ready() -> void:
	play_anim("start")
	self.position = GameState.target_player.position+Vector2(10,0)

func _physics_process(_delta: float) -> void:
	## Define variable values based on system input 
	var directionx := Input.get_axis("ui_left_2", "ui_right_2")
	var directiony := Input.get_axis("ui_up_2", "ui_down_2")
	
	##Update 5/6/26: Don't need this because it's built-in to the native pause function
	## Modifying speed value based on state e.g mice, freezing, death
	#if !get_tree().paused
		#speed = GameState.playerBuffedSpd
	#else:
		#speed = 0
		#velocity.x = 0
		#velocity.y = 0

	if directionx:
		velocity.x = directionx * speed
	else: velocity.x = 0
	
	if directiony:
		velocity.y = directiony * speed
	else: velocity.y = 0
	
	move_and_slide()
