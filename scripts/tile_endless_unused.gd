extends Node2D
@export var top : bool = false
@export var bottom : bool = false
@export var left : bool = false
@export var right : bool = false
@export var my_sprite : AnimatedSprite2D
@export var collider_up : RayCast2D
@export var collider_down : RayCast2D
@export var collider_left : RayCast2D
@export var collider_right : RayCast2D

func _ready() -> void:
	##Check neighboring tiles
	if collider_down.is_colliding:
		bottom = true
	if collider_up.is_colliding:
		top = true
	if collider_left.is_colliding:
		left = true
	if collider_right.is_colliding:
		right = true
	determine_appearance()

func determine_appearance():
	##Change appearance depending on my neighbors
	#if !bottom and !top and !left and !right:
		#my_sprite.frame = 0 #no neighbors
	
	if !bottom and !top and left and !right:
		my_sprite.frame = 1 #neighbor on left only
	
	if bottom and !top and !left and !right:
		my_sprite.frame = 2 #neighbor on bottom only
	
	if !bottom and !top and !left and !right:
		my_sprite.frame = 3 #neighbor on right only
	
	if !bottom and top and left and right:
		my_sprite.frame = 4 #neighbors on left,top,right
	#
	#if top and left and right and bottom:
		#my_sprite.frame = 5 #neighbors on all sides
