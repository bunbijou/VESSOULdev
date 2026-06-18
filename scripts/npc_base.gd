extends Node2D
@export_enum("Sculptor","Jari","ZenithNadir") var npcID: String
@export var jariHiding : bool = false
@export var myTarget : Node2D
@onready var anim : AnimatedSprite2D = %AnimatedSprite2D
var beat : int = 1
var player_contact : bool = false
var can_interact : bool = false

##Animations
func anim_sculptor(value : String):
	match value:
		"idle": anim.play("SculptorIdle",1,false)
		"talk": anim.play("SculptorTalk",1,false)
		"showhands": anim.play("SculptorTalkOpenHands",1,false)
		"transform": anim.play("SculptorTransform",1,false)
		"unmask": anim.play("SculptorFaceReveal",1,false)
		"unmask_talk": anim.play("SculptorUnmaskedTalk",1,false)
		"unmask_reject": anim.play("SculptorUnmaskedReject",1,false)
		"unmask_reject_stare":anim.play("SculptorUnmaskedRejectedStare",1,false)

func anim_jari(value : String):
	match value:
		"hide": anim.play("JariHide",1,false)
		"emerge": anim.play("JariEmerge",1,false)
		"idle": anim.play("JariActive",1,false)
		"talk": anim.play("JariTalk",1,false)

func anim_zn(value : String):
	match value:
		"zenith_hide":	anim.play("ZenithEmerge",0,false)
		"nadir_hide":	anim.play("NadirEmerge",0,false)
		"zenith_emerge": 
			if anim.animation != "ZenithEmerge":
				anim.play("ZenithEmerge",1,false)
		"nadir_emerge": 
			if anim.animation != "NadirEmerge":
				anim.play("NadirEmerge",1,false)
		"zenith_talk": anim.play("ZenithTalk",1,false)
		"nadir_talk": anim.play("NadirTalk",1,false)
		"zenith_retreat": anim.play("ZenithRetreat",1,false)
		"nadir_retreat": anim.play("NadirRetreat",1,false)

func anim_zn_switch():
	can_interact = false
	%InteractSprite.visible = false
	if GameState.npcDict["zn"] % 2 == 0:
		anim_zn("nadir_retreat")
		await get_tree().create_timer(beat).timeout
		anim_zn("zenith_emerge")
		await get_tree().create_timer(beat).timeout
	if GameState.npcDict["zn"] % 2 != 0:
		anim_zn("zenith_retreat")
		await get_tree().create_timer(beat).timeout
		anim_zn("nadir_emerge")
	if player_contact:
			Sound.textPopup()
			can_interact = true
			%InteractSprite.visible = true

##Functions
#Determining initial animation state
func _ready() -> void:
	Dialogue.dialogue_end.connect(reset) #experimental
	if GameState.npcDict["jari"] != 0:
		jariFreed()
	match npcID:
		"Sculptor":
			anim_sculptor("idle")
		"Jari":
			if jariHiding:
				anim_jari("hide")
				myTarget.death_rattle.connect(jariFreed)
				%InteractArea2D.monitoring = false
			else: anim_jari("idle")
		"ZenithNadir":
			if GameState.npcDict["zn"] % 2 == 0: #if even
				anim_zn("zenith_emerge")
			else: anim_zn("nadir_emerge")

