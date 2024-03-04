extends Node2D

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
