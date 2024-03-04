extends Node3D


func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/boss_level.tscn")

func play_swoosh() -> void:
	AudioManager.play_sound(AudioManager.swoosh)

func _ready() -> void:
	AudioManager.play_boss()
