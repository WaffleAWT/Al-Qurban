extends Node

func frame_freeze(timescale, duration) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0
