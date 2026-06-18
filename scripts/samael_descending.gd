extends Node2D

signal cast_flame

func _ready() -> void:
	BgmController.track_miracle.play()
	Sound.samael("incant_fire")

func attack_begin():
	cast_flame.emit()