func _process(_delta: float) -> void:
	#Shows the dialogue state for debug purposes
	match npcID:
			"Sculptor":
				%DebugStateLabel.text = str(GameState.npcDict["sculptor"])
			"Jari":
				%DebugStateLabel.text = str(GameState.npcDict["jari"])
			"ZenithNadir":
				%DebugStateLabel.text = str(GameState.npcDict["zn"])

	if can_interact and !get_tree().paused:
		if Input.is_action_just_pressed("ui_accept") and !jariHiding and !GameState.target_player.dead:
			Sound.menu("accept")
			disable()
			talk()
	
	if !get_tree().paused:
		match npcID:
			"Sculptor":
				#if sculptor has his mask on, default to regular idle animation
				if anim.animation != "SculptorFaceReveal" and anim.animation != "SculptorUnmaskedTalk" and anim.animation != "SculptorUnmaskedReject" and anim.animation != "SculptorUnmaskedRejectedStare":
					anim_sculptor("idle")
				#Don't wait for player input, kill them
				if GameState.npcDict["sculptor"] == 98:
					BgmController.stopAll()
					%Music.stop()
					anim_sculptor("unmask_talk")
					Localize.reference_dialogue("SculptorPlayerAccept")
					GameState.npcDict["sculptor"] = 980
				#Ditto
				if GameState.npcDict["sculptor"] == 980:
					GameState.npcDict["sculptor"] = 981
					GameState.target_player.waiting = true
					LevelTransition.fadeToBlack()
					await get_tree().create_timer(1).timeout
					GameState.target_player.anim_death()
					GameState.playerHP = 0
					await get_tree().create_timer(3).timeout
					print("Changing scene")
					get_tree().change_scene_to_file("res://samael_plunder.tscn")
				#Player declines
				if GameState.npcDict["sculptor"] == 99:
					BgmController.stopAll()
					anim_sculptor("unmask_reject")
					Localize.reference_dialogue("SculptorPlayerDecline")
					GameState.npcDict["sculptor"] = 100 ##begin final battle (see below)
				if GameState.npcDict["sculptor"] == 100:
					GameState.battleStart()
					GameState.npcDict["sculptor"] = 101 ##begin final battle (see below)
			"Jari":
				if jariHiding:
					pass
				else: 
					#wait for her emerge animation to play
					if anim.animation != "JariActive":
						await get_tree().create_timer(beat).timeout
						anim_jari("idle")
			"ZenithNadir":
				if GameState.npcDict["zn"] % 2 != 0:
					#if zenith just got done talking
					if player_contact:
						if anim.animation == "ZenithTalk":
							anim_zn_switch()
				else: 
					#if nardir just got done talking
					if player_contact:
						if anim.animation == "NadirTalk":
							anim_zn_switch()

func on_interact_area_entered(_body: Node2D) -> void:
	Sound.textPopup()
	player_contact = true #the order is important
	can_interact = true
	match npcID:
		"Sculptor": 
			%InteractSpriteSculptor.visible = true
			%InteractSprite.visible = false
		"Jari":
			%InteractSprite.visible = true
			%InteractSpriteSculptor.visible = false
		"ZenithNadir": 
			%InteractSprite.visible = true
			%InteractSpriteSculptor.visible = false
			#if GameState.npcDict["zn"] % 2 == 0: #if even
				#anim_zn("zenith_emerge")
			#else: 
				#anim_zn("nadir_emerge")

func on_interact_area_exit(_body: Node2D) -> void:
	player_contact = false #the order is important
	disable()
	#match npcID:
		#"Sculptor": 
			#pass
		#"Jari":
			#pass
		#"ZenithNadir": 
			#if GameState.npcDict["zn"] % 2 == 0: #if even
				#anim_zn("zenith_retreat")
			#else: anim_zn("nadir_retreat")

