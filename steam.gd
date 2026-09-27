extends Node
var AppID : String = "4363480"
#var queue : Array = []

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void:
	var isRunning = Steam.isSteamRunning()
	Steam.steamInit()
	if !isRunning:
		printerr("ERROR: Steam not running")
		#return
	else:
		var id = Steam.getSteamID()
		var player_name : String = Steam.getFriendPersonaName(id)
		print("Steam is running with user "+player_name)

#func queue_achievement(achievement_name : String):
	#queue.append(achievement_name)
#
###Run through Achievement queue
#func _process(_delta: float) -> void:
	#for i in queue:
		#achievement_get(queue[i])

func achievement_get(achievement_name : String):
	#print("Achievement "+achievement_name+" currently disabled (GodotSteam not active)")
	var status = Steam.getAchievement(achievement_name)
	
	if status["achieved"]:
		print("Achievement "+achievement_name+" already unlocked")
		#return
	else:
		Steam.setAchievement(achievement_name)
		Steam.storeStats() ##triggers the toast
		print("Unlocked achievement: "+achievement_name)
		GameState.target_player.anim_achievment_success()

func achievement_reset(achievement_name : String):
	Steam.clearAchievement(achievement_name)
	#Sound.respawn() ##placeholder
