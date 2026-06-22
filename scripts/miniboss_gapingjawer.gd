class_name BossGapingJawer extends Node2D

signal death_rattle

@export var current_zone : int = 999
@export var targetPreBattle : JawerPrison
@export var battleReward : Node2D
var health : int = 4 #default: 4
var spd : float = 0.05
var active : bool = false
var isVulnerable: bool = false
var stunned : bool = false
var isInvis : bool = true
var dead : bool = false
var initial_speed : float = 0


func _ready() -> void:
	if GameState.EasyMode:
		health = 3
	if GameState.woodsDict["woodsMiniBoss"][1] == 1:
		queue_free()
	if battleReward:
		battleReward.visible = false
	GameState.target_player.flashed.connect(_isDamaged)
	if !targetPreBattle:
		_start()
	else: 
		targetPreBattle.battleStart.connect(_start)
		%JawerAnim.current_animation = "hidden"

func _process(_delta: float) -> void:
	if health < 1 and !dead: #if my hp is below zero, kill me
			_death()
	else:
		if GameState.target_player.dead:
			_laugh()
			await get_tree().create_timer(3).timeout

func _physics_process(_delta: float) -> void:
	if GameState.target_player.current_zone == current_zone and active and !stunned and !dead:
			if self.position.y < GameState.target_player.position.y: #if player is below us
				self.position.y += spd #move down on Y axis
			else:
				if self.position.y >= GameState.target_player.position.y: #if player is above us
					self.position.y -= spd #move up on Y axis
			if self.position.x < GameState.target_player.position.x: #if player is to the right
				self.position.x += spd #move right
			else: 
				self.position.x -= spd #if player is to the left, move left

func _on_jawer_area_2d_body_entered(_body: PlayerVessel) -> void:
	if !dead:
		if !isInvis:
			Sound.PlayerDamaged()
			GameState.target_player.isHurt(1+GameState.newgame)
		else: _bite()

func _start():
	if !active:
		isInvis = false 
		active = true
		%JawerAnim.current_animation = "RESET"
		await get_tree().create_timer(1.5).timeout
		_fadeout()

func _fadeout():
	if active and !dead:
		Sound.jawer("disappear")
		isVulnerable = false
		print ("Jawer _fadeout")
		active = false
		%JawerAnim.current_animation = "disappear"#####################
		await get_tree().create_timer(.35).timeout
		isInvis = true
		active = true

func _bite():
	if active and !dead:
		initial_speed = spd
		spd = (spd)*12
		Sound.mimic("bite") #placeholder
		%JawerAnim.current_animation = "bite"
		await get_tree().create_timer(.35).timeout
		spd = initial_speed
		GameState.target_player.isHurt(1+GameState.newgame)
		_fadein()

func _laugh():
	if active and !dead:
		isInvis = false
		Sound.jawer("laugh")
		active = false
		%JawerAnim.current_animation = "RESET"
		isVulnerable = true
		await get_tree().create_timer(1).timeout
		_fadeout()

func _fadein():
	if active and !dead:
		Sound.jawer("reappear")
		%JawerAnim.current_animation = "reappear" 
		await get_tree().create_timer(1).timeout
		_laugh()

func _isDamaged():
	if !stunned and !isInvis and !dead:
		if GameState.target_player.current_zone == current_zone:
			Sound.jawer("stun")
			active = false
			health -= 1+(1*GameState.playerDamageMod)
			stunned = true
			%JawerAnim.play("stun")
			await get_tree().create_timer(.35).timeout
			if !dead:
				%JawerAnim.play("RESET")
				stunned = false
				active = true
				await get_tree().create_timer(.35).timeout
				_fadeout()

func _death():
	var fade_time : float = 5
	if !dead:
		##Achievement: Ring Gold Bell
		SteamHandler.achievement_get("a_gaping_jawer_defeat")
		dead = true
		active = false
		%JawerAnim.play("defeat",1)
		%AnimSpriteBody.play("stun")
		%AnimSpriteMouth.play("stun")
		%MoteExplosion.emitting = true
		self.position = Vector2(0,0)
		GameState.target_player.current_zone = -999
		GameState.target_player.temp_position = Vector2(0,0)
		BgmController.stopAll()
		Sound.jawer("death")
		await get_tree().create_timer(fade_time/2).timeout #wait so anim and sound can play
		Sound.explosion()
		%DarknessExplosion.emitting = true
		await get_tree().create_timer(fade_time/2).timeout #wait so anim and sound can play
		%AnimSpriteBody.visible = false
		%AnimSpriteMouth.visible = false
		%DarknessExplosion.emitting = false
		%MoteExplosion.emitting = false
		GameState.mote_reward(GameState.reward_jawer,0,"big")
		#Re-focus camera on player
		GameState.target_player.current_zone = 17
		GameState.target_player.anim_enemy_slain()
		GameState.addKillCount()
		if battleReward:
			battleReward.visible = true
		GameState.woodsDict["woodsMiniBoss"][1] = 1
		#print("Gaping Jawer defeated")
		death_rattle.emit()
		await get_tree().create_timer(3).timeout
		queue_free()
