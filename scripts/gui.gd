extends Control
@onready var sidebar = %Sidebar #the container, can be moved left-right
@onready var moteCount = %MotesCount #lifetime souls
@onready var kindlingCount = %KindlingCount
@onready var bulbCount = %BloombulbCount
@onready var tomeCount = %TomeCount
@onready var playerHealth = %HPDisplay
@export var endless_sidebar : NinePatchRect
@export var endless_maze_level : Label
##A quick int calculated to determine how many times the player can flash at any given moment, can be buggy
var max_flash : int 
## See: pause function
var MenuOrExit = 0
var pause_menu : bool = false

func _ready() -> void:
	GameState.show_gui_save_menu.connect(show_save_menu)
	GameState.target_player.item_get.connect(show_sidebar)
	GameState.target_player.player_death.connect(show_death_message)
	GameState.target_player.humanity_gained.connect(show_humanity_message)
	%PauseMenu.visible = false
	%DeathMessage.visible = false
	%LabelPause.text = str(Localize.menu_paused)
	%ReturnToMenu.text = str(Localize.menu_return_to_menu)
	%QuitToDesktop.text = str(Localize.menu_quit_to_desktop)
	%BackToGame.text = str(Localize.menu_continue)
	%ConsentLabelHeader.text = str(Localize.menu_quit_consent)
	%ConsentLabelSubheader.text = str(Localize.menu_quit_consent_add)
	%ConsentYes.text = str(Localize.menu_confirm)
	%ConsentNo.text = str(Localize.menu_deny)
	%SaveSlot1Label.text = str(Localize.menu_save_1)
	%SaveSlot2Label.text = str(Localize.menu_save_2)
	%SaveSlot3Label.text = str(Localize.menu_save_3)
	%DeleteSaveConsentHeader.text = str(Localize.menu_delete_save_consent)
	%DeleteSaveConsentSubheader.text = str(Localize.menu_delete_save_consent_add)
	%DeleteSaveConsentYes.text = str(Localize.menu_deny)
	%DeleteSaveConsentNo.text = str(Localize.menu_deny)	

##Called by NPCs when they do their item conversion
func show_sidebar():
	if %SidebarAnim.current_animation == "active":
		%SidebarAnim.current_animation = "show"
		await get_tree().create_timer(.1).timeout
		%SidebarAnim.current_animation = "hide"
	else: %SidebarAnim.current_animation = "active"


func show_death_message(output : String):
	if %DeathAnimPlayer.current_animation != "death": #ideally this keeps it from playing twice
		Sound.bell() 
		%DeathBannerText.visible = true
		%HumanityBannerText.visible = false
		%DeathAnimPlayer.speed_scale = 5/GameState.target_player.respawn_time #5 being the length of the death banner anim, usually this will be 1
		%DeathBannerText.text = output
		%DeathAnimPlayer.play("death",-1,1,false)
		await get_tree().create_timer(.1).timeout
		%DeathMessage.visible = true
		%DeathMessage.text = str(Localize.death_description)+str(GameState.last_enemy)

func show_humanity_message(message):
	Sound.enemy_slain()
	%DeathBannerText.visible = false
	%HumanityBannerText.visible = true
	%DeathAnimPlayer.speed_scale = 1
	%HumanityBannerText.text = str(message)
	%DeathAnimPlayer.play("death",-1,1,false)



