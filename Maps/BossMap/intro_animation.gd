extends Node3D
class_name IntroAnimation

var player : CharacterBody3D
var boss : CharacterBody3D
var camera : Camera3D
var hud : HUD



func setup(player : CharacterBody3D, camera : Camera3D, hud : HUD) -> void:
	self.player = player
	self.boss = boss
	self.camera = camera
	self.hud = hud

func set_boss(boss : CharacterBody3D) -> void:
	self.boss = boss

func play() -> void:

	player.set_pause(true)
	## this should pause time damage, status effects  and disable inputs
	boss.set_pause(true)
	## this should be in enemy base maybe? should just pause the state machine and timers?


	## camera. zoom in and track the boss
	camera.start_cinematic(boss)
	## at the same time show letter box and hide the hud
	hud.show_boss_intro_hud(boss.name)

	# You might want to add a timer or animation to fade out the boss name after a duration
	await get_tree().create_timer(3.0).timeout
	# hud.boss_name.fade_out()
	camera.end_cinematic()

	# animation.play()

	## once done
	hud.hide_boss_intro_hud()
	## AFTER ALL the above is done and camera is done lerping
	player.set_pause(false)
	boss.set_pause(false)
