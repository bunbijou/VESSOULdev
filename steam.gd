extends Node
var AppID : String = "4363480"
var is_running : bool = false
#var queue : Array = []

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void:
	var isRunning = Steam.isSteamRunning()
	Steam.steamInit()
	if !isRunning:
		printerr("ERROR: Steam not running")
		is_running = false
	else:
		var id = Steam.getSteamID()
		var player_name : String = Steam.getFriendPersonaName(id)
		print("Steam is running with user "+player_name)
		is_running = true

#func queue_achievement(achievement_name : String):
	#queue.append(achievement_name)
#
###Run through Achievement queue
#func _process(_delta: float) -> void:
	#for i in queue:
		#achievement_get(queue[i])

func achievement_get(achievement_name : String):
	if is_running:
		var status = Steam.getAchievement(achievement_name)
		if status["achieved"]:
			print("Achievement "+achievement_name+" already unlocked")
			#return
		else:
			Steam.setAchievement(achievement_name)
			achievement_show_toast()
			print("Unlocked achievement: "+achievement_name)
			GameState.target_player.anim_achievment_success()
	else: print("ERROR: Achievement not unlocked (Reason: Steam not running)")

func achievement_reset(achievement_name : String):
	if is_running:
		Steam.clearAchievement(achievement_name)
	#Sound.respawn() ##placeholder

func achievement_show_toast():
	if is_running:
		Steam.storeStats() ##triggers the toast
