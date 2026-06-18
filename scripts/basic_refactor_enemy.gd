extends Node2D #class_name ExampleEnemy
##This class is just an example, it shouldn't be actually used for anything

signal death_rattle

##Should be the same for pretty much every enemy, very few entities don't reference this in someway
#@onready var target_player : PlayerVessel = get_tree().get_first_node_in_group("Player")
##Determines when this entity should be active/affected by broadly-reaching behaviors such as flash
@export var current_zone : int = 999
##Component that keeps track of health, conveys pain and death states, and shows health readouts
@export var hit_area : HitboxComponent
##Component that enables flash damage, also controls the visual effect of an enemy that has been flashed
@export var flash_component : FlashComponent
##Shorthand for the main sprite, can be augmented, see below for examples
@export var my_sprite : AnimatedSprite2D
@export var my_sprite_auxillary : AnimatedSprite2D
@export var sprite_overlay : AnimatedSprite2D
##In the case of a static (non-moving) enemy, get rid of the associated movement code
@export var speed : float = 1
##----------ANIMATIONS-----------##

func anim_idle():
	my_sprite.animation = "default"

func anim_active():
	my_sprite.animation = "active"
	
func anim_stun():
	Sound.painGeneric()
	my_sprite.animation = "stun"
	await get_tree().create_timer(hit_area.hitstun).timeout
	anim_idle()

func anim_death():
	Sound.deathGeneric()

##---------FUNCTIONS----------##

func _ready() -> void:
	##if flashable
	flash_component.flash_detected.connect(hurt)	
	hit_area.painState.connect(hurt)
	hit_area.death_rattle.connect(death)

##Super duper simple movement
func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone and GameState.isPaused:
		if self.position.y < GameState.target_player.position.y: #if player is below us
			self.position.y += speed #move down on Y axis
		else:
			if self.position.y >= GameState.target_player.position.y: #if player is above us
				self.position.y -= speed #move up on Y axis
			
		if self.position.x < GameState.target_player.position.x: #if player is to the right
			self.position.x += speed #move right
		else: 
			self.position.x -= speed #if player is to the left, move left


func hurt():
	anim_stun()
	#other stuff

func flash():
	hit_area.hp -= flash_component.flash_damage
	hurt()

func death():
	anim_death()
	await get_tree().create_timer(hit_area.hitstun).timeout #wait so anim and sound can play
	death_rattle.emit()
	GameState.addKillCount()
	await get_tree().create_timer(GameState.cleanup_time_enemy).timeout
	queue_free() #banish self to shadow realm
