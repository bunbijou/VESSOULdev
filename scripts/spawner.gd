extends Node2D
@export_enum("Quick Flash","Mote","Big Mote","Kindling Chest","Vesselbloom","Tome","Breakable Pot","Heavy Breakable Pot") var selection : String = "Quick Flash"
var quickflash = preload("res://scenes/endless_quick_flash.tscn")
var mote = preload("res://scenes/mote.tscn")
var bigmote = preload("res://scenes/moteBig.tscn")
var item = preload("res://scenes/story_collectable_item.tscn")
var potbreakable = preload("res://scenes/decor/jar_breakable.tscn")
var potbreakableheavy = preload("res://scenes/decor/vessel_breakable_large.tscn")
var player_contact : bool = false

func _ready() -> void:
	randomize()
	%Label.text = selection
	instance_create(0)

func instance_create(delay):
	await get_tree().create_timer(delay).timeout
	Sound.PlayerHeal()
	match selection:
		"Quick Flash":
			spawn(quickflash,null,null,null,null)
		"Mote":
			spawn(mote,null,null,null,null)
		"Big Mote":
			spawn(bigmote,null,null,null,null)
		"Kindling Chest":
			spawn(item,GameState.target_player.current_zone,0,null, false)
		"Vesselbloom":
			spawn(item,GameState.target_player.current_zone,1,null, false)
		"Tome":
			spawn(item,GameState.target_player.current_zone,2,randi_range(0,2),false)
		"Breakable Pot":
			spawn(potbreakable,null,null,null,null)
		"Heavy Breakable Pot":
			spawn(potbreakableheavy,null,null,null,null)

func spawn(type, property1, property2, property3,property4):
	var my_instance = type.instantiate()
	add_child(my_instance)
	if property1 != null: ##Current Zone (if applicable)
		my_instance.current_zone = property1
	if property2 != null: ##Item Type (itemchest.tscn)
		my_instance.item_type = property2
	if property3 != null: ##Item Subtype (itemchest.tscn)
		my_instance.item_subtype = property3
	if property4 != null: ##Locked / Unlocked
		my_instance.locked = false
func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if body == PlayerVessel:
		Sound.textPopup()
		player_contact = true
		instance_create(3)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	#if body == PlayerVessel:
		player_contact = false
