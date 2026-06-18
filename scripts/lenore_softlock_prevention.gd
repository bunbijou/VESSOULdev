extends Node

##Sometimes, the player will load a save after defeating lenore; she will despawn herself, but in
##doing so, and as such, the player can never acquire Humanity, and never spawn the escape portal;
##this script just re-routes the player back to the Abyss

func _ready() -> void:
	if GameState.favor == 1:
		GameState.playerCurrentLocation = Vector2(0,320) #hardcoded location of abyss spawn point
		get_tree().call_deferred("change_scene_to_file","res://abyss.tscn")
		print("Rerouted player (Humanity already acquired)")
