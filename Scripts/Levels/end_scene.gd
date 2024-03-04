extends Node3D

func _ready() -> void:
	AudioManager.stop_boss()

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
