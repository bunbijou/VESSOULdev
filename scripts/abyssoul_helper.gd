extends AnimatedSprite2D
@export_enum("A","B","C","D") var id : String = ""
@export var my_particle : CPUParticles2D
var shade_projectile = preload("res://scenes/abyss_orb.tscn")
var active : bool = false
var current : String = "A"
var iteration : int = 0
var casting : bool = false

func anim_appear():
	Sound.LurkerGiggle()
	self.play("default")
	my_particle.emitting = true
	
func anim_stun():
	if active and id == current:
		self.play("stun")
		@warning_ignore("integer_division")
		await get_tree().create_timer(GameState.cleanup_time_enemy/2).timeout
		self.play("default")

func anim_disappear():
	self.play("hide")
	my_particle.emitting = false


func _ready() -> void:
	%Abyssal.helper_start.connect(start)
	%Abyssal.helper_stop.connect(cleanup)
	%Abyssal.boss_stun.connect(anim_stun)

func start():
	if !active:
		active = true
		cast_loop()
		#await get_tree().create_timer(3).timeout
		#cycle()

func cleanup():
	Sound.rock_break()
	active = false

func _process(_delta: float) -> void:
	if active and !GameState.target_player.dead and !casting:
		cast_loop()
		cycle()

func cast_loop():
	var abyss_orb_instance = shade_projectile.instantiate()
	if id == current and !casting:
		casting = true
		anim_appear()
		await get_tree().create_timer(2).timeout
		add_child(abyss_orb_instance)
		abyss_orb_instance.lifetime = 10
		abyss_orb_instance.z_index = 999
		abyss_orb_instance.current_zone = 4
		abyss_orb_instance.velocity = (Vector2.RIGHT*0.85)
		await get_tree().create_timer(2).timeout
		anim_disappear()
		await get_tree().create_timer(2).timeout
		casting = false

func cycle():
	var interval : int = 3
	
	if current == "A":
		await get_tree().create_timer(interval*1).timeout
		current = "B"
	else: 
		if current == "B": 
			await get_tree().create_timer(interval*2).timeout
			current = "C"
		else: 
			if current == "C":
				await get_tree().create_timer(interval*3).timeout
				current = "D"
			else:
				await get_tree().create_timer(interval*4).timeout
				if current == "D":
					current = "A"
