extends AudioStreamPlayer3D

@onready var sound1: AudioStreamWAV = preload("res://sounds/footsteps_gravel1.wav") as AudioStreamWAV
@onready var sound2: AudioStreamWAV = preload("res://sounds/footsteps_gravel2.wav") as AudioStreamWAV

func play_random_sound() -> void:
	stream = sound1 if randi_range(0, 1) == 0 else sound2
	play()
