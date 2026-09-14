##GLOBAL - BgmController
extends Node
var default : AudioStreamPlayer
@export_category("Note: These are triggered by zones")
@export var abyss_main : AudioStreamPlayer
@export var gods_wood : AudioStreamPlayer
@export var church_town : AudioStreamPlayer
@export var success_jingle : AudioStreamPlayer
@export var abyss_chasm_ambience : AudioStreamPlayer
@export var abyss_chasm_music : AudioStreamPlayer
@export var catacombs : AudioStreamPlayer
@export var battle_1 : AudioStreamPlayer
@export var battle_2 : AudioStreamPlayer
@export var battle_3 : AudioStreamPlayer
@export var menu_theme : AudioStreamPlayer
@export var battle_frenzygrowth : AudioStreamPlayer
@export var samael_theme : AudioStreamPlayer
@export var jari_theme : AudioStreamPlayer
@export var samael_battle : AudioStreamPlayer
@export var descent_battle : AudioStreamPlayer
@export var djinn_battle : AudioStreamPlayer
@export var ending_bad : AudioStreamPlayer
@export var ending_good : AudioStreamPlayer
@export var zn_theme : AudioStreamPlayer
@export var impostor_theme : AudioStreamPlayer
@onready var track_leviathan = %DylgLeviathan
@onready var track_brawl = %DylgBrawl
@onready var track_options = %DylgOptions
@onready var track_armaments = %DylGArmaments
@onready var track_forge = %DylgForge
@onready var track_killer = %DylgKiller
@onready var track_market = %DylgMarket
@onready var track_palette = %DylgPalette
@onready var track_training = %DylgTraining
@onready var track_moon = %BunbijouMoon
@onready var track_drive = %DylGDrive
@onready var track_soul = %DylGSoul
@onready var track_tomorrow = %BunbijouTomorrow
@onready var track_echoes = %DylgEchos
@onready var track_phantoms = %DylgPhantoms
@onready var track_grimoire = %DylgGrimoire
@onready var track_incantation = %DylgIncantation
@onready var track_miracle = %DylgMiracle
@onready var track_trial = %TrialLoop
@onready var track_aeon = %DylGAeon
@onready var track_ambush = %DylGAmbush
#@onready var track_maze_ruler = %MazeRulerTheme

func _ready() -> void:
	default = abyss_main

func begin_playing(input: Array[AudioStreamPlayer]): #
	## Random sound variants
	var variant_count : int = len(input)
	var music_selection : AudioStreamPlayer
	if variant_count >= 2:
		randomize()
		music_selection = input.pick_random()
	else: music_selection = input[0]
	if !music_selection.playing:
		music_selection.play()

func play_random():
	begin_playing([%DylgLeviathan,%DylgBrawl,%DylgTraining,%DylGArmaments,%DylgKiller,%DylGAeon,%DylGAmbush])

func stopAll():
	abyss_main.stop()
	church_town.stop()
	gods_wood.stop()
	abyss_chasm_ambience.stop()
	abyss_chasm_music.stop()
	catacombs.stop()
	battle_1.stop()
	battle_2.stop()
	battle_3.stop()
	battle_frenzygrowth.stop()
	jari_theme.stop()
	samael_battle.stop()
	descent_battle.stop()
	djinn_battle.stop()
	menu_theme.stop()
	ending_bad.stop()
	ending_good.stop()
	samael_theme.stop()
	zn_theme.stop()
	impostor_theme.stop()
	track_leviathan.stop()
	track_brawl.stop()
	track_options.stop()
	track_armaments.stop()
	track_forge.stop()
	track_killer.stop()
	track_market.stop()
	track_palette.stop()
	track_training.stop()
	track_moon.stop()
	track_drive.stop()
	track_soul.stop()
	track_tomorrow.stop()
	track_echoes.stop()
	track_grimoire.stop()
	track_incantation.stop()
	track_miracle.stop()
	track_phantoms.stop()
	track_trial.stop()
	track_ambush.stop()
	track_aeon.stop()

func _on_bgm_deep_abyss_finished() -> void:
	default.play()
	default.stop() 
	print("Called the obscure on_deep_abyss_finished function")
