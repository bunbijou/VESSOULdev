extends CanvasLayer

signal dialogue_start
signal dialogue_end

@export var anim : AnimationPlayer
var textSpeed = 1
var isReading = false
var isComplete = false
var isMurmuring = false
var quick : bool = false
var quick_time : int = 1
var speed_modifier : int = 3 #when text is moving a lil slow
var murmur_audio : String = "default"

func save_indicate():
	%Save.visible = true
	await get_tree().create_timer(3).timeout
	%Save.visible = false

func _ready() -> void:
	%Save.visible = false
	%DialogueControl.visible = false
	%DialogueBoxText.visible = false

func openDialogue(speech:String,portrait:String,speed:float,fast:bool):
	var quick_speed : float = 6
	if GameState.decisionActive == false:
		dialogue_start.emit()
		GameState.target_player.hunger_change_state("stop")
		if !fast:
			quick = false
			get_tree().paused = true
		else: quick = true
		isComplete = false
		if !fast:
			%DialogueControl.visible = true
		%DialogueBoxText.visible = true
		%DialogueBoxText.text = str(speech)
		%DialogueBoxText.visible_ratio = 0
		if !quick:
			textSpeed = speed+speed_modifier
		else: textSpeed = quick_speed
		%Portrait.visible = true
		%PortraitFrame.visible = true
		match portrait:
			"none": 
				%Portrait.visible = false
				%PortraitFrame.visible = false
				#murmur_audio = "default"
				murmur_audio = "zenith"
			"sculptor":  
				%Portrait.animation = "sculptor"
				murmur_audio = "sculptor"
			"sculptor_unmask":
				%Portrait.animation = "sculptor_unmask"
				murmur_audio = "sculptor"
			"sculptor_unmask_reject":
				%Portrait.animation = "sculptor_unmask_reject"
				murmur_audio = "sculptor"
			"jari":  
				%Portrait.animation = "jari"
				murmur_audio = "jari"
			"jari_sad":
				%Portrait.animation = "jari_sad"
				murmur_audio = "jari"
			"zenith":  
				%Portrait.animation = "zenith"
				murmur_audio = "zenith"
			"zenith_contemplative":
				%Portrait.animation = "zenith_contemplative"
				murmur_audio = "zenith"
			"nadir":  
				%Portrait.animation = "nadir"
				murmur_audio = "nadir"
			"nadir_contemplative":
				%Portrait.animation = "nadir_contemplative"
				murmur_audio = "nadir"
			"jove": 
				%Portrait.animation = "joviel"
				murmur_audio = "joviel"
			"jove_surprise":
				%Portrait.animation = "joviel_surprise"
				murmur_audio = "joviel"
			"samael": 
				%Portrait.animation = "samael"
				murmur_audio = "sculptor"
			"samael_fear": 
				%Portrait.animation = "samael_fear"
				murmur_audio = "sculptor"
			"samael_anger": 
				%Portrait.animation = "samael_anger"
				murmur_audio = "sculptor"
			"samael_triumph":
				%Portrait.animation = "samael_triumph"
				murmur_audio = "sculptor"
			"samael_djinn":
				%Portrait.animation = "samael_djinn"
				murmur_audio = "djinn"
			"lenore":
				%Portrait.animation = "lenore"
				murmur_audio = "lenore"
			"lenore_happy":
				%Portrait.animation = "lenore_happy"
				murmur_audio = "lenore"
			"lenore_sad":
				%Portrait.animation = "lenore_sad"
				murmur_audio = "lenore"
			"player":
				%Portrait.animation = "player"
				murmur_audio = "default"
			"friendly_mote":
				%Portrait.animation = "friendly_mote"
				murmur_audio = "mote"
			"tip":
				%Portrait.animation = "tip"
				murmur_audio = "default"
			"journal":
				%Portrait.animation = "journal"
				murmur_audio = "default"
			"samael_sprite":
				%Portrait.animation = "samael_sprite"
				murmur_audio = "samael_sprite"
			"impostor":
				%Portrait.play("impostor")
				murmur_audio = "default"
			"lailun":
				%Portrait.play("lailun")
				murmur_audio = "lailun"
			"barrelby":
				%Portrait.play("barrelby")
				murmur_audio = "barrelby" #placeholder
			"barrelby_laugh":
				%Portrait.play("barrelby_laugh")
				murmur_audio = "barrelby" #ditto
			"barrelby_serious":
				%Portrait.play("barrelby_serious")
				murmur_audio = "barrelby" #ditto
			"portia":
				%Portrait.play("portia")
				murmur_audio = "mote"
			"portia_happy":
				%Portrait.play("portia_happy")
				murmur_audio = "mote"
			"portia_sad":
				%Portrait.play("portia_sad")
				murmur_audio = "mote"
			"portia_wink":
				%Portrait.play("portia_wink")
				murmur_audio = "mote"
			"anon1": 
				%Portrait.visible = false
				%PortraitFrame.visible = false
				murmur_audio = "joviel"
			"anon2":
				%Portrait.visible = false
				%PortraitFrame.visible = false
				murmur_audio = "lailun"
		readOut()
	else: print("Dialogue box deferred (Reason: Decision prompt active)")

