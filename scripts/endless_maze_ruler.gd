extends Node2D

@export var speed_mod : float = 0.05
@export var my_sprite : AnimatedSprite2D
@export var hit_area : HitboxComponent
var active : bool = false

func anim(type : String):
	match type:
		"active":
			match GameState.endless["theme"]:
				0: 
					my_sprite.play("dawn_active")
				1:
					my_sprite.play("dusk_active")
				2:
					my_sprite.play("twilight_active")
		"attack":
			match GameState.endless["theme"]:
				0: 
					Sound.impact() #placeholder
					my_sprite.play("dawn_attack")
				1:
					Sound.ThreeTendrilSwipe() #placeholder
					my_sprite.play("dusk_attack")
				2:
					Sound.mimic("bite") #placeholder
					my_sprite.play("twilight_attack")
		"stun":
			match GameState.endless["theme"]:
				0: 
					my_sprite.play("dawn_stun")
					await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
					anim("active")
				1:
					my_sprite.play("dusk_stun")
					await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
					anim("active")
				2:
					my_sprite.play("twilight_attack")
					await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
					anim("active")

func anim_update(theme : int):
	match theme:
		0: my_sprite.play("dawn_active")
		1: my_sprite.play("dusk_active")
		2: my_sprite.play("twilight_active")

func _ready() -> void:
	%EndlessConfig.activate_E.connect(start)
	%EndlessConfig.condition_met.connect(disable)
	%EndlessConfig.update_theme.connect(anim_update)
	GameState.target_player.flashed.connect(stun)
	GameState.target_player.flash_weak.connect(stun_weak)

func start():
	var direction = 0
	var offset = 200
	anim("active")
	randomize()
	direction = randi() % 4
	active = true
	BgmController.stopAll()
	await get_tree().create_timer(0.1).timeout
	BgmController.ending_bad.play() 
	match direction:
		0:
			#print("Maze ruler approach angle: Top")
			self.position = GameState.target_player.position - Vector2(0,offset)
		1:
			#print("Maze ruler approach angle: Bottom")
			self.position = GameState.target_player.position + Vector2(0,offset)
		2:
			#print("Maze ruler approach angle: Left")
			self.position = GameState.target_player.position - Vector2(offset,0)
		3:
			#print("Maze ruler approach angle: Right")
			self.position = GameState.target_player.position + Vector2(offset,0)

func stun():
	if active:
		anim("stun")
		active = false
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun).timeout
		anim("active")
		hit_area.on_touch_effect = "Instakill"
		active = true

func stun_weak():
	if active:
		anim("stun")
		active = false
		hit_area.on_touch_effect = "None"
		await get_tree().create_timer(%EndlessConfig.guardian_hitstun/2).timeout
		anim("active")
		hit_area.on_touch_effect = "Instakill"
		active = true

func disable():
	if active:
		hit_area.on_touch_effect = "None"
		active = false
		BgmController.stopAll()
		self.position = Vector2(9999,9999)

func _physics_process(_delta: float) -> void:
	if active:
		if self.position.y < GameState.target_player.position.y: #if player is below us
			self.position.y += %EndlessConfig.guardian_spd*speed_mod #move down on Y axis
		else:
			if self.position.y >= GameState.target_player.position.y: #if player is above us
				self.position.y -= %EndlessConfig.guardian_spd*speed_mod #move up on Y axis
			
		if self.position.x < GameState.target_player.position.x: #if player is to the right
			self.position.x += %EndlessConfig.guardian_spd*speed_mod #move right
		else: 
			self.position.x -= %EndlessConfig.guardian_spd*speed_mod #if player is to the left, move left


func _on_hitbox_component_body_entered(_body: Node2D) -> void:
	if GameState.endless["boon_jupiter"] == 1:
		GameState.endless["boon_jupiter"] = 0
	anim("attack")
