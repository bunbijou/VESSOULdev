extends Node2D
##How quickly the wheel should move over time
@export var node_spd : float = 0.5
##How quickly the spacing between individual nodes should increase
var scaling : float = 0.005
##How fast the wheel body should rotate
@export var rot : float = 0.005
##How long until the wheel should disappear
@export var lifetime : float = 5.00
##Whether the wheel should move over time
@export var movement : bool = true
var velocity : Vector2 = Vector2.RIGHT

func _ready() -> void:
	if movement:
		self.rotation = get_angle_to(GameState.target_player.position)
		velocity = velocity.rotated(self.rotation)
	Sound.fire("small")
	await get_tree().create_timer(lifetime).timeout
	queue_free() 
	Sound.vesselflower("flame_extinguish")
	

func _physics_process(_delta: float) -> void:
	if movement:
		position += velocity
	%WheelRot.rotation += rot
	%FireNode1.rotation += rot
	%FireNode2.rotation += rot
	%FireNode3.rotation += rot
	%FireNode4.rotation += rot
	%FireNode6.rotation += rot
	%FireNode7.rotation += rot
	%FireNode8.rotation += rot
	%WheelShape.scale += Vector2(scaling,scaling)
	%Node1.position += Vector2(0,-node_spd) ##move up
	%Node2.position += (Vector2(-node_spd,-node_spd))*0.75 ##move up and left
	%Node3.position += (Vector2(node_spd,-node_spd))*0.75 ##move up and right
	%Node4.position += Vector2(node_spd,0) ##move right
	%Node5.position += Vector2(-node_spd,0) ##move left
	%Node6.position += (Vector2(-node_spd,node_spd))*0.75 ##move down and left
	%Node7.position += (Vector2(node_spd,node_spd))*0.75 ##move down and right
	%Node8.position += Vector2(0,node_spd) ##move down
	%FireNode1.position = %Node1.position
	%FireNode2.position = %Node2.position
	%FireNode3.position = %Node3.position
	%FireNode4.position = %Node4.position
	%FireNode5.position = %Node5.position
	%FireNode6.position = %Node6.position
	%FireNode7.position = %Node7.position
	%FireNode8.position = %Node8.position
