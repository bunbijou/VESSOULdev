##Global - SOUND
extends Node


func begin_playing(input: Array[AudioStreamPlayer]): #
	## Random sound variants
	var variant_count : int = len(input)
	var sound_selection : AudioStreamPlayer
	if variant_count >= 2:
		randomize()
		sound_selection = input.pick_random()
	else: sound_selection = input[0]
	if !sound_selection.playing:
		sound_selection.play()

func play_with_random(input: Array[AudioStreamPlayer],pitch_mod_range : Array):
	# Temporarily disabled as of 5/12
	var variant_count : int = len(input)
	var sound_selection : AudioStreamPlayer
	var sound_initial_pitch : float = 0
	if variant_count >= 2:
		randomize()
		sound_selection = input.pick_random()
	else: sound_selection = input[0]
	if !sound_selection.playing:
		randomize()
		sound_initial_pitch = sound_selection.pitch_scale
		sound_selection.pitch_scale = sound_initial_pitch+randf_range(pitch_mod_range[0],pitch_mod_range[1])
		sound_selection.play()
		await get_tree().create_timer(.25).timeout
		sound_selection.pitch_scale = sound_initial_pitch

func LoopingSoundCleanup():
	pass
	#if %PotheadSnore.playing:
		#Sound.pothead("snore_stop")
	#if %OssuarySnoreLoop.playing:
		#Sound.ossuary("snore_stop")
	#if %OssuaryChaseLoop.playing:
		#Sound.ossuary("chase_stop")
	#if %FireCrackleLoop.playing:
		#Sound.fire_crackle_loop("stop")
	#print("Cleaned up looping sounds from gameplay")

func menu(sound : String):
	match sound:
		"accept":
			begin_playing([%MenuAccept])
		"cancel":
			begin_playing([%MenuCancel])
		"move":
			begin_playing([%MenuMove])

func itemGet(type : String):
	match type:
		"bulb":
			begin_playing([%BloomBulbGet,%BloomBulbGet2])
		"tome":
			begin_playing([%TomeGet])
		"kindling":
			begin_playing([%KindlingGet, %KindlingGet2, %KindlingGet3, %KindlingGet4, %KindlingGet5, %KindlingGet6, %KindlingGet7, %KindlingGet8])

func textPopup():
	begin_playing([%Dialogue])

func murmur(sound : String):
	match sound:
		"default": begin_playing([%Dialogue]) ##see above
		"mote": play_with_random([%FriendlyMoteMurmur],[-0.2,0.2])
		"sculptor": play_with_random([%SculptorMurmur],[-0.3,0.3])
		"jari": play_with_random([%JariMurmur],[-0.2,0.2])
		"zenith": play_with_random([%ZenithMurmur],[-0.4,0.2])
		"nadir": play_with_random([%NadirMurmur],[-0.3,0.3])
		"joviel": play_with_random([%JovielMurmur],[-0.3,0.3])
		"djinn": play_with_random([%DjinnMurmur],[-0.3,0.3])
		"lenore": play_with_random([%LenoreMurmur],[-0.2,0.2])
		"samael_sprite": play_with_random([%SamaelSpriteMurmur],[-0.2,0.2])
		"lailun": play_with_random([%LailunMurmur],[-0.2,0.2])
		"barrelby": play_with_random([%BarrelbyMurmur],[-0.3,0.3])

func painGeneric(): begin_playing([%PainGeneric])

func deathGeneric(): begin_playing([%EnemyDeath])

##Used during frenzygrowth's jab attacks
func impact():
	begin_playing([%Impact1,%Impact2,%Impact3,%Impact4])

##Used for Douser attacks and when Amphora explodes
func splash():
	begin_playing([%Splash])

func muckman(type : String):
	match type:
		"attack":
			begin_playing([%MuckHammer])
		"death":
			begin_playing([%MuckmanDeath])
		"activate":
			begin_playing([%MuckmanActivate])
		"pain":
			begin_playing([%MuckmanPain1,%MuckmanPain2,%MuckmanPain3,%MuckmanPain4])

