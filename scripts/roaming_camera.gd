class_name ZoneCamera extends Node2D

##Enables freecam
@export var override : bool = false
## For by samael bossfight
@export var target_enemy : Node2D
@export var endless : bool = false 
var initial_zoom : Vector2
var battle_cam : bool = false
var shaking : bool = false
var shake_amplitude : float = 10

func _ready() -> void:
	GameState.rumble.connect(anim_rumble)
	%CanvasLayerGUI.visible = true
	%GlobalCamera.position_smoothing_enabled = false
	self.position = GameState.target_player.position
	initial_zoom = %GlobalCamera.zoom
	await get_tree().create_timer(.25).timeout
	%GlobalCamera.position_smoothing_enabled = true

##Should only be called by game_manager.gd
func anim_rumble(state : bool,amplitude):
	shaking = state
	shake_amplitude = amplitude

func _process(_delta: float) -> void:
	if !endless:
		camera_motion(GameState.target_player.current_zone)
	
		##Below is pretty much only used in the final battle with Samael, could have other uses
		if target_enemy:
			if target_enemy.combat_phase != "pre_battle":
				override = true
			else: override = false

		if override:
			camera_motion(999)
	if shaking:
		randomize()
		#%GlobalCamera.position_smoothing_enabled = false
		%GlobalCamera.position += Vector2(randf_range(-shake_amplitude,shake_amplitude),randf_range(-shake_amplitude,shake_amplitude))
		await get_tree().create_timer(.1).timeout
		%GlobalCamera.position = Vector2(0,0)
		await get_tree().create_timer(.1).timeout
	else:
		%GlobalCamera.position = Vector2(0,0)
		#%GlobalCamera.position_smoothing_enabled = true
func battle_cam_override():
	battle_cam = true

func camera_motion(zoneid):
	match zoneid: #whatever player area id is, do x thing
		-1000: #Statue activation cam
			self.position = GameState.target_player.temp_position
			%GlobalCamera.zoom = Vector2(4,4)
		-999: #Boss Death cam
			self.position = GameState.target_player.temp_position
			%GlobalCamera.zoom = Vector2(8,8)
		-2: #lenore
			self.position = Vector2(0,-26)
			%GlobalCamera.zoom = initial_zoom
		-1: #flash room, abyss
			self.position = Vector2(-164, 164)
			%GlobalCamera.zoom = initial_zoom
		0: # Abyss 
			self.position = Vector2(0,304)
			%GlobalCamera.zoom = initial_zoom
		1:
			self.position = Vector2(1, 160)
			%GlobalCamera.zoom = initial_zoom
		2:
			self.position = Vector2(160,160)
			%GlobalCamera.zoom = initial_zoom
		3:
			self.position = Vector2(160, 8)
			%GlobalCamera.zoom = initial_zoom
		4:  #Chasm of the Abyss
			self.position = Vector2(0,0)
			%GlobalCamera.zoom = initial_zoom
		-4:  #BOSS: Forsaken - Phase 3
			self.position = Vector2(0, 0)
			%GlobalCamera.zoom = initial_zoom
		5:
			self.position = Vector2(-165, 305)
			%GlobalCamera.zoom = initial_zoom
		6:
			self.position = Vector2(0,8)
			%GlobalCamera.zoom = initial_zoom
		7:
			self.position = Vector2(160,320)
			%GlobalCamera.zoom = initial_zoom
		8: #Woods - Abyssal Chasm Outlet
			self.position = Vector2(0,0) #don't modify
			%GlobalCamera.zoom = initial_zoom
		9: #Gate Exterior
			self.position = Vector2(-1,-140) #ditto
			%GlobalCamera.zoom = initial_zoom
		10: #CairnWood
			self.position = Vector2(-153,-4)
			%GlobalCamera.zoom = initial_zoom
		11: #Pumpkin Patch
			self.position = Vector2(-151,156)
			%GlobalCamera.zoom = initial_zoom
		12: #Ruin'd Fort
			self.position = Vector2(2,153)
			%GlobalCamera.zoom = initial_zoom
		13: #Frenzied Growth
			self.position = Vector2(154,155)
			%GlobalCamera.zoom = initial_zoom
		14: #Greattree Stump
			self.position = Vector2(-151,306)
			%GlobalCamera.zoom = initial_zoom
		15: #Storm Drain
			self.position = Vector2(153,-146)
			%GlobalCamera.zoom = initial_zoom
		16: # Gate Interior
			self.position = Vector2(0,-20)
			%GlobalCamera.zoom = initial_zoom
		17: #Gaping Jawer Arena
			self.position = Vector2(0,0) #do not change
			%GlobalCamera.zoom = initial_zoom
		-17: #Promenade
			self.position = Vector2(-151,-1)
			%GlobalCamera.zoom = initial_zoom
		18: #Town Square
			self.position = Vector2(143,-1)
			%GlobalCamera.zoom = initial_zoom
		-19: #Ebon Vessel:
			self.position = GameState.target_player.position + Vector2(0,-20)
			%GlobalCamera.zoom = initial_zoom
		-199: #Ebon Cinematic Cam 1:
			self.position = %EbonVessel.position
			%GlobalCamera.zoom = Vector2(6,6)
		-200: #Ebon Cinematic Cam 2:
			self.position = Vector2(0,73)
			%GlobalCamera.zoom = Vector2(4,4)
		-201: #Ebon Follow Cam
			self.position = (%EbonVessel.position+GameState.target_player.position)/2
			%GlobalCamera.zoom = Vector2(4,4)
		19: #Cathedral - Forsaken Arena
			self.position = target_enemy.position#+(Vector2(0,-50))
			%GlobalCamera.zoom = initial_zoom
		20: #Cemetary
			self.position = Vector2(-288,2)
			%GlobalCamera.zoom = initial_zoom
		21: #Cloyster
			self.position = Vector2(-150,-137)
			%GlobalCamera.zoom = initial_zoom
		22: #Sculptor's Garden
			self.position = Vector2(147,-141)
			%GlobalCamera.zoom = initial_zoom
		23: #Outskirts
			self.position = Vector2(287,-1)
			%GlobalCamera.zoom = initial_zoom
		24: #Clerestory
			self.position = Vector2(0,0)
			%GlobalCamera.zoom = initial_zoom
		888: #Free Camera
			self.position = GameState.target_player.position
			%GlobalCamera.zoom = initial_zoom
		999: #Free Camera
			self.position = GameState.target_player.position
			%GlobalCamera.zoom = initial_zoom
		998: #Final Boss - Active State
			self.position = Vector2(0,0)
			%GlobalCamera.zoom = Vector2(3,3)
		1000: #endless mode #1
			#self.position = Vector2(0,0)
			%GlobalCamera.zoom = initial_zoom
		1111: #demo room 2
			self.position = Vector2(1,2)
		1112: ##demo secret room
			self.position = Vector2(-131,2)
