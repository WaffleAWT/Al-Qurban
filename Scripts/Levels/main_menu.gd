extends Control

#Refrences
@onready var story = preload("res://Scenes/Levels/story.tscn")
@onready var credits = preload("res://Scenes/Levels/credits.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AudioManager.stop_music()

func _on_start_button_up() -> void:
	get_tree().change_scene_to_packed(story)

func _on_credits_button_up() -> void:
	get_tree().change_scene_to_packed(credits)

func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_start_mouse_entered() -> void:
	AudioManager.play_sound(AudioManager.menu_sound)

func _on_credits_mouse_entered() -> void:
	AudioManager.play_sound(AudioManager.menu_sound)

func _on_quit_mouse_entered() -> void:
	AudioManager.play_sound(AudioManager.menu_sound)

func _on_start_pressed() -> void:
	AudioManager.play_sound(AudioManager.click)

func _on_credits_pressed() -> void:
	AudioManager.play_sound(AudioManager.click)

func _on_quit_pressed() -> void:
	AudioManager.play_sound(AudioManager.click)