func lurker(sound : String):
	match sound:
		"start": begin_playing([%LurkerStart])
		"leech": begin_playing([%LurkerLeech1,%LurkerLeech2,%LurkerLeech3,%LurkerLeech4])
		"pain": begin_playing([%LurkerPain])
		"cast": begin_playing([%LurkerCast1,%LurkerCast2,%LurkerCast3])
		"channel_start": begin_playing([%LurkerChannelLoop])
		"channel_stop": %LurkerChannelLoop.stop()
		"death": begin_playing([%LurkerDeath])

func LurkerGiggle():
	begin_playing([%LurkerGiggle])

func MuncherEat():
	begin_playing([%MuncherEat])

func fallOut():
	begin_playing([%Falling])

func PumpkinSplat():
	begin_playing([%PumpkinSplat])

## Abyss Presence
func abyss_presence(line : String):
	match line:
		"cast_divider": begin_playing([%LongTendrilSwipe])
		"cast_tendril": begin_playing([%ThreeTendrilSwipe])
		"war_cry": begin_playing([%AbyssalWarCry])
		"pain": begin_playing([%AbyssalPain1,%AbyssalPain2,%AbyssalPain3,%AbyssalPain4])
		"death": begin_playing([%AbyssalDeath])

## Legacy functions (still referenced)
func LongTendrilSwipe(): abyss_presence("cast_divider")

func ThreeTendrilSwipe(): abyss_presence("cast_tendril")

func AbyssalCry(): abyss_presence("war_cry")

func AbyssalPain(): abyss_presence("pain")

func AbyssalDeath(): abyss_presence("death")

## Amphora
func amphora(line : String):
	match line:
		"cast_1": begin_playing([%SndAmphora1])
		"cast_2": begin_playing([%SndAmphora2])
		"pain": begin_playing([%SndAmphoraPain])
		"death": begin_playing([%SndAmphoraDeath])

## Legacy functions (still referenced)
func Amphora1(): amphora("cast_1")

func Amphora2(): amphora("cast_2")

func AmphoraStun(): amphora("pain")

func AmphoraDeath(): amphora("death")

## Player / "The Vessel"
func player(line : String):
	match line: 
		"flash": begin_playing([%sfxPlayerFlash])
		"flash_fail": begin_playing([%FlashFail])
		"mote_collect": begin_playing([%FriendlyMoteMurmur]) ##was %sfxMoteCollect
		"mote_absorb": begin_playing([%MoteAbsorb])
		"heal": begin_playing([%sfxPlayerHeal])
		"pain": begin_playing([%sfxPlayerDamage])
		"empowered": begin_playing([%sfxPlayerEmpowered])
		"extinguish": begin_playing([%sfxPlayerExtinguished])
		"mote_bonus": begin_playing([%MoteBonus])

## Legacy functions (still referenced)
func PlayerFlash(): player("flash")

func FlashFail(): player("flash_fail")

func MoteCollect(): player("mote_collect")

func MoteAbsorb(): player("mote_absorb")

func PlayerHeal(): player("heal")

func PlayerDamaged(): player("pain")

func PlayerEmpowered(): player("empowered")

func PlayerExtinguished(): player("extinguished")

func mote_bonus(): player("mote_bonus")

## These are used broadly by objects and enemies (e.g Player, Potheads, Breakable Jars)
func VesselBreak():
	begin_playing([%CrackVariant1,%CrackVariant2,%CrackVariant3,%CrackVariant4,%CrackVariant5,%CrackVariant6])

func DoorOpen(sound : String, state : String):
		match sound:
			"abyss":
				if state == "open": begin_playing([%AbyssDoorClose])
				else: begin_playing([%AbyssDoorClose])
			"woods":
				if state == "open": begin_playing([%WoodsDoorOpen])
				else: begin_playing([%WoodsDoorOpen]) ## i know this seems redundant, but in the latter two cases we just found that the initial sounds sound better
			"town":
				if state == "open": begin_playing([%DoorTownOpen])
				else: begin_playing([%DoorTownClose])

