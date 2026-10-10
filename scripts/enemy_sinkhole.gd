class_name EnemySinkhole extends Node2D

signal death_rattle 

#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
@export var current_zone : int = 999
@export var hit_area : HitboxComponent
@export var flash_component : FlashComponent
@export var my_sprite : AnimatedSprite2D
@export var overlay_sprite : AnimatedSprite2D
@export var overlay_sprite_aux : AnimatedSprite2D
@export var mote_bonus_mult : float = 0
var dead : bool = false

##---------ANIMATIONS-----------##
func anim_idle():
	self.scale = Vector2(1,1)
	my_sprite.animation = "default"
	overlay_sprite.visible = true
	overlay_sprite_aux.visible = true

func anim_stun():
	Sound.sinkhole("pain")
	my_sprite.animation = "stun"
	overlay_sprite.visible = false
	overlay_sprite_aux.visible = false
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
	if !dead:
		anim_idle()

func anim_swallow():
	Sound.fallOut()

func anim_death():
	Sound.sinkhole("death")
	my_sprite.visible = false
	%eyeSpriteRed.visible = false
	%darkSpriteSwirl.visible = false
	%DeathParticle.emitting = true
	GameState.mote_reward(GameState.reward_sinkhole,mote_bonus_mult,"small")

##-----------FUNCTIONS--------------##
func _ready() -> void:
	anim_idle()
	flash_component.flash_detected.connect(flash)
	hit_area.painState.connect(hurt)
	hit_area.player_reposition.connect(displace_player)
	hit_area.death_rattle.connect(death)

func displace_player():
	if !dead:
		GameState.target_player.position = self.position
		anim_swallow()

func flash():
	if GameState.target_player.current_zone == current_zone and !dead:
		anim_stun()
		hit_area.hp -= flash_component.flash_damage
	else: print ("Sinkhole resisted damage")

func hurt():
	if GameState.target_player.current_zone == current_zone and !dead:
		anim_stun()
	else: print ("Sinkhole resisted damage")

func death():
	if !dead:
		dead = true
		hit_area.on_touch_effect = "None"
		anim_death()
		death_rattle.emit()
		GameState.addKillCount()
		await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
		queue_free()