func _process(_delta: float) -> void:
	#Toggle GUI
	if Input.is_action_just_pressed("ui_hide"):
		if %GUI.visible:
			%GUI.visible = false
		else: %GUI.visible = true
	
	
	##Damage Add Indicato
	if GameState.playerDamageMod == 0:
		%DamageAdd.text = ""
	else: %DamageAdd.text = "+"+str(GameState.playerDamageAdd)
	
	## Sanctuary Bell Indicators
	if GameState.townDict["townSanctuaryBells"][0] == 0:
		%BellGoldIcon.visible = false
	else: %BellGoldIcon.visible = true

	if GameState.townDict["townSanctuaryBells"][1] == 0:
		%BellSilverIcon.visible = false
	else: %BellSilverIcon.visible = true
	
	## Humanity / Lenore's Favor Indicator (Also shows if player has Mr Bjorn in Endless Mode)
	if GameState.favor >= 1:
		%FavorIcon.visible = true
	else: %FavorIcon.visible = false
	
	##Conditional Hide Bloombulb Hud Elements
	if GameState.playerCapacity == 0:
		if GameState.playerBulbsHeld == 0:
			%Bloombulb.visible = false
		else: %Bloombulb.visible = true
	else: %Bloombulb.visible = true
	
	##Conditional Hide Kindling Hud Elements
	if GameState.playerIntensity == 0:
		if GameState.playerKindlingHeld == 0:
			%Kindling.visible = false
		else: %Kindling.visible = true
	else: %Kindling.visible = true

	##Conditional Hide Tome Hud Elements
	if GameState.playerEfficiency == 0:
		if GameState.playerTomesHeld == 0:
			%Tome.visible = false
		else: %Tome.visible = true
	else: %Tome.visible = true

	###Soul Meter
	if GameState.playerActiveSouls >= GameState.playerBoostMin:
		%SoulMeter.visible = true
		update_soul_meter(GameState.playerActiveSouls,GameState.playerFlashMin,GameState.abyssDict["abyssGlaze"],GameState.playerBoostMin,GameState.playerFlashMax)
	else: 
		if GameState.playerActiveSouls <= GameState.playerExhaustPoint:
			%SoulMeter.visible = false
	
	##Glyphic HP Bar
	#Note: we want this to be backwards because the Upsilon glyph is stylized upside-down
	if GameState.playerBaseHP == 1: #if player's base HP is only 1
		if GameState.playerHP != 0:
			playerHealth.text = "Ω"
		else: playerHealth.text = "˜"
	else: #if player's base HP is higher than 1
		if GameState.playerHP <= 0:
			@warning_ignore("narrowing_conversion")
			playerHealth.text = "˜ ".repeat(GameState.playerBaseHP)
		else:
			if GameState.playerBaseHP > 11:
				playerHealth.text = "Ω".repeat(GameState.playerHP)+"˜".repeat(GameState.playerBaseHP-GameState.playerHP)
			else:
				playerHealth.text = "˜ ".repeat(int(GameState.playerBaseHP-GameState.playerHP+0.1))+"Ω ".repeat(GameState.playerHP)
	
	##Mote Count
	moteCount.text = "• × " + str(int(GameState.playerLifetimeSouls))
	kindlingCount.text = "× " + str(GameState.playerKindlingHeld)
	bulbCount.text = "× " + str(GameState.playerBulbsHeld)
	tomeCount.text = "× " + str(GameState.playerTomesHeld)
	
	##Sidebar Stat Labels
	if GameState.playerIntensity < 11:
		if GameState.playerIntensity == 0:
			%IntensityBar.visible = false
		else:
			%IntensityBar.visible = true
			%IntensityBar.value = GameState.playerIntensity
	else: #once player's stats get past the base game max values, switch back to the label view
		%IntensityBar.visible = false
		%IntensityLabel.visible = true
		%IntensityLabel.text =  str(Localize.stat_intensity)+": "+str(GameState.playerIntensity)
	
	if GameState.playerCapacity < 6:
		if GameState.playerCapacity == 0: #if un-upgraded
			%CapacityBar.visible = false
		else: 
			%CapacityBar.visible = true
			%CapacityBar.value = GameState.playerCapacity+1 #for starting hp
	else: #once player's stats get past the base game max values, switch back to the label view
		%CapacityBar.visible = false
		%CapacityLabel.visible = true
		%CapacityLabel.text = str(Localize.stat_capacity)+": "+str(GameState.playerCapacity)
	
	if GameState.playerEfficiency < 4:
		if GameState.playerEfficiency == 0:
			%EfficiencyBar.visible = false
		else:
			%EfficiencyBar.visible = true
			%EfficiencyBar.value = GameState.playerEfficiency
	else: #once player's stats get past the base game max values, switch back to the label view
		%EfficiencyBar.visible = false
		%EfficiencyLabel.visible = true
		%EfficiencyLabel.text =  str(Localize.stat_efficiency)+": "+str(GameState.playerEfficiency)
	
	if GameState.abyssDict["abyssGlaze"] >= 1:
		##this value should be a number between 1 and 100
		if (GameState.playerActiveSouls-GameState.playerFlashMin) == 0:
			%ProgressBar.value = 0
		else:
			%ProgressBar.value = 2*(int(GameState.playerActiveSouls)%int(GameState.playerFlashMin))
		%ItemIconGlaze.visible = true
		%ProgressBar.visible = true
	else: 
		%ItemIconGlaze.visible = false
		%ProgressBar.visible = false
	if GameState.abyssDict["abyssLid"] > 0:
		%ItemIconLid.visible =  true
	else: %ItemIconLid.visible = false
	
	## In-Game Pause Menu
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused: #if pausing
		pause()
	
	if Input.is_action_just_pressed("ui_cancel") and pause_menu:
		_unpause()

