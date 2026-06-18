class_name EnemyMoteMouse extends Node2D

@export var current_zone : int = 999
@export var my_sprite : AnimatedSprite2D
#var current_zone = 999 #will inherit from parent 
#var active : bool = false
##They're smaller, so it's ok if these guys are a little faster
@export var speed : float = .45
var dead : bool = false

func anim_idle():
	my_sprite.play("default",0)

func anim_active():
	my_sprite.play("default",1)

func anim_stun():
	my_sprite.play("stun",1)

func anim_death():
	Sound.motemouse("death")
	my_sprite.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_motemouse,0,"small")

func _ready() -> void:
	Sound.motemouse("squeak")
	%DetectBox.set_deferred("monitoring", true)
	GameState.target_player.flashed.connect(_enemyDamaged)
	GameState.target_player.flash_weak.connect(_enemyDamaged)

	anim_active()

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone:
		if self.position.y < GameState.target_player.position.y: #if player is below us
			self.position.y += speed #move down on Y axis
		else:
			if self.position.y >= GameState.target_player.position.y: #if player is above us
				self.position.y -= speed #move up on Y axis
		if self.position.x < GameState.target_player.position.x: #if player is to the right
			self.position.x += speed #move right
			my_sprite.flip_h = false
		else: 
			self.position.x -= speed #if player is to the left, move left
			my_sprite.flip_h = true

##Only able to be damaged by flash + Only has 1 HP
func _enemyDamaged(): 
	if GameState.target_player.current_zone == current_zone: # and active:
		#active = false
		speed = 0
		anim_stun()
		await get_tree().create_timer(.35).timeout 
		if !dead:
			dead = true
			anim_death()
			GameState.addKillCount()
			await get_tree().create_timer(5).timeout
			queue_free()
	#else: print("Motemouse hid from damage")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	anim_active()
	Sound.motemouse("squeak")
	%GrabBox.set_deferred("monitoring", true)
	GameState.target_player.mice_count += 1
	self.position = Vector2(999,999)
	queue_free()

#func _on_detect_box_body_entered(_body: Node2D) -> void:
	#Sound.motemouse("squeak")
	#active = true
	#%DetectBox.set_deferred("monitoring", true)
