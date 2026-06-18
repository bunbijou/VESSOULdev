extends Node2D

@export var childMaws : Array
var active = false

#func _process(_delta: float) -> void:
	#for i in childMaws.size():
		#childMaws[i].scale = Vector2(0.5,0.5)
	#
	#if !active:
		#for i in childMaws.size():
			#childMaws[i].monitoring = false
	#else:
		#for i in childMaws.size():
			#childMaws[i].monitoring = true
