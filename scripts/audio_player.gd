extends Node

var jump_sound = preload("res://assets/audio/jump.wav")
var hurt_sound = preload("res://assets/audio/hurt.wav")

func play_sfx(sfx_name: String):
	var stream = null
	
	if sfx_name == 'hurt':
		stream = hurt_sound
	elif sfx_name == 'jump':
		stream = jump_sound
	else:
		print("Invalid sfx name")
		return

	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	
	asp.play()
	
	await asp.finished
	
	asp.queue_free()