func pause():
	if !GameState.target_player.dead:
		Sound.menu("accept")
		get_tree().paused = true
		%PauseMenu.visible = true
		%SidebarAnim.current_animation = "show"
		await get_tree().create_timer(.25).timeout
		pause_menu = true
		%BackToGame.grab_focus()

func _unpause():
		Sound.menu("cancel")
		pause_menu = false
		%SidebarAnim.current_animation = "RESET"
		%PauseMenu.visible = false 
		%HPDisplay.visible = true
		get_tree().paused = false
		if GameState.target_player.empowered:
			GameState.target_player.hunger_restart()
		GameState.signal_unpause()


func hide_all():
	%Sidebar.visible = false
	%PauseMenu.visible = false
	%ConsentMenu.visible = false
	%SoulMeter.visible = false
	%HPDisplay.visible = false
	%SaveSelect.visible = false

func hide_save_select():
	%SaveSelect.visible = false
	%Sidebar.visible = true

func update_soul_meter(current_souls,flash_min,has_glaze,empowered_min,flash_capacity):
	## If player has the glaze, show the meter
	if has_glaze >= 1:
		## If player is in the empowered state, show meter and other info
		if current_souls > empowered_min:
			max_flash = int(current_souls/flash_min)
			
			## Restrict maximum flashes by the flash_capacity stat
			if max_flash > flash_capacity:
				max_flash = flash_capacity
			
			if max_flash < 11: #expanded form
				%SoulMeter.text = "☼ ".repeat(max_flash)#+"☼"
			if max_flash >= 11: #condensed form
				%SoulMeter.text = "☼".repeat(max_flash)
		else: ## If player isn't in the empowered state, hide the soul meter
			%SoulMeter.visible = false
	else: ## If player doesn't have glaze, show the soul meter
			%SoulMeter.visible = false

