##Stage Exit
class_name WarpPortal extends Area2D


@export_enum("res://abyss.tscn","res://chasm.tscn","res://woods.tscn","res://depths.tscn","res://town.tscn","res://catacombs.tscn","res://clerestory.tscn","res://scenes/nullscn.tscn","res://darkspace.tscn") var destination : String = "res://scenes/nullscn.tscn"
@export var anim : AnimationPlayer
@export var my_sprite : AnimatedSprite2D
@export var myLabel : Label
@export_enum(" ","ToGodsWood","ToChasm","ToAbyss","ToTown") var LabelText : String = ""
@export var woods_warp : bool = false
@export var overridePlayerPosition = false
@export var newPlayerCoord : Vector2

#@export_category("Use this if you want the warp to be hidden behind a boss")
@export var requires_condition : bool = false
@export var target_enemy : Node2D

##Unused, see warp_special.gd
#@export_category("Lenore")
#var miniBossScene : String = "res://lenore.tscn"
#@export var isBlack = false

func _ready() -> void:
	match LabelText:
		"":
			myLabel.text = ""
		"ToGodsWood":
			myLabel.text = str(Localize.to_gods_wood)
		"ToChasm":
			myLabel.text = str(Localize.to_abyss_chasm)
		"ToAbyss":
			myLabel.text = str(Localize.to_abyss_proper)
		"ToTown":
			myLabel.text = str(Localize.return_to_town)
		

	## Normal, free-use portals
	if !requires_condition:
		anim.current_animation = "default"
	else:  ##Post-boss one-time warps E.g. after Lenore, Town miniboss etc.
		if target_enemy:
			target_enemy.death_rattle.connect(conditionMet)
			anim.current_animation = "hidden"

	##Unused, see warp_special.gd
	#if isBlack:
		#if GameState.abyssDict["abyssBoss"][0] == 1: #if abyss presence defeated
			#anim.current_animation = "black"
			##self.visible = true
			#if GameState.abyssDict["abyssBoss"][1] == 1: #if lenore defeated
				#anim.current_animation = "hidden"
				##self.visible = false
		#else:
			#anim.current_animation = "hidden"
			##self.visible = false

func _process(_delta: float) -> void:
	##Post-Abyss Presence Woods Warp
	if woods_warp:
		if GameState.abyssDict["abyssBoss"][0] == 1:
			anim.current_animation = "default"
		else: anim.current_animation = "hidden"

func _on_body_entered(_body: Node2D) -> void:
		GameState.playerCurrentLocation = newPlayerCoord
		LevelTransition.animation_player.current_animation = "fadeout"
		changeScene()

func changeScene():
		Sound.warp()
		#Maintain the player HP state between scenes
		GameState.player_hp_previous = GameState.playerHP
		get_tree().call_deferred("change_scene_to_file",destination)
		LevelTransition.animation_player.current_animation = "fadein"

func conditionMet():
	requires_condition = false
	anim.current_animation = "default"
