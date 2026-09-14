extends Node2D

var can_interact : bool = false
var follow_up : bool = false
var player_touch : bool = false

func _ready() -> void:
	Dialogue.dialogue_end.connect(reset)

## On player touch
func _on_interact_area_2d_body_entered(_body: Node2D) -> void:
	player_touch = true
	%BarrelbyDialogueIndicator.visible = true
	%BarrelbyDialogueIndicator.play("default")
	can_interact = true
	follow_up = false #follow-up not read
	
func _process(_delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("ui_accept"):
			Sound.menu("accept")
			disable()
			talk()
			%BarrelbySprite.play("talk")

func talk():
		var my_random
		randomize()
		my_random = randi() % 8
		Localize.reference_dialogue("Barrelby"+str(my_random+1))
		#match my_random:
			#0: Localize.reference_dialogue("Barrelby1") 
			#1: Localize.reference_dialogue("Barrelby1") 
			#2: Localize.reference_dialogue("Barrelby1") 
			#3: Localize.reference_dialogue("Barrelby1") 
			#4: Localize.reference_dialogue("Barrelby1") 
			#5: Localize.reference_dialogue("Barrelby1") 
			#6: Localize.reference_dialogue("Barrelby1") 
			#7: Localize.reference_dialogue("Barrelby1") 

func _on_interact_area_2d_body_exited(_body: Node2D) -> void:
	player_touch = false
	%BarrelbyDialogueIndicator.visible = false
	can_interact = false

##functions similarly to collision_reset() on the HitboxComponent object
##after the dialogue is done, check if the player is still there and enable collisions if so
func reset():
	if player_touch:
		can_interact = true
		%BarrelbySprite.play("idle")
		%BarrelbyArea2D.monitoring = false
		await get_tree().create_timer(.10).timeout
		%BarrelbyArea2D.monitoring = true

func disable():
	%BarrelbyDialogueIndicator.visible = false
	can_interact = false
