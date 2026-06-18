extends Node2D
var count : int = 1

func _ready() -> void:
	Dialogue.dialogue_end.connect(iterate)

func iterate():
	if count == 11:
		count = 1 ##loop
	else: count += 1

func _process(_delta: float) -> void:
	match count:
		1: Localize.reference_dialogue("moteTest")
		2: Localize.reference_dialogue("sculptorTest")
		3: Localize.reference_dialogue("jariTest")
		4: Localize.reference_dialogue("zenithTest")
		5: Localize.reference_dialogue("nadirTest")
		6: Localize.reference_dialogue("jovielTest")
		7: Localize.reference_dialogue("djinnTest")
		8: Localize.reference_dialogue("lenoreTest")
		9: Localize.reference_dialogue("samaelspriteTest")
		10: Localize.reference_dialogue("lailunTest")
		11: Localize.reference_dialogue("barrelbyTest")
		11: Localize.reference_dialogue("portiaTest")
