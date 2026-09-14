class_name DecisionPrompt extends CanvasLayer

signal endless_start
signal motebasin
signal ng_adjust

##Whether the decision prompt is showing
var active : bool = false
##Prevents actions from being input multiple times a frame
var beat : float  = 0.1
##See below
var active_key : String
##Defaults to leftmost selection
var selection : int = 0
var consent : bool = false

func _ready() -> void:
	Dialogue.dialogue_start.connect(close_decision_prompt)
	%DecisionControl.visible = false
	%DecisionHeader.visible = false
	%DecisionConsent.visible = false
	%DecisionConsent.text = Localize.menu_decision_consent
	%DecisionArrowLeft.visible = false
	%DecisionArrowRight.visible = false

func _process(_delta: float) -> void:
	if active:
		##Move cursor from left to right
		if Input.is_action_just_pressed("ui_right") and !%DecisionConsent.visible: #No selection
			selection = 1
			Sound.menu("move")
			%DecisionArrowLeft.visible = false
			%DecisionArrowRight.visible = true

		##Move cursor from right to left
		if Input.is_action_just_pressed("ui_left") and !%DecisionConsent.visible:
			selection = 0
			Sound.menu("move")
			%DecisionArrowLeft.visible = true
			%DecisionArrowRight.visible = false

		##Selecting An Option
		if Input.is_action_just_pressed("ui_accept") and !%DecisionConsent.visible:
			Sound.menu("accept")
			await get_tree().create_timer(beat).timeout
			if consent != true:
				decision_consent_show()
			else:
				await get_tree().create_timer(beat).timeout
				close_decision_prompt()
				decision_action(active_key,selection)

		##Affirm Consent
		if %DecisionConsent.visible:
			if Input.is_action_just_pressed("ui_accept"):
				consent = true
				Sound.menu("accept")
				await get_tree().create_timer(beat).timeout
				close_decision_prompt()
				decision_action(active_key,selection)
			##Deny Consent
			if Input.is_action_just_pressed("ui_close_dialog"):
				consent = false
				Sound.menu("cancel")
				decision_consent_hide()