##NPC dialogue, the meat of their functions are in here, should be analysed for break points
func talk():
	match npcID:
		"Sculptor":
			if GameState.npcDict["sculptor"] <= 96: #if sculptor hasn't unmasked already
				if !BgmController.samael_theme.playing:
					BgmController.stopAll()
					BgmController.samael_theme.play()
		"Jari":
			if !BgmController.jari_theme.playing:
				BgmController.stopAll()
				BgmController.jari_theme.play()
		"ZenithNadir":
			if !BgmController.zn_theme.playing:
				if GameState.abyssDict["abyssBoss"][0] == 0: #if abyss presnce not defeated
					BgmController.abyss_chasm_music.stop()
				BgmController.zn_theme.play()
	
	#Only want to start up a dialogue if there's not already an active dialouge
	if !Dialogue.isReading:
		match npcID: 
			"Sculptor":
				match GameState.npcDict["sculptor"]: #checking NPC id state
					0: #first meet
						if GameState.abyssDict["abyssTome"] == 0:
							anim_sculptor("showhands")
							Localize.reference_dialogue("SculptorIntro")
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
						else: 
							#this is to allow people to skip people talking to samael for the first time
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
							Localize.reference_dialogue("SculptorUpgradeGeneric")
							tomeConversion()
					1: #return
						if GameState.abyssDict["abyssTome"] == 0: #if doesn't have tome
							anim_sculptor("talk")
							Localize.reference_dialogue("SculptorRemindAmphora")
						else: 
							anim_sculptor("showhands")
							Localize.reference_dialogue("SculptorAmphoraDefeated")
							tomeConversion() ##convert tomes to efficiency
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
					2: #returning following Abyss Presence
						if GameState.abyssDict["abyssBoss"][0] == 0: #if boss not defeated
							anim_sculptor("talk")
							Localize.reference_dialogue("SculptorRemindAbyssal")
							tomeConversion() ##convert tomes to efficiency
							#Don't move dialogue forward
						else: 
							anim_sculptor("showhands")
							Localize.reference_dialogue("SculptorAbyssalDefeated")
							tomeConversion() ##convert tomes to efficiency
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
							#%DialogueIndicatorSamael.visible = true #show additional dialogue sign
					3:
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorAbyssalDefeated2")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					4:
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorAbyssalDefeated3")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					5: 
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorAbyssalDefeated4")
						tomeConversion() ##convert tomes to efficiency
						#%DialogueIndicatorSamael.visible = false
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					6: ##Upon talking in God's Wood
						if GameState.player_gods_wood_entered:
							anim_sculptor("talk")
							Localize.reference_dialogue("SculptorGodsWood")
							tomeConversion() ##convert tomes to efficiency
							#%DialogueIndicatorSamael.visible = true #show additional dialogue sign
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
						else: 
							if GameState.playerTomesHeld > 0:
								Localize.reference_dialogue("SculptorUpgradeGeneric")
								tomeConversion()
							else: Localize.reference_dialogue("NPCWaiting")
					7: ##Cont
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorGodsWood2")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					8: ##Cont
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorGodsWood3")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
						#%DialogueIndicatorSamael.visible = false #end dialogue chain
					9: 
						if GameState.woodsDict["woodsBoss"] == 1:
							anim_sculptor("showhands")
							Localize.reference_dialogue("SculptorGrowthDefeated")
							tomeConversion() ##convert tomes to efficiency
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
						else: 
							if GameState.playerTomesHeld > 0:
								Localize.reference_dialogue("SculptorUpgradeGeneric")
								tomeConversion()
							else: Localize.reference_dialogue("NPCWaiting")
					10: ##Church Town 
						if GameState.player_church_town_entered == true:
							anim_sculptor("talk")
							Localize.reference_dialogue("SculptorChurchTown")
							tomeConversion() ##convert tomes to efficiency
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
							#%DialogueIndicatorSamael.visible = true
					11: ##Church Town 
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorChurchTown2")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					12: ##Church Town 
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorChurchTown3")
						tomeConversion() ##convert tomes to efficiency
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
						#%DialogueIndicatorSamael.visible = false #end dialogue chain
					13:
						if GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
							anim_sculptor("talk")
							Localize.reference_dialogue("SculptorBellsRetrieved")
							tomeConversion() ##convert tomes to efficiency
							GameState.npcDict["sculptor"] += 1 #move dialogue forward
						else: 
							if GameState.playerTomesHeld > 0:
								Localize.reference_dialogue("SculptorUpgradeGeneric")
								tomeConversion()
							else: Localize.reference_dialogue("NPCWaiting")
					14: 
						Localize.reference_dialogue("SculptorEnterSanctuary")
						tomeConversion() ##convert tomes to efficiency
					#140: #player says no
						#Localize.reference_dialogue("SanctuaryDecline")
						#GameState.npcDict["sculptor"] = 14 #ask question again next time player walks up
					#141: #player agrees
						#Sound.enemy_slain()
						#LevelTransition.fadeToBlack()
						#await get_tree().create_timer(1.5).timeout
						#Sound.enemy_slain()
						#await get_tree().create_timer(1.5).timeout
						#get_tree().change_scene_to_file("res://sanctuary.tscn")
					15: ##Sanctuary
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorSanctuary")
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
						#%DialogueIndicatorSamael.visible = true #end dialogue chain
					16: ##Sanctuary
						anim_sculptor("showhands")
						Localize.reference_dialogue("SculptorSanctuary2")
						GameState.npcDict["sculptor"] += 1 #move dialogue forward
					17: ##Sanctuary
						anim_sculptor("talk")
						Localize.reference_dialogue("SculptorSanctuary3")
						GameState.npcDict["sculptor"] = 97 #move dialogue forward
						#%DialogueIndicatorSamael.visible = false #end dialogue chain
					97: ##Sculptor explains the question
						BgmController.stopAll()
						BgmController.abyss_chasm_music.play()
						anim_sculptor("unmask")
						Localize.reference_dialogue("SculptorQuestion")
						GameState.npcDict["sculptor"] = 970
					970: ##Question Prompt
						Localize.reference_dialogue("SculptorPrompt")
					98: ##Player agrees
						pass #ditto
					980: ##Player soul is plundered (Bad ending)
						pass #see process event
					99: ##Player Declines
						pass #ditto
					100:
						pass #ditto
						pass ##see res://smoke_bomb.gd
					101:
						pass ##see res://sculptor_reveal.gd
					102:
						BgmController.stopAll()
						BgmController.samael_battle.play()

			"Jari": 
				match GameState.npcDict["jari"]: #checking NPC id state
					0: 
						anim_jari("talk")
						Localize.reference_dialogue("JariIntro")
						GameState.npcDict["jari"] += 1 
					1:
						if GameState.playerBulbsHeld < 1: #if no bulbs
							anim_jari("talk")
							Localize.reference_dialogue("JariBloombulbReminder")
						else:
							anim_jari("talk")
							Localize.reference_dialogue("JariThanks")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
					2:  #If amphora defeated
						if GameState.abyssDict["abyssMiniBoss"] == 1:
							anim_jari("talk")
							Localize.reference_dialogue("JariAmphoraDefeated")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
						else: 
							if GameState.playerBulbsHeld > 0:
								anim_jari("talk")
								Localize.reference_dialogue("JariUpgradeGeneric")
								bulbConversion()
							else: 
								anim_jari("talk")
								Localize.reference_dialogue("JariBloombulbReminder")
					3: #Abyss Presence Defeated
						if GameState.abyssDict["abyssBoss"][0] == 1:
							anim_jari("talk")
							Localize.reference_dialogue("JariAbyssPresenceDefeated")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
						else: 
							if GameState.playerBulbsHeld > 0:
								anim_jari("talk")
								Localize.reference_dialogue("JariUpgradeGeneric")
								bulbConversion()
							else: 
								anim_jari("talk")
								Localize.reference_dialogue("JariBloombulbReminder")
					4: #Gods Wood Entered
						if GameState.player_gods_wood_entered:
							anim_jari("talk")
							Localize.reference_dialogue("JariGodsWood")
							GameState.npcDict["jari"] += 1
							bulbConversion()
						else: 
							if GameState.playerBulbsHeld > 0:
								anim_jari("talk")
								Localize.reference_dialogue("JariUpgradeGeneric")
								bulbConversion()
							else: 
								anim_jari("talk")
								Localize.reference_dialogue("JariBloombulbReminder")
					5: #Frenzied Growth Defeated
						if GameState.woodsDict["woodsBoss"] == 1:
							anim_jari("talk")
							Localize.reference_dialogue("JariGrowthDefeated")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
						else: 
							if GameState.playerBulbsHeld > 0:
								anim_jari("talk")
								Localize.reference_dialogue("JariUpgradeGeneric")
								bulbConversion()
							else: 
								anim_jari("talk")
								Localize.reference_dialogue("JariBloombulbReminder")
					6: #Church Town Entered
						if GameState.player_church_town_entered:
							anim_jari("talk")
							Localize.reference_dialogue("JariChurchTown")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
						else: 
							if GameState.playerBulbsHeld > 0:
								anim_jari("talk")
								Localize.reference_dialogue("JariUpgradeGeneric")
								bulbConversion()
							else: 
								anim_jari("talk")
								Localize.reference_dialogue("JariBloombulbReminder")
					7: #Jari Praise Player
						anim_jari("talk")
						Localize.reference_dialogue("JariPraise")
						GameState.npcDict["jari"] += 1
						bulbConversion()
					8: # Jari Motivational
						anim_jari("talk")
						Localize.reference_dialogue("JariMotivational")
						GameState.npcDict["jari"] += 1
						bulbConversion()
					9: # Jari Completion
						if GameState.playerBulbsHeld > 1 and GameState.playerCapacity < 5:
							anim_jari("talk")
							Localize.reference_dialogue("JariCompletion")
							GameState.npcDict["jari"] += 1 
							bulbConversion()
						else: GameState.npcDict["jari"] += 1 
					10: #Jari Upgrade Generic
						if GameState.playerBulbsHeld > 0:
							anim_jari("talk")
							Localize.reference_dialogue("JariUpgradeGeneric")
							bulbConversion()
						else: 
							Localize.reference_dialogue("NPCWaiting")
							Sound.JariPurr()
			"ZenithNadir":
				match GameState.npcDict["zn"]:
					0: ##Zenith Introduction
						anim_zn("zenith_talk")
						if GameState.playerKindlingHeld < 1:
							Localize.reference_dialogue("ZenithIntro")
							GameState.npcDict["zn"] += 1
						else:
							Localize.reference_dialogue("ZenithIntroAlt")
							kindlingConversion()
							GameState.npcDict["zn"] += 1
					1: ##Nadir Introduction
						anim_zn("nadir_talk")
						if GameState.playerKindlingHeld < 1:
							Localize.reference_dialogue("NadirIntro")
							GameState.npcDict["zn"] += 1 
						else:
							Localize.reference_dialogue("NadirIntroAlt")
							kindlingConversion()
							GameState.npcDict["zn"] += 1 
					2: ##Zenith Snide Remark
						anim_zn("zenith_talk")
						Localize.reference_dialogue("ZenithRetort")
						kindlingConversion()
						GameState.npcDict["zn"] += 1
					3: ##Nadir Retort
						anim_zn("nadir_talk")
						Localize.reference_dialogue("NadirRetort")
						kindlingConversion()
						GameState.npcDict["zn"] += 1
					4: #Zenith Abyss Presence
						if GameState.abyssDict["abyssBoss"][0] == 0: #if boss not defeated
							anim_zn("zenith_talk")
							Localize.reference_dialogue("ZenithAbyssPresence")
							kindlingConversion()
							GameState.npcDict["zn"] += 1
						else: 
							if GameState.playerKindlingHeld > 0:
								Localize.reference_dialogue("ZNUpgradeGeneric")
								kindlingConversion()
								GameState.npcDict["zn"] += 2 #skip
							else: 
								Localize.reference_dialogue("NPCWaiting")
								if anim.animation == "zenith_talk":
									Sound.ZenithHmm()
								if anim.animation == "nadir_talk":
									Sound.NadirSnort()
					5: #NadirAbyssPresence
						if GameState.abyssDict["abyssBoss"][0] == 0: #if boss not defeated
							anim_zn("nadir_talk")
							Localize.reference_dialogue("NadirAbyssPresence")
							kindlingConversion()
							GameState.npcDict["zn"] += 1
						else: 
							if GameState.playerKindlingHeld > 0:
								Localize.reference_dialogue("ZNUpgradeGeneric")
								kindlingConversion()
								GameState.npcDict["zn"] += 1 #skip
							else: 
								Localize.reference_dialogue("NPCWaiting")
								if anim.animation == "zenith_talk":
									Sound.ZenithHmm()
								if anim.animation == "nadir_talk":
									Sound.NadirSnort()
					6: 
						if GameState.player_gods_wood_entered:
							anim_zn("zenith_talk")
							Localize.reference_dialogue("ZenithGodsWood")
							kindlingConversion()
							GameState.npcDict["zn"] += 1
						else:
							if GameState.playerKindlingHeld > 0:
								Localize.reference_dialogue("ZNUpgradeGeneric")
								kindlingConversion()
							else: 
								Localize.reference_dialogue("NPCWaiting")
								if anim.animation == "zenith_talk":
									Sound.ZenithHmm()
								if anim.animation == "nadir_talk":
									Sound.NadirSnort()
					7: #Ditto
						anim_zn("nadir_talk")
						Localize.reference_dialogue("NadirGodsWood")
						kindlingConversion()
						GameState.npcDict["zn"] += 1
					8: 
						if GameState.player_church_town_entered:
							anim_zn("zenith_talk")
							Localize.reference_dialogue("ZenithChurchTown")
							kindlingConversion()
							GameState.npcDict["zn"] += 1
						else: 
							if GameState.playerKindlingHeld > 0:
								Localize.reference_dialogue("ZNUpgradeGeneric")
								kindlingConversion()
							else: 
								Localize.reference_dialogue("NPCWaiting")
								if anim.animation == "zenith_talk":
									Sound.ZenithHmm()
								if anim.animation == "nadir_talk":
									Sound.NadirSnort()
					9:
						if GameState.playerKindlingHeld > 0:
							Localize.reference_dialogue("ZNUpgradeGeneric")
							kindlingConversion()
						else: 
							Localize.reference_dialogue("NPCWaiting")
							if anim.animation == "zenith_talk":
								Sound.ZenithHmm()
							if anim.animation == "nadir_talk":
								Sound.NadirSnort()
					10:
						if GameState.playerKindlingHeld > 0:
							Localize.reference_dialogue("ZNUpgradeGeneric")
							kindlingConversion()
						else: 
							Localize.reference_dialogue("NPCWaiting")
							if anim.animation == "zenith_talk":
								Sound.ZenithHmm()
							if anim.animation == "nadir_talk":
								Sound.NadirSnort()

