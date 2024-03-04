extends Node3D

#Refrences
@onready var story_2 = preload("res://Scenes/Levels/story2.tscn")
@onready var tree = preload("res://Assets/Models/Prefabs/World/Tree.glb")
@export var trees : Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	AudioManager.stop_music2()
	get_tree().create_timer(1.0).timeout.connect(play_music)
	
	for i in trees.get_children():
		var new_tree = tree.instantiate()
		get_tree().current_scene.add_child(new_tree)
		new_tree.global_position = i.global_position

func play_music() -> void:
	AudioManager.play_music()

func next_scene() -> void:
	get_tree().change_scene_to_packed(story_2)

func play_swoosh() -> void:
	AudioManager.play_sound(AudioManager.swoosh)