func decision_action(key : String,choice : int):
	match key:
		"LenoreQuestion1": #determines outcome of lenore NPC sequence
			match choice:
				0: #"You are foolish"
					GameState.favor = false
					Dialogue.remote_end_dialogue()
				1: #"You are kind"
					GameState.favor = true
					Dialogue.remote_end_dialogue()
		"GiveUpSoul": #Samael's Question
			match choice:
				0: #Give up
					GameState.npcDict["sculptor"] = 98
					Dialogue.remote_end_dialogue()
				1: #Do not
					GameState.npcDict["sculptor"] = 99
					Dialogue.remote_end_dialogue()
		"ContinueGame":
			match choice:
				0:#New Game Plus
					GameState.newgame += 1
					GameState.start_new_game()
				1:#New Game Standard
					print("Player deferred on new game plus")
					GameState.start_new_game()
		"EnterSanctuary":
			match choice:
				0: #Enter
					Dialogue.remote_end_dialogue()
					enter_sanctuary()
				1: #Do Not
					#this line will have no effect on Impostors
					GameState.npcDict["sculptor"] = 14
					Dialogue.remote_end_dialogue()
		"EnterImpostorSanctuary":
			match choice:
				0: #Enter
					Dialogue.remote_end_dialogue()
					enter_sanctuary_alt()
				1: #Do Not
					#this line will have no effect on Impostors
					Dialogue.remote_end_dialogue()
		"RingBellGold":
			match choice:
				0: #Pay Toll
					if GameState.playerLifetimeSouls >= GameState.gold_toll:
						GameState.townDict["townSanctuaryBells"][0] = 1
						GameState.playerLifetimeSouls -= GameState.gold_toll
					else: Localize.reference_dialogue("BellInsufficientMotes")
					Dialogue.remote_end_dialogue()
				1: #Do Not
					print("Player deferred on paying toll")
					Dialogue.remote_end_dialogue()
		"RingBellSilver":
			match choice:
				0: #Pay Toll
					if GameState.playerLifetimeSouls >= GameState.silver_toll:
						GameState.townDict["townSanctuaryBells"][1] = 1
						GameState.playerLifetimeSouls -= GameState.silver_toll
					else: Localize.reference_dialogue("BellInsufficientMotes")
					Dialogue.remote_end_dialogue()
				1: #Do Not
					print("Player deferred on paying toll")
					Dialogue.remote_end_dialogue()
		"TimelineReset":
			match choice:
				0: #Free Samael / Reset Timeline
					print("Player chose to restore Samael")
					GameState.townDict["townEndingChoice"][0] = 1
					GameState.townDict["townEndingChoice"][1] = 0
					GameState.townDict["townEndingChoice"][2] = 0
					Dialogue.remote_end_dialogue()
				1: #Do Not / Maintain Impostor Route
					print("Player chose not to restore Samael")
					Dialogue.remote_end_dialogue()
		"EndlessModeWarning":
			match choice:
				0: #Go back
					Dialogue.remote_end_dialogue()
				1: #Continue
					endless_start.emit()
					Dialogue.remote_end_dialogue()
		"EndlessMoteBasin":
			match choice:
				0: #Deposit All Motes
					motebasin.emit("deposit")
					Dialogue.remote_end_dialogue()
				1: #Withdraw All motes
					motebasin.emit("withdraw")
					Dialogue.remote_end_dialogue()
		"NGAdjust":
			match choice:
						0: #Reduce NG+ value
							if GameState.newgame >= 2:
								GameState.newgame -= 1
								ng_adjust.emit("change")
							else: 
								ng_adjust.emit("no_change")
							Dialogue.remote_end_dialogue()
						1: #
							GameState.newgame += 1
							ng_adjust.emit("change")
							Dialogue.remote_end_dialogue()
		"LevelUpKindling": ##experimental
			GameState.toll = 1#50+(GameState.playerKindlingHeld*(20*GameState.kindlingMaximumPerGame))
			match choice:
				0: #Pay Level Up Cost
					if GameState.playerLifetimeSouls >= GameState.toll:
						GameState.playerLifetimeSouls -= GameState.toll
						if GameState.playerKindlingHeld > 0:
							##Achievement: first time upgrading Intensity
							if GameState.playerIntensity == 0:
								GameState.target_player.anim_achievement("a_intensity_up")
							##Achievement: increasing Intensity to max
							if GameState.playerIntensity + GameState.playerKindlingHeld >= 10:
								GameState.target_player.anim_achievement("a_intensity_max")
							GameState.target_player.position = Vector2(27,366)#self.position+Vector2(0,30)
							GameState.target_player.anim_unnerve()
							GameState.anim_dragon_flame()
							Sound.upgrade("zn")
							GameState.target_player.anim_sparkle()
							GameState.playerIntensity += GameState.playerKindlingHeld
							GameState.playerKindlingHeld = 0
							#GameState.target_player.anim_levelupdate()#(lvl_prev,lvl_prev+GameState.playerTomesHeld-1)
							GameState.target_player.show_sidebar()
							Localize.reference_dialogue("ZNUpgradeGeneric")
							await get_tree().create_timer(beat*2).timeout
							GameState.target_player.anim_reset()
					else: Localize.reference_dialogue("BellInsufficientMotes")
					Dialogue.remote_end_dialogue()
				1: #Do Not
					print("Player deferred on paying toll")
					Dialogue.remote_end_dialogue()
		"LevelUpTome": #experimental
			GameState.toll = 50+(GameState.playerTomesHeld*(20*GameState.tomeMaximumPerGame))
			match choice:
				0: #Pay Level Up Cost
					if GameState.playerLifetimeSouls >= GameState.toll:
						GameState.playerLifetimeSouls -= GameState.toll
						if GameState.playerTomesHeld > 0: #and GameState.playerEfficiency < 3: #if player has collected tomess
							##Achievement: first time upgrading Efficiency
							if GameState.playerEfficiency == 0:
								GameState.target_player.anim_achievement("a_efficiency_up")
							##Achievement: increasing Efficiency to max
							if GameState.playerEfficiency + GameState.playerTomesHeld >= 3:
								GameState.target_player.anim_achievement("a_efficiency_max")
							GameState.playerEfficiency += GameState.playerTomesHeld
							##Deduct items
							GameState.playerTomesHeld = 0
							#GameState.target_player.anim_levelupdate()#(lvl_prev,lvl_prev+GameState.playerTomesHeld-1)
							Sound.upgrade("sculptor")
							GameState.target_player.anim_sparkle()
							GameState.target_player.anim_enchant()
							GameState.target_player.show_sidebar()
							Localize.reference_dialogue("SculptorUpgradeGeneric")
					else: Localize.reference_dialogue("BellInsufficientMotes")
					Dialogue.remote_end_dialogue()
				1: #Do Not
					print("Player deferred on paying toll")
					Dialogue.remote_end_dialogue()
		"LevelUpBulb":
			GameState.toll = 50+(GameState.playerBulbsHeld*(20*GameState.bulbMaximumPerGame))
			match choice:
				0: #Pay Level Up Cost
					if GameState.playerLifetimeSouls >= GameState.toll:
						if GameState.playerBulbsHeld > 0: #and GameState.playerCapacity < 5: #if player has bloombulbs
							##Achievement: first time upgrading Capacity
							if GameState.playerCapacity == 0:
								GameState.target_player.anim_achievement("a_capacity_up")
							##Achievement: increasing Capacity to max
							if GameState.playerIntensity + GameState.playerBulbsHeld >= 5:
								GameState.target_player.anim_achievement("a_capacity_max")
							GameState.playerCapacity += GameState.playerBulbsHeld
							GameState.playerBulbsHeld = 0
							#GameState.target_player.anim_levelupdate()#(lvl_prev,lvl_prev+GameState.playerTomesHeld-1)
							Sound.upgrade("jari")
							GameState.target_player.show_sidebar()
							GameState.target_player.anim_sparkle()
							Localize.reference_dialogue("JariUpgradeGeneric")
							##Not working as of right now
							#await get_tree().create_timer(.1).timeout
							#GameState.fullHeal()
						else: Localize.reference_dialogue("BellInsufficientMotes")
					Dialogue.remote_end_dialogue()
				1: #Do Not
					print("Player deferred on paying toll")
					Dialogue.remote_end_dialogue()