##functions similarly to collision_reset() on the HitboxComponent object
##after the dialogue is done, check if the player is still there and enable collisions if so
func reset():
	if npcID != "ZenithNadir":
		%InteractArea2D.monitoring = false
		await get_tree().create_timer(.10).timeout
		%InteractArea2D.monitoring = true

func disable():
	can_interact = false
	%InteractSprite.visible = false
	%InteractSpriteSculptor.visible = false

## Gameplay Functions
func tomeConversion():
	if GameState.playerTomesHeld > 0: #and GameState.playerEfficiency < 3: #if player has collected tomess
		GameState.playerEfficiency += GameState.playerTomesHeld
		GameState.playerTomesHeld = 0
		Sound.upgrade("sculptor")
		GameState.target_player.anim_sparkle()
		GameState.target_player.anim_enchant()
		GameState.target_player.show_sidebar()

func bulbConversion():
	if GameState.playerBulbsHeld > 0: #and GameState.playerCapacity < 5: #if player has bloombulbs
		GameState.playerCapacity += GameState.playerBulbsHeld
		GameState.playerBulbsHeld = 0
		Sound.upgrade("jari")
		GameState.target_player.show_sidebar()
		GameState.target_player.anim_sparkle()
		await get_tree().create_timer(.1).timeout
		GameState.fullHeal()

