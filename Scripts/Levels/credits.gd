extends Control

@onready var tree = preload("res://Assets/Models/Prefabs/World/Tree.glb")
@export var trees : Node3D

func change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _input(event : InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			change_scene()

func _ready() -> void:
	for i in trees.get_children():
		var new_tree = tree.instantiate()
		get_tree().current_scene.add_child(new_tree)
		new_tree.global_position = i.global_position
