#Cremator Explosive Fireball
extends Node2D
@export var startDelay = 0.0

func _ready() -> void:
	%AnimatedSprite2D.visible = true
	%FireHitbox.on_touch_effect = "Burning" #unblockable damage
	%AnimatedSprite2D.speed_scale = 1
	await get_tree().create_timer(0.2).timeout #wait for spark animation
	%FlameBurst.emitting = true
	Sound.explosion()
	#if startDelay != 0:
		#%AnimatedSprite2D.visible = false
		#%AnimatedSprite2D.speed_scale = 0

#func _startup():
	#if !GameState.target_player.dead:
		#await get_tree().create_timer(startDelay).timeout #add to enemy stat block?
		#%AnimatedSprite2D.visible = true
		#%FireHitbox.on_touch_effect = "Burning" #unblockable damage
		#%AnimatedSprite2D.speed_scale = 1
		#await get_tree().create_timer(0.2).timeout #wait for spark animation
		#Sound.explosion()
	
func _process(_delta: float) -> void:
	if %AnimatedSprite2D.frame == 8: #after animation is done, reset automatically
		queue_free()
		#_reset()

#func _reset():
	#%AnimatedSprite2D.speed_scale = 0
	#%AnimatedSprite2D.frame = 0
	#%FireHitbox.on_touch_effect = "None" #disable hitbox
	#%AnimatedSprite2D.visible = false
