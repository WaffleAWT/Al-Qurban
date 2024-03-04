extends Node3D

@onready var tree = preload("res://Assets/Models/Prefabs/World/Tree.glb")
@export var trees : Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for i in trees.get_children():
		var new_tree = tree.instantiate()
		get_tree().current_scene.add_child(new_tree)
		new_tree.global_position = i.global_position

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/game.tscn")

func stop_music() -> void:
	AudioManager.stop_music()

func start_music() -> void:
	AudioManager.play_music2()
