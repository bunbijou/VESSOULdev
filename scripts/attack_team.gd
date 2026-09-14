extends Node2D

func _ready() -> void:
	%GlazeChest.item_get.connect(activate)

func activate():
	BgmController.abyss_main.stop()
	BgmController.track_ambush.play()
	self.visible = true
	%PotheadA.current_zone = 1111
	%PotheadA.retarget()
	%PotheadB.current_zone = 1111
	%PotheadB.retarget()
	%PotheadC.current_zone = 1111
	%PotheadC.retarget()
	%PotheadD.current_zone = 1111
	%PotheadD.retarget()