##Called by Gamestate/Remote save / Save Point objects
#NOTE: to-do switch .tres to .res for final build / steam release 
func show_save_menu():
	var data1 = ResourceLoader.load("user://save_data_1.res") as SceneData #load saved data
	var data2 = ResourceLoader.load("user://save_data_2.res") as SceneData #load saved data
	var data3 = ResourceLoader.load("user://save_data_3.res") as SceneData #load saved data
	get_tree().paused = true
	hide_all()
	%SaveSelect.visible = true
	match GameState.saveslot:
		0:
			%SaveSelectReturn.grab_focus()
		1:
			%Save1.grab_focus()
		2:
			%Save2.grab_focus()
		3:
			%Save3.grab_focus()
	%Save1.grab_focus()
	if data1: #if data exists
		var glaze_icon : String
		var samael_icon : String
		var favor_icon : String
		var value : int = 0 #for calcualtion
		var title : String #shown to players
		var completion : int #ditto
		var ngplus : String
		
		if data1.abyssData["abyssGlaze"] != 0:
			glaze_icon = "☼"
			value += 1
		else: glaze_icon = ""
		
		if data1.townData["townEndingChoice"][1] == 2 or data1.townData["townEndingChoice"][2] == 2:
			samael_icon = " φ"
		else: samael_icon = ""
		
		if data1.favor == 1:
			favor_icon = " ♥"
		else: favor_icon = ""
		
		if data1.abyssData["abyssLid"] > 0:
			value += 1

		value += data1.playercapacity+data1.playerefficiency+data1.playerintensity

		if value >= 19:
			title = Localize.noun_rank_20
		else:
			match value:
				0: title = Localize.noun_rank
				1: title = Localize.noun_rank_2 
				2: title = Localize.noun_rank_3
				3: title = Localize.noun_rank_4
				4: title = Localize.noun_rank_5
				5: title = Localize.noun_rank_6
				6: title = Localize.noun_rank_7
				7: title = Localize.noun_rank_8
				8: title = Localize.noun_rank_9
				9: title = Localize.noun_rank_10
				10: title = Localize.noun_rank_11 
				11: title = Localize.noun_rank_12
				12: title = Localize.noun_rank_13
				13: title = Localize.noun_rank_14
				14: title = Localize.noun_rank_15
				15: title = Localize.noun_rank_16
				16: title = Localize.noun_rank_17
				17: title = Localize.noun_rank_18
				18: title = Localize.noun_rank_19
		completion = value*5
		
		if data1.newgame != 0: #if player is in NG+
			ngplus = "- NG+"+str(data1.newgame)
		
		%Save1.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
		 "+"Ω ".repeat(int(data1.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
		 "+str(Localize.menu_player_location)+" "+str(data1.activescn).capitalize()+"
		 • × "+str(int(data1.playersouls))+" "+str(ngplus)
	else: %Save1.text =str(Localize.menu_no_data)

	if data2: #if data exists
		var glaze_icon : String
		var samael_icon : String
		var favor_icon : String
		var value : int = 0 #for calcualtion
		var title : String #shown to players
		var completion : int #ditto
		var ngplus : String
		
		if data2.abyssData["abyssGlaze"] != 0:
			glaze_icon = "☼"
			value += 1
		else: glaze_icon = ""
		
		if data2.townData["townEndingChoice"][1] == 2 or data2.townData["townEndingChoice"][2] == 2:
			samael_icon = " φ"
		else: samael_icon = ""
		
		if data2.favor == 1:
			favor_icon = " ♥"
		else: favor_icon = ""
		
		if data2.abyssData["abyssLid"] > 0:
			value += 1

		value += data2.playercapacity+data2.playerefficiency+data2.playerintensity

		if value >= 19:
			title = Localize.noun_rank_20
		else:
			match value:
				0: title = Localize.noun_rank
				1: title = Localize.noun_rank_2 
				2: title = Localize.noun_rank_3
				3: title = Localize.noun_rank_4
				4: title = Localize.noun_rank_5
				5: title = Localize.noun_rank_6
				6: title = Localize.noun_rank_7
				7: title = Localize.noun_rank_8
				8: title = Localize.noun_rank_9
				9: title = Localize.noun_rank_10
				10: title = Localize.noun_rank_11 
				11: title = Localize.noun_rank_12
				12: title = Localize.noun_rank_13
				13: title = Localize.noun_rank_14
				14: title = Localize.noun_rank_15
				15: title = Localize.noun_rank_16
				16: title = Localize.noun_rank_17
				17: title = Localize.noun_rank_18
				18: title = Localize.noun_rank_19
		completion = value*5
		
		if data2.newgame != 0: #if player is in NG+
			ngplus = "- NG+"+str(data2.newgame)
		
		%Save2.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
		 "+"Ω ".repeat(int(data2.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
		 "+str(Localize.menu_player_location)+" "+str(data2.activescn).capitalize()+"
		 • × "+str(int(data2.playersouls))+" "+str(ngplus)
	else: %Save2.text = str(Localize.menu_no_data)

	if data3: #if data exists
		var glaze_icon : String
		var samael_icon : String
		var favor_icon : String
		var value : int = 0 #for calcualtion
		var title : String #shown to players
		var completion : int #ditto
		var ngplus : String
		
		if data3.abyssData["abyssGlaze"] != 0:
			glaze_icon = "☼"
			value += 1
		else: glaze_icon = ""
		
		if data3.townData["townEndingChoice"][1] == 2 or data3.townData["townEndingChoice"][2] == 2:
			samael_icon = " φ"
		else: samael_icon = ""
		
		if data3.favor == 1:
			favor_icon = " ♥"
		else: favor_icon = ""
		
		if data3.abyssData["abyssLid"] > 0:
			value += 1

		value += data3.playercapacity+data3.playerefficiency+data3.playerintensity

		if value >= 19:
			title = Localize.noun_rank_20
		else:
			match value:
				0: title = Localize.noun_rank
				1: title = Localize.noun_rank_2 
				2: title = Localize.noun_rank_3
				3: title = Localize.noun_rank_4
				4: title = Localize.noun_rank_5
				5: title = Localize.noun_rank_6
				6: title = Localize.noun_rank_7
				7: title = Localize.noun_rank_8
				8: title = Localize.noun_rank_9
				9: title = Localize.noun_rank_10
				10: title = Localize.noun_rank_11 
				11: title = Localize.noun_rank_12
				12: title = Localize.noun_rank_13
				13: title = Localize.noun_rank_14
				14: title = Localize.noun_rank_15
				15: title = Localize.noun_rank_16
				16: title = Localize.noun_rank_17
				17: title = Localize.noun_rank_18
				18: title = Localize.noun_rank_19
		completion = value*5
		
		if data3.newgame != 0: #if player is in NG+
			ngplus = "- NG+"+str(data3.newgame)
		
		%Save3.text = " "+Localize.player_rank+": "+title+" - "+str(completion)+"%
		 "+"Ω ".repeat(int(data3.playercapacity) + 1)+str(glaze_icon)+str(samael_icon)+str(favor_icon)+"
		 "+str(Localize.menu_player_location)+" "+str(data3.activescn).capitalize()+"
		 • × "+str(int(data3.playersouls))+" "+str(ngplus)
	else: %Save3.text = str(Localize.menu_no_data)


