class_name EnemyMuckMan extends Node2D

signal teamEmerge
signal death_rattle

@export var current_zone : int = 999
@export var detect_area : HitboxComponent
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var my_sprite_overlay : AnimatedSprite2D
@export var isLeader : bool #when the leader detects the player, the whole pack emerges
@export var leaderTarget : EnemyMuckMan 
@export var speed : float = .075
@export var mote_bonus_mult : float = 0
var active : bool = false
var emerged : bool = false
var dead : bool = false

## Animations
func anim_idle():
	my_sprite.play("float")
	my_sprite_overlay.play("float")

func anim_attack():
	my_sprite.play("attack")
	my_sprite_overlay.play("attack")
	await get_tree().create_timer(0.15).timeout
	Sound.muckman("attack")

func anim_activate():
	Sound.muckman("activate")
	my_sprite.play("erupt")
	my_sprite_overlay.play("erupt")

func anim_stun():
	my_sprite_overlay.visible = false
	Sound.muckman("pain")
	my_sprite.play("stun")
	await get_tree().create_timer(hit_area.hitstun).timeout
	my_sprite_overlay.visible = true
	anim_idle()

func anim_death():
	Sound.muckman("death")
	my_sprite.visible = false
	my_sprite_overlay.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_muckman,mote_bonus_mult,"small")

## Game
func _ready() -> void:
	flash_component.flash_detected.connect(flash)
	if !leaderTarget:
		detect_area.enemy_alert.connect(emerge)
	else: leaderTarget.teamEmerge.connect(emerge)
	hit_area.enemy_alert.connect(attack)
	hit_area.painState.connect(hurt)
	hit_area.death_rattle.connect(death)
	hit_area.disabled = true

func emerge():
	if isLeader:
		teamEmerge.emit()
	anim_activate()
	emerged = true #to keep from repeating the animation
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim can play
	hit_area.disabled = false
	active = true

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone and !dead: #if target player is in my zone (IMPORTANT!!)
		if emerged and active:
			detect_area.disabled = true
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += speed #move down on Y axis
				anim_idle()
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= speed #move up on Y axis
					anim_idle()
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += speed #move right
				anim_idle()
			else: 
				self.position.x -= speed #if player is to the left, move left
				anim_idle()

func attack():
	if !GameState.target_player.dead and !dead:
		active = false #stop moving
		anim_attack()
		GameState.target_player.isHurt(1+GameState.newgame)
		await get_tree().create_timer(hit_area.hitstun*2.25).timeout 
		active = true

func flash():
	if emerged and !dead:
		hit_area.hp -= flash_component.flash_damage
		hurt()
	#else: print("Muckman resisted damage")

func hurt():
	if GameState.target_player.current_zone == current_zone and !dead:
		if emerged:
			active = false #interrupt charge
			anim_stun()
			await get_tree().create_timer(hit_area.hitstun).timeout
			active = true #continue attack
	else: print ("Muckman resisted damage")

func death():
	if !dead:
		dead = true
		await get_tree().create_timer(hit_area.hitstun).timeout 
		anim_death()
		flash_component.is_flashable = false
		hit_area.on_touch_effect = "None"
		detect_area.on_touch_effect = "None"
		GameState.addKillCount()
		death_rattle.emit()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()
