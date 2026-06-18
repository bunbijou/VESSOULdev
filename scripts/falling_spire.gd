class_name FallingRock extends Node2D

@export var delay : float
@export var sprite : AnimatedSprite2D
@export var hit_area : HitboxComponent
@export var target_enemy : Node2D
@export var attack_area_0 : Vector2 ## Top Left
@export var attack_area_1 : Vector2 ## Top Right
@export var attack_area_3 : Vector2 ## Bottom Left
@export var attack_area_4 : Vector2 ## Bottom Right
var active : bool = false
var impact_area : Vector2
var target_acquired : bool
var variability : float = 50
var fall_speed : float = 3


func _ready() -> void:
	self.position = Vector2(999,999)
	target_enemy.cast_spikes.connect(activate)
	hit_area.on_touch_effect = "None"
	#%Node1.position = attack_area_0
	#%Node2.position = attack_area_1
	#%Node3.position = attack_area_3
	#%Node4.position = attack_area_4

func activate():
	if !active:
		active = true
		self.visible = true
		sprite.animation = "default"
		await get_tree().create_timer(delay*1.5).timeout
		get_destination()

func get_destination():
		randomize()
		impact_area = Vector2((randf_range(attack_area_0[0], attack_area_1[0])),(randf_range(attack_area_0[1], attack_area_4[1])))
		self.position = impact_area-Vector2(0,randfn(0.0, variability)+250)
		target_acquired = true ##see below
		Sound.fallOut()

func _physics_process(_delta: float) -> void:
	if target_acquired:
		self.position.y += fall_speed
		
		if self.position.y >= impact_area[1]:
			shatter()
			target_acquired = false


func shatter():
	%BreakParticle.emitting = true
	sprite.play("break")
	hit_area.on_touch_effect = "Hazard"
	Sound.stone_break()
	await get_tree().create_timer(.25).timeout
	hit_area.on_touch_effect = "None"
	await get_tree().create_timer(2.5).timeout
	conceal()



func conceal():
	active = false
	self.visible = false
	self.position = Vector2(999,999)