func closeDialogue(): #keeps portraits from stacking on eachother between dialogues
	dialogue_end.emit()
	isReading = false
	%DialogueControl.visible = false
	%DialogueBoxText.visible = false
	%Portrait.visible = false
	%PortraitFrame.visible = false
	GameState.target_player.hunger_change_state("start")

func readOut():
	isReading = true

func _process(_delta: float) -> void:
	if isReading:
		if %DialogueBoxText.visible_ratio != 100: #if not all text is not visible
				%DialogueBoxText.visible_ratio += 0.001*textSpeed #continue to show text
				if !isMurmuring:
					_murmur()
		
		##Reading dialogue message
		if !quick: #Regular textboxes
			if %DialogueBoxText.visible_ratio == 1: #if finished showing text/nearly finished
				%ContArrow.visible = true
				isComplete = true
			else: %ContArrow.visible = false
		else: #Quick textboxses
			if %DialogueBoxText.visible_ratio == 1:
				await get_tree().create_timer(quick_time).timeout
				isComplete = true
				closeDialogue()
		
		##Finishing Dialogue MEssage
		if !quick: #Regular textboxes
			if isComplete: #if dialogue is complete and player hits enter
					if Input.is_action_just_pressed("ui_accept"):
						get_tree().paused = false
						closeDialogue()
			else: #if dialogue is not complete and player hits enter
				if Input.is_action_just_pressed("ui_accept"): #if player hits enter
					if %DialogueBoxText.visible_ratio <= 1:
							%DialogueBoxText.visible_ratio = 100 #show rest of text

#wanna make this scale with the message speed but it doesn't like when i change the timer value
func _murmur():
	if %DialogueBoxText.visible_ratio != 1:
		isMurmuring = true
		#Sound.murmur(murmur_audio)
		match murmur_audio:
			"default":
				Sound.murmur("default")
			"sculptor":
				Sound.murmur("sculptor")
			"jari":
				Sound.murmur("jari")
			"zenith":
				Sound.murmur("zenith")
			"nadir":
				Sound.murmur("nadir")
			"joviel":
				Sound.murmur("joviel")
			"djinn":
				Sound.murmur("djinn")
			"lenore":
				Sound.murmur("lenore")
			"mote":
				Sound.murmur("mote")
			"samael_sprite":
				Sound.murmur("samael_sprite")
			"lailun":
				Sound.murmur("lailun")
			"barrelby":
				Sound.murmur("barrelby")
		await get_tree().create_timer(.05).timeout
		isMurmuring = false

##called by the decision box global object
func remote_end_dialogue():
	dialogue_end.emit()
