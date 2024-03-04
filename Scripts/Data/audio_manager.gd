extends Node

#Loads
@onready var shotgun : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Shotgun.wav")
@onready var rifle : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Rifle.wav")
@onready var bazooka : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Bazooka.wav")
@onready var swoosh : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Swoosh.wav")
@onready var swoosh2 : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Swoosh2.wav")
@onready var swoosh3 : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Swoosh3.wav")
@onready var enemy_death : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Enemy Death.wav")
@onready var menu_sound : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Menu.wav")
@onready var click : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Click.wav")
@onready var eating : AudioStreamWAV = preload("res://Assets/Audio/Sounds/Eating.wav")

#Refrences
@onready var sound_players = $Sounds.get_children()

func play_music() -> void:
	stop_music2()
	stop_boss()
	$AudioStreamPlayer.playing = true

func play_music2() -> void:
	stop_music()
	stop_boss()
	$AudioStreamPlayer2.playing = true

func play_boss() -> void:
	stop_music()
	stop_music2()
	$AudioStreamPlayer3.playing = true

func stop_music() -> void:
	$AudioStreamPlayer.playing = false

func stop_music2() -> void:
	$AudioStreamPlayer2.playing = false

func stop_boss() -> void:
	$AudioStreamPlayer3.playing = false

func play_sound(sound) -> void:
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