func kindlingConversion():
	if GameState.playerKindlingHeld > 0:
		GameState.target_player.position = self.position+Vector2(0,30)
		GameState.target_player.anim_unnerve()
		if GameState.npcDict["zn"] % 2 != 0:
			%NadirFlame.emitting = true
		else: 
			%ZenithFlame.emitting = true
		Sound.upgrade("zn")
		GameState.target_player.anim_sparkle()
		GameState.playerIntensity += GameState.playerKindlingHeld
		GameState.playerKindlingHeld = 0
		GameState.target_player.show_sidebar()
		await get_tree().create_timer(beat*2).timeout
		GameState.target_player.anim_reset()

func jariFreed():
	jariHiding = false
	reset()
	anim_jari("emerge")

#This function is copied in npc_impostor.gd
func _on_music_area_body_exited(_body: Node2D) -> void:
	var music_switch_wait : float = .5
	match npcID:
		"Sculptor":
			if BgmController.samael_theme.playing:
				if !GameState.player_gods_wood_entered and !GameState.player_church_town_entered:
					BgmController.abyss_main.play()
				if GameState.player_gods_wood_entered and !GameState.player_church_town_entered:
					BgmController.gods_wood.play()
				if GameState.player_gods_wood_entered and GameState.player_church_town_entered:
					BgmController.church_town.play()
				await get_tree().create_timer(music_switch_wait).timeout
				BgmController.samael_theme.stop()
		"Jari":
			if BgmController.jari_theme.playing:
				BgmController.abyss_main.play()
				await get_tree().create_timer(music_switch_wait).timeout
				BgmController.jari_theme.stop()
		"ZenithNadir":
			if BgmController.zn_theme.playing:
				if GameState.abyssDict["abyssBoss"][0] == 0: #if abyss presnce not defeated
					BgmController.abyss_chasm_music.play()
				await get_tree().create_timer(music_switch_wait).timeout
				BgmController.zn_theme.stop()
