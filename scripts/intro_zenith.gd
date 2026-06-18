extends Node2D
var skip : bool = false

func _ready() -> void:
	LevelTransition.fadeFromBlack()
	dialogue_read()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and !skip:
		skip = true
		LevelTransition.fadeFromBlack()
		Dialogue.isComplete = true #experimental
		await get_tree().create_timer(1).timeout 
		get_tree().call_deferred("change_scene_to_file","res://mainMenu.tscn")

func dialogue_read():
	var text_speed : float = 6.5
	Dialogue.openDialogue("			
	
	
	
	Allow me to tell you a story.","none",text_speed,true)

	await get_tree().create_timer(4).timeout 
	%Anim.play("fade",-1,1,false)
	%Slide1.visible = false
	await get_tree().create_timer(1).timeout 
	%Slide2.visible = true
	if !skip:
		Dialogue.openDialogue("			
		
		
		
		Long ago, humanity worshipped the Aspect of the Moon, Lailun.","none",text_speed,true)
		await get_tree().create_timer(5).timeout 
		if !skip:
			Dialogue.openDialogue("			
			
			
			
			It was said that, rarely, the Aspect of the Moon would grace humanity with her presence.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("
			
			
			
			In time, the humans moved on from this practice, choosing instead to speak the glories of Man.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("			
			
			
			
			As a result, a new Aspect arrived, intent on challenging the dominion of Mankind.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("			
			
			
			
			The Aspect of the Saturnine Flame.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("			
			
			
			Now, humanity is no more. Its remnants, reduced to mere shadows, cast by fragmented light, dancing upon the walls. These fragments, found in and around the dark places of this realm.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("			
			
			
			
			The question remains: what will become of the remnants of these souls?","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("			
			
			
			
			It is up to you to show them the light, humble vessel.","none",text_speed,true)

			await get_tree().create_timer(5).timeout 
			Dialogue.openDialogue("","none",text_speed,true)
			await get_tree().create_timer(5).timeout
