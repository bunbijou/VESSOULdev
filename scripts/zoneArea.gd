class_name AreaZone extends Node2D

@onready var isActive : bool
@export var zoneCamera : Camera2D
@export var myID : int
@export_category("Set this to keep the player's area from overriding music")
@export var override : bool = false 
var music : AudioStreamPlayer
var follow_up : bool = false

func _ready() -> void:
	if GameState.impostor:
		Dialogue.dialogue_end.connect(addendum)
	isActive = false #for use by objects e.g doors, illusory walls, chests
	if !override:
		BgmController.stopAll()
	else: print("zoneArea.gd - Stop music deferred")

func _on_area_2d_body_entered(_body: PlayerVessel) -> void:
	GameState.target_player.current_zone = myID
	isActive = true #we want all the objects tied to this zone to also become active
	print("Player entered zone " + str(GameState.target_player.current_zone))
	music_swap()

func music_swap():
	if !override:
		match myID:
			0: ## Abyss - Start
				if !BgmController.abyss_main.playing:
					BgmController.stopAll()
					BgmController.abyss_main.play()
			1: ##Cave of Reflection
				if !BgmController.abyss_main.playing:
					BgmController.stopAll()
					BgmController.abyss_main.play()
			2: ##Grave of a Hero (first samael spot)
				if !BgmController.abyss_main.playing:
							BgmController.stopAll()
							BgmController.abyss_main.play()
			3: ##MINIBOSS - Amphora
					Sound.LoopingSoundCleanup()
					if !GameState.abyssDict["abyssMiniBoss"] == 1  and !BgmController.battle_1.playing:
						BgmController.stopAll()
						BgmController.battle_2.play()
					else:
						if !BgmController.abyss_main.playing:
							BgmController.stopAll()
							BgmController.abyss_main.play()
			4: ## Abyssoul arena
				if GameState.abyssDict["abyssBoss"][0] == 1:
					BgmController.stopAll()
					BgmController.abyss_chasm_ambience.play()
			6: ##Jari's Hideaway (Secret)
				if !BgmController.abyss_main.playing:
							BgmController.stopAll()
							BgmController.abyss_main.play()
			7: ## Acolyte's Labyrinth (Secret)
				if !BgmController.abyss_main.playing:
					BgmController.stopAll()
					BgmController.abyss_main.play()
			8: ## Chasm Outlet
				GameState.player_gods_wood_entered = true #SUPER SUPER SUPER DUPER IMPORTANT
				if !BgmController.gods_wood.playing:
						Sound.LoopingSoundCleanup()
						BgmController.stopAll()
						BgmController.gods_wood.play()
			11: ## Pumpkin Patch (leaving Blazin' arena)
				if !BgmController.gods_wood.playing:
					BgmController.stopAll()
					BgmController.gods_wood.play()
			12: ## Ruined Fort (leaving FrenzyGrowth arena)
				if !BgmController.gods_wood.playing:
					BgmController.stopAll()
					BgmController.gods_wood.play()
			13: ## BOSS - Frenzied Growth
				if !GameState.woodsDict["woodsBoss"] == 1  and !BgmController.battle_1.playing:
					BgmController.stopAll()
					BgmController.battle_frenzygrowth.play()
			14: ## MINIBOSS - Blazing Stump (Secret)
				if !GameState.woodsDict["woodsMiniBoss"][1] != 0  and !BgmController.battle_3.playing:
					BgmController.stopAll()
					BgmController.battle_3.play()
			15: ## Depths outlet 
				#Sound.LoopingSoundCleanup()
				if !BgmController.gods_wood.playing:
					BgmController.stopAll()
					BgmController.gods_wood.play()
			16: ## Town Gate Interior
				GameState.player_church_town_entered = true #SUPER SUPER SUPER DUPER IMPORTANT
				if !BgmController.church_town.playing:
					Sound.LoopingSoundCleanup()
					BgmController.stopAll()
					BgmController.church_town.play()
				#NG+ Secret boss route only
				if GameState.impostor:
					#await get_tree().create_timer(1).timeout
					##if player has no bells rung
					if GameState.townDict["townSanctuaryBells"][0] == 0 and GameState.townDict["townSanctuaryBells"][1] == 0:
						#temporarily alter bell state to indicate dialogue phase
						GameState.townDict["townSanctuaryBells"][0] = -1
						GameState.townDict["townSanctuaryBells"][1] = -1
						GameState.target_player.anim_samael_emerge()
						Localize.reference_dialogue("SamaelSpriteGuidance") #tell player to ring bells
					#if player has one of two bells rung (Option A)
					if GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] != 1:
						GameState.target_player.anim_samael_emerge()
						Localize.reference_dialogue("SamaelSpriteHalfwayPoint") #tell player to ring the other bell
					
					#if player has one of two bells rung (Option B)
					if GameState.townDict["townSanctuaryBells"][0] != 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
						GameState.target_player.anim_samael_emerge()
						Localize.reference_dialogue("SamaelSpriteHalfwayPoint") #tell player to ring the other bell
					
					#if player has rung both bells
					if GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
						GameState.target_player.anim_samael_emerge()
						Localize.reference_dialogue("SamaelSpriteWarning")
			17: ## Gaping Jawer Arena
				if !GameState.woodsDict["woodsMiniBoss"][0] == 1 and !BgmController.battle_2.playing:
					BgmController.stopAll()
					BgmController.battle_2.play()
			-17: ## Broken Well (Catacombs entrance)
				if !BgmController.church_town.playing:
					Sound.LoopingSoundCleanup()
					BgmController.stopAll()
					BgmController.church_town.play()
			18: ## Town Square
				if !BgmController.church_town.playing:
					BgmController.stopAll()
					BgmController.church_town.play()
			19: ##FINAL BOSS - The Forsaken
				BgmController.stopAll()
			-19: ##SECRET FINAL BOSS - Ebon Vessel / Mad Mote
				BgmController.stopAll()
			22: ##Sculptor's Garden (Secret)
				if !BgmController.samael_theme.playing:
					BgmController.stopAll()
					BgmController.samael_theme.play()
			24: ##MINIBOSS - Censer
				if GameState.townDict["townMiniBoss"] == 0: #if not already defeated
					BgmController.stopAll()
					BgmController.battle_1.play()

func addendum():
	if !follow_up and GameState.target_player.current_zone == 16 and GameState.townDict["townSanctuaryBells"][0] == 1 and GameState.townDict["townSanctuaryBells"][1] == 1:
		await get_tree().create_timer(.01).timeout #IMPORTANT 
		Localize.reference_dialogue("ImpostorEnterSanctuary")
		follow_up = true #prevent further prompts
