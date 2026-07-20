extends Node
var AppID : String = "4363480"

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void:
	var isRunning = Steam.isSteamRunning()
	Steam.steamInit()
	
	if !isRunning:
		printerr("ERROR: Steam not running")
		return
	#else
	var id = Steam.getSteamID()
	var player_name : String = Steam.getFriendPersonaName(id)
	print("Steam is running with user "+player_name)

func achievement_get(achievement_name : String):
	###Ditto
	#print("Achievement "+achievement_name+" currently disabled (GodotSteam not active)")
	var status = Steam.getAchievement(achievement_name)
	if status["achieved"]:
		print("Achievement "+achievement_name+" already unlocked")
		return
	#else
	Steam.setAchievement(achievement_name)
	Steam.storeStats() ##triggers the toast
	print("Unlocked achievement: "+achievement_name)