func whoosh(): begin_playing([%Whoosh])

func warp(): begin_playing([%Warp])

func warble(): begin_playing([%Warble])

func bell(): begin_playing([%Bell])

func glass_break(): begin_playing([%GlassBreak])

func samael(sound:String):
		match sound:
			"anger": begin_playing([%SamaelAnger])
			"incant_fire": begin_playing([%SamaelIncantFire])
			"incant_sphere": begin_playing([%SamaelIncantSphere])
			"incant_rocks": begin_playing([%SamaelIncantSpire])
			"stun": begin_playing([%SamaelStun1,%SamaelStun2,%SamaelStun3,%SamaelStun4])
			"victory": begin_playing([%SamaelVictory1,%SamaelVictory2,%SamaelVictory3,%SamaelVictory4])
			"ominous_laugh": begin_playing([%SamaelLaughOminous])
			"refusal": begin_playing([%SamaelRefusal])
			"parry": begin_playing([%SamaelReflect])
			"djinn_warcry": begin_playing([%DjinnWarcry])
			"djinn_charge": begin_playing([%DjinnCharge1,%DjinnCharge2])
			"djinn_confusion": begin_playing([%DjinnConfusion])
			"djinn_stun": begin_playing([%DjinnPain1,%DjinnPain2,%DjinnPain3,%DjinnPain4])

func djinn(type : String):
	match type:
		"warcry": samael("djinn_warcry")
		"charge": samael("djinn_charge")
		"confusion": samael("djinn_confusion")
		"stun": samael("djinn_stun")

func woosh_ascend(): begin_playing([%SamaelJump])

func impact_big(): begin_playing([%SamaelLand1,%SamaelLand2,%SamaelLand3,%SamaelLand4,%SamaelLand5])

func wood_break(): begin_playing([%PewBreak1,%PewBreak2,%PewBreak3,%PewBreak4])

func stone_break(): begin_playing([%SpellSpireEmerge])

func sanctuary_destroy():
		begin_playing([%SanctuaryFloorBreak])
		begin_playing([%SanctuaryCollapse])

func dark_sphere(): begin_playing([%CelestialSphere])

func frenzygrowth(sound : String):
		match sound:
			"roar": begin_playing([%FrenzygrowthRoar])
			"giggle": begin_playing([%FrenzygrowthGiggle1,%FrenzygrowthGiggle2,%FrenzygrowthGiggle3,%FrenzygrowthGiggle4])
			"swipe": begin_playing([%FrenzygrowthSwipe1,%FrenzygrowthSwipe2])
			"jab": begin_playing([%FrenzygrowthJab1,%FrenzygrowthJab2])
			"pain": begin_playing([%FrenzygrowthPain,%FrenzygrowthPain2,%FrenzygrowthPain3])
			"death": begin_playing([%FrenzygrowthDeath])
			"seed_spit": begin_playing([%FrenzygrowthSeedSpit])

##Legacy Function (still referenced)
func seed_spit(): frenzygrowth("seed_spit")

func fire(type : String):
		match type:
			"big": begin_playing([%FrenzygrowthFireBreath])
			"small": begin_playing([%FireSmall])

func undead_emerge(): begin_playing([%UndeadEmerge])

func pothead(sound : String):
		match sound:
			"snore": begin_playing([%PotheadSnore])
			"snore_stop": %PotheadSnore.stop() #this is fine, don't worry about it
			"death": begin_playing([%PotheadDeath])
			"pain": begin_playing([%PotheadPain1,%PotheadPain2,%PotheadPain3,%PotheadPain4])

func burnout(sound : String):
		match sound:
			"death": begin_playing([%BurnoutDeath])
			"pain": begin_playing([%BurnoutPain1,%BurnoutPain2,%BurnoutPain3,%BurnoutPain4])

func fire_crackle_loop(sound : String):
		match sound:
			"start": begin_playing([%FireCrackleLoop])
			"stop": %FireCrackleLoop.stop() #ditto

