extends Node
@export_enum("Abyss","Woods","Town") var location: String

##This function is copied in npc_impostor.gd
func _ready() -> void:
	## We don't want instances of OG Samael overlapping with the Impostor
	if !GameState.impostor:
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
				print("Samael is in his final location")
	else: 
		print("Samael replaced by Impostor")
		queue_free()