func decision_prompt(question,option1,option2,key,consent_required):
	if GameState.decisionActive == false:
		active_key = key
		get_tree().paused = true
		GameState.decisionActive = true
		%DecisionControl.visible = true
		%DecisionHeader.visible = true
		%DecisionHeader.text = str(question)
		
		%DecisionChoice1.visible = true
		%DecisionChoice1.text = str(option1)
		
		%DecisionChoice2.visible = true
		%DecisionChoice2.text = str(option2)
		
		%DecisionArrowLeft.visible = true
		selection = 0 #default to leftmost option
		if !consent_required:
			consent = true
		else: consent = false #indicate that consent is required to affirm
		active = true ## pass to process event
	else: print("Decision prompt deferred (Reason: Decision prompt already active)")

func close_decision_prompt():
	active = false
	GameState.decisionActive = false
	get_tree().paused = false
	%DecisionControl.visible = false
	%DecisionHeader.visible = false
	%DecisionChoice1.visible = false
	%DecisionChoice2.visible = false
	%DecisionArrowLeft.visible = false
	%DecisionArrowRight.visible = false
	%DecisionConsent.visible = false
	%ConsentBox.visible = false

func decision_consent_show():
	%DecisionConsent.text = Localize.menu_decision_consent
	%DecisionConsent.visible = true
	%ConsentBox.visible = true

func decision_consent_hide():
	%DecisionConsent.visible = false
	%ConsentBox.visible = false

func enter_sanctuary():
	BgmController.stopAll()
	Sound.LoopingSoundCleanup()
	Sound.enemy_slain()
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(2).timeout
	Sound.enemy_slain()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://sanctuary.tscn")
	
func enter_sanctuary_alt():
	BgmController.stopAll()
	BgmController.ending_bad.play()
	Sound.LoopingSoundCleanup()
	#Sound.enemy_slain()
	LevelTransition.fadeToBlack()
	await get_tree().create_timer(4).timeout
	#Sound.enemy_slain()
	get_tree().change_scene_to_file("res://sanctuaryAlt.tscn")