func explosion(): begin_playing([%CrematorExplosion1,%CrematorExplosion2,%CrematorExplosion3,%CrematorExplosion4,%CrematorExplosion5])

func ossuary(sound : String):
	match sound:
		"snore_start": begin_playing([%OssuarySnoreLoop])
		"snore_stop": %OssuarySnoreLoop.stop() #ditto
		"chase_start": begin_playing([%OssuaryChaseLoop])
		"chase_stop": %OssuaryChaseLoop.stop() #ditto
		"death":
			%OssuaryChaseLoop.stop()
			begin_playing([%OssuaryExplodeAdd])
		"pain": begin_playing([%OssuaryPain1,%OssuaryPain2,%OssuaryPain3])

func censer(sound : String):
	match sound:
		"warcry": begin_playing([%CenserWarcry])
		"swing": begin_playing([%CenserWarcry,%CenserSwing])
		"stun": begin_playing([%CenserPain,%CenserPain2,%CenserPain3,%CenserPain4])
		"death": begin_playing([%CenserDeath])


func blazing(sound : String):
	match sound:
		"warcry": begin_playing([%BlazingRoar])
		"stun": begin_playing([%BlazingPain1,%BlazingPain2,%BlazingPain3,%BlazingPain4])
		"empowered": begin_playing([%BlazingEmpoweredAdd])
		"death": begin_playing([%BlazingDeath])

func gazer(sound : String):
	match sound:
		"death": begin_playing([%GazerDeath])
		"stun": begin_playing([%GazerPain1,%GazerPain2,%GazerPain3,%GazerPain4])

func jawer(sound : String):
	match sound:
		"death": begin_playing([%JawerDeath])
		"disappear": begin_playing([%JawerFadeOut])
		"reappear": begin_playing([%JawerReappear])
		"warcry": begin_playing([%JawerLaughIntro])
		"laugh": begin_playing([%JawerLaughShort])
		"stun": begin_playing([%JawerPain1,%JawerPain2,%JawerPain3,%JawerPain4])

func upgrade(sound : String):
	match sound:
		"jari": begin_playing([%UpgradeJari])
		"sculptor": begin_playing([%UpgradeSculptor])
		"zn": begin_playing([%UpgradeZn])

func raven(sound : String):
	match sound:
		"alert": begin_playing([%RavenAlert])
		"death":begin_playing([%RavenDeath])
		"stun":begin_playing([%RavenPain])

func motebearer(sound : String):
	match sound:
		"dispel": begin_playing([%MotebearerDispel])
		"freeze": begin_playing([%MotebearerChillerCastFreeze])
		"reveal": begin_playing([%MotebearerShadeReveal])
		"dispel_no_cloth": begin_playing([%MotebearerDispelNoCloth])
		"cremator_dispel": begin_playing([%MotebearerCrematorDispelAdd])

## Legacy function
func cremator_dispel(): motebearer("cremator_dispel")

##Motemice (see below)
func motemouse(line : String):
	match line:
		"squeak": begin_playing([%MouseSqueak])
		"death": begin_playing([%MotemouseDeath])

func JariPurr(): begin_playing([%JariPurr])

func ChestOpen(): begin_playing([%ChestOpen])

func ZenithHmm(): begin_playing([%ZenithHmm])

func NadirSnort(): begin_playing([%NadirSnort])

func freeze(): begin_playing([%FreezeJingle])

func respawn(): begin_playing([%Respawn])

func enemy_slain(): begin_playing([%EnemySlain])

func wood_impact(): begin_playing([%HitWood1,%HitWood2,%HitWood3])

func rock_break(): begin_playing([%RockCrumble])

func explosion_pumpkin(): begin_playing([%ExplosionChunky])

func key_drop(): begin_playing([%KeyDrop])

func metal_impact(): begin_playing([%MetalHit1,%MetalHit2,%MetalHit3,%MetalHit4])

func shadow_snake(sound:String):
	match sound:
		"death": begin_playing([%ShadowSnakeDeath])
		"pain": begin_playing([%ShadowSnakePain1,%ShadowSnakePain2,%ShadowSnakePain3,%ShadowSnakePain4])
		"hiss": begin_playing([%ShadowSnakehiss])

