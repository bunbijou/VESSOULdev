extends Area2D
@onready var animation_player = $AnimationPlayer
@export var myParticle : CPUParticles2D
@export var mySprite : AnimatedSprite2D
@export var myShadow : AnimatedSprite2D
@export var moteBigParticleAdd : bool = true
@export var moteBigParticle : CPUParticles2D

##Determines on-touch effect
@export_enum("Mote","BigMote","GazerMote") var type : String

##These only work for Sprite2D derived motes ATP
@export_enum("Default","Sprite2D","Sprite2D-Wavy","Sprite2D-Random","Static") var animation : String
var moteValue: int = 5

##On scene load
func _ready():
	match animation:
		"Default":
			if type != "BigMote": #small motes should be one size
				if myParticle:
					myParticle.visible = true
				mySprite.visible = false
				if myShadow:
					myShadow.visible = false
			else: ##Big Motes (Come in varying sizes determined by whether they are contained in a jar)
				##This just controls whether or not the small particle that accompanies big motes shows
				if moteBigParticle:
					if moteBigParticleAdd == true:
							moteBigParticle.emitting = true
					else: moteBigParticle.emitting = false
				mySprite.visible = true
				if myShadow:
					myShadow.visible = true
		"Static":
			if type != "BigMote": #small motes should be one size
				if myParticle:
					myParticle.visible = false
				mySprite.visible = false
				if myShadow:
					myShadow.visible = false
			else: #these guys come in various sizes
				##This just controls whether or not the small particle that accompanies big motes shows
				if moteBigParticleAdd == true:
						%MoteBigParticle.emitting = true
				else: %MoteBigParticle.emitting = false
				mySprite.visible = true
				mySprite.speed_scale = 0
				if myShadow:
					myShadow.visible = true
					myShadow.speed_scale = 0
		"Sprite2D": #if we want to move motes around (e.g. during Descent, we wanna use this kind)
			if myParticle:
				myParticle.visible = false
			mySprite.visible = true
			if myShadow:
				myShadow.visible = true
		"Sprite2D-Wavy": #optional modifier where the motes move in a wave
			if myParticle:
				myParticle.visible = false
			mySprite.visible = true
			mySprite.frame = int(self.position.y/13)
			if myShadow:
				myShadow.visible = true
				myShadow.frame = mySprite.frame
		"Sprite2D-Random": #optional modifier where the motes move randomly
			if myParticle:
				myParticle.visible = false
			mySprite.visible = true
			randomize()
			mySprite.frame = randi() % 13
			if myShadow:
				myShadow.visible = true
				myShadow.frame = mySprite.frame
			

##On player touch
func _on_body_entered(_body: Node2D) -> void:
	Sound.MoteCollect()
	animation_player.play("pickup") 
	match type:
		"Gazer":
			GameState.addSoul(5)
			GameState.healMe(1)
		"Mote":
			GameState.addSoul(1)
		"BigMote":
			GameState.addSoul(moteValue+(1*GameState.playerSatietyMod))
			GameState.healMe(1)
