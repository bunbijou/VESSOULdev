#remove node following defeat of Abyss Presence 
extends Node

func _ready() -> void:
	if GameState.abyssDict["abyssBoss"][0] == 1: #if boss defeated
			print("A darkness was lifted from the Abyss")
			queue_free()

func _process(_delta: float) -> void:
	if GameState.abyssDict["abyssBoss"][0] == 1: #if boss defeated
			print("A darkness was lifted from the Abyss")
			queue_free()
