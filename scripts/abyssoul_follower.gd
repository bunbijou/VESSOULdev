extends Node2D
@export var rot : float = 0#0.005
@export var lifetime : float = 999
@export var movement : bool = true
var velocity : Vector2 = Vector2.RIGHT

#func _ready() -> void:
	#%Abyssal.helper_stop.connect(cleanup)
#
#func _physics_process(_delta: float) -> void:
	#%WheelShape.rotation += rot
	#%Helper1.position = %Point1.position
	#%Helper1.rotation -= rot
	#%Helper2.position = %Point2.position
	#%Helper2.rotation -= rot
	#%Helper3.position = %Point3.position
	#%Helper3.rotation -= rot
	#%Helper4.position = %Point4.position
	#%Helper4.rotation -= rot
#
#func cleanup():
	#queue_free()
