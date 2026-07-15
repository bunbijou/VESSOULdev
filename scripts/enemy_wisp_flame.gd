class_name EnemyWisp extends Node2D

@export var my_sprite : AnimatedSprite2D
@onready var wisp_parent : WispBase
var dead : bool = false
var enabled : bool = false

func _ready() -> void:
	await get_tree().create_timer(.35).timeout
	if wisp_parent:
		wisp_parent.death_rattle.connect(death)
		wisp_parent.enable_wisps.connect(enable)

func enable():
	print("Wisp enabled")
	if !enabled:
		Sound.vesselflower("flame_extinguish")
		toggle(true)
		%FireExplosion.emitting = true

func toggle(state : bool):
	enabled = state
	self.visible = state

func _physics_process(_delta: float) -> void:
	if !dead:
		self.rotation -= .05
		my_sprite.rotation = -(self.rotation)

func death():
	if !dead:
		%FireExplosion.emitting = true
		%IdleFlame.emitting = false
		dead = true
		Sound.vesselflower("flame_extinguish")
		my_sprite.play("fizzle")
		await get_tree().create_timer(.35).timeout
		queue_free()


func _on_rotation_child_area_2d_body_entered(_body: PlayerVessel) -> void:
	if !dead and enabled:
		if GameState.npcDict["zn"] != 999: #Endless Mode Only
			GameState.target_player.isHurt(1+GameState.newgame)
		GameState.target_player.is_burning()
		Sound.PlayerDamaged()
