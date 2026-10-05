class_name SceneData extends Resource

@export var activescn = "abyss"
@export var playerxy = Vector2(0,0)
@export var playersouls : float = 0
@export var playersoulsl : float = 0
@export var playerkills : int = 0
@export var playerbulbs : int = 0
@export var playertomes : int = 0
@export var playerkindling : int = 0
@export var playercapacity : int = 0
@export var playerefficiency : int = 0
@export var playerintensity : int = 0
@export var mote_residue : bool = false
@export var mote_residue_value : int = 0
@export var mote_residue_position : Vector2 = Vector2(9999,9999)
@export var mote_residue_scene : String = "abyss"
@export var EasyMode : bool = false
@export var favor : int = -1
@export var completion : bool = false
@export var newgame : int = 0
@export var player_church_town_entered : bool = false
@export var player_gods_wood_entered : bool = false
@export var language : String = "English"

@export var npcState = {
	"sculptor": [0],
	"jari": [0],
	"zn": [0]
}

@export var abyssData = {
"abyssBlooms": [0,0],
"abyssMiniBoss": [0], #amphora
"abyssTome": [0],
"abyssBonusR": [0,0,0],
"abyssKindling": [0,0,0],
"abyssLid": [0],
"abyssGlaze": [0],
"abyssBoss": [0,1] #abyss presence, lenore
}

@export var woodsData = {
"woodsBlooms": [0],
"woodsMiniBoss": [0,0], #Stump, Gaping Jawer
"woodsTome": [0], #from Gaping Jawer
"woodsBonusR": [0,0], #14, 15
"woodsKindling": [0,0],
"woodsBoss": [0], #Frenzied Growth
"woodsKey": [0] #Church Town Key 
}

@export var townData = {
"townBlooms": [0,0], #16/17
"townMiniBoss": [0], #Censer / 24
"townTome": [0], #from Censer / 24
"townBonusR": [0,0,0,0], #B1/19, B2/20, B3/21, B4/22
"townKindling": [0,0,0,0,0], #19,20,21,22,23
"townSanctuaryBells": [0,0], #gold and silver bell, respectively
"townEndingChoice": [0,0,0], #accept, refuse, secret 3rd thing
"townBoss": [0]
}
