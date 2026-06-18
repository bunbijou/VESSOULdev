extends Node2D

@export var anim : AnimatedSprite2D
@export var active_particle : CPUParticles2D
@export var interact_sprite : AnimatedSprite2D
var addendum : bool = false
var dialogue : int = 0
var start_dialogue : bool = false
var beat : float = 1.0

func play_anim(value : String):
	match value:
		"idle":
			anim.play("idle",1,false)
		"emerge":
			%ParticleAbyss.emitting = true
			active_particle.emitting = true
			Sound.rock_break()
			anim.play("emerge",1,false)
			await get_tree().create_timer(beat/2).timeout
			play_anim("float_front")
		"hide":
			%ParticleAbyss.emitting = true
			active_particle.emitting = false
			Sound.rock_break()
			anim.play("emerge",-1,true)
			await get_tree().create_timer(beat/2).timeout
			play_anim("idle")
		"vanish":
			%ParticleAbyss.emitting = true
			active_particle.emitting = false
			Sound.rock_break()
			anim.play("emerge",-1,true)
			await get_tree().create_timer(beat).timeout
			anim.visible = false
		"reappear":
			%ParticleAbyss.emitting = true
			anim.visible = true
			play_anim("idle")
		"float_front":
			anim.play("float_front",1,false)

func _ready() -> void:
	Dialogue.dialogue_end.connect(npc_move)
	%SoulDoor.open.connect(soul_door_open)
	%KillDoor.open.connect(kill_door_open)
	BgmController.abyss_main.play()

func _player_touch(_body: Node2D) -> void:
	##Don't wait for player input
	start_dialogue = true
	play_anim("emerge")

func _on_area_2d_body_exited(_body: Node2D) -> void:
	play_anim("hide")

##When dialogue is done, move me to the next position
func npc_move():
	if !addendum:
		start_dialogue = false
		play_anim("vanish")
		await get_tree().create_timer(beat).timeout
		match dialogue:
			1: ##First motion point
				self.position = %PortiaMoveA.position
			3: self.position = %PortiaMoveD.position
			4: self.position = %PortiaMoveB.position
			6: self.position = %PortiaMoveC.position
		play_anim("reappear")
		##Oh no enemies!
		if GameState.abyssDict["abyssGlaze"] != 0 and dialogue == 5:
			Dialogue.anim.play("RESET")
			Localize.reference_dialogue("portiaF")
			increment_message(999)

func soul_door_open():
	dialogue = 4
	npc_move()

func kill_door_open():
	BgmController.stopAll()
	BgmController.abyss_main.play()
	BgmController.success_jingle.play()
	dialogue = 6
	npc_move()

func _process(_delta: float) -> void:
	if start_dialogue:
		if !Dialogue.isReading:
			match dialogue: 
				0: #first meet
					addendum = false
					Localize.reference_dialogue("portiaA")
					increment_message(1)
				1: #second room, explaination 1
					addendum = true
					Localize.reference_dialogue("portiaB")
					increment_message(1)
				2: #second room, explaination 2
					addendum = true
					Localize.reference_dialogue("portiaC")
					increment_message(1)
				3: #second room, explaination 2
					addendum = false
					Localize.reference_dialogue("portiaD")
				4: #After opening soul door and entering next room
					addendum = false
					Dialogue.anim.play("up")
					await get_tree().create_timer(0.01).timeout
					Localize.reference_dialogue("portiaE")
					increment_message(1)
					start_dialogue = false
				5: #oh no enemies!
					pass
				6: #good job you kiled them!
					addendum = true
					Localize.reference_dialogue("portiaG")
					increment_message(1)
				7:
					addendum = true
					Localize.reference_dialogue("portiaH")
					increment_message(1)
				8:
					addendum = true
					start_dialogue = false
					play_anim("vanish")
					await get_tree().create_timer(beat*1).timeout
					increment_message(1)
				9:
					addendum = false
					self.position = %PortiaMoveD.position

func increment_message(value : int):
	dialogue += value
