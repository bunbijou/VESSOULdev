extends Node2D

signal battle_start()

@export_enum("Abyss","Woods","Town") var location: String
@export var interact_sprite : AnimatedSprite2D #debug
var can_interact : bool = false
var follow_up : bool = false
var player_touch : bool = false
var terminating : bool = false #preventing a freeze with this

func anim_reveal():
	GameState.target_player.waiting = true
	BgmController.stopAll()
	#Sound.LurkerGiggle()
	%AnimatedSprite2D.play("reveal")
	await get_tree().create_timer(.75).timeout
	Sound.fallOut()
	await get_tree().create_timer(1.25).timeout
	%DarknessExplosion.emitting = true
	Sound.motebearer("dispel")
	await get_tree().create_timer(.5).timeout
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(3).timeout
	LevelTransition.fadeFromBlack()
	terminating = true
	%EbonVessel.visible = true
	%EbonVessel.start()
	queue_free()

func _ready() -> void:
	if !GameState.impostor:
		print("Impostor not present in this instance")
		queue_free()
	else: ## see also: sculptor_motion.gd
		#Override player inputs if final battle immenant
		if GameState.target_player.current_zone == -19:
			if !BgmController.impostor_theme.playing:
				BgmController.impostor_theme.play()
			talk()
		Dialogue.dialogue_end.connect(addendum)
		match location: #function as normal
			"Abyss":
				if GameState.player_gods_wood_entered:
						queue_free()
				if GameState.player_church_town_entered:
						queue_free()
			"Woods":
				if GameState.player_church_town_entered:
					queue_free()
			"Town":
				print("Impostor!Samael is in his final location")

## On player touch
func _on_interact_area_2d_body_entered(_body: Node2D) -> void:
	player_touch = true
	GameState.target_player.anim_samael_emerge()
	BgmController.stopAll()
	if !BgmController.impostor_theme.playing:
		BgmController.impostor_theme.play()
	interact_sprite.visible = true
	can_interact = true
	follow_up = false #follow-up not read
	
func _process(_delta: float) -> void:
	if can_interact and player_touch and Input.is_action_just_pressed("ui_accept"):
			Sound.menu("accept")
			disable()
			talk()

func talk():
	Localize.reference_dialogue("Impostor1")

func addendum():
	if GameState.target_player.current_zone == -19:
		battle_start.emit()
	else:
		if !follow_up and player_touch:
				#this wait is important to keep the events from overlapping
				await get_tree().create_timer(.01).timeout
				if GameState.playerTomesHeld > 0:
					Localize.reference_dialogue("ImpostorFollowUpHasTome")
					tomeConversion()
				else: Localize.reference_dialogue("ImpostorFollowUpNoTome")
		follow_up = true

func _on_interact_area_2d_body_exited(_body: Node2D) -> void:
	disable()

## Copied from npc_base.gd
func _on_music_area_body_exited(_body: Node2D) -> void:
	if !terminating:
		GameState.target_player.anim_samael_hide()
		if BgmController.impostor_theme.playing:
			BgmController.impostor_theme.stop()
			if !GameState.player_gods_wood_entered and !GameState.player_church_town_entered:
				BgmController.abyss_main.play()
			if GameState.player_gods_wood_entered and !GameState.player_church_town_entered:
				BgmController.gods_wood.play()
			if GameState.player_gods_wood_entered and GameState.player_church_town_entered:
				BgmController.church_town.play()

##functions similarly to collision_reset() on the HitboxComponent object
##after the dialogue is done, check if the player is still there and enable collisions if so
func reset():
	%InteractArea2D.monitoring = false
	await get_tree().create_timer(.10).timeout
	%InteractArea2D.monitoring = true

#called when player moves away
func disable():
	if !terminating:
		player_touch = false
		interact_sprite.visible = false
		can_interact = false

#copied from npc_base.gd
func tomeConversion():
	GameState.playerEfficiency += GameState.playerTomesHeld
	GameState.playerTomesHeld = 0
	Sound.upgrade("sculptor")
	GameState.target_player.anim_sparkle()
	GameState.target_player.anim_enchant()
	GameState.target_player.show_sidebar()
