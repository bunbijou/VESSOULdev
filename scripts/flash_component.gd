class_name FlashComponent extends Node2D

signal flash_detected

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var is_flashable : bool = true
var flash_damage : int = 0

func anim_reset():
	%FlashResidualEffect.visible = false
	%FlashResidualEffect.animation = "default"

func anim_dazzle(duration : float):
	%FlashResidualEffect.visible = true
	%FlashResidualEffect.play("dazzle",1,false)
	await get_tree().create_timer(duration).timeout
	anim_reset()

func _ready() -> void:
	await get_tree().create_timer(.35).timeout
	GameState.target_player.flashed.connect(_flashed)
	GameState.target_player.flash_weak.connect(_flash_weak)
	anim_reset()

func _flashed():
	##Shade effect will block all flash attempts even if the caster is outside the player zone
	if !GameState.shadeActive and is_flashable:
			flash_damage = 1+GameState.playerDamageMod
			flash_detected.emit()
			anim_dazzle(1)

func _flash_weak(): #Endless Mode Only
	if !GameState.shadeActive and is_flashable:
			flash_damage = 1
			flash_detected.emit()
			anim_dazzle(0.5)