func _on_returnto_menu_pressed() -> void:
	%PauseMenu.visible = false
	%ConsentMenu.visible = true
	MenuOrExit = 0
	Sound.menu("accept")
	%ConsentNo.grab_focus()

func _on_quit_to_desktop_pressed() -> void:
	%PauseMenu.visible = false
	%ConsentMenu.visible = true
	MenuOrExit = 1
	Sound.menu("accept")
	%ConsentNo.grab_focus()

func _on_consent_yes_pressed() -> void:
	match MenuOrExit:
		0:
			Sound.menu("accept")
			await get_tree().create_timer(.5).timeout
			GameState.reset_game_values()
			get_tree().change_scene_to_file("res://mainMenu.tscn") # change scene
		1:
			Sound.menu("accept")
			await get_tree().create_timer(1).timeout
			get_tree().quit()

func _on_consent_no_pressed() -> void:
	Sound.menu("cancel")
	%ConsentMenu.visible = false
	%PauseMenu.visible = true
	%BackToGame.grab_focus()

func _on_unpause_pressed() -> void:
	Sound.menu("cancel")
	_unpause()

func _on_save_1_pressed() -> void:
	save_game(1)

func _on_save_2_pressed() -> void:
	save_game(2)

func _on_save_3_pressed() -> void:
	save_game(3)

func save_game(saveslot):
	BgmController.success_jingle.play()
	GameState.fullHeal() #experimental
	await get_tree().create_timer(.01).timeout
	GameState.saveslot = saveslot
	GameState._save(GameState.target_player.position, get_tree().get_current_scene().get_name())
	await get_tree().create_timer(.33).timeout
	get_tree().reload_current_scene() #experimental
	hide_save_select()
	_unpause()

func _on_save_select_return_pressed() -> void:
	Sound.menu("cancel")
	hide_save_select()
	_unpause()