func lenore(sound : String):
	match sound: 
		"war_cry": begin_playing([%LenoreWarcry])
		"pain": begin_playing([%LenorePain1,%LenorePain2,%LenorePain3,%LenorePain4])
		"place": begin_playing([%LenorePlace1,%LenorePlace2,%LenorePlace3,%LenorePlace4])
		"dig": begin_playing([%LenoreDig1,%LenoreDig2,%LenoreDig3])
		"slam": begin_playing([%LenorePrayerfulStrike1,%LenorePrayerfulStrike2,%LenorePrayerfulStrike3])
		"slap": begin_playing([%LenoreSlap1,%LenoreSlap2,%LenoreSlap3])
		"claw": begin_playing([%LenoreClaw1,%LenoreClaw2])
		"death": begin_playing([%LenoreDeath])
		"teddy": begin_playing([%Teddy])

func muncher(sound : String):
	match sound:
		"pain": begin_playing([%MotemuncherPain1,%MotemuncherPain2,%MotemuncherPain3,%MotemuncherPain4])
		"eat": begin_playing([%MuncherEat])
		"anger": begin_playing([%MotemuncherAnger1,%MotemuncherAnger2,%MotemuncherAnger3,%MotemuncherAnger4])
		"death": begin_playing([%MotemuncherDeath])

func mimic(sound : String):
	match sound:
		"pain": begin_playing([%MimicPain])
		"death": begin_playing([%MimicDeath])
		"bite": begin_playing([%MimicCrunch])

func vesselflower(sound : String):
	match sound:
		"flame_extinguish": begin_playing([%WispFlameExtinguish])
		"pain": itemGet("kindling") #placeholder
		"death": begin_playing([%VesselflowerDeath1,%VesselflowerDeath2,%VesselflowerDeath3])

func sinkhole(sound : String):
	match sound: 
		"pain": begin_playing([%SinkholePain1,%SinkholePain2,%SinkholePain3,%SinkholePain4])
		"death": begin_playing([%SinkholeDeath])

func ebon(sound : String):
	match sound:
		"charge": begin_playing([%EbonCharge])
		"fire": begin_playing([%EbonFire])
		"laugh": begin_playing([%EbonLaugh1,%EbonLaugh2,%EbonLaugh3,%EbonLaugh4])
		"pain": begin_playing([%EbonPain])
		"deflect": begin_playing([%EbonParry])

func maze_guardian(sound : String):
	match GameState.endless["theme"]:
		0: #Dawn
			match sound:
				"spawn": begin_playing([%EndlessDawnSpawn1,%EndlessDawnSpawn2,%EndlessDawnSpawn3,%EndlessDawnSpawn4])
				"pain": begin_playing([%EndlessDawnPain1,%EndlessDawnPain2,%EndlessDawnPain3])
				"death": begin_playing([%EndlessDawnDeath1,%EndlessDawnDeath2,%EndlessDawnDeath3,%EndlessDawnDeath4])
		1: #Dusk
			match sound:
				"spawn": begin_playing([%EndlessDuskSpawn1,%EndlessDuskSpawn2,%EndlessDuskSpawn3,%EndlessDuskSpawn4])
				"pain": begin_playing([%EndlessDuskPain1,%EndlessDuskPain2,%EndlessDuskPain3,%EndlessDuskPain4])
				"death": begin_playing([%EndlessDuskDeath1,%EndlessDuskDeath2,%EndlessDuskDeath3,%EndlessDuskDeath4])
		2: #Twilight
			match sound:
				"spawn": begin_playing([%EndlessTwilightSpawn1,%EndlessTwilightSpawn2,%EndlessTwilightSpawn3])
				"pain": begin_playing([%EndlessTwilightPain1,%EndlessTwilightPain2,%EndlessTwilightPain3])
				"death": begin_playing([%EndlessTwilightDeath1,%EndlessTwilightDeath2,%EndlessTwilightDeath3])
